# Retro · 风味规范

> **使用前提**:先读 [`../PRINCIPLES.md`](../PRINCIPLES.md) —— 通用排版原则不在此重复。
> 本文件只讲 Retro **这一种风格** 的视觉选择。

---

## 1. 风格定位

**关键词**:Retro-inspired / Candy colors / Chunky shadows / Modern bones, nostalgic skin

**情感基调**:玩心、温度、有记忆点、轻松

**核心理念**:**以风为重** —— 现代排版骨架 + 复古质感皮肤。不是做 8-bit 像素 UI,也不是 80 年代赛博朋克。是"糖果色 + 粗边框硬阴影 + CRT 细扫描线"用在**现代结构**上。

**适用场景**:创作者作品集、活动邀请、有玩心的产品站、社区页、独立游戏站、儿童/教育轻量产品、播客/音乐人页

**不适用**:严肃商务、开发者工具(选 tech-dark)、金融、医疗、面向高龄用户的严肃产品

### 和其他"复古风"的区别

- ❌ 不是"8-bit Pixel UI"(全 pixel 字体 + 像素化图标 + Pico-8 UI)
- ❌ 不是"Cyberpunk 80s"(霓虹网格 + 立体字 + 赛博夜店感)
- ❌ 不是"Brutalist"(粗野堆叠 + 故意丑)
- ✅ 是"现代骨 + 复古质感"(糖果色 + chunky 阴影 + CRT 低扫 + 标准排版节奏)

参考气质:大厂周年活动页的"复古主题"、独立小游戏站、90 年代杂志排版的数字化回响。

---

## 2. 色彩

### 核心调色板

```css
--bg:        #fbf1e0;   /* 奶油底(带一点奶黄,比纯白温暖) */
--text:      #2a1f3d;   /* 深紫黑文字(不用纯黑,更柔) */
--text-sub:  #4a3d66;   /* 副文字 */
--text-dim:  #8b7ea8;   /* 弱化文字 */
--line:      #2a1f3d;   /* 边框色同主文字(粗边框特征) */

/* 糖果三色(卡片/强调区域用) */
--candy-pink:  #ffdbe5;  /* 奶粉 */
--candy-blue:  #c7e0f4;  /* 天空蓝 */
--candy-yellow:#fff3b0;  /* 奶油黄 */

/* Accent(强调色,用在按钮/链接/小强调) */
--accent:      #ec4899;  /* 玫红 */
--accent-alt:  #4f8ec7;  /* 天蓝 */
```

### 配色原则

- **奶油底 + 深紫黑文字** 是主体对比,不用纯白纯黑(那是 minimal-mono 的活)
- **糖果三色轮换使用** —— 3 张卡片可以依次 pink/blue/yellow,但一次用尽,不堆砌第四色
- **Accent 玫红** 用在 CTA 按钮、链接下划线、pixel 标签色点
- **天蓝 alt** 是 h1 第二关键词的颜色(和玫红配合形成双关键词强调)

### 不允许

- 霓虹色 / 高饱和荧光色(会滑向 Cyberpunk)
- 纯黑 `#000` / 纯白 `#fff`(奶味丢失)
- 渐变(Retro 靠实色块 + chunky 阴影,不靠渐变)

---

## 3. 字体

### 字体栈

```css
--sans:  'Space Grotesk', 'Noto Sans SC', -apple-system, sans-serif;
--serif: 'Source Serif 4', 'Noto Serif SC', Georgia, serif;  /* 仅 italic accent 关键词 */
--mono:  'JetBrains Mono', 'SF Mono', monospace;             /* 像素标签/元信息 */
```

**Google Fonts 加载**:
```
https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Source+Serif+4:ital,wght@1,400&family=JetBrains+Mono:wght@400;500&family=Noto+Sans+SC:wght@400;500;700&family=Noto+Serif+SC:ital,wght@1,400&display=swap
```

### 分工

