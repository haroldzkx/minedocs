# gRPC (user, address)

## 项目结构

```bash
alembic/	# 使用alembic命令生成的
alembic/env.py  # 命令生成的，但需要修改配置

models/__init__.py
models/address.py
models/user.py

protos/__init__.py
protos/address_pb2_grpc.py
protos/address_pb2.py
protos/address.proto
protos/user_pb2_grpc.py # 命令生成的
protos/user_pb2.py      # 命令生成的
protos/user.proto   # 要自己编写的

services/__init__.py
services/address.py
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
from . import address
```

</details>

<details>
<summary>models/address.py</summary>

```python
from . import Base
from sqlalchemy import Column, String, BigInteger, ForeignKey
from sqlalchemy.orm import relationship
from .user import User
import uuid
from sqlalchemy_serializer import SerializerMixin

def generate_id():
    return uuid.uuid4().hex

class Address(Base, SerializerMixin):
    __tablename__ = 'address'
    serialize_only = ('id', 'realname', 'mobile', 'region', 'detail')
    id = Column(String(200), primary_key=True, default=generate_id)
    realname = Column(String(100))
    mobile = Column(String(20))
    region = Column(String(200))
    detail = Column(String(200))

    user_id = Column(BigInteger, ForeignKey('user.id'))
    user = relationship(User, backref="addresses")
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
<summary>protos/address_pb2_grpc.py</summary>

```python
import address_pb2 as address__pb2
# 修改为
from . import address_pb2 as address__pb2
```

</details>

<details>
<summary>protos/address.proto</summary>

```python
syntax = "proto3";
import "google/protobuf/empty.proto";

service Address {
  rpc CreateAddress(CreateAddressRequest) returns (AddressResponse);
  rpc UpdateAddress(UpdateAddressRequest) returns (google.protobuf.Empty);
  rpc DeleteAddress(DeleteAddressRequest) returns (google.protobuf.Empty);
  rpc GetAddressById(AddressIdRequest) returns (AddressResponse);
  rpc GetAddressList(AddressListRequest) returns (AddressListResponse);
}

message CreateAddressRequest {
  uint64 user_id = 1;
  string realname = 2;
  string mobile = 3;
  string region = 4;
  string detail = 5;
}

message UpdateAddressRequest {
  string id = 1;
  string realname = 2;
  string mobile = 3;
  string region = 4;
  string detail = 5;
  uint64 user_id = 6;
}

message DeleteAddressRequest {
  string id = 1;
  uint64 user_id = 2;
}

message AddressIdRequest {
  string id = 1;
  uint64 user_id = 2;
}

message AddressListRequest {
  uint64 user_id = 1;
  uint32 page = 2;
  uint32 size = 3;
}

message AddressInfo {
  string id = 1;
  string realname = 2;
  string mobile = 3;
  string region = 4;
  string detail = 5;
}

message AddressResponse {
  AddressInfo address = 1;
}

message AddressListResponse {
  repeated AddressInfo addresses = 1;
}
```

</details>

<details>
<summary>protos/user_pb2_grpc.py</summary>

```python
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
<summary>services/address.py</summary>

