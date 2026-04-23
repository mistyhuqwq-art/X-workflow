---
name: frontend-testing
description: 前端测试 skill。编码完成后,引导前端设计测试策略 + 产出 Playwright 用例 + 跑通 4 层分层测试。触发场景:用户说"写测试"、"写 E2E"、"自动化测试"、或 workflow-start 路由到此 skill。
---

# Frontend-Testing — 前端测试工作流

你是前端测试环节的引导专家。目标:**让测试真的能发现 bug,不是凑 coverage 数**。

## 核心原则

> **72 条 UI 存在性用例全绿,但 batchId 传错(string→number)—— 只有 Layer 3 验 API 参数才能发现**。测试必须分层,不能只验 UI 存在。

**Layer 1 全绿 ≠ 没问题**,这是 某 B 端中台项目 项目最痛的教训。

## 4 层测试分层架构

这是 **某 B 端中台项目 实战验证** 的分层(共 927 条用例,分层覆盖):

| 层级 | 用例数(示例) | 验什么 | 发现什么级别的问题 |
|---|---|---|---|
| **Layer 1:UI 存在性** | 72 条 | 页面渲染、组件存在 | 组件缺失、路由错误 |
| **Layer 2:回归测试** | 10 条 | 已修 bug 不复发 | 回归 bug |
| **Layer 3:端到端数据流** | 3 条 | API 参数正确性 | **字段映射错误** ⭐ 最关键 |
| **Layer 4:异常边界** | 10 条 | 错误处理、边界条件 | 健壮性问题 |

**关键认知**:4 层**缺一不可**,数量比例可以是金字塔(Layer 1 最多、Layer 3 最精)。

## 引用资产

本 skill 深度依赖以下资产,执行时按需读取:

- 📚 **[前端教训全集](../../lessons/by-role/frontend.md)** — 72 条用例全绿但字段传错的教训,以及 Layer 3 验 API 参数的必要性
- 📚 **[QA 教训全集](../../lessons/by-role/qa.md)** — 测试分层经验共享:4 层分层架构与 QA 策略高度重叠,执行前参考

## 门禁原则(Gate-based)

4 个 Phase,每个有明确产出和通过标准。

## Phase 0:前置对齐

- [ ] 编码完成(`frontend-coding` 已通过)
- [ ] 联调完成(`frontend-integration` 已通过)—— 或至少有 mock
- [ ] Playwright 环境就绪
- [ ] PRD v3.x 的 AC(验收标准)清单

**🚧 Phase 0 门禁**:
- ✅ 编码 / 联调都过了 `frontend-coding` / `frontend-integration` 的 Phase 3 验收
- ✅ PRD 7.N.8 的 G-W-T 验收清单已提取
- ❌ "代码还在改" → 写测试容易白写

## Phase 1:测试策略设计

**🎯 目标**:产出分层测试策略 + 用例数量预估 + 优先级。

### 1.1 分层策略

**Layer 1(UI 存在性,最大头)**:
- 每个页面至少 3 条:加载成功 / 主要组件存在 / 空态
- 每个 Modal/Drawer 至少 1 条
- 每个筛选器至少 1 条

**Layer 2(回归,由 bug 驱动)**:
- 每修复一个 bug → 加 1 条回归用例
- 命名约定:`bug-{id}-{description}`

**Layer 3(端到端数据流,最精,但必须有)**:
- 核心增删改查每个 1 条(验 API payload 是否正确)
- 用 Playwright 的 `page.on('request')` 拦截验 payload

**Layer 4(异常边界,验 6 类)**:
- 网络异常 / 权限 / 数据 / 并发 / 极值 / 兼容

### 1.2 优先级

| 优先级 | 何时写 | 放弃成本 |
|---|---|---|
| P0 Layer 3(数据流) | 必写,coding 后就写 | 放弃 = 上线出字段 bug |
| P1 Layer 1(核心页面) | 必写 | 放弃 = 基础回归无保障 |
| P2 Layer 4(核心边界) | 建议写 | 放弃 = 上线后客诉集中 |
| P3 Layer 2 / Layer 4(非核心) | 有空再写 | 可接受 |

**🚧 Phase 1 门禁**:
- ✅ 4 层都有明确数量预估
- ✅ Layer 3 至少覆盖核心增删改查
- ❌ 只写 Layer 1 就说"测试做完了" → 拒绝,必须有 Layer 3

## Phase 2:用例产出

**🎯 目标**:按策略写 Playwright 用例,通过率 100%。

### 2.1 Layer 1 示例

```typescript
test('TaskList 页面加载成功', async ({ page }) => {
  await page.goto('/tasks');
  await expect(page.getByRole('heading', { name: '任务列表' })).toBeVisible();
  await expect(page.getByRole('table')).toBeVisible();
});
```

