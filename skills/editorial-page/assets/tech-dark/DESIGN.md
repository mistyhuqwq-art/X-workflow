# Tech Dark · 风味规范

> **使用前提**:先读 [`../PRINCIPLES.md`](../PRINCIPLES.md)——通用排版原则不在此重复。
> 本文件只讲 Tech Dark **这一种风格** 的视觉选择。

---

## 1. 风格定位

**关键词**:Modern Dark / Warm Neutral / Developer-first / Terminal-inspired

**情感基调**:克制、硬核、专注、技术性而非 AI 扮演

**适用场景**:开发者工具、API 平台、技术文档、CLI 产品、基础设施、严肃技术站、开源项目主页、技术博客

**不适用**:面向普通消费者的产品、儿童/教育产品、金融理财、温暖叙事的内容站

### 和其他"深色风"的区别

- ❌ 不是"AI 创业公司模板风"(青紫渐变 + 玻璃拟态 + 呼吸灯堆砌)
- ❌ 不是"Cyberpunk"(霓虹多色 + 扫描线过强 + 故障美学)
- ✅ 是"现代克制的深色"(暖中性黑 + 单色 accent + 字族反差 + 可选荧光)

参考气质:开发者工具领域一线产品的官网——中性背景、不依赖彩色渐变建立科技感、靠排版节奏和字体选择拉层级。

---

## 2. 色彩

### 核心四色

```css
--bg:     #1c1b1a;  /* 暖中性黑(不是 #000,不是蓝调 #0a0e1a) */
--fg:     #fafaf9;  /* 冷白主文字 */
--accent: #9eff00;  /* Lime 电光绿(默认选择) */
--line:   rgba(255,255,255,0.08);  /* hairline 分割线 */
```

### 暖灰阶梯

```css
--fg-sub:   #a8a29e;  /* 副文字 / 标签 */
--fg-muted: #78716c;  /* 弱化文字 / 章节标签 */
--fg-dim:   #57534e;  /* 最弱文字 / 编号 / 辅助元素 */
```

**关键:用暖灰(tan/stone 色系),不用冷灰(slate/zinc)**。暖灰让深色不那么工业,更有人味。区分方法:暖灰在 RGB 里 R > B,冷灰 R < B 或接近。

### Accent 可选色

Tech Dark 的 accent 不锁死,**一次只用一个主色**。常用选择:

| Accent | Hex | 气质 | 适合 |
|---|---|---|---|
| **Lime**(默认) | `#9eff00` | 硬核、terminal 血统 | 开发者工具、CLI、底层基础设施 |
| Mango | `#ff6b35` | 温暖、个人作品 | 工程师个人站、独立开发者产品 |
| Rose | `#ff3860` | 直接、商业 | SaaS 首页、需要高转化的站 |
| Citron | `#e5ff4c` | 怪诞、记忆点 | 独立创作者、个性工具 |
| Cyan-Violet | `#00e6c8` → `#7c5cff` | 科技未来感 | AI 产品、基础设施 landing、发布页 |
| Sky | `#3b82f6` | 稳重可信 | 企业级产品、API 平台 |

**渐变 accent 允许**(如 Cyan-Violet 的青紫渐变)—— 这不是 AI 味儿的元凶,PRINCIPLES.md 已经讲清:真正的 AI 味在排版层(结构可预测/密度均一/无作者痕迹),不在颜色。只要 PRINCIPLES 6 条把关了,颜色可以自由。

**注意**:页面同时只用**一个** accent 色相(或一组同色系渐变)。不要在同一页混用 Lime + Cyan-Violet,会破坏焦点。

### 色彩使用比例

- **85%** 背景 + 暖灰文字(主体灰调)
- **10%** 冷白主文字(标题、重要内容)
- **≤5%** accent(关键词、按钮、极少数边框强调)

---

## 3. 字体

### 字体栈

```css
--sans:  'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
--serif: 'Source Serif 4', Georgia, serif;  /* 仅用于 italic accent */
--mono:  'JetBrains Mono', 'SF Mono', Menlo, monospace;
```

**Google Fonts 加载**:
```
https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&family=Source+Serif+4:ital,wght@1,400&family=JetBrains+Mono:wght@400;500&display=swap
```

### 分工(严格)