```python
from protos import address_pb2, address_pb2_grpc
from sqlalchemy import select, update, delete
from models.address import Address
import grpc
from google.protobuf import empty_pb2


class AddressServicer(address_pb2_grpc.AddressServicer):
    async def CreateAddress(self, request: address_pb2.CreateAddressRequest, context, session):
        async with session.begin():
            user_id = request.user_id
            realname = request.realname
            mobile = request.mobile
            region = request.region
            detail = request.detail
            try:
                address = Address(
                    realname=realname,
                    mobile=mobile,
                    region=region,
                    detail=detail,
                    user_id=user_id
                )
                session.add(address)
            except Exception as e:
                context.set_code(grpc.StatusCode.NOT_FOUND)
                context.set_details('用户不存在！')
        response = address_pb2.AddressResponse(address=address.to_dict())
        return response

    async def UpdateAddress(self, request: address_pb2.UpdateAddressRequest, context, session):
        async with session.begin():
            id = request.id
            realname = request.realname
            mobile = request.mobile
            region = request.region
            detail = request.detail
            user_id = request.user_id
            result = await session.execute(update(Address).where(
                Address.id==id, Address.user_id==user_id
            ).values(
                realname=realname,
                mobile=mobile,
                region=region,
                detail=detail
            ))
            rowcount = result.rowcount
            if rowcount == 0:
                context.set_code(grpc.StatusCode.NOT_FOUND)
                context.set_details('地址不存在！')
        return empty_pb2.Empty()

    async def DeleteAddress(self, request: address_pb2.DeleteAddressRequest, context, session):
        async with session.begin():
            id = request.id
            user_id = request.user_id
            result = await session.execute(delete(Address).where(Address.id==id, Address.user_id==user_id))
            if result.rowcount == 0:
                context.set_code(grpc.StatusCode.NOT_FOUND)
                context.set_details('地址不存在！')
        return empty_pb2.Empty()

    async def GetAddressById(self, request: address_pb2.AddressIdRequest, context, session):
        async with session.begin():
            id = request.id
            result = await session.execute(select(Address).where(Address.id == id))
            address = result.scalar()
        return address_pb2.AddressResponse(address=address.to_dict())

    async def GetAddressList(self, request: address_pb2.AddressListRequest, context, session):
        async with session.begin():
            user_id = request.user_id
            page = request.page
            size = request.size
            offset = (page-1)*size
            result = await session.execute(select(Address).where(Address.user_id==user_id).limit(size).offset(offset))
            rows = result.scalars()
        addresses = []
        for row in rows:
            addresses.append(row.to_dict())
        return address_pb2.AddressListResponse(addresses=addresses)
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
MYSQL_USER = 'xxx'
MYSQL_PASSWORD = "xxx"
MYSQL_DB = 'xxx'

# aiomysql
# pip install aiomysql
# asyncmy：在保存64位的整形时，有bug：Unexpected <class 'OverflowError'>: Python int too large to convert to C unsigned long
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

source ~/pyenvs/userservice/bin/activate
# set python mirror repo
pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/simple

# install dependencies
pip install -r requirements.txt
pip install asyncmy, cryptography, sqlalchemy[asyncio], alembic, grpcio, grpcio-tools, sqlalchemy-serializer, grpc-interceptor, passlib
# 
pip install asyncmy
pip install aiomysql
pip install cryptography
pip install sqlalchemy[asyncio]
pip install alembic
pip install grpcio, grpcio-tools
pip install sqlalchemy-serializer
pip install grpc-interceptor
pip install passlib
pip install py-consul

# Alembic commands
alembic init alembic --template async
alembic revision --autogenerate -m "add user model"
alembic upgrade head

# gRPC commands
cd protos
python -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. user.proto
python -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. address.proto

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
from protos import address_pb2_grpc, address_pb2


def test_create_user(stub):
    try:
        request = user_pb2.CreateUserRequest()
        request.mobile = "18899990003"
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

def test_create_address(stub):
    request = address_pb2.CreateAddressRequest(
        user_id=1939134518510223360,
        realname='猪八戒',
        mobile='18899991111',
        region='北京市朝阳区1111',
        detail='白家庄东里1111',
    )
    response = stub.CreateAddress(request)
    print(response.address)

def test_update_address(stub):
    request = address_pb2.UpdateAddressRequest(
        id="d9bc9f2a9bb4463b9fc5753c4aac84ca",
        realname="猪八戒",
        mobile='19900001111',
        region='北京市朝阳区',
        detail='白家庄东里',
        user_id=1939683615000494080
    )
    stub.UpdateAddress(request)

def test_delete_address(stub):
    request = address_pb2.DeleteAddressRequest(
        user_id=1939683615000494080,
        id="d9bc9f2a9bb4463b9fc5753c4aac84ca"
    )
    stub.DeleteAddress(request)

def test_get_address_by_id(stub):
    request = address_pb2.AddressIdRequest(
        id="35503c491fd04ac1b74539c8b6f4c615",
        user_id=1939134518510223360
    )
    address = stub.GetAddressById(request)
    print(address)

def test_get_address_list(stub):
    request = address_pb2.AddressListRequest(
        user_id=1939683615000494080,
        page=1,
        size=10
    )
    addresses = stub.GetAddressList(request)
    print(addresses)

def main():
    with grpc.insecure_channel("127.0.0.1:5001") as channel:
        # stub = user_pb2_grpc.UserStub(channel)
        # test_create_user(stub)
        # test_get_user_by_id(stub)
        # test_get_user_by_mobile(stub)
        # test_update_avatar(stub)
        # test_update_username(stub)
        # test_update_password(stub)
        # test_verify_user(stub)
        # test_get_user_list(stub)
        # test_get_or_create_user(stub)

        address_stub = address_pb2_grpc.AddressStub(channel)
        # test_create_address(address_stub)
        # test_update_address(address_stub)
        # test_delete_address(address_stub)
        # test_get_address_by_id(address_stub)
        test_get_address_list(address_stub)

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
from services.address import AddressServicer
from protos import user_pb2_grpc, address_pb2_grpc
import asyncio
from services.interceptors import UserInterceptor
import consul
import uuid
from typing import Tuple
import socket
from loguru import logger

client = consul.Consul(host='localhost', port=8500)

def get_ip_port() -> Tuple[str, int]:
    sock_ip = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock_ip.connect(('8.8.8.8', 80))
    ip = sock_ip.getsockname()[0]
    sock_ip.close()

    sock_port = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock_port.bind(("", 0))
    _, port = sock_port.getsockname()
    sock_port.close()
    return ip, port

def register_consul(ip: str, port: int):
    service_id = uuid.uuid4().hex
    client.agent.service.register(
        name='user_service',
        service_id=service_id,
        address=ip,
        port=port,
        tags=['user', 'grpc'],
        check=consul.Check.tcp(host=ip, port=port, interval='10s')
    )
    return service_id

def deregister_consul(service_id: str):
    client.agent.service.deregister(service_id)

async def main():
    ip, port = get_ip_port()
    server = grpc.aio.server(interceptors=[UserInterceptor()])
    user_pb2_grpc.add_UserServicer_to_server(UserServicer(), server)
    address_pb2_grpc.add_AddressServicer_to_server(AddressServicer(), server)
    server.add_insecure_port(f"0.0.0.0:{port}")
    service_id = register_consul(ip, port)
    await server.start()
    # print('gRPC服务已经启动...')
    logger.info(f"gRPC服务已经启动：0.0.0.0:{port}")
    try:
        await server.wait_for_termination()
    finally:
        deregister_consul(service_id)


if __name__ == '__main__':
    asyncio.run(main())
```

</details>

---

<details>
<summary>模型迁移 alembic 命令</summary>

```bash
pip install alembic

# 1.创建初始迁移仓库（只需要创建1次就行）
# 会在当前目录下生成alembic目录和alembic.ini文件
alembic init alembic --template async

# 2.配置
# 2.1 修改alembic.ini文件中的sqlalchemy.url
sqlalchemy.url = driver://user:pass@localhost/dbname
# 2.2 修改alembic/env.py
target_metadata = None
# 修改为
from models import Base
target_metadata = Base.metadata

# 3.迁移模型到数据库中去
alembic revision --autogenerate -m "add user model"
alembic upgrade head
```

</details>

# RESTFul API (user, address)

只提供接口服务，不提供增删改查功能，增删改查功能全部都在gRPC接口里

## 项目结构

