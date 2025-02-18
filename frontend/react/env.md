- [https://github.com/nonamenme/docker-react/](https://github.com/nonamenme/docker-react/)

- [https://www.silicloud.com/zh/blog/使用docker构建react的开发环境。/](https://www.silicloud.com/zh/blog/%E4%BD%BF%E7%94%A8docker%E6%9E%84%E5%BB%BAreact%E7%9A%84%E5%BC%80%E5%8F%91%E7%8E%AF%E5%A2%83%E3%80%82/)

# Docker

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
