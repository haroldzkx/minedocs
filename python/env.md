# 本地 Docker + VSCode

```yaml
# docker compose up -d
services:
  python-project-name:
    image: registry.cn-shenzhen.aliyuncs.com/haroldfinch/python:3.10.16-slim-bookworm-arm
    container_name: python-project-name
    volumes:
      - ./src:/home/work
    command: ["tail", "-f", "/dev/null"]
    restart: always
```

1. 启动 docker 容器：`docker compose up -d`

2. VSCode 左下角 -> Attach to Running Container...

# 安装库

通常使用的是下面的方式

```bash
pip install xxx
```

对于经常使用的库，可以考虑离线安装，比如 Django

```bash
# 下载 Django 和它的所有依赖包的 .whl 文件
# 也可以去 https://pypi.org/project/ 这里下载 xxx.tar.gz 源码安装文件
pip download django==5.1.7

# 安装库及其依赖库
pip install path/to/*.whl
```