```bash
hooks/__init__.py
hooks/lifespan.py
hooks/middlewares.py

logs/

routers/__init__.py
routers/address.py
routers/user.py

schemas/__init__.py
schemas/request.py
schemas/response.py

services/__init__.py
services/address.py
services/decorators.py
services/user.py
services/protos/__init__.py
services/protos/address_pb2_grpc.py
services/protos/address_pb2.py
services/protos/address.proto
services/protos/user_pb2_grpc.py
services/protos/user_pb2.py
services/protos/user.proto

settings/__init__.py

utils/__init__.py
utils/alyoss.py
utils/alysms.py
utils/auth.py
utils/cache.py
utils/single.py
utils/status_code.py
utils/u_consul.py

bash.sh
curls.sh
main.py
```

## 代码实现

<details>
<summary>hooks/lifespan.py</summary>

```python
from contextlib import asynccontextmanager
from fastapi import FastAPI
from loguru import logger
from utils.cache import TLLRedis
from utils.u_consul import MineConsul

mine_consul = MineConsul()


@asynccontextmanager
async def lifespan(app: FastAPI):
    logger.add("logs/file.log", rotation="500 MB", enqueue=True)
    mine_consul.register()
    await mine_consul.fetch_user_service_addresses()
    yield
    # 程序即将结束之前，先把redis的连接关闭
    await TLLRedis().close()
    mine_consul.deregister()
```

</details>

<details>
<summary>hooks/middlewares.py</summary>

```python
from fastapi.requests import Request
from loguru import logger
from fastapi.responses import JSONResponse


async def log_middleware(request: Request, call_next):
    try:
        # 执行视图函数之前的代码
        response = await call_next(request)
        # 执行视图函数之后的
        await logger.complete()
        return response
    except Exception as e:
        logger.exception('发生异常了！')
        return JSONResponse(content={"detail": "服务器内部错误！"}, status_code=500)
```

</details>

<details>
<summary>routers/address.py</summary>

```python
from fastapi import APIRouter, HTTPException
from schemas.response import AddressModel, ResultModel, AddressListModel
from schemas.request import CreateAddressModel, DeleteAddressModel, UpdateAddressModel
from utils.auth import AuthHandler
from services.address import AddressServiceClient
from fastapi import status
from fastapi import Depends

router = APIRouter(prefix='/address')

auth_handler = AuthHandler()
address_service_client = AddressServiceClient()


@router.post('/create', response_model=AddressModel)
async def create_address(data: CreateAddressModel, user_id: int=Depends(auth_handler.auth_access_dependency)):
    address = await address_service_client.create_address(
        user_id,
        realname=data.realname,
        mobile=data.mobile,
        region=data.region,
        detail=data.detail
    )
    return address


@router.delete('/delete', response_model=ResultModel)
async def delete_address(data: DeleteAddressModel, user_id: int=Depends(auth_handler.auth_access_dependency)):
    await address_service_client.delete_address(user_id, data.id)
    return ResultModel()


@router.put('/update', response_model=ResultModel)
async def update_address(data: UpdateAddressModel, user_id: int=Depends(auth_handler.auth_access_dependency)):
    await address_service_client.update_address(
        id=data.id,
        realname=data.realname,
        mobile=data.mobile,
        region=data.region,
        detail=data.detail,
        user_id=user_id,
    )
    return ResultModel()

@router.get('/detail/{id}', response_model=AddressModel)
async def detail_address(id: str, user_id: int=Depends(auth_handler.auth_access_dependency)):
    address = await address_service_client.get_address_by_id(user_id, id)
    return address

# /address/list?page=1&size=20
@router.get('/list', response_model=AddressListModel)
async def list_address(page: int=1, size: int=10, user_id: int=Depends(auth_handler.auth_access_dependency)):
    addresses = await address_service_client.get_address_list(user_id, page=page, size=size)
    return {"addresses": addresses}
```

</details>

<details>
<summary>routers/user.py</summary>

```python
from fastapi import APIRouter, HTTPException
import string
import random
from utils.alysms import AliyunSMSSender
from schemas.response import ResultModel, LoginedModel, UserModel, UpdatedAvatarModel
from utils.cache import TLLRedis
from schemas.request import LoginModel, UpdateUsernameModel, UpdatePasswordModel
from utils.auth import AuthHandler
from fastapi import Depends, UploadFile
from services.user import UserServiceClient
from utils.alyoss import oss_upload_image
from fastapi import status

router = APIRouter(prefix='/user')

sms_sender = AliyunSMSSender()
tll_redis = TLLRedis()
auth_handler = AuthHandler()
user_service_client = UserServiceClient()

@router.get('/smscode/{mobile}', response_model=ResultModel)
async def get_smscode(mobile: str):
    code = "".join(random.sample(string.digits, 4))
    # await sms_sender.send_code(mobile, code)
    # await tll_redis.set(mobile, code)
    await tll_redis.set_sms_code(mobile, code)
    print(f"code: {code}")
    return ResultModel()

@router.post('/login', response_model=LoginedModel)
async def login(data: LoginModel):
    mobile = data.mobile
    code = data.code
    cached_code = await tll_redis.get_sms_code(mobile)
    if code != cached_code:
        raise HTTPException(status_code=400, detail='验证码错误！')
    user = await user_service_client.get_or_create_user_by_mobile(mobile)
    tokens = auth_handler.encode_login_token(user.id)
    return {
        'user': user,
        'access_token': tokens['access_token'],
        'refresh_token': tokens['refresh_token']
    }

@router.get('/access/token')
async def access_token_view(user_id: int=Depends(auth_handler.auth_access_dependency)):
    return {"detail": "access token验证成功！", 'user_id': user_id}

@router.get('/refresh/token')
async def refresh_token_view(user_id: int=Depends(auth_handler.auth_refresh_dependency)):
    # 调用/user/refresh/token，如果refresh token没有过期
    # 那么就重新返回一个access token
    access_token = auth_handler.encode_update_token(user_id)
    return access_token

@router.post('/logout', response_model=ResultModel)
async def logout(user_id: int=Depends(auth_handler.auth_access_dependency)):
    await tll_redis.delete_refresh_token(user_id)
    return ResultModel()

@router.put('/update/username', response_model=ResultModel)
async def update_username(data: UpdateUsernameModel, user_id: int=Depends(auth_handler.auth_access_dependency)):
    username = data.username
    await user_service_client.update_username(user_id, username)
    return ResultModel()
    
@router.put('/update/password', response_model=ResultModel)
async def update_password(data: UpdatePasswordModel,user_id: int=Depends(auth_handler.auth_access_dependency)):
    password = data.password
    await user_service_client.update_password(user_id, password)
    return ResultModel()

@router.post('/update/avatar', response_model=UpdatedAvatarModel)
async def update_avatar(
        file: UploadFile,
        user_id: int=Depends(auth_handler.auth_access_dependency)
):
    file_url = await oss_upload_image(file)
    if file_url:
        await user_service_client.update_avatar(user_id, file_url)
        return {'file_url': file_url}
    else:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail='头像上传失败！')

# 产品设计：当前登录的用户，不能查看其他用户的信息
@router.get('/mine', response_model=UserModel)
async def get_mine_info(user_id: int=Depends(auth_handler.auth_access_dependency)):
    user = user_service_client.get_user_by_id(user_id)
    return user
```

