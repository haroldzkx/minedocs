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

# 基础命令

<details>
<summary>修改 root 密码</summary>

```bash
alter user "root"@"localhost" identified with mysql_native_password by "PASSWORD";
flush privileges;
```

</details>

<details>
<summary>修改 root 远程登录权限</summary>

```bash
USE mysql;
SELECT User, Host FROM user WHERE User = 'root';
UPDATE user SET Host = '%' WHERE User = 'root' AND Host = 'localhost';
FLUSH PRIVILEGES;
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

# 主从复制

## 简介

MySQL 的主从复制是一种数据备份和灾难恢复的解决方案，它允许将一个 MySQL 服务器（主服务器）上的数据实时复制到一个或多个 MySQL 服务器（从服务器）。通过这种机制，可以实现数据的高可用性，负载均衡和读写分离，大大提高数据库系统的可靠性和性能。

在主从复制架构中，主服务器负责处理所有写操作（如 INSERT, UPDATE, DELETE），并将这些操作记录到二进制日志（Binary log）中。从服务器通过一个 I/O 线程连接到主服务器，持续地读取主服务器的二进制日志，并将这些日志事件复制到自己的中继日志（Relay log）中。随后，从服务器上的一个 SQL 线程会执行中继日志中的事件，从而在从服务器上重放主服务器上的写操作。这样，主服务器上的数据变更就会实时同步到从服务器上。

![](https://gitee.com/haroldzkx/pbed1/raw/main/db/mysqlms.png)

主从复制的优点包括：

1. 数据备份：从服务器可作为主服务器数据的备份，以防主服务器发生故障。
2. 负载均衡：可以将读操作分配到从服务器，减轻主服务器的负担。
3. 读写分离：主服务器处理写操作，从服务器处理读操作，提高系统整体性能。
4. 灾难恢复：在主服务器发生故障时，可以快速切换到从服务器继续提供服务。

## 主从复制搭建

主从复制可以分为一主多从，多主多从。这里配置一个1主2从来讲解配置过程。

```bash
master: 192.168.0.120:3306
slave1: 192.168.0.121:3306
slave2: 192.168.0.122:3306
```

<details>
<summary>master 节点配置</summary>

1. 先给 slave 节点添加一个连接的用户（在 master 上执行）

```bash
create user "slave"@"%" identified with mysql_native_password by "slave";
grant replication slave on *.* to "slave"@"%";
```

2. 修改配置文件 /etc/mysql/mysql.conf.d/mysqld.cnf

```conf
[mysqld]
log-error	= /var/log/mysql/error.log

bind-address		= 0.0.0.0
mysqlx-bind-address	= 127.0.0.1

general_log_file	= /var/log/mysql/query.log
general_log		= 1
server-id		= 1
log_bin			= /var/log/mysql/mysql-bin.log
max_binlog_size		= 100M
```

3. 重启 MySQL 服务 sudo systemctl restart mysql

</details>

---

<details>
<summary>slave 节点配置</summary>

1. 修改配置文件 /etc/mysql/mysql.conf.d/mysqld.cnf

```conf
[mysqld]
log-error	= /var/log/mysql/error.log

bind-address	= 0.0.0.0
mysqlx-bind-address	= 127.0.0.1

general_log_file	= /var/log/mysql/query.log
general_log		= 1
server-id		= 2
```

2. 重启 MySQL 服务

```bash
sudo systemctl restart mysql
```

3. 在 master 节点上查看信息

```bash
$ mysql -u root -p
...
mysql> show master status\G;
*************************** 1. row ***************************
             File: mysql-bin.000003
         Position: 157
     Binlog_Do_DB: 
 Binlog_Ignore_DB: 
