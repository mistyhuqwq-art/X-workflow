# Sources —— workflow-dlc 持续迭代的根基

> **一句话**:workflow-dlc 的经验库不是死的,而是**活的** —— 两条引擎让它越用越准。

## 📚 文档索引

| 文件 | 作用 | 何时看 |
|---|---|---|
| `source-registry.md` | **外部资料源清单**(20 份权威资料) | 知道 workflow-dlc 依赖啥 / 更新资料时 |
| `source-skill-map.md` | **资料 ↔ skill 双向映射** | 改资料时 / 改 skill 时 |
| `sync-checker.md` | **自动同步检查脚本设计** | 设计定期同步机制 |
| `community-learning-design.md` | **用户经验回流机制设计** | 想让社区贡献经验时 |

## 🎯 三条核心机制

```
┌─────────────────────────────────────────────────────┐
│                  workflow-dlc                        │
│                  (28 skill + 教训库)                 │
└────────────────┬──────────────────┬─────────────────┘
                 │                  │
    ┌────────────┘                  └────────────┐
    │                                            │
    ▼                                            ▼
┌────────────────────┐              ┌────────────────────┐
│  上游资料同步        │              │  下游用户经验回流    │
│  (sync-checker)    │              │  (community-       │
│                    │              │   learning)        │
│                    │              │                    │
│  20 份飞书/本地资料  │              │  用户使用日志 +     │
│  → 定期 diff       │              │   GitHub Issue 反馈│
│  → 更新 skill      │              │  → 新教训          │
└────────────────────┘              └────────────────────┘
```

### 机制 1:上游资料源注册表

**为什么**:workflow-dlc 的方法论、教训、模板**全部来自外部资料**。外部变了 workflow-dlc 不跟 = 过时。

**做什么**:
- 记录 20 份核心资料的 URL / 版本 / 上次同步 / 影响 skill
- 定期(月度/季度)检查资料是否有更新
- 资料变了 → 更新对应 skill / 教训

**文档**:`source-registry.md`(清单)+ `source-skill-map.md`(映射)

### 机制 2:下游用户经验回流

**为什么**:workflow-dlc 装给 N 个用户,每个人会遇到 N 种场景。N×N 的经验如果回不来 = workflow-dlc 永远只是作者的视角。

**做什么**:
- P0:GitHub Issue 模板,用户主动分享经验
- P1:skill 内建 "/share-lesson" 命令,使用中随手分享
- P2+:后端服务 / 联邦学习(未来)

**文档**:`community-learning-design.md`

### 机制 3:自动同步检查(连接机制 1 和 2)

**为什么**:人工同步太麻烦,容易漏。

**做什么**:
- 定时用飞书 MCP 拉资料,diff 后产出报告
- 自动开 Issue 提醒维护者

**文档**:`sync-checker.md`

## 📊 资料依赖层级

```
P0 核心源(4 份)     → 变化直接影响多个 skill,月度检查
  ├── 通用 PRD 规范
  ├── MVP 社区项目分享
  ├── design-workflow-spec v4.0
  └── One Click Agent 设计

P1 实战源(6 份)     → 变化影响教训库,季度检查
  ├── 某 B 端中台项目 复盘
  ├── 某营销后台项目 复盘
  ├── SOP 手册
  └── 其他样例

P2 参考源(10 份)    → 偶尔参照,半年检查
  └── ...
```

详见 `source-registry.md`。

## 🚀 立即行动

workflow-dlc 上线后,本 sources/ 目录需要:

### 维护者日常
- [ ] 每月 1 号跑一遍 source-registry.md 的 P0 资料
- [ ] 每季度跑 P1 资料
- [ ] 半年跑 P2 资料
- [ ] 同步后更新 registry 的"上次同步"字段

### 社区贡献入口
- [ ] 配置 `.github/ISSUE_TEMPLATE/` 3 个模板(见 community-learning-design.md)
- [ ] README 首页加"贡献经验"入口
- [ ] 每月 merge 一次 community 贡献

### 自动化(可选)
- [ ] 实现 sync-check skill
- [ ] 配置 GitHub Actions 定期跑
- [ ] 飞书机器人通知

---

## ⚠️ 关键认知

**"资料源 = workflow-dlc 的生命线"**

- 不管资料 → workflow-dlc 一年后就是**化石**
- 不管用户经验 → workflow-dlc 永远是**一个人的作品**
- 两者都管 → workflow-dlc **真正成为活的协作平台**

这是 workflow-dlc 从"工具"升级到"社区"的临界条件。