</details>

<details>
<summary>schemas/request.py</summary>

```python
from pydantic import BaseModel


class LoginModel(BaseModel):
    mobile: str
    code: str

class UpdateUsernameModel(BaseModel):
    username: str

class UpdatePasswordModel(BaseModel):
    password: str

class CreateAddressModel(BaseModel):
    realname: str
    mobile: str
    region: str
    detail: str

class DeleteAddressModel(BaseModel):
    id: str

class UpdateAddressModel(CreateAddressModel):
    id: str
```

</details>

<details>
<summary>schemas/response.py</summary>

```python
from pydantic import BaseModel
from enum import Enum
from typing import List


class ResultEnum(Enum):
    SUCCESS = 1
    FAILURE = 2

class ResultModel(BaseModel):
    result: ResultEnum = ResultEnum.SUCCESS

class UserModel(BaseModel):
    id: int
    mobile: str
    username: str
    avatar: str
    is_active: bool
    is_staff: bool

class LoginedModel(BaseModel):
    user: UserModel
    access_token: str
    refresh_token:str
    
class UpdatedAvatarModel(BaseModel):
    file_url: str

class AddressModel(BaseModel):
    id: str
    realname: str
    mobile: str
    region: str
    detail: str

class AddressListModel(BaseModel):
    addresses: List[AddressModel]
```

</details>

<details>
<summary>services/protos/address_pb2_grpc.py</summary>

```python
import address_pb2 as address__pb2
# 修改为
from . import address_pb2 as address__pb2
```

</details>

<details>
<summary>services/protos/address.proto</summary>

```python
syntax = "proto3";
import "google/protobuf/empty.proto";

service Address {
  rpc CreateAddress(CreateAddressRequest) returns (AddressResponse);
  rpc UpdateAddress(UpdateAddressRequest) returns (google.protobuf.Empty);
  rpc DeleteAddress(DeleteAddressRequest) returns (google.protobuf.Empty);
  rpc GetAddressById(AddressIdRequest) returns (AddressResponse);
  rpc GetAddressList(AddressListRequest) returns (AddressListResponse);
}

message CreateAddressRequest {
  uint64 user_id = 1;
  string realname = 2;
  string mobile = 3;
  string region = 4;
  string detail = 5;
}

message UpdateAddressRequest {
  string id = 1;
  string realname = 2;
  string mobile = 3;
  string region = 4;
  string detail = 5;
  uint64 user_id = 6;
}

message DeleteAddressRequest {
  string id = 1;
  uint64 user_id = 2;
}

message AddressIdRequest {
  string id = 1;
  uint64 user_id = 2;
}

message AddressListRequest {
  uint64 user_id = 1;
  uint32 page = 2;
  uint32 size = 3;
}

message AddressInfo {
  string id = 1;
  string realname = 2;
  string mobile = 3;
  string region = 4;
  string detail = 5;
}

message AddressResponse {
  AddressInfo address = 1;
}

message AddressListResponse {
  repeated AddressInfo addresses = 1;
}
```

</details>

<details>
<summary>services/protos/user_pb2_grpc.py</summary>

```python
import user_pb2 as user__pb2
# 修改为
from . import user_pb2 as user__pb2
```

</details>

<details>
<summary>services/protos/user.proto</summary>

```python
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
<summary>services/address.py</summary>

```python
from utils.single import SingletonMeta
import grpc
from services.protos import address_pb2, address_pb2_grpc
from .decorators import grpc_error_handler
from utils.u_consul import MineConsul

mine_consul = MineConsul()

class AddressStub:
    def __init__(self):
        # self.user_service_addr = '127.0.0.1:5001'
        pass

    @property
    def user_service_addr(self):
        host, port = mine_consul.get_one_user_service_address()
        return f"{host}:{port}"

    async def __aenter__(self):
        self.channel = grpc.aio.insecure_channel(self.user_service_addr)
        stub = address_pb2_grpc.AddressStub(self.channel)
        return stub

    async def __aexit__(self, exc_type, exc_val, exc_tb):
        await self.channel.close()


