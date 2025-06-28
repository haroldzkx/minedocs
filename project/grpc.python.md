# 用户微服务

## 项目结构

```bash
alembic/	# 使用alembic命令生成的
alembic/env.py  # 命令生成的，但需要修改配置

models/__init__.py
models/user.py

protos/__init__.py
protos/user_pb2_grpc.py # 命令生成的
protos/user_pb2.py      # 命令生成的
protos/user.proto   # 要自己编写的

services/__init__.py
services/interceptors.py
services/user.py    # gRPC服务端代码实现

settings/__init__.py

utils/__init__.py
utils/snowflake/__init__.py
utils/snowflake/exceptions.py
utils/snowflake/snowflake.py
utils/pwdutil.py

alembic.ini	# 命令生成的，但需要修改配置
bash.sh
client.py   # gRPC客户端代码，也可以放在别的项目中
docker-compose.yml
main.py
```

## 代码实现

<details>
<summary>alembic/env.py</summary>

```python
target_metadata = None
# 修改为
from models import Base
target_metadata = Base.metadata
```

</details>

<details>
<summary>alembic.ini</summary>

```ini
修改 sqlalchemy.url
```

</details>


<details>
<summary>models/__init__.py</summary>

```python
from sqlalchemy.ext.asyncio import create_async_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.ext.declarative import declarative_base
from settings import DB_URI


engine = create_async_engine(
    DB_URI,
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

AsyncSessionFactory = sessionmaker(
    # Engine或者其子类对象（这里是AsyncEngine）
    bind=engine,
    # Session类的代替（默认是Session类）
    class_=AsyncSession,
    # 是否在查找之前执行flush操作（默认是True）
    autoflush=True,
    # 是否在执行commit操作后Session就过期（默认是True）
    expire_on_commit=False
)

Base = declarative_base()

from . import user
```

</details>

<details>
<summary>models/user.py</summary>

```python
from . import Base
from sqlalchemy import Column, BigInteger, String, Boolean, DateTime
import random
import string
from utils.snowflake.snowflake import Snowflake
from settings import DATACENTER_ID, WORKER_ID
from sqlalchemy_serializer import SerializerMixin

snowflake = Snowflake(DATACENTER_ID, WORKER_ID)

def generate_username():
    code = "".join(random.sample(string.digits, 6))
    return "用户" + code

def generate_snowflake_id():
    new_id = snowflake.get_id()
    return new_id

class User(Base, SerializerMixin):
    __tablename__ = 'user'
    serialize_only = ('id', 'mobile', 'username', 'avatar', 'is_active', 'is_staff')
    id = Column(BigInteger, primary_key=True, default=generate_snowflake_id)
    mobile = Column(String(20), unique=True, index=True)
    username = Column(String(20), default=generate_username)
    password = Column(String(300), nullable=True)
    avatar = Column(String(200), nullable=True)
    is_active = Column(Boolean, default=True)
    is_staff = Column(Boolean, default=False)
    last_login = Column(DateTime, nullable=True)
```

</details>

<details>
<summary>protos/user_pb2_grpc.py</summary>

```python
# 将
import user_pb2 as user__pb2
# 修改为
from . import user_pb2 as user__pb2
```

</details>

<details>
<summary>protos/user.proto</summary>

```proto
syntax = "proto3";
import "google/protobuf/empty.proto";

service User {
  rpc CreateUser(CreateUserRequest) returns (UserInfoResponse);
  rpc GetUserById(IdRequest) returns (UserInfoResponse);
  rpc GetUserByMobile(MobileRequest) returns (UserInfoResponse);
  rpc UpdateAvatar(AvatarRequest) returns (google.protobuf.Empty);
  rpc UpdateUsername(UsernameRequest) returns (google.protobuf.Empty);
  rpc UpdatePassword(PasswordRequest) returns (google.protobuf.Empty);
  rpc GetUserList(PageRequest) returns (UserListResponse);
  rpc VerifyUser(VerifyUserRequest) returns (UserInfoResponse);
  rpc GetOrCreateUserByMobile(MobileRequest) returns (UserInfoResponse);
}

message CreateUserRequest {
  string mobile = 1;
}

message IdRequest {
  uint64 id = 1;
}

message MobileRequest {
  string mobile = 1;
}

message AvatarRequest {
  uint64 id = 1;
  string avatar = 2;
}

message UsernameRequest {
  uint64 id = 1;
  string username = 2;
}

message PasswordRequest {
  uint64 id = 1;
  string password = 2;
}

message PageRequest {
  uint32 page = 1;
  uint32 size = 2;
}

message VerifyUserRequest {
  string mobile = 1;
  string password = 2;
}

message UserInfo {
  uint64 id = 1;
  string mobile = 2;
  string username = 3;
  string avatar = 4;
  bool is_active = 5;
  bool is_staff = 6;
  string last_login = 7;
}

message UserInfoResponse {
  UserInfo user = 1;
}

message UserListResponse {
  repeated UserInfo users = 1;
}
```

