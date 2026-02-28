Python 多版本共存教程：https://zhuanlan.zhihu.com/p/509506199

# 国内镜像源

```bash
# 中科大源（临时使用）
pip install -i https://mirrors.ustc.edu.cn/pypi/simple package

# 中科大源（设为默认，长期使用）
pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/simple
```

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

方式:

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

# uv

<details>
<summary>离线安装 uv</summary>

```bash
# 下载合适的 uv 版本
wget https://github.com/astral-sh/uv/releases/download/0.8.12/uv-x86_64-unknown-linux-gnu.tar.gz

# Linux / Mac
# 1.解压到指定目录
tar -xzf uv-x86_64-unknown-linux-gnu.tar.gz -C /usr/local/
mv /usr/local/uv-x86_64-unknown-linux-gnu /usr/local/uv

# 2.添加环境变量
echo 'export PATH="/usr/local/uv:$PATH"' >> ~/.bashrc
echo 'export PATH="/home/xxx/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Windows
# 1.解压到 C:\uv
# 2.添加 C:\uv\bin 到系统环境变量 PATH
```

</details>

<details>
<summary>uv 离线安装 python</summary>

```bash
# 1. 使用这个命令获取 日期 和 文件名
uv python install --mirror file:///home/xxx/ 3.9.23
# $ uv python install --mirror file:///home 3.9.23 
# error: Failed to install cpython-3.9.23-linux-x86_64-gnu 
#   Caused by: failed to query metadata of file /home/20250723/cpython-3.9.23+20250723-x86_64-unknown-linux-gnu-install_only_stripped.tar.gz: No such file or directory (os error 2)
# 日期：20250723
# 文件名：cpython-3.9.23+20250723-x86_64-unknown-linux-gnu-install_only_stripped.tar.gz

# 2. 下载合适的 Python 版本（根据日期和文件名构造下载链接）
wget https://github.com/astral-sh/python-build-standalone/releases/download/日期/文件名

# 3. 构造目录
mkdir -p ~/Downloads/日期/
cd ~/Downloads/日期/
mv ~/Downloads/文件名 ~/Downloads/日期/文件名

# 4. Linux (gnu)
uv python install --mirror file:///home/xxx/ 3.9.23

# 4. Windows (msvc)
uv python install --mirror file:///C:/Users/xxx/Downloads/ 3.9.23
```

</details>

<details>
<summary>uv 在线安装 python</summary>

```bash
uv python install 3.8.20
uv python install 3.9.23
uv python install 3.10.18
uv python install 3.11.13
uv python install 3.12.11
# Python 安装在 /home/xxx/.local/share/uv/python
# 软链接在 /home/xxx/.local/bin

uv python list
```

</details>

<details>
<summary>uv 项目更换国内镜像源</summary>

```bash
# 临时使用
uv pip install numpy --default-index https://mirrors.ustc.edu.cn/pypi/simple
uv add numpy --default-index https://mirrors.ustc.edu.cn/pypi/simple

# 项目级别使用：两种方案 二选一
# 1.在项目目录下的 pyproject.toml 中添加
[[tool.uv.index]]
url = "https://mirrors.ustc.edu.cn/pypi/simple"
default = true

# 2.在项目目录下的 uv.toml 中添加
[[index]]
url = "https://mirrors.ustc.edu.cn/pypi/simple"
default = true
```

</details>

<details>
<summary>uv 常用命令</summary>

```bash
#----- Python 版本 -----
uv python install	3.11
uv python uninstall 3.11
uv python list					# 查看可用的 Python 版本
uv python list 3.11			# 只查看 3.11 版本的 Python
uv python find					# 查看 Python 解释器位置
uv python pin 3.11			# 为项目设置 Python 版本（在项目根目录下执行）

#----- 虚拟环境 -----
uv venv		# 创建虚拟环境，默认为 .venv
uv venv --python 3.12.0		# 指定 python 版本来创建虚拟环境
uv venv your_name				# 指定虚拟环境名
uv venv your_name --python 3.12.0

#----- 运行脚本 -----
uv run xxx.py
uv run --python 3.x xxx.py	# 指定版本运行脚本

```