class AddressServiceClient(metaclass=SingletonMeta):

    @grpc_error_handler
    async def create_address(
            self,
            user_id: int,
            realname: str,
            mobile: str,
            region: str,
            detail: str
    ):
        async with AddressStub() as stub:
            request = address_pb2.CreateAddressRequest(
                user_id=user_id,
                realname=realname,
                mobile=mobile,
                region=region,
                detail=detail
            )
            response = await stub.CreateAddress(request)
            return response.address

    @grpc_error_handler
    async def update_address(
            self,
            id: str,
            realname: str,
            mobile: str,
            region: str,
            detail: str,
            user_id: int,
    ):
        async with AddressStub() as stub:
            request = address_pb2.UpdateAddressRequest(
                id=id,
                user_id=user_id,
                realname=realname,
                mobile=mobile,
                region=region,
                detail=detail
            )
            await stub.UpdateAddress(request)

    @grpc_error_handler
    async def delete_address(self, user_id: int, id: str):
        async with AddressStub() as stub:
            request = address_pb2.DeleteAddressRequest(user_id=user_id, id=id)
            await stub.DeleteAddress(request)

    @grpc_error_handler
    async def get_address_by_id(self, user_id: int, id: str):
        async with AddressStub() as stub:
            request = address_pb2.AddressIdRequest(user_id=user_id, id=id)
            response = await stub.GetAddressById(request)
            return response.address

    @grpc_error_handler
    async def get_address_list(self, user_id: int, page: int=1, size: int=10):
        async with AddressStub() as stub:
            request = address_pb2.AddressListRequest(user_id=user_id, page=page, size=size)
            response = await stub.GetAddressList(request)
            return response.addresses
```

</details>

<details>
<summary>services/decorators.py</summary>

```python
from functools import wraps
from fastapi.exceptions import HTTPException
from utils.status_code import get_http_code

import grpc


def grpc_error_handler(func):
    @wraps(func)
    async def wrapper(*args, **kwargs):
        try:
            result = await func(*args, **kwargs)
            return result
        except grpc.RpcError as e:
            raise HTTPException(status_code=get_http_code(e.code()), detail=e.details())
    return wrapper
```

</details>

<details>
<summary>services/user.py</summary>

```python
from utils.single import SingletonMeta
import grpc
from services.protos import user_pb2, user_pb2_grpc
from services.decorators import grpc_error_handler
from utils.u_consul import MineConsul
from loguru import logger

mine_consul = MineConsul()

class UserStub:
    def __init__(self):
        # self.user_service_addr = '127.0.0.1:5001'
        pass

    @property
    def user_service_addr(self):
        host, port = mine_consul.get_one_user_service_address()
        logger.info(f"Get Address: {host}:{port}")
        return f"{host}:{port}"

    async def __aenter__(self):
        self.channel = grpc.aio.insecure_channel(self.user_service_addr)
        stub = user_pb2_grpc.UserStub(self.channel)
        return stub

    async def __aexit__(self, exc_type, exc_val, exc_tb):
        await self.channel.close()

class UserServiceClient(metaclass=SingletonMeta):

    @grpc_error_handler
    async def get_or_create_user_by_mobile(self, mobile: str):
        async with UserStub() as stub:
            request = user_pb2.MobileRequest(mobile=mobile)
            response = await stub.GetOrCreateUserByMobile(request)
            return response.user

    @grpc_error_handler
    async def update_username(self, user_id: int, username: str):
        async with UserStub() as stub:
            request = user_pb2.UsernameRequest(id=user_id, username=username)
            await stub.UpdateUsername(request)

    @grpc_error_handler
    async def update_password(self, user_id: int, password: str):
        async with UserStub() as stub:
            request = user_pb2.PasswordRequest(id=user_id, password=password)
            await stub.UpdatePassword(request)
    
    @grpc_error_handler
    async def update_avatar(self, user_id: int, avatar: str):
        async with UserStub() as stub:
            request = user_pb2.AvatarRequest(id=user_id, avatar=avatar)
            await stub.UpdateAvatar(request)

    @grpc_error_handler
    async def get_user_by_id(self, user_id: int):
        async with UserStub() as stub:
            request = user_pb2.IdRequest(id=user_id)
            response = await stub.UpdateAvatar(request)
            return response.user

    @grpc_error_handler
    async def get_user_by_mobile(self, mobile: str):
        async with UserStub() as stub:
            request = user_pb2.MobileRequest(mobile=mobile)
            response = await stub.GetUserByMobile(request)
            return response.user

    @grpc_error_handler
    async def get_user_list(self, page: int=1, size: int=10):
        async with UserStub() as stub:
            request = user_pb2.PageRequest(page=page, size=size)
            response = await stub.GetUserList(request)
            return response.users

    @grpc_error_handler
    async def verify_user(self, mobile: str, password: str):
        async with UserStub() as stub:
            request = user_pb2.VerifyUserRequest(mobile=mobile, password=password)
            response = await stub.VerifyUser(request)
            return response.user
```

</details>

<details>
<summary>settings/__init__.py</summary>

```python
from datetime import timedelta

JWT_SECRET_KEY = "helloworld"
JWT_ACCESS_TOKEN_EXPIRES = timedelta(hours=20)
JWT_REFRESH_TOKEN_EXPIRES = timedelta(days=15)

ALIYUN_OSS_ENDPOINT = "https://oss-cn-hangzhou.aliyuncs.com"
ALIYUN_OSS_BUCKET = "xxx"
ALIYUN_OSS_REGION = "cn-hangzhou"
ALIYUN_OSS_DOMAIN = "https://xxx.oss-cn-hangzhou.aliyuncs.com/"

CONSUL_HOST = '127.0.0.1'
CONSUL_HTTP_PORT = 8500
# user_service.service.consul
CONSUL_DNS_PORT = 8600

SERVER_PORT = 8000
```

</details>

<details>
<summary>utils/alyoss.py</summary>

```python
import os.path
import oss2

from fastapi import HTTPException
from fastapi import status
from fastapi import UploadFile
import settings
import uuid
from asgiref.sync import sync_to_async
from loguru import logger


