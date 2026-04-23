# Sync Checker —— 资料源自动检查脚本

> 用飞书 MCP 定期拉最新资料,和本地记录的版本 diff,自动提醒。

## 🎯 目标

让 workflow-dlc 维护者不必每月手动 check 20 份资料是否有更新,**用脚本 + AI 代劳**。

## 📐 架构

```
┌──────────────────────────────────────────────┐
│ 1. cron / 手动触发                            │
└───────────────────┬──────────────────────────┘
                    ↓
┌──────────────────────────────────────────────┐
│ 2. 读 source-registry.md,拿到 20 份资料清单    │
└───────────────────┬──────────────────────────┘
                    ↓
┌──────────────────────────────────────────────┐
│ 3. 飞书 MCP 拉最新内容 + 本地缓存版本 diff     │
└───────────────────┬──────────────────────────┘
                    ↓
┌──────────────────────────────────────────────┐
│ 4. 对每份有变化的:                             │
│    - AI 分析变化点                            │
│    - 查 source-skill-map.md 影响哪些 skill    │
│    - 产出变更报告                             │
└───────────────────┬──────────────────────────┘
                    ↓
┌──────────────────────────────────────────────┐
│ 5. 输出 sync-report-YYYY-MM-DD.md             │
│    + 自动开 GitHub Issue                      │
└──────────────────────────────────────────────┘
```

## 🚀 使用方式

### 方式 A:手动(当前可立即做)

直接在 Claude Code 里跑 `/sync-check`(需要先把它做成一个 skill):

```
/sync-check
```

Skill 会:
1. 读 `sources/source-registry.md`
2. 对每份 P0 资料,用飞书 MCP 拉当前内容
3. 对比 "上次同步" 字段,报告差异
4. 生成 `sources/sync-reports/sync-YYYY-MM-DD.md`

### 方式 B:定时(CronCreate)

首次装好 workflow-dlc 后,用 Claude Code 的 CronCreate 设置定时任务:

```
CronCreate(cron: "0 9 1 * *", prompt: "/sync-check")
# 每月 1 号早 9 点检查一次
```

### 方式 C:GitHub Actions(终极方案)

把 sync-check 逻辑改成命令行脚本,跑在 GitHub Actions 里:

```yaml
# .github/workflows/sync-check.yml
name: Source Sync Check
on:
  schedule:
    - cron: '0 1 1 * *'  # 每月 1 号
  workflow_dispatch:

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run sync check via Claude API
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
          FEISHU_APP_ID: ${{ secrets.FEISHU_APP_ID }}
          FEISHU_APP_SECRET: ${{ secrets.FEISHU_APP_SECRET }}
        run: node scripts/sync-check.js
      - name: Create Issue if changes found
        if: ${{ env.CHANGES_FOUND == 'true' }}
        uses: actions/github-script@v7
        with:
          script: |
            github.rest.issues.create({
              ...
            })
```

---

## 📋 Sync-Check Skill 设计(方案 A)

**位置**:`skills/sync-check/SKILL.md`(未来添加)

### Phase 0:读 registry

读取 `sources/source-registry.md`,提取 20 份资料的:
- 链接
- 类型(飞书 docx / wiki / 本地 MD)
- 上次同步日期
- 上次字符量

### Phase 1:拉最新内容

对每份 P0 资料:

```python
# 伪代码
for source in p0_sources:
    if source.type == "feishu-docx":
        current = feishu_mcp.fetch_doc(source.url, limit=1000)  # 只拉头部判断变化
    elif source.type == "feishu-wiki":
        current = feishu_mcp.fetch_doc(source.url, limit=1000)
    elif source.type == "local":
        current = read_file(source.path)

    # 保存到临时缓存
    cache_to_tmp(source.id, current)
```

### Phase 2:对比 diff

```python
for source in p0_sources:
    last_size = source.last_size
    current_size = get_current_size(source)

    diff_ratio = abs(current_size - last_size) / last_size

    if diff_ratio > 0.05:  # 变化 >5% 认为有实质改动
        source.status = "CHANGED"
    else:
        source.status = "UNCHANGED"
```