</details>

<details>
<summary>初始化项目</summary>

```bash
# 快速创建步骤
uv python pip 3.x
uv init --vcs none  # 不创建git库初始化
uv venv
```

```bash
mkdir project_name
cd project_name
uv init

# 1. 初始化时指定项目名称（若不指定，默认使用当前文件夹名称）
uv init my_custom_project

# 2. 指定项目使用的Python版本（如3.11，uv会自动查找或安装对应版本）
uv init --python 3.11

# 3. 初始化时直接添加依赖（如requests）
uv init --add requests

# 4. 初始化时添加开发依赖（如pytest）
uv init --dev pytest
```

```bash
# 场景1：项目有 requirements.txt
cd my_existing_project
uv init
uv add --requirements requirements.txt
uv add --dev --requirements requirements-dev.txt
uv sync

# 场景 2：项目有 setup.py/setup.cfg
cd my_existing_project
uv init
# 导入setup.py中的依赖（uv会自动解析）
uv add --from-setup-py
uv sync

# 场景 3：项目没有任何依赖配置（只有代码）
cd my_existing_project
uv init
uv add requests pandas
uv add --dev pytest

# 场景 4：项目已有 pyproject.toml
cd my_existing_project
uv sync
uv add numpy # 后续用uv add/uv remove管理依赖即可
```

</details>

<details>
<summary>依赖管理</summary>

```bash
uv add requests
uv add 'requests==2.31.0'
uv add git+https://github.com/psf/requests
uv add -r requirements.txt -c constraints.txt
uv remove requests
uv lock --upgrade-package requests	# 升级库

uv pip install xxx
uv pip install pandas==2.0.0
uv pip install -r requirements.txt
uv pip install -e .	# 从 pyproject.toml 安装
uv pip install -r requirements.txt --parallel		# 并行安装依赖
uv pip install numpy --cache-dir ~/.uv/cache		# 使用缓存安装
```

uv add xxx 与 uv pip install xxx 的区别

+ uv add xxx 安装包的同时会将其写入项目的依赖配置文件（如 `pyproject.toml`），适合项目开发中添加正式依赖
+ uv pip install xxx 仅安装包到环境中，不修改依赖配置文件 pyproject.toml ，适合临时安装包或兼容原有 pip 工作流（uv pip install xxx属于 uv 对 `pip install` 的**兼容封装命令**，行为几乎和原生 `pip install xxx` 一致）

</details>

<details>
<summary>Docker 中使用 uv</summary>

```Dockerfile
FROM registry.cn-shenzhen.aliyuncs.com/haroldfinch/python:3.11.13-bookworm
COPY --from=m.daocloud.io/ghcr.io/astral-sh/uv:0.8.22 /uv /uvx /bin
# COPY --from=m.daocloud.io/ghcr.io/astral-sh/uv:latest /uv /uvx /bin
```

```yaml
services:
  testuv:
    build: .
    container_name: testuv
    volumes:
      - ./src:/app
    working_dir: /app
    command: ["tail", "-f", "/dev/null"]
```

</details>

<details>
<summary>uv 中使用 jupyter</summary>

```bash
# 为项目创建一个专用jupyter内核
uv add --dev ipykernel

# 使用以下命令为 项目 创建内核
uv run ipython kernel install --user --env VIRTUAL_ENV $(pwd)/.venv --name=PROJECT_NAME

# 启动 jupyter 服务器
# 临时启动 Jupyter Lab，Jupyter 本身跑在 uv 缓存的临时环境中，
# 但是内核是在项目的虚拟环境中，切换内核使用就好
uv run --with jupyter jupyter lab

# 项目中删除 jupyter 内核
uv remove --dev ipykernel

# 清理 uv 所有缓存（包括 Jupyter 等临时依赖的缓存）
uv cache clean
# 或只清理特定包（如 jupyter）的缓存
uv cache clean jupyter

# 删除 Jupyter 中注册的内核配置
# 删除名为 tuv 的内核配置（彻底清理痕迹）
uv run jupyter kernelspec remove tuv
```