async def oss_upload_image(file: UploadFile, max_size: int=1024*1024) -> str|None:
    if file.size > max_size:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f'文件不能超过{max_size}')
    # 获取文件拓展名
    # abc.png => ['abc', '.png']
    extension = os.path.splitext(file.filename)[1]
    if extension not in ['.jpg', '.jpeg', '.png']:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='请上传正确格式的图片！')

    access_key_id = os.environ['ALIBABA_CLOUD_ACCESS_KEY_ID']
    access_key_secret = os.environ['ALIBABA_CLOUD_ACCESS_KEY_SECRET']

    # 使用环境变量中获取的RAM用户访问密钥配置访问凭证
    auth = oss2.AuthV4(access_key_id, access_key_secret)
    # 填写Bucket所在地域对应的Endpoint。以华东1（杭州）为例，Endpoint填写为https://oss-cn-hangzhou.aliyuncs.com。
    # yourBucketName填写存储空间名称。
    bucket = oss2.Bucket(auth, settings.ALIYUN_OSS_ENDPOINT, settings.ALIYUN_OSS_BUCKET, region=settings.ALIYUN_OSS_REGION)

    filename = f"{uuid.uuid4().hex}{extension}"
    filedata = await file.read()
    # 同步转异步
    async_put_object = sync_to_async(bucket.put_object)
    result = await async_put_object(key=filename, data=filedata)
    if result.status == 200:
        # https://taolele-abc.oss-cn-hangzhou.aliyuncs.com/04c7e4c081d64128b3c5fe7c1b126f45.jpg
        file_url = f"{settings.ALIYUN_OSS_DOMAIN}{filename}"
        return file_url
    else:
        # requests -> Response.text
        logger.error(result.resp.text)
        return None
```

</details>

<details>
<summary>utils/alysms.py</summary>

```python
import os
from alibabacloud_dysmsapi20170525.client import Client as Dysmsapi20170525Client
from alibabacloud_tea_openapi import models as open_api_models
from alibabacloud_dysmsapi20170525 import models as dysmsapi_20170525_models
from alibabacloud_tea_util import models as util_models
from alibabacloud_tea_util.client import Client as UtilClient
from .single import SingletonMeta
import json


class AliyunSMSSender(metaclass=SingletonMeta):
    template_code = "SMS_154950909"
    sign_name = "阿里云短信测试"
    def __init__(self):
        """
        使用AK&SK初始化账号Client
        @return: Client
        @throws Exception
        """
        # 工程代码泄露可能会导致 AccessKey 泄露，并威胁账号下所有资源的安全性。以下代码示例仅供参考。
        # 建议使用更安全的 STS 方式，更多鉴权访问方式请参见：https://help.aliyun.com/document_detail/378659.html。
        config = open_api_models.Config(
            # 必填，请确保代码运行环境设置了环境变量 ALIBABA_CLOUD_ACCESS_KEY_ID。,
            access_key_id=os.environ['ALIBABA_CLOUD_ACCESS_KEY_ID'],
            # 必填，请确保代码运行环境设置了环境变量 ALIBABA_CLOUD_ACCESS_KEY_SECRET。,
            access_key_secret=os.environ['ALIBABA_CLOUD_ACCESS_KEY_SECRET']
        )
        # Endpoint 请参考 https://api.aliyun.com/product/Dysmsapi
        config.endpoint = f'dysmsapi.aliyuncs.com'
        self.client = Dysmsapi20170525Client(config)

    async def send_code(self, mobile, code: str):
        send_sms_request = dysmsapi_20170525_models.SendSmsRequest(
            phone_numbers=mobile,
            sign_name=self.sign_name,
            template_code=self.template_code,
            template_param=json.dumps({'code': code})
        )
        try:
            # 复制代码运行请自行打印 API 的返回值
            response = await self.client.send_sms_with_options_async(send_sms_request, util_models.RuntimeOptions())
            print(response)
        except Exception as error:
            # 此处仅做打印展示，请谨慎对待异常处理，在工程项目中切勿直接忽略异常。
            # 错误 message
            print(error.message)
            # 诊断地址
            print(error.data.get("Recommend"))
            UtilClient.assert_as_string(error.message)
```

</details>

<details>
<summary>utils/auth.py</summary>

```python
import jwt
from fastapi import HTTPException, Security
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from datetime import datetime
from enum import Enum
import settings
from .single import SingletonMeta
from starlette.status import HTTP_401_UNAUTHORIZED, HTTP_403_FORBIDDEN


class TokenTypeEnum(Enum):
    ACCESS_TOKEN = 1
    REFRESH_TOKEN = 2


