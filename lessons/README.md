# 教训库

> 180+ 条可执行规则,按角色/环节/严重度分类。所有 skill 按需引用。

## 组织方式

```
lessons/
├── README.md         # 本索引
├── top-critical.md   # Top 5 致命教训(所有人必读)
├── by-role/          # 按角色分类
│   ├── pm.md
│   ├── design.md
│   ├── frontend.md   # 前端 (M1 重点)
│   ├── backend.md
│   ├── qa.md
│   └── agent.md
└── by-phase/         # 按环节分类
    ├── alignment.md      # 对齐阶段
    ├── solution.md       # 技术方案
    ├── coding.md         # 编码
    ├── integration.md    # 联调
    ├── testing.md        # 测试
    └── retrospective.md  # 复盘
```

## 已有教训库

- ✅ `top-critical.md` — Top 5 致命教训(跨角色必读)
- ✅ `by-phase/skill-design.md` — Skill 设计教训 7 条
- ✅ `by-role/` — 按角色分类教训 **90 条**
  - `pm.md` 15 条
  - `frontend.md` 20 条
  - `backend.md` 15 条
  - `qa.md` 12 条
  - `design.md` 16 条
  - `agent.md` 12 条

## M2-M3 待补充

其他教训文件从以下源抽取并分类:

| 源 | 数量 | 目标位置 |
|---|---|---|
| 某 B 端中台项目 复盘 | 105+ 条 | by-role/frontend + by-phase/* |
| 某营销后台 复盘 L1-L49 | 49 条 | by-role/frontend + by-phase/* |
| SOP 手册 | Top 5 | top-critical.md (已完成) |
| design-workflow-spec v4.0 附录 A | 13 条 | by-role/design.md |
| 本地 `knowledge-base/lessons.md` | 10+ 条 | by-phase/alignment + by-phase/retrospective |

## 引用方式

### Skill 内引用

在 SKILL.md 里用相对路径引用:

```markdown
详见 [Top 5 致命教训](../../lessons/top-critical.md)
```

### 快速加载

Skill 执行到关键环节时,用 Read 工具读取对应 lessons 文件并摘录。

## 教训格式规范

每条教训必须是**可执行规则**,包含:

```markdown
## {类别}

### #N {一句话规则}

**触发场景**:{什么时候适用}
**为什么**:{原因 / 不这么做的后果}
**怎么做**:
```code
// ❌ 错误
// ✅ 正确
```
```

## 反例(不要这样写)

- ❌ "今天发现后端返回了字符串" (事实,不是规律)
- ❌ "注意字段类型" (太笼统)
- ❌ 长篇大论 3 段 (读不完 = 没写)