</details>

# venv

```bash
python -m venv ENV_NAME

source ./ENV_NAME/bin/activate
.\ENV_NAME\Scripts\Activate.ps1

deactivate
```

# Jupyter

## 配置文件

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

## Jupyter Docker

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

### 添加 sudo 权限

```yaml
# docker-compose.yml
environment:
  - GRANT_SUDO=yes
```

## 方案 1

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

## 方案 2

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

# Conda

<details>
<summary>Conda 常用命令</summary>

```bash
# 创建虚拟环境
conda create -n env_name

# 创建虚拟环境并指定 python 版本
conda create -n env_name python=3.8

# 查看当前系统的环境
conda info -e
conda env list

# 激活环境
conda activate env_name

# 退出环境
conda deactivate

# 切换环境
conda activate env_name

# 删除环境
# 新版本中用
conda env remove --name env_name
# 旧版本中用
conda remove -n env_name --all

# 安装库
conda install xxx==1.1
conda install --file requirements.txt
conda env update -f environment.yml --prune
```

```bash
# 环境配置文件
# 在文件夹里创建environment.yml文件，然后执行命令
# 这里的 yml 文件名可以随便定义
conda env create -f environment.yml
```

```yaml
# environment.yml
name: myenv
channels:
  - conda-forge
  - defaults
dependencies:
  - python=3.8
  - numpy
  - pandas=1.1.5
  - scipy
  - pip:
      - some-package-only-on-pip
```

</details>

<details>
<summary>Conda 配置命令</summary>

```bash
# 配置 Conda 仓库
conda config --add channels conda-forge

# 设置通道优先级：可以设置 Conda-Forge 仓库的优先级高于默认的 Anaconda 仓库。
conda config --set channel_priority strict

# 添加清华大学镜像源
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/

# 添加中科大镜像源
conda config --add channels https://mirrors.ustc.edu.cn/anaconda/pkgs/main/
conda config --add channels https://mirrors.ustc.edu.cn/anaconda/pkgs/free/

# 清理缓存：定期清理 Conda 的缓存可以释放磁盘空间，并可能提高下载速度。
conda clean -a

# 查看已经添加的 conda 通道
conda config --show channels

# 命令移除中科大镜像源
conda config --remove channels https://mirrors.ustc.edu.cn/anaconda/pkgs/main/
conda config --remove channels https://mirrors.ustc.edu.cn/anaconda/pkgs/free/
# 命令移除清华大学镜像源
conda config --remove channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --remove channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
```

</details>

<details>
<summary>miniconda 安装教程</summary>

```bash
# 1.下载安装脚本
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

# 2.添加执行权限
sudo chmod +x Miniconda3-latest-Linux-x86_64.sh

# 3.执行
sudo ./Miniconda3-latest-Linux-x86_64.sh

# 4.更改安装目录
......
Miniconda3 will now be installed into this location:
/root/miniconda3
- Press ENTER to confirm the location
- Press CTRL-C to abort the installation
- Or specify a different location below
[/root/miniconda3] >>> /opt/miniconda3【在这一步骤更改安装目录】

# 5.配置miniconda
conda config --set auto_activate_base false

# 打开~/.bashrc文件，在文件末尾加入如下内容
export PATH="/opt/miniconda3/bin:$PATH"

conda info

# 打开~/.condarc，在文件末尾加入如下内容
channels:
  - defaults
show_channel_urls: true
channel_alias: https://mirrors.tuna.tsinghua.edu.cn/anaconda
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/pro
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
```

</details>
