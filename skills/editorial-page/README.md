# Editorial Page Skill

一个 Claude Code Skill —— 让 AI 帮你生成**精心排版的单页静态 HTML**。
采用**两层架构**:通用排版原则 + 具体视觉风味。

> 🌐 设计规范源 repo:https://github.com/mistyhuqwq-art/editorial-page-skill

适用场景:项目名片、产品介绍页、技术方案展示、博客长文、个人简历、路演一页纸、团队周报、分享会封面。

---

## 两层架构

```
assets/
├── PRINCIPLES.md        ← 通用排版原则(6 条,跨风格)
├── warm-editorial/      ← 风味 1
│   ├── DESIGN.md            暖色编辑杂志风(米色 + 砖红 + 衬线)
│   ├── template.html
│   └── example.html
└── tech-dark/           ← 风味 2
    ├── DESIGN.md            开发者深色风(暖中性黑 + Lime + italic serif)
    ├── template.html
    └── example.html
```

**为什么分两层**:AI 生成的页面之所以"有 AI 味儿",真正原因不在颜色和装饰,而在排版语法(结构可预测、密度均一、没有作者痕迹)。PRINCIPLES 抽出了这些底层规则,DESIGN 只管风味 —— 换风格不改原则。

---

## 安装(约 30 秒)

### 1. 解压到 Claude Code 的 skills 目录

```bash
mkdir -p ~/.claude/skills/
tar -xzf editorial-page-skill.tar.gz -C ~/.claude/skills/
```

解压后的结构:

```
~/.claude/skills/editorial-page/
├── SKILL.md
├── README.md
└── assets/
    ├── PRINCIPLES.md
    └── warm-editorial/
        ├── DESIGN.md
        ├── template.html
        └── example.html
```

### 2. 重启 Claude Code(或开新会话)

### 3. 验证

在 Claude Code 输入 `/`,应该能看到 `editorial-page`。

---

## 使用

最简单的触发方式 —— 自然语言:

```
做一个我们团队项目的介绍页
帮我写一页个人简历
生成一份本周工作总结的分享页
```

或显式调用:
```
/editorial-page 做个团队周报,主题是 Q2 收尾复盘
```

Skill 会:
1. 先读 `PRINCIPLES.md` 规划结构(≥4 种区块、密度跳变、留白节奏等 6 条)
2. 再读当前选用的 `warm-editorial/DESIGN.md` 应用风味
3. 基于 `template.html` 生成成品

产物是**独立的 HTML 文件**,所有 CSS 内联,双击就能看。

---

## 非 Claude Code 用户怎么用

把两份 Markdown 贴给任何 AI(Cursor / v0 / Copilot / ChatGPT):

1. `assets/PRINCIPLES.md`
2. `assets/warm-editorial/DESIGN.md`

然后说:
```
Build a single-page HTML following the two Markdown specs above.
Topic: [主题]
Audience: [受众]
Key messages: [3-7 点]
CTA: [希望读者做什么]

Apply PRINCIPLES.md's 6 rules first, then the style's DESIGN.md.
```

---

## 自定义

想改风味?改两个地方:

1. `assets/warm-editorial/template.html` —— 改 `<style>` 里的 CSS 变量
2. `assets/warm-editorial/DESIGN.md` —— 同步更新规范描述

想加新风格?新建 `assets/<new-style>/` 目录,照 warm-editorial 的结构放 DESIGN + template + example。

---

## 反馈

生成的页面哪里不对,直接告诉 Claude:
> 这个卡片间距太窄,我想要 24px

Claude 会在当次生成里调整,不需要你改 skill 本身。

反复出现的问题可以提回 GitHub issue:https://github.com/mistyhuqwq-art/editorial-page-skill/issues

---

Made with editorial-page skill · by X & 小克 · MIT
