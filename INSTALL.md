# 安装指南

## 前置要求

- macOS / Linux
- [Claude Code](https://docs.claude.com/claude-code) 已安装
- 你的项目符合 [CLAUDE.md](https://github.com/) §5 结构(有 `knowledge-base/` + `tasks/todo.md` + `CLAUDE.md`)

## 安装方式

### 方式 1:用户级(所有项目可用,推荐)

```bash
# 1. 复制 skills 到用户级 skills 目录
cp -r workflow-dlc-package/skills/* ~/.claude/skills/

# 2. 复制经验库到用户级(可选,如果希望跨项目共享经验)
cp -r workflow-dlc-package/experience-base ~/.claude/workflow-dlc-experience-base

# 3. 复制模板和教训库(供 skill 引用)
cp -r workflow-dlc-package/templates ~/.claude/workflow-dlc-templates
cp -r workflow-dlc-package/lessons ~/.claude/workflow-dlc-lessons

# 4. 重启 Claude Code 或开新会话
```

### 方式 2:项目级(只在某个项目用)

```bash
cd /path/to/your-project

# 复制到项目的 .claude 目录
mkdir -p .claude/skills
cp -r /path/to/workflow-dlc-package/skills/* .claude/skills/

# 经验库放项目里(这样日志也在项目里)
cp -r /path/to/workflow-dlc-package/experience-base .claude/workflow-dlc-experience-base
```

## 验证安装

### 方式 A:快速验证(推荐)

打开任意项目的 Claude Code,输入:

```
/workflow-start
```

如果看到系统开始读项目文件并尝试判断角色,说明装成功。

### 方式 B:用示例项目

用 workflow-dlc-package/examples/ 里的示例:

```bash
1. cp -r examples/task-dashboard /tmp/
2. cd /tmp/task-dashboard && git init -q && git add . && git commit -qm "init"
3. 打开 Claude Code, /workflow-start
4. 应该看到:声明"前端·联调"场景,让你一键确认
```

如果没看到,说明装错了。常见问题:

| 现象 | 原因 | 解决 |
|---|---|---|
| /workflow-start 不识别 | skill 没装到 ~/.claude/skills/ | 重新执行 cp 命令 |
| 装了但不工作 | Claude Code 未重启 | 开新会话 |
| 读项目文件失败 | 项目没有 CLAUDE.md 和 tasks/todo.md | 按 workflow-dlc 约定初始化 |

## 使用示例

### 示例 1:高置信度场景

项目有 `package.json`(含 react)、`tasks/todo.md` 里"联调"进行中、git log 有 `fix(api)` 。

```
> /workflow-start

🎯 已为你定位当前工作场景:
  角色:前端工程师
  环节:联调(Phase 3)
  依据:
    - package.json 检测到 React 19 + Vite
    - tasks/todo.md 第 22 行"联调 TaskList 接口"进行中
    - git log 最近 3 条 commit 含 fix(api)

接下来调用 frontend-integration skill...
```

### 示例 2:中等置信度场景

```
> /workflow-start

🔍 根据项目信号,我倾向于认为你是「前端·编码」场景,但不完全确定。

[弹出 AskUserQuestion]
Q1: 你的角色?
  ○ 前端(Recommended)
  ○ 后端
  ○ PM
  ○ 设计师

Q2: 当前环节?
  ○ 编码(Recommended)
  ○ 技术方案
  ○ 联调
  ○ 复盘
```

## 卸载

```bash
# 用户级
rm -rf ~/.claude/skills/{workflow-start,frontend-coding,frontend-integration,frontend-retrospective}
rm -rf ~/.claude/workflow-dlc-experience-base
rm -rf ~/.claude/workflow-dlc-templates
rm -rf ~/.claude/workflow-dlc-lessons

# 项目级
rm -rf .claude/skills/{workflow-start,frontend-coding,frontend-integration,frontend-retrospective}
rm -rf .claude/workflow-dlc-experience-base
```

## 常见问题

### Q:可以只装某几个 skill 吗?

可以。比如你只做前端联调,可以只装:
```bash
cp -r workflow-dlc-package/skills/workflow-start ~/.claude/skills/
cp -r workflow-dlc-package/skills/frontend-integration ~/.claude/skills/
```

但建议至少装 `workflow-start`(入口),否则失去自动判断能力。

### Q:经验库写到哪儿?

默认写到 skill 所在目录的相对路径 `../../experience-base/raw/`。如果你装到用户级,日志会写到 `~/.claude/workflow-dlc-experience-base/raw/`。

### Q:能和现有的 skill 共存吗?

可以。所有 skill 名都带前缀(`workflow-start`、`frontend-*`),不会和别的 skill 冲突。

### Q:我是非前端角色,能用吗?

M1 阶段只做了前端闭环。PM / 设计师 / 后端 / QA / Agent 设计师的 skill 在 M2-M3 阶段发布。现在先用 `workflow-start` 定位,再手动说你的需求。

## 升级

```bash
cd /path/to/workflow-dlc-package
git pull    # 或者重新下载最新版本

# 覆盖安装
cp -r skills/* ~/.claude/skills/
```

经验库不会被覆盖(只覆盖 skills 定义,不碰 raw/patterns/rules 数据)。
