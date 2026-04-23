# Community Learning —— 用户经验自动收集机制设计

> 让 workflow-dlc 真正实现"越多人用越准"的自我进化能力。

## 🎯 设计目标

**把每个用户的使用经验**(哪里被拦下、哪里要纠正判断、产生了什么新教训)**聚合回 workflow-dlc**,让框架:
- 新用户享受老用户的经验(规则层越来越全)
- workflow-dlc 维护者发现真实使用场景(不是闭门造车)
- 用户获得"贡献感",更愿意长期使用

---

## 🛡️ 隐私前置原则(底线)

所有方案**必须满足**:

1. **Opt-in 而非 Opt-out**:默认不收集,用户明确同意才开启
2. **可见数据**:用户能看到自己要上传什么,能编辑/删除敏感内容
3. **匿名化**:默认匿名,用户可选署名
4. **脱敏优先**:项目路径 / 用户名 / 文件路径必须自动脱敏
5. **可撤回**:用户随时可以关闭 / 要求删除已上传数据

---

## 📐 5 种落地方案(递进式,先做轻量再做复杂)

### 方案 A:GitHub Issue 模板(零成本,先做)

**机制**:
- workflow-dlc 仓库配置 3 个 Issue 模板(新教训 / 改进建议 / Bug 反馈)
- 用户在使用过程中遇到可分享的经验,点 "New Issue" → 填模板
- workflow-dlc 维护者 review → 合并到 lessons/

**优点**:
- ✅ 零成本(GitHub 原生能力)
- ✅ 隐私天然安全(用户自己脱敏)
- ✅ 贡献有署名(GitHub username)

**缺点**:
- ❌ 需要用户主动行为(很多人懒得开 Issue)
- ❌ 格式参差不齐,review 成本高

**落地步骤**:
- `.github/ISSUE_TEMPLATE/new-lesson.md`
- `.github/ISSUE_TEMPLATE/improvement.md`
- `.github/ISSUE_TEMPLATE/bug-report.md`

### 方案 B:本地导出脚本 + PR(半自动,零服务器)

**机制**:
- 提供 `sources/export-experience.sh` 脚本
- 用户运行脚本 → 从 `~/.claude/experience-base/raw/` 读日志 → 自动脱敏(路径/用户名) → 产出一个 PR-ready 的 patch 文件
- 用户 review 脱敏结果 → 手动开 PR → workflow-dlc 维护者合并

**优点**:
- ✅ 低门槛(一键脱敏)
- ✅ 用户能 review 要上传的内容
- ✅ 依然走 GitHub PR,审计可追溯

**缺点**:
- ❌ 还是需要用户手动 PR
- ❌ 脚本要维护(跨平台兼容)

**核心脚本逻辑**:
```bash
# sources/export-experience.sh
#!/bin/bash

# 1. 找到用户的 raw 日志目录
LOG_DIR="$HOME/.claude/workflow-dlc-experience-base/raw"

# 2. 脱敏(项目路径 → {PROJECT_ROOT},用户名 → {USER})
sed -e "s|$HOME|~|g" \
    -e "s|$(whoami)|{USER}|g" \
    "$LOG_DIR"/*.json > /tmp/exported-raw.json

# 3. 提取可贡献的信息(只保留结构,去除具体内容)
jq '{
  skill: .skill,
  role_judgment: .user_confirmed,
  user_overrode: .user_overrode,
  phase_gate_blocked: .phase_gate_blocked,
  new_lesson_hint: .new_lesson_hint
}' /tmp/exported-raw.json > /tmp/contribution.json

# 4. 让用户 review,然后放到本地一个 contributions/ 目录准备 PR
echo "请 review /tmp/contribution.json,满意后运行:"
echo "  cp /tmp/contribution.json workflow-dlc/contributions/\$(date +%Y%m%d)-<your-name>.json"
echo "  然后 git commit + git push + 开 PR"
```

### 方案 C:Skill 内建 "share this lesson" 命令(最自然)

**机制**:
- 每个 skill 新增一个子命令:`/share-lesson <skill-name>`
- 用户在使用 skill 时遇到新教训,直接在 Claude Code 里说 "/share-lesson pm-requirement:今天遇到物料 2 和物料 3 都缺时应该怎么办..."
- AI 自动**结构化**成教训格式 + **脱敏**后,生成一个 PR-ready 的 Markdown 片段
- 用户 confirm 后,AI 用 gh CLI 自动开 PR

**优点**:
- ✅ 最符合使用流(不打断用户)
- ✅ AI 帮忙格式化(用户负担小)
- ✅ 自动脱敏 + 自动开 PR

**缺点**:
- ❌ 需要用户装 gh CLI + OAuth
- ❌ AI 脱敏不一定 100% 可靠,需要人复核

**实现思路**:
- 新增 `skills/share-lesson/SKILL.md`
- Trigger:用户说 `/share-lesson` 或"这条教训想贡献"
- Phase 0:问用户哪个 skill / 什么教训
- Phase 1:AI 转成 `lessons/by-role/xxx.md` 的标准格式
- Phase 2:AI 脱敏 + 展示给用户 review
- Phase 3:用 gh CLI 开 PR

### 方案 D:后端服务 + 自动上传(重,但最顺)

**机制**:
- workflow-dlc 运营一个后端服务(如 Vercel / Cloudflare Workers + KV)
- 用户装 workflow-dlc 时,INSTALL 问:"是否开启匿名经验贡献?"
- 开启后,每次 skill 执行完,raw 日志**脱敏后** HTTP POST 到后端
- 后端存 KV → 定期(每周)AI 汇总 → 放到 GitHub 仓库的 `patterns/` 目录
- 维护者 review patterns/ → 升级到 rules/ → 合入 lessons/

