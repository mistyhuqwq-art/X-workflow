# 前端教训(38 条)

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

---

## 联调防御类

### #21 联调完成 = 浏览器走完全流程,不只是 curl 通
**触发**:宣告"接口联调完成"时。
**为什么**:curl 200 只证明 HTTP 通,无法发现 JSON 字段差异、前端 parse 错误、UI 显示异常等实际 bug。
**规则**:必须用浏览器打开目标页面,走完增/删/改/查全流程,才算联调完成。

### #22 自定义组件通过 antd DisabledContext 获取 disabled
**触发**:在 Form 中使用自定义组件(RadioCard/Chip/Switch 等)时。
**为什么**:自定义组件不继承 Form 的 disabled 上下文,查看模式下仍可编辑。
**规则**:
```typescript
import { DisabledContext } from 'antd/es/config-provider/DisabledContext';
const disabled = useContext(DisabledContext);
```
不通过 props 手传 disabled,让组件自动跟随 Form 上下文。

### #23 Mock 数据必须包含残缺记录
**触发**:用 Mock 数据开发时。
**为什么**:"完美"的 Mock 掩盖空字段问题,联调才发现 undefined 崩溃。
**规则**:Mock 至少包含 1 条"残缺记录"(部分字段为 null/undefined/空字符串),验证空值防御逻辑。

### #24 奖励值等复杂字段需确认格式类型
**触发**:接收奖励值、配置值等看起来是数字的字段时。
**为什么**:后端可能用 `{"GLOBAL": "200"}` 对象格式而非 number,前端按 number 处理则回显为空。
**规则**:联调前先 console.log 打印实际字段类型,不靠字段名推断。

---

## 状态筛选类

### #25 枚举 → 后端状态码映射不能漏值
**触发**:做列表筛选、状态映射时。
**为什么**:漏了某个枚举值(如 offline:4)→ 选"已下线"无数据,静默失效。
**规则**:枚举定义后立即对照后端文档,枚举值全量覆盖,写测试验证所有分支。

### #26 状态展示需统一通过 resolveDisplayStatus 计算
**触发**:列表中有时间相关的派生状态(如"已结束")时。
**为什么**:漏了 ended 等派生状态时,已结束任务仍显示"已上线"。
**规则**:所有状态展示集中走一个 resolve 函数,不在多处分散判断。

---

## 权限系统类

### #27 权限码写完立即 grep 验证拼写
**触发**:写入权限码字符串常量后。
**为什么**:拼写错误(如 task-punish 应为 task-publish)导致发布权限检查完全失效。
**规则**:写完权限码后立即执行 `grep -rn '权限码' src/`,并与后端文档对照。

### #28 权限接口失败时应拒绝访问,不能全放行
**触发**:设计权限 API 失败时的降级策略。
**为什么**:空 permissions = 全放行,权限 API 一挂 = 等于无权限系统,高危。
**规则**:权限 API 失败 → 进入只读模式或显示错误,不能以"兼容"为由全放行。

---

## 部署配置类

### #29 staging 无 Vite proxy 时 API_BASE 要改为完整路径
**触发**:从本地联调环境部署到 staging 环境时。
**为什么**:本地用 proxy 不需要写路径前缀,staging 直连后端需要完整路径。
**规则**:`.env.staging` 和 `.env.production` 的 `VITE_API_BASE` 必须独立配置,不能和本地开发共用。

### #30 dev-only 逻辑泄漏生产是阻塞级问题
**触发**:Code Review 或上线前检查时。
**为什么**:测试占位用户、Mock 数据、调试日志进入生产 = 安全漏洞 + 数据污染。
**规则**:所有 dev-only 代码用 `import.meta.env.DEV` 包裹,CR checklist 必检此项。

---

## 性能优化类

### #31 搜索输入框必须 debounce
**触发**:为搜索框绑定 onChange 触发 API 请求时。
**为什么**:每字符触发一次 API = 接口压力 + 用户体验差。
**规则**:搜索输入 debounce 300-500ms,使用 useDebounce hook 统一处理。

### #32 状态计数接口避免并发 N 次请求
**触发**:需要获取多状态分别计数时。
**为什么**:并发 6 个请求拿 6 个状态数量,浪费接口资源。
**规则**:后端提供一个合并接口,或前端做请求合并,避免并发多次相同接口。

---

## React 编码类

### #33 useState 连续设同值不触发 re-render
**触发**:需要触发查询刷新时(如点击同一个查询条件)。
**为什么**:React 的 state bail-out 机制,连续 `setState(sameValue)` 不会 re-render。
**规则**:用计数器方式触发强制刷新:
```typescript
const [queryTrigger, setQueryTrigger] = useState(0);
// 触发时: setQueryTrigger(t => t + 1)
```

### #34 项目只使用一种包管理器
**触发**:项目初始化或添加依赖时。
**为什么**:同时存在 yarn.lock 和 package-lock.json 会导致依赖版本不一致。
**规则**:项目开始时确定一种包管理器(yarn/npm/pnpm),删掉其他 lock 文件并写入项目规范。

---

## Mock 开发类

### #35 写 Mock 前必须 grep 前端实际字段名
**触发**:开始写 Playwright page.route / MSW mock 时。
**为什么**:transform 层改名导致 mock 字段名和前端实际读取的字段名不一致,mock 永不生效,联调才暴露。
**规则**:第一步 `grep -rn '目标字段' src/`,确认前端代码真正读的字段名,再写 fulfill 响应体。

### #36 Figma 组件库不过 80% 不出原型
**触发**:组件库首版想直接画页面原型时。
**为什么**:组件库可用度 40% 时出原型,引用错误组件导致交付后返工 5h+。
**规则**:原子/分子/有机体三层 review 综合可用度 ≥ 80% 再进原型帧阶段。

### #37 Mock 开发必有字段映射文档且双方签字
**触发**:后端未就绪先用 Mock 并行开发时。
**为什么**:前端单方面定 Mock 字段 → 联调暴露 40% 字段差异 → 6 天修 41 bug（某营销后台 实录）。
**规则**:开 Mock 开发前,前后端共同产出双向映射表(前端字段 ↔ 后端字段 ↔ PRD 描述)并签字,不能前端单方面定。

---

## AI 协作类

### #38 Agent 自报成绩必须独立核验（4 类作弊）
**触发**:让 AI 子代理跑测试/review 并自报结果时。
**为什么**:AI 存在 4 类作弊模式:虚报 passed / skip 掩盖 / 改配置绕过 / 脚注藏 TODO。Day 2 AI 报"7/7 通",Day 3 人测发现 15 个问题。
**规则**:主代理独立重跑 + 按四桶汇报(✅ 通过 / 🖐 手动验 / ⚠️ 跳过原因 / ❌ 失败),不信单行"all passed"汇报。

### #39 dev 跑通 ≠ staging/prod 跑通(三步验证 SOP)
**触发**:改 proxy / env var / rewrite 规则 / 鉴权 任一项时。
**为什么**:与 #29 互补 — #29 讲"怎么配置",本条讲"怎么验证配置对不对"。2026-04-23 `NODE_SCOPED_PATTERNS` 翻车实录:dev 本地跑通,staging 构建后同一路径 404,因为 dev 的 proxy 在 staging 不生效。
**规则**:三步验证必走全 — (1) `tsc && build` 验证构建过 → (2) dev server 跑一遍 curl 关键路径 → (3) **模拟 staging/prod 构建的运行时行为**(grep 构建产物里的 env / `npm run build && npx serve dist` + 直发后端域名)。dev 跑通不等于上线跑通,第 (3) 步必做。
