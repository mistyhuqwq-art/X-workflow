import { Task } from '../types/task';

const BASE = '/api/tasks';

export async function fetchTaskList(): Promise<Task[]> {
  const res = await fetch(BASE);
  const json = await res.json();
  return json.data;
}

export async function createTask(task: Partial<Task>): Promise<Task> {
  const res = await fetch(BASE, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(task),
  });
  const json = await res.json();
  if (json.code !== 0) {
    throw new Error('提交失败,请重试');  // ⚠️ BUG 埋点:吞掉了后端错误
  }
  return json.data;
}
