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

# 锁机制

在电商秒杀等高并发场景中，多个用户同时秒杀同一件商品，如果不加锁，那么可能会出现数据异常或者超卖的现象，为此针对这些数据，需要加入锁机制。

常见的锁机制有悲观锁和乐观锁，他们的原理分别如下：

1. 悲观锁：悲观锁是数据库层面实现的。之所以成为悲观锁，是由于其假定数据操作过程种会产生冲突，那么在一次的数据操作过程中，会将数据处于锁定的状态，直至操作结束。在 MySQL 数据库中，使用 InnoDB 引擎的锁机制是行级数据锁定，而 MyISAM 引擎是表级锁定，一般情况而言，行级锁机制的效率比表级的锁机制效率更高。

2. 乐观锁：乐观锁是代码层面实现的。之所以成为乐观锁，是由于其假定数据操作过程中不会产生冲突，在操作数据时，不会将数据处于锁定状态，而是通过先判断该数据是否有冲突，如果没有冲突则正常执行，如果有冲突则停止访问，或者等待一段时间再访问。

## 悲观锁

### with_for_update

在SQLAlchemy中，可以使用with_for_update方法来实现悲观锁。

```python
async with session.begin():
    result = await session.execute(select(Seckill.stock).where(Seckill.id == seckill_id).with_for_update())
    seckill = result.scalar()
    seckill.stock -= 1
```

以上代码会输出类似以下的SQL语句：

```sql
SELECT seckill.max_sk_count
FROM seckill
WHERE seckill.id = %s FOR UPDATE;
```

with_for_update方法的参数及其意义如下：

- nowait: 默认是False。如果设置为True，则当请求的行被其他事务锁定时，查询将不会等待，而是立即抛出一个异常。

- read: 默认值是False。如果设置为True，则查询将使用读锁而不是写锁。这通常用于避免锁定不必要的行，只锁定那些实际需要更新的行。

- of: 指定要加锁的表或列。可以使用此参数来更精确地控制锁的范围。

- skip_locked: 默认是False。如果设置为True，则查询将跳过被其他事务锁定的行，只返回未被锁定的行。

- key_share: 默认是False，如果设置为True，则查询将使用键共享锁（key share lock），这是一种特殊的读锁，允许多个事务读取相同的行，但只允许一个事务更新这些行。

在数据库中，锁是用来控制并发访问共享资源（如数据库表）的一种机制，读锁和写锁是两种基本的锁类型，它们定义了如何对数据进行访问和修改。

### 读锁

读锁（也称为共享锁）是一种用于防止其他事务对数据进行写操作的锁。当一个事务对数据加上了读锁后，其他事务仍然可以读取这些数据，但不能修改或删除这些数据，直到读锁被释放。

读锁通常用于以下情况：

- 允许多个事务同时读取数据，但阻止任何事务修改数据。

- 防止其他事务修改数据，从而避免读取到未提交的数据（脏读）

### 写锁

写锁（也称为排他锁或独占锁）是一种用于防止其他事务对数据进行读或写操作的锁。当一个事务对数据加上了写锁后，其他事务不能读取或修改这些数据，直到写锁被释放。

写锁通常用于以下情况：

- 允许一个事务修改或删除数据，但阻止其他事务读取或修改数据。

- 防止其他事务读取或修改数据，从而避免读取到未提交的数据（脏读）.

在 SQLAlchemy中，你可以使用with_for_update()方法来对查询结果集加锁。如果你设置read=True，则使用读锁；如果你不设置或设置为 False，则使用写锁。

例如，如果你想使用读锁来防止其他事务修改数据，你可以这样使用 with_for_update()：

```python
stmt = select(MyModel).where(MyModel.id == some_id).with_for_update(read=True)
```

而如果你想使用写锁来防止其他事务读取或修改数据，你可以这样使用 with_for_update():

```python
stmt = select(MyModel).where(MyModel.id == some_id).with_for_update() # 默认使用写锁
```

## 乐观锁

在代码层面实现的，一般是在需要加锁的表上加一个 version 字段，用来记录当前的版本号，在操作数据之前，先判断当前版本是否正确，如果正确，则可以正常操作，否则应该要继续等待。在 SQLAlchemy 中，可以通过以下方式实现乐观锁：

```python
class Seckill(Base, SnowFlakeIdModel, SerializerMixin):
    __tablename__ = 'seckill'
    serialize_only = ('id', 'sk_price', 'start_time', 'end_time', 'create_time', 'max_sk_count', 'sk_per_max_count', 'commodity')
    sk_price = Column(DECIMAL(10, 2), comment='秒杀价')
    start_time = Column(DateTime, comment='秒杀开始时间')
    end_time = Column(DateTime, comment='秒杀结束时间')
    create_time = Column(DateTime, default=datetime.now)
    max_sk_count = Column(Integer, comment='秒杀数量')
    stock = Column(Integer, comment='库存量')
    sk_per_max_count = Column(Integer, comment='每人最多秒杀数量')
    version_id = Column(String(100), nullable=False)

    commodity_id = Column(BigInteger, ForeignKey('commodity.id'))
    commodity = relationship(Commodity, backref=backref('seckills'), lazy='joined')

    __mapper_args__ = {
        "version_id_col": version_id,
        "version_id_generator": lambda version: uuid.uuid4().hex
    }
```

要使用乐观锁去修改数据，则应该先查找出对应的数据，然后再进行更新操作。代码如下：

```python
async with session.begin():
    result = await session.execute(select(Seckill).where(Seckill.id == seckill_id))
    seckill = result.scalar()
    seckill.stock -= 1
```

以上代码执行完后，输出以下类似的SQL语句。代码如下：

```sql
UPDATE seckill
SET stock=%s, version_id=%s
WHERE seckill.id = %s AND seckill.version_id = %s
 (8, 'b4d2f4982e714048a4d5889f2177f1f9', 1941710239204114432, '')
```
