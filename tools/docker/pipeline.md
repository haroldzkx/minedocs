# Program Language

## Node.js

<details>
<summary>docker-compose.yml</summary>

```yaml
services:
  vuemovie:
    image: registry.cn-shenzhen.aliyuncs.com/haroldfinch/node:22.12.0-bookworm-slim-arm
    container_name: vuemovie
    volumes:
      - ./:/home/work
    working_dir: /home/work
    ports:
      - 3000:3000
      - 5173:5173
      - 5174:5174
    command: ["tail", "-f", "/dev/null"]
```

</details>

<details>
<summary>bash.sh</summary>

```bash
docker compose up -d
docker compose down
docker stop vuemovie
docker start vuemovie
docker exec -it vuemovie /bin/bash

# 安装cnpm
npm get registry
npm install -g cnpm --registry=https://registry.npmmirror.com

# 安装依赖
cd /home/work/VueMovie/frontend && cnpm install
cd /home/work/VueMovie/admin && cnpm install
cd /home/work/VueMovie/mock && cnpm install

# 启动服务并写入运行日志
cd /home/work/VueMovie/mock && npm run start
cd /home/work/VueMovie/frontend && npm run dev
cd /home/work/VueMovie/admin && npm run dev
# or
docker exec -d vuemovie bash -c "cd /home/work/VueMovie/mock && npm run start > /home/work/mock.log 2>&1"
docker exec -d vuemovie bash -c "cd /home/work/VueMovie/frontend && npm run dev > /home/work/frontend.log 2>&1"
docker exec -d vuemovie bash -c "cd /home/work/VueMovie/admin && npm run dev > /home/work/admin.log 2>&1"

# 查看日志
docker exec -it vuemovie cat /home/work/mock.log
docker exec -it vuemovie tail -f /home/work/mock.log
```

</details>

## Python

<details>
<summary>docker-compose.yml</summary>

```yaml
services:
  XXX:
    image: registry.cn-shenzhen.aliyuncs.com/haroldfinch/python:3.10.16-slim-bookworm-arm
    container_name: XXX
    volumes:
      - ./XXX:/home/work
    working_dir: /home/work
    ports:
      - 8080:8080
    command: ["tail", "-f", "/dev/null"]
```

</details>

<details>
<summary>bash.sh</summary>

```bash
docker compose up -d
docker compose down
docker stop XXX
docker start XXX
docker exec -it XXX /bin/bash

cd /home/work/

# set repo
pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/simple

# install dependencies
pip install -r requirements.txt
pip install XXX
```

</details>

## C++

<details>
<summary>docker-compose.yml</summary>

```yaml
services:
  kmchess:
    image: registry.cn-shenzhen.aliyuncs.com/haroldfinch/gcc:13
    container_name: kmchess
    volumes:
      - ./src:/app
    working_dir: /app
    command: ["tail", "-f", "/dev/null"]
```

</details>

<details>
<summary>bash.sh</summary>

```bash
docker compose up -d
docker compose down
docker stop kmchess
docker start kmchess
docker exec -it kmchess /bin/bash

g++ main.cpp -o main
./main

apt update && apt install -y cmake gdb
```

</details>

<details>
<summary>check_denpendencies.sh</summary>

```bash
for tool in gcc g++ make bash cmake gdb clang git; do
    if command -v $tool >/dev/null 2>&1; then
        echo "[ ] $tool found: $($tool --version | head -n 1)"
    else
        echo "[X] $tool NOT found"
    fi
done
```

</details>

<details>
<summary>build.sh</summary>

```bash
#!/bin/bash

set -e  # 出现错误时立即退出

# set build dir
BUILD_DIR=build

if [ ! -d "$BUILD_DIR" ]; then
  mkdir $BUILD_DIR
fi

cd $BUILD_DIR
cmake ..
make

# launch program
echo " - Build successful. Running program:"
echo "-------------------------------------"
./main
```

</details>

## Java

<details>
<summary>Dockerfile</summary>