</details>

<details>
<summary>services/interceptors.py</summary>

```python
from grpc_interceptor.server import AsyncServerInterceptor
import grpc
from typing import Any, Callable
from models import AsyncSessionFactory
from grpc_interceptor.exceptions import GrpcException

class UserInterceptor(AsyncServerInterceptor):
    async def intercept(
            self,
            method: Callable,
            request_or_iterator: Any,
            context: grpc.ServicerContext,
            method_name: str,
    ) -> Any:
        session = AsyncSessionFactory()
        try:
            response = await method(request_or_iterator, context, session)
            return response
        except GrpcException as e:
            await context.set_code(e.status_code)
            await context.set_details(e.details)
        finally:
            await session.close()
```

</details>

<details>
<summary>services/user.py</summary>

```python
import sqlalchemy.exc

from protos import user_pb2, user_pb2_grpc
from models.user import User
import grpc
from sqlalchemy import select, update
from google.protobuf import empty_pb2
from utils import pwdutil

class UserServicer(user_pb2_grpc.UserServicer):

    async def CreateUser(self, request: user_pb2.CreateUserRequest, context, session):
        mobile = request.mobile
        try:
            async with session.begin():
                user = User(mobile=mobile)
                session.add(user)
                # sqlalchemy_serializer
            response = user_pb2.UserInfoResponse(user=user.to_dict())
            return response
        except sqlalchemy.exc.IntegrityError:
            context.set_code(grpc.StatusCode.ALREADY_EXISTS)
            context.set_details('该手机号已经存在！')
    
    async def GetUserById(self, request: user_pb2.IdRequest, context, session):
        try:
            async with session.begin():
                user_id = request.id
                query = await session.execute(select(User).where(User.id==user_id))
                user = query.scalar()
                if not user:
                    context.set_code(grpc.StatusCode.NOT_FOUND)
                    context.set_details('该用户不存在！')
                else:
                    response = user_pb2.UserInfoResponse(user=user.to_dict())
                    return response
        except Exception as e:
            context.set_code(grpc.StatusCode.INTERNAL)
            context.set_details('服务器错误！')

    async def GetUserByMobile(self, request: user_pb2.MobileRequest, context, session):
        try:
            async with session.begin():
                mobile = request.mobile
                query = await session.execute(select(User).where(User.mobile==mobile))
                user = query.scalar()
                if not user:
                    context.set_code(grpc.StatusCode.NOT_FOUND)
                    context.set_details('该用户不存在！')
                else:
                    response = user_pb2.UserInfoResponse(user=user.to_dict())
                    return response
        except Exception as e:
            context.set_code(grpc.StatusCode.INTERNAL)
            context.set_details('服务器错误！')

    async def UpdateAvatar(self, request: user_pb2.AvatarRequest, context, session):
        async with session.begin():
            user_id = request.id
            avatar = request.avatar
            stmt = update(User).where(User.id == user_id).values(avatar=avatar)
            result = await session.execute(stmt)
            # async sqlalchemy
            rowcount = result.rowcount
            if rowcount == 0:
                context.set_code(grpc.StatusCode.NOT_FOUND)
                context.set_details(f'ID{user_id}不存在！')
            else:
                return empty_pb2.Empty()

    async def UpdateUsername(self, request: user_pb2.AvatarRequest, context, session):
        async with session.begin():
            user_id = request.id
            username = request.username
            stmt = update(User).where(User.id == user_id).values(username=username)
            result = await session.execute(stmt)
            # async sqlalchemy
            rowcount = result.rowcount
            if rowcount == 0:
                context.set_code(grpc.StatusCode.NOT_FOUND)
                context.set_details(f'ID{user_id}不存在！')
            else:
                return empty_pb2.Empty()

    async def UpdatePassword(self, request: user_pb2.PasswordRequest, context, session):
        async with session.begin():
            user_id = request.id
            password = request.password
            hashed_password = pwdutil.hash_password(password)
            stmt = update(User).where(User.id == user_id).values(password=hashed_password)
            result = await session.execute(stmt)
            # async sqlalchemy
            rowcount = result.rowcount
            if rowcount == 0:
                context.set_code(grpc.StatusCode.NOT_FOUND)
                context.set_details(f'ID{user_id}不存在！')
            else:
                return empty_pb2.Empty()

    async def VerifyUser(self, request: user_pb2.VerifyUserRequest, context, session):
        async with session.begin():
            mobile = request.mobile
            password = request.password
            result = await session.execute(select(User).where(User.mobile==mobile))
            user = result.scalar()
            if not user:
                context.set_code(grpc.StatusCode.NOT_FOUND)
                context.set_details('该用户不存在！')
            if not pwdutil.check_password(password, user.password):
                context.set_code(grpc.StatusCode.INVALID_ARGUMENT)
                context.set_details('密码错误！')
            reponse = user_pb2.UserInfoResponse(user=user.to_dict())
            return reponse

    async def GetUserList(self, request: user_pb2.PageRequest, context, session):
        async with session.begin():
            page = request.page
            size = request.size
            # limit/offset
            offset = (page-1)*size
            query = await session.execute(select(User).limit(size).offset(offset))
            # [(User1, ), (User2, ), ...]
            # [User1, User2, User3, ...]
            result = query.scalars().fetchall()
            # 转换为字典
            users = []
            for user in result:
                users.append(user.to_dict())
            response = user_pb2.UserListResponse(users=users)
            return response

    async def GetOrCreateUserByMobile(self, request: user_pb2.MobileRequest, context, session):
        async with session.begin():
            mobile = request.mobile
            query = await session.execute(select(User).where(User.mobile == mobile))
            user = query.scalar()
            if not user:
                user = User(mobile=mobile)
                session.add(user)
        response = user_pb2.UserInfoResponse(user=user.to_dict())
        return response
```

