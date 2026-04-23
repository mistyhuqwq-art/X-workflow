# Top Critical Lessons —— 跨项目必读的 6 条致命教训

> 来自真实项目踩坑。每条都是"用 2 小时起步换来的"。

所有 skill 都应该提醒用户这 6 条,尤其是前端·联调 + 推公开仓库前。

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

## #6 推公开仓库前必做隐私扫描 🔒

**触发场景**:workflow-dlc / skill 包 / 任何工作流文档 push 到公开仓库前。
**为什么**:内部飞书链接、项目名、团队关键词一旦进公开仓库,即使后来删了,**git 历史永久保留**。clone 仓库的人 `git log -p` 能看到所有历史泄漏。修复成本极高(删仓重建 or filter-repo 重写历史)。

**真实代价**:本 workflow-dlc 首次 push 就因此泄漏 18 处飞书链接 + 17 个文件的内部项目名,后来不得不删仓重建。

### 强制扫描脚本(push 前跑)

```bash
# push 前必跑这个扫描,有任何输出就不许 push
grep -rEi "mi\.feishu|www\.feishu|{你公司名}|{内部系统名}|{项目内部代号}" . \
  --include="*.md" --include="*.yml" --include="*.json" \
  2>/dev/null | grep -v ".git"
```

### 脱敏替换的原则

| 敏感类型 | 如何脱敏 |
|---|---|
| 内部文档链接 | 改为"见维护者私有 registry"或完全删除 |
| 内部项目名(如 某 B 端中台项目) | 改为通用描述(如"某 B 端中台项目") |
| 公司名 / 团队名 | 删除,或改"企业内部" |
| 内部人员名 | 删除或匿名化 |
| API 路径 / 内部系统 URL | 删除或改占位符 |

### 分层管理原则

```
公开仓库 = 方法论 + 工作流框架(通用化)
私有位置 = 真实资料链接 + 项目名 + 团队信息
```

**两边分开维护,永远不混**。工作时私有 registry 查真实信息,但只有脱敏后的方法论进公开仓库。

### 防泄漏 checklist

- [ ] 全文搜索过公司名 / 内部项目名 / 内部系统 URL
- [ ] `grep mi.feishu` 等内部链接关键词 = 0 匹配
- [ ] 示例数据都是虚构的(非真实用户名 / 邮箱 / token)
- [ ] 配置文件(.env / config.json)没被意外带入
- [ ] git 历史也要干净(新仓库优先,或 filter-repo 重写)

### 检测不到就删仓重建

如果发现**已经 push 了**敏感内容,优先级排序:
1. **P0 最彻底**:删远程仓库 → 新建同名 → push 脱敏版(git 历史完全清空)
2. **P1 保留历史**:`git filter-repo` 重写历史 + force push(复杂,可能有人已 fork)
3. **P2 只改当前**:只改当前文件(**最危险**,clone 者 `git log` 能看到全部历史)

---

## 使用方式

- 任何 skill 都可以 `@reference` 这个文件
- 前端·联调 skill 自动在 Phase 2 开始前让用户读一遍
- **workflow-dlc / 任何公开项目 push 前必读 #6**
- 新成员上手项目时的"必读材料"
