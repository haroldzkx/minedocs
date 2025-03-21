# React 18 语法

官方文档: [https://18.react.dev/reference/react](https://18.react.dev/reference/react)

React 中使用 JS 表达式

1. 使用引号传递字符串
2. 使用 javascript 变量
3. 函数调用和方法调用
4. 使用 javascript 对象

## 事件

事件绑定: [https://18.react.dev/learn/responding-to-events](https://18.react.dev/learn/responding-to-events)

1. 基础事件绑定: [https://18.react.dev/learn/responding-to-events#adding-event-handlers](https://18.react.dev/learn/responding-to-events#adding-event-handlers)
2. 使用事件对象参数: 在事件回调函数中设置形参 e [https://18.react.dev/learn/responding-to-events#capture-phase-events](https://18.react.dev/learn/responding-to-events#capture-phase-events)
3. 传递自定义参数: [https://18.react.dev/learn/responding-to-events#reading-props-in-event-handlers](https://18.react.dev/learn/responding-to-events#reading-props-in-event-handlers)
4. 同时传递事件对象 e 和自定义参数: 在事件绑定的位置传递事件实参 e 和自定义参数，clickHandler 中声明形参，注意顺序对应

## JSX

条件渲染: [https://18.react.dev/learn/conditional-rendering](https://18.react.dev/learn/conditional-rendering)

复杂条件渲染: 自定义函数 + if 判断语句

列表渲染: [https://18.react.dev/learn/rendering-lists](https://18.react.dev/learn/rendering-lists)

## 样式

行内样式（不推荐）: [https://18.react.dev/learn/javascript-in-jsx-with-curly-braces#using-double-curlies-css-and-other-objects-in-jsx](https://18.react.dev/learn/javascript-in-jsx-with-curly-braces#using-double-curlies-css-and-other-objects-in-jsx)

class 类名控制样式: [https://18.react.dev/learn#adding-styles](https://18.react.dev/learn#adding-styles)

## Hooks

自定义 Hook: [https://18.react.dev/learn/reusing-logic-with-custom-hooks](https://18.react.dev/learn/reusing-logic-with-custom-hooks)

Hooks 使用规则: [https://18.react.dev/reference/rules/rules-of-hooks](https://18.react.dev/reference/rules/rules-of-hooks)

useState: [https://18.react.dev/reference/react/useState](https://18.react.dev/reference/react/useState)

useRef: [https://18.react.dev/reference/react/useRef](https://18.react.dev/reference/react/useRef)

## Components

自定义 Component: [https://18.react.dev/learn/your-first-component](https://18.react.dev/learn/your-first-component)

## 组件通信

组件通信就是组件之间的数据传递，根据组件嵌套关系的不同，有不同的通信方法

props: [https://18.react.dev/learn/passing-props-to-a-component](https://18.react.dev/learn/passing-props-to-a-component)

- 父子通信:
- 兄弟通信: 子传父，父传子。借助“状态提升”机制，通过父组件进行兄弟组件之间的数据传递。[https://18.react.dev/learn/sharing-state-between-components](https://18.react.dev/learn/sharing-state-between-components)
- 跨层通信: Context 机制 [https://18.react.dev/learn/passing-data-deeply-with-context](https://18.react.dev/learn/passing-data-deeply-with-context)

# 环境

npm: [npm](./react/npm.md)

# 第三方库

Redux: [Redux](./react/redux.md)

优化类名控制:

- classnames: 通过条件动态控制 class 类名的显示。[https://github.com/JedWatson/classnames#readme](https://github.com/JedWatson/classnames#readme)

生成唯一 id:

- uuid: [https://github.com/uuidjs/uuid#readme](https://github.com/uuidjs/uuid#readme)

- nanoid: [https://github.com/ai/nanoid#readme](https://github.com/ai/nanoid#readme)

时间格式化:

- dayjs: [https://day.js.org/docs/en/installation/installation](https://day.js.org/docs/en/installation/installation)

生成模拟数据:

- json-server:

发送请求:

- axios:

```jsx
// 自定义Hook封装数据请求逻辑
function useGetList() {
  // 获取接口数据渲染
  const [commentList, setCommentList] = useState([]);

  useEffect(() => {
    // 请求数据
    async function getList() {
      // axios请求数据
      const res = await axios.get("http://localhost:3004/list");
      setCommentList(res.data);
    }
    getlist();
  }, []);

  return {
    commentList,
    setCommentList,
  };
}

// 调用自定义数据请求Hook
const { commentList, setCommentList } = useGetList();
```

# 项目目录结构

项目的渲染路径

```bash
App -> index.js -> public/index.html(root)
```

```bash
project_name/
  node_modules/
    ...
  public/
    favicon.ico
    index.html
    logo.png
    manifest.json
    robots.txt
  src/
    compoents/
      FilterButton.js
      Form.js
      Todo.js
      xxx.js
      ...
    store/
      modules/
        channelStore.js
        counterStore.js
        xxx.js
        ...
      index.js
    App.js
    index.css
    index.js
  .gitignore
  package-lock.json
  package.json
  README.md
```
