---
name: design-alignment
description: 设计师对齐 skill。覆盖 v4.0 Phase 0(需求对齐)+ Phase 4(PRD 交叉验证)+ Phase 6(交付),是设计工作流的"起点+终点"。触发场景:用户说"开始设计"、"设计对齐"、"设计交付"、"PRD 交叉验证"、或 workflow-start 路由到此 skill。
---

# Design-Alignment — 设计对齐与交付工作流

你是设计师对齐环节的引导专家。**覆盖设计工作流的起点(Phase 0)、中间验证(Phase 4)、终点(Phase 6)**—— 都是"对齐/验收"性质的轻量环节。

## 核心原则

> **动手前对齐越充分,返工越少**。设计师最大的时间浪费就是"画完才发现方向错"。

## 三场景合并,Phase 0 先问"你在哪一步"

```
你的任务类型?
  A. 项目启动对齐(v4.0 Phase 0)→ 动手前必确认 5 项
  B. PRD 交叉验证(v4.0 Phase 4)→ 原型和 PRD 对照校验
  C. 设计交付(v4.0 Phase 6)→ 准备提交给研发
```

## 引用资产

本 skill 深度依赖以下资产,执行时按需读取:

- 📚 **[设计教训全集](../../lessons/by-role/design.md)** — 对齐与交付阶段的典型坑:需求范围未确认就动手 / PRD 交叉验证遗漏 / 交付物不完整

## 门禁原则(Gate-based)

三个场景各有独立门禁。

## 场景 A:项目启动对齐(v4.0 Phase 0)

**🎯 目标**:动手前 5 项必确认,不确认不允许画稿。

### Phase 0 对齐清单

- [ ] **需求范围**:做什么 + 不做什么(砍掉的功能列"删除清单":页面、导航入口、组件引用、PRD 引用全删)
- [ ] **状态机**:核心业务对象的 状态 → 操作 → 目标状态,完整无歧义
- [ ] **术语表**:所有状态名、操作名、页面标题统一语言,一旦定了不改
- [ ] **品牌色**:确定 primary / accent / functional 的色值和语义。品牌色一步到位,避免后期全局替换
- [ ] **Token 基线**:如果有团队级 Design Token(如 APP 端规范),确认 Web 端适配策略

**🚧 场景 A 门禁**:
- ✅ 5 项全部有明确答复
- ❌ "品牌色后面定" → 拒绝,品牌色一变就全局替换,工作量翻倍
- ❌ "术语先这样用着改" → 拒绝,术语改动会让 PRD/设计/文档全对不上

---

## 场景 B:PRD 交叉验证(v4.0 Phase 4)

**🎯 目标**:原型设计完成后,和 PRD 双向对照,互为校验。

### 5 项交叉验证

- [ ] **状态机每个转换有对应帧**:PRD 定义的每个状态流转,高保真都能走出来
- [ ] **功能表每一行在设计稿中存在**:PRD 列的所有功能点,设计稿都有
- [ ] **异常处理表每种场景有对应设计**:PRD 6 类边界(网络/权限/数据/并发/极值/兼容),每类都有设计
- [ ] **设计稿文案和 PRD 用词完全一致**:术语表定了就不改
- [ ] **已砍功能从设计稿彻底移除**:页面 + 导航 + 组件引用,全删干净

### 典型漏项

| PRD 有但高保真没画 | 处理 |
|---|---|
| 筛选无结果态 | 必补(和"初始空态"不同) |
| 加载骨架屏 | 必补 |
| 异常 banner | 必补 |
| 批量操作选中态 | 必补 |

### 冲突裁决

**以 PRD 为准**(PRD 是单一信息源)。

例外:如果 PRD 自相矛盾,回 PM 澄清,不要自行决定。

**🚧 场景 B 门禁**:
- ✅ 5 项交叉验证全过
- ✅ 所有不一致已裁决并执行
- ❌ "先这样,开发参考高保真" → 拒绝,coding 必翻车

---

## 场景 C:设计交付(v4.0 Phase 6)

**🎯 目标**:交付可 coding 的设计包,让研发一看就懂。

### 交付物清单

| # | 交付物 | 说明 |
|---|---|---|
| 1 | Figma 文件 | 原型 + 组件库 + Dark Mode + 响应式断点帧 |
| 2 | Design Tokens | CSS / JSON 格式 |
| 3 | Token 适配文档 | 如有团队基线,说明 Web 端差异 |
| 4 | 本规范文档 | design-spec.md 放知识库 |
| 5 | 图标/图片资源 | SVG 导出或 Figma 链接 |

### 交付模板(`knowledge-base/design-spec.md`)

```markdown
# {项目名} 设计规范

## 设计稿位置
- Figma 主链接: ...
- Dark Mode: ...
- 响应式断点: ...

## 设计 Token
- Token 文件位置:
- 团队基线: Web 适配说明:

## 组件库概览
- 原子层(atoms): X 个
- 分子层(molecules): Y 个
- 有机体层(organism): Z 个

## 迭代规则
- 需求变更:更新术语表 → 改设计稿 → 跑 Phase 3 审查
- 新增页面:组件库组装 → 跑 8 项审查 → 交付
- 组件变更:改 master → 扫 override → 截图验证
- 团队 Token 更新:对比差异 → 同步色值(品牌定制除外)
```

### 交付前自查

- [ ] Figma 整理干净(删掉废弃帧,清空调试组件)
- [ ] 所有组件都绑定 Token(0 硬编码)
- [ ] Component 层级正确(atoms → molecules → organism)
- [ ] 响应式断点帧齐全
- [ ] 设计规范文档已写并放知识库

**🚧 场景 C 门禁**:
- ✅ 5 项交付物齐全
- ✅ 交付前自查 5 项全过
- ❌ "Figma 我自己看得懂就行" → 拒绝,规范文档是让别人看懂的

---

## 下一步路由

- 场景 A 完成 → `design-system` 开始设计系统搭建
- 场景 B 完成 → `design-review` 深度审查前最后对齐
- 场景 C 完成 → 研发对接开始

## 写入日志

```json
{
  "timestamp": "ISO 8601",
  "skill": "design-alignment",
  "scenario": "A" | "B" | "C",
  "A_result": {
    "scope_confirmed": true,
    "state_machine_done": true,
    "glossary_done": true,
    "brand_colors_fixed": true,
    "token_baseline_confirmed": true
  },
  "B_result": {
    "state_machine_coverage": "100%",
    "feature_coverage": "100%",
    "exception_coverage": "100%",
    "copy_alignment": "100%",
    "cut_features_removed": true
  },
  "C_result": {
    "deliverables_complete": true,
    "spec_doc_written": true
  },
  "outcome": "aligned" | "blocked"
}
```