</details>

<details>
<summary>settings/__init__.py</summary>

```python
MYSQL_HOST = '127.0.0.1'
MYSQL_PORT = '3306'
MYSQL_USER = ''
MYSQL_PASSWORD = ""
MYSQL_DB = 'user_db'

DB_URI = f"mysql+asyncmy://{MYSQL_USER}:{MYSQL_PASSWORD}@{MYSQL_HOST}:{MYSQL_PORT}/{MYSQL_DB}?charset=utf8mb4"

# 这个地方是写死的，后续如果部署到服务器上，可以使用读取环境变量的形式
DATACENTER_ID = 0
WORKER_ID = 0
```

</details>

<details>
<summary>utils/snowflake/exceptions.py</summary>

```python
class InvalidSystemClock(Exception):
    """
    时钟回拨异常
    """
    pass
```

</details>

<details>
<summary>utils/snowflake/snowflake.py</summary>

```python
# Twitter's Snowflake algorithm implementation which is used to generate distributed IDs.
# https://github.com/twitter-archive/snowflake/blob/snowflake-2010/src/main/scala/com/twitter/service/snowflake/IdWorker.scala

import time

from .exceptions import InvalidSystemClock


# 64位ID的划分
WORKER_ID_BITS = 5
DATACENTER_ID_BITS = 5
SEQUENCE_BITS = 12

# 最大取值计算
MAX_WORKER_ID = -1 ^ (-1 << WORKER_ID_BITS)  # 2**5-1 0b11111
MAX_DATACENTER_ID = -1 ^ (-1 << DATACENTER_ID_BITS)

# 移位偏移计算
WOKER_ID_SHIFT = SEQUENCE_BITS
DATACENTER_ID_SHIFT = SEQUENCE_BITS + WORKER_ID_BITS
TIMESTAMP_LEFT_SHIFT = SEQUENCE_BITS + WORKER_ID_BITS + DATACENTER_ID_BITS

# 序号循环掩码
SEQUENCE_MASK = -1 ^ (-1 << SEQUENCE_BITS)

# Twitter元年时间戳
TWEPOCH = 1288834974657


class Snowflake(object):
    """
    用于生成IDs
    """

    def __init__(self, datacenter_id, worker_id, sequence=0):
        """
        初始化
        :param datacenter_id: 数据中心（机器区域）ID
        :param worker_id: 机器ID
        :param sequence: 序号
        """
        # sanity check
        if worker_id > MAX_WORKER_ID or worker_id < 0:
            raise ValueError('worker_id值越界')

        if datacenter_id > MAX_DATACENTER_ID or datacenter_id < 0:
            raise ValueError('datacenter_id值越界')

        self.worker_id = worker_id
        self.datacenter_id = datacenter_id
        self.sequence = sequence

        self.last_timestamp = -1  # 上次计算的时间戳

    def _gen_timestamp(self):
        """
        生成整数时间戳
        :return:int timestamp
        """
        return int(time.time() * 1000)

    def get_id(self):
        """
        获取新ID
        :return:
        """
        timestamp = self._gen_timestamp()

        # 时钟回拨
        if timestamp < self.last_timestamp:
            raise InvalidSystemClock

        if timestamp == self.last_timestamp:
            self.sequence = (self.sequence + 1) & SEQUENCE_MASK
            if self.sequence == 0:
                timestamp = self._til_next_millis(self.last_timestamp)
        else:
            self.sequence = 0

        self.last_timestamp = timestamp

        new_id = ((timestamp - TWEPOCH) << TIMESTAMP_LEFT_SHIFT) | (self.datacenter_id << DATACENTER_ID_SHIFT) | \
                 (self.worker_id << WOKER_ID_SHIFT) | self.sequence
        return new_id

    def _til_next_millis(self, last_timestamp):
        """
        等到下一毫秒
        """
        timestamp = self._gen_timestamp()
        while timestamp <= last_timestamp:
            timestamp = self._gen_timestamp()
        return timestamp
```