| 元素 | 字体 | 字重 | 备注 |
|---|---|---|---|
| h1 主标题 | Space Grotesk | 700 | ⭐ 圆润的几何无衬线,带 retro 气质 |
| h2 / h3 | Space Grotesk | 700 | |
| 正文 | Space Grotesk | 500 | 比 400 略重,配合糖果色不易糊 |
| 强调词 accent(玫红) | Space Grotesk | 700 + 背景色块 + chunky 阴影 | 标志性 |
| 强调词 alt(italic serif) | Source Serif italic | 400 | 第二关键词,天蓝色 |
| 章节小标签 | JetBrains Mono | 700 | 前面加像素方块 |
| 版本/时间元信息 | JetBrains Mono | 500 | |

### Retro 的签名技巧

**① 关键词贴糖色块**

h1 里的主关键词包在**实色色块 + 3px 深紫黑边框 + 5px chunky 阴影 + 轻微歪斜**:

```html
<h1>Make things, <span class="k">share</span> them, <span class="k2">have fun</span>.</h1>
```

```css
h1 .k {
  background: #ffdbe5;
  padding: 0 12px;
  border: 3px solid #2a1f3d;
  box-shadow: 5px 5px 0 #2a1f3d;
  transform: rotate(-1.5deg);
  display: inline-block;
}
h1 .k2 {
  color: #4f8ec7;
  font-style: italic;
  font-family: var(--serif);
  font-weight: 400;
}
```

### ⚠️ 中文关键词用 `.k-cn` / `.k2-cn`

中文没有真 italic 字形,浏览器做人工歪斜会导致视觉基线偏移、和前后字对不齐。

- **英文 h1 第二关键词(italic 蓝色)** → `<span class="k2">ship</span>`(italic serif)
- **中文 h1 第二关键词** → `<span class="k2-cn">一起来玩</span>`(粗衬线 normal,蓝色)

- **英文 h2 关键词(italic 玫红色)** → `<span class="k">ideas</span>`(italic serif)
- **中文 h2 关键词** → `<span class="k-cn">三件事</span>`(粗衬线 normal,玫红色)

**保留的糖色块关键词**(h1 的 `<span class="k">`)不受影响 —— 它不依赖 italic,靠色块视觉即可,中英都能用。

---

**② 像素方块 bullet**

章节小标签前用 CSS `box-shadow` 模拟的 + 形像素装饰(不用实际 pixel art):

```css
.tag::before {
  content: ''; width: 10px; height: 10px;
  background: var(--accent);
  box-shadow:
    2px 0 0 var(--accent),  0 2px 0 var(--accent),
    -2px 0 0 var(--accent), 0 -2px 0 var(--accent);
  display: inline-block; margin-right: 8px;
  vertical-align: middle;
}
```

**③ chunky 阴影卡片**

所有卡片类元素都有 **3px 实色边框 + 5px 硬阴影**(不是软模糊阴影,是 pure offset):

```css
.card {
  border: 3px solid #2a1f3d;
  box-shadow: 5px 5px 0 #2a1f3d;
  border-radius: 8px;
  transition: transform 0.15s, box-shadow 0.15s;
}
.card:hover {
  transform: translate(-2px, -2px);
  box-shadow: 7px 7px 0 #2a1f3d;
}
```

**④ 细微 CRT 扫描线**(可选叠层)

2.5% 透明,只在近看时察觉,像印刷颗粒:

```css
body::after {
  content: '';
  position: fixed; inset: 0; pointer-events: none;
  background-image: repeating-linear-gradient(
    0deg, transparent 0, transparent 3px,
    rgba(42,31,61,0.025) 3px, rgba(42,31,61,0.025) 4px
  );
}
```

---

## 4. 布局选择

### 容器

```css
max-width: 900px;
padding: 80px 48px;    /* 移动端 56px 28px */
```

比 Warm 的 960 略窄一点,留出"相册边距"的感觉。

