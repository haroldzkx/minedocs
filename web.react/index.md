项目目录结构

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

核心思想：

- 组件化开发，通过将复杂的用户界面拆分为独立的、可复用的组件

- 通过虚拟 DOM 来高效地更新页面，而不直接操作真实的 DOM

React 核心库

1. React：构建用户界面的 JavaScript 库

2. ReactDOM：将 React 组件渲染到浏览器中
