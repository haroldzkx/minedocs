# 开发环境（Docker）

准备如下的目录和文件

```bash
devpack/  # 离线安装的库 *.whl
bash.sh   # 常用命令
docker-compose.yml
```

# docker-compose.yml

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
    ports:
      - 3306:3306
    volumes:
      - ./mysql/log:/var/log/mysql
      - ./mysql/data:/var/lib/mysql
      - ./mysql/conf.d:/etc/mysql/conf.d
    networks:
      - django-PROJECT_NAME-network

networks:
  django-PROJECT_NAME-network:
    driver: bridge
```

# bash.sh

```shell
### bash.sh
# docker
docker compose up -d
docker exec -it djangodev /bin/bash
docker rm -f djangodev
docker stop djangodev
docker start djangodev

# dependencies
pip install -i https://mirrors.ustc.edu.cn/pypi/simple --upgrade pip
pip install -i https://mirrors.ustc.edu.cn/pypi/simple django, djangorestframework
pip install devpack/*.whl
pip install devpack/*.tar.gz
pip uninstall asgiref django sqlparse typing_extensions -y

# django config
django-admin startproject XXX
chmod 777 -R XXX
python XXX/manage.py runserver 0.0.0.0:8000
python XXX/manage.py migrate
# or
cd XXX
python manage.py runserver 0.0.0.0:8000
python manage.py migrate
```

# 启动步骤

```bash
# 1. 启动python容器
docker compose up -d

# 2. 进入容器的终端 或者 VSCode中attach进容器

# 3. 安装库（以下3种方式任选其一）
pip install django xxx ...
pip install -r requirements.txt
pip install devpack/*.whl

# 4. 创建django项目
django-admin startproject

# 5. 启动django项目
python manage.py runserver 0.0.0.0:8000
```
