# Node.js

## docker-compose.yml

```yaml
services:
  vuemovie:
    image: registry.cn-shenzhen.aliyuncs.com/haroldfinch/node:22.12.0-bookworm-slim-arm
    container_name: vuemovie
    volumes:
      - ./:/home/work
    ports:
      - 3000:3000
      - 5173:5173
      - 5174:5174
    command: ["tail", "-f", "/dev/null"]
```

## bash.sh

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

# Python

## docker-compose.yml

```yaml
services:
  XXX:
    image: registry.cn-shenzhen.aliyuncs.com/haroldfinch/python:3.10.16-slim-bookworm-arm
    container_name: XXX
    volumes:
      - ./XXX:/home/work
    ports:
      - 8080:8080
    command: ["tail", "-f", "/dev/null"]
```

## bash.sh

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

# Django

## docker-compose.yml

```yaml
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
```

## bash.sh

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

# C++

## docker-compose.yml

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

## bash.sh

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

## check_denpendencies.sh

```bash
for tool in gcc g++ make bash cmake gdb clang git; do
    if command -v $tool >/dev/null 2>&1; then
        echo "[ ] $tool found: $($tool --version | head -n 1)"
    else
        echo "[X] $tool NOT found"
    fi
done
```

## build.sh

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