### 垂直节奏

```
section padding:  80px 0
hero padding:     96px 0 80px
卡片间 gap:       16-20px
元素间紧凑间距:    12-16px
```

### 章节结构

```html
<section>
  <div class="tag">THREE INGREDIENTS</div>     <!-- 带像素方块 -->
  <h2>Three <span class="k">ingredients</span></h2>  <!-- 关键词糖色块 -->
  <p class="lead">副标题,解释本节。</p>
  <!-- 糖果色卡片网格 / 其他... -->
</section>
```

---

## 5. 核心组件

| 组件 | 用途 | Retro 特色 |
|---|---|---|
| `.hero` | 页首 | **pixel-star 三菱点 ◆◆◆** + **pill 徽章**(chunky 阴影) + h1 双关键词 |
| `.pill` | 版本/状态徽章 | 白底 + 3px 边框 + 3px 阴影 + 呼吸灯小点 |
| `.tag` | 章节小标签 | 前缀像素方块 + Mono 700 + accent 玫红色 |
| `.rcard` + `.cards` | 糖果卡片网格 | 3 张卡,pink/blue/yellow 依次,chunky 边框阴影,hover 上推 |
| `.btn-primary` | 主按钮 | 玫红底 + 深紫边框 + 4px 阴影,"可点的方糖" |
| `.btn-ghost` | 次按钮 | 白底 + 深紫边框 |
| `.sticker` | 小装饰印章 | 歪斜 -4deg,mono 字体,白字深紫底 |

### 糖果卡片(Retro 签名)

三张卡,背景色依次轮换奶粉/天空蓝/奶油黄:

```html
<div class="cards">
  <div class="rcard"><!-- pink --></div>
  <div class="rcard"><!-- blue --></div>
  <div class="rcard"><!-- yellow --></div>
</div>
```

```css
.rcard:nth-child(1) { background: #ffdbe5; }
.rcard:nth-child(2) { background: #c7e0f4; }
.rcard:nth-child(3) { background: #fff3b0; }
```

超过 3 张时,循环使用这三色(第 4 张又是 pink,第 5 张又是 blue...)。**不引入第四色**。

---

## 6. 装饰约定

### ✅ 使用

- **pixel-star ◆ ◆ ◆** —— hero 装饰,玫红色 Mono
- **pill 呼吸灯徽章** —— 版本/状态展示
- **chunky 边框阴影** —— 所有卡片/按钮/印章的标志
- **像素方块 bullet** —— 章节标签前缀
- **糖果三色** —— 奶粉/天空蓝/奶油黄轮换
- **CRT 细扫描线** —— 2.5% 透明全页叠层
- **微斜装饰** —— 印章 -4deg,关键词色块 -1.5deg

### ❌ 不使用(这是本风格的选择)

- 软模糊阴影 `box-shadow: 0 4px 12px rgba(0,0,0,0.1)` —— Retro 只用硬偏移阴影
- 渐变 —— 实色块更有玩具感
- 霓虹荧光色 —— 会滑向 Cyberpunk
- 纯黑 `#000` / 纯白 `#fff` —— 奶味丢失
- 衬线主体 —— Retro 的主字是几何 sans
- 过度装饰(3 个以上动效/装饰叠加)—— 变乱

### ✨ 允许的反差元素

- **italic serif 第二关键词** —— 配天蓝色,和玫红色块关键词形成双重奏
- **手绘感不对齐元素** —— 一个歪斜的印章 / 一个错位的编号 / 一个"本该对齐但没对齐"的元素,作为 PRINCIPLES 原则 6(打破齐整)的锚点

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
  outline: 3px solid var(--accent);
  outline-offset: 4px;
  border-radius: 6px;
}
```

注意 Retro 的 focus outline 要比其他风味**更粗**(3px),因为 chunky 美学要求线条硬朗。

### 动效偏好

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    transition-duration: 0.01ms !important;
    animation-duration: 0.01ms !important;
  }
}
```

