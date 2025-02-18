# VS Code

插件：在 VSCode 中左右分栏实时预览页面效果

- Live Server - Microsoft
- Live Preview - Ritwick Dey

# Node.js and Nvm

<details>
<summary>Install nvm ( linux )</summary>

```bash
# 离线安装 nvm

wget https://gitee.com/haroldzkx/repo/releases/download/nvm/nvm-0.40.3.tar.gz
# 也可以去官网这里下载 nvm 的源码包
# https://github.com/nvm-sh/nvm/releases

mkdir -p ~/.nvm
tar -zxvf nvm-0.40.3.tar.gz -C ~/.nvm

# 在 .bashrc 或 .bash_aliases 里添加如下内容
export NVM_DIR="/home/happy/.nvm/nvm-0.40.3"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source ~/.bashrc

# Verify
nvm -v
```

</details>

<details>
<summary>Install nvm ( Mac )</summary>

```bash
# install nvm
brew install nvm
mkdir ~/.nvm

vi ~/.zshrc
# 在 ~/.zshrc 配置文件后添加如下内容
export NVM_DIR="$HOME/.nvm"
 [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh" # This loads nvm
 [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
source ~/.zshrc
echo $NVM_DIR

# install node, npm
nvm install --lts
node -v
npm -v
```

</details>

<details>
<summary>Install nvm ( Windows )</summary>

```bash
# 去这里找安装包安装
https://github.com/coreybutler/nvm-windows/releases
# nvm-setup.exe
```

```bash
nvm version

# 在 settings.txt 中添加
node_mirror: https://npmmirror.com/mirrors/node/
npm_mirror: https://npmmirror.com/mirrors/npm/

nvm list available
nvm install 22.11.0
nvm use
nvm on
node -v
npm -v
nvm list
```

</details>

---

<details>
<summary>install node.js with nvm ( offline )</summary>

```bash
# 在这里找自己需要的 node 版本
# https://nodejs.org/download/release/

# 下载安装包
wget https://nodejs.org/download/release/latest-v22.x/node-v22.18.0-linux-x64.tar.gz

mkdir -p ~/.nvm/nvm-0.40.3/versions/node

# 解压
tar -zxvf node-v22.18.0-linux-x64.tar.gz -C ~/.nvm/nvm-0.40.3/versions/node

# 重命名
mv ~/.nvm/nvm-0.40.3/versions/node/node-v22.18.0-linux-x64 ~/.nvm/nvm-0.40.3/versions/node/v22.18.0

# 查看已安装的 node 版本
nvm ls
node -v
npm -v
npx -v
```

</details>

---

<details>
<summary>nvm commands</summary>

```bash
# 查看 nvm 版本
nvm -v

# 列出所有版本的 Node.js
nvm ls-remote

# 列出所有 LTS 版本的 Node.js
nvm ls-remote --lts

# 切换版本
nvm use 22.18.0
```

</details>

---

<details>
<summary>npm set mirror</summary>

```bash
# 方法1：使用淘宝镜像
npm config set registry https://registry.npmmirror.com

# 方法2：使用cnpm
npm install -g cnpm --registry=https://registry.npmmirror.com
cnpm install <package_name>

npm get registry
```

```bash
# Windows 配置镜像（没有验证，慎用）
# 在 nvm 的安装路径下有一个 settings.txt 文件
# 将下面两行内容添加到 settings.txt 文件中
node_mirror: https://npmmirror.com/mirrors/node/
npm_mirror: https://npmmirror.com/mirrors/npm/
```

</details>


# React

- [https://github.com/nonamenme/docker-react/](https://github.com/nonamenme/docker-react/)

- [https://www.silicloud.com/zh/blog/使用docker构建react的开发环境。/](https://www.silicloud.com/zh/blog/%E4%BD%BF%E7%94%A8docker%E6%9E%84%E5%BB%BAreact%E7%9A%84%E5%BC%80%E5%8F%91%E7%8E%AF%E5%A2%83%E3%80%82/)

## Docker

优化：将创建项目脚手架和获取项目目录通过 Docker 镜像自动完成

<details>
<summary>1.创建项目脚手架</summary>

<details>
<summary>&emsp;&emsp; 方法 1：手动创建</summary>

```bash
docker run -d --name cra-temp registry.cn-shenzhen.aliyuncs.com/haroldfinch/node:22.12.0-bookworm-slim-arm tail -f /dev/null

docker exec -it cra-temp /bin/bash

mkdir app && cd /app

npm config set registry https://registry.npmmirror.com

npm install -g create-react-app

npx create-react-app hellotest

cd /app/hellotest

npm install react@18 react-dom@18 web-vitals @testing-library/jest-dom @testing-library/react @testing-library/user-event
```

</details>

<details>
<summary>&emsp;&emsp; 方法 2：使用 Docker</summary>

```Dockerfile
# 基础镜像
ARG REPO=registry.cn-shenzhen.aliyuncs.com
ARG REPO_USER=haroldfinch
ARG VER=22.12.0-bookworm-slim-arm

FROM $REPO/$REPO_USER/node:$VER

# 配置 npm 镜像源
RUN npm config set registry https://registry.npmmirror.com

# 全局安装 create-react-app
RUN npm install -g create-react-app

# 创建项目目录
WORKDIR /app

# 使用 npx 创建 React 应用并安装依赖
RUN npx create-react-app hellotest && \
    cd hellotest && \
    npm install react@18 react-dom@18 web-vitals @testing-library/jest-dom @testing-library/react @testing-library/user-event

# 默认命令，不会立即启动应用
CMD ["tail", "-f", "/dev/null"]
```

```bash
docker build -t cra .
docker run -d --name cra-temp cra

# 这一步可以省略
docker exec -it cra-temp /bin/bash
```

</details>

</details>

<details>
<summary>2.获取项目目录</summary>

```bash
docker cp cra-temp:/app/hellotest ./
```

</details>

<details>
<summary>3.搭建开发环境</summary>

```Dockerfile
ARG REPO=registry.cn-shenzhen.aliyuncs.com
ARG REPO_USER=haroldfinch
ARG VER=22.12.0-bookworm-slim-arm
ARG PROJECT=hellotest

FROM ${REPO}/${REPO_USER}/node:${VER}

# 配置 npm 镜像源
RUN npm config set registry https://registry.npmmirror.com

WORKDIR /app

COPY $PROJECT/package.json $PROJECT/package-lock.json ./

RUN npm install

COPY $PROJECT/ .

CMD npm run start
```

```yaml
services:
  frontend:
    container_name: react-dev
    build:
      context: ./
    ports:
      - 3000:3000
    restart: always
    tty: true
    volumes:
      - ./:/app
      - ./hellotest:/app
      - react-node_modules:/app/node_modules
volumes:
   react-node_modules:
```

```bash
docker-compose up -d --build
```

</details>
