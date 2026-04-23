---
name: qa-cases
description: QA 用例产出 skill。测试策略通过后,按 4 层分层产出具体用例,存入用例库便于复用和回归。触发场景:用户说"写测试用例"、"用例设计"、"QA 用例"、或 workflow-start 路由到此 skill。
---

# QA-Cases — QA 用例产出工作流

你是 QA 用例产出环节的引导专家。目标:**每条用例都必须能发现 bug 或证明正确性,避免"凑数"用例**。

## 核心原则

> **用例不是写给 QA 看的,是写给"未来可能改这段代码的人"看的**。未来改代码时能看出"哪里可能被改坏"。

**好用例的标准**:
- 步骤清晰(复现成本 < 2 分钟)
- 预期明确(对 or 错一目了然)
- 独立性(不依赖其他用例的前置状态)
- 幂等性(多次跑结果一致)

## 引用资产

本 skill 深度依赖以下资产,执行时按需读取:

- 📚 **[QA 教训全集](../../lessons/by-role/qa.md)** — 用例产出阶段的典型坑:凑数用例 / 独立性不足 / Layer 3 数据流用例缺失

## 门禁原则(Gate-based)

3 个 Phase。

## Phase 0:前置

- [ ] qa-strategy 已通过
- [ ] PRD G-W-T 清单已提取
- [ ] 接口 spec 已冻结(用于 Layer 3)
- [ ] 用例管理平台/文档位置已定

## Phase 1:按层产出用例

**🎯 目标**:4 层按优先级产出用例,每条用例完整可执行。

### 1.1 用例模板

```markdown
## Case-{层级}-{序号}:{标题}

**层级**: Layer 1 / 2 / 3 / 4
**模块**: {PRD 模块名}
**优先级**: P0 / P1 / P2 / P3
**前置条件**: {登录状态 / 数据状态 / 环境}
**操作步骤**:
  1. ...
  2. ...
**预期结果**:
  - ...
**实际结果**(执行时填):
  - ✅/❌ ...
**关联 PRD G-W-T**: #{G-W-T 编号}
**回归标记**: bug-{id}(仅 Layer 2 用)
```

### 1.2 Layer 1 用例示例(UI 存在性)

```markdown
## Case-L1-001:TaskList 页面正常加载

**层级**: Layer 1
**模块**: 任务列表
**优先级**: P1
**前置条件**: 已登录,有任务数据
**操作步骤**:
  1. 访问 /tasks
**预期结果**:
  - 页面标题"任务列表"显示
  - 表格组件渲染
  - 至少一行数据显示
**关联 PRD G-W-T**: 7.1.8 Case 1
```

### 1.3 Layer 3 用例示例(数据流,核心)

```markdown
## Case-L3-001:创建任务时 API payload 正确

**层级**: Layer 3
**模块**: 任务创建
**优先级**: P0
**前置条件**: 已登录
**操作步骤**:
  1. 打开 Network 面板
  2. 访问 /tasks/new
  3. 填写:任务名="测试"、类型=DAILY、奖励=100
  4. 点击提交
**预期结果**:
  - 请求 POST /api/tasks
  - Payload 字段:
    - `task_name`: "测试"(必须 snake_case)
    - `task_type`: "DAILY"(枚举值对齐)
    - `reward_amount`: 100(number)
  - 不能有 `taskName` / `taskType` 等 camelCase 字段
**关联 PRD G-W-T**: 7.3.8 Case 1
```

### 1.4 Layer 4 用例示例(边界,覆盖 6 类)

```markdown
## Case-L4-001:网络超时时展示兜底 + 重试

**层级**: Layer 4(网络异常类)
**模块**: 任务列表
**优先级**: P2
**前置条件**: 已登录
**操作步骤**:
  1. DevTools Network → Offline
  2. 访问 /tasks
**预期结果**:
  - 页面显示"加载失败"兜底
  - 有"重试"按钮
  - 恢复网络后点重试能正常加载
**关联 PRD 6 类边界**: 网络异常
```

**🚧 Phase 1 门禁**:
- ✅ 4 层都有用例
- ✅ 每条用例都完整(前置/步骤/预期/关联 PRD)
- ✅ PRD 每条 G-W-T 都有至少一条用例覆盖
- ❌ "大概这些用例吧" → 必须到明确条目

## Phase 2:自动化用例编写

**🎯 目标**:可自动化的用例用 Playwright/MockMvc 实现。

**自动化优先级**:
- ✅ P0 Layer 3 必须自动化(每次 CI 跑)
- ✅ P1 Layer 1 核心页面自动化
- 🟡 P2 Layer 4 重要边界自动化
- ❌ P3 可保留手工

**Playwright 模板**(Layer 3 最关键):

```typescript
test('创建任务 payload 正确', async ({ page }) => {
  await page.goto('/tasks/new');

  const reqPromise = page.waitForRequest(r =>
    r.url().includes('/api/tasks') && r.method() === 'POST'
  );

  await page.fill('[name="taskName"]', '测试');
  await page.selectOption('[name="taskType"]', 'DAILY');
  await page.click('button:has-text("提交")');

  const req = await reqPromise;
  const payload = req.postDataJSON();

  expect(payload).toHaveProperty('task_name', '测试');
  expect(payload).toHaveProperty('task_type', 'DAILY');
  expect(payload).not.toHaveProperty('taskName');
});
```

**🚧 Phase 2 门禁**:
- ✅ 可自动化的用例都自动化
- ✅ 自动化用例本地跑绿
- ❌ "手工测一下就行" → P0/P1 必须自动化

## Phase 3:用例库归档

**🎯 目标**:用例有组织地存放,可复用、可回归、可追溯。

**组织结构**:

```
tests/
├── layer1-ui/
│   ├── task-list.spec.ts
│   └── task-form.spec.ts
├── layer2-regression/
│   └── bugs.spec.ts           # 每修一个 bug 加一条
├── layer3-dataflow/           # ⭐ 最重要
│   ├── task-api.spec.ts
│   └── auth-api.spec.ts
├── layer4-boundary/
│   ├── network-errors.spec.ts
│   └── permissions.spec.ts
└── README.md                   # 用例索引
```

**README 索引**:

```markdown
# 测试用例索引

## Layer 1 UI 存在性(75 条)
- task-list.spec.ts:25 条
- task-form.spec.ts:30 条
- ...

## Layer 3 数据流(15 条)⭐ 核心
- task-api.spec.ts:POST 字段映射
- auth-api.spec.ts:token 传递
- ...
```

**🚧 Phase 3 门禁**:
- ✅ 用例按层级归档
- ✅ 有索引 README,说明每个文件测什么
- ❌ 全堆在一个文件 → 拒绝,分层管理是前提

## 下一步

- 用例准备好 → 等开发提测 → `qa-execution` 执行
- 每个 bug 修复后 → 补 Layer 2 回归用例

## 常见卡点

| 卡点 | 做法 |
|---|---|
| PRD 某些 G-W-T 写得模糊 | 问 PM 澄清,不自己猜 |
| 自动化写不出来 | 先手工补 case,列入技术债后补自动化 |
| 用例执行顺序依赖 | 重构用例,让每条独立 |
| 数据构造麻烦 | 用 API 造数据(POST /test-data),不用 UI 点 |

## 写入日志

```json
{
  "timestamp": "ISO 8601",
  "skill": "qa-cases",
  "total_cases": 130,
  "by_layer": {"layer1": 75, "layer2": 10, "layer3": 15, "layer4": 30},
  "automated": 100,
  "automation_rate": "77%",
  "gwt_coverage": "95%",
  "outcome": "ready_for_execution"
}
```
