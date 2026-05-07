# Warm Editorial · 风味规范

> **使用前提**:先读 [`../PRINCIPLES.md`](../PRINCIPLES.md)——通用排版原则不在此重复。
> 本文件只讲 Warm Editorial **这一种风格** 的视觉选择。

---

## 1. 风格定位

**关键词**:编辑杂志风 / Warm Minimalism / Print-inspired

**情感基调**:温暖、克制、可信、有呼吸感

**适用场景**:项目介绍页、产品 landing、技术方案、个人简历、博客长文、演讲稿在线版、团队周报、分享封面

**不适用**:B2C 电商(太冷静)、游戏站(太平静)、金融仪表盘(数据密度不够)

---

## 2. 色彩

### 核心三色

```css
--bg:     #f5f0e8;  /* 米色底 */
--text:   #1a1a1a;  /* 近黑文字(不用 #000) */
--accent: #c0542e;  /* 赤陶红/砖红 */
```

### 辅助灰阶

```css
--bg-card:        #fff;                 /* 唯一的纯白使用处(卡片背景) */
--border:         rgba(0,0,0,0.08);
--text-secondary: #6b6560;
--text-light:     #999080;
--accent-light:   rgba(192,84,46,0.08);
```

### 色彩选择

- **限制配色范围**:核心三色 + 灰阶,不引入其他色相
- **比例大致 70-25-5**:70% 米色底+近黑文字,25% 灰阶,5% 赤陶 accent
- **渐变**:本风格不使用
- **阴影**:本风格不使用(深度靠边框和背景对比)

> **为什么这些是本风格的选择,不是 PRINCIPLES**:其他风格(Tech Dark、Retro 等)可以用渐变、阴影、霓虹——它们不违反原则。本风格的"克制"是**风味**,不是**普适规则**。

---

## 3. 字体

### 字体栈

```css
--serif: 'Source Serif 4', 'Noto Serif SC', 'Georgia', serif;
--sans:  'Noto Sans SC', -apple-system, BlinkMacSystemFont, sans-serif;
```

**Google Fonts 加载**:
```
https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@400;600;700;900&family=Noto+Sans+SC:wght@300;400;500;600&family=Source+Serif+4:ital,opsz,wght@0,8..60,400;0,8..60,600;0,8..60,700;0,8..60,900;1,8..60,400&display=swap
```

### 分工

| 元素 | 字体 | 原因 |
|---|---|---|
| h1/h2/h3 | **衬线** | 杂志感 + 权威感 |
| 正文 / 段落 | **无衬线** | 屏幕可读性 |
| 数字墙大数字 | **衬线** | 视觉锚点 |
| 代码 / URL / 元信息 | `'SF Mono', monospace` | 技术对比 |
| 章节小标签(英文) | sans + `letter-spacing: 0.15em` + uppercase | 杂志章节感 |

### 字号 & 字重

```
h1: clamp(40px, 6vw, 64px)  900  line-height 1.15
h2: clamp(28px, 4vw, 40px)  700  line-height 1.2
h3: 18-20px                  600-700
正文: 14-15px                400  line-height 1.7
辅助: 12-13px                300-400
标签: 11px                   600  uppercase + letter-spacing
```

- 标题 900 / 正文 400 / 引语 300 —— 强字重对比建立层级
- 禁止通页 500-600 单字重(扁平化会失去杂志感)
- 中文 line-height 1.7 比常规高,为中文留呼吸

---

## 4. 布局选择

### 容器

```css
max-width: 960px;
padding: 0 48px;  /* 移动端 24px */
```

比主流 1280px 窄,模拟杂志内页。**此宽度是本风格的选择**,不是 PRINCIPLES 要求。

### 垂直节奏

```
section padding: 80px 0
hero padding:    120px 0 80px
段落间距:         56-64px
紧凑间距:         16-24px
```

### 章节三件套(本风格约定)

每个 section 开头三件套:

```html
<section>
  <div class="section-tag">THE CORE IDEA</div>        <!-- 英文小标签 -->
  <h2>中文标题<span class="accent">强调词</span></h2>  <!-- 衬线 + 单 accent -->
  <p class="section-lead">副标题引语</p>                <!-- 浅灰 300 字重 -->
  <!-- 内容... -->
</section>
```

