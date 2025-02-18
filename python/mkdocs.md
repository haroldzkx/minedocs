# 【Mkdocs 构建网站】

# 1.安装环境

```bash
pip install mkdocs
pip install mkdocs-material
```

# 2.创建新网站

```bash
mkdocs new my-project
cd my-project
```

项目目录里文件如下所示：

- mkdocs.yml: yaml 文件，整个网站的配置文件
- docs: 存放 markdown 文档的地方

# 3.本地查看网站

```bash
mkdocs serve
```

运行该命令之后，打开 [http://127.0.0.1:8000](http://127.0.0.1:8000) 可以本地查看网站是什么样的

# 4.生成网站源文件

```bash
mkdocs build
```

该命令会在文件根目录下生成名称为 site 的文件夹，这就是生成的网站源代码，将这个部署到 github pages 里，就可以在线访问你的网站了。

但是实际上，如果想把网站部署到 Github pages 上面，这个命令并不需要。

# 5.mkdocs.yml 配置文件

使用 mkdocs-material 主题的话，一份配置文件如下，将下面的内容复制到 mkdocs.yml 文件中即可配置好主题：

```yaml
# mkdocs.yml
site_name: your site name
site_url: https://username.github.io/
nav:
  - Home: index.md
  - 模块1:
      - page/index.md
      - 子模块1:
          - 页面1: page/1.md
          - 页面2: page/2.md
      - 子模块2:
          - 页面3: page/3.md

theme:
  name: material
  favicon: images/favicon.ico
  logo: images/logo.jpeg
  # palette: # palette是用来设置主题颜色的
  #     primary: "black"
  #     accent: "deep orange"
  language: zh
  features:
    - content.code.copy
    - navigation.tabs # 顶部显示导航顶层nav（也就是第一个节点）
    - navigation.tabs.sticky # 滚动时隐藏顶部nav，配合navigation.tabs使用
    - navigation.tracking # 在url中使用标题定位锚点
    # - navigation.expand # 不折叠左侧nav节点
    # - navigation.sections # nav节点缩进
    - navigation.path
    - navigation.top # 一键回顶部
    - navigation.instant # 启用即时加载
    - navigation.indexes
    - toc.follow
markdown_extensions:
  - pymdownx.highlight:
      anchor_linenums: true
      linenums: true
  - pymdownx.inlinehilite
  - pymdownx.snippets
  - pymdownx.superfences
  - pymdownx.critic
  - pymdownx.caret
  - pymdownx.keys
  - pymdownx.mark
  - pymdownx.tilde
  # md图片配置：https://squidfunk.github.io/mkdocs-material/reference/images/
  - attr_list
  - md_in_html
  # 这个是设置页面支持latex公式的，下面四行都是
  - pymdownx.arithmatex:
      generic: true
extra_javascript:
  - https://polyfill.io/v3/polyfill.min.js?features=es6
  - https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js
```

# 6.git 版本管理并部署到 GitHub

在项目根目录下放一个.gitignore 文件，文件内容如下：

```latex
# Ignore all .DS_Store files
.DS_Store
**/.DS_Store
.DS_Store?

# Ignore static resource
site/
public/

# Ignore temp file
temp.txt
temp.py
book.sh
```

然后执行如下命令：

```shell
# 1.git仓库初始化，只执行一次
git init

# 2.将变动加入版本管理中
git add .
git commit -m "init"

# 3.给远程仓库添加别名，只执行一次

# 这里的hhzh是我自己取的别名(这里自己取喜欢的名字)
# 这里设置 hhzh   是为同步 main     分支
git remote add hhzh git@github.com:xxxx/xx.git
# 这里设置 origin 是为同步 gh-pages 分支
git remote add origin git@github.com:xxxx/xx.git

# 4.将主分支强制命名为main，只执行一次
git branch -M main

# 5.部署mkdocs
# 5.1 先将源码做同步
git add .
git commit -m "xxx"
git pull && git push -u hhzh main
# 5.2 再部署站点
mkdocs gh-deploy --force
```

上面是初次建站并部署到 GitHub 上的步骤，下面给出一个 git 自动化脚本

```bash
# MacOS / Linux
#message=$(date "+%Y-%m-%d %H:%M:%S")

git add .
git commit -m "$(date "+%Y-%m-%d %H:%M:%S")"

git fetch hhzh main && git merge hhzh FETCH_HEAD
# 或者用 git pull hhzh main

git push hhzh main
#git push -u hhzh main

mkdocs gh-deploy --force

### windows
# git add .
# git commit -m "%date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2%"
# git fetch hhzh main && git merge hhzh FETCH_HEAD
# # git pull hhzh main
# git push hhzh main
# mkdocs gh-deploy --force
```

# 7.本地脚本

```bash
source ~/pyvenv/mkdocs/bin/activate
cd ~/你的网站目录地址
mkdocs serve
```
