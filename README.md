# Workflow-DLC

> **Workflow-DLC** (Workflow Development Life Cycle) —— 为 Claude Code 用户打造的**角色驱动 Skill 框架**,由 1 个入口 skill + 1 个通用对话 skill + 26 个角色环节 skill 组成,**共 28 个 Skill 协同工作**。
>
> 装到 `~/.claude/skills/` 即用,选角色 → 自动定位环节 → 引导完成工作。

## 🆔 术语说明

| 术语 | 含义 |
|---|---|
| **DLC**(本框架名) | 整个工作流体系,对标 AWS AI-DLC,提供"从需求到上线"的完整生命周期支持 |
| **Skill**(构成单元) | Claude Code 官方概念,每个 `SKILL.md` 文件 = 一个 Skill,可通过 `/skill-name` 调用 |
| **Phase**(执行阶段) | 每个 Skill 内部的 Phase 0 / Phase 1 / ... 流程阶段,有明确门禁 |

> 简单讲:**你装的是 28 个 Skill,它们共同构成 Workflow-DLC 框架**。

## 🚀 3 分钟快速开始

### 装上

```bash
# 1. Clone 到任意位置
git clone https://github.com/mistyhuqwq-art/X-workflow.git workflow-dlc

# 2. 把 skill 复制到 Claude Code 全局 skill 目录
cp -r workflow-dlc/skills/* ~/.claude/skills/

# 3. 完成!重开 Claude Code 会话即可看到 28 个 skill 可用
```

### 用起来

在**任意项目目录**打开 Claude Code,输入:

```
/workflow-start
```

系统会自动做完这些事:

1. 🔍 **读你的项目**(`CLAUDE.md` / `tasks/todo.md` / `src/` / git log 等)自动判断你是谁、在做什么
2. 💬 **声明判断 + 一键确认**("我判断是前端·联调,对吗?" 一键 Yes 或纠正)
3. 📋 **少量补问**必要信息(环境?接口文档?)
4. 🎯 **路由到对应 skill**,按 Phase 门禁引导你完成工作
5. 📝 **写原始层日志**,使用越多判断越准

### 适用场景

| 你是 | 你在做 | 调 workflow-start 会路由到 |
|---|---|---|
| PM | 写 PRD | `pm-requirement`(18 章骨架 + 三步对话法) |
| 前端 | 联调接口 | `frontend-integration`(字段映射表 + Top 5 教训) |
| 后端 | 设计接口 | `backend-interface`(陷阱字段标注 + 契约冻结) |
| QA | 写测试用例 | `qa-cases`(4 层分层 + Playwright 模板) |
| 设计师 | Figma 深度审查 | `design-review`(8 项审查) |
| Agent 设计师 | 规划 P0 | `agent-phasing`(MVP 最小可用版本) |
| 任何人 | 启动新任务 | `socratic-dialogue`(苏格拉底 + 第一性 + 奥卡姆) |

### 核心亮点

- ✅ **6 角色 × 28 skill** 全闭环覆盖,不是只给前端/PM
- 🚧 **门禁机制**:每个 Phase 有明确通过标准,不过闸不下一步,拒绝"差不多就行"
- 🤝 **用户确认权**:AI 永远给你纠正判断的机会,不搞"越自信越强迫"
- 🎁 **降级出路**:场景外不拒绝,给模板/跨角色 skill/飞书文档作替代
- 📊 **自我迭代**:三层经验库(原始→模式→规则),使用越多越准

### 详细安装和使用

见 [INSTALL.md](./INSTALL.md)。

---

## 这是什么

一套给 Claude Code 用户的 Skill 包。解决一个具体痛点:

> **你知道 AI 能干活,但不知道每一步该怎么让 AI 配合你最好。**

安装后,你在项目里调用 `/workflow-start`,系统会:
1. **读项目文件**,自动判断你的角色(PM/设计师/前端/后端/QA/Agent 设计师)和当前环节
2. **用 AskUserQuestion 补问**不确定的信息
3. **路由到对应环节 skill**,引导你完成该环节的工作(带教训、模板、checklist)
4. **写入经验库**,使用越多,后续判断越准

