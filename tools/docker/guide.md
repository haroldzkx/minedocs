# 【Docker 常用命令】

# 国内镜像源

1. DaoCloud

https://docs.daocloud.io/community/mirror.html

```bash
# 使用方法
# 1.增加前缀（推荐）:
k8s.gcr.io/coredns/coredns => m.daocloud.io/k8s.gcr.io/coredns/coredns

# 2.修改镜像仓库的前缀
k8s.acr.io/coredns/coredns => k8s-gcr.m.daocloud.io/coredns/coredns

docker pull m.daocloud.io/docker.io/library/node:17.5.0-stretch-slim
```

2. Aliyun（自建的）

```bash
registry.cn-shenzhen.aliyuncs.com/haroldfinch
```

```bash
docker pull registry.cn-shenzhen.aliyuncs.com/haroldfinch/[image]:[镜像版本号]
```

# 容器

## 后台启动容器并进入容器

```bash
docker pull $ali/node-react:1.0

# 通过镜像启动容器并后台运行
# -d: 指定容器后台运行
# --name node-react-1: 指定容器名称为node-react-1
# $ali/node-react:1.0: 镜像名和镜像Tag
# tail -f /dev/null: 这个命令让容器保持运行状态
docker run -d \
  --name node-react-1 \
  $ali/node-react:1.0 \
  tail -f /dev/null

# 进入运行中的容器
docker exec -it node-react-1 /bin/bash
```

```yaml
services:
  node-react:
    image: $ali/node-react:1.0
    container_name: node-react-1
    command: tail -f /dev/null
    restart: always
```

## 不进入容器执行命令

```bash
docker exec CONTAINER_NAME bash -c "COMMAND"
```

## 停止容器并删除容器

```bash
docker stop CONTAINER_NAME && docker rm CONTAINER_NAME
# 等价于
docker rm -f CONTAINER_NAME

# 停止容器（不删除容器，网络，卷）
docker compose stop
# 启动容器
docker compose start

# 停止容器（删除容器，网络）
docker compose down
# 停止容器（删除容器，网络，卷）
docker compose down -v
```

## 从运行中的容器拷贝文件到宿主机

```bash
# 从容器中拷贝文件到宿主机
docker cp [容器名]:[容器中的文件/目录路径] [宿主机目录]
docker cp [容器名]:/app/my-app ./
```

# docker-compose.yml

```yaml
services:
  cpp-dev:
    image: gcc:13
    container_name: cpp-dev
    volumes:
      - ./src:/app
    working_dir: /app
    command: ["tail", "-f", "/dev/null"]
```

working_dir：让你一进入容器或运行命令时就处于代码目录下（而不是 / 或其他系统路径）。

- 指定容器内的“工作目录”。

- 进入容器时，默认所在的目录。

- command 和 entrypoint 的执行目录。

# 镜像

## Dockerfile

一个典型的 Dockerfile 包含以下部分：

- **基础镜像**：指定镜像的起点。
- **元数据**：设置镜像的作者、描述等信息。
- **依赖安装**：安装应用程序所需的依赖。
- **文件复制**：将应用程序代码复制到镜像中。
- **环境变量**：设置运行时的环境变量。
- **启动命令**：定义容器启动时执行的命令。

### 换系统源

```dockerfile
# Debian 12 换为 阿里云源
RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak && \
    echo "deb https://mirrors.aliyun.com/debian/ bookworm main non-free non-free-firmware contrib" > /etc/apt/sources.list && \
    echo "deb-src https://mirrors.aliyun.com/debian/ bookworm main non-free non-free-firmware contrib" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.aliyun.com/debian-security/ bookworm-security main" >> /etc/apt/sources.list && \
    echo "deb-src https://mirrors.aliyun.com/debian-security/ bookworm-security main" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.aliyun.com/debian/ bookworm-updates main non-free non-free-firmware contrib" >> /etc/apt/sources.list && \
    echo "deb-src https://mirrors.aliyun.com/debian/ bookworm-updates main non-free non-free-firmware contrib" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.aliyun.com/debian/ bookworm-backports main non-free non-free-firmware contrib" >> /etc/apt/sources.list && \
    echo "deb-src https://mirrors.aliyun.com/debian/ bookworm-backports main non-free non-free-firmware contrib" >> /etc/apt/sources.list && \
    apt update
```