| 元素 | 字体 | 字重 | 备注 |
|---|---|---|---|
| h1 主标题 | Inter | 500 | 不用 700/900(会过重) |
| h2/h3 | Inter | 500-600 | |
| 正文 | Inter | 400 | |
| **Accent 关键词** | **Source Serif 4 italic** | 400 | ⭐ 字族反差,不是颜色反差 |
| 标签 / 章节小标题 | JetBrains Mono | 500 | uppercase + letter-spacing 0.06em |
| 编号 / 版本号 / 元信息 | JetBrains Mono | 400 | |
| 数字墙大数字 | Inter | 300-400 | Tech Dark 的数字不用衬线 |

### 字号(偏现代无衬线的节奏)

```
h1: clamp(44px, 5.5vw, 64px)  font-weight 500  line-height 1.02  letter-spacing -0.04em
h2: clamp(28px, 3.6vw, 36px)  font-weight 500  line-height 1.1   letter-spacing -0.025em
h3: 17-18px                    font-weight 500
正文: 14-15px                   font-weight 400  line-height 1.55
辅助: 12-13px                   font-weight 400
标签: 11px                     font-weight 500  uppercase  letter-spacing 0.06em mono
```

### Accent 的字族反差(本风格签名)

Tech Dark **用字体族差异制造视觉焦点,不主要靠颜色**。典型做法:

```html
<h1>Engineered for those who <span class="k">ship</span>.</h1>
```

```css
h1 { font-family: var(--sans); font-weight: 500; color: var(--fg); }
h1 .k {
  font-family: var(--serif);
  font-style: italic;
  font-weight: 400;
  color: var(--accent);  /* 颜色是辅助 */
}
```

**为什么**:纯色 accent 会被"就是加了个颜色"消解;一笔 italic serif 的字族反差,让关键词在 sans-serif 的主体里**物理上**跳出来,才是 Tech Dark 高级感的来源。

### Italic 关键词的呼吸空间

中文字型本身方正紧密,斜体叠加时和前后字会挤在一起。给斜体关键词加左右 padding:

```css
h1 .k { padding: 0 0.15em; }
h2 .k { padding: 0 0.12em; }
```

### ⚠️ 中文关键词用 `.k-cn` 不用 `.k`

中文没有真 italic 字形,浏览器做人工歪斜(transform 矩阵),导致**视觉基线偏移、和前后字对不齐**。
所以:
- **英文关键词** → 用 `<span class="k">ship</span>`(italic serif)
- **中文关键词** → 用 `<span class="k-cn">真实</span>`(粗衬线 normal style,不 italic)

```css
h1 .k-cn { font-family: serif; font-weight: 700; font-style: normal; padding: 0 0.1em; }
h2 .k-cn { font-family: serif; font-weight: 700; font-style: normal; padding: 0 0.08em; }
```

**核心判断**:写 `<span>` 前看里面是中文还是英文。中英混的短语(极少数),**整体走 `.k-cn`** 避免局部对不齐。

**为什么选粗衬线而非其他方案**:保留了 sans 正文 vs serif 关键词的**字族反差**(tech-dark 的签名),只是不歪。和英文 italic 形成"英斜/中粗"的互补。

---

## 4. 布局选择

### 容器

```css
max-width: 920px;
padding: 80px 56px;  /* 移动端 64px 32px */
```

比 Warm Editorial 的 960px 略窄,比普通全宽更聚焦。

### 垂直节奏

```
section padding:  72px 0 (紧凑于 Warm 的 80px)
hero padding:     96px 0 64px
hairline 上下:    40-48px 留白
章节内段落:       40-56px
```

### 章节结构(Tech Dark 特色)

```html
<section>
  <div class="tag">PRINCIPLES</div>        <!-- Mono uppercase 小标签 -->
  <h2>Three <span class="k">ideas</span> we won't compromise</h2>
  <p class="lead">副标题,说明本节要讲什么。</p>
  <div class="hairline"></div>              <!-- ⭐ 本风格标志:发丝线代替卡片边框 -->
  <!-- 内容区块... -->
</section>
```

---

## 5. 核心组件

本风格推荐使用的区块(CSS 定义见 `template.html`):