## 当前状态 🎉 全闭环完成(2026-04-23)

### 6 角色 × 28 skill 全支持

| 角色 | skill 数 | Skill(链接 + 一句话) |
|---|---|---|
| **PM** | 4 | [pm-requirement](skills/pm-requirement/SKILL.md):PRD 产出 4 Phase / [pm-review](skills/pm-review/SKILL.md):三端并行 review / [pm-acceptance](skills/pm-acceptance/SKILL.md):终审+功能验收双场景 / [pm-retrospective](skills/pm-retrospective/SKILL.md):流程/决策/协作复盘 |
| **前端** | 5 | [frontend-solution](skills/frontend-solution/SKILL.md):技术方案蓝图 / [frontend-coding](skills/frontend-coding/SKILL.md):AI Native 编码最佳实践 / [frontend-integration](skills/frontend-integration/SKILL.md):联调契约对齐+Top5教训 / [frontend-testing](skills/frontend-testing/SKILL.md):4层分层测试 / [frontend-retrospective](skills/frontend-retrospective/SKILL.md):代码/bug/AI使用复盘 |
| **后端** | 4 | [backend-interface](skills/backend-interface/SKILL.md):接口契约文档真相源 / [backend-coding](skills/backend-coding/SKILL.md):分层架构编码不漂移 / [backend-integration](skills/backend-integration/SKILL.md):配合前端联调快响应 / [backend-retrospective](skills/backend-retrospective/SKILL.md):接口/数据库/性能复盘 |
| **QA** | 4 | [qa-strategy](skills/qa-strategy/SKILL.md):4层分层测试策略设计 / [qa-cases](skills/qa-cases/SKILL.md):按层产出用例存用例库 / [qa-execution](skills/qa-execution/SKILL.md):提测冒烟+bug分级+回归 / [qa-retrospective](skills/qa-retrospective/SKILL.md):测试策略/自动化复盘 |
| **设计师** | 5 | [design-alignment](skills/design-alignment/SKILL.md):对齐+PRD验证+交付 / [design-system](skills/design-system/SKILL.md):Token三层架构设计系统 / [design-prototype](skills/design-prototype/SKILL.md):10类帧覆盖+组装红线 / [design-review](skills/design-review/SKILL.md):8项系统化深度审查 / [design-responsive](skills/design-responsive/SKILL.md):8条规则多断点适配 |
| **Agent 设计师** | 4 | [agent-scenario](skills/agent-scenario/SKILL.md):交互模型+场景+用户画像 / [agent-interaction](skills/agent-interaction/SKILL.md):三步确认链路设计 / [agent-learning](skills/agent-learning/SKILL.md):日志→AI汇总→学习循环 / [agent-phasing](skills/agent-phasing/SKILL.md):P0-P3分期规划 |
| **跨角色** | 2 | [workflow-start](skills/workflow-start/SKILL.md):自动判断角色环节并路由 / [socratic-dialogue](skills/socratic-dialogue/SKILL.md):三步对话法启动任何新任务 |

### 交付里程碑

| M | 范围 | 状态 |
|---|---|---|
| M1 | workflow-start + 前端 3 + socratic | ✅ |
| M2 | PM 4 + 前端补 2 | ✅ |
| M3 后端 + QA | 后端 4 + QA 4 | ✅ |
| M3 设计师 + Agent | 设计 5 + Agent 4 | ✅ |

⏳ 后续(可选):
- 真实项目验证
- 打包 release 到 `~/.claude/skills/`
- 使用经验迭代

## 快速开始

### 安装

见 [INSTALL.md](./INSTALL.md)。

### 使用

在任意符合标准结构的项目(有 `knowledge-base/` + `tasks/todo.md` + `CLAUDE.md`)里,打开 Claude Code:

```
/workflow-start
```

然后按提示选择/确认角色和环节,系统会路由到对应 skill。

## 设计理念

### 为什么是"角色驱动"

传统 workflow 工具(如 AWS AI-DLC)是**规则驱动 AI 编码**——给 AI 制定规则,让它按流程输出。

