# Brutalist · 风味规范

> **使用前提**:先读 [`../PRINCIPLES.md`](../PRINCIPLES.md) —— 通用排版原则不在此重复。
> 本文件只讲 Brutalist **这一种风格** 的视觉选择。

---

## 1. 风格定位

**关键词**:Brutalist / Loud typography / High-contrast / Design with conviction

**情感基调**:张扬、直白、有观点、拒绝客气。**不是**"设计粗糙"——是"**故意不精致**的精致"

**核心理念**:**Design should shout, not whisper**。当其他风味用节制说话,Brutalist 用**超粗字重 + 纯黄纯黑 + 故意的歪斜/错位**大声说话。它有一种"我不装客气"的态度 —— 适合观点强、立场明确、需要立刻被记住的场景。

**适用场景**:活动海报、观点宣言、创始人声明、强主张分享会、竞选/倡议页、反叛品牌、非盈利冲击性传播、音乐节 landing

**不适用**:严肃商务 / SaaS 日常页 / 儿童教育 / 医疗健康 / 高龄用户产品 / 需要柔和温度的场景

### 和其他"张扬"风味的区别

- ❌ 不是 Retro(retro 是糖果温柔的"玩心", Brutalist 是硬核的"声量")
- ❌ 不是 Swiss Grid(Swiss 秩序至上, Brutalist 故意打破秩序)
- ❌ 不是 Cyberpunk/Neon(Brutalist 不靠荧光,只靠黑黄二元)
- ✅ 是**"有观点的排版"** —— 字体即声量,不靠任何装饰特效

参考气质:90 年代 punk zine、David Carson 的 Ray Gun 杂志、现代 Gen-Z 政治海报、独立音乐节主页。

---

## 2. 色彩

### 核心二色(警示色逻辑)

```css
--bg:     #ffe500;    /* 鲜黄底(高饱和,不是奶油黄) */
--text:   #000000;    /* 纯黑 */
--bg-alt: #000000;    /* 反色块背景(黑底反衬黄字) */
--fg-alt: #ffe500;    /* 反色块文字 */
```

### 辅助色(非常节制)

```css
--fg-sub:  #222222;   /* 副文字,几乎还是黑 */
--line:    #000000;   /* 所有边框都是纯黑 */
```

### 可选 pop 色(最多 1 种,用于单个强调)

Brutalist 默认只用黑黄。如果需要第二色,**只能选一种**这三选一:

```css
--pop-red:    #ff2e2e;  /* 警报红 */
--pop-pink:   #ff4fa3;  /* 荧光粉 */
--pop-cyan:   #2effea;  /* 霓虹青 */
```

Pop 色用法:**只在一个位置出现一次**,作为 hero 的一笔 accent 或 sticker 背景。不能多处重复使用 pop 色,否则失控。

### 色彩哲学

Brutalist 的黄黑是**警示色**,它本来就在说"注意看我"。这是整个风格的气质来源 —— 黄是路标的黄、警告的黄、工程帽的黄,不是温柔的黄。

### 严格禁忌

- ❌ 柔和的黄(奶油黄、米黄 —— 那是 Retro 的活)
- ❌ 渐变(Brutalist 只用实色块)
- ❌ 阴影模糊(只用 chunky 硬偏移阴影)
- ❌ 灰色调和剂(黄到黑之间不经过灰色过渡)
- ❌ 多种 pop 色并列(只能有一种)

---

## 3. 字体

### 字体栈(两个超粗字体族)

```css
--sans:    'Space Grotesk', 'Noto Sans SC', -apple-system, sans-serif;
--display: 'Archivo Black', 'Space Grotesk', 'Noto Sans SC', sans-serif;  /* h1/h2 的超重显示字 */
--mono:    'JetBrains Mono', 'SF Mono', monospace;
```

**Archivo Black** 是开源的超粗 display 字体,只有 900 一个字重。用来代替或补充 Space Grotesk 的 700。

