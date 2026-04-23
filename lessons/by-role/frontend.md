# 前端教训(20 条)

> 来自 某 B 端中台 V1 项目(105+ 条)、某营销后台项目(L1-L49)的真实前端踩坑

---

## 字段契约类(联调最易踩)

### #1 后端 JSON 字段一律先 parse
**触发**:联调时嵌套对象字段看起来是 object。
**为什么**:后端可能把嵌套结构序列化成 JSON 字符串,直接访问 undefined。
**规则**:
```typescript
const extConfig = typeof detail.extConfig === 'string'
  ? JSON.parse(detail.extConfig)
  : detail.extConfig;
```

### #2 枚举值不能起别名
**触发**:定义前端枚举时。
**为什么**:别名看着语义更好,联调时前端传的后端不认。
**规则**:和后端完全一致,不起别名(`PROBABILITY` 不写成 `SAVE`)。

### #3 ID 类型以后端为准
**触发**:接收后端 ID 字段时。
**为什么**:后端 string 前端当 number,`find(id===xxx)` 永远 false。
**规则**:联调前先确认 ID 是 string 还是 number,不能擅自转。

### #4 catch 必须透传 err.message
**触发**:所有 API 调用的 catch 块。
**为什么**:吞掉后端具体错误 = 用户/开发都无法排查。
**规则**:`catch(err) { message.error(err?.message || '兜底文案') }`

### #5 时区字段默认假设 UTC
**触发**:拿到 `created_at` 这类时间字段。
**为什么**:后端常返 UTC,前端直接显示会差 8 小时。
**规则**:时间字段标注时区 + 前端用 dayjs 转本地时区展示。

---

## Ant Design 陷阱类

### #6 getFieldsValue 默认丢字段
**触发**:多 Tab 表单提交。
**为什么**:默认只返回可见字段,切 Tab 后数据拿不到。
**规则**:用 `getFieldsValue(true)` 拿全部注册字段。

### #7 Form.Item 嵌套会覆盖
**触发**:做复杂表单结构时。
**为什么**:嵌套 Form.Item 的外层会覆盖内层值。
**规则**:避免嵌套,或用不同 name 路径。

### #8 Select 的 value 严格等 options[].value
**触发**:下拉联动时。
**为什么**:string "1" 和 number 1 不匹配,下拉显示空。
**规则**:type 一致性,不要混 string/number。

### #9 Modal.confirm 异步要返回 Promise
**触发**:确认弹窗要等请求返回关闭。
**为什么**:不返回 Promise,确认按钮不 loading,用户重复点。
**规则**:onOk 返回 Promise,让 Modal 自己管 loading。

### #10 antd theme token 不是所有值都支持
**触发**:全局主题配置时。
**为什么**:类型定义未覆盖的 token 静默失败。
**规则**:不支持的值在组件内用 inline style。

---

## 编码质量类

### #11 不要加没要求的防御性代码
**触发**:写函数时容易"保险起见加 try-catch"。
**为什么**:过度实现增加复杂度,还掩盖真 bug。
**规则**:内部函数不校验,边界(用户输入、API)才校验。

### #12 三行相似不急抽,五次以上再抽
**触发**:看到相似代码想抽工具函数。
**为什么**:过早抽象 = 未来需求变化时抽象不对,反而妨碍。
**规则**:3 行以下不抽,5 次以上才抽。

### #13 命名代替注释
**触发**:想写注释解释代码做什么。
**为什么**:好的命名能取代 80% 的注释。
**规则**:默认不写注释,除非 WHY 很隐蔽(bug 历史、业务约束)。

### #14 枚举值 grep 自检
**触发**:写入权限码/字段名/API 路径常量后。
**为什么**:拼写错误静默失败,到联调才发现。
**规则**:写完立即 grep 一次,对比后端文档。

---

## 性能 / 构建类

### #15 tsc -b 和 vite build 都要跑
**触发**:push 前自检时。
**为什么**:vite build 不检查 TS6133(未使用变量)、TS2353(未知属性),CI 用 tsc -b 严格模式会卡。
**规则**:push 前必跑 `tsc -b && vite build`。

### #16 列表 map 里的 function 要 useCallback
**触发**:长列表渲染。
**为什么**:每次渲染创建新函数 → 子组件 rerender 失控。
**规则**:提到外面或 useCallback。

### #17 图片默认 loading="lazy"
**触发**:列表/详情页有图片。
**为什么**:首屏加载全部图片拖累性能。
**规则**:`<img loading="lazy">`。

---

## 测试类

### #18 测试不能只验 UI 存在
**触发**:写 E2E 测试时。
**为什么**:72 条 Layer 1 全绿,但 batchId 传错只有 Layer 3 能发现。
**规则**:4 层分层必齐,尤其 Layer 3(验 API payload)。

### #19 自动化用 data-testid 最稳
**触发**:写 Playwright selector。
**为什么**:CSS class 常变,text 多语言会变,data-testid 最稳定。
**规则**:关键元素加 `data-testid`,selector 优先选它。

---

## Figma 协作类

### #20 detach 后必须重绑 Text Style
**触发**:需要调整实例内部列宽等 override 不到的地方。
**为什么**:detach 断了和 Style 的关联,字体/颜色会乱。
**规则**:detach 后立即 findAll TEXT,重新绑 textStyleId。