```dockerfile
# Ubuntu 22.04 换为 阿里云源
RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak && \
    echo "deb https://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb-src https://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb-src https://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb-src https://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.aliyun.com/ubuntu/ jammy-proposed main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ jammy-proposed main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb-src https://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    apt update
```

## 构建镜像

```yaml
# 如果文件名不为Dockerfile，用如下命令
docker build -f Dockerfile文件路径 -t 镜像名:[tag] .

# 如果文件名为Dockerfile，用如下命令
docker build -t 用户名/镜像名:[tag] .
```

# 配置

## 设置输出格式

在 `.bashrc`中设置别名

```bash
alias dpsa='docker ps -a --format "\nContainer ID: {{.ID}}\nImage: {{.Image}}\nCommand: {{.Command}}\nCreated: {{.Created}}\nStatus: {{.Status}}\nPorts: {{.Ports}}\nContainer Name: {{.Names}}\n"'
alias dps='docker ps --format "\nContainer ID: {{.ID}}\nImage: {{.Image}}\nCommand: {{.Command}}\nCreated: {{.Created}}\nStatus: {{.Status}}\nPorts: {{.Ports}}\nContainer Name: {{.Names}}\n"'
alias di=''
```

```bash
docker ps -a --format "\nContainer ID: {{.ID}}\nImage: {{.Image}}\nCommand: {{.Command}}\nCreated: {{.Created}}\nStatus: {{.Status}}\nPorts: {{.Ports}}\nContainer Name: {{.Names}}\n"
```

# 数据持久化

1. **数据卷（Volumes）**：最推荐的持久化和共享数据方式，适用于生产环境，提供更高的可移植性、持久性和管理性，数据卷的生命周期由 Docker 控制，适合共享和持久化数据。

```yaml
services:
  app:
    image: my_app_image
    volumes:
      - my_volume:/data # 将数据卷my_volume挂载到容器的/data目录

volumes:
  my_volume: # 定义数据卷my_volume
```

2. **绑定挂载（Bind Mounts）**：适用于开发环境，便于与主机文件系统的实时交互和调试，但容器和主机紧密耦合，不适合跨主机部署或生产环境。

```yaml
services:
  app:
    image: my_app_image
    volumes:
      - ./src:/data # 将宿主机的src挂载到容器的/data目录
```

3. **临时数据（Container Storage）**：适用于不需要持久化的数据。【不用了解】
4. **数据容器（Data Containers）**：【旧方法，现在多用数据卷】
5. **外部存储**：适用于大规模、高可用的存储需求。

## 数据卷

数据卷是 Docker 推荐的用于持久化和共享数据的方式。

它是 Docker 管理的目录或文件，可以在多个容器之间共享数据，也可以在容器删除时保持数据。

数据卷有以下特点：

- **持久化**：即使容器被删除，数据卷中的数据不会丢失。
- **共享**：多个容器可以挂载同一个数据卷，实现数据共享。
- **备份和恢复**：可以通过 `docker volume` 命令方便地备份和恢复数据。
- **跨主机共享**：通过 Docker 的集群管理工具（如 Docker Swarm 或 Kubernetes），可以实现跨主机的数据共享。

创建和使用数据卷示例：

```bash
# 创建数据卷
docker volume create my_volume

# 启动容器并挂载数据卷
docker run -d \
  -v my_volume:/data \
  --name [container name] [image name]
```

```bash
FROM centos

VOLUMES ["volume1", "volume2"]

CMD /bin/bash
```

```yaml
services:
  app:
    image: my_app_image
    volumes:
      - my_volume:/data # 将数据卷my_volume挂载到容器的/data目录

volumes:
  my_volume: # 定义数据卷my_volume
```

docker run -v 与 Dockerfile 的 VOLUME 指令方式指定数据卷的区别：

