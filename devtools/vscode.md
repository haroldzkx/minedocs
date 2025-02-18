# settings.json

左下角齿轮 -> Settings -> 右上角转换符号打开 settings.json 文件

```json
{
  // 设置编辑器字体
  "editor.fontSize": 16,
  // 设置菜单栏大小
  "window.zoomLevel": 0.5,
  // 设置代码格式自动调整
  "editor.formatOnType": true,
  "editor.formatOnSave": true,
  // 设置启动时不显示欢迎界面
  "workbench.startupEditor": "none",
  // 设置python interpreter路径
  "python.defaultInterpreterPath": "YOUR/PATH",
  // 设置terminal字体大小
  "terminal.integrated.fontSize": 16,
  "extensions.ignoreRecommendations": true,
  "notebook.lineNumbers": "on"
}
```

# 连接 Docker 开发

## 连接 Docker（本地）

1. 启动容器，注意做好目录映射
2. 在 VSCode 的 Docker 插件里，找到容器，然后右键 Attach Visual Studio Code 就可以连接到 Docker 容器
3. Open Folder 打开容器里的文件夹

Connect to Host -> Configure SSH Hosts... -> /Users/xxx/.ssh/config -> 配置用户名和 IP 地址 -> 选择远程 SSH 地址

## 连接 Docker（服务器）

不用在容器内安装 ssh 服务就可以将远程服务器中的 docker 容器作为开发环境

其实 ssh 连接服务器就好了，然后 remote-container 和 docker 扩展就可以连接到容器里面了，没必要去容器里装 ssh, 这也不符合 docker 的理念

装上 remote development 和 docker,正常 ssh 连接到服务器，这时候左边可以看到小鲸鱼，点一下上面可以看到容器和镜像列表，右键容器可以运行，或者直接输命令也行，运行后再运行的容器上右键点 attach to vscode 会打开个新窗口，初次打开要等一会儿，vscode 会在上面装 server 端，然后就能用了，左边也能直接看到容器里的文件，挺方便的

# Python 虚拟环境配置

在 vscode 中的 settings.json 中添加如下配置

```bash
"python.venvPath": "/Users/kxz/pyenvs", // 这里是你的虚拟环境存放位置
"python.venvFolders": [
    ".jupyter", // 这里是你的虚拟环境名称，也就是文件名
],
```

# LaTeX

```bash
{
  // 设置LaTeX环境
  "latex-workshop.latex.recipes": [
    {
      "name": "xelatex",
      "tools": [
        "xelatex"
      ]
    },
    {
      "name": "xe*2",
      "tools": [
        "xelatex",
        "xelatex"
      ]
    },
    {
      "name": "latexmk",
      "tools": [
        "latexmk"
      ]
    },
    {
      "name": "xelatex -> bibtex -> xelatex*2",
      "tools": [
        "xelatex",
        "bibtex",
        "xelatex",
        "xelatex"
      ]
    },
    {
      "name": "pdflatex -> bibtex -> pdflatex*2",
      "tools": [
        "pdflatex",
        "bibtex",
        "pdflatex",
        "pdflatex"
      ]
    }
  ],
  "latex-workshop.latex.tools": [
    {
      "name": "latexmk",
      "command": "latexmk",
      "args": [
        "-synctex=1",
        "-interaction=nonstopmode",
        "-file-line-error",
        "-pdf",
        "%DOC%"
      ]
    },
    {
      "name": "pdflatex -> bibtex -> pdflatex*2",
      "command": "xelatex",
      "args": [
          "pdflatex",
          "bibtex",
          "pdflatex",
          "pdflatex"
      ]
    },
    {
      "name": "xelatex",
      "command": "xelatex",
      "args": [
        "-synctex=1",
        "-interaction=nonstopmode",
        "-file-line-error",
        "%DOC%"
      ]
    },
    {
      "name": "pdflatex",
      "command": "pdflatex",
      "args": [
        "-synctex=1",
        "-interaction=nonstopmode",
        "-file-line-error",
        "%DOC%"
      ]
    },
    {
      "name": "bibtex",
      "command": "bibtex",
      "args": [
        "%DOCFILE%"
      ]
    }
  ],
  "latex-workshop.view.pdf.viewer": "tab",
  "latex-workshop.latex.clean.fileTypes": [
    "*.aux",
    "*.bbl",
    "*.blg",
    "*.idx",
    "*.ind",
    "*.lof",
    "*.lot",
    "*.out",
    "*.toc",
    "*.acn",
    "*.acr",
    "*.alg",
    "*.glg",
    "*.glo",
    "*.gls",
    "*.ist",
    "*.fls",
    "*.log",
    "*.fdb_latexmk"
  ],
}
```

# 插件

## 通用

Git Graph【mhutchie】
Prettier - Code formatter【Prettier】
vscode-icons【VSCode Icons Team】
Error Lens【Alexander】

## 其他

Markdown Preview Enhanced【Yiyi Wang】
Live Server【Ritwick Dey】