Executed_Gtid_Set: 
1 row in set (0.01 sec)
```

4. 在 slave 节点上指定 master 服务器的信息

```bash
mysql -u root -p
mysql> change master to master_host="192.168.0.120" , master_user="slave", master_password="slave", master_log_file="mysql-bin.000003", master_log_pos=157;
```

5. 启动 slave 进程

```bash
mysql> start slave;
```

<details>
<summary>&nbsp;&nbsp; 6. 查看 slave 状态信息</summary>

```bash
# 看到 Slave_IO_Running: Yes 和 Slave_SQL_Running: Yes 
# 说明 slave 已经连接到 master 节点
mysql> show slave status\G;
*************************** 1. row ***************************
               Slave_IO_State: Waiting for source to send event
                  Master_Host: 192.168.5.18
                  Master_User: slave
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000003
          Read_Master_Log_Pos: 157
               Relay_Log_File: slave-relay-bin.000002
                Relay_Log_Pos: 326
        Relay_Master_Log_File: mysql-bin.000003
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
              Replicate_Do_DB: 
          Replicate_Ignore_DB: 
           Replicate_Do_Table: 
       Replicate_Ignore_Table: 
      Replicate_Wild_Do_Table: 
  Replicate_Wild_Ignore_Table: 
                   Last_Errno: 0
                   Last_Error: 
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 157
              Relay_Log_Space: 536
              Until_Condition: None
               Until_Log_File: 
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File: 
           Master_SSL_CA_Path: 
              Master_SSL_Cert: 
            Master_SSL_Cipher: 
               Master_SSL_Key: 
        Seconds_Behind_Master: 0
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error: 
               Last_SQL_Errno: 0
               Last_SQL_Error: 
  Replicate_Ignore_Server_Ids: 
             Master_Server_Id: 1
                  Master_UUID: 14251a77-6c61-11f0-9759-0800274bae1a
             Master_Info_File: mysql.slave_master_info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Replica has read all relay log; waiting for more updates
           Master_Retry_Count: 86400
                  Master_Bind: 
      Last_IO_Error_Timestamp: 
     Last_SQL_Error_Timestamp: 
               Master_SSL_Crl: 
           Master_SSL_Crlpath: 
           Retrieved_Gtid_Set: 
            Executed_Gtid_Set: 
                Auto_Position: 0
         Replicate_Rewrite_DB: 
                 Channel_Name: 
           Master_TLS_Version: 
       Master_public_key_path: 
        Get_master_public_key: 0
            Network_Namespace: 
1 row in set, 1 warning (0.00 sec)

mysql> 
```

</details>

</details>

---

<details>
<summary>测试主从复制结构是否完成</summary>

```bash
# 在 master 节点上
mysql -u root -p
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.00 sec)

mysql> create database csdn charset=utf8mb4;
Query OK, 1 row affected (0.02 sec)

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| csdn               |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.00 sec)
```

```bash
# 在 slave 节点上
mysql -u root -p
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| csdn               |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.00 sec)
```

</details>

## 主从复制模式

MySQL 8.0 支持三种复制模式：

1. 异步复制（Asynchronous Replication）：在这种模式下，主服务器在处理完客户端的写操作后，不会等待从服务器确认接收到了这些写操作，就会继续处理其他事务。因此，如果主服务器发生故障，可能会有数据丢失的风险。

2. 半同步复制（Semi-synchronous Replication）：在半同步复制模式下，主服务器在提交事务后，会等待至少一个从服务器接收并记录了该事务的日志。如果超时没有从服务器确认，主服务器将回退到异步复制模式。这种模式减少了数据丢失的风险，但可能会略微影响主服务器的性能。

3. 全同步复制（Full Synchronous Replication）：MySQL 不直接支持全同步复制，但可以通过半同步复制来近似实现。在全同步复制中，主服务器在提交每个事务之前，必须等待所有从服务器都确认接收到了该事务。这保证了数据的高度一致性，但会显著降低性能。

MySQL 8 默认的复制模式是异步复制。

<details>
<summary>改成半同步复制模式</summary>

```bash
# 1.确认半同步插件是否安装
show plugins;
# 查看输出中是否有 semisync_master 和 semisync_slave 两个插件

# 2.如果插件没有安装，就去安装
# master 节点上执行
install plugin rpl_semi_sync_master SONAME 'semisync_master.so';
# slave 节点上执行
install plugin rpl_semi_sync_slave SONAME 'semisync_slave.so';

# 3.master: 启用半同步复制
SET GLOBAL rpl_semi_sync_master_enabled = ON;

# 4.slave: 启用半同步复制
SET GLOBAL rpl_semi_sync_slave_enabled = ON;

