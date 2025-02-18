# 【MySQL 使用指南】

# 创建权限适当的账户

1. 单独创建一个数据库

2. 单独为要使用的数据库创建一个账户，永远不要让 root 可以远程登录

```bash
# 一、
mysql -u root -p

# 创建数据库，并设置默认编码，
# MySQL的utf8编码是有缺陷的，utf8mb4才是真正的utf8编码
create database 数据库名 charset=utf8mb4;

# 二、单独为要使用的数据库创建一个账户，永远不要让root可以远程登录
# 1.创建一个可以在本地登录的用户账号，
# 如：用户名为me_user，密码为PASSWORD，并且允许远程登录
CREATE USER 'me_user'@'%' IDENTIFIED BY 'PASSWORD';

# 2.把该数据库的所有权限赋予给这个me_user账户
GRANT 这个账户需要的权限 ON 数据库名.* TO 'me_user'@'%';
# 或
GRANT ALL PRIVILEGES ON 数据库名.* TO 'me_user'@'%';

# 3.刷新权限
FLUSH PRIVILEGES;

# 4.本地远程连接
mysql -h IP地址 -u me_user -p
```