```Dockerfile
# docker build -t NAME:TAG .
FROM registry.cn-shenzhen.aliyuncs.com/haroldfinch/debian:bookworm-slim

# 将本地的 JDK 安装包复制到 Docker 镜像中的 /tmp 目录
COPY ./jdk-11.0.27_linux-x64_bin.deb /tmp/

RUN rm /etc/apt/sources.list.d/debian.sources \
    && echo "deb https://mirrors.aliyun.com/debian/ bookworm main non-free non-free-firmware contrib" > /etc/apt/sources.list \
    && echo "deb-src https://mirrors.aliyun.com/debian/ bookworm main non-free non-free-firmware contrib" >> /etc/apt/sources.list \
    && echo "deb https://mirrors.aliyun.com/debian-security/ bookworm-security main" >> /etc/apt/sources.list \
    && echo "deb-src https://mirrors.aliyun.com/debian-security/ bookworm-security main" >> /etc/apt/sources.list \
    && echo "deb https://mirrors.aliyun.com/debian/ bookworm-updates main non-free non-free-firmware contrib" >> /etc/apt/sources.list \
    && echo "deb-src https://mirrors.aliyun.com/debian/ bookworm-updates main non-free non-free-firmware contrib" >> /etc/apt/sources.list \
    && echo "deb https://mirrors.aliyun.com/debian/ bookworm-backports main non-free non-free-firmware contrib" >> /etc/apt/sources.list \
    && echo "deb-src https://mirrors.aliyun.com/debian/ bookworm-backports main non-free non-free-firmware contrib" >> /etc/apt/sources.list \
	&& apt update \
	&& rm -rf /var/lib/apt/lists/* \
	&& dpkg -i /tmp/jdk-11.0.27_linux-x64_bin.deb \
	&& rm /tmp/jdk-11.0.27_linux-x64_bin.deb

# 配置 JAVA_HOME 和 PATH 环境变量
ENV JAVA_HOME=/usr/lib/jvm/jdk-11.0.27-oracle-x64
ENV PATH=$JAVA_HOME/bin:$PATH

# 更新 ~/.bashrc
RUN echo "export JAVA_HOME=$JAVA_HOME" >> /root/.bashrc && \
    echo "export PATH=$PATH" >> /root/.bashrc
```

</details>

<details>
<summary>docker-compose.yml</summary>

```yml
services:
  NAME:
    image: IMAGE:TAG
    container_name: NAME
    working_dir: /home/work
    ports:
      - 8000:8000
    command: ["tail", "-f", "/dev/null"]
```

</details>

<details>
<summary>base.sh</summary>

```bash
docker compose up -d
docker compose down
docker exec -it NAME /bin/bash

javac --version
java --version
```

</details>

# Web

## Django

<details>
<summary>【temp】docker-compose.yml</summary>

```yaml
### docker-compose.yml
services:
  djangodev:
    image: registry.cn-shenzhen.aliyuncs.com/haroldfinch/python:3.10.16-slim-bookworm
    container_name: djangodev
    volumes:
      - ./:/home/work
    ports:
      - 8000:8000
    command: ["tail", "-f", "/dev/null"]
    restart: always
    # 这里不完整，还应该有mysql数据库的配置
    # **下面的配置还未验证**
    depends_on:
      - db_mysql
    environment:
      - DATABASE_URL=mysql://dev_user:dev_pass@db_mysql:3306/dev_db
    networks:
      - django-PROJECT_NAME-network

db_mysql:
image: registry.cn-shenzhen.aliyuncs.com/haroldfinch/mysql:8.0.40
container_name: djangodev-mysql
environment:
MYSQL_ROOT_PASSWORD: xxx
MYSQL_DATABASE: xxx
MYSQL_USER: xxx
MYSQL_PASSWORD: xxx
ports: - 3306:3306
volumes: - ./mysql/log:/var/log/mysql - ./mysql/data:/var/lib/mysql - ./mysql/conf.d:/etc/mysql/conf.d
networks: - django-PROJECT_NAME-network

networks:
django-PROJECT_NAME-network:
driver: bridge
```

</details>

<details>
<summary>docker-compose.yml</summary>

```yaml
services:
  djangodev:
    image: registry.cn-shenzhen.aliyuncs.com/haroldfinch/python:3.10.16-slim-bookworm
    container_name: djangodev
    volumes:
      - ./:/home/work
    working_dir: /home/work
    ports:
      - 8000:8000
    command: ["tail", "-f", "/dev/null"]
    restart: always
```

</details>

<details>
<summary>bash.sh</summary>

```bash
### bash.sh
# docker
docker compose up -d
docker exec -it djangodev /bin/bash
docker rm -f djangodev
docker stop djangodev
docker start djangodev

# set repo
pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/simple

# dependencies
pip install --upgrade pip

pip install django, djangorestframework
pip install devpack/*.whl
pip install devpack/*.tar.gz

# django config
django-admin startproject XXX
chmod 777 -R XXX
python XXX/manage.py runserver 0.0.0.0:8000
python XXX/manage.py migrate
# or
cd XXX
python manage.py runserver 0.0.0.0:8000
python manage.py migrate

# run
docker exec -d djangodev bash -c "python XXX/manage.py runserver 0.0.0.0:8000 > /home/work/run.log 2>&1"
# 查看日志
docker exec -it djangodev cat /home/work/mock.log
docker exec -it djangodev tail -f /home/work/mock.log
```

</details>

# DataBase

## MySQL

<details>
<summary>  docker-compose.yml</summary>

```yaml
services:
  mysql:
    image: registry.cn-shenzhen.aliyuncs.com/haroldfinch/mysql:8.0.40
    container_name: mysql-dev
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: mydatabase
      MYSQL_USER: happy
      MYSQL_PASSWORD: happy
    ports:
      - "3306:3306"
    volumes:
      - ./mysql/log:/var/log/mysql
      - ./mysql/data:/var/lib/mysql
      - ./mysql/conf.d:/etc/mysql/conf.d
    # networks:
    #   - mysql-network
    # command: ["bash", "-c", "tail -f /dev/null"]
# networks:
#   mysql-network:
#     driver: bridge
```

