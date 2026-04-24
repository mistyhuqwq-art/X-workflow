#!/bin/bash
# 分析 token-log.jsonl,按 skill 聚合 token 消耗。
#
# 用法:
#   ./analyze-tokens.sh                          # 总览
#   ./analyze-tokens.sh by-skill                 # 按 skill 分组(所有 session)
#   ./analyze-tokens.sh by-skill --clean         # 按 skill 分组(剔除 "首轮全量" 脏数据)
#   ./analyze-tokens.sh by-session               # 按 session 分组
#   ./analyze-tokens.sh cost                     # 按 ppio 定价估算 $
#   ./analyze-tokens.sh cost --clean             # 同上,剔除脏数据
#   ./analyze-tokens.sh filter <session_id>      # 只看单个 session(跨 session 隔离)
#   ./analyze-tokens.sh skills                   # 列出日志里出现过的所有 skill
#
# 时间切片(任意模式可叠加):
#   --since 7d / 30d / 24h / 1h                  # 只看最近 N 天/小时
#   示例:
#     ./analyze-tokens.sh by-skill --since 7d              # 近 7 天按 skill
#     ./analyze-tokens.sh by-skill --clean --since 30d     # 近 30 天且去脏
#     ./analyze-tokens.sh cost --since 24h                 # 近 24 小时成本
#
# 脏数据说明:
#   hook 首次在某 session 触发时,state 文件不存在,delta 等于整个 session 的累计量,
#   不代表这一轮新产生的 token。--clean 模式会剔除每个 session 的首条记录。

set -uo pipefail

# 日志位置:优先用 env var,其次用脚本所在目录的 raw/,最后 fallback 到用户级位置。
# 这样 analyze-tokens.sh 跟着 experience-base 走到哪都能用。
script_dir="$(cd "$(dirname "$0")" && pwd)"
log="${WORKFLOW_DLC_LOG_DIR:-${script_dir}/raw}/token-log.jsonl"

if [ ! -f "$log" ]; then
  echo "No log yet: $log"
  exit 0
fi

mode="${1:-summary}"

# ── 解析所有可选 flag(--clean / --since 7d / <session_id>) ──
clean_mode=false
since_spec=""
positional_arg=""
shift || true  # 吃掉 mode
while [ $# -gt 0 ]; do
  case "$1" in
    --clean) clean_mode=true; shift ;;
    --since) since_spec="$2"; shift 2 ;;
    *) positional_arg="$1"; shift ;;
  esac
done

# ── --since 7d → 算截止时间戳(epoch 秒) ──
# BSD date(macOS)要求大写单位: H(hour) M(minute) d(day);小写 m 表示 month、h 非法。
# 策略:不靠 date -v,直接用"now - seconds"算,跨平台安全。
since_epoch=0
if [ -n "$since_spec" ]; then
  num="${since_spec%[dhmDHM]*}"
  unit="${since_spec: -1}"
  case "$unit" in
    d|D) seconds=$((num * 86400)) ;;
    h|H) seconds=$((num * 3600)) ;;
    m|M) seconds=$((num * 60)) ;;
    *) echo "Invalid --since: use 7d / 24h / 30m (got: $since_spec)"; exit 1 ;;
  esac
  now_epoch=$(date +%s)
  since_epoch=$((now_epoch - seconds))
fi

# ── 数据取出:可组合 --clean + --since ──
# 时间戳格式兼容:旧日志是 "...Z"(UTC),新日志是 "...+0800"(本地+时区)。
# jq 的 fromdateiso8601 只认 Z,所以先用 sub 规范化再转。
get_data() {
  local time_filter='.'
  if [ "$since_epoch" -gt 0 ]; then
    time_filter="select((.timestamp | sub(\"\\\\+\\\\d{4}$\"; \"Z\") | sub(\"-\\\\d{4}$\"; \"Z\") | fromdateiso8601) >= $since_epoch)"
  fi

  if [ "$clean_mode" = true ]; then
    jq -s --argjson since "$since_epoch" '
      def normts: sub("\\+\\d{4}$"; "Z") | sub("-\\d{4}$"; "Z");
      group_by(.session_id)
      | map(if length > 1 then .[1:] else [] end)
      | flatten
      | if $since > 0 then map(select((.timestamp | normts | fromdateiso8601) >= $since)) else . end
    ' "$log"
  else
    jq -s --argjson since "$since_epoch" '
      def normts: sub("\\+\\d{4}$"; "Z") | sub("-\\d{4}$"; "Z");
      if $since > 0 then map(select((.timestamp | normts | fromdateiso8601) >= $since)) else . end
    ' "$log"
  fi
}