---

## 5. 核心组件

本风格推荐使用的 10 种区块(CSS 定义见 `template.html`):

| 组件 | 用途 |
|---|---|
| `.hero` | 页首,含 40×4px 砖红小条 + 大标题 + 元信息 |
| `.section-tag` | 英文小标签("The Core Idea" 等) |
| `.def-list` | 定义列表(如"定义/动因/路径"三段式) |
| `.card` / `.card-grid` | 卡片网格(3 列,每张含 tag + h3 + p) |
| `.compare-table` | 对比表(无竖线,仅 border-bottom) |
| `.stats-row` | 数字墙(serif 36px accent 数字) |
| `.flow-steps` | 横向流程(带 → 箭头,自动编号) |
| `.roles-row` | 3-5 列并列模块 |
| `.stack-grid` | 4×N 信息矩阵 |
| `.ending` | CTA 收尾(2px 边框按钮) |

---

## 6. 装饰约定(本风格特有)

### ✅ 使用
- **40×4px 小红条**:本风格标志性元素,出现在 hero 和 ending 开头
- **1px hairline 边框**:`rgba(0,0,0,0.08)`
- **4px 圆角**:仅此一种圆角值

### ❌ 不使用(这是本风格的选择)
- 图标库 / emoji / 徽章
- 渐变(唯一例外:roadmap 高亮卡片的 2% accent 极淡渐变)
- 阴影 / backdrop-filter / 3D transform
- 霓虹色 / 高饱和色

### ✨ 允许的反差元素
- **深色代码块** `#1a1a2e`:技术文档的视觉变化点
- **角色标识 8px 小圆点**:`#6366f1` / `#ec4899` / `#14b8a6` 等彩色——仅作身份,不作主体

---

## 7. 可访问性 & 打印(本风格必备)

本风格天然适合长阅读和纸面输出,a11y 和打印必须默认到位。

### `<head>` 必填

```html
<meta name="description" content="一句话概括本页">
<meta name="color-scheme" content="light only">
<meta property="og:title" content="...">
<meta property="og:description" content="...">
```

### 键盘聚焦

```css
a:focus-visible, button:focus-visible {
  outline: 2px solid var(--accent);
  outline-offset: 3px;
}
```

### 动效偏好

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    transition-duration: 0.01ms !important;
  }
}
```

### 打印样式

必须处理:
- `-webkit-print-color-adjust: exact` 保留米色底
- `page-break-inside: avoid` 卡片不拦腰切断
- `a[href^="http"]::after { content: " (" attr(href) ")" }` 展开 URL
- `@page { margin: 16mm 14mm; }`

---

## 8. 和 PRINCIPLES.md 的协作

本文件 **只讲风味**。PRINCIPLES.md 讲的是**任何风格都要遵守的排版原则**。

生成一个 Warm Editorial 页面的完整流程:

1. 先按 PRINCIPLES.md 的 6 条原则规划结构(≥4 种区块 / 密度跳变 / 留白节奏 / 强调节制 / 作者痕迹 / 打破齐整)
2. 再按本文件应用 Warm Editorial 的视觉选择(米色 / 衬线 / 砖红 / 克制装饰)
3. 两者缺一不可:只按 PRINCIPLES 会没风格,只按本文件会显 AI 味

---

## Appendix · Token 速查

```css
:root {
  --bg: #f5f0e8;
  --bg-card: #fff;
  --bg-code: #1a1a2e;
  --border: rgba(0,0,0,0.08);
  --text: #1a1a1a;
  --text-secondary: #6b6560;
  --text-light: #999080;
  --accent: #c0542e;
  --accent-light: rgba(192,84,46,0.08);
  --serif: 'Source Serif 4', 'Noto Serif SC', 'Georgia', serif;
  --sans: 'Noto Sans SC', -apple-system, BlinkMacSystemFont, sans-serif;
}
```

---

**Credits**:风格诞生于 Teamspace 项目名片页(2026-04),由 X 和小克提炼。
**License**:MIT · **Author**:X & 小克,2026-04-23
