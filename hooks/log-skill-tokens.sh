#!/bin/bash
# Stop hook: 记录本轮 session 的 token 消耗 + 关联最近的 Skill 调用。
# 追加到 workflow-dlc-package/experience-base/raw/token-log.jsonl,便于按 skill 聚合分析。
#
# 设计:
#   - 失败静默,绝不阻塞主流程
#   - 只追加不改写,磁盘友好
#   - 从 transcript_path(JSONL)倒扫,抓最近一次 Skill tool_use 的 skill name
#   - 抓不到就标 "untracked"(非 skill 触发的普通会话)
#   - 每次 Stop 写一行,含本轮(自上次 Stop 以来)的 token 增量

set -uo pipefail

input=$(cat)

command -v jq >/dev/null 2>&1 || exit 0

transcript_path=$(echo "$input" | jq -r '.transcript_path // empty')
session_id=$(echo "$input" | jq -r '.session_id // empty')
cwd=$(echo "$input" | jq -r '.cwd // empty')

[ -z "$transcript_path" ] && exit 0
[ ! -f "$transcript_path" ] && exit 0

# ── 可配置路径(通过环境变量覆盖;方便部署到不同机器) ──
# WORKFLOW_DLC_LOG_DIR 指向 experience-base/raw/,默认跟随 ~/.claude/workflow-dlc-experience-base/raw/
# 自己装在项目 .claude 里的话可以 export WORKFLOW_DLC_LOG_DIR=/path/to/project/.claude/workflow-dlc-experience-base/raw
default_log_dir="${HOME}/.claude/workflow-dlc-experience-base/raw"
log_dir="${WORKFLOW_DLC_LOG_DIR:-$default_log_dir}"
log_file="${log_dir}/token-log.jsonl"
state_file="${HOME}/.claude/hooks/.token-log-state-${session_id}.json"

# ── 本 session 历史累计 tokens(从 JSONL 全量算,假设单调增长) ──
totals=$(jq -s '
  map(select(.message.usage))
  | {
      input_tokens: (map(.message.usage.input_tokens // 0) | add // 0),
      output_tokens: (map(.message.usage.output_tokens // 0) | add // 0),
      cache_creation: (map(.message.usage.cache_creation_input_tokens // 0) | add // 0),
      cache_read: (map(.message.usage.cache_read_input_tokens // 0) | add // 0),
      message_count: length
    }
' "$transcript_path" 2>/dev/null)

[ -z "$totals" ] && exit 0

# ── 读上次 state,算本轮增量 ──
if [ -f "$state_file" ]; then
  prev=$(cat "$state_file" 2>/dev/null)
else
  prev='{"input_tokens":0,"output_tokens":0,"cache_creation":0,"cache_read":0,"message_count":0}'
fi

# 负值保护:如果 cur < prev(state 丢失/session 重启/cache 清空),
# delta 可能为负,会污染统计。用 max(0, ...) 兜底。
delta=$(jq -n --argjson cur "$totals" --argjson prev "$prev" '
  def nonneg(x): if x < 0 then 0 else x end;
  {
    input_tokens: nonneg($cur.input_tokens - $prev.input_tokens),
    output_tokens: nonneg($cur.output_tokens - $prev.output_tokens),
    cache_creation: nonneg($cur.cache_creation - $prev.cache_creation),
    cache_read: nonneg($cur.cache_read - $prev.cache_read),
    message_count_delta: nonneg($cur.message_count - $prev.message_count)
  }
')

# ── 抓最近 Skill tool_use ──
# content 可能为 null(user/system/meta 消息),必须先 select type=array 再 iterate。
skill_name=$(jq -rs '
  [.[]
   | select(.message.content | type == "array")
   | select(.message.content | any(.type? == "tool_use" and .name? == "Skill"))]
  | if length > 0 then
      (last | .message.content | map(select(.type? == "tool_use" and .name? == "Skill"))[-1].input.skill)
    else "untracked" end
' "$transcript_path" 2>/dev/null)

[ -z "$skill_name" ] && skill_name="untracked"

# ── 抓模型(取最后一条 assistant 消息的 model) ──
model=$(jq -rs '
  map(select(.message.model)) | if length > 0 then last | .message.model else "unknown" end
' "$transcript_path" 2>/dev/null)

# ── 组装 log 行 ──
log_line=$(jq -nc \
  --arg ts "$(date +%Y-%m-%dT%H:%M:%S%z)" \
  --arg session_id "$session_id" \
  --arg skill "$skill_name" \
  --arg model "$model" \
  --arg cwd "$cwd" \
  --argjson delta "$delta" \
  --argjson cumulative "$totals" \
  '{
    timestamp: $ts,
    session_id: $session_id,
    skill: $skill,
    model: $model,
    cwd: $cwd,
    turn_delta: $delta,
    session_cumulative: $cumulative
  }')

# ── 写日志(append,创建目录失败就静默) ──
[ -d "$log_dir" ] || mkdir -p "$log_dir" 2>/dev/null || exit 0
echo "$log_line" >> "$log_file" 2>/dev/null || true

# ── 更新 state(为下次算增量) ──
echo "$totals" > "$state_file" 2>/dev/null || true

# ── 清理超过 30 天的 state 文件(session 已 stale) ──
find "$(dirname "$state_file")" -name '.token-log-state-*.json' -mtime +30 -delete 2>/dev/null || true

exit 0