# 兼容旧逻辑:一些 mode(filter, skills) 用 positional_arg
arg2="$positional_arg"

case "$mode" in
  summary)
    get_data | jq '
      {
        total_entries: length,
        distinct_skills: ([.[].skill] | unique | length),
        distinct_sessions: ([.[].session_id] | unique | length),
        total_input: (map(.turn_delta.input_tokens) | add // 0),
        total_output: (map(.turn_delta.output_tokens) | add // 0),
        total_cache_read: (map(.turn_delta.cache_read) | add // 0),
        total_cache_creation: (map(.turn_delta.cache_creation) | add // 0)
      }
    '
    ;;

  by-skill)
    get_data | jq '
      if length == 0 then [] else
        group_by(.skill)
        | map({
            skill: .[0].skill,
            turns: length,
            sessions: ([.[].session_id] | unique | length),
            input: (map(.turn_delta.input_tokens) | add),
            output: (map(.turn_delta.output_tokens) | add),
            cache_read: (map(.turn_delta.cache_read) | add),
            cache_creation: (map(.turn_delta.cache_creation) | add),
            avg_output_per_turn: ((map(.turn_delta.output_tokens) | add) / length | floor)
          })
        | sort_by(-.output)
      end
    '
    ;;

  by-session)
    get_data | jq '
      if length == 0 then [] else
        group_by(.session_id)
        | map({
            session_id: .[0].session_id,
            skill: .[0].skill,
            turns: length,
            output_total: (map(.turn_delta.output_tokens) | add)
          })
        | sort_by(-.output_total)
        | .[0:20]
      end
    '
    ;;

  cost)
    # ppio claude-opus-4-7 定价(官方公开价,按需调整)
    # input $15/M, output $75/M, cache_read $1.5/M, cache_creation $18.75/M
    get_data | jq '
      if length == 0 then [] else
        group_by(.skill)
        | map({
            skill: .[0].skill,
            turns: length,
            sessions: ([.[].session_id] | unique | length),
            input_usd: ((map(.turn_delta.input_tokens) | add) / 1000000 * 15),
            output_usd: ((map(.turn_delta.output_tokens) | add) / 1000000 * 75),
            cache_read_usd: ((map(.turn_delta.cache_read) | add) / 1000000 * 1.5),
            cache_creation_usd: ((map(.turn_delta.cache_creation) | add) / 1000000 * 18.75)
          })
        | map(. + {total_usd: (.input_usd + .output_usd + .cache_read_usd + .cache_creation_usd)})
        | map(. + {avg_usd_per_turn: (.total_usd / .turns)})
        | sort_by(-.total_usd)
      end
    '
    ;;

  filter)
    if [ -z "$arg2" ]; then
      echo "Usage: $0 filter <session_id>"
      exit 1
    fi
    jq -c --arg sid "$arg2" 'select(.session_id == $sid)' "$log" | jq -s '
      {
        session_id: (.[0].session_id // "not found"),
        skill: (.[0].skill // null),
        turns: length,
        timeline: map({ts:.timestamp, skill, output:.turn_delta.output_tokens}),
        total_output: (map(.turn_delta.output_tokens) | add // 0),
        total_cache_read: (map(.turn_delta.cache_read) | add // 0)
      }
    '
    ;;

  skills)
    jq -rs '[.[].skill] | unique | .[]' "$log"
    ;;

  *)
    echo "Usage: $0 [summary|by-skill|by-session|cost|filter|skills] [--clean|<session_id>]"
    exit 1
    ;;
esac