我们做的是**角色驱动人类工作流**——给人类一套 Skill 路由系统,让不同角色在不同环节都能快速接入最佳实践。

### 为什么要自动判断环节

每次都让用户回答"你是谁/你在做什么"累。更好的做法是:
- **项目结构会说话**:CLAUDE.md §5 强制的 `knowledge-base/` + `tasks/todo.md` 就是信号源
- **读文件成本 < 采访成本**:能从 `git log` 猜出来的事情不要让用户再说一遍
- **不确定才问**:置信度 <80% 才用 AskUserQuestion

### 三层经验库

每次使用都产生日志,越用越准:

```
原始层(使用日志) → 模式层(AI 汇总) → 规则层(人工确认,写回 skill)
```

## 目录结构

```
workflow-dlc-package/
├── skills/                       # 28 个 Skill
│   ├── workflow-start/           # 入口(自动判断+路由+28 skill 全支持)
│   ├── socratic-dialogue/        # 跨角色:三步对话法
│   │
│   ├── pm-requirement/           # PM·需求(物料+三步对话+18 章 PRD)
│   ├── pm-review/                # PM·评审(三端并行 + 5 轮迭代)
│   ├── pm-acceptance/            # PM·验收(终审 + 功能验收双场景)
│   ├── pm-retrospective/         # PM·复盘(流程/决策/协作)
│   │
│   ├── frontend-solution/        # 前端·技术方案
│   ├── frontend-coding/          # 前端·编码
│   ├── frontend-integration/     # 前端·联调(字段映射 + 教训 Top 5)
│   ├── frontend-testing/         # 前端·测试(4 层分层)
│   ├── frontend-retrospective/   # 前端·复盘
│   │
│   ├── backend-interface/        # 后端·接口设计(陷阱字段标注)
│   ├── backend-coding/           # 后端·编码(分层架构)
│   ├── backend-integration/      # 后端·联调(响应式配合前端)
│   ├── backend-retrospective/    # 后端·复盘
│   │
│   ├── qa-strategy/              # QA·策略(4 层分层)
│   ├── qa-cases/                 # QA·用例(按层产出)
│   ├── qa-execution/             # QA·执行(提测冒烟 + bug 分级)
│   ├── qa-retrospective/         # QA·复盘
│   │
│   ├── design-alignment/         # 设计·对齐(v4.0 Phase 0/4/6 合并)
│   ├── design-system/            # 设计·系统(Token 三层架构)
│   ├── design-prototype/         # 设计·原型(10 类帧 + 组装红线)
│   ├── design-review/            # 设计·审查(8 项深度审查)
│   ├── design-responsive/        # 设计·响应式(8 条规则)
│   │
│   ├── agent-scenario/           # Agent·场景(交互模型 + PageContext)
│   ├── agent-interaction/        # Agent·交互(三步确认链路)
│   ├── agent-learning/           # Agent·学习(日志 + 三层经验库)
│   └── agent-phasing/            # Agent·分期(P0-P3 规划)
├── templates/                 # 产出物模板
├── lessons/                   # 教训库(按角色/环节)
├── experience-base/           # 三层经验库
│   ├── raw/                   # 原始使用日志
│   ├── patterns/              # AI 汇总规律
│   └── rules/                 # 人工确认后的规则
└── examples/                  # 示例项目(待填充)
```

## 资料源

- 设计师工作流:`design-workflow-spec v4.0`
- Agent 设计方法论:One Click 国际化 CMS Agent
- 前端 SOP:《AI Native 开发实践》
- 项目复盘:某 B 端中台 V1 项目、某营销后台项目

详见 `knowledge-base/workflow-dlc/asset-inventory.md`(在 docs 项目根下)

## 反馈 / 迭代

使用过程中产生的日志在 `experience-base/raw/`。如果有被误判、漏问、流程不顺的地方,记录下来,每双周 AI 汇总 → 人工确认 → 回写到 skill。

## License

[MIT](./LICENSE) © 2026 workflow-dlc contributors