**Google Fonts 加载**:
```
https://fonts.googleapis.com/css2?family=Archivo+Black&family=Space+Grotesk:wght@500;700&family=JetBrains+Mono:wght@400;500;700&family=Noto+Sans+SC:wght@500;700;900&display=swap
```

### 分工

| 元素 | 字体 | 字重 | 备注 |
|---|---|---|---|
| h1 | Archivo Black | 900 | clamp(56px, 9vw, 112px) uppercase |
| h2 | Archivo Black | 900 | clamp(36px, 5vw, 56px) uppercase |
| h3 | Space Grotesk | 700 | 20px |
| 正文 | Space Grotesk | 500 | 16-17px |
| 印章/按钮 | Space Grotesk | 700 | 12-14px uppercase letter-spacing 0.1em |
| 元信息/章节编号 | JetBrains Mono | 700 | 11-12px uppercase |

### 字号(故意极端对比)

```
h1: clamp(56px, 9vw, 112px)   ← 非常大
h2: clamp(36px, 5vw, 56px)    ← 依然大
h3: 20px                       ← 然后骤降
正文: 16-17px                  ← 正文正常
```

**h1 到正文是断崖式跳跃**(112px → 16px),这是 Brutalist 的招牌 —— 让标题**物理上**大到无法忽视。

### Brutalist 签名技巧

**① 标题关键词"黑底块"**

把关键词包在**黑色实色块 + 黄色文字**,并轻微歪斜:

```html
<h1>Design should <span class="k">SHOUT</span>, not whisper.</h1>
```

```css
h1 .k {
  background: var(--bg-alt);
  color: var(--fg-alt);
  padding: 0 0.2em;
  display: inline-block;
  transform: skewX(-4deg);
}
```

**② 粗黑边框引语**

副标题用**左侧超粗 6-8px 黑边**标示:

```css
.hero-sub {
  border-left: 8px solid var(--line);
  padding-left: 18px;
  font-weight: 500;
}
```

**③ 歪斜印章 sticker**

实色块 + 超粗字重 + 旋转 -3 到 -5 度:

```css
.stamp {
  background: var(--text);
  color: var(--bg);
  padding: 6px 14px;
  font-family: var(--mono);
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.12em;
  transform: rotate(-3deg);
  display: inline-block;
}
```

**④ 完全没有圆角**

所有元素 `border-radius: 0`。即使是按钮、block quote、sticker,都是方角。

**⑤ 粗框方块(blocks)**

卡片式内容用**黑底黄字**(或**黄底黑字 + 黑粗边**)交错:

```css
.block { background: var(--text); color: var(--bg); padding: 24px; }
.block.inverse { background: var(--bg); color: var(--text); outline: 3px solid var(--text); outline-offset: -3px; }
```

**不用 box-shadow 硬偏移** —— Retro 的玩心用 chunky 阴影,Brutalist 更狠:用**实色反色块交错**,几乎没有阴影。

---

## 4. 布局选择

### 容器

```css
max-width: 1100px;    /* 宽容器,让标题大字有展开空间 */
padding: 64px 48px;
```

不像 Warm (960)/Minimal (680) 那么窄 —— Brutalist 的大标题需要横向空间。

### 垂直节奏

```
section padding:  64px 0
hero padding:     48px 0 72px
超大分割线:        4-6px 黑实线 margin: 48px 0
段落间距:         24-32px
```

### 全宽/反色块/错位

Brutalist 喜欢"**某个元素故意跨出容器边界**"的手法。例如 hero 的超大标题宽度 = viewport 宽,左右内边距独立计算。这种越界是**风格的一部分**。

---

## 5. 核心组件

| 组件 | 用途 | Brutalist 特色 |
|---|---|---|
| `.hero` | 页首 | 左对齐超大标题 + 粗黑边引语 + 歪斜 stamp |
| `.stamp` | 歪斜印章 | 黑底黄字 Mono 超粗 + 旋转 -3~-5deg |
| `.blocks` | 反色块网格 | 2-3 列,黑底黄字/黄底黑边交错,无间隙 |
| `.block` | 单块 | 反色或正色,粗边框,数字特别大 |
| `.bar` | 超粗分隔 | 4-6px 黑实线,全宽 |
| `.btn` | 按钮 | 方角实色,无圆角,粗黑边 |
| `.screamer` | 超级声量段 | 整栏,96pt+ 字号,直接喊出一句话 |