| 组件 | 用途 | Tech Dark 特色 |
|---|---|---|
| `.hero` | 页首 | 无红条(用 `.kicker` 元信息替代),标题 italic 关键词 |
| `.kicker` | 小标识 | `—  PRODUCT · 2026` 形式,Mono 字体 |
| `.hairline` | 分割线 | 1px `rgba(255,255,255,0.08)`,替代卡片边框分隔区域 |
| `.tag` | 章节小标签 | JetBrains Mono + uppercase + `#78716c` |
| `.stack` + `.row` | **列表式排版** ⭐ | 替代 3 列卡片网格。每行 `[编号][标题+描述][右侧小标签]` |
| `.grid` | 2-3 列布局 | 必要时用,不要默认用 |
| `.code-block` | 深色代码块 | 背景 `#0f0e0c`(比主背景更深) |
| `.cta-row` | CTA 按钮组 | 主按钮 accent 实色,次按钮 ghost |
| `.chip` | 版本/状态标签 | Mono + accent-dim 背景 |

### 列表式排版(`.stack` + `.row`)

这是 Tech Dark 的**排版签名**。当 Warm Editorial 会用 3 列卡片网格时,Tech Dark 改用纵向列表:

```html
<div class="stack">
  <div class="row">
    <div class="num">01</div>
    <div class="body">
      <h3>Restraint over flair</h3>
      <p>单色 accent、hairline、充分留白。</p>
    </div>
    <div class="tag-end">typography</div>
  </div>
  <!-- 更多 row... -->
</div>
```

**为什么**:列表比卡片更"文本化",更符合 Tech Dark 的克制气质;也和 PRINCIPLES 原则 1(结构多样性)呼应——避免 AI 模板化的卡片网格。

---

## 6. 基础装饰

### 默认元素(所有 Tech Dark 页面都用)

- **Hairline 分割线** `rgba(255,255,255,0.08)` 1px —— 替代卡片边框的主要分隔手段
- **字族反差 accent** —— Source Serif italic 当关键词
- **Mono 标签** —— 所有章节/元信息用 JetBrains Mono
- **暖灰阶梯** —— 不用冷 slate/zinc

### 几条最弱的约束(避免套路化,非装饰禁忌)

- **页面同时只用一个 accent 主色** —— 不混用 Lime + Rose + Cyan。焦点要集中
- **避免"打卡式"模板流** —— 这由 PRINCIPLES 原则 1(结构多样性)把关
- **不依赖纯颜色传达信息** —— a11y 基本要求

> 注意:我们**不**禁止玻璃拟态、呼吸灯、青紫渐变、跨色相渐变、阴影等具体视觉手段。PRINCIPLES.md 已经从排版层把关 —— 只要结构有多样性、密度跳变、留白有节奏、强调节制、有作者痕迹、打破齐整,任何视觉手段都是**工具**而不是问题。

---

## 7. 表现力开关(fx-rich)

Tech Dark 提供一个**总开关**,用同一套排版/色彩/字体,给两种表现力:

### 默认:克制版

`<body>` 无 class。纯色 accent,无 glow,无渐变。适合:
- 📄 文档页 / API 参考 / 变更日志 / README 展示
- 📝 技术博客内容页
- 🔬 规范类、严肃类内容

### 开启 `fx-rich`:丰富版

`<body class="fx-rich">`。自动生效的效果:
- **Hero 背景 radial glow** —— accent 色极淡辐射光斑,不跨色相
- **关键词荧光扩散** —— `h1 .k` / `h2 .k` 的 italic serif 加 text-shadow
- **CTA 渐变 + 发光边缘** —— 主按钮从 accent 亮色到原色,hover 微微悬浮
- **Hairline 带 accent 起点** —— 分割线开头 30% 有 accent 渐入
- **极细 CRT 扫描线** —— 全页 2.5% 透明水平扫描线
- **可选呼吸灯** —— `.kicker.pulse` 会在右侧加一个 accent 呼吸点

### 何时用 `fx-rich`

✓ 品牌主页、产品 landing、发布公告、活动邀请
✓ Hero 需要"品牌张力"、希望访客停留的场景
✓ 投资人 pitch 页、融资宣传

✗ 文档页、博客内容、变更日志(读者目标是"读懂",不需要呼吸感)
✗ 内容密集的长文(glow 会和密集文字互相干扰)

**关键判断问题**:"这页访客进来,主要目的是阅读信息,还是被吸引?"
阅读 → 默认。被吸引 → `fx-rich`。

### 实现细节

所有效果已经在 `template.html` 里写好,作用域限制在 `body.fx-rich` 下。
切换只需要改一行 HTML:

```html
<body>                 <!-- 克制版 -->
<body class="fx-rich"> <!-- 丰富版 -->
```

不用改 CSS,不用改内容,不用改结构。

---

## 8. 可访问性 & 打印

