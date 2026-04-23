# Top Critical Lessons —— 跨项目必读的 5 条致命教训

> 来自 某 B 端中台 V1 项目 和 某营销后台项目 的真实踩坑。每条都是"用 2 小时换来的"。

所有 skill 都应该提醒用户这 5 条,尤其是前端·联调环节。

---

## #1 后端 JSON 字段一律先 parse

**触发场景**:联调时接口返回的某个字段看起来是对象。
**为什么**:后端可能把嵌套结构序列化成 JSON 字符串存储,返回时是字符串而非对象。直接访问属性会 undefined。

```typescript
// ❌ 错误
const refreshType = detail.extConfig.refreshType; // undefined

// ✅ 正确
const extConfig = typeof detail.extConfig === 'string'
  ? JSON.parse(detail.extConfig)
  : detail.extConfig;
```

---

## #2 枚举值不能起别名

**触发场景**:定义前端枚举类型时。
**为什么**:别名看着语义更好,但联调时前端传的值后端不认识。必须和后端完全一致。

```typescript
// ❌ 前端自己起名字
enum RewardType { SAVE = 'SAVE' }

// ✅ 和后端完全一致
enum RewardType { PROBABILITY = 'PROBABILITY' }
```

---

## #3 catch 必须透传 err.message

**触发场景**:所有 API 调用的 catch 块。
**为什么**:吞掉后端错误让用户无法自助排查,也让开发定位 bug 变困难。

```typescript
// ❌
catch (err) { message.error('提交失败,请重试'); }

// ✅
catch (err: any) { message.error(err?.message || '提交失败,请重试'); }
```

---

## #4 Form.getFieldsValue() 可能丢字段

**触发场景**:多 Tab 表单(如多语言表单)提交时。
**为什么**:默认只返回**可见**字段的值。切 Tab 后之前 Tab 填的值取不到。

```typescript
// ❌ 只拿当前可见字段
const values = form.getFieldsValue();

// ✅ 拿全部注册字段(包括不可见 Tab)
const values = form.getFieldsValue(true);
```

---

## #5 测试不能只验 UI 存在

**触发场景**:写 E2E 测试时。
**为什么**:UI 渲染通过 ≠ 数据传输正确。72 条 Layer 1 用例全绿,但 batchId 类型错传(string→number),只有 Layer 3 验 API 参数才能发现。

**4 层测试分层**(必须都有):

| 层 | 验什么 | 能发现 |
|---|---|---|
| Layer 1 | 组件渲染、页面加载 | 组件缺失 |
| Layer 2 | 已修 bug 不复发 | 回归 |
| Layer 3 | API 请求参数正确性 | **字段映射错误** |
| Layer 4 | 异常边界 | 健壮性 |

**规则**:联调后的测试必须包含 Layer 3,光验 Layer 1 是假安全感。

---

## 使用方式

- 任何 skill 都可以 `@reference` 这个文件
- 前端·联调 skill 自动在 Phase 2 开始前让用户读一遍
- 新成员上手项目时的"必读材料"