# 5.master: 为了确保在 master 发生故障时能够自动切换到异步复制，可以设置超时时间
# 单位为毫秒
SET GLOBAL rpl_semi_sync_master_timeout = 10000;

# 6.slave: 重启 slave 上的复制线程以应用更改
STOP SLAVE IO_THREAD;
START SLAVE IO_THREAD;

# 7.master: 检查半同步是否正常工作
# 结果显示 ON，表示半同步复制已经启用
SHOW STATUS LIKE "Rpl_semi_sync_master_status";
```

</details>

## FastAPI + SQLAlchemy 实现主从结构

<details>
<summary>在数据库中创建一个用户，用于代码客户端连接</summary>

```bash
# master 和 slave 上都要创建
mysql> create user 'USER'@'%' identified with mysql_native_password by 'PWD';
mysql> grant all privileges on DATABASE.* to 'USER'@'%';
mysql> flush privileges;
```

</details>

<details>
<summary>创建 AsyncEngine 和 AsyncSession 对象</summary>

```python
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from settings import SQLALCHEMY_URIS
import random
from sqlalchemy.orm import Session
from sqlalchemy import Select
import re

SQLALCHEMY_URIS = {
    "master": "mysql+asyncmy://USER:PASSWORD@192.168.0.120:3306/DATABASE?charset=utf8mb4",
    "slave1": "mysql+asyncmy://USER:PASSWORD@192.168.0.121:3306/DATABASE?charset=utf8mb4",
}

engines = {}
slave_keys = []

for key, db_uri in SQLALCHEMY_URIS.items():
    print(db_uri)
    engines[key] = create_async_engine(
        db_uri,
        # 将输出所有执行SQL的日志（默认是关闭的）
        echo=True,
        # 连接池大小（默认是5个）
        pool_size=10,
        # 允许连接池最大的连接数（默认是10个）
        max_overflow=20,
        # 获得连接超时时间（默认是30s）
        pool_timeout=10,
        # 连接回收时间（默认是-1，代表永不回收）
        pool_recycle=3600,
        # 连接前是否预检查（默认为False）
        pool_pre_ping=True,
    )
    if re.match(r"^slave", key):
        slave_keys.append(key)

class RoutingSession(Session):
    def get_bind(self, mapper=None, clause=None, **kw):
        # within get_bind(), return sync engines
        if self._flushing or isinstance(clause, (Insert, Update, Delete)):
            return engines["master"].sync_engine
        else:
            return engines[
                random.choice(slave_keys)
            ].sync_engine
        
# apply to AsyncSession using sync_session_class
AsyncSessionFactory = async_sessionmaker(
    sync_session_class=RoutingSession,
    # 是否在查找之前执行flush操作（默认是True）
    autoflush=True,
    # 是否在执行commit操作后Session就过期（默认是True）
    expire_on_commit=False
)

Base = declarative_base()
```

</details>

<details>
<summary>创建模型</summary>

```python
from . import Base
from sqlalchemy import Column, Integer, String

class User(Base):
    __tablename__ = "user"
    id = Column(Integer, primary_key=True, autoincrement=True)
    username = Column(String(200))
    email = Column(String(200), unique=True, nullable=True)
    password = Column(String(200))
```

</details>

<details>
<summary>创建 get_db_session 的依赖项</summary>

```python
from models import AsyncSessionFactory

async def get_db_session():
    session = AsyncSessionFactory()
    try:
        yield session
    finally:
        await session.close()
```

</details>

<details>
<summary>执行 SQL 语句</summary>

```python
# 添加数据（走 master 节点）
@app.post("/user/add", response_model=UserResp)
async def add_user(
    session: AsyncSession = Depends(get_db_session)
):
    async with session.begin():
        user = User(email="test@163.com", username="Tom", password="123456")
        session.add(user)
    return user

# 查找数据（走 slave 节点）
@app.get("/user/list", response_model=UserListResp)
async def user_list(
    session: AsyncSession = Depends(get_db_session)
):
    async with session.begin():
        query = await session.execute(
            select(User)
        )
        users = query.scalars()
    return {"users": users}
```

</details>
