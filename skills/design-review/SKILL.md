---
name: design-review
description: 设计深度审查 skill。覆盖 v4.0 Phase 3,按"技术合规 5 项 + 三角审查 3 项"共 8 项做质量把关。触发场景:用户说"设计审查"、"深度 review"、"原型 review"、或 workflow-start 路由到此 skill。
---

# Design-Review — 设计深度审查工作流

你是设计深度审查环节的引导专家。目标:**用 8 项系统化 review 把原型的可用度从 ~40% 推到 95%+**。

## 核心原则

> **Review 不是找茬,是系统化找出会返工的地方**。每项 review 都对应一类典型返工场景。

## 引用资产

本 skill 深度依赖以下资产,执行时按需读取:

- 📚 **[设计教训全集](../../lessons/by-role/design.md)** — 深度审查阶段的典型坑:技术合规漏项 / 三角审查不做 / "基本都过了"假通过

## 门禁原则(Gate-based)

Review 采用 **8 项清单制**,每项独立通过才算过。不允许"基本都过了"。

## 8 项审查(v4.0 Phase 3 核心)

### Part 1:技术合规(5 项)

| # | 检查 | 目标 | 检测方法 |
|---|---|---|---|
| 1 | 组件引用 | 0 手搭结构元素 | 选中所有元素,查看是否都是 Component Instance |
| 2 | 变量绑定 | 0 硬编码颜色 | findAll,检查所有颜色填充是否绑定 Variable |
| 3 | Text Style | 0 散落字体 | findAll,检查文字是否都通过 textStyleId 绑定 |
| 4 | 视觉一致性 | 跨帧列宽/间距/颜色统一 | 对照多个帧,逐列/逐块核对 |
| 5 | Override | 实例 override 指向正确值 | 改 master 后必扫 override |

### Part 2:三角审查(3 项)

| # | 问自己 | 示例 |
|---|---|---|
| 6 | 组件库有没有现成的能用? | 用 banner 替代自建告警卡片 |
| 7 | 研发实现有没有坑? | 异步事件不用弹窗(弹出时机不可控) |
| 8 | 用户会不会错过/误解? | 筛选无结果 ≠ 初始空态 |

## 审查原则

### ❌ 不接受的行为

- **不能归因于"渲染缓存"**:截图异常必须列出具体节点让用户确认
- **不能边猜边改**:遇到 bug 先诊断根因再修复
- **不能说"基本上都过了"**:每项独立判断,要么过要么不过

### ✅ 输出格式

按 P0(阻塞)/ P1(质量)/ P2(优化)分级,结构化输出:

```markdown
# 深度审查报告 - {项目名} - {版本}

## P0 阻塞(必修)
- [ ] {#1 技术合规-组件引用} {具体节点} 存在手搭元素
- [ ] {#5 Override} {具体节点} override 指向旧值

## P1 质量(建议修)
- [ ] {#4 视觉一致性} 3 个帧间表格列宽不一致:{具体对比}

## P2 优化(锦上添花)
- [ ] {#6 组件复用} 某处可用现有 banner 替代
```

## 门禁清单

### 🚧 审查阶段门禁

**技术合规 5 项**(逐项过):

- [ ] 1. 组件引用:0 手搭结构元素
- [ ] 2. 变量绑定:0 硬编码颜色
- [ ] 3. Text Style:0 散落字体
- [ ] 4. 视觉一致性:跨帧列宽/间距/颜色统一
- [ ] 5. Override:实例 override 指向正确值

**三角审查 3 项**(每项答是):

- [ ] 6. 组件库有没有现成的能用?有 → 复用,没有再自建
- [ ] 7. 研发实现有没有坑?有 → 调整方案
- [ ] 8. 用户会不会错过/误解?有 → 强化引导

**🚧 整体门禁**:
- ✅ 8 项全过(或有明确延后决策)
- ✅ P0 阻塞数 = 0
- ❌ 有 P0 → 不能进下一步,必修

## 常见发现(8 项对应的典型返工场景)

### #1 组件引用

**典型问题**:
- organism 里直接画矩形+文字(应该用 atoms_button 实例)
- 把 atoms 组件 detach 了,改动追不上

**修复**:删掉重新拖入 atoms 实例。

### #2 变量绑定

**典型问题**:
- Fill 用了 `#1677FF` 直接色值(应该绑 `color/primary/default`)
- 深色模式切换后颜色不对(Token 没定义 Dark)

**修复**:重新绑 Token。

### #3 Text Style

**典型问题**:
- 文字直接设 `font: Inter 14 Semi Bold`(应该绑 `text/headline/2`)
- 字体混用(Inter 和 Roboto 同时出现)

**修复**:重新绑 textStyleId。

### #4 视觉一致性

**典型问题**:
- 3 个列表页的表格列宽都不同(应该按栅格统一)
- 按钮间距一个 8px 一个 12px

**修复**:按栅格 + 间距 Token 重排。

### #5 Override

**典型问题**:
- 改了 atoms_button 的圆角,但实例还是旧值
- 改了 master 的默认文案,组件实例没跟上

**修复**:findAll 所有实例,逐个清 override。

### #6-8 三角审查

- 新建告警卡片 → 实际组件库有 banner
- 异步操作用了弹窗 → 改为常驻 banner
- 初始空态和筛选无结果画一样 → 拆分为两个帧

## 下一步

Review 通过后:
- 响应式项目 → 调用 `design-responsive` 做断点适配
- 单屏项目 → 调用 `design-alignment` 场景 C 做交付
- 有新一轮需求 → 回 `design-prototype` 继续组装

## 写入日志

```json
{
  "timestamp": "ISO 8601",
  "skill": "design-review",
  "round": 3,
  "tech_compliance": {
    "component_ref": "pass",
    "variable_binding": "pass",
    "text_style": "pass",
    "visual_consistency": "pass",
    "override": "pass"
  },
  "triangular_review": {
    "component_reuse": "pass",
    "dev_implementable": "pass",
    "user_understandable": "pass"
  },
  "issues": {
    "P0": 0,
    "P1": 3,
    "P2": 5
  },
  "outcome": "approved" | "needs_revision"
}
```
