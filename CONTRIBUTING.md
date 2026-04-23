# 贡献指南

欢迎为 Workflow-DLC 贡献内容!本文说明如何新增 skill、修改教训库、修改模板,以及 PR 流程。

---

## 新增一个 Skill

### 1. 目录结构

```
skills/
└── {角色}-{环节}/         # 命名规范:小写,用连字符分隔
    └── SKILL.md           # skill 的完整定义(唯一必须文件)
```

例如:`skills/pm-requirement/SKILL.md`

### 2. SKILL.md 格式规范

每个 SKILL.md 必须包含以下结构,**顺序固定**:

```markdown
---
name: {skill 名称}
description: {一句话描述。格式:角色 + 场景 + 核心产出 + 触发场景}
---

# {Role}-{Env} — {中文标题}工作流

{一段话说清这个 skill 解决什么问题,给谁用。}

## 核心原则

> **引用块**:最重要的原则,配实际案例(不要写教条,要写"我们真的踩过这个坑")

## 引用资产

本 skill 深度依赖以下资产,执行时按需读取:

- 📚 **[教训名](../../lessons/by-role/{角色}.md)** — 用途说明
- 📋 **[模板名](../../templates/{模板}.md)** — 用途说明

## 门禁原则(Gate-based)

{说明 Phase 数量和整体结构。}

## Phase 0:{名称}

**🎯 目标**:{本 Phase 要达成什么}

{...内容...}

**🚧 Phase 0 门禁**:
- ✅ {通过条件}
- ❌ {不通过的典型情况}

## Phase 1:{名称}

{...重复...}

## 下一步

{完成后调用哪个 skill,或交付什么产物。}

## 写入日志

Skill 完成后写入 `experience-base/raw/` 对应日志。
```

### 3. description 字段规范

description 是 Claude Code 路由的关键信号,格式要求:

- **角色定语**:明确说"XX 角色"或"XX 环节"
- **核心产出**:一个动词短语("产出接口契约"/"引导 PM 从命题到 PRD")
- **触发场景**:以"触发场景:用户说 XX、XX、或 workflow-start 路由到此 skill"结尾

### 4. 新增后必做

- 在 `SKILL-INDEX.md` 对应角色表格里加一行
- 在 `README.md` 对应角色 skill 列表里加一行(带一句话描述)
- 在 `lessons/README.md` 确认是否需要新增角色教训文件

---

## 修改教训库

教训库位于 `lessons/by-role/` 目录。

### 文件结构

```
lessons/
├── README.md              # 所有文件索引
├── top-critical.md        # 跨角色最高优先级教训
└── by-role/
    ├── pm.md
    ├── frontend.md
    ├── backend.md
    ├── qa.md
    ├── design.md
    └── agent.md
```

### 教训格式规范

每条教训 = **一条可执行的规则**,格式如下:

```markdown
### 教训 N:{标题}

**触发场景**:{什么情况下会踩这个坑}

**规则**:做 X / 不做 Y(动词开头,一句话)

**案例**:{真实项目的具体例子,附代码片段或数字}

**反模式**:❌ {错误做法}
**正模式**:✅ {正确做法}
```

### 规范要求

- **不写流水账**:不要记录"今天我先做了 A 再做了 B"
- **写规则**:每条教训对应一条可复用的规则
- **去重**:新增前检查是否已有同类规则,有则合并更新
- **有案例**:每条教训必须配真实项目案例,不能只写理论
- `top-critical.md` 里的教训需要 **跨项目验证** 才能加入

---

## 修改模板

模板位于 `templates/` 目录。

```
templates/
├── prd-template.md             # PRD 18 章骨架
├── field-mapping-template.md   # 字段映射表
├── integration-checklist.md    # 联调验收 Checklist
└── retrospective-template.md   # 复盘报告模板
```

### 修改原则

- **向后兼容**:修改已有模板时,确认引用该模板的 skill 仍然适用
- **不破坏格式**:模板的标题层级结构是 skill 读取的锚点,不要随意增删 `##` 层级
- **注释变更**:在模板文件顶部 `<!-- changelog -->` 区域简要记录修改原因

---

## PR 流程

1. **Fork** 本仓库到你的账号
2. **新建分支**:命名规范 `feat/add-{skill名}` 或 `fix/lessons-{角色}` 或 `docs/templates-{模板名}`
3. **提交内容**:遵守上述格式规范,commit message 格式:
   ```
   feat(skills): 新增 {skill名} skill
   fix(lessons): 修正 {角色} 教训 N 的规则表述
   docs(templates): 更新 {模板名} 补充 XX 字段
   ```
4. **提交 PR**:
   - 标题:和 commit message 一致
   - 描述:说明新增/修改了什么,以及为什么(附真实案例更好)
   - 如果是新 skill,附上一次实际使用的截图或对话记录
5. **Review**:至少一位 reviewer 确认格式规范 + 内容质量
6. **Merge**:review 通过后由维护者 merge

---

## 快速检查清单

提交前自查:

- [ ] SKILL.md 包含所有必须章节(核心原则/引用资产/门禁原则/Phase/.../下一步/写入日志)
- [ ] description 符合格式规范
- [ ] SKILL-INDEX.md 已更新
- [ ] README.md 已更新
- [ ] 教训库新增的教训有真实案例,不是纯理论
- [ ] 模板修改向后兼容
