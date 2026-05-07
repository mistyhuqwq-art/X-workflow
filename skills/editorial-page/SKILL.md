---
name: editorial-page
description: 生成精心排版的单页 HTML(项目介绍、周报、简历、活动邀请、技术博客、开发者工具介绍、作品集、出版物期刊、宣言声明等)。两层架构:底层通用排版原则 + 上层视觉风味。当前提供 6 种风味,其中 4 种支持 fx-rich 表现力档位:warm-editorial(米色杂志,可 fx-rich)/tech-dark(暖中性黑开发者风,可 fx-rich)/minimal-mono(纯黑白极简,无 fx-rich)/retro(糖果色复古玩心,可 fx-rich)/swiss-grid(红黑 12 栏出版物,无 fx-rich)/brutalist(鲜黄纯黑大声量,可 fx-rich)。共 10 种可选形态。当用户说"做个好看的名片/介绍页/展示页/一页纸/邀请页/作品集/技术博客/期刊/年报/宣言/海报"且未指定其他视觉体系时触发。
---

# Editorial Page Skill · 两层架构

生成精心排版的单页静态 HTML。本 skill 采用**规范分层**:

- **`assets/PRINCIPLES.md`** — 通用排版原则(6 条),所有风格都遵守
- **`assets/<style>/DESIGN.md`** — 具体风格的视觉选择(色彩/字体/装饰)

当前实现的 6 种风味:
| 风味 | 气质 | 适合 |
|---|---|---|
| **warm-editorial** | 米色 + 砖红 + 衬线 + 克制 | 项目名片、周报、简历、博客长文、杂志感内容 |
| **tech-dark** | 暖中性黑 + Lime + italic serif 字族反差 | 开发者工具、API/CLI、技术文档、基础设施。支持 `fx-rich` 表现力开关(克制版 vs 丰富版) |
| **minimal-mono** | 纯黑白 + 等宽元信息 + 虚线分隔 + 粗细断崖 | 技术博客、开源 README、工程师个人站、论文式长文 |
| **retro** | 奶油底 + 糖果三色 + chunky 阴影 + CRT 扫描 | 活动邀请、创作者作品集、独立游戏站、有玩心的产品 |
| **swiss-grid** | 红黑二色 + Inter 900 uppercase + 12 栏精确对齐 + modular scale | 出版/期刊、设计品牌、文化机构、严肃年报、排版研究 |
| **brutalist** | 鲜黄纯黑 + Archivo Black 超粗 + 歪斜印章 + 黑黄反色块 + screamer 大声量 | 活动海报、观点宣言、创始人声明、竞选倡议、反叛品牌 |

---

## 工作流程(严格按顺序执行)

### Step 1 — 理解需求

确认以下(缺了主动问):
- **主题**:这页讲什么?一句话定调。
- **受众**:给谁看?决定用词的专业度。
- **核心信息**:3-7 个要传达的重点。
- **CTA**:看完后希望读者做什么?

### Step 2 — 选风味(10 个形态中选 1)

6 个风味 + 4 个 `fx-rich` 变体(warm / tech-dark / retro / brutalist) = 一共 **10 个可选形态**:

| 选项 | 气质 | 何时用 |
|---|---|---|
| `warm-editorial` | 温暖杂志感 | 项目名片/周报/简历/博客长文/分享封面 |
| `warm-editorial` + `fx-rich` | warm 含进入动效 | 同上,希望首屏更有仪式感时 |
| `tech-dark` (默认) | 冷静克制开发者风 | 技术文档/API 参考/变更日志/README/技术博客 |
| `tech-dark` + `fx-rich` | 科技呼吸感 | 品牌主页/产品 landing/发布公告/Pitch 页 |
| `minimal-mono` | 纯黑白极简文本 | 技术博客/开源 README/工程师个人站/论文式长文 |
| `retro` | 糖果色 chunky 玩心 | 活动邀请/创作者作品集/独立游戏站/有玩心产品 |
| `retro` + `fx-rich` | retro 含小活物动效(星星闪烁 / dot 呼吸 / wiggle) | 邀请/作品集希望 hero 更吸引眼球时 |
| `swiss-grid` | 红黑 12 栏精确对齐出版物感 | 设计品牌/期刊/文化机构/年报/排版研究 |
| `brutalist` | 鲜黄纯黑超粗大声量 | 活动海报/宣言/声明/竞选倡议/需要立刻被记住 |
| `brutalist` + `fx-rich` | brutalist 含刚猛动感(stamp wiggle / screamer 弹入 / block 翻转) | 宣言/海报希望首屏就"炸一下"时 |