</details>

<details>
<summary>utils/pwdutil.py</summary>

```python
from passlib.hash import pbkdf2_sha256

def hash_password(password):
    return pbkdf2_sha256.hash(password)

def check_password(raw_password, hashed_password):
    return pbkdf2_sha256.verify(raw_password, hashed_password)
```

</details>

<details>
<summary>bash.sh</summary>

```python
docker compose up -d
docker compose down
docker stop userservice
docker start userservice
docker exec -it userservice /bin/bash

# set python mirror repo
pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/simple

# install dependencies
pip install -r requirements.txt
pip install asyncmy, cryptography, sqlalchemy[asyncio], alembic, grpcio, grpcio-tools, sqlalchemy-serializer, grpc-interceptor, passlib
# 
pip install asyncmy
pip install cryptography
pip install sqlalchemy[asyncio]
pip install alembic
pip install grpcio, grpcio-tools
pip install sqlalchemy-serializer
pip install grpc-interceptor
pip install passlib

# Alembic commands
alembic init alembic --template async
alembic revision --autogenerate -m "add user model"
alembic upgrade head

# gRPC commands
cd protos
python -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. user.proto

# run gRPC server
python main.py
# run gRPC client
python client.py
```

</details>

<details>
<summary>client.py</summary>

```python
import grpc
from protos import user_pb2_grpc, user_pb2


def test_create_user(stub):
    try:
        request = user_pb2.CreateUserRequest()
        request.mobile = "18899990001"
        response = stub.CreateUser(request)
        # 如果直接打印response，那么只会输出那些有值的字段，没有值的字段不会输出
        # 并不代表这个字段不存在
        print(response)
    except grpc.RpcError as e:
        print(e.code())
        print(e.details())

def test_get_user_by_id(stub):
    try:
        request = user_pb2.IdRequest()
        # request.id = 1938902769242996736
        request.id = 1938905905219239936
        response = stub.GetUserById(request)
        print(response)
    except grpc.RpcError as e:
        print(e.code())
        print(e.details())

def test_get_user_by_mobile(stub):
    try:
        request = user_pb2.MobileRequest()
        request.mobile = '18899990000'
        response = stub.GetUserByMobile(request)
        print(response)
    except grpc.RpcError as e:
        print(e.code())
        print(e.details())

def test_update_avatar(stub):
    try:
        request = user_pb2.AvatarRequest()
        request.id = 1938902769242996736
        request.avatar = 'https://www.zlkt.net/xxxx.jpg'
        response = stub.UpdateAvatar(request)
        print(response)
    except grpc.RpcError as e:
        print(e.code())
        print(e.details())

def test_update_username(stub):
    try:
        request = user_pb2.UsernameRequest()
        request.id = 1938902769242996736
        request.username = '张三s'
        response = stub.UpdateUsername(request)
        print(response)
    except grpc.RpcError as e:
        print(e.code())
        print(e.details())

def test_update_password(stub):
    try:
        request = user_pb2.PasswordRequest()
        request.id = 1938902769242996736
        request.password = '111111'
        response = stub.UpdatePassword(request)
        print(response)
    except grpc.RpcError as e:
        print(e.code())
        print(e.details())

def test_verify_user(stub):
    try:
        request = user_pb2.VerifyUserRequest()
        request.mobile = '18899990000'
        request.password = '111111'
        response = stub.VerifyUser(request)
        print(response)
    except grpc.RpcError as e:
        print(e.code())
        print(e.details())

def test_get_user_list(stub):
    try:
        request = user_pb2.PageRequest()
        request.page = 1
        request.size = 10
        response = stub.GetUserList(request)
        print(response)
    except grpc.RpcError as e:
        print(e.code())
        print(e.details())

def test_get_or_create_user(stub):
    request = user_pb2.MobileRequest()
    request.mobile = '18899990002'
    response = stub.GetOrCreateUserByMobile(request)
    print(response)

def main():
    with grpc.insecure_channel("127.0.0.1:5001") as channel:
        stub = user_pb2_grpc.UserStub(channel)
        # test_create_user(stub)
        # test_get_user_by_id(stub)
        # test_get_user_by_mobile(stub)
        # test_update_avatar(stub)
        # test_update_username(stub)
        # test_update_password(stub)
        # test_verify_user(stub)
        # test_get_user_list(stub)
        test_get_or_create_user(stub)

if __name__ == '__main__':
    main()
```

