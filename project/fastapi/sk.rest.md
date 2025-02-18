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

services/protos/__init__.py
services/protos/address_pb2_grpc.py
services/protos/address_pb2.py
services/protos/address.proto
services/protos/user_pb2_grpc.py
services/protos/user_pb2.py
services/protos/user.proto
services/__init__.py
services/address.py
services/decorators.py
services/user.py

settings/__init__.py

utils/__init__.py
utils/alyoss.py
utils/alysms.py
utils/auth.py
utils/cache.py
utils/grpc_bl.py
utils/single.py
utils/status_code.py
utils/u_consul.py

avatar.jpg
curls.sh
docker-compose.yml
main.py
README.md
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
    logger.add("logs/file.log", rotation="500 MB", enqueue=True, level='INFO')
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
from schemas.request import LoginModel, UpdateUsernameModel, UpdatePasswordModel, LoginWithPassword
from utils.auth import AuthHandler
from fastapi import Depends, UploadFile
from services.user import UserServiceClient
from utils.alyoss import oss_upload_image
from fastapi import status

router = APIRouter(prefix='/user', tags=['user'])

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
    # 单点登录
    # 1. 先把refresh_token存储在服务器
    # 2. 把refresh_token从服务器上删掉
    await tll_redis.set_refresh_token(user.id, tokens['refresh_token'])
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

@router.post('/login/with/pwd', response_model=LoginedModel)
async def login_with_pwd(data: LoginWithPassword):
    mobile = data.mobile
    password = data.password
    user = await user_service_client.verify_user(mobile, password)
    if user:
        tokens = auth_handler.encode_login_token(user.id)
        await tll_redis.set_refresh_token(user.id, tokens['refresh_token'])
        return {
            'user': user,
            'access_token': tokens['access_token'],
            'refresh_token': tokens['refresh_token']
        }
    else:
        raise HTTPException(status_code=400, detail='Mobile or Password not correct!')
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

class LoginWithPassword(BaseModel):
    mobile: str
    password: str
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
ALIYUN_OSS_BUCKET = "seckilluserapi"
ALIYUN_OSS_REGION = "cn-hangzhou"
ALIYUN_OSS_DOMAIN = "https://seckilluserapi.oss-cn-hangzhou.aliyuncs.com/"

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
import settings


class TLLRedis(metaclass=SingletonMeta):
    SMS_CODE_PREFIX = 'sms_code_{}'
    REFRESH_TOKEN_PREFIX = "refresh_token_{}"
    
    def __init__(self):
        self.client = redis.Redis(host='127.0.0.1', port='6379', db=0)

    async def set(self, key, value, ex=5*60*60):
        await self.client.set(key, value, ex)

    async def get(self, key):
        value = await self.client.get(key)
        if type(value) == bytes:
            return value.decode('utf-8')
        return value

    async def delete(self, key):
        await self.client.delete(key)

    async def set_sms_code(self, mobile, code):
        await self.set(self.SMS_CODE_PREFIX.format(mobile), code)

    async def get_sms_code(self, mobile):
        code = await self.get(self.SMS_CODE_PREFIX.format(mobile))
        return code

    async def set_refresh_token(self, user_id, refresh_token):
        ex = settings.JWT_REFRESH_TOKEN_EXPIRES
        await self.set(self.REFRESH_TOKEN_PREFIX.format(user_id), refresh_token, ex=ex)

    async def get_refresh_token(self, user_id):
        refresh_token = await self.get(self.REFRESH_TOKEN_PREFIX.format(user_id))
        return refresh_token

    async def delete_refresh_token(self, user_id):
        await self.delete(self.REFRESH_TOKEN_PREFIX.format(user_id))

    async def close(self):
        await self.client.aclose()
```

</details>

<details>
<summary>utils/grpc_bl.py</summary>

```python
from .single import SingletonMeta
import consul
from dns import resolver
from dns import rdatatype
from typing import List, Dict
import settings


