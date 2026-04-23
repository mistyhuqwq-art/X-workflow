# Task Dashboard - 前端联调示例项目

> 这是 workflow-dlc 的示例项目,模拟前端·联调场景。

## 技术栈
- React 19 + TypeScript 5.5 + Vite 8
- Ant Design 6.x
- Tailwind CSS v4
- Zustand(状态管理)
- Playwright(E2E)

## 接口规范
- 所有 API 返回格式:{ code: 0, data: T, message: string }
- 枚举值与后端保持完全一致,不起别名
- JSON 字符串字段一律 safe parse

## 当前阶段
前端代码已完成,后端接口已 ready,正在联调阶段。

## 故意埋的 bug(测试用)
走 frontend-integration skill 时应该能识别出来:
1. src/types/task.ts: taskId 类型不对(number vs 后端 string)
2. src/pages/TaskList.tsx: extConfig 当成对象访问(实际是 JSON 字符串)
3. src/api/task.ts: catch 吞掉了 err.message
