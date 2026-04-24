# 三层经验库

基于 One Click Agent 设计的三层架构,支持 workflow-dlc 自我迭代。

## 三层结构

| 层次 | 位置 | 内容 | 谁写 |
|---|---|---|---|
| **原始层** Raw | `raw/` | 每次 skill 使用的日志 | Skill 自动写入 |
| **模式层** Patterns | `patterns/` | AI 汇总发现的规律 | AI 定期清洗 |
| **规则层** Rules | `rules/` | 人工确认后的规则 | 人工审核后写入 |

## 流转规则

```
raw/ ──AI 清洗(双周)──→ patterns/ ──人工确认(月度)──→ rules/ ──→ 反哺 skill
```

**只能向上流动,不能跳级**。AI 不能从原始日志直接改 skill 规则。

## 成本模式(Cost Pattern) —— DLC 自我观测闭环

这是 workflow-dlc 的**第 4 类经验**(前 3 类是教训/模式/规则),专门用来回答:**这个 skill 花了多少 token?值不值?该怎么优化?**

### 数据从哪来

`raw/token-log.jsonl` — 全局 Stop hook 自动追加,每轮对话结束写一行。

**采集机制**:`hooks/log-skill-tokens.sh`(项目根部 `hooks/`,或用户级 `~/.claude/hooks/`)
- 从当前 session JSONL 倒扫最近的 `Skill` tool_use,关联 skill name(零侵入,不改任何 SKILL.md)
- 计算本轮(自上次 Stop 以来)的 token 增量,防负值兜底
- 失败静默,不阻塞 Claude 主流程

**日志行结构**:
```json
{
  "timestamp": "2026-04-24T01:59:43+0800",
  "session_id": "1c81b800-...",
  "skill": "pm-retrospective | editorial-page | untracked",
  "model": "pa/claude-opus-4-7",
  "turn_delta": {"input_tokens": ..., "output_tokens": ..., "cache_read": ..., "cache_creation": ...},
  "session_cumulative": { ... }
}
```

### 三层流转(和其他经验层一致)

```
raw/token-log.jsonl ──raw-to-patterns.sh──→ patterns/pattern-token-{skill}.md
                                                      │
                                                      ├─ 人工审核(样本 >= 10 + P50/P90 稳定)
                                                      ↓
                                             rules/rule-token-{skill}.md
                                                      │
                                                      ├─ 反哺
                                                      ↓
                              SKILL.md 末尾 <!-- budget: p50=..., p90=... -->
```

### 日常查询(临时视角,不产出资产)

```bash
./analyze-tokens.sh by-skill --clean           # 按 skill 聚合
./analyze-tokens.sh by-skill --clean --since 7d # 近 7 天
./analyze-tokens.sh cost --clean --since 30d   # 按 ppio 定价估算 $
./analyze-tokens.sh filter <session_id>        # 单 session 隔离分析
```

### 产出成本模式(资产视角,升级到 patterns/)

```bash
./raw-to-patterns.sh                  # 所有样本 >= 3 的 skill
./raw-to-patterns.sh --min 5          # 自定义门槛
./raw-to-patterns.sh --skill foo      # 只跑单个 skill
```

产出 `patterns/pattern-token-{skill}-{date}.md`,含:
- P50/P90/P99 output token 分位数(skill 工作量分布)
- 总成本($)
- 异常点(超 P90 的 run,提示检查 skill 是否失控)
- 建议 budget(人工审核时的参考值)

### 为什么这是 DLC 的"自我观测闭环"

- **当前状态**:每个 skill 的成本靠感觉("这次好像有点贵?")
- **经 token 工具后**:skill 的 P50/P90 是个数字,优化前后能对比
- **经 pattern 升级后**:skill 自己的 budget 有依据地写进 SKILL.md
- **长期**:skill 执行时能自检 budget 异常,DLC 从"他人观察"进化成"自我观察"

这个链路是 workflow-dlc 区别于"一堆静态 skill 包"的关键 —— 它有**自己的 metrics + 自己的 ceiling**。

---

## 原始层日志格式

文件名:`YYYY-MM-DD-HHmmss-{session_id}.json`

```json
{
  "timestamp": "2026-04-23T16:30:00+08:00",
  "skill": "workflow-start",
  "project_path": "/Users/x/Projects/xxx",
  "signals": {
    "files": ["src/App.tsx", "package.json", "e2e/"],
    "todo_active": ["联调 TaskList 接口"],
    "git_recent": ["fix(api): batchId type", "feat(frontend): TaskList"],
    "mcps": ["figma", "playwright"]
  },
  "candidates": {
    "roles": [{"role": "前端", "score": 13}],
    "phases": [{"phase": "联调", "score": 10}]
  },
  "confidence": 0.92,
  "user_confirmed": {"role": "前端", "phase": "联调"},
  "user_overrode": false,
  "routed_skill": "frontend-integration",
  "interview": {
    "api_doc": "feishu",
    "env": "staging_cookie",
    "field_mapping_done": false
  },
  "outcome": "pending"
}
```

Skill 执行完成后,追加 outcome 字段:

```json
{
  ...,
  "outcome": "success",
  "completed_at": "2026-04-23T18:45:00+08:00",
  "bugs_found": 3,
  "lessons_added": ["backend JSON field 需 parse"]
}
```

## 模式层文件格式

AI 汇总后产出,文件名:`pattern-{category}-{date}.md`

```markdown
---
name: {模式名}
status: pending_review | approved | rejected
confidence: 0.75
based_on: [raw log files]
---

## 模式

{AI 发现的规律描述}

## 数据支撑

{哪些日志导出这个规律}

## 建议升级为规则?

{是否建议写入 rules/}
```

## 规则层文件格式

经人工确认后,文件名:`rule-{category}-{name}.md`

```markdown
---
name: {规则名}
category: role:前端 / phase:联调
severity: P0 | P1 | P2
approved_by: user
approved_at: ISO 8601
source_pattern: {pattern file}
---

## 规则

{一句话规则}

## 触发场景

{何时应用}

## 怎么做

{具体指引}

## 反例

{不这么做的后果}
```

## 迭代节奏

| 节奏 | 动作 | 谁做 |
|---|---|---|
| 每次使用 | 写入 `raw/` | Skill(自动) |
| 双周 | 汇总 raw → 产出 patterns | AI(可通过 cron 调度) |
| 月度 | 审核 patterns → 批准写入 rules | 人工 |
| 季度 | rules 复核,3 个月未命中标记待复核 | 人工 |

## 与 lessons/ 的关系

- `lessons/` 是**打包好的教训库**(skill 发布时内置的内容)
- `experience-base/rules/` 是**使用中新沉淀的规则**

每次发版时,把 `rules/` 里成熟的规则合并到 `lessons/`,然后清空 `rules/`。

## 隐私

- `raw/` 日志包含项目路径、git 记录、采访内容
- **不建议**共享到公开仓库(可能含敏感项目信息)
- 建议:`.gitignore` 里加 `experience-base/raw/`,只提交 patterns/ 和 rules/