class GrpcAddress:
    def __init__(self, host: str, port: int):
        self.count = 0
        self.host = host
        self.port = port

    def increment(self):
        self.count += 1

    def format(self):
        return f"{self.host}:{self.port}"


class GrpcLoadBalancer(metaclass=SingletonMeta):
    def __init__(self, consul_host: str):
        self.consul_host = consul_host
        self.consul_client = consul.Consul(host=consul_host, port=8500)
        self.service_addresses: Dict[str, List[GrpcAddress]] = {}
        self._fetch_addresses()

    def _fetch_addresses(self):
        reso = resolver.Resolver()
        reso.nameservers = [self.consul_host]
        reso.port = 8600

        for service_name in settings.GRPC_SERVICE_NAMES:
            dnsanswer = reso.resolve(f"{service_name}.service.consul", rdatatype.A)
            dnsanswer_srv = reso.resolve(f"{service_name}.service.consul", rdatatype.SRV)
            for index, srv in enumerate(dnsanswer_srv):
                if len(dnsanswer) == 1:
                    ip = dnsanswer[0].address
                else:
                    ip = dnsanswer[index].address
                self.service_addresses[service_name].append(GrpcAddress(ip, srv.port))

    def get_address(self, service_name: str):
        print(self.service_addresses)
        print(service_name)
        addresses = self.service_addresses[service_name]
        addresses.sort(key=lambda address: address.count)
        address = addresses[0]
        address.increment()
        return address.format()
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
<summary>curls.sh</summary>

```bash
# user
curl -X GET http://127.0.0.1:8000/user/smscode/18899990000

curl -X POST http://127.0.0.1:8000/user/login \
    -H 'Content-Type:application/json' \
    -d '{"mobile": "18899990000", "code": "5691"}' | jq . --color-output

curl -X GET http://127.0.0.1:8000/user/access/token \
    -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOjE5Mzg5MDI3NjkyNDI5OTY3MzYsInN1YiI6IjEiLCJleHAiOjE3NTEyNDYwODJ9.pPxCxehKwsTzG7mZ2qnBW0QOo4eR-KOVIFmEfrxeiv4' | jq . --color-output

curl -X GET http://127.0.0.1:8000/user/refresh/token \
    -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOjE5Mzg5MDI3NjkyNDI5OTY3MzYsInN1YiI6IjIiLCJleHAiOjE3NTI0NzAwNjN9.rlELyHrWbYBxTg8x12i71DEmN_opF55QLEAldkB72I0' | jq . --color-output

curl -X PUT http://127.0.0.1:8000/user/update/username \
    -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOjE5Mzg5MDI3NjkyNDI5OTY3MzYsInN1YiI6IjEiLCJleHAiOjE3NTEyNDYwODJ9.pPxCxehKwsTzG7mZ2qnBW0QOo4eR-KOVIFmEfrxeiv4' \
    -H 'Content-Type:application/json' \
    -d '{"username": "法外狂徒fasdfasdf"}' | jq . --color-output

curl -X POST http://127.0.0.1:8000/user/update/avatar \
    -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOjE5Mzg5MDI3NjkyNDI5OTY3MzYsInN1YiI6IjEiLCJleHAiOjE3NTEyNzA0MDh9.LYCePz9ijCvNYnsp1y2in_1rZWhFV4XkAxjbKtsSYDQ' \
    -F 'file=@/home/happy/ms/userapi/avatar.jpg' | jq . --color-output

curl -X POST http://127.0.0.1:8000/address/create \
    -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOjE5Mzg5MDI3NjkyNDI5OTY3MzYsInN1YiI6IjEiLCJleHAiOjE3NTEzNjU4ODZ9.fmO2Y-6aLX8sbPlcKiYzSOk6nCVPKX03TE9xINRhqUw' \
    -H 'Content-Type:application/json' \
    -d '{"realname": "大头儿子", "mobile": "18899991112", "region": "广东省白云区", "detail": "xx卢"}' | jq . --color-output

curl -X DELETE http://127.0.0.1:8000/address/delete \
    -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOjE5Mzg5MDI3NjkyNDI5OTY3MzYsInN1YiI6IjEiLCJleHAiOjE3NTEzNjU4ODZ9.fmO2Y-6aLX8sbPlcKiYzSOk6nCVPKX03TE9xINRhqUw' \
    -H 'Content-Type:application/json' \
    -d '{"id": "92fbeb2724af4f79bd31c30cc0068aa9"}' | jq . --color-output

curl -X PUT http://127.0.0.1:8000/address/update \
    -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOjE5Mzg5MDI3NjkyNDI5OTY3MzYsInN1YiI6IjEiLCJleHAiOjE3NTEzNjU4ODZ9.fmO2Y-6aLX8sbPlcKiYzSOk6nCVPKX03TE9xINRhqUw' \
    -H 'Content-Type:application/json' \
    -d '{"id": "fc1c080704634b879fa85bb703e62a8a", "realname": "小头爸爸", "mobile": "18899991112", "region": "南京省白云区", "detail": "xx卢发生的"}' | jq . --color-output

curl -X GET http://127.0.0.1:8000/address/detail/fc1c080704634b879fa85bb703e62a8a \
    -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOjE5Mzg5MDI3NjkyNDI5OTY3MzYsInN1YiI6IjEiLCJleHAiOjE3NTEzNjU4ODZ9.fmO2Y-6aLX8sbPlcKiYzSOk6nCVPKX03TE9xINRhqUw' \
    | jq . --color-output

curl -X GET "http://127.0.0.1:8000/address/list?page=1&size=20" \
    -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOjE5Mzg5MDI3NjkyNDI5OTY3MzYsInN1YiI6IjEiLCJleHAiOjE3NTEzNjc0NTR9.YX8YMaKQr4cupjkHf6a3lw2rq8UWfEUk2f5Slothu8k' \
    | jq . --color-output
```

