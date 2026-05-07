# Minimal Mono · 风味规范

> **使用前提**:先读 [`../PRINCIPLES.md`](../PRINCIPLES.md) —— 通用排版原则不在此重复。
> 本文件只讲 Minimal Mono **这一种风格** 的视觉选择。

---

## 1. 风格定位

**关键词**:Minimal / Typographic / Mono-coded metadata / Paper-like restraint

**情感基调**:理性、克制、技术性、无色彩装饰

**适用场景**:技术博客、开源项目 README 展示页、个人开发者主页、technical writing、工程师作品集、论文式长文、"less is more" 的观点页

**不适用**:品牌宣传页、活动邀请、面向非技术用户的产品页(会显得冷淡)、儿童/娱乐类内容

### 和其他"黑白风"的区别

- ❌ 不是"Swiss Grid"(需要 12 栏严格对齐 + 红色 accent)
- ❌ 不是"Brutalist"(故意粗野 + 张扬)
- ✅ 是"安静的技术文本"(纯黑白 + 等宽元信息 + 虚线分隔)

参考气质:优秀的独立开发者 README、技术博客内页、工程师 thinking journal —— 不靠颜色,不靠装饰,靠字体族和间距。

---

## 2. 色彩(只有灰度)

### 核心灰阶

```css
--bg:       #ffffff;                /* 纯白底 */
--text:     #000000;                /* 纯黑主文字 */
--text-sub: #333333;                /* 副文字 */
--text-mid: #666666;                /* 中性辅助 */
--text-dim: #999999;                /* 弱化文字 */
--line:     #cccccc;                /* 虚线分隔 */
--line-heavy: #000000;              /* 实线强分隔(仅少数几处) */
```

**允许的"色彩"例外**:
- 链接 hover 可以用 `currentColor` 加下划线(不换色)
- 选中文本背景 `::selection` 用纯黑 + 白字
- 代码块背景可用极浅灰 `#f5f5f5`(非纯白,避免代码和正文粘连)

**不允许**:
- 任何彩色(包括蓝色链接)
- 渐变
- 阴影
- accent 色(Minimal Mono 的"accent"是字族反差和加粗,不是颜色)

> **为什么如此激进地放弃颜色**:颜色是视觉捷径,一旦放弃,**排版必须真的过硬**。这个风格的气质来源就是"克制到无可克制"。颜色进来就破功。

---

## 3. 字体

### 字体栈(双字体系统)

```css
--sans:  'Inter', 'Noto Sans SC', -apple-system, BlinkMacSystemFont, sans-serif;
--mono:  'JetBrains Mono', 'SF Mono', Menlo, monospace;
```

**关键:没有 serif**。Minimal Mono 不用衬线。

**Google Fonts 加载**:
```
https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;700&family=JetBrains+Mono:wght@400;500&family=Noto+Sans+SC:wght@300;400;500;700&display=swap
```

### 分工(严格)

| 元素 | 字体 | 字重 | 原因 |
|---|---|---|---|
| h1 | Inter | 300 | ⭐ 细而大,和正文反差靠字号不靠字重 |
| h1 重点词 | Inter | 900 | 在 300 里嵌 900,形成**"粗细断崖"** |
| h2 / h3 | Inter | 500 | |
| 正文 | Inter | 400 | |
| 元信息 / 时间戳 / 版本号 / 章节编号 | **JetBrains Mono** | 400 | ⭐ 等宽一眼识别出是"元数据" |
| 章节小标签 | Mono | 500 | 不 uppercase 不 letter-spacing |
| 代码 | Mono | 400 | |

### Minimal Mono 的签名技巧

**① 粗细断崖**

h1 用 300 细字,关键词嵌 900,形成极端对比:

```html
<h1>A <b>design system</b> for people who <b>read</b>.</h1>
```

```css
h1 { font-family: var(--sans); font-weight: 300; font-size: 56px; }
h1 b { font-weight: 900; }   /* 没有其他样式,只换字重 */
```

**② 等宽标签代替所有"小字"**

任何时间、版本、编号、元信息都用 Mono:

```html
<div class="meta">
  <span>2026.04</span>
  <span>v1.0.0</span>
  <span>draft</span>
</div>
```

**③ 虚线替代实线**

分隔用虚线 `1px dashed #cccccc`,视觉上更轻、更像手写稿的结构提示,而不是印刷的硬隔断。

---

## 4. 布局选择

### 容器

```css
max-width: 680px;       /* 比 warm 的 960px 更窄! */
padding: 64px 48px;     /* 移动端 48px 28px */
```

**为什么 680px**:这是"适合阅读的最佳行长"(50-75 字/行)。Minimal Mono 的所有内容都应该**像读书**,不是扫视。窄容器强迫内容更精炼。

### 垂直节奏

```
section padding:  72px 0
hero padding:     120px 0 72px   ← hero 留白大,让单一标题独立存在
段落间距:          32-40px
紧凑间距:          12-16px        ← 密的地方更密(PRINCIPLES 原则 2)
```

### 左侧 hairline 引导

可选:在容器左侧加一条垂直细线作为"视线引导":

```css
.container::before {
  content: '';
  position: absolute; left: 48px; top: 120px; bottom: 72px;
  width: 1px; background: #000; opacity: 0.08;
}
```

这根细线**不划分内容**,只是"书脊"—— 视觉锚点。

---

## 5. 核心组件

