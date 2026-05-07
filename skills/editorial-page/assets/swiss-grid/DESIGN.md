# Swiss Grid · 风味规范

> **使用前提**:先读 [`../PRINCIPLES.md`](../PRINCIPLES.md) —— 通用排版原则不在此重复。
> 本文件只讲 Swiss Grid **这一种风格** 的视觉选择。

---

## 1. 风格定位

**关键词**:International Typographic Style / 12-column grid / Modular scale / Red & black

**情感基调**:秩序、严肃、克制、精确。带印刷出版物的权威感

**核心理念**:**Grid is a way of thinking**。不依赖装饰,靠**网格对齐、字重对比、模数比例**本身构建美感。1950s 瑞士学派(Müller-Brockmann / Hofmann)的数字化回响。

**适用场景**:设计品牌自我展示、排版研究、出版物/期刊、严肃媒体站、建筑/工业设计事务所、年度报告、文化机构官网

**不适用**:SaaS 首页(太冷)、消费产品(无趣)、教育/儿童(呆板)、需要温度的内容

### 和其他"极简"的区别

- ❌ 不是 Minimal Mono(MM 是纯文本式极简,这个是结构化极简)
- ❌ 不是 Warm Editorial(杂志感但不严格网格)
- ✅ 是 "秩序至上的极简" —— 一切元素都在 12 栏网格上精确对齐,用红黑二色 + 一种字体 + 三四种字重完成全部视觉层级

参考气质:严肃的建筑师作品集、文化机构年报、瑞士设计学校的期刊、需要"有设计感但不张扬"的企业展示。

---

## 2. 色彩

### 核心二色 + 白底

```css
--bg:     #ffffff;    /* 纯白底 */
--text:   #000000;    /* 纯黑主文字 */
--accent: #ff1f1f;    /* 瑞士红(纯正饱和的红,不是砖红,不是玫红) */
```

### 辅助灰阶(仅为层级,不为装饰)

```css
--text-sub:   #222222;
--text-mid:   #444444;
--text-dim:   #999999;
--line-thin:  rgba(0,0,0,0.08);
--line-thick: #000000;
```

### 色彩哲学

Swiss Grid 的色彩是**二元的**:**黑或红**。不存在"灰色选项"—— 灰度只是辅助文字的字重表现手段,不作为设计色。

**红色**用于:
- h1 里的**单个关键词**(不多于 1 个)
- 对比表/列表里的 `.highlight` 列
- 章节编号前缀(如"§ 02")
- 垂直章节引导线

**红色不用于**:
- 按钮填充(按钮用纯黑)
- 背景大面积着色(红作为 spot color,不是面色)
- 装饰线/分隔线(用黑)

### 严格禁令

- ❌ 任何第二种有色相的颜色(没有蓝、绿、橙)
- ❌ 渐变
- ❌ 阴影
- ❌ 圆角 > 0(网格系统不允许圆角)
- ❌ accent 红色的透明度变体(透明的瑞士红会失掉纯度)

---

## 3. 字体

### 字体栈(单字体族)

```css
--sans: 'Inter', 'Noto Sans SC', -apple-system, BlinkMacSystemFont, sans-serif;
--mono: 'JetBrains Mono', 'SF Mono', Menlo, monospace;  /* 仅编号/章节号/元信息用 */
```

**关键:Swiss Grid 不用 serif**。整个系统只用一个 sans-serif 字体族,靠**字重对比**(300/500/700/900) 撑起全部层级。

**Google Fonts 加载**:
```
https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;700;900&family=JetBrains+Mono:wght@400;500&family=Noto+Sans+SC:wght@300;400;500;700;900&display=swap
```

### 分工(严格,只允许这些字重)

| 元素 | 字体 | 字重 | 大小 |
|---|---|---|---|
| h1 | Inter | **900** | clamp(56px, 7vw, 80px) |
| h1 红色关键词 | Inter | 900 | 同上 `color: var(--accent)` |
| h2 | Inter | **900** | clamp(32px, 4vw, 44px) uppercase |
| h3 | Inter | 700 | 18-20px |
| 正文 | Inter | 400 | 14-16px |
| 副栏引语 | Inter | 400 | 12-14px |
| 章节编号 | JetBrains Mono | 500 | 11-12px `§ 02` 格式 |
| 元信息 | Mono | 500 | 11px uppercase |

### Swiss Grid 的签名技巧

**① 全大写 h1 / h2**

标题**强制 uppercase** + `letter-spacing: -0.025em`:

```css
h1, h2 { text-transform: uppercase; letter-spacing: -0.03em; }
```

这让标题变得**像排版样本**,而非像说话。

**② 单关键词染红,不整句**

```html
<h1>Grid is a <span class="k">way</span> of thinking.</h1>
```

严格一个 h2 最多一个红色关键词。整页的红色"事件"≤ 3 次(hero 1 次 + 某章节 1 次 + 对比表 highlight 列 1 次)。

**③ Modular scale(模数比例)**

所有字号按 **1.25 ratio**(major third) 递进:

```
12 → 14 → 16 → 20 → 24 → 32 → 40 → 56 → 80
```

不允许"11.5px" / "17px" 这种中间值。字号必须在 scale 上。

---

## 4. 12 栏网格系统(核心)

### 容器

```css
.container {
  max-width: 1100px;
  margin: 0 auto;
  padding: 60px 48px;
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  gap: 16px;
}
```

比其他风味宽(1100px),为了容纳 12 栏。

### 默认列分配

**Hero 层**:
- 编号 `§ 01` — col 1-2 (2 栏)
- 主标题 + 副标题 — col 3-9 (7 栏)
- 侧边引语 — col 10-13 (3 栏,带左粗黑线)

**常规章节**:
- 章节编号/小标签 — col 1-2
- 主体 — col 3-13

**全宽块**(分隔/大标题/数字墙):
- col 1 / -1(跨所有 12 栏)
- 前面加 `border-top: 2px solid #000` 作为强分隔

### 对齐是硬规则

Swiss Grid 的**每一个元素**必须落在 12 栏的**列起点/终点**上。禁止"1450 像素宽的漂浮卡片"。如果一个元素跨越某几栏,必须明确说出是 col 3-9 还是 col 5-12。

### 垂直节奏(模数化)

```
section padding: 48px 0 或 72px 0
大分隔上下:     96px
段落间距:        32px 或 48px
紧凑间距:        16px
```

间距也按 **16 的倍数**递进(16/32/48/72/96),不允许"38px"这种。

---

## 5. 核心组件

| 组件 | 用途 | Swiss 特色 |
|---|---|---|
| `.hero` | 页首 | 12 栏 3 分区:编号 / 主标 / 侧边引语 |
| `.col-num` | 左列章节编号 | Mono + `§ 01` 格式 |
| `.col-side` | 右列窄副栏 | 带 `border-left: 2px solid #000`,小字副本 |
| `.rule` | 强分隔线 | 整 12 栏宽,`border-top: 2px solid #000` |
| `.tbl` | 严格表格 | 顶底黑实线,行间细线,红 highlight 列 |
| `.modular-h2` | 章节大标题 | uppercase 900,红色单关键词 |
| `.cta-row` | 按钮行 | 方角黑底白字按钮,无圆角 |
| `.meta-tag` | 章节小标签 | Mono uppercase 红色 |

### 典型章节结构

```html
<section class="row">
  <div class="col-num">
    § 02<br>
    FEATURES
  </div>
  <div class="col-main">
    <h2>Four <span class="k">pillars</span></h2>
    <p class="lead">Each column earns its place.</p>
    <!-- 内容... -->
  </div>
  <div class="col-side">
    A short editorial note that
    runs in the narrow right
    column. Like a magazine.
  </div>
</section>
```

---

## 6. 装饰约定

### ✅ 使用
- **2px 实黑线** 作为章节分隔(严肃)
- **1px 细线** 作为行分隔(表格/列表)
- **左侧 2-3px 红线** 作为章节引导
- **方角**(`border-radius: 0`,全系统)

### ❌ 禁止
- 任何圆角(甚至 2px 都不行)
- 任何阴影 / 渐变 / backdrop-filter
- 图标库 / emoji
- 手绘/歪斜元素(Swiss 的反面)
- 彩色照片/彩色图表(需要图表时用黑白条纹/斜线 hatching)
- 动效(hover 可以换色但不能有 transition transform)

### ✨ 唯一的"打破齐整"

Swiss Grid 是最严格的风格,但 PRINCIPLES 原则 6 仍然要求打破齐整。允许的做法:
- **一个故意"越栏"的元素**(如 h1 横跨 col 3-11,结果某个字母越过 col 11 边界)
- **一张表格里某一行字号不同**(不是错误,是重音)
- **一个数字用 serif 而全系统是 sans**(手写感反差)

这些是 Swiss 大师们常用的"打破严格"的方式 —— 它们存在,才让严格显得是选择而不是笨拙。

---

## 7. 可访问性 & 打印

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

