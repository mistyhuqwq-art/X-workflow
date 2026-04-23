# Examples —— workflow-dlc 示例项目

> 2 个完整虚拟项目,用于体验 workflow-dlc 的真实工作流。

## 示例清单

| 项目 | 角色场景 | 验证的 skill |
|---|---|---|
| `task-dashboard/` | **前端·联调** | workflow-start + frontend-integration |
| `member-growth/` | **PM·需求产出** | workflow-start + pm-requirement + socratic-dialogue |

## 如何体验

### 方式一:快速体验(推荐)

```bash
# 1. 复制示例到临时目录
cp -r examples/task-dashboard /tmp/

# 2. 进入项目
cd /tmp/task-dashboard

# 3. git init(示例没带 .git,避免嵌套)
git init -q && git add . && git commit -qm "init example"

# 4. 打开 Claude Code
claude

# 5. 在 Claude Code 里输入
/workflow-start
```

**预期结果**:系统会读项目文件,声明 "前端·联调" 场景,给你一键确认。

### 方式二:深度体验(完整流程)

跑 `member-growth` 项目,体验完整 PM 需求产出流程:

```bash
cp -r examples/member-growth /tmp/
cd /tmp/member-growth
git init -q && git add . && git commit -qm "init"
claude

# 然后在 Claude Code 里:
/workflow-start
# 按引导走完 pm-requirement 的 4 个 Phase
```

**预期结果**:Phase 0 物料准备会拦下你(故意设计的),让你体验门禁机制。

## 示例的设计意图

### task-dashboard 的埋点(刻意放 bug)

在 `src/` 里埋了 3 个典型 bug(符合 frontend.md 教训 #1-3):

1. **taskId 类型不对**:前端 number,后端(假设)string
2. **extConfig 未 parse**:当成对象访问,会 undefined
3. **err.message 被吞**:catch 写死"提交失败"

走 `frontend-integration` skill 时,Phase 1 产出的字段映射表会**自动识别这 3 个问题**。

### member-growth 的埋点(物料不齐)

故意让:
- 物料 1(竞品截图)完全缺失
- 物料 2(数据)口径混乱
- 物料 3(继承清单)OK

走 `pm-requirement` skill 时,Phase 0 门禁会**拦下你**,触发补料子流程。

## 体验后清理

```bash
rm -rf /tmp/task-dashboard /tmp/member-growth
```

## 从示例学到什么

1. **项目结构最佳实践**:CLAUDE.md + knowledge-base/ + tasks/todo.md 是 workflow-dlc 起作用的前提
2. **门禁机制如何拦下问题**:物料不齐、接口没对齐等场景被提前拦住
3. **Skill 之间的路由**:workflow-start → 环节 skill → 下一步 skill 的衔接