**重要**:`minimal-mono` 和 `swiss-grid` **没有 fx-rich 版本**——它们的极端性(纯黑白极简 / 秩序至上)就是核心身份,加装饰或动效会背叛风味基因。

**自动判断(能判断就不打扰用户)**:

先判断风味 → 再判断是否加 `fx-rich`:

**风味判断**:
- "项目名片/周报/简历/博客/介绍页/杂志感" → **warm-editorial**
- "深色/暗色/开发者工具/API/CLI/文档/变更日志" → **tech-dark 克制**
- "发布/landing/品牌/产品主页/pitch/发布公告" → **tech-dark fx-rich**
- "技术博客/开源/README 展示/论文/essay/工程师个人" → **minimal-mono**
- "活动邀请/作品集/独立游戏/儿童/有玩心/奶油色/复古" → **retro**
- "期刊/年报/出版/文化机构/建筑事务所/设计品牌展示/瑞士/严肃媒体" → **swiss-grid**
- "宣言/声明/manifesto/海报/反叛/punk/观点强/立刻被记住/粗野" → **brutalist**

**fx-rich 叠加判断(仅对 warm/tech-dark/retro/brutalist 有效)**:
- 用户关键词包含 "hero 要炸一点 / 更有仪式感 / 首屏要抓人 / 带动效 / 入场效果" → 加 `fx-rich`
- 用户明确说"丰富版 / rich / 活一点 / 动感一点" → 加 `fx-rich`
- 默认(内容阅读向)→ 不加 fx-rich
- mono 和 swiss:**无论用户怎么说都不加 fx-rich**(没有这个版本)

**用户犹豫 / 场景跨多个分类 / 无法判断时,主动打开预览让用户自己看**:

```
当无法自动判断风味时,执行:
1. 告诉用户:"我打开预览让你看 7 种效果,选完告诉我"
2. Bash 调用: open ~/.claude/skills/editorial-page/assets/preview-index.html
   (备用 GitHub Pages 链接:
    https://mistyhuqwq-art.github.io/editorial-page-skill/preview-index.html)
3. 等待用户回复"用 X"再继续
```

**用户主动要求预览时**:
如果用户说 "先看看" / "预览" / "preview" / "show me" / "我想对比一下",
立即用同样的 Bash 打开 preview-index.html,不要先问其他问题。

### Step 3 — 读取规范(两份都要读)

**必读,顺序不可颠倒**:

1. **先读 `assets/PRINCIPLES.md`** — 6 条跨风格通用原则
2. **再读 `assets/<选中风味>/DESIGN.md`** — 具体风味的视觉选择

两份都读完,再动手。

### Step 4 — 规划结构(应用 PRINCIPLES)

在动手前,先用 PRINCIPLES.md 的 6 条**规划这一页**:

- 选 **≥4 种** 不同区块(不要通篇卡片网格)
- 安排 **密度跳变**:哪里极短(一句话章节)、哪里极密(长段落/复杂表)
- 安排 **留白节奏**:哪里大留白让内容孤立、哪里紧凑节约视线
- 规划 **accent 克制**:每个 h2 最多 1 个关键词、全页 accent 按钮 ≤2
- 预埋 **作者痕迹**:具体数字 / 署名 / 自嘲 / 专有名词
- 留一处 **打破齐整**:手绘线 / 错位标签 / 不在主色板的单点

复杂页面(≥6 章节)先用 1-2 句告诉用户你选了哪些区块,再写代码。

### Step 5 — 基于模板生成(应用 DESIGN)

**不从零写 CSS**。读取 `assets/<选中风味>/template.html`,保留所有 CSS 变量和类定义,只替换 `<body>` 内的内容。按对应 DESIGN.md 的风味选择填充。

### Step 6 — 自检清单

