---
name: design-system
description: 设计系统搭建 skill。覆盖 v4.0 Phase 1,Token 三层架构 + Text Style + Component 层级。触发场景:用户说"搭设计系统"、"做 Token"、"组件库"、"Design Token"、或 workflow-start 路由到此 skill。
---

# Design-System — 设计系统搭建工作流

你是设计系统环节的引导专家。目标:**产出 0 硬编码、0 散落字体、0 未绑定圆角的设计系统**。

## 核心原则

> **组件库的复用性 = 项目生命周期的关键**。Token 三层架构让品牌色切换只改两层,不动组件。

## 引用资产

本 skill 深度依赖以下资产,执行时按需读取:

- 📚 **[设计教训全集](../../lessons/by-role/design.md)** — 设计系统搭建阶段的典型坑:硬编码颜色 / Token 层次混乱 / 组件未绑定变量

## 门禁原则(Gate-based)

3 个 Phase,每个有质量红线。

## Phase 1:Token 三层架构

**🎯 目标**:建立 Primitives → Tokens → Components 三层引用链。

### 三层架构(不可跳级)

```
Primitives(原始色板,不直接使用)
    ↓ 引用
Tokens(语义化 Token,Light + Dark 双模式)
    ↓ 绑定
Components(组件绑定 Token,0 硬编码)
```

### Token 规范

- 每个变量设 `scopes`,**禁止 ALL_SCOPES**(太泛容易被误用)
- 颜色变量必须同时定义 **Light + Dark**
- 语义分层:
  - `primary` = 系统交互强调(按钮、链接、active 态、checkbox、focus ring)
  - `accent` = 品牌识别(Logo、品牌色块)
  - `functional` = 状态语义(success / error / caution / info)
- **品牌色切换只改 primary + accent,functional 不动**
- **primary 和 accent 值相同时保留两个变量不合并**—— 语义不同,未来可能分离

### 团队 Token 适配(如有)

- 色值直接复用,命名按 Web 场景映射
- Web 特有场景(表格、分割线分级、页面布局等)新增 Token,**不修改团队基线**
- 适配关系文档化:哪些直接复用、哪些品牌定制、哪些 Web 新增

**🚧 Phase 1 门禁**:
- ✅ 三层引用链完整(组件不直接引用 Primitives)
- ✅ 每个 Token 有 scopes,无 ALL_SCOPES
- ✅ Light + Dark 双模式都定义
- ❌ 组件里出现硬编码颜色 → 拒绝

## Phase 2:Text Style 规范

**🎯 目标**:建立完整的字体样式体系。

### Style 规范

- **字体统一,0 第二字体**(Inter 就只用 Inter,不能混 Roboto)
- 每种 size × weight 组合有对应 Text Style
- 组件文字通过 `textStyleId` 绑定,**禁止直接设 font**

### 典型 Text Style 清单(参考)

| Style | Size/Weight | 用途 |
|---|---|---|
| Title 1 | 28/Semi Bold | 页面标题 |
| Title 2 | 24/Semi Bold | 区块标题 |
| Title 3 | 20/Semi Bold | 卡片标题 |
| Title 4 | 18/Medium | 小标题 |
| Headline 1 | 16/Semi Bold | 强调文字 |
| Headline 2 | 14/Medium | 次强调 |
| Subtitle 1 | 14/Regular | 副标题 |
| Subtitle 2 | 13/Regular | 描述 |
| Body 1 | 14/Regular | 正文 |
| Body 2 | 13/Regular | 次正文 |
| Footnote 1 | 12/Regular | 辅助文字 |
| Footnote 2 | 11/Regular | 微文字 |
| Button | 14/Medium | 按钮文字 |
| Button/Small | 12/Medium | 小按钮 |

**关键细节**:
- **Inter 字体的 weight 用"Semi Bold"**(有空格),**不是"SemiBold"**—— 常见陷阱
- 可变字重(如 MiSans VF)需用原生值(Regular=330, Medium=380, Semi Bold=600)

**🚧 Phase 2 门禁**:
- ✅ 0 第二字体
- ✅ 每种 size × weight 组合都有对应 Style
- ✅ 所有组件文字通过 textStyleId 绑定
- ❌ 组件直接设 font-family / font-size → 拒绝,必须用 Style

## Phase 3:Component 层级

**🎯 目标**:原子设计三层架构 + 质量红线。

### 层级命名

```
atoms_*     原子层(Button、Input、Tag、Icon...)
molecules_* 分子层(SearchBox、FormField、Breadcrumb...)
organism_*  有机体层(TopBar、Sidebar、TaskList、DataTable...)
```

### 组合规则

- **organism 里所有视觉元素必须来自 atom 实例**(不能自绘)
- molecules 可以包含 atoms 实例
- atoms 是最小单位,不能再拆

### 质量红线(3 个 0)

- **0 硬编码颜色**(全部用 Token)
- **0 散落字体**(全部用 Text Style)
- **0 未绑定圆角**(圆角也用 Token)

### variant 规范

- **variant 间共享属性(列宽、高度)必须完全一致**
- 改 master 属性后实例 override 优先级更高,需手动清除冲突 override
- COMPONENT_SET 有 auto-layout 时手动 x/y 无效,布局引擎覆盖

### Review 顺序

1. **先看交互合理性**(这个组件的状态变化是否符合产品意图)
2. **再看层级规范**(有没有自绘、Token 有没有绑定)

**🚧 Phase 3 门禁**:
- ✅ 三层架构清晰(无跳级)
- ✅ 质量红线三个 0 全部达成
- ✅ variant 共享属性一致
- ❌ organism 里有自绘视觉元素 → 重建
- ❌ 有硬编码色值 / 散落字体 / 未绑定圆角 → 重绑

## 常见踩坑

| 坑 | 解决 |
|---|---|
| Inter 字体 weight 写成 "SemiBold" | 改 "Semi Bold"(有空格) |
| 图标实例着色用 instance.fills 导致背景块遮住线条 | 正确做法:改内层 VECTOR |
| combineAsVariants 后 variants 默认堆叠需手动排列 | 接受,手动排 |
| organism 里的 tabs_status 误用 chip_filter 实例 | 语义不同:tabs 单选导航,chip 多选过滤,必须重建 |
| 改 master 后实例 override 优先级更高 | 改 master 后必做:findAll 扫实例 → 检查 override → 统一更新 |

## 下一步

设计系统搭建完成后:
- 调用 `design-prototype` 开始页面原型组装
- 组件库每次变更后回来跑门禁自检

## 写入日志

```json
{
  "timestamp": "ISO 8601",
  "skill": "design-system",
  "tokens": {
    "primitives": 82,
    "semantic_tokens": 48,
    "radius": 7,
    "spacing": 11,
    "light_dark_coverage": true
  },
  "text_styles": 16,
  "components": {
    "atoms": 36,
    "molecules": 27,
    "organism": 14
  },
  "red_lines": {
    "hardcoded_color": 0,
    "scattered_fonts": 0,
    "unbound_radius": 0
  },
  "outcome": "system_ready"
}
```