</details>

<details>
<summary>docker-compose.yml</summary>

```yml
services:
  userapi:
    image: registry.cn-shenzhen.aliyuncs.com/haroldfinch/python:3.10.16-slim-bookworm
    container_name: userapi
    ports:
      - 8000:8000
    volumes:
      - ./:/home/app
    working_dir: /home/app
    command: ["tail", "-f", "/dev/null"]
    networks:
      - app-network
    environment:
      - REDIS_HOST=redis  # 环境变量指定 Redis 容器的名称
      - REDIS_PORT=6379   # 默认的 Redis 端口
      - ALIBABA_CLOUD_ACCESS_KEY_ID=xxx
      - ALIBABA_CLOUD_ACCESS_KEY_SECRET=xxx
  redis:
    image: registry.cn-shenzhen.aliyuncs.com/haroldfinch/redis:6.2.16
    container_name: redismine
    ports:
      - 6379:6379
    networks:
      - app-network
networks:
  app-network:
    driver: bridge
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

<details>
<summary>README.md</summary>

```bash
# 1.FastAPI 运行命令
fastapi dev main.py --port 8000 --host 0.0.0.0

# 2.Docker命令
docker compose up -d
docker compose down
docker stop userapi
docker start userapi
docker exec -it userapi /bin/bash

# 3.环境
source .venv/bin/activate
# set python mirror repo
pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/simple

# install dependencies
pip install -r requirements.txt
pip install fastapi[standard] loguru alibabacloud_dysmsapi20170525==4.1.1 redis[hiredis] grpcio grpcio-tools pyjwt oss2 asgiref python-multipart py-consul dnspython

# config aliyun sms
export ALIBABA_CLOUD_ACCESS_KEY_ID=xxx
export ALIBABA_CLOUD_ACCESS_KEY_SECRET=xxx

# 4.Alembic commands
alembic init alembic --template async
alembic revision --autogenerate -m "add user model"
alembic upgrade head

# 5.gRPC commands
cd protos
python -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. user.proto
python -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. address.proto
```

</details>