### 2.2 Layer 3 示例(最关键)

```typescript
test('创建任务时 API payload 正确', async ({ page }) => {
  await page.goto('/tasks/new');

  // 监听请求
  const requestPromise = page.waitForRequest(req =>
    req.url().includes('/api/tasks') && req.method() === 'POST'
  );

  await page.fill('[name="taskName"]', '测试任务');
  await page.selectOption('[name="taskType"]', 'DAILY');
  await page.click('button:has-text("提交")');

  const request = await requestPromise;
  const payload = request.postDataJSON();

  // 验字段名
  expect(payload).toHaveProperty('task_name');  // 后端字段
  expect(payload).not.toHaveProperty('taskName');  // 前端字段不能直接发

  // 验字段值
  expect(payload.task_name).toBe('测试任务');
  expect(payload.task_type).toBe('DAILY');  // 枚举值对齐
});
```

### 2.3 Layer 4 示例

```typescript
test('网络异常时展示兜底', async ({ page }) => {
  await page.route('**/api/tasks', route => route.abort('failed'));
  await page.goto('/tasks');
  await expect(page.getByText('加载失败')).toBeVisible();
  await expect(page.getByRole('button', { name: '重试' })).toBeVisible();
});
```

### 2.4 用例组织

```
e2e/
├── layer1-ui/              # UI 存在性
│   ├── tasks.spec.ts
│   └── users.spec.ts
├── layer2-regression/      # 回归
│   └── bug-fixes.spec.ts
├── layer3-dataflow/        # 数据流(最关键)
│   └── api-payload.spec.ts
└── layer4-boundary/        # 异常边界
    └── network-errors.spec.ts
```

**🚧 Phase 2 门禁**:
- ✅ 4 层用例都有产出(不是只做 Layer 1)
- ✅ Layer 3 用例真的拦截了 request 验 payload
- ✅ 本地 `npx playwright test` 全绿
- ❌ "测试过了,一半绿就行" → 拒绝,必须 100% 绿

## Phase 3:覆盖率核对

**🎯 目标**:对照 PRD 的 G-W-T 清单,确认覆盖无遗漏。

**操作**:
1. 提取 PRD 每个功能模块的 7.N.8 G-W-T
2. 对每条检查:是否有 Playwright 用例对应?
3. 没对应的 → 补用例 或 明确"不测"并写理由

**❌ 不可接受的"不测"理由**:
- "太复杂没法测" → 拆小点再测
- "偶发的测不出来" → 那就真实环境跑

**✅ 可接受的"不测"理由**:
- 第三方支付 / 短信验证码(依赖外部,用 mock)
- 非核心路径(P2 级别,评估后接受不测)

**🚧 Phase 3 门禁**:
- ✅ PRD G-W-T 覆盖率 ≥ 80%(核心路径 100%)
- ✅ 不测的项都有明确理由
- ❌ 覆盖率 < 80% 且无解释 → 回 Phase 2 补

## Phase 4:CI 接入 + 稳定性

**🎯 目标**:测试接入 CI,每次 push 自动跑。

**检查**:
- [ ] CI 配置已加 Playwright 步骤
- [ ] 本地能跑通、CI 也能跑通(环境一致性)
- [ ] flaky 用例识别(3 次运行成功率)
- [ ] 失败时能看到 trace(Playwright trace viewer)

**🚧 Phase 4 门禁**:
- ✅ CI 能跑通,3 次连续成功
- ✅ 没有 flaky 用例(或 flaky 已标记 skip + 跟踪)
- ❌ "本地能跑 CI 跑不了" → 修环境,不是 skip 测试

## 下一步

测试完成后:
- 联调 + 测试都通过 → 调用 `frontend-retrospective` 进入复盘
- 有新测试发现的 bug → 回 `frontend-coding` 修复并加 Layer 2 回归

## 常见卡点

| 卡点 | 做法 |
|---|---|
| Layer 3 难写(不会拦截 request) | 参考 Playwright 文档 page.on('request') |
| Mock 和真实不一致 | 用 page.route 做 mock,和生产一致的 response 结构 |
| 测试太慢 | 并行跑 workers、只跑 changed files、Layer 1 和 Layer 3 拆开执行 |
| CI 不稳定 | headless 模式 + retry: 1 + trace on-failure |

## 写入日志

```json
{
  "timestamp": "ISO 8601",
  "skill": "frontend-testing",
  "total_cases": 95,
  "by_layer": {
    "layer1_ui": 72,
    "layer2_regression": 10,
    "layer3_dataflow": 3,
    "layer4_boundary": 10
  },
  "prd_gwt_coverage": "92%",
  "ci_integrated": true,
  "flaky_count": 0,
  "outcome": "testing_complete"
}
```