### 对比度

- 黑 on 白 = 21:1 ✓✓✓
- 红 `#ff1f1f` on 白 ≈ 4.1:1 ✓ AA(≥18px 字体安全)
- 灰 `#999` on 白 ≈ 2.8:1 ⚠️ 仅用于装饰性元信息(章节号、页码)

### 打印(Swiss 天生为打印而生)

```css
@media print {
  @page { margin: 20mm 18mm; }
  body { font-size: 11pt; }
  .container { display: block; max-width: none; padding: 0; }
  .row { display: grid; grid-template-columns: 2fr 7fr 3fr; gap: 16px; }
  /* 保留 accent 红,因为 Swiss 的红是核心语义 */
  body { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
  h1, h2 { page-break-after: avoid; }
  .row { page-break-inside: avoid; }
  a[href^="http"]::after { content: " (" attr(href) ")"; color: #666; font-size: 0.85em; }
}
```

---

## 8. 中文处理(特别说明)

Swiss Grid 是**拉丁字母文化产物**,中文适配需要注意:

- **h1/h2 uppercase 对中文无效** — 中文字形本来就是"全大写"状态。中文标题去掉 `text-transform: uppercase` 规则
- **字重 900 在中文下太重** — 中文 h1 建议 700,比英文 900 略轻
- **letter-spacing 对中文要减少** — `letter-spacing: -0.03em` 在中文会显得挤,中文段落用 0

可以用 `:lang(zh)` 选择器做自适应:

```css
:lang(zh) h1, :lang(zh) h2 {
  text-transform: none;
  font-weight: 700;
  letter-spacing: 0;
}
```

**中文红关键词**用 `.k-cn`(粗衬线) 还是 `.k`(sans 单纯染红)?Swiss Grid 不用 serif,所以中文关键词直接沿用 `.k` 染红即可 —— 没有字族反差对齐问题,因为整系统都是 sans。

---

## 9. 和 PRINCIPLES.md 的协作

本文件**只讲风味**。生成一个 Swiss Grid 页面的完整流程:

1. 先按 PRINCIPLES.md 规划结构
2. 按本文件应用 Swiss 视觉(黑白红 / Inter / 12 栏 / uppercase / 模数间距)

**Swiss Grid 对 PRINCIPLES 的翻译**:

- **原则 1(结构多样性)**:Swiss 替代 3 列卡片的是**表格、12 栏分区、数字墙、规则线分隔段**。混用这些,不要通篇都是 row
- **原则 2(密度跳变)**:Swiss 适合在密集表格旁放一个**大留白的 hero 式 pull 引语**。反差极大
- **原则 3(留白节奏)**:Swiss 的留白是**模数化**的,但"哪个元素周围有更大留白"就是节奏
- **原则 4(强调节制)**:全页红色事件 ≤ 3 次。每个 h2 最多 1 红
- **原则 5(作者痕迹)**:Swiss 适合放 `Issue No. 001`、`Berlin / Apr 2026`、`Volume 3` 这类期刊式元信息
- **原则 6(打破齐整)**:见第 6 节"唯一的打破齐整"——Swiss 越严格,打破越重要

**节制陷阱**:Swiss 的极简看起来容易做,实际**最难**。因为所有装饰都被拿走了,任何对齐错误、字号不在 modular scale 上、红色出现第四次,都会**立刻显得 off**。AI 生成后必须**逐元素对照 modular scale 检查**。

---

## Appendix · Token 速查

```css
:root {
  --bg:         #ffffff;
  --text:       #000000;
  --text-sub:   #222222;
  --text-mid:   #444444;
  --text-dim:   #999999;
  --accent:     #ff1f1f;
  --line-thin:  rgba(0,0,0,0.08);
  --line-thick: #000000;

  --sans: 'Inter', 'Noto Sans SC', -apple-system, sans-serif;
  --mono: 'JetBrains Mono', 'SF Mono', monospace;
}
```

### Modular scale 字号速查

| 用途 | px |
|---|---|
| 最大标题 / 数字墙 | 80 |
| h1 | 56 |
| h2 | 40 |
| 副大号 | 32 |
| h3 / 引语 | 24 |
| sub-lead | 20 |
| 正文 | 16 |
| 副文 | 14 |
| 标签 / 元信息 | 12 |

---

**Credits**:风味由 X 和小克提炼。参考气质来自 Müller-Brockmann / Josef Müller-Hofmann 的经典瑞士学派出版物。
**License**:MIT · **Author**:X & 小克,2026-04-23