</details>

<details>
<summary>  bash.sh</summary>

```bash
# 警告：使用前，当前目录下不要有挂载的mysql目录，不然会连接不上
# 启动后会自动创建mysql目录
docker compose up -d
docker exec -it mysql-dev /bin/bash

docker network ls
docker network inspect NETWORK_NAME
```

</details>

<details>
<summary>  mysql/conf.d/my.cnf</summary>

```bash
###### [client]配置模块 ######
[client]
default-character-set=utf8mb4
socket=/var/lib/mysql/mysql.sock

###### [mysql]配置模块 ######
[mysql]
# 设置MySQL客户端默认字符集
default-character-set=utf8mb4
socket=/var/lib/mysql/mysql.sock

###### [mysqld]配置模块 ######
[mysqld]
port=3306
user=mysql
# 设置sql模式 sql_mode模式引起的分组查询出现*this is incompatible with sql_mode=only_full_group_by，这里最好剔除ONLY_FULL_GROUP_BY
sql_mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
server-id = 1

# MySQL8 的密码认证插件 如果不设置低版本navicat无法连接
default_authentication_plugin=mysql_native_password

# 禁用符号链接以防止各种安全风险
symbolic-links=0

# 允许最大连接数
max_connections=1000

# 服务端使用的字符集默认为8比特编码的latin1字符集
character-set-server=utf8mb4

# 创建新表时将使用的默认存储引擎
default-storage-engine=INNODB

# 0: 表名将按指定方式存储，并且比较区分大小写;
# 1: 表名以小写形式存储在磁盘上，比较不区分大小写；
lower_case_table_names=0

max_allowed_packet=16M

# 设置时区
default-time_zone='+8:00'
```

</details>

## Redis

<details>
<summary>docker-compose.yml</summary>

```yml
services:
  redis:
    image: registry.cn-shenzhen.aliyuncs.com/haroldfinch/redis:6.2.16
    container_name: redismine
    ports:
      - 6379:6379
    volumes:
      - ./redis.conf:/usr/local/etc/redis/redis.conf # 添加 Redis 配置文件
    command: ["redis-server", "/usr/local/etc/redis/redis.conf"] # 使用配置文件启动 Redis
```

</details>

<details>
<summary>redis.conf</summary>

```conf
# redis.conf 配置文件

# 启用受保护模式，确保 Redis 只监听本地接口
protected-mode no

# 绑定到 localhost 或指定 IP
bind 0.0.0.0

# 配置密码，增强安全性
requirepass yourpassword

# 禁用外部 HTTP 请求
# (如果使用了某些代理或非 Redis 协议访问，可能会产生安全风险)
disable-protocols "http"
```

</details>

# Others

## 换阿里云源，安装 SSH

<details>
<summary>Dockerfile</summary>

```dockerfile
FROM registry.cn-shenzhen.aliyuncs.com/haroldfinch/python:3.10.16-slim-bookworm

RUN rm /etc/apt/sources.list.d/debian.sources \
    && echo "deb https://mirrors.aliyun.com/debian/ bookworm main non-free non-free-firmware contrib" > /etc/apt/sources.list \
    && echo "deb-src https://mirrors.aliyun.com/debian/ bookworm main non-free non-free-firmware contrib" >> /etc/apt/sources.list \
    && echo "deb https://mirrors.aliyun.com/debian-security/ bookworm-security main" >> /etc/apt/sources.list \
    && echo "deb-src https://mirrors.aliyun.com/debian-security/ bookworm-security main" >> /etc/apt/sources.list \
    && echo "deb https://mirrors.aliyun.com/debian/ bookworm-updates main non-free non-free-firmware contrib" >> /etc/apt/sources.list \
    && echo "deb-src https://mirrors.aliyun.com/debian/ bookworm-updates main non-free non-free-firmware contrib" >> /etc/apt/sources.list \
    && echo "deb https://mirrors.aliyun.com/debian/ bookworm-backports main non-free non-free-firmware contrib" >> /etc/apt/sources.list \
    && echo "deb-src https://mirrors.aliyun.com/debian/ bookworm-backports main non-free non-free-firmware contrib" >> /etc/apt/sources.list \
    && apt update \
    && apt install -y openssh-server openssh-client \
    && echo "root:0" | chpasswd \
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
```

</details>

<details>
<summary>docker-compose.yml</summary>

```dockerfile
services:
  NAME:
    image: python:3.10.16-pycharm
    container_name: NAME
    working_dir: /home/work
    ports:
      - 8000:8000
      - 8001:22
    command: ["/bin/sh", "-c", "/etc/init.d/ssh start && tail -f /dev/null"]
```

</details>