**优点**:
- ✅ 真正自动化
- ✅ 覆盖率最高(不需要用户主动行为)
- ✅ 数据量大,AI 汇总质量高

**缺点**:
- ❌ 运维成本(服务器 / 认证 / 数据合规)
- ❌ 信任成本(用户不一定信任"匿名")
- ❌ 法律合规(GDPR / 个人信息保护法)
- ❌ 技术栈复杂(需要写后端)

### 方案 E:零信任联邦学习(最理想,最难)

**机制**:
- 用户本地就能**跑汇总算法**,只上传**汇总结果**(不是原始日志)
- 类似联邦学习,但不是机器学习,是"统计 + 模式识别"
- 用户本地 Claude Code 定期问用户:"你愿意分享本季度的 50 条日志汇总结论吗?(已本地脱敏 + 聚类)"

**优点**:
- ✅ 最佳隐私保护(原始日志不出本地)
- ✅ 用户更愿意分享

**缺点**:
- ❌ 实现复杂(要写本地 AI pipeline)
- ❌ 汇总质量依赖本地数据量(单用户样本少)

---

## 🎯 推荐落地节奏

| 阶段 | 方案 | 周期 | 成本 | 收益 |
|---|---|---|---|---|
| **P0(现在)** | 方案 A:GitHub Issue 模板 | 1 天 | 低 | 启动用户反馈通道 |
| **P1(1 个月后)** | 方案 C:Share-Lesson skill | 3-5 天 | 中 | 让贡献变得自然 |
| **P2(用户>50)** | 方案 B:本地导出脚本 | 2 天 | 中 | 给高级用户专业工具 |
| **P3(用户>500)** | 方案 D:后端服务 | 2 周 | 高 | 规模化数据 |
| **P4(未来)** | 方案 E:联邦学习 | 研究型 | 高 | 终极隐私方案 |

---

## 🏗️ P0 立即可做:GitHub Issue 模板

### 模板 1:分享一条新教训

```markdown
---
name: 📚 分享新教训
about: 使用 workflow-dlc 时遇到了新的实战教训
labels: community-lesson
---

## 这条教训属于哪个角色?
- [ ] PM
- [ ] 前端
- [ ] 后端
- [ ] QA
- [ ] 设计师
- [ ] Agent 设计师

## 这条教训属于哪个环节?
<!-- 如 "联调" / "评审" / "编码" -->

## 教训一句话
<!-- "做 X" 或 "不做 Y",可执行的规则 -->

## 触发场景
<!-- 什么时候应用这条规则? -->

## 为什么(踩过的坑 / 案例)
<!-- 不这么做会怎样?最好有具体例子 -->

## 怎么做
<!-- 具体操作 / 代码示例 -->

---

**⚠️ 提交前自查**:
- [ ] 已脱敏(无公司名、项目名、具体用户名)
- [ ] 规则是"规律"而不是"事实"
- [ ] 有触发场景 + 怎么做
```

### 模板 2:改进建议

```markdown
---
name: 💡 改进建议
about: Skill 有某处可以改得更好
labels: improvement
---

## 涉及的 Skill
<!-- 如 pm-requirement / frontend-integration -->

## 当前问题
<!-- 你遇到什么不好用的地方? -->

## 建议怎么改
<!-- 你希望它变成什么样? -->

## 为什么这样改好
<!-- 改进后解决什么问题? -->
```

### 模板 3:Bug 反馈

```markdown
---
name: 🐛 Bug 反馈
about: workflow-dlc 跑出问题了
labels: bug
---

## 场景
<!-- 你在做什么? -->

## 预期
<!-- 你期望发生什么? -->

## 实际
<!-- 实际发生了什么? -->

## 复现步骤
1. ...
2. ...

## 环境
- Claude Code 版本:
- 操作系统:
- workflow-dlc 版本(commit hash):
```

---

## 📊 贡献者激励机制

为了鼓励贡献,workflow-dlc 可以:

1. **README 列 Contributors 墙**(GitHub 自动)
2. **新教训的 `source:` 字段注明贡献者 GitHub username**
3. **季度 TOP 贡献者在 CHANGELOG 致谢**
4. **重大贡献者邀请进维护组**

---

## 🔒 隐私红线(不可突破)

| 内容 | 是否可收集 |
|---|---|
| skill 名称 | ✅ 可(公开信息) |
| Phase 门禁是否被拦下 | ✅ 可(匿名统计) |
| 用户覆盖 AI 判断的次数 | ✅ 可(学习信号) |
| 原始项目路径 | ❌ 不可(脱敏为 {PROJECT_ROOT}) |
| 用户 git 信息 | ❌ 不可(脱敏) |
| 具体文件内容 | ❌ 不可(除非用户明确同意) |
| PRD / 代码片段 | ❌ 不可(可能含商业机密) |

---

## 🎯 立即行动项(本轮 P0)

1. [ ] 在 `.github/ISSUE_TEMPLATE/` 创建 3 个模板
2. [ ] 在 README 加 "如何贡献经验" 小节链接到 Issue 模板
3. [ ] 在 CONTRIBUTING.md 补充"贡献教训的流程"

---

## 相关文档

- `sources/source-registry.md` —— 外部资料源清单
- `sources/source-skill-map.md` —— 资料 ↔ skill 映射(下一步做)
- `experience-base/README.md` —— 本地经验库三层架构
