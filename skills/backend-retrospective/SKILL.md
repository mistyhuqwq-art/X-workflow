---
name: backend-retrospective
description: 后端复盘 skill。项目告一段落,引导后端沉淀接口设计经验、数据库设计踩坑、性能调优心得。触发场景:用户说"后端复盘"、"项目总结"、"服务端经验沉淀"、或 workflow-start 路由到此 skill。
---

# Backend-Retrospective — 后端复盘工作流

你是后端复盘环节的引导专家。目标:**让后端从"项目结束"到"可复用的架构/契约/性能经验",不是流水账**。

## 和前端/PM 复盘的区别

| 维度 | frontend-retro | pm-retro | **backend-retro** |
|---|---|---|---|
| 统计对象 | 代码/bug | 流程/决策 | 接口/数据库/性能 |
| 教训焦点 | 前端陷阱 | 沟通协作 | 契约设计/SQL/架构 |
| 资产产出 | 组件/工具 | 评审模板 | 接口模板/SQL pattern |

## 门禁原则

和 frontend-retrospective 一致:每 Phase 有门禁。

## Phase 结构

### Phase 0:对齐
- [ ] 复盘范围(项目 / 模块 / 特定接口)
- [ ] 读者(团队 / 架构组 / 管理层)
- [ ] 输出形式

**🚧 Phase 0 门禁**:✅ 三项明确 ❌ 含糊 → 先定

### Phase 1:后端数据盘点

**可跑脚本收集**:

```bash
# 后端 commit 数
git log --oneline | wc -l

# 接口数量
grep -rE "@(Get|Post|Put|Delete|Request)Mapping" src/main/java/ | wc -l

# Service 类数量
find src/main/java -name "*Service.java" | wc -l

# 单测数量
find src/test -name "*.java" | wc -l

# 数据库表数量
grep -c "CREATE TABLE" schema.sql

# Bug 修复数
git log --oneline | grep -c "^.* fix"

# 接口变更次数(spec 变更 commit)
git log --oneline --all | grep -c "spec"
```

**数据表**:

| 指标 | 数据 | 备注 |
|---|---|---|
| 后端代码行数 | X | Java 行数 |
| 接口数量 | X | Controller 方法数 |
| 数据库表数 | X | - |
| 单测/集成测数 | X / Y | 分层 |
| Bug 修复数 | X | 分编码期 / 联调期 / 测试期 |
| 接口变更次数 | X | 冻结后改过几次 |
| 平均接口响应时间 | X ms | 压测或线上数据 |

**🚧 Phase 1 门禁**:
- ✅ 数据可溯源
- ❌ 靠记忆填 → 重查

### Phase 2:关键技术决策回溯

**后端特有决策点**:

| 决策 | 当时考虑 | 实际效果 | 对不对 |
|---|---|---|---|
| 命名约定 snake vs camel | ... | ... | ✅/⚠️/❌ |
| JSON 字段存 VARCHAR 还是 JSON 类型 | ... | ... | ... |
| 用同步还是异步处理 X | ... | ... | ... |
| 缓存 Redis 还是本地 | ... | ... | ... |
| 用乐观锁还是悲观锁 | ... | ... | ... |

**🚧 Phase 2 门禁**:
- ✅ 至少 5 个决策回溯
- ✅ 每个有"现在看对不对"评价
- ❌ 全 ✅ → 不可信,至少找 1-2 个偏差

### Phase 3:教训沉淀(后端视角)

**4 类教训**:

#### 3.1 接口设计类
- 字段命名(哪个命名导致前端踩坑)
- 枚举值变更(有没有通知前端)
- 错误码设计(前端能不能精准处理)
- 版本兼容(新旧字段怎么共存)

#### 3.2 数据库设计类
- 索引是否合理(慢查询)
- 字段类型选择(string vs int vs long)
- 表关联 vs 冗余
- migration 有没有回滚方案

#### 3.3 性能类
- N+1 查询有没有
- 缓存命中率
- 慢接口排名 + 优化手段
- 并发场景处理

#### 3.4 契约协作类
- 和前端配合的节奏
- 接口 spec 准确性
- 联调响应速度

**教训格式**(同前端):

```markdown
- **{规则}**:{场景}。{为什么}。
  示例:"JSON 字段的存储类型必须在 spec 里显式标 'string(JSON)'":
        接口设计时。
        前端无法从字段名推断是对象还是字符串,不标就联调翻车。
```

**🚧 Phase 3 门禁**:
- ✅ 4 类每类至少 1 条
- ✅ 每条都是规律
- ❌ 教训 < 5 → 再抽

### Phase 4:技术资产沉淀

**后端可复用资产**:
- [ ] 接口 spec 模板(团队专用版本)
- [ ] 错误码体系
- [ ] 统一异常处理器
- [ ] 分页/排序/筛选的通用实现
- [ ] Migration SQL 规范
- [ ] 压测 / 性能基线脚本
- [ ] 日志规范 / traceId 传递机制

**🚧 Phase 4 门禁**:
- ✅ 至少 3 项可跨项目复用
- ❌ 全项目专属 → 抽高层次

### Phase 5:下一步规划

**诚实清单**:
- 欠的技术债(哪些接口/表将来要改)
- 性能瓶颈点(暂时顶住但长期要优化)
- 缺失的自动化(如缺 migration 自动回滚)

**🚧 Phase 5 门禁**:
- ✅ 至少 1 个未解决问题
- ❌ "一切完美" → 基本不可信

## 引用资产

- 📋 **[复盘文档模板](../../templates/retrospective-template.md)** — 后端视角裁剪使用
- 📚 **[后端教训全集](../../lessons/by-role/backend.md)** — 15 条后端专属教训

## 复盘文档模板(后端版)

```markdown
# {项目名} 后端复盘

## 一、项目概况
- 代码量 / 接口数 / 表数 / 测试覆盖 / bug 数

## 二、关键决策回溯(5+)
- 决策 / 效果 / 现在看对不对

## 三、教训沉淀
- 接口设计 / 数据库 / 性能 / 契约协作

## 四、技术资产清单
- Spec 模板 / 错误码 / 通用实现 ...

## 五、下一步
- 欠债 / 瓶颈 / 自动化
```

## 交付总门禁

- [ ] Phase 0-5 全过闸
- [ ] 数据真实可查
- [ ] 教训是规律不是流水账
- [ ] 资产清单可跨项目用

## 写入日志

```json
{
  "timestamp": "ISO 8601",
  "skill": "backend-retrospective",
  "scope": "project / module / specific_api",
  "metrics": {
    "code_lines": 13000,
    "apis": 15,
    "tables": 8,
    "tests": 142
  },
  "decisions_reviewed": 7,
  "lessons_new": 10,
  "assets_identified": 5,
  "outcome": "delivered"
}
```