生成后**逐条核对**。任何一条不达标就回头改:

**PRINCIPLES 层(通用,两种风味都要过):**
- [ ] ≥4 种不同区块,单种 ≤2 次?
- [ ] 有极短也有极密区块?
- [ ] 有明显大留白和紧密区,不是一律均匀?
- [ ] h2 单关键词 accent,全页 accent 按钮 ≤2?
- [ ] ≥1 处署名/自嘲/黑话/具体数字?
- [ ] ≥1 处不属于主体系的视觉元素?

**DESIGN 层 · warm-editorial:**
- [ ] 配色仅米色 + 砖红 + 灰阶?
- [ ] 标题用衬线、正文用无衬线?
- [ ] 没有图标/emoji/渐变/阴影?
- [ ] 窄容器 960px?
- [ ] 每个 section 有三件套(小标签 + h2 + lead)?
- [ ] `<head>` 里 meta / og 字段都填齐了?
- [ ] `@media print` / `:focus-visible` / `prefers-reduced-motion` 保留?

**DESIGN 层 · tech-dark:**
- [ ] 配色:暖中性黑 `#1c1b1a` + 冷白 + 暖灰 + 单 accent 主色(不混用多 accent)?
- [ ] Accent 用字族反差(Source Serif italic)而非单纯颜色?
- [ ] 列表式排版(`.stack + .row`)而非默认 3 列卡片?
- [ ] Hairline 分隔替代卡片边框?
- [ ] 表现力档位决定了(默认 vs `fx-rich`) 且符合场景?
- [ ] `fx-rich` 开了时,body 有 `class="fx-rich"`?
- [ ] 中文 `.k` 关键词加了 `padding: 0 0.15em/0.12em` 呼吸空间?
- [ ] `<head>` color-scheme: dark?
- [ ] `@media print` 已实现"深色转浅色"省墨?

**DESIGN 层 · minimal-mono:**
- [ ] 配色只有灰度(纯黑白 + 灰阶),**完全没有彩色**?
- [ ] 没用 serif?h1 用 Inter 300 + 关键词 Inter 900 的粗细断崖?
- [ ] 元信息(时间/版本/草稿状态)用 JetBrains Mono?
- [ ] 分隔用虚线 `1px dashed #ccc` 而非实线?
- [ ] 强调只用 `<b>` 加粗,不用任何颜色?
- [ ] 容器 680px(比其他风味更窄)?
- [ ] `@media print` 利用本风格天然打印感,展开 URL?

**DESIGN 层 · retro:**
- [ ] 配色:奶油底 `#fbf1e0` + 深紫黑文字 + 糖果三色(奶粉/天空蓝/奶油黄)循环 + 玫红 accent?
- [ ] 卡片/按钮/印章用 **chunky 硬阴影**(pure offset 不是软模糊)?
- [ ] 主字 Space Grotesk 700,关键词包糖色块 + 轻微歪斜?
- [ ] 第二关键词(italic serif)配天蓝色形成双关键词?
- [ ] 章节标签前有像素方块 bullet?
- [ ] 全页有 CRT 扫描线叠层(2.5% 透明)?
- [ ] 至少 1 处歪斜 sticker 作为"打破齐整"?
- [ ] chunky 阴影元素总数 ≤ 12 处(避免滑向 Brutalist)?
- [ ] 中文 h2 关键词用 `.k-cn`(不 italic),中文 h1 italic 词用 `.k2-cn`?
- [ ] `@media print` 禁用背景色,糖果底转白底?

**DESIGN 层 · swiss-grid:**
- [ ] 配色**只有**黑/白/瑞士红 `#ff1f1f`,没有第二种色相?
- [ ] 整页只用 Inter 一个字体族(+ Mono 仅用于编号/元信息)?
- [ ] 字重只用 300/400/500/700/900 这几档,不用中间值?
- [ ] 所有元素落在 12 栏网格上,明确标注 col 起终点?
- [ ] 字号都在 modular scale(1.25 ratio,12/14/16/20/24/32/40/56/80)上?
- [ ] 间距都是 16 的倍数(16/32/48/72/96),不用"38px"这种?
- [ ] h1/h2 英文 uppercase,中文段落去掉 uppercase(用 `:lang(zh)`)?
- [ ] 全页红色出现不超过 3 次(1 个 h1 关键词 + 1-2 处其他)?
- [ ] 圆角全系统 = 0?
- [ ] 有左列章节编号(`§ 01`) + 右列窄副栏(`col-side`) 的 3 分区 hero?
- [ ] 至少 1 处"允许的打破齐整"(见 DESIGN 第 6 节)?