### 反色块网格(签名)

```html
<div class="blocks">
  <div class="block"><div class="num">01</div><h3>Loud</h3><p>说人话不装客气。</p></div>
  <div class="block inverse"><div class="num">02</div><h3>Weird</h3><p>歪斜是特性。</p></div>
  <div class="block"><div class="num">03</div><h3>On purpose</h3><p>不是 bug,是选择。</p></div>
</div>
```

- 第一块:黑底黄字
- 第二块:黄底黑边(inverse)
- 第三块:黑底黄字

用反色交错制造"印章感"。

### Screamer(大声区)

```html
<section class="screamer">
  <div class="screamer-text">SAY IT<br>LOUD.</div>
  <div class="screamer-sub">不是所有东西都要精致。</div>
</section>
```

`.screamer-text` 字号 `clamp(80px, 14vw, 180px)`,**真的大到占满屏**。这是 Brutalist 的礼物 —— 在其他风味都讲"克制"的时候,这里允许你**直接喊出来**。

---

## 6. 装饰约定

### ✅ 使用

- **黑色实色块 + 黄字** —— 所有反差
- **4-6px 粗黑边框** —— 方块/按钮/重要区域
- **歪斜 -3 到 -5 度** —— 印章、关键词色块,**仅此二者**歪斜
- **超粗字重** —— 900 Archivo Black,正文 500-700
- **uppercase** —— 所有小标签、印章、按钮的英文
- **`█` 方块字符** 作为装饰前缀(如 `█ MANIFESTO`)

### ❌ 禁止

- 圆角(任何元素)
- 阴影(box-shadow,除非明显作为装饰块的硬偏移且 ≤ 4px)
- 渐变 / backdrop-filter
- 细线(Brutalist 只用粗线 ≥ 3px)
- 多种 pop 色同时出现
- 细字重(低于 500)
- 柔和装饰(波浪线、细虚线、虚框)

### ✨ 允许的打破齐整

Brutalist 本来就有"歪斜"的属性,所以 PRINCIPLES 原则 6 的"打破齐整"在这里容易过度。节制点:

- **一页最多 2-3 处歪斜元素**(印章、关键词块)
- **一处故意"越界"**(一个块延伸出容器 20-40px)
- 可以有**手写字体的一句话**(用 `Caveat` 或 `Permanent Marker` 字体)作为页面"作者痕迹"
- 禁止**每一个元素都歪斜** —— 那就不叫打破齐整,叫混乱

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
  outline: 4px solid var(--text);    /* Brutalist 的 focus 线特别粗 */
  outline-offset: 4px;
}
```

### 动效偏好

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after { transition-duration: 0.01ms !important; }
  .stamp, h1 .k { transform: none !important; }   /* 停掉所有歪斜 */
}
```

### 对比度

- 黑 `#000` on 鲜黄 `#ffe500` ≈ 16:1 ✓✓✓
- 黄 on 黑 ≈ 16:1 ✓✓✓
- 所有对比度都充分,因为 Brutalist 本来就是高对比

### 打印样式

```css
@media print {
  @page { margin: 16mm 14mm; }
  body {
    background: #fff !important;
    color: #000 !important;
    -webkit-print-color-adjust: exact;
    print-color-adjust: exact;
  }
  /* 保留黑黄反差,但黄底转白底避免烧墨 */
  .block { background: #f0f0f0 !important; color: #000 !important; border: 2px solid #000 !important; }
  .block.inverse { background: #fff !important; color: #000 !important; }
  .stamp { background: #000 !important; color: #fff !important; transform: none !important; }
  h1 .k { background: #000 !important; color: #fff !important; transform: none !important; }
  section, .blocks { page-break-inside: avoid; }
  h1, h2 { page-break-after: avoid; }
  a[href^="http"]::after { content: " (" attr(href) ")"; font-size: 0.85em; color: #666; }
}
```

