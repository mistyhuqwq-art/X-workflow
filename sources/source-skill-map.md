# Source ↔ Skill 映射表(方法论模板)

> 双向查表:**改一份资料 → 影响哪些 skill** / **改一个 skill → 需参考哪份资料**。
>
> ⚠️ 本文件是**方法论模板**。真实的映射表(含具体资料名/项目名)应放私有位置。

## 🎯 使用目的

- **改资料时**:知道要同步更新哪些 skill
- **改 skill 时**:知道核心方法论来自哪里
- **紧急变更时**:快速定位影响面

---

## 📊 典型资料类型 → Skill 影响模式

### 类型 1:PRD 规范类资料

| 更新类型 | 典型影响面 |
|---|---|
| PRD 章节结构变更 | pm-requirement, pm-review, pm-acceptance + PRD 模板 |
| 硬规则(如 R1-R6)变更 | 所有 pm-* 和 frontend-solution / backend-interface |
| 边界场景清单变更 | pm-* + frontend-solution + frontend-testing + qa-strategy |
| 状态机格式变更 | pm-requirement, design-alignment |
| 数值参数规范变更 | pm-requirement, frontend-solution |
| 验收标准格式(如 G-W-T)变更 | pm-acceptance, qa-strategy, qa-cases, frontend-testing |

### 类型 2:设计工作流规范

| 更新类型 | 典型影响面 |
|---|---|
| 需求对齐阶段变更 | design-alignment |
| Token 架构变更 | design-system |
| 帧覆盖清单变更 | design-prototype |
| 深度审查项变更 | design-review |
| 响应式规则变更 | design-responsive |
| 速查规律变更 | lessons/by-role/design.md |

### 类型 3:Agent 设计方法论

| 更新类型 | 典型影响面 |
|---|---|
| 交互模型变更 | agent-scenario |
| 上下文协议变更 | agent-scenario, agent-interaction |
| 确认链路变更 | agent-interaction |
| 日志结构变更 | agent-learning + workflow-dlc 自身 experience-base |
| 经验库架构变更 | agent-learning + workflow-dlc 自身架构 |
| 分期策略变更 | agent-phasing |

### 类型 4:项目实战复盘

| 更新类型 | 典型影响面 |
|---|---|
| 新增教训 Top N | lessons/top-critical.md + 对应角色 lessons/by-role/*.md |
| 测试分层实践变更 | frontend-testing, qa-strategy, qa-cases |
| AI 可用度数据变更 | frontend-retrospective, pm-retrospective 模板 |
| 踩坑案例变更 | 对应角色 lessons/by-role/xxx.md |

### 类型 5:SOP 手册

| 更新类型 | 典型影响面 |
|---|---|
| 需求产出 SOP 变更 | pm-requirement |
| 编码 SOP 变更 | frontend-coding, backend-coding |
| 联调 SOP 变更 | frontend-integration, backend-integration |
| 测试 SOP 变更 | qa-* |

---

## 🔄 Skill → 资料类型映射(通用版)

### PM Skills(4 个)

| Skill | 主要依赖类型 |
|---|---|
| pm-requirement | PRD 规范 / Agent 对话方法论 |
| pm-review | PRD 规范 / Review 节奏方法论 |
| pm-acceptance | PRD 规范(验收标准章节) |
| pm-retrospective | 项目复盘模板 |

### 前端 Skills(5 个)

| Skill | 主要依赖类型 |
|---|---|
| frontend-solution | 技术方案样例 / 前后端开发规范 |
| frontend-coding | 编码 SOP / 代码规范 |
| frontend-integration | 项目复盘(联调教训) / 联调 SOP |
| frontend-testing | 测试分层实践 |
| frontend-retrospective | 项目复盘模板 |

### 后端 Skills(4 个)

| Skill | 主要依赖类型 |
|---|---|
| backend-interface | 接口规范 / PRD 规范(前后端分离) |
| backend-coding | 后端开发规范 |
| backend-integration | 项目复盘(后端视角联调) |
| backend-retrospective | 后端复盘模板 |

### QA Skills(4 个)

| Skill | 主要依赖类型 |
|---|---|
| qa-strategy | 测试分层实践 / PRD 规范(边界场景) |
| qa-cases | 测试用例样例 / 自动化框架文档 |
| qa-execution | 提测 / bug 管理 SOP |
| qa-retrospective | QA 复盘模板 |

### 设计师 Skills(5 个)

| Skill | 主要依赖类型 |
|---|---|
| design-alignment | 设计工作流规范(Phase 0/4/6) / PRD 规范 |
| design-system | 设计工作流规范(Phase 1) / Design Token 规范 |
| design-prototype | 设计工作流规范(Phase 2) |
| design-review | 设计工作流规范(Phase 3) |
| design-responsive | 设计工作流规范(Phase 5) |

### Agent 设计师 Skills(4 个)

| Skill | 主要依赖类型 |
|---|---|
| agent-scenario | Agent 设计方法论(场景章节) |
| agent-interaction | Agent 设计方法论(交互章节) |
| agent-learning | Agent 设计方法论(学习循环章节) |
| agent-phasing | Agent 设计方法论(分期章节) |

### 跨角色 Skills(2 个)

| Skill | 主要依赖类型 |
|---|---|
| workflow-start | 所有 lessons/by-role + 28 skill 的 description |
| socratic-dialogue | Agent 对话方法论(三步对话法章节) |

---

## 🔍 影响面速查(通用模式)

### 改什么可能影响最大?

排名(改一下可能影响 5+ skill 的"高影响变更"):

| 变更类型 | 影响 skill 数 | 紧急同步? |
|---|---|---|
| **PRD 规范的硬规则**(如 R1-R6) | 12+ | ⚠️ 需要 |
| **边界场景清单** | 8+ | ⚠️ 需要 |
| **项目复盘的 Top 教训** | 7+ | ⚠️ 需要 |
| **测试分层架构** | 6+ | ⚠️ 需要 |
| **经验库架构** | 5+(包括 workflow-dlc 自身) | 🔴 立即 |
| **设计工作流 Phase 数量** | 5+(整个设计师 track) | ⚠️ 需要 |
| **Agent 方法论单章节** | 1-4 个 agent skill | 🟢 单系列 |

---

## 📝 维护原则

1. **每次更新 skill**:检查是否引入了新资料源,有 → 加到私有版 registry
2. **每次更新资料源**:检查本表模式,同步可能受影响的 skill
3. **每季度自检**:对照同步节奏,补上欠的同步

---

## 📂 本地化建议

和 `source-registry.md` 配对使用:

- **本文件**(公开):映射**模式和方法论**
- **私有版 source-skill-map-actual.md**:填具体资料名 + 具体 skill 对应关系

---

## 🔗 相关文档

- `sources/source-registry.md` —— 资料源清单模板
- `sources/sync-checker.md` —— 自动同步检查脚本设计
- `sources/community-learning-design.md` —— 用户经验回流机制