| 组件 | 用途 | Minimal Mono 特色 |
|---|---|---|
| `.hero` | 页首 | 无标签,无装饰。Mono 时间 + h1 + 引语。节制到只有文字 |
| `.meta-row` | 元信息 | Mono 字体 + `/` 分隔符 + 灰色 |
| `.rule` | 实线分隔段 | `border-top: 1px solid #000` + `padding-top: 32px` 开启新章 |
| `.list` (编号列表) | 替代卡片 | Mono 编号 + sans 标题 + 灰色描述,用虚线分隔每项 |
| `.blockquote` | 引语 | 加粗左边线(`#000` 3px) + italic? 不,用正常字重 + 斜 padding |
| `.pull` | 提拉引用 | h2 级字号,左侧空 72px hanging,形成"书页感" |
| `.footnote` | 脚注 | Mono 字体,`[1]` / `[2]` 方括号引用 |
| `.code-block` | 代码 | 极浅灰底 `#f5f5f5`,无语法高亮(保持单色) |

### 编号列表(替代卡片网格)

这是 Minimal Mono 的**排版签名**:

```html
<ul class="list">
  <li>
    <span class="n">01</span>
    <span><b>Only black and white.</b> 色彩是噪音,文字是信号。</span>
  </li>
  <!-- ... -->
</ul>
```

```css
.list { list-style: none; }
.list li {
  padding: 14px 0;
  border-top: 1px dashed #ccc;
  display: grid;
  grid-template-columns: 32px 1fr;
  gap: 16px;
  align-items: baseline;
}
.list li:last-child { border-bottom: 1px dashed #ccc; }
.list .n {
  font-family: var(--mono);
  font-size: 12px;
  color: #999;
}
```

---

## 6. 装饰约定

### ✅ 使用
- **虚线分隔** 1px dashed `#cccccc` —— 比实线轻
- **Mono 元信息** —— 所有小字用等宽
- **粗细断崖** —— 字重 300 / 900 对比
- **左侧引导线**(可选)—— 书脊式垂直细线

### ❌ 禁止(这是本风格的选择)
- 任何颜色(包括灰度以外)
- 图标库 / emoji
- 渐变 / 阴影 / backdrop-filter
- 圆角 > 0(所有元素方角)
- accent 颜色标签(改用加粗)
- 衬线字体(serif)

### ✨ 允许的反差元素
- **极浅灰代码块** `#f5f5f5` —— 代码必须和正文稍微分开,纯白上纯白会糊
- **提拉引用区域** —— padding 大 + hanging indent,形成书页感

---

## 7. 可访问性 & 打印

### `<head>` 必填

```html
<meta name="description" content="一句话概括本页">
<meta name="color-scheme" content="light only">  <!-- Minimal Mono 明确只做亮色 -->
<meta property="og:title" content="...">
<meta property="og:description" content="...">
```

### 键盘聚焦

```css
a:focus-visible, button:focus-visible {
  outline: 2px solid #000;
  outline-offset: 3px;
}
```

### 动效偏好

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after { transition-duration: 0.01ms !important; }
}
```

### 打印样式

Minimal Mono **天然为打印而生** —— 它本来就像打印品:

```css
@media print {
  @page { margin: 20mm 18mm; }
  body { font-size: 11pt; }
  .container { max-width: none; padding: 0; }
  a[href^="http"]::after {
    content: " [" attr(href) "]";
    font-family: var(--mono);
    font-size: 0.82em;
    color: #666;
  }
  .list li, .rule { page-break-inside: avoid; }
  h1, h2, h3 { page-break-after: avoid; }
}
```

---

## 8. 和 PRINCIPLES.md 的协作

本文件**只讲风味**。生成一个 Minimal Mono 页面的完整流程:

1. 先按 PRINCIPLES.md 规划结构(≥4 种区块 / 密度跳变 / 留白节奏 / 强调节制 / 作者痕迹 / 打破齐整)
2. 再按本文件应用 Minimal Mono 视觉选择(纯黑白 / Inter + Mono / 虚线分隔 / 粗细断崖)

**Minimal Mono 对 PRINCIPLES 的翻译**:

- **原则 1(结构多样性)**:Minimal Mono 替代卡片的是**编号列表** + **提拉引用** + **代码块** + **实线分隔段**。别只用编号列表,也会模板化
- **原则 2(密度跳变)**:Minimal Mono 天然适合长段落 + 一句话引语的跳变。多用
- **原则 3(留白节奏)**:hero 可以 120px+ 大留白,段落内紧凑 14-16px。反差大
- **原则 4(强调节制)**:Minimal Mono 的"强调"只能靠**字重**(900) 或**加粗**(`<b>`)。没有颜色可退路
- **原则 5(作者痕迹)**:Mono 字体的元信息(日期、版本、draft/final)天然就是作者痕迹,充分利用
- **原则 6(打破齐整)**:Minimal Mono 可以放一个手写注释、一处 ascii art、一个编号反常的 `[07]` 跳号

---

## Appendix · Token 速查

```css
:root {
  --bg:       #ffffff;
  --text:     #000000;
  --text-sub: #333333;
  --text-mid: #666666;
  --text-dim: #999999;
  --line:     #cccccc;
  --line-heavy: #000000;
  --sans:  'Inter', 'Noto Sans SC', -apple-system, sans-serif;
  --mono:  'JetBrains Mono', 'SF Mono', Menlo, monospace;
}
```

---

**Credits**:风味由 X 和小克提炼,灵感来自独立开发者的 README 和技术博客。
**License**:MIT · **Author**:X & 小克,2026-04-23