- docker run -v 方式是针对已经存在的镜像的，而 Dockerfile 的 VOLUME 指令方式是针对准备创建的镜像的。
- docker run -v 方式可以指定宿主机中的数据卷目录，而 Dockerfile 的 VOLUME 指令方式无法指定宿主机中的数据卷目录，由 Docker Daemon 自动分配的。所以对于用户来说，通过 docker run -v 方式来指定数据卷会更为清晰明了些。

**数据卷权限与默认路径**

- 所有的 docker 容器内的卷，没有指定目录的情况下都是在 /var/lib/docker/volumes/xxxx/\_data 下，如果指定了目录，docker volume ls 是查看不到的。
- 改变读写权限：-v 容器内路径:ro/rw

## 绑定挂载

```bash
# 启动容器并绑定挂载主机上的目录
docker run -d
-v /path/on/host:/path/in/container
--name [container name] [image name]
```

# 安装与卸载

## ubuntu

```bash
# 1.检查卸载老版本 docker
sudo apt remove docker docker-engine docker.io containerd runc

# 2.更新软件包
sudo apt update
sudo apt upgrade

# 3.安装 docker 依赖
sudo apt install apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release

# 4.添加 docker 密钥
# 使用curl下载GPG密钥
curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg -o docker-ce.gpg
# 将下载的GPG密钥转换为适合trusted.gpg.d目录的格式
sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-ce-archive-keyring.gpg docker-ce.gpg
# 删除之前下载的未处理的GPG密钥文件（可选）
rm docker-ce.gpg

# 5.添加阿里云 docker 软件源
sudo add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"

# 6.安装docker
apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 7.配置用户组然后重启系统
sudo usermod -aG docker $USER
sudo reboot

# 8.检验 docker 是否安装成功
systemctl start docker
service docker restart
docker run hello-world
```

```bash
# 1.删除docker及安装时自动安装的所有包
apt-get autoremove docker docker-ce docker-engine  docker.io  containerd runc

# 2.查看docker是否卸载干净
dpkg -l | grep docker
# 删除无用的相关的配置文件
dpkg -l | grep ^rc|awk '{print $2}' | sudo xargs dpkg -P

# 3.删除没有删除的相关插件
apt-get autoremove docker-ce-*

# 4.删除docker的相关配置&目录
rm -rf /etc/systemd/system/docker.service.d
rm -rf /var/lib/docker
rm -rf /var/lib/containerd
rm -rf /etc/docker

# 5.确定docker卸载完毕
docker --version
```

## Debian

```bash
# 更新系统包和安装必要工具
sudo apt update
sudo apt upgrade -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

# 添加 Docker 官方 GPG 密钥（从阿里云下载）
sudo curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 添加阿里云的 Docker 软件源
# echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://mirrors.aliyun.com/docker-ce/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://mirrors.aliyun.com/docker-ce/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

# 更新 apt 软件包索引
sudo apt update

# 安装 Docker
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 启动并设置 Docker 开机自启
sudo systemctl start docker
sudo systemctl enable docker

# 验证 Docker 是否安装成功
docker --version

# 添加当前用户到 Docker 组（可选）
sudo usermod -aG docker $USER
# 然后退出当前会话并重新登录

 # 验证 Docker 服务
sudo systemctl status docker
```

```bash
# 卸载 Docker 包和相关依赖
sudo apt purge docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 删除 Docker 配置文件和数据目录
## 删除 Docker 配置和数据目录
sudo rm -rf /var/lib/docker
sudo rm -rf /etc/docker
## 删除 Docker 配置文件
sudo rm -rf /etc/systemd/system/docker.service.d
sudo rm -rf /etc/apt/sources.list.d/docker.list
## 删除 Docker 配置的 GPG 密钥
sudo rm -f /usr/share/keyrings/docker-archive-keyring.gpg

# 清理无用的依赖
sudo apt autoremove --purge
sudo apt clean

# 更新 apt 软件源
sudo apt-get update

# 确认 Docker 是否完全卸载
docker --version
```

# 实用工具

将 docker 命令转变为 docker compose 的 yaml 文件

Composerize: [https://www.composerize.com](https://www.composerize.com)