class AuthHandler(metaclass=SingletonMeta):
    security = HTTPBearer()
    # Authorization: Bearer {token}

    secret = settings.JWT_SECRET_KEY

    def _encode_token(self, user_id: int, type: TokenTypeEnum):
        payload = dict(
            iss=user_id,
            sub=str(type.value)
        )
        to_encode = payload.copy()
        if type == TokenTypeEnum.ACCESS_TOKEN:
            exp = datetime.now() + settings.JWT_ACCESS_TOKEN_EXPIRES
        else:
            exp = datetime.now() + settings.JWT_REFRESH_TOKEN_EXPIRES
        to_encode.update({"exp": int(exp.timestamp())})
        return jwt.encode(to_encode, self.secret, algorithm='HS256')

    def encode_login_token(self, user_id: int):
        access_token = self._encode_token(user_id, TokenTypeEnum.ACCESS_TOKEN)
        refresh_token = self._encode_token(user_id, TokenTypeEnum.REFRESH_TOKEN)
        login_token = dict(
            access_token=f"{access_token}",
            refresh_token=f"{refresh_token}"
        )
        return login_token

    def encode_update_token(self, user_id):
        access_token = self._encode_token(user_id, TokenTypeEnum.ACCESS_TOKEN)

        update_token = dict(
            access_token=f"{access_token}"
        )
        return update_token

    def decode_access_token(self, token):
        # ACCESS TOKEN：不可用（过期，或有问题），都用403错误
        try:
            payload = jwt.decode(token, self.secret, algorithms=['HS256'])
            if payload['sub'] != str(TokenTypeEnum.ACCESS_TOKEN.value):
                raise HTTPException(status_code=HTTP_403_FORBIDDEN, detail='Token类型错误！')
            return payload['iss']
        except jwt.ExpiredSignatureError:
            raise HTTPException(status_code=HTTP_403_FORBIDDEN, detail='Access Token已过期！')
        except jwt.InvalidTokenError as e:
            raise HTTPException(status_code=HTTP_403_FORBIDDEN, detail='Access Token不可用！')

    def decode_refresh_token(self, token):
        # REFRESH TOKEN：不可用（过期，或有问题），都用401错误
        try:
            payload = jwt.decode(token, self.secret, algorithms=['HS256'])
            if payload['sub'] != str(TokenTypeEnum.REFRESH_TOKEN.value):
                raise HTTPException(status_code=HTTP_401_UNAUTHORIZED, detail='Token类型错误！')
            return payload['iss']
        except jwt.ExpiredSignatureError:
            raise HTTPException(status_code=HTTP_401_UNAUTHORIZED, detail='Refresh Token已过期！')
        except jwt.InvalidTokenError as e:
            raise HTTPException(status_code=HTTP_401_UNAUTHORIZED, detail='Refresh Token不可用！')

    def auth_access_dependency(self, auth: HTTPAuthorizationCredentials = Security(security)):
        return self.decode_access_token(auth.credentials)

    def auth_refresh_dependency(self, auth: HTTPAuthorizationCredentials = Security(security)):
        return self.decode_refresh_token(auth.credentials)
```

</details>

<details>
<summary>utils/cache.py</summary>

```python
from .single import SingletonMeta
import redis.asyncio as redis


class TLLRedis(metaclass=SingletonMeta):

    SMS_CODE_PREFIX = 'sms_code_{}'
    
    def __init__(self):
        self.client = redis.Redis(host='127.0.0.1', port='6379', db=0)

    async def set(self, key, value, ex=5*60*60):
        await self.client.set(key, value, ex)

    async def get(self, key):
        value = await self.client.get(key)
        if type(value) == bytes:
            return value.decode('utf-8')
        return value

    async def set_sms_code(self, mobile, code):
        await self.set(self.SMS_CODE_PREFIX.format(mobile), code)

    async def get_sms_code(self, mobile):
        code = await self.get(self.SMS_CODE_PREFIX.format(mobile))
        return code

    async def close(self):
        await self.client.aclose()
```

</details>

<details>
<summary>utils/single.py</summary>

```python
from threading import Lock

class SingletonMeta(type):
    """
    This is a thread-safe implementation of Singleton.
    """
    _instances = {}
    _lock: Lock = Lock()

    def __call__(cls, *args, **kwargs):
        with cls._lock:
            if cls not in cls._instances:
                instance = super().__call__(*args, **kwargs)
                cls._instances[cls] = instance
        return cls._instances[cls]
```

</details>

<details>
<summary>utils/status_code.py</summary>

```python
# https://gist.github.com/hamakn/708b9802ca845eb59f3975dbb3ae2a01

from grpc import StatusCode

code_dict = {
    StatusCode.OK: 200,
    StatusCode.CANCELLED: 499,
    StatusCode.UNKNOWN: 500,
    StatusCode.INVALID_ARGUMENT: 400,
    StatusCode.DEADLINE_EXCEEDED: 504,
    StatusCode.NOT_FOUND: 404,
    StatusCode.ALREADY_EXISTS: 409,
    StatusCode.PERMISSION_DENIED: 403,
    StatusCode.RESOURCE_EXHAUSTED: 429,
    StatusCode.FAILED_PRECONDITION: 400,
    StatusCode.ABORTED: 409,
    StatusCode.OUT_OF_RANGE: 400,
    StatusCode.UNIMPLEMENTED: 501,
    StatusCode.INTERNAL: 500,
    StatusCode.UNAVAILABLE: 503,
    StatusCode.DATA_LOSS: 500,
    StatusCode.UNAUTHENTICATED: 401
}

def get_http_code(grpc_code: StatusCode):
    return code_dict[grpc_code]
```

</details>

<details>
<summary>utils/u_consul.py</summary>

```python
import consul
from .single import SingletonMeta
import uuid
import socket
from typing import Tuple
import settings
# pip install dnspython
from dns import asyncresolver, rdatatype
from typing import List, Dict


def get_current_ip() -> Tuple[str, int]:
    sock_ip = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock_ip.connect(('8.8.8.8', 80))
    ip = sock_ip.getsockname()[0]
    sock_ip.close()
    return ip


class ServiceAddress:
    def __init__(self, host: str, port: int):
        self.host = host
        self.port = port
        self.count = 0

    def increment(self):
        self.count += 1


class LoadBalancer:
    def __init__(self, addresses: List[Dict[str, str|int]]=None):
        self.addresses: List[ServiceAddress] = []
        if addresses:
            self.init_addresses(addresses)

    def init_addresses(self, addresses: List[Dict[str, str|int]]):
        self.addresses.clear()
        for address in addresses:
            self.addresses.append(ServiceAddress(host=address['ip'], port=address['port']))

    def get_address(self) -> Tuple[str|None, int|None]:
        if len(self.addresses) > 0:
            self.addresses.sort(key=lambda address: address.count)
            address = self.addresses[0]
            address.increment()
            return address.host, address.port
        else:
            return None, None


