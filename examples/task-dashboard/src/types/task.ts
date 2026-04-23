export enum TaskStatus {
  PENDING = 'PENDING',
  RUNNING = 'RUNNING',
  COMPLETED = 'COMPLETED',
}

export enum TaskType {
  DAILY = 'DAILY',
  WEEKLY = 'WEEKLY',
  ONEOFF = 'ONEOFF',
}

export interface Task {
  taskId: number;          // ⚠️ BUG 埋点:后端实际是 string
  taskName: string;
  taskType: TaskType;
  status: TaskStatus;
  rewardAmount: number;
  extConfig: {             // ⚠️ BUG 埋点:后端可能返回 JSON 字符串
    refreshType: string;
  };
  createdAt: string;
}