### 对比度

- `#2a1f3d` 深紫黑 on `#fbf1e0` 奶油底 ≈ 12.5:1 ✓
- `#4a3d66` 副文字 on `#fbf1e0` ≈ 7.5:1 ✓
- `#ec4899` 玫红 on `#fbf1e0` ≈ 4.1:1 ✓ AA(用于 ≥18px 字体)
- 糖果色底上的深紫黑 ≈ 10+ : 1 ✓✓

### 打印样式

Retro 的糖果色打印效果可能不好,建议打印时**转为黑白线稿**:

```css
@media print {
  @page { margin: 16mm 14mm; }
  body {
    background: #fff !important;
    color: #000 !important;
    -webkit-print-color-adjust: exact;
  }
  body::after { display: none; }  /* 关掉扫描线 */
  .rcard {
    background: #fff !important;
    border-color: #000 !important;
    box-shadow: none !important;
  }
  .pill, .sticker, .btn-primary, .btn-ghost {
    box-shadow: none !important;
    background: #fff !important;
    color: #000 !important;
  }
  h1 .k { background: #f5f5f5 !important; box-shadow: none !important; transform: none !important; }
  h1 .k2 { color: #000 !important; }
  a[href^="http"]::after { content: " (" attr(href) ")"; font-size: 0.85em; }
}
```

---

## 8. 和 PRINCIPLES.md 的协作

本文件**只讲风味**。生成一个 Retro 页面的完整流程:

1. 先按 PRINCIPLES.md 规划结构(≥4 种区块 / 密度跳变 / 留白节奏 / 强调节制 / 作者痕迹 / 打破齐整)
2. 再按本文件应用 Retro 视觉选择(奶油底 / Space Grotesk / 糖果三色 / chunky 阴影 / CRT 扫描)

**Retro 对 PRINCIPLES 的翻译**:

- **原则 1(结构多样性)**:Retro 尤其要避免"9 张糖果卡片排满屏"。混用 hero + pill + cards + sticker + 编号列表等
- **原则 2(密度跳变)**:Retro 适合在密集糖果块旁边放一个极短的一句话 sticker 作为呼吸
- **原则 3(留白节奏)**:chunky 阴影本身占视觉空间,所以 Retro 的留白要**更大**,避免拥挤
- **原则 4(强调节制)**:糖色块关键词 + italic 关键词 = 一个 h2 最多两个关键词。不要每个词都裹色块
- **原则 5(作者痕迹)**:Retro 适合放 "shipped with ♪" / "made on a sunday" 这类有情绪的签名
- **原则 6(打破齐整)**:Retro 的核心美学就是"故意不对齐"的 sticker/rotation。别忘了放 1-2 个歪斜元素

**Retro 的节制**:容易过度装饰。一个页面内"chunky 阴影元素"(卡片 + 按钮 + 印章...) 加起来**不超过 12 处**,否则就进入 brutalist 领域了。

---

## Appendix · Token 速查

```css
:root {
  --bg:          #fbf1e0;
  --text:        #2a1f3d;
  --text-sub:    #4a3d66;
  --text-dim:    #8b7ea8;
  --line:        #2a1f3d;
  --candy-pink:  #ffdbe5;
  --candy-blue:  #c7e0f4;
  --candy-yellow:#fff3b0;
  --accent:      #ec4899;
  --accent-alt:  #4f8ec7;
  --sans:  'Space Grotesk', 'Noto Sans SC', -apple-system, sans-serif;
  --serif: 'Source Serif 4', 'Noto Serif SC', Georgia, serif;
  --mono:  'JetBrains Mono', 'SF Mono', monospace;
}
```

---

**Credits**:风味由 X 和小克提炼。参考气质来自大厂周年活动页、独立游戏站、90 年代杂志排版回响。
**License**:MIT · **Author**:X & 小克,2026-04-23