### Phase 3:AI 分析变化点

对变化的资料,让 AI 概括:

```
prompt: 这份文档和上次同步时相比,主要变化有哪些?
输出:
- 新增章节 X
- 删除章节 Y
- 修改规则 Z
```

### Phase 4:查影响

读 `sources/source-skill-map.md`,对每个变化点查"影响哪些 skill"。

### Phase 5:产出报告

输出 `sources/sync-reports/sync-YYYY-MM-DD.md`:

```markdown
# Sync Check Report - 2026-05-01

## 总览

- 检查资料数:20 份
- 有变化:3 份
- 无变化:17 份

## 变化详情

### 📕 通用 PRD 规范 v1.0 —— ⚠️ 有变化

**上次同步**:2026-04-23(54,346 字符)
**当前**:2026-05-01(57,892 字符,+6.5%)

**AI 分析的变化**:
- 新增"规范 7:数据契约版本管理"
- 修改 R3(前后端分离描述)措辞
- 新增附录 D:微前端场景的 PRD 特殊规则

**影响的 skill**:
- pm-requirement(Phase 2 R3 说明要更新)
- pm-review(R3 检查项)
- backend-interface(R3 前后端分离)
- templates/prd-template.md(新增规范 7 + 附录 D)

**建议动作**:
- [ ] 更新 templates/prd-template.md 同步规范 7
- [ ] 更新 pm-requirement Phase 2 的 R3 描述
- [ ] 回填到 source-registry.md 的"当前版本"字段

**自动创建的 Issue**: #XX

---

### 其他 2 份变化...

## 无变化清单(17 份)

- 某 B 端中台项目 全流程复盘(2026-04-23 同步,字符量一致)
- ...
```

### Phase 6:自动开 Issue

对每份变化,自动开一个 GitHub Issue 标记 `source-sync`:

```
Title: [Source Sync] 通用 PRD 规范 v1.0 有更新

Body:
见 sync-reports/sync-2026-05-01.md
影响 skill: pm-requirement / pm-review / backend-interface
建议动作: [见报告]
```

---

## 🎯 MVP 版本(先手动做一次)

先不做脚本,先手动跑一次验证流程:

```
# 在 Claude Code 里手动执行:
1. 用飞书 MCP 拉 通用 PRD 规范 v1.0 的当前内容
2. 对比 source-registry.md 记录的 54K 字符量
3. 如果有变化,用 AI 总结变化点
4. 手动更新 source-registry.md 的"上次同步"和"当前版本"
```

**首次执行建议时间**:本 workflow-dlc 上线后 1 个月。

---

## 🔒 敏感性说明

资料源拉取可能需要:
- 访问权限(如企业飞书 / Confluence / 内部系统)
- 对应 MCP 已配置(飞书 MCP / Notion MCP 等)

**外部用户无法运行特定维护者的 sync-check**(缺乏内部资料权限),只能依赖维护者定期同步后 push 到仓库。

**隐私原则**:
- sync-check 产出的变化报告可能含内部文档摘要 → 放私有位置
- 公开仓库只留**脚本设计**,不留真实同步结果
- 真实 registry/map 放私有位置(见 `source-registry.md` 本地化 SOP)

---

## 📊 与 community-learning 的关系

| 机制 | 方向 | 对象 |
|---|---|---|
| **sync-checker**(本文档) | 外部资料 → workflow-dlc | 维护者私有资料源 |
| **community-learning** | 用户使用 → workflow-dlc | 新教训 / 改进建议 |

两者合起来 = **workflow-dlc 的自我进化双引擎**:
- sync-checker 确保**上游资料**不过时
- community-learning 确保**下游经验**被吸收

---

## 🔗 相关文档

- `sources/source-registry.md`
- `sources/source-skill-map.md`
- `sources/community-learning-design.md`
