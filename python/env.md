> 优先选择使用 Docker 构建 Python 环境，一个项目一个 Docker 容器，不能使用 Docker 再考虑 miniconda

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

方式 1:

1. 启动 docker 容器：`docker compose up -d`

2. VSCode 左下角 -> Attach to Running Container...

方式 2:（也不一定要在 IDE 中 Attach 进容器）

- Docker 容器挂载目录，直接在本地修改文件，修改的内容会同步进去

- 结合命令行 debug 工具使用

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

> 三选一，随便安装一个即可使用，不需要单独安装 python 环境

1. miniconda（推荐这个）: 在电脑里可以只安装 miniconda 而不单独安装 python，一般使用可以直接使用 base 环境即可
2. mamba（当有性能需求时，推荐这个）
3. micromamba：这个可以独立使用，当需要极致性能和极致大小时使用

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

## mamba

Micro/Mamba 安装与注意事项: https://github.com/shenweiyan/Knowledge-Garden/discussions/24

安装步骤：

1. 先去 Miniforge distribution 下载 Mambaforge-Linux-x86_64.sh
2. 执行 sh Mambaforge-Linux-x86_64.sh

Windows 直接下载 exe 文件运行安装，然后添加系统变量 即可

## micromamba

安装步骤

```bash
# Automatic Install
"${SHELL}" <(curl -L micro.mamba.pm/install.sh)

# Once installed, micromamba can be updated with
micromamba self-update
```

micromamba 配置

专有的 conda-forge 设置可以配置为：

```bash
micromamba config append channels conda-forge
micromamba config append channels nodefaults
micromamba config set channel_priority strict
```

## conda install 与 pip install 的区别

结论：推荐使用 conda 创建虚拟环境，能用 conda 安装的就先用 conda，不行再使用 pip 安装。
注意事项：这两个尽量不要混用，要么统一用 conda install，要么统一用 pip install

[支持语言]：

- pip 是 python 官方推荐的包下载工具，但是只能安装 python 包
- conda 是一个跨平台（支持 linux, mac, win）的通用包和环境管理器，它除了支持 python 外，还能安装各种其他语言的包，例如 C/C++, R 语言等

[Repo 源]：

- pip 从 PyPI（Python Package Index）上拉取数据。上面的数据更新更及时，涵盖的内容也更加全面
- conda 从 Anaconda.org 上拉取数据。虽然 Anaconda 上有一些主流 Python 包，但在数量级上明显少于 PyPI，缺少一些小众的包

[包的内容]：

- pip 里的软件包为 wheel 版或源代码发行版。wheel 属于已编译发新版的一种，下载好后可以直接使用；而源代码发行版必须要经过编译生成可执行程序后才能使用，编译的过程是在用户的机子上进行的
- conda 里的软件包都是二进制文件，下载后即可使用，不需要经过编译

[环境隔离]：

- pip 没有内置支持环境隔离，只能借助其他工具例如 virtualenv or venv 实现环境隔离
- conda 有能力直接创建隔离的环境

[依赖关系]：

- pip 安装包时，尽管也对当前包的依赖做检查，但是并不保证当前环境的所有包的所有依赖关系都同时满足。当某个环境所安装的包越来越多，产生冲突的可能性就越来越大。
- conda 会检查当前环境下所有包之间的依赖关系，保证当前环境里的所有包的所有依赖都会被满足

[库的储存位置]：

- 在 conda 虚拟环境下使用 pip install 安装的库： 如果使用系统的的 python，则库会被保存在 ~/.local/lib/python3.x/site-packages 文件夹中；如果使用的是 conda 内置的 python，则会被保存到 anaconda3/envs/current_env/lib/site-packages 中
- conda install 安装的库都会放在 anaconda3/pkgs 目录下。这样的好处就是，当在某个环境下已经下载好了某个库，再在另一个环境中还需要这个库时，就可以直接从 pkgs 目录下将该库复制至新环境而不用重复下载
