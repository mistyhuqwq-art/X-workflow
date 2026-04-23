---
name: backend-interface
description: 后端接口设计 skill。PRD review 通过后,后端产出接口契约文档(RESTful 设计 + 字段规范 + 错误码),作为前端联调的"真相源"。触发场景:用户说"设计接口"、"API spec"、"定接口字段"、或 workflow-start 路由到此 skill。
---

# Backend-Interface — 后端接口设计工作流

你是后端接口设计环节的引导专家。目标:**让接口契约一次定准,避免联调时前后端反复扯皮**。

## 核心原则

> **接口契约 = 前后端的真相源**。契约模糊 = 联调 80% 的 bug 来源(某 B 端中台项目 实测)。

**反面案例**(前端侧看到的常见问题):
- ❌ 字段名前后端不一致(`taskName` vs `task_name`)
- ❌ 嵌套对象用 JSON 字符串存,但文档没说
- ❌ 枚举值后端改名没通知前端
- ❌ 错误码没定义,只返回 500
- ❌ ID 类型模糊(有时 number 有时 string)

## 引用资产

本 skill 深度依赖以下资产,执行时按需读取:

- 📚 **[后端教训全集](../../lessons/by-role/backend.md)** — 接口设计阶段的典型坑:JSON 字符串字段未标注 / 枚举值改名未通知 / 错误码缺失
- 📐 **[字段映射表模板](../../templates/field-mapping-template.md)** — Phase 3 和前端对齐时,用此模板产出字段映射表,作为联调的"真相源"

## 门禁原则(Gate-based)

4 个 Phase,每个有明确产出和通过标准。

## Phase 0:前置对齐

**确认信息**:
- [ ] PRD v3.x 终稿链接
- [ ] 技术栈(Spring Boot / Node / Go / ...)
- [ ] 数据库结构设计状态(已出?草稿?)
- [ ] 是否有既有接口可继承/参考
- [ ] 前端同学对接人(需要双向沟通)

**🚧 Phase 0 门禁**:
- ✅ PRD 已终稿
- ✅ 技术栈和框架明确
- ❌ PRD 还在改 → 回 PM 终审

## Phase 1:接口清单产出

**🎯 目标**:列出所有接口 + 基本信息,和 PRD 功能点一一对应。

**接口清单表**:

| # | 接口名 | Method | Path | 用途 | 对应 PRD 章节 | 前端调用页面 |
|---|---|---|---|---|---|---|
| 1 | 任务列表 | GET | /api/tasks | 列表分页 | 7.1 TaskList | TaskList |
| 2 | 任务详情 | GET | /api/tasks/{id} | 详情 | 7.2 TaskDetail | TaskDetail |
| 3 | 创建任务 | POST | /api/tasks | 新建 | 7.3 TaskForm | TaskForm |
| ... | | | | | | |

**RESTful 命名规范**:
- 资源用名词复数:`/api/tasks` 不是 `/api/getTask`
- 动作用 HTTP Method:GET/POST/PUT/DELETE/PATCH
- 批量用资源集合:`POST /api/tasks/batch`
- 关联资源嵌套:`/api/tasks/{id}/rewards`

**🚧 Phase 1 门禁**:
- ✅ PRD 所有功能点都有对应接口
- ✅ 接口命名遵循 RESTful
- ✅ 每个接口有"对应 PRD 章节"溯源
- ❌ 有 PRD 功能点没接口 → 补
- ❌ 接口命名不符合规范 → 改

## Phase 2:每个接口的详细 Spec

**🎯 目标**:每个接口产出完整的请求/响应/错误码 spec,前端能依此写代码。

### 2.1 请求字段

| 字段名 | 类型 | 必填 | 枚举/长度 | 说明 |
|---|---|---|---|---|
| task_name | string | Y | ≤100 字符 | 任务名 |
| task_type | enum | Y | DAILY/WEEKLY/ONEOFF | 任务类型 |
| reward_amount | int | Y | ≥0 | 奖励金额(分) |

**命名约定**(团队选一种,全项目统一):
- 选项 A:snake_case(Spring Boot 常用):`task_name` / `reward_amount`
- 选项 B:camelCase:`taskName` / `rewardAmount`

**⚠️ 关键**:选定后不允许混用,否则前端必翻车。

### 2.2 响应字段

| 字段名 | 类型 | 含义 | 示例 | 备注 |
|---|---|---|---|---|
| code | int | 业务状态码 | 0 | 0=成功 |
| data | object/array | 业务数据 | {...} | 见下表 |
| message | string | 提示消息 | "" | 错误时必填 |

**data 内部字段**:
| 字段名 | 类型 | 含义 | 示例 | 备注 |
|---|---|---|---|---|
| task_id | **string** | 任务 ID | "T-001" | ⚠️ 明确是 string 不是 number |
| ext_config | **string(JSON)** | 扩展配置 | `"{\"refreshType\":\"ALL\"}"` | ⚠️ 序列化存储,前端要 parse |
| created_at | string(ISO) | 创建时间 | "2026-04-23T10:00:00Z" | UTC 时间 |

