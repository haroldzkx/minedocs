# 【MySQL】

# 安装

<details>
<summary>Debian 12</summary>

```bash
# 1.前置准备工作
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y wget gnupg

# 2.
wget https://repo.mysql.com/mysql-apt-config_0.8.33-1_all.deb

sudo dpkg -i mysql-apt-config_0.8.33-1_all.deb

# 选择 MySQL Server & Cluster，按回车键
# 选择 mysql-8.0，按回车键
# 选择 Ok，按回车键

# 3.安装mysql-server
sudo apt update -y
sudo apt install -y mysql-server
# 这里会有设置root密码的界面，记好密码

# 4.配置
sudo systemctl status mysql
sudo systemctl start mysql
sudo systemctl enable mysql

# 5.测试登录
mysql -u root -p
```

</details>

<details>
<summary>CentOS</summary>

这个安装步骤可能过时了，谨慎选择

```bash
# 1.下载rpm包
wget https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm

# 2.对repo进行安装
rpm -ivh mysql57-community-release-el7-9.noarch.rpm

# 3.进入 /etc/yum.repos.d 目录
# 查看是否有mysql-community.repo和mysql-community-source.repo文件
# 若有这两个文件，执行安装命令：
yum install mysql-server

# 4.启动MySQL服务器
systemctl start mysqld

# 5.查看是否启动
ps aux | grep mysql

# 6.查看生成的临时密码
grep 'temporary password' /var/log/mysqld.log

# 7.进入MySQL
mysql -u root -p

# 8.设置新的密码
# MySQL 5.7.6版本之后用如下命令：
ALTER USER USER() IDENTIFIED BY '你的新密码';
# MySQL 5.7.6版本以前的用如下命令：
SET PASSWORD = PASSWORD('你的新密码');

# 9.关闭服务
systemctl stop mysqld

# 10.启动服务
systemctl start mysqld
```

</details>

<details>
<summary>Docker</summary>

<details>
<summary>  docker-compose.yml</summary>

```yaml
services:
  mysql:
    image: registry.cn-shenzhen.aliyuncs.com/haroldfinch/mysql:8.0.40
    container_name: mysql-dev
    environment:
      MYSQL_ROOT_PASSWORD: 123456
      MYSQL_DATABASE: mydatabase
      MYSQL_USER: happy
      MYSQL_PASSWORD: happyyppah
    ports:
      - "3306:3306"
    volumes:
      - ./mysql/log:/var/log/mysql
      - ./mysql/data:/var/lib/mysql
      - ./mysql/conf.d:/etc/mysql/conf.d
    networks:
      - mysql-network
    # command: ["bash", "-c", "tail -f /dev/null"]
networks:
  mysql-network:
    driver: bridge
```

</details>

<details>
<summary>  bash.sh</summary>

```bash
# 警告：使用前，当前目录下不要有挂载的mysql目录，不然会连接不上
# 启动后会自动创建mysql目录
docker compose up -d
docker network ls
docker network inspect NETWORK_NAME
docker exec -it mysql-dev /bin/bash
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

</details>

---

# 配置

<details>
<summary>创建权限适当的账户</summary>

1. 单独创建一个数据库
2. 单独为要使用的数据库创建一个账户，永远不要让 root 可以远程登录，一个数据库对应一个账户

```bash
# 1.先在本地使用root用户登录 MySQL
mysql -u root -p

# 2.创建数据库，并设置默认编码
# MySQL的utf8编码是有缺陷的，utf8mb4才是真正的utf8编码
create database 数据库名 charset=utf8mb4;

# 3.单独为要使用的数据库创建一个账户
# 用户名(me_user)，密码(PASSWORD)，允许远程登录
CREATE USER 'me_user'@'%' IDENTIFIED BY 'PASSWORD';

# 4.把该数据库的所有权限赋予给这个me_user账户
GRANT 这个账户需要的权限 ON 数据库名.* TO 'me_user'@'%';
# 或
GRANT ALL PRIVILEGES ON 数据库名.* TO 'me_user'@'%';

# 5.刷新权限
FLUSH PRIVILEGES;

# 6.本地远程连接
mysql -h IP地址 -u me_user -p
```

</details>
