Python 多版本共存教程：https://zhuanlan.zhihu.com/p/509506199

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

# 国内镜像源

```bash
# 中科大源（临时使用）
pip install -i https://mirrors.ustc.edu.cn/pypi/simple package

# 中科大源（设为默认，长期使用）
pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/simple
```

# venv

```bash
python -m venv ENV_NAME

source ./ENV_NAME/bin/activate
.\ENV_NAME\Scripts\Activate.ps1

deactivate
```

# Conda

## Conda Guide

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

## Conda 配置

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

## miniconda

安装教程：

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