**⚠️ 陷阱字段必须在 Spec 里标注**(某 B 端中台项目 实测踩过的):
- **ID 字段**:明确是 string 还是 number(不写 = 翻车)
- **JSON 字符串字段**:明确标"string(JSON)"和具体结构
- **枚举字段**:列出全部枚举值(不允许"等等")
- **时间字段**:标明时区(UTC / 本地)和格式

### 2.3 错误码

| code | HTTP Status | 含义 | 何时出现 | 前端处理建议 |
|---|---|---|---|---|
| 0 | 200 | 成功 | - | - |
| 400001 | 400 | 参数缺失 | 必填字段为空 | 透传 message 高亮字段 |
| 400002 | 400 | 参数格式错 | 类型/枚举不符 | 透传 message |
| 401000 | 401 | 未登录 | token 缺失/过期 | 跳登录 |
| 403000 | 403 | 无权限 | 角色无权 | 跳无权限页 |
| 500001 | 500 | 业务冲突 | 重复创建等 | 透传 message |
| 500002 | 500 | 数据库异常 | 意外故障 | 通用重试 |

**规则**:
- 错误必须有 `code`(不是只靠 HTTP status)
- 错误必须有具体 `message`(让用户知道问题)
- 不允许用 "0000" / "9999" 这种模糊错误码

**🚧 Phase 2 门禁**:
- ✅ 每个接口都有完整的 请求 / 响应 / 错误码 三部分
- ✅ 陷阱字段(ID / JSON / 枚举 / 时间)全部标注
- ✅ 命名风格统一(全 snake 或全 camel)
- ❌ 含糊的"等等" / "类似" → 拒绝,必须穷举
- ❌ 错误码只定义了 0 → 至少补 400/401/403/500 几类

## Phase 3:和前端对齐 + 输出字段映射表

**🎯 目标**:接口 spec 完成后,**主动和前端对齐**,让前端不踩雷。

### 3.1 约见前端 mini-review

**议题**:
- 通读接口清单
- 对每个**陷阱字段**(ID / JSON / 枚举 / 时间)口头确认
- 前端提出疑问 → 后端当场回答或约定答复时间

**时长**:半小时够了(接口 < 15 个)。

### 3.2 产出字段映射表(对接前端)

**复用前端的 field-mapping-template.md 模板**,但由后端主动产出。位置:
- `knowledge-base/interface/field-mapping-{feature}.md`
- 或飞书文档直接和前端共享

**后端主动写的好处**:前端不用再猜,直接查。

### 3.3 接口文档工具选择

| 工具 | 优势 | 劣势 |
|---|---|---|
| **Swagger/Knife4j** | 代码注解自动生成 | 格式相对生硬 |
| **飞书文档** | 灵活、支持评论、易协作 | 要手动维护,易过期 |
| **YAPI** | Mock + 文档一体 | 学习成本 |

推荐组合:**飞书作为权威源 + Swagger 自动生成辅助**(两者冲突以飞书为准,因为飞书是 PM/前端/后端 review 过的)。

**🚧 Phase 3 门禁**:
- ✅ 和前端 mini-review 已开
- ✅ 字段映射表已产出并共享
- ✅ 接口文档位置固定(所有相关方都知道)
- ❌ "文档我放我本地了" → 不行,必须共享位置

## Phase 4:接口评审 + 冻结

**🎯 目标**:和架构 / PM / 前端 / QA 对齐,接口冻结后才能开始编码。

**评审清单**:
- [ ] 架构 review:RESTful 规范、命名、向后兼容
- [ ] PM review:接口功能与 PRD 一致
- [ ] 前端 review:字段对齐、陷阱字段确认
- [ ] QA review:错误场景可测

**冻结规则**:
- 冻结后改接口必须走变更流程(通知前端 + 更新文档)
- 不冻结就开始编码 = 返工惯犯

**🚧 Phase 4 门禁**:
- ✅ 四方 review 全过
- ✅ 接口已冻结(明确声明)
- ❌ "先写着,有问题再改" → 拒绝,接口必须冻结

## 下一步

接口冻结后:
- 调用 `backend-coding` 开始编码
- 同时前端可以并行走 `frontend-solution` + `frontend-coding`(有冻结的接口 = 前端可以安心推进)

## 常见卡点

| 卡点 | 做法 |
|---|---|
| PRD 某功能不知道该几个接口 | 回 PM 澄清,不自己猜 |
| 字段类型犹豫(string vs int) | 看后续是否要做数值运算,不做就 string(避免精度问题) |
| 错误码没思路 | 参考 HTTP 状态 + 业务前缀(如 400xxx 表参数类) |
| 枚举值将来会加 | 可以,但当前清单必须完整,加的时候走变更流程 |

## 写入日志

```json
{
  "timestamp": "ISO 8601",
  "skill": "backend-interface",
  "prd_version": "v3.4",
  "apis_count": 15,
  "trap_fields_annotated": {
    "id_fields": 5,
    "json_string_fields": 2,
    "enum_fields": 6,
    "time_fields": 4
  },
  "error_codes_defined": 8,
  "naming_convention": "snake_case",
  "frontend_review_passed": true,
  "frozen": true,
  "outcome": "ready_for_coding"
}
```
