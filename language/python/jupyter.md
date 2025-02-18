# 【Jupyter】

# 配置文件

```bash
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser

# 如果你不想每次启动 JupyterLab 都输入长命令，可以修改 JupyterLab 的配置文件：
# 生成 Jupyter 配置文件（如果还没有的话）：
jupyter lab --generate-config

# 打开配置文件（默认在 ~/.jupyter/jupyter_notebook_config.py）：
vim ~/.jupyter/jupyter_notebook_config.py

# 修改以下配置项：
c.ServerApp.ip = '0.0.0.0'  # 监听所有网络接口
c.ServerApp.port = 8888      # 设置端口号
c.ServerApp.open_browser = False  # 禁止自动打开浏览器
```

# Jupyter Docker

Jupyter Docker Stacks: [https://jupyter-docker-stacks.readthedocs.io/en/latest/index.html](https://jupyter-docker-stacks.readthedocs.io/en/latest/index.html)

选择镜像: [https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#)

镜像之间的关系: [https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#image-relationships](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#image-relationships)

```yaml
services:
  jupyter-pure:
    container_name: jupyter-pure
    image: registry.cn-shenzhen.aliyuncs.com/haroldfinch/jupyter:3.10.11-base-arm
    volumes:
      - ./notebook:/home/jovyan/work
    environment:
      - GRANT_SUDO=yes
    ports:
      - 8888:8888
    # command: ["tail", "-f", "/dev/null"]
    command: ["jupyter", "lab"]
```

## 添加 sudo 权限

```yaml
# docker-compose.yml
environment:
  - GRANT_SUDO=yes
```

# 方案 1

在工作目录中放置三个文件：`Dockerfile`, `docker-compose.yaml`, `requirements.txt`

然后可以一键启动：`docker compose up`

```dockerfile
# ubuntu 22.04, python 3.8
FROM quay.io/jupyter/base-notebook:7285848c0a11

COPY --chown=${NB_UID}:${NB_GID} requirements.txt /tmp/

RUN mamba install --yes --file /tmp/requirements.txt && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"
```

```yaml
services:
  jupyter:
    container_name: jupyter-py38
    build:
      context: .
      dockerfile: Dockerfile
    image: hh-jupyter # set image name
    volumes:
      - ./notebook:/home/jovyan/work
    ports:
      - 8888:8888
```

```plain
loguru
pandas
...
```

# 方案 2

一键启动：`docker compose up ; docker logs --tail 2 container_name`

1. 进入 Jupyter 后手动安装第三方库和其他 Jupyter 插件

```yaml
services:
  jupyter-pure:
    container_name: project-name
    image: quay.io/jupyter/base-notebook:7285848c0a11
    volumes:
      - ./notebook:/home/jovyan/work
    ports:
      - 8888:8888
    command: ["tail", "-f", "/dev/null"]
```

2. 获得 jupyter 的链接（查看 jupyter notebook 的 token）

```bash
# 进入容器，用这个命令
jupyter server list

# 不进入容器，用这个命令
docker logs --tail 2 container_name
```

3. 创建一个 ipynb 文件用于安装第三方库及配置环境等

```python
!pip install -i https://pypi.mirrors.ustc.edu.cn/simple pandas, loguru,...
```
