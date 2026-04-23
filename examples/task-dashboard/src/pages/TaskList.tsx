import { useEffect, useState } from 'react';
import { Table } from 'antd';
import { fetchTaskList } from '../api/task';
import { Task } from '../types/task';

export function TaskList() {
  const [data, setData] = useState<Task[]>([]);

  useEffect(() => {
    fetchTaskList().then(setData);
  }, []);

  return (
    <Table
      dataSource={data}
      columns={[
        { title: 'ID', dataIndex: 'taskId' },
        { title: '名称', dataIndex: 'taskName' },
        {
          title: '刷新',
          render: (_, row) => row.extConfig.refreshType,  // ⚠️ BUG:JSON 字符串当对象
        },
      ]}
    />
  );
}
