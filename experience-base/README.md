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