### `<head>` 必填

```html
<meta name="description" content="一句话概括本页">
<meta name="color-scheme" content="dark">  <!-- Tech Dark 声明只做暗色 -->
<meta property="og:title" content="...">
<meta property="og:description" content="...">
```

### 键盘聚焦

```css
a:focus-visible, button:focus-visible {
  outline: 2px solid var(--accent);
  outline-offset: 3px;
  border-radius: 2px;
}
```

### 动效偏好(尤其 optional glow 启用时)

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    transition-duration: 0.01ms !important;
    animation-duration: 0.01ms !important;
  }
}
```

### 对比度

核心色对 `#1c1b1a` 的对比度:
- `#fafaf9` 主文字 ≈ 16:1 ✓✓
- `#a8a29e` 副文字 ≈ 7.5:1 ✓ AA
- `#78716c` 弱文字 ≈ 4.8:1 ✓ AA
- `#9eff00` accent 对深背景对比充足

### 打印样式

Tech Dark 的深色默认 **不打印** —— 页面检测到 print 环境时 **反转为浅色**(否则打印机会烧墨):

```css
@media print {
  @page { margin: 16mm 14mm; }
  body {
    background: #fff !important;
    color: #1a1a1a !important;
    -webkit-print-color-adjust: exact;
  }
  .hairline, h1, h2 { color: #1a1a1a !important; }
  h1 .k, h2 .k, .tag { color: #4a1a6e !important; }  /* accent 在白底用深紫 */
  .btn-primary { background: #4a1a6e !important; color: #fff !important; }
  a[href^="http"]::after {
    content: " (" attr(href) ")";
    font-size: 0.85em; color: #666;
  }
}
```

---

## 9. 和 PRINCIPLES.md 的协作

本文件**只讲风味**。生成一个 Tech Dark 页面的完整流程:

1. **先按 PRINCIPLES.md** 规划结构(≥4 种区块 / 密度跳变 / 留白节奏 / 强调节制 / 作者痕迹 / 打破齐整)
2. **再按本文件** 应用 Tech Dark 视觉选择(暖中性黑 / Inter + italic serif accent / hairline 列表式)
3. **判断表现力档位** —— 读阅读类? 默认克制。吸引类? `<body class="fx-rich">`
4. **颜色自由,排版严守** —— PRINCIPLES 6 条过了,颜色/渐变/光效都是工具

**特别提醒 Tech Dark 对 PRINCIPLES 的翻译**:
- 原则 1(结构多样性):Tech Dark 尤其要避免"3 列卡片",默认改成列表式 `.stack + .row`
- 原则 4(强调节制):不是指不能用光效,而是指"全页重点不能太多"。一个 fx-rich 页面仍然可以只有 1-2 处 accent 聚焦
- 原则 5(作者痕迹):Tech Dark 适合放 version 号、commit hash、build time 这些真实技术元素作为"作者痕迹"
- 原则 6(打破齐整):Tech Dark 可以放一处手写注释、一段 ascii art、一个不对齐的版本号作为个性锚点

**关于光效和 AI 味的澄清**:
在 v2.1 之前本文件曾规定"禁止青紫渐变/禁止呼吸灯/禁止阴影",这是个**错误归因**。后来我们发现:
- Stripe / Vercel / Linear 用渐变,气质高级
- 很多扁平纯色站反而 AI 味更重(因为排版模板化)

真正的 AI 味是排版语法问题,不是视觉手段问题。PRINCIPLES 6 条守住排版,Tech Dark 的视觉手段就可以放开。

---

## Appendix · Token 速查

```css
:root {
  /* Background & text */
  --bg:       #1c1b1a;
  --fg:       #fafaf9;
  --fg-sub:   #a8a29e;
  --fg-muted: #78716c;
  --fg-dim:   #57534e;
  --line:     rgba(255,255,255,0.08);

  /* Accent (替换为你选的色即可) */
  --accent:     #9eff00;
  --accent-dim: rgba(158,255,0,0.12);

  /* Fonts */
  --sans:  'Inter', -apple-system, sans-serif;
  --serif: 'Source Serif 4', Georgia, serif;
  --mono:  'JetBrains Mono', 'SF Mono', monospace;
}
```

---

**Credits**:风味由 X 和小克提炼,v1 基于 `dark-accent-preview.html` 的 Lime 纯色版整理。
**License**:MIT · **Author**:X & 小克,2026-04-23
