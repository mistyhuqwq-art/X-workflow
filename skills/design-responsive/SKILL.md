---
name: design-responsive
description: 响应式适配 skill。覆盖 v4.0 Phase 5,按 8 条规则做多断点适配(桌面/平板/移动)。触发场景:用户说"响应式"、"断点适配"、"多屏幕支持"、或 workflow-start 路由到此 skill。
---

# Design-Responsive — 响应式适配工作流

你是响应式适配环节的引导专家。目标:**用 8 条规则把单断点设计扩展到多断点,研发能直接按照帧实现**。

## 核心原则

> **大屏不等于等比放大**——利用额外空间展开省略文字、加宽列间距。

## 引用资产

本 skill 深度依赖以下资产,执行时按需读取:

- 📚 **[设计教训全集](../../lessons/by-role/design.md)** — 响应式适配阶段的典型坑:等比放大思维 / 断点选多了 / 只做桌面端

## 门禁原则(Gate-based)

3 个 Phase。

## Phase 0:断点决策

**🎯 目标**:根据目标用户设备选 2-3 个断点。

### 常见断点策略

| 策略 | 断点 | 适用 |
|---|---|---|
| 桌面为主 | 1440 + 1920 | B 端后台 |
| 响应全栈 | 375 + 768 + 1440 | C 端 Web App |
| 移动优先 | 375 + 768 | 手机为主的 Web |

**决策规则**:
- 选 2-3 个(多了维护成本爆炸)
- 起始断点要和研发配合的 CSS 框架对齐(Tailwind / Antd 默认值)

**🚧 Phase 0 门禁**:
- ✅ 断点数量 2-3 个
- ✅ 断点值和研发 CSS 框架对齐
- ❌ 断点 > 4 个 → 合并(维护成本失控)

## Phase 1:先做 1 帧示意验证

**🎯 目标**:不要全量铺开,先做 1 个代表帧验证方案。

**操作顺序**:
1. 选 1 个代表性页面(通常是列表页,信息最多)
2. 在目标断点下做出 1 帧示意
3. 和 PM / 研发对齐:
   - 列宽适配方案合理吗?
   - 文案缩写方案合理吗?
   - 布局调整合理吗?
4. 确认后再全量铺开

**🚧 Phase 1 门禁**:
- ✅ 1 帧示意已做并对齐
- ❌ 直接全量做 → 拒绝,全量做完发现方案不对,工作量翻倍

## Phase 2:全量铺开,应用 8 条规则

### 规则 1:帧结构必须 auto-layout + FILL

```
Frame (HORIZONTAL)
  ├── Sidebar (FIXED)
  └── Main Content (FILL)
       └── Content Area (FILL, padding)
            └── Table / Content (FILL)
```

**关键**:FILL 的子节点自动适应断点宽度,不需要每个断点重画。

### 规则 2:表格列宽适配

| 列类型 | 策略 |
|---|---|
| 固定短内容(ID、checkbox) | FIXED |
| 长文本(名称) | FILL 或按断点调宽度 |
| 操作列 | FIXED,按最多按钮数量计算最小宽度 |

### 规则 3:文案适配

| 断点 | 文案策略 |
|---|---|
| 小屏(375) | 缩写("发布到线上"→"发布") |
| 大屏(1440+) | 完整文案 |

**实现方式**:按钮里用 Text Component 的 override 展示不同文本。

### 规则 4:大屏不等于等比放大

大屏可用空间多:
- 展开省略的文字
- 加宽列间距
- 增加次要信息列
- 不要简单等比放大(会显得空旷)

### 规则 5:实例内部列宽无法 override

**场景**:想让 TaskList 组件的实例在大屏下列宽变大。

**限制**:Figma 不支持 override 内部列宽。

**解决**:detach 后调整,**detach 后必须重新绑定 Text Style**(detach 断了和 Style 的关联)。

### 规则 6:resize 帧后检查所有子帧

- auto-layout 的 FILL 子节点会自动适应
- **NONE 布局的 FIXED 子节点必须手动调**

### 规则 7:每个帧名明确标断点

```
TaskList/Desktop-1440
TaskList/Tablet-768
TaskList/Mobile-375
```

### 规则 8:组件在不同断点可能有不同 variant

如:
- 小屏 Sidebar = Collapsed variant
- 大屏 Sidebar = Expanded variant

利用 Component Property 做 variant 切换,不是画两个不同组件。

**🚧 Phase 2 门禁**:
- ✅ 每个断点都有对应帧
- ✅ 8 条规则全部应用
- ✅ 所有 auto-layout 节点都用了 FILL
- ❌ 断点间有帧被遗漏 → 补上

## Phase 3:跨断点一致性检查

**🎯 目标**:确保断点间只差布局,不差内容/功能。

### 检查清单

- [ ] 同一页面的不同断点,信息完整度一致(大屏不能多东西)
- [ ] 所有断点都复用同一套 Token
- [ ] detach 过的组件已重新绑 Text Style
- [ ] 所有断点帧都在 Phase 1 对齐过的方案范围内
- [ ] 响应式帧和非响应式帧的命名区分清楚

**🚧 Phase 3 门禁**:
- ✅ 一致性清单全过
- ❌ 有断点独有功能 → 决策是否必要,不必要的删掉

## 下一步

响应式完成后:
- 调用 `design-alignment` 场景 C 做最终交付
- 有 review 反馈 → 回 `design-review`

## 常见踩坑

| 坑 | 解决 |
|---|---|
| 每个断点重画一遍 | 错,应该用 auto-layout + FILL 让一套 frame 适应多断点 |
| detach 后字体乱了 | detach 必须立即 findAll TEXT 重绑 textStyleId |
| NONE 布局的子节点 resize 后没跟上 | 手动调,或改用 auto-layout |
| 断点选 4 个以上 | 合并,维护成本不值 |
| 等比放大做大屏 | 利用空间展开,不是放大 |

## 写入日志

```json
{
  "timestamp": "ISO 8601",
  "skill": "design-responsive",
  "breakpoints": [375, 768, 1440],
  "representative_frame_approved": true,
  "rules_applied": {
    "auto_layout_fill": true,
    "table_columns_adapted": true,
    "copy_abbreviated": true,
    "large_screen_expanded": true,
    "detach_restyled": true,
    "all_frames_checked": true,
    "frame_naming": true,
    "variants_per_breakpoint": true
  },
  "consistency_check": "pass",
  "outcome": "responsive_complete"
}
```