</details>

<details>
<summary>docker-compose.yml</summary>

```yml
services:
  userservice:
    image: registry.cn-shenzhen.aliyuncs.com/haroldfinch/python:3.10.16-slim-bookworm
    container_name: userservice
    volumes:
      - ./:/home/app
    working_dir: /home/app
    command: ["tail", "-f", "/dev/null"]
```

</details>

<details>
<summary>main.py</summary>

```python
import grpc
from services.user import UserServicer
from protos import user_pb2_grpc
import asyncio
from services.interceptors import UserInterceptor


async def main():
    server = grpc.aio.server(interceptors=[UserInterceptor()])
    user_pb2_grpc.add_UserServicer_to_server(UserServicer(), server)
    server.add_insecure_port(f"0.0.0.0:5001")
    await server.start()
    print('gRPC服务已经启动...')
    await server.wait_for_termination()


if __name__ == '__main__':
    asyncio.run(main())
```

</details>

---

<details>
<summary>模型迁移 alembic 命令</summary>

```bash
pip install alembic

# 1.创建初始迁移仓库
# 会在当前目录下生成alembic目录和alembic.ini文件
alembic init alembic --template async

# 2.配置
# 2.1 修改alembic.ini文件中的sqlalchemy.url
sqlalchemy.url = driver://user:pass@localhost/dbname
# 2.2 修改alembic/env.py
target_metadata = None
修改为
from models import Base
target_metadata = Base.metadata

# 3.迁移模型到数据库中去
alembic revision --autogenerate -m "add user model"
alembic upgrade head
```

</details>

# 用户API服务