---

## 8. 中文处理(重要)

Brutalist 是**拉丁字母文化产物**,中文适配要注意:

### 关键词处理

- **英文关键词黑块**用 `.k`(skewX 歪斜 + padding 0.2em)
- **中文关键词黑块**用 `.k-cn`:保留黑底黄字和 padding,**但不歪斜**(中文字形本身方正,歪斜会挤在一起,和前后文对不齐)

```css
h1 .k {
  background: var(--text);
  color: var(--bg);
  padding: 0 0.2em;
  transform: skewX(-4deg);     /* 英文歪斜 */
  display: inline-block;
}
h1 .k-cn {
  background: var(--text);
  color: var(--bg);
  padding: 0 0.15em;
  /* 不加 transform */
  display: inline-block;
}
```

### 字重处理

Archivo Black 不包含中文字形,中文 h1 会 fallback 到 Noto Sans SC 900。这在视觉上和 Archivo Black 会有**字重厚度差**,需要接受这个事实(或者硬上 Noto Sans SC 900 同时用于英文)。

### Uppercase 处理

```css
:lang(zh) h1, :lang(zh) h2 {
  text-transform: none;  /* 中文不 uppercase */
}
```

---

## 9. 和 PRINCIPLES.md 的协作

本文件**只讲风味**。生成一个 Brutalist 页面的完整流程:

1. 先按 PRINCIPLES.md 规划结构
2. 按本文件应用 Brutalist 视觉(黑黄 / Archivo Black / 歪斜印章 / 反色块)

**Brutalist 对 PRINCIPLES 的翻译**:

- **原则 1(结构多样性)**:Brutalist 不要通篇 block,混用 screamer + 反色块 + 大引语 + 印章行
- **原则 2(密度跳变)**:Brutalist 的密度跳变是**字号跳变**—— 112px 标题 + 16px 正文 + 180px screamer,多重断崖
- **原则 3(留白节奏)**:Brutalist 的**标题占满屏**就是一种留白 —— 一个字撑一整行比三个字撑半行更有冲击
- **原则 4(强调节制)**:Brutalist 危险 —— 所有元素都想"大声"。必须**克制"声量数量"**:一页最多 2-3 处歪斜 + 1 个 screamer + 1 处 pop 色
- **原则 5(作者痕迹)**:Brutalist 适合放 **"shipped from a basement / made at 3am / one-person team" 这种反客套** 的签名,而不是 warm 的文雅署名
- **原则 6(打破齐整)**:Brutalist 本来就不齐,但允许**一处"居然齐"**(比如所有块都歪的情况下,有一个元素老老实实居中对齐) 作为反打

**声量陷阱**:Brutalist 容易让 AI "一路大声"——每一行都加大字号、每一个字都加黑块,结果变成**噪音**。记住:**大声是选择性的武器,不是默认状态**。页面的 95% 应该是正常正文,只有 5% 是 Brutalist 的"标志性时刻"。

---

## Appendix · Token 速查

```css
:root {
  --bg:      #ffe500;
  --text:    #000000;
  --bg-alt:  #000000;
  --fg-alt:  #ffe500;
  --fg-sub:  #222222;
  --line:    #000000;
  /* 可选 pop (三选一,不同时用) */
  --pop-red:  #ff2e2e;
  --pop-pink: #ff4fa3;
  --pop-cyan: #2effea;

  --sans:    'Space Grotesk', 'Noto Sans SC', -apple-system, sans-serif;
  --display: 'Archivo Black', 'Space Grotesk', 'Noto Sans SC', sans-serif;
  --mono:    'JetBrains Mono', 'SF Mono', monospace;
}
```

---

**Credits**:风味由 X 和小克提炼。参考气质来自 90s punk zine、David Carson 的 Ray Gun、现代独立海报设计。
**License**:MIT · **Author**:X & 小克,2026-04-23