class MineConsul(metaclass=SingletonMeta):
    def __init__(self):
        self.consul_host = settings.CONSUL_HOST
        self.consul_http_port = settings.CONSUL_HTTP_PORT
        self.consul_dns_port = settings.CONSUL_DNS_PORT
        self.client = consul.Consul(host=self.consul_host, port=self.consul_http_port)
        self.user_service_id = uuid.uuid4().hex
        self.user_service_lb = LoadBalancer()

    def register(self):
        ip = get_current_ip()
        port = settings.SERVER_PORT
        self.client.agent.service.register(
            name='user_api',
            service_id=self.user_service_id,
            address=ip,
            port=port,
            tags=['user', 'http'],
            check=consul.Check.http(url=f"http://{ip}:{port}/health", interval='10s')
        )

    def deregister(self):
        self.client.agent.service.deregister(self.user_service_id)

    async def fetch_user_service_addresses(self):
        resolver = asyncresolver.Resolver()
        resolver.nameservers = [self.consul_host]
        resolver.port = self.consul_dns_port

        answer_ip = await resolver.resolve(f'user_service.service.consul', rdatatype.A)
        ips = []
        for info in answer_ip:
            ips.append(info.address)

        ports = []
        answer_port = await resolver.resolve('user_service.service.consul', rdatatype.SRV)
        for info in answer_port:
            ports.append(info.port)

        user_addresses = []
        for index, port in enumerate(ports):
            if len(ips) == 1:
                user_addresses.append({"ip": ips[0], 'port': port})
            else:
                user_addresses.append({"ip": ips[index], 'port': port})
        self.user_service_lb.init_addresses(user_addresses)

    def get_one_user_service_address(self) -> Tuple[str|None, int|None]:
        return self.user_service_lb.get_address()
```

</details>

<details>
<summary>bash.sh</summary>

```bash
docker compose up -d
docker compose down
docker stop userapi
docker start userapi
docker exec -it userapi /bin/bash

source ~/pyenvs/userapi/bin/activate
# set python mirror repo
pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/simple

# install dependencies
pip install -r requirements.txt
pip install --upgrade pip
pip install fastapi[standard] loguru alibabacloud_dysmsapi20170525==4.1.1 redis[hiredis] grpcio grpcio-tools pyjwt oss2 asgiref python-multipart
# 
pip install fastapi[standard]
pip install loguru
pip install alibabacloud_dysmsapi20170525==4.1.1
pip install redis[hiredis]
pip install grpcio grpcio-tools
pip install pyjwt
pip install oss2
pip install asgiref
pip install python-multipart
pip install py-consul
pip install dnspython

# config aliyun sms
export ALIBABA_CLOUD_ACCESS_KEY_ID=xxx
export ALIBABA_CLOUD_ACCESS_KEY_SECRET=xxx

# FastAPI commands
fastapi dev main.py --port 8000 --host 0.0.0.0
```

</details>

<details>
<summary>curls.sh</summary>

```bash
# user
curl -X GET http://127.0.0.1:8000/user/smscode/18899990000

curl -X POST http://127.0.0.1:8000/user/login \
    -H 'Content-Type:application/json' \
    -d '{"mobile": "18899990000", "code": "8051"}' | jq . --color-output

curl -X GET http://127.0.0.1:8000/user/access/token \
    -H 'Authorization: Bearer XXX' | jq . --color-output

curl -X GET http://127.0.0.1:8000/user/refresh/token \
    -H 'Authorization: Bearer XXX' | jq . --color-output

curl -X PUT http://127.0.0.1:8000/user/update/username \
    -H 'Authorization: Bearer XXX' \
    -H 'Content-Type:application/json' \
    -d '{"username": "法外狂徒fasdfasdf"}' | jq . --color-output

curl -X POST http://127.0.0.1:8000/user/update/avatar \
    -H 'Authorization: Bearer XXX' \
    -F 'file=@/path/avatar.jpg' | jq . --color-output

curl -X POST http://127.0.0.1:8000/address/create \
    -H 'Authorization: Bearer XXX' \
    -H 'Content-Type:application/json' \
    -d '{"realname": "大头儿子", "mobile": "18899991112", "region": "广东省白云区", "detail": "xx卢"}' | jq . --color-output

curl -X DELETE http://127.0.0.1:8000/address/delete \
    -H 'Authorization: Bearer XXX' \
    -H 'Content-Type:application/json' \
    -d '{"id": "92fbeb2724af4f79bd31c30cc0068aa9"}' | jq . --color-output

curl -X PUT http://127.0.0.1:8000/address/update \
    -H 'Authorization: Bearer XXX' \
    -H 'Content-Type:application/json' \
    -d '{"id": "fc1c080704634b879fa85bb703e62a8a", "realname": "小头爸爸", "mobile": "18899991112", "region": "南京省白云区", "detail": "xx卢发生的"}' | jq . --color-output

curl -X GET http://127.0.0.1:8000/address/detail/fc1c080704634b879fa85bb703e62a8a \
    -H 'Authorization: Bearer XXX' \
    | jq . --color-output

curl -X GET "http://127.0.0.1:8000/address/list?page=1&size=20" \
    -H 'Authorization: Bearer XXX' \
    | jq . --color-output
```

</details>

<details>
<summary>main.py</summary>

```python
from fastapi import FastAPI
from hooks.lifespan import lifespan
from hooks.middlewares import log_middleware
from loguru import logger
from starlette.middleware.base import BaseHTTPMiddleware
from routers import user, address
import uvicorn
import settings

app = FastAPI(lifespan=lifespan)

app.add_middleware(BaseHTTPMiddleware, dispatch=log_middleware)

# 添加路由
app.include_router(user.router)
app.include_router(address.router)

@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.get("/health")
async def health_check():
    return "ok"

if __name__ == '__main__':
    uvicorn.run(app, host='0.0.0.0', port=settings.SERVER_PORT)
```

</details>
