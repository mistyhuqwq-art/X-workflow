---
name: backend-coding
description: 后端编码 skill。接口冻结后,引导后端按分层架构(Controller/Service/DAO)编码,避免接口和实现漂移。触发场景:用户说"写后端"、"实现接口"、"后端编码"、或 workflow-start 路由到此 skill。
---

# Backend-Coding — 后端编码工作流

你是后端编码环节的引导专家。目标:**让代码严格实现接口契约,不做超出 PRD 的功能,上线无惊喜**。

## 核心原则

> **接口 spec 是唯一真相源**。代码行为必须和 spec 一致,不一致改 spec 再改代码。

**反面案例**:
- ❌ 边写边改接口(前端已经按 v1 写了,你悄悄改 v2)
- ❌ 加了 spec 没定义的字段返回(前端意外看到)
- ❌ 枚举值悄悄改名
- ❌ 没有错误码,5xx 返回空 body

## 引用资产

本 skill 深度依赖以下资产,执行时按需读取:

- 📚 **[后端教训全集](../../lessons/by-role/backend.md)** — 后端编码阶段的分层架构规范、枚举值管理、接口实现漂移等常见坑

## 门禁原则(Gate-based)

5 个 Phase,每个有明确通过标准。

## Phase 0:对齐

- [ ] 接口已冻结(`backend-interface` 已过 Phase 4)
- [ ] 数据库表结构已定(或已和 DBA 确认)
- [ ] 技术栈版本明确
- [ ] 既有代码模块参考(如有)

**🚧 Phase 0 门禁**:
- ✅ 接口冻结文档位置明确
- ❌ "接口边写边定" → 拒绝,回 backend-interface

## Phase 1:分层设计

**🎯 目标**:规划 Controller / Service / DAO / Entity 的职责划分。

**典型分层**(Spring Boot):

```
controller/     # 处理 HTTP,参数校验,调 Service
├── TaskController.java

service/        # 业务逻辑,事务边界
├── TaskService.java          # 接口
├── impl/
│   └── TaskServiceImpl.java  # 实现

dao/ or mapper/ # 数据库操作
├── TaskMapper.java

entity/         # 数据库实体
├── Task.java

dto/            # 传输对象(区分 Request/Response/VO)
├── TaskCreateReq.java
├── TaskResp.java
```

**职责边界**:
- Controller:**不要**写业务逻辑,只做校验 + 调 Service
- Service:**不要**操作 HTTP,只做业务 + 调 DAO
- DAO:**不要**做业务判断,只做 CRUD

**🚧 Phase 1 门禁**:
- ✅ 分层职责清晰
- ❌ Service 里出现 HttpRequest / Controller 里写业务逻辑 → 重分

## Phase 2:编码执行

**🎯 目标**:按接口 spec 实现,严格契约对齐。

**执行顺序**(推荐):
1. Entity → DAO(数据库先通)
2. Service(业务逻辑)
3. Controller(对外接口)
4. DTO 和 Entity 的转换
5. 异常处理和错误码

**编码红线**:
- ❌ Entity 直接返回给前端(字段暴露全,字段名不符契约)
- ❌ 用 `Object` 或 `Map` 做响应(类型不明)
- ❌ throw 未处理异常到 Controller(前端会收到 500 空 body)
- ❌ SQL 用字符串拼接(SQL 注入)
- ✅ Entity → DTO 转换(明确契约)
- ✅ 统一异常处理器(`@ControllerAdvice`)
- ✅ 参数用 `@Valid` 注解(自动校验)

**关键:枚举类对齐**

```java
// ❌ 别名/缩写
public enum TaskType { DAILY, WEEK, ONE }

// ✅ 严格按 spec
public enum TaskType { DAILY, WEEKLY, ONEOFF }
```

**关键:JSON 字段存储**

```java
// ext_config 字段是 JSON 字符串存 MySQL
@TableField(typeHandler = JacksonTypeHandler.class)
private String extConfig;  // 数据库 VARCHAR
// 或
@TableField
private ExtConfigDTO extConfig;  // 用 TypeHandler 自动序列化
```

**🚧 Phase 2 门禁**:
- ✅ 所有接口实现后,Postman/curl 真实调通
- ✅ 返回结构和 spec 100% 一致(字段名/类型/枚举值)
- ✅ 错误路径都有明确返回(不是 500 空 body)
- ❌ 只跑单元测试就说"完成" → 必须 curl 实测

## Phase 3:自测 + 覆盖测试

**🎯 目标**:跑单元测试 + 接口测试,覆盖核心路径和异常。

**测试分层**(后端版):

| 层级 | 目的 | 工具 |
|---|---|---|
| Service 单测 | 业务逻辑正确 | JUnit + Mockito |
| Controller 集成测 | HTTP 参数 / 响应 / 错误码 | MockMvc |
| 端到端接口 | 真实 DB + 真实 HTTP | Postman / Newman / HTTP 测试 |

**必覆盖场景**:
- ✅ Happy path(每个接口主要成功路径)
- ✅ 参数校验失败(400)
- ✅ 业务冲突(500001 之类)
- ✅ 并发场景(幂等性 / 乐观锁)

**🚧 Phase 3 门禁**:
- ✅ Service 单测 + MockMvc 集成测全绿
- ✅ 每个接口至少一条成功 + 一条失败测试
- ❌ "测试后面补" → 拒绝,编码完成就要测试
- ❌ 覆盖率 < 70% 且无解释 → 补测

## Phase 4:和前端联调前最后自检

**🎯 目标**:准备好让前端开始联调,不让前端吃屎。

**自检清单**:
- [ ] 所有接口 Postman/Knife4j 能调通
- [ ] 返回的字段名、类型、枚举值 100% 对齐 spec
- [ ] 错误码都返回(不只 0)
- [ ] 数据库数据有样本(不是空库)
- [ ] CORS 配置正确(前端跨域能访问)
- [ ] 鉴权机制文档化(Cookie / Token 怎么传)

**🚧 Phase 4 门禁**:
- ✅ 上述 6 项全过
- ✅ 已告知前端"可以开始联调"
- ❌ "有个接口没写完先联调" → 让前端等,不要挖坑

## 下一步

- 编码完成 → `backend-integration` 和前端联调
- 所有接口测通 → `backend-retrospective` 复盘

## 常见卡点

| 卡点 | 做法 |
|---|---|
| 接口 spec 有歧义 | 停下,回 backend-interface 澄清,别猜 |
| 前端说字段对不上 | 先 curl 自己接口确认返回,再和前端对比(大概率是 JSON 字符串问题) |
| 数据库设计改了 | 同步更新接口 spec + 通知前端(走变更流程) |
| 性能不达标 | 先看 SQL(索引 / N+1 查询),再看缓存 |

## 写入日志

```json
{
  "timestamp": "ISO 8601",
  "skill": "backend-coding",
  "apis_implemented": 15,
  "service_tests": 50,
  "mockmvc_tests": 92,
  "coverage": "82%",
  "curl_verified": true,
  "outcome": "ready_for_integration"
}
```
