# Composer

Linux 安装 Composer

```bash
# 安装
php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');"
php composer-setup.php

# 移动 composer.phar，这样 composer 就可以进行全局调用
mv composer.phar /usr/local/bin/composer

# 切换为国内镜像
composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

# 更新 composer
composer selfupdate
```

# Docker

## Docker 1

```dockerfile
ARG REPO=registry.cn-shenzhen.aliyuncs.com
ARG REPO_NAME=haroldfinch
ARG VER=8.0.30-apache-bullseye-arm

FROM $REPO/$REPO_NAME/php:$VER

# 安装常用的 PHP 扩展和开发工具
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql zip \
    && a2enmod rewrite \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 安装 Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 设置工作目录
WORKDIR /var/www/html

# 暴露 Apache 默认端口
EXPOSE 80
```

```yaml
services:
  php:
    build: .
    container_name: php-dev-container
    ports:
      - "8080:80" # 将容器的 80 端口映射到主机的 8080 端口
    volumes:
      - ./src:/var/www/html # 将当前目录下的 src 文件夹挂载到容器的 /var/www/html 目录
```

```bash
docker compose up -d
```

```nginx
<!-- my_apache_config.conf -->
<VirtualHost *:80>
    DocumentRoot /var/www/html
    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

```yaml
./my_apache_config.conf:/etc/apache2/sites-available/000-default.conf
```

安装 composer

```bash
# 安装
php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');"
php composer-setup.php

# 移动 composer.phar，这样 composer 就可以进行全局调用
mv composer.phar /usr/local/bin/composer

# 切换为国内镜像
composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

# 更新 composer
composer selfupdate
```

安装 thinkphp8

```bash
# 安装阿里云源
bash -c 'cat << EOF >> /etc/apt/sources.list
deb https://mirrors.aliyun.com/debian/ bookworm main non-free non-free-firmware contrib
deb-src https://mirrors.aliyun.com/debian/ bookworm main non-free non-free-firmware contrib
deb https://mirrors.aliyun.com/debian-security/ bookworm-security main
deb-src https://mirrors.aliyun.com/debian-security/ bookworm-security main
deb https://mirrors.aliyun.com/debian/ bookworm-updates main non-free non-free-firmware contrib
deb-src https://mirrors.aliyun.com/debian/ bookworm-updates main non-free non-free-firmware contrib
deb https://mirrors.aliyun.com/debian/ bookworm-backports main non-free non-free-firmware contrib
deb-src https://mirrors.aliyun.com/debian/ bookworm-backports main non-free non-free-firmware contrib
EOF'

# 安装unzip
apt install unzip

# 安装thinkphp8
composer create-project topthink/think PROJECT_NAME
```

## ThinkPHP Dev Env

镜像：

httpd:2.4.56-arm

同步配置文件

mysql:8.0.40-arm

php:8.2.27-fpm-bookworm-arm

```dockerfile
ARG REPO=registry.cn-shenzhen.aliyuncs.com
ARG NAMESPACE=haroldfinch
ARG VER=8.2.27-fpm-bookworm

FROM ${REPO}/${NAMESPACE}/php:${VER}

# 安装阿里云源
RUN echo "deb https://mirrors.aliyun.com/debian/ bookworm main non-free non-free-firmware contrib" > /etc/apt/sources.list && \
    echo "deb-src https://mirrors.aliyun.com/debian/ bookworm main non-free non-free-firmware contrib" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.aliyun.com/debian-security/ bookworm-security main" >> /etc/apt/sources.list && \
    echo "deb-src https://mirrors.aliyun.com/debian-security/ bookworm-security main" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.aliyun.com/debian/ bookworm-updates main non-free non-free-firmware contrib" >> /etc/apt/sources.list && \
    echo "deb-src https://mirrors.aliyun.com/debian/ bookworm-updates main non-free non-free-firmware contrib" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.aliyun.com/debian/ bookworm-backports main non-free non-free-firmware contrib" >> /etc/apt/sources.list && \
    echo "deb-src https://mirrors.aliyun.com/debian/ bookworm-backports main non-free non-free-firmware contrib" >> /etc/apt/sources.list

# 安装 unzip 和 Composer
RUN rm /etc/apt/sources.list.d/debian.sources \
  && apt update \
  && apt install -y unzip \
  && php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" \
  && php composer-setup.php \
  && mv composer.phar /usr/local/bin/composer \
  && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ \
  && composer selfupdate \
  && rm -f composer-setup.php

# 设置工作目录为 ThinkPHP 项目目录
WORKDIR /var/www/html

# 暴露 ThinkPHP 默认的端口 8000
EXPOSE 8000
```

```bash
docker build -t testphp:0.1 .
docker run -d --name testphp-1 testphp:0.1 tail -f /dev/null
# docker exec -it testphp-1 /bin/bash
docker exec testphp-1 bash -c "composer create-project topthink/think PROJECT_NAME"
docker exec testphp-1 bash -c "cd PROJECT_NAME && php think run"
```

```yaml
services:
  myapp:
    image: testphp:0.1
    container_name: testphp-1
    ports:
      - "8889:8000" # 将宿主机的 8080 端口映射到容器的 80 端口
    volumes:
      - ./src:/var/www/html # 将本地目录 ./local-directory 挂载到容器内的 /app/data 目录
    command: ["bash", "-c", "cd www.haha.com && php think run"]
#    command: ["bash", "-c", "composer create-project topthink/think www.haha.com && cd www.haha.com && php think run"
#    restart: always  # 设置容器的重启策略
```

我的本地有 3 个镜像，分别是 httpd:2.4.56，mysql:8.0.40，php:8.2.27-fpm-bookwork，我需要在 php 镜像中安装 composer 和 thinkphp8，然后使用 docker-compose 将这三个镜像连接起来同时使用，给出 Dockerfile 和 docker-compose.yml 文件