**DESIGN 层 · brutalist:**
- [ ] 配色:鲜黄底 `#ffe500` + 纯黑文字 + 黑黄反色块?不超过 1 种 pop 色?
- [ ] 字体:Archivo Black 900 作 h1/h2 display,Space Grotesk 作正文?
- [ ] 所有圆角 = 0?
- [ ] h1 到正文有断崖式字号跳跃(≥56px vs 16-17px)?
- [ ] 至少有 1 个 screamer 段 (80-180px 超大字)?
- [ ] 黑底黄字反色块网格 / 交错,**无圆角无软阴影**?
- [ ] 英文关键词用 `.k`(skewX 歪斜);**中文关键词用 `.k-cn`(不歪斜)**?
- [ ] 歪斜元素(stamp + `.k` + 其他) 总数 ≤ 3 处?(避免混乱)
- [ ] 至少 1 处 stamp/handwritten/签名作为作者痕迹?
- [ ] 中文 h1/h2 自动去掉 uppercase(`:lang(zh)`)?
- [ ] `@media print` 禁用黄背景,转白底省墨?

---

## 文件清单

```
assets/
├── PRINCIPLES.md              ← 通用排版原则(Step 3 先读)
├── preview-index.html         ← 5 种形态浏览器预览页(Step 2 用户犹豫时 open)
├── warm-editorial/
│   ├── DESIGN.md
│   ├── template.html          (含 body.fx-rich CSS)
│   ├── example.html
│   └── example-rich.html      ← fx-rich 变体(含进入动效)
├── tech-dark/
│   ├── DESIGN.md
│   ├── template.html
│   ├── example.html           ← 克制版示例
│   └── example-rich.html      ← fx-rich 丰富版示例
├── minimal-mono/
│   ├── DESIGN.md              (无 fx-rich;本风味的极简是核心身份)
│   ├── template.html
│   └── example.html
├── retro/
│   ├── DESIGN.md
│   ├── template.html          (含 body.fx-rich CSS)
│   ├── example.html
│   └── example-rich.html      ← fx-rich 变体(含小活物动效)
├── swiss-grid/
│   ├── DESIGN.md              (无 fx-rich;本风味的秩序是核心身份)
│   ├── template.html
│   └── example.html
└── brutalist/
    ├── DESIGN.md
    ├── template.html          (含 body.fx-rich CSS)
    ├── example.html
    └── example-rich.html      ← fx-rich 变体(含刚猛动感)
```

**GitHub Pages 在线预览备用链接**:
https://mistyhuqwq-art.github.io/editorial-page-skill/preview-index.html

---

## 重要约束

1. **两层都要应用**:只按 PRINCIPLES 会没风格,只按 DESIGN 会显 AI 味。
2. **用户犹豫时打开预览,不要硬逼选**:本地 `open preview-index.html` 是首选,让用户看完再决定。
3. **不加图标库**:Font Awesome / Lucide / emoji 都不要(两种风味都不用)。
4. **单页 HTML**:所有 CSS 内联 `<style>` 标签,双击就能看,不依赖构建。
5. **中英混排**:两种风味都已在字体栈加了 Noto Sans SC + Noto Serif SC,斜体关键词加了 padding 呼吸。生成时不要自己改字体。
6. **生成前先规划**:≥6 章节的复杂页面,先用 1-2 句说明你选了哪些区块,再写代码。

---

## 未来扩展

当新风味(minimal-mono / tech-dark / retro 等)加入时,会新增:
```
assets/
├── PRINCIPLES.md        ← 不变,所有风味共享
├── warm-editorial/
├── minimal-mono/        ← 新增
├── tech-dark/           ← 新增
└── ...
```

触发时会先询问用户"用哪种风味?",再加载对应 DESIGN.md。
