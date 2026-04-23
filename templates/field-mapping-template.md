# 字段映射表模板

> 联调前 5 分钟产出,拦截 80% 的前后端契约 bug。

**使用方式**:复制本模板到 `knowledge-base/integration/field-mapping-{接口名}.md`,逐字段填写。

---

# 字段映射表 - {接口名}

**接口文档**:{飞书链接 / Swagger URL}
**产出时间**:{日期}
**对齐人**:前端 @xxx × 后端 @yyy

## 基础映射

| 前端字段 | 后端字段 | 类型 | 示例值 | 备注 |
|---|---|---|---|---|
| taskName | task_name | string | "春促活动" | - |
| taskType | task_type | enum | "DAILY" | 枚举值见下 |
| rewardAmount | reward_amount | number | 100 | 单位:分 |
| extConfig | ext_config | string(JSON) | `"{\"a\":1}"` | ⚠️ 需要 JSON.parse |
| batchId | batch_id | string | "CFG-001" | ⚠️ 非 number,比较时注意 |
| createdAt | created_at | string(ISO) | "2026-04-23T10:00:00Z" | UTC 时间,前端展示需转本地 |

## 枚举值对齐

### TaskType
| 前端常量 | 后端值 | 含义 |
|---|---|---|
| DAILY | "DAILY" | 每日任务 |
| WEEKLY | "WEEKLY" | 每周任务 |
| PROBABILITY | "PROBABILITY" | 概率任务(⚠️ 不要起别名 SAVE) |

### RewardType
| 前端常量 | 后端值 | 含义 |
|---|---|---|
| CASH | "CASH" | 现金奖励 |
| POINTS | "POINTS" | 积分奖励 |

## ⚠️ 关键差异告警

逐条列出已知的前后端差异,联调时重点验证:

1. **extConfig 是 JSON 字符串**
   - 现象:直接 `detail.extConfig.refreshType` 得到 undefined
   - 处理:
     ```typescript
     const extConfig = typeof detail.extConfig === 'string'
       ? JSON.parse(detail.extConfig)
       : detail.extConfig;
     ```

2. **batchId 是 string**
   - 现象:`batchId === 123`(number)永远 false
   - 处理:前端类型定义用 `string`,比较时显式转换或保持类型一致

3. **createdAt 是 UTC ISO 字符串**
   - 现象:直接显示会是 UTC 时间,用户看到晚 8 小时
   - 处理:用 dayjs/moment 转本地时区展示

## 错误码对齐

| 后端 code | 含义 | 前端处理 |
|---|---|---|
| 0 | 成功 | - |
| 400001 | 参数缺失 | 透传后端 message |
| 400002 | 参数类型错误 | 透传后端 message |
| 500001 | 业务规则冲突(如重复创建) | message.error + 高亮冲突字段 |
| 500002 | 数据库异常 | message.error 通用提示 |

## 验收

联调完成后勾选:

- [ ] 每个字段的**请求 payload** 都验过(Network 面板)
- [ ] 每个字段的**响应解析**都验过
- [ ] 枚举值前后端完全对齐(不改别名)
- [ ] JSON 字符串字段都做了 parse
- [ ] ID/数字字段的类型对齐
- [ ] 错误码的 message 都透传到 UI
- [ ] 时间字段的时区处理正确
