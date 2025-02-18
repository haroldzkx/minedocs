# 【JSX 语法】

项目的渲染路径

```bash
App -> index.js -> public/index.html(root)
```

# 使用 JS 表达式

1. 使用引号传递字符串
2. 使用 javascript 变量
3. 函数调用和方法调用
4. 使用 javascript 对象

注意：if 语句，switch 语句，变量声明属于语句，不是表达式，不能出现在 `{ }`中

```jsx
const count = 100;

function getName() {
  return "jack";
}

function App() {
  return (
    <div className="App">
      {/* 使用引号传递字符串 */}
      {"this is a message"}
      {/* 识别JS变量 */}
      {count}
      {/* 函数调用 */}
      {getName()}
      {/* 方法调用 */}
      {new Date().getDate()}
      {/* 使用js对象 */}
      <div style={{ color: "red" }}>this is a div</div>
    </div>
  );
}
export default App;
```

# 列表渲染

在 JSX 中使用原生 JS 中的 map 方法遍历渲染列表

```jsx
const list = [
  { id: 1001, name: "vue" },
  { id: 1002, name: "react" },
  { id: 1003, name: "angular" },
];

function App() {
  return (
    <div className="App">
      <ul>
        {list.map((item) => (
          <li key={item.id}>{item.name}</li>
        ))}
      </ul>
    </div>
  );
}

export default App;
```

# 条件渲染

在 React 中，可以通过逻辑与运算符&&、三元表达式（?:）实现基础的条件渲染

```jsx
const isLogin = true;

function App() {
  return (
    <div className="App">
      {/* 逻辑与&& */}
      {isLogin && <span>this is span</span>}
      {/* 三元表达式 */}
      {isLogin ? <span>jack</span> : <span>loading...</span>}
    </div>
  );
}

export default App;
```

# 复杂条件渲染

自定义函数 + if 判断语句

```jsx
const articleType = 1; // 0 1 3

function getArticle() {
  if (articleType === 0) {
    return <div>我是无图文章</div>;
  } else if (articleType === 1) {
    return <div>我是单图模式</div>;
  } else {
    return <div>我是三图模式</div>;
  }
}

function App() {
  return (
    <div className="App">
      {/* 调用函数渲染不同的模板 */}
      {getArticle()}
    </div>
  );
}

export defaultApp;
```
