---
name: design-prototype
description: 设计原型组装 skill。覆盖 v4.0 Phase 2,按帧覆盖清单 + 组装红线产出页面原型。触发场景:用户说"做原型"、"画页面"、"组装设计稿"、或 workflow-start 路由到此 skill。
---

# Design-Prototype — 设计原型组装工作流

你是原型组装环节的引导专家。目标:**每个页面都覆盖 10 类必备帧,0 手搭视觉元素**。

## 核心原则

> **设计稿不是给设计师自己看的,是给研发+QA 看的**。研发看了就能实现,QA 看了就能测,才算合格。

## 引用资产

本 skill 深度依赖以下资产,执行时按需读取:

- 📚 **[设计教训全集](../../lessons/by-role/design.md)** — 原型组装阶段的典型坑:帧类型不全 / 手搭视觉元素 / 红线标注缺失

## 门禁原则(Gate-based)

3 个 Phase,每个有明确产出和通过标准。

## Phase 0:前置检查

- [ ] `design-alignment` 场景 A 已完成(对齐 5 项)
- [ ] `design-system` 已完成(组件库可用)
- [ ] PRD v3.x 终稿可访问
- [ ] 页面清单已列(做哪几个页面)

**🚧 Phase 0 门禁**:
- ✅ 组件库已 review 通过
- ❌ 组件库没 review 就直接出原型 → 拒绝,原型必返工(实测教训)

## Phase 1:帧覆盖清单(10 类必备帧)

**🎯 目标**:每个列表页/表单页必须覆盖以下 10 类帧。

### 列表页必备帧

| # | 帧类型 | 说明 |
|---|---|---|
| 1 | 默认态 | 有数据正常展示 |
| 2 | 初始空态 | 无数据 + 主 CTA 引导 |
| 3 | 筛选无结果 | 有数据但不匹配 + "清除筛选" |
| 4 | 加载中 | 骨架屏 |
| 5 | 批量操作 | 多选 + 选中行高亮 |
| 6 | 全选 | 所有 checkbox checked |
| 7 | 操作确认 | 1 个完整帧展示 modal 位置 |
| 8 | 操作反馈 | Toast(白底实色,不遮操作区) |
| 9 | 异常告警 | 页面常驻 banner(不用弹窗) |
| 10 | 其余 modal | 独立画出,排在完整帧下方 |

### 关键区分

- **初始空态 ≠ 筛选无结果**:后端逻辑不同,引导操作不同(一个是"创建第一个",一个是"清除筛选")
- **异步事件用 banner 不用弹窗**(弹出时机不可控,用户不一定在线)
- **Toast 白底实色,不要半透明**

**🚧 Phase 1 门禁**:
- ✅ 10 类帧每类都有(不涉及时明确标注)
- ✅ 初始空态和筛选无结果拆分
- ❌ 只画"默认态"就交 → 拒绝,研发无法实现异常路径

## Phase 2:组装红线

**🎯 目标**:按红线组装,杜绝返工元凶。

### 组装红线

- **所有视觉元素必须是组件实例**,0 手搭(layout 容器除外)
- 操作按钮严格按 PRD 状态→操作映射
- 按钮样式层级:primary 填充 = 主 CTA → danger 文字 = 危险 → ghost 文字 = 普通
- **空态必须拆分**:初始空态 ≠ 筛选无结果
- **异步事件用 banner 不用弹窗**
- **Toast 白底实色**

### 按钮尺寸规则

| 场景 | 尺寸 |
|---|---|
| 页面级 CTA | default |
| 筛选区辅助操作 | small |
| 表格行内操作 | small |
| Modal 操作 | default |

### 改 Master 后必做

1. `findAll` 扫描所有该组件的实例
2. 检查 override 是否指向旧值
3. 统一更新
4. **不要假设改了 master 实例就会跟着变**

**🚧 Phase 2 门禁**:
- ✅ 0 手搭视觉元素(所有都是组件实例)
- ✅ 按钮尺寸按场景对
- ✅ 改 master 后已扫 override
- ❌ 遇到 override 冲突就 detach → 拒绝,detach 断了和组件库的关联,后续组件升级追不上

## Phase 3:自检 + 准备 review

**🎯 目标**:原型交给 design-review 前,设计师自己先跑一遍基础检查。

### 自检清单

- [ ] 10 类帧齐全
- [ ] 所有视觉元素都是组件实例
- [ ] 状态机每个转换都有对应帧
- [ ] 文案和 PRD 术语表一致
- [ ] 已砍功能从设计稿彻底移除

### 交付给 review 的物料

- Figma 链接(确保有权限)
- 帧覆盖清单 checklist(哪些已画,哪些标"不涉及")
- PRD 交叉引用(每个帧对应 PRD 哪一章)

**🚧 Phase 3 门禁**:
- ✅ 自检 5 项全过
- ❌ "剩下的 review 时再说" → 拒绝,review 应该找系统性问题,不是 PM 帮你找低级错误

## 常见踩坑

| 坑 | 解决 |
|---|---|
| 第一版原型可用度 ~40% | 正常,需要 10+ 轮 review,耐心 |
| 组件库没 review 就出原型 | 原型会混乱,返工严重;永远:先 review 组件库再设计 |
| 下拉值未填充 | 原型就要填真实的候选值,不是 "<xxx>" |
| 状态标签混乱 | 每个帧名明确标状态:"TaskList/Default"、"TaskList/Filtered-Empty" |
| Token 消耗巨量(300K+/次) | 接受,复杂页面如此;不接受的话做框架先,细节开发时补 |

## 下一步

原型组装完成 → 调用 `design-review` 做深度审查(8 项)

## 写入日志

```json
{
  "timestamp": "ISO 8601",
  "skill": "design-prototype",
  "pages_designed": 21,
  "frame_coverage": {
    "default": true,
    "empty_initial": true,
    "empty_filter": true,
    "loading": true,
    "batch_ops": true,
    "select_all": true,
    "confirmation": true,
    "feedback_toast": true,
    "banner_alert": true,
    "other_modals": true
  },
  "all_as_instances": true,
  "hand_drawn_count": 0,
  "outcome": "ready_for_review"
}
```
