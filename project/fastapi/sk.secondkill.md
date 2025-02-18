# 秒杀系统

## 项目结构

![](https://gitee.com/haroldzkx/pbed1/raw/main/fastapi/arch.png)

1. 先从 redis 中获取库存是否足够
2. 如果不够，直接返回
3. 如果足够，将请求数据存入 kafka，库存减1，并立即返回
4. 从 kafka 中读取请求数据，生成订单，包括 alipay_order 字符串，存入 MySQL，以及 Redis 中
5. 客户端定时请求服务器，从 Redis 中获取 alipay_order，并完成支付
6. 服务器接收支付宝的回调，修改订单为已经成功
7. 定时任务，将已超时定时任务从 Redis 中删除，并将库存 +1

kafka 可以作为秒杀系统中的中间件，起到削峰填谷的功能。当秒杀开始时，会有大量的请求过来，这时候我们先把请求封装成 Event，然后存放到 kafka 的指定 Topic 中，接着我们可以再启一个项目，专门从 kafka 中读取请求消息进行处理。

```python
alembic/	# 使用alembic命令生成的
alembic/env.py  # 命令生成的，但需要修改配置

hooks/__init__.py
hooks/dependencies.py
hooks/middlewares.py

keys/alipay_public.pem
keys/app_private.key

models/__init__.py
models/base.py
models/order.py
models/seckill.py

routers/__init__.py
routers/order.py
routers/seckill.py

schemas/__init__.py
schemas/request.py
schemas/response.py

settings/__init__.py

utils/snowflake/__init__.py
utils/snowflake/exceptions.py
utils/snowflake/id_worker.py
utils/snowflake/snowflake.py
utils/__init__.py
utils/auth.py
utils/cache.py
utils/single.py
utils/sk_alipay.py

alembic.ini
commands.py
curls.sh
kafka_consumer.py
main.py
README.md
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
<summary>hooks/dependencies.py</summary>

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
<summary>hooks/middlewares.py</summary>

```python
from models import AsyncSessionFactory
from fastapi import Request


async def db_session_middleware(request: Request, call_next):
    # 请求前的中间件（调用call_next前）
    session = AsyncSessionFactory()
    setattr(request.state, 'session', session)
    response = await call_next(request)
    # 响应后的中间件（调用call_next后）
    await session.close()
    return response
```

</details>

<details>
<summary>keys/alipay_public.pem</summary>

```pem
-----BEGIN PUBLIC KEY-----
xxx
-----END PUBLIC KEY-----
```

</details>

<details>
<summary>keys/app_private.key</summary>

```key
-----BEGIN PRIVATE KEY-----
xxx
-----END PRIVATE KEY-----
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

from . import order
from . import seckill
```

</details>

<details>
<summary>models/base.py</summary>

```python
from utils.snowflake import snowflake
from sqlalchemy import Column, BigInteger

id_worker = snowflake.Snowflake(0, 0)


def generate_id():
    return id_worker.get_id()


class SnowFlakeIdModel:
    id = Column(BigInteger, primary_key=True, default=generate_id)
```

</details>

<details>
<summary>models/order.py</summary>

```python
from . import Base
from .base import SnowFlakeIdModel
from sqlalchemy_serializer import SerializerMixin
from sqlalchemy import Column, String, BigInteger, ForeignKey, DateTime, Enum, Integer, DECIMAL
from datetime import datetime
from sqlalchemy.orm import relationship
from .seckill import Seckill
import enum


class OrderStatusEnum(enum.Enum):
    # 未支付
    UNPAYED = 1
    # 已支付
    PAYED = 2
    # 运输中
    TRANSIT = 3
    # 完成
    FINISHED = 4
    # 退款中
    REFUNDING = 5
    # 已退款
    REFUNDED = 6


class Order(Base, SnowFlakeIdModel, SerializerMixin):
    __tablename__ = 'order'
    serialize_only = ('id', 'create_time', 'status', 'count', 'amount', 'user_id', 'address', 'seckill')
    create_time = Column(DateTime, default=datetime.now)
    status = Column(Enum(OrderStatusEnum), default=OrderStatusEnum.UNPAYED)
    count = Column(Integer)
    amount = Column(DECIMAL(10, 2))

    alipay_trade_no = Column(String(200))

    user_id = Column(BigInteger)
    address = Column(String(500))

    seckill_id = Column(BigInteger, ForeignKey("seckill.id"))
    seckill = relationship(Seckill, backref='orders', lazy='joined')
```

</details>

<details>
<summary>models/seckill.py</summary>

```python
from . import Base
from sqlalchemy import Column, BigInteger, String, DECIMAL, JSON, Text, DateTime, Integer, ForeignKey
from sqlalchemy.orm import relationship, backref
from datetime import datetime
from sqlalchemy_serializer import SerializerMixin
from .base import SnowFlakeIdModel
import uuid


class Commodity(Base, SnowFlakeIdModel, SerializerMixin):
    __tablename__ = 'commodity'
    serialize_only = ('id', 'title', 'price', 'covers', 'detail', 'create_time')
    title = Column(String(200))
    price = Column(DECIMAL(10, 2))
    covers = Column(JSON)
    detail = Column(Text)
    create_time = Column(DateTime, default=datetime.now)


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

</details>

<details>
<summary>routers/order.py</summary>

```python
from fastapi import APIRouter, Depends
from sqlalchemy import select
from models.order import Order
from schemas.response import OrderListSchema
from hooks.dependencies import get_db_session
from models import AsyncSession
from utils.auth import AuthHandler

auth_handler = AuthHandler()

router = APIRouter(prefix='/order')


@router.get('/list', response_model=OrderListSchema)
async def order_list(
        page: int=1,
        size: int=10,
        user_id: int=Depends(auth_handler.auth_access_dependency),
        session: AsyncSession=Depends(get_db_session)
):
    async with session.begin():
        offset = (page-1)*size
        result = await session.execute(
            select(Order).where(
                Order.user_id==user_id
            ).order_by(
                Order.create_time.desc()
            ).limit(size).offset(offset)
        )
        orders = result.scalars()
    return {"orders": orders}
```

</details>

<details>
<summary>routers/seckill.py</summary>

```python
from fastapi import APIRouter, Depends, HTTPException, status, Request
from sqlalchemy import select, update
from models.seckill import Seckill
from models.order import Order
from datetime import datetime
from schemas.response import SeckillListSchema, SeckillSchema, ResultSchema
from hooks.dependencies import get_db_session
from models import AsyncSession
from utils.auth import AuthHandler
from schemas.request import BuySchema
from alipay import AliPay
from alipay.utils import AliPayConfig
from models.order import Order, OrderStatusEnum
import aiofiles
import settings
from kafka import KafkaProducer
import json
from utils.cache import sk_redis


auth_handler = AuthHandler()


# 支付宝网页下载的证书不能直接被使用，需要加上头尾
# 你可以在此处找到例子： tests/certs/ali/ali_private_key.pem
# 异步读取文件
# async with aiofiles.open('keys/app_private.key', mode='r') as f:
#     app_private_key_string = await f.read()
# async with aiofiles.open('keys/alipay_public.pem', mode='r') as f:
#     alipay_public_key_string = await f.read()
with open('keys/app_private.key', mode='r') as f:
    app_private_key_string = f.read()
with open('keys/alipay_public.pem', mode='r') as f:
    alipay_public_key_string = f.read()

alipay = AliPay(
    appid=settings.ALIPAY_APP_ID,
    # app_notify_url="http://www.example.com/notify",  # 默认回调 url
    app_notify_url="http://318621gs38qz.vicp.fun/seckill/alipay/notify",
    app_private_key_string=app_private_key_string,
    # 支付宝的公钥，验证支付宝回传消息使用，不是你自己的公钥,
    alipay_public_key_string=alipay_public_key_string,
    sign_type="RSA2",  # RSA 或者 RSA2
    # 沙箱环境需要设置debug=True
    debug=True,  # 默认 False
    verbose=True,  # 输出调试数据
    config=AliPayConfig(timeout=15)  # 可选，请求超时时间
)

kafka_producer = KafkaProducer(
    bootstrap_servers=settings.KAFKA_SERVER,
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)


router = APIRouter(prefix='/seckill')

# @router.get('/ing', response_model=SeckillListSchema)
# async def get_ing_seckills(request: Request, page: int=1, size: int=10):
#     async with request.state.session.begin():
#         # 秒杀中：start_time <= now, end_time >= now
#         now = datetime.now()
#         offset = (page-1)*size
#         stmt = select(Seckill).where(Seckill.start_time<=now, Seckill.end_time>=now).order_by(Seckill.create_time.desc()).limit(size).offset(offset)
#         result = await request.state.session.execute(stmt)
#         rows = result.scalars()
#         return {"seckills": rows}
#
#
# @router.get('/will', response_model=SeckillListSchema)
# async def get_will_seckills(request: Request, page: int=1, size: int=10):
#     async with request.state.session.begin():
#         # 即将秒杀：start_time > now
#         now = datetime.now()
#         offset = (page-1)*size
#         stmt = select(Seckill).where(Seckill.start_time>now).order_by(Seckill.create_time.desc()).limit(size).offset(offset)
#         result = await request.state.session.execute(stmt)
#         rows = result.scalars()
#         return {"seckills": rows}

@router.get('/ing', response_model=SeckillListSchema)
async def get_ing_seckills(session: AsyncSession=Depends(get_db_session), page: int=1, size: int=10):
    async with session.begin():
        # 秒杀中：start_time <= now, end_time >= now
        now = datetime.now()
        offset = (page-1)*size
        stmt = select(Seckill).where(Seckill.start_time<=now, Seckill.end_time>=now).order_by(Seckill.create_time.desc()).limit(size).offset(offset)
        result = await session.execute(stmt)
        rows = result.scalars()
        return {"seckills": rows}


@router.get('/will', response_model=SeckillListSchema)
async def get_will_seckills(session: AsyncSession=Depends(get_db_session), page: int=1, size: int=10):
    async with session.begin():
        # 即将秒杀：start_time > now
        now = datetime.now()
        offset = (page-1)*size
        stmt = select(Seckill).where(Seckill.start_time>now).order_by(Seckill.create_time.desc()).limit(size).offset(offset)
        result = await session.execute(stmt)
        rows = result.scalars()
        return {"seckills": rows}

@router.post('/lock')
async def mysql_lock(session: AsyncSession=Depends(get_db_session)):
    seckill_id = 1824791667731857408

    # 1. 悲观锁实现
    # async with session.begin():
    #     # 先查找（with_for_update），再更新
    #     result = await session.execute(select(Seckill).where(Seckill.id==seckill_id).with_for_update())
    #     seckill = result.scalar()
    #     seckill.stock -= 1
    #     # 事务执行完后，就会自动释放悲观锁

    # 2. 乐观锁实现
    async with session.begin():
        result = await session.execute(select(Seckill).where(Seckill.id==seckill_id))
        seckill = result.scalar()
        seckill.stock -= 1
    return "ok"

# @router.post('/buy')
# async def buy(data: BuySchema, session: AsyncSession=Depends(get_db_session), user_id: int=Depends(auth_handler.auth_access_dependency)):
#     seckill_id = data.seckill_id
#     count = data.count
#     address = data.address
#
#     # 只能让用户抢购一次
#     async with session.begin():
#         result = await session.execute(select(Order).where(Order.user_id==user_id, Order.seckill_id==seckill_id))
#         order = result.scalar()
#         # if order:
#         #     raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='您已参加该秒杀！')
#
#         seckill_result = await session.execute(select(Seckill).where(Seckill.id==seckill_id).with_for_update())
#         seckill = seckill_result.scalar()
#         if not seckill:
#             raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='该秒杀不存在！')
#         if seckill.stock <= 0:
#             raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='库存不足！')
#         if seckill.sk_per_max_count < count:
#             raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f'最多抢购{count}个！')
#         # 下面两行代码是用来测试并发的
#         # import asyncio
#         # await asyncio.sleep(10)
#         # 更新库存
#         await session.execute(update(Seckill).where(Seckill.id==seckill_id).values(stock=seckill.stock-1))
#
#     # 再重新开启一个事务
#     async with session.begin():
#         order = Order(user_id=user_id, seckill_id=seckill_id, count=count, amount=seckill.sk_price*count, address=address)
#         session.add(order)
#
#     order_string = alipay.api_alipay_trade_app_pay(
#         out_trade_no=order.id,
#         total_amount=float(order.amount),
#         subject=seckill.commodity.title
#     )
#     # 获取支付宝的orderStr
#     return {"alipay_order": order_string}


@router.post('/buy', response_model=ResultSchema)
async def buy(
    data: BuySchema, session: AsyncSession=Depends(get_db_session),
    user_id: int=Depends(auth_handler.auth_access_dependency)
):
    # 0. 先判断是否存在未支付或已支付的订单
    order = await sk_redis.get_order(user_id, data.seckill_id)
    if order:
        if order['status'] == OrderStatusEnum.UNPAYED.value:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='您有尚未支付的订单！')
        if order['status'] == OrderStatusEnum.PAYED.value:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='您已经抢购过商品！')

    # 1. 先进行库存减1
    result = await sk_redis.decrease_stock(data.seckill_id)
    if not result:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='库存不足！')
    # 2. 如果有库存
    # 变成字典
    form_data = data.model_dump()
    form_data['user_id'] = user_id
    kafka_producer.send('seckill', form_data)
    return ResultSchema()


@router.get('/detail/{seckill_id}', response_model=SeckillSchema)
async def seckill_detail(seckill_id: int, session: AsyncSession=Depends(get_db_session)):
    async with session.begin():
        result = await session.execute(select(Seckill).where(Seckill.id==seckill_id))
        seckill = result.scalar()
        if not seckill:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='该秒杀不存在！')
        return seckill

@router.post("/alipay/notify")
async def alipay_notify(
    request: Request,
    session: AsyncSession=Depends(get_db_session)
):
    form_data = await request.form()
    data = dict(form_data)
    sign = data.pop("sign")
    result = alipay.verify(data, sign)
    if not result:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='该请求无效！')
    # 自己的订单号
    out_trade_no = data.get('out_trade_no')
    # 支付宝的订单号
    trade_no = data.get('trade_no')
    trade_status = data.get('trade_status')
    async with session.begin():
        result = await session.execute(select(Order).where(Order.id==out_trade_no))
        order = result.scalar()
        if not order:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='该订单不存在！')
        order.alipay_trade_no = trade_no
        if trade_status == 'WAIT_BUYER_PAY':
            order.status = OrderStatusEnum.UNPAYED
        elif trade_status == 'TRADE_CLOSED':
            order.status = OrderStatusEnum.REFUNDED
        elif trade_status == 'TRADE_SUCCESS':
            order.status = OrderStatusEnum.PAYED
        elif trade_status == 'TRADE_FINISHED':
            order.status = OrderStatusEnum.FINISHED
    await sk_redis.add_order(order=order, alipay_order=None)
    return "success"

@router.get('/order/{seckill_id}')
async def get_seckill_order(
    seckill_id: int,
    user_id: int=Depends(auth_handler.auth_access_dependency)
):
    order = await sk_redis.get_order(user_id, seckill_id)
    if not order:
        # raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='您未抢购本商品！')
        return {"alipay_order": ''}
    return {"alipay_order": order['alipay_order']}
```

</details>

<details>
<summary>schemas/request.py</summary>

```python
from pydantic import BaseModel, ConfigDict


class BuySchema(BaseModel):
    # 把整形，转换为字符串类型
    model_config = ConfigDict(coerce_numbers_to_str=True)
    seckill_id: int
    count: int
    # 这里传的是地址的具体信息，比如：北京市朝阳区xxx，而不是存储address_id
    address: str
```

</details>

<details>
<summary>schemas/response.py</summary>

```python
from pydantic import BaseModel, ConfigDict
from typing import List
from datetime import datetime
from enum import Enum

class ResultEnum(Enum):
    SUCCESS = 1
    FAILURE = 2


class ResultSchema(BaseModel):
    result: ResultEnum = ResultEnum.SUCCESS

class CommoditySchema(BaseModel):
    # 把整形，转换为字符串类型
    model_config = ConfigDict(coerce_numbers_to_str=True)
    # id: int
    id: str
    title: str
    price: float
    covers: List[str]
    detail: str
    create_time: datetime

class SeckillSchema(BaseModel):
    # 把整形，转换为字符串类型
    model_config = ConfigDict(coerce_numbers_to_str=True)
    # id: int
    id: str
    sk_price: float
    start_time: datetime
    end_time: datetime
    create_time: datetime
    max_sk_count: int
    sk_per_max_count: int
    stock: int

    commodity: CommoditySchema


class SeckillListSchema(BaseModel):
    seckills: List[SeckillSchema]


class OrderSchema(BaseModel):
    # 把整形，转换为字符串类型
    model_config = ConfigDict(coerce_numbers_to_str=True)
    # id: int
    id: str
    create_time: datetime
    status: int
    count: int
    amount: float
    address: str
    seckill: SeckillSchema


class OrderListSchema(BaseModel):
    orders: List[OrderSchema]
```

</details>

<details>
<summary>settings/__init__.py</summary>

```python
MYSQL_HOST = '127.0.0.1'
MYSQL_PORT = '3306'
MYSQL_USER = 'username'
MYSQL_PASSWORD = "password"
MYSQL_DB = 'seckill_db'

# aiomysql
# pip install aiomysql
# asyncmy：在保存64位的整形时，有bug：Unexpected <class 'OverflowError'>: Python int too large to convert to C unsigned long
DB_URI = f"mysql+asyncmy://{MYSQL_USER}:{MYSQL_PASSWORD}@{MYSQL_HOST}:{MYSQL_PORT}/{MYSQL_DB}?charset=utf8mb4"

JWT_SECRET_KEY = "helloworld"

ALIPAY_APP_ID = "9021000150619361"

KAFKA_SERVER = "192.168.0.14:9092"
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
<summary>utils/snowflake/id_worker.py</summary>

```python
# Twitter's Snowflake algorithm implementation which is used to generate distributed IDs.
# https://github.com/twitter-archive/snowflake/blob/snowflake-2010/src/main/scala/com/twitter/service/snowflake/IdWorker.scala

import time
import logging

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


logger = logging.getLogger('flask.app')


class IdWorker(object):
    """
    用于生成IDs
    """

    def __init__(self, datacenter_id, worker_id, sequence=0):
        """
        初始化
        :param datacenter_id: 数据中心（机器区域）ID
        :param worker_id: 机器ID
        :param sequence: 其实序号
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
            logging.error('clock is moving backwards. Rejecting requests until {}'.format(self.last_timestamp))
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


if __name__ == '__main__':
    worker = IdWorker(1, 2, 0)
    print(worker.get_id())
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
<summary>utils/auth.py</summary>

```python
import jwt
from fastapi import HTTPException, Security
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from enum import Enum
import settings
from .single import SingletonMeta
from starlette.status import HTTP_403_FORBIDDEN


class TokenTypeEnum(Enum):
    ACCESS_TOKEN = 1
    REFRESH_TOKEN = 2


class AuthHandler(metaclass=SingletonMeta):
    security = HTTPBearer()

    secret = settings.JWT_SECRET_KEY

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

    def auth_access_dependency(self, auth: HTTPAuthorizationCredentials = Security(security)):
        return self.decode_access_token(auth.credentials)
```

</details>

<details>
<summary>utils/cache.py</summary>

```python
from .single import SingletonMeta
import redis.asyncio as redis
from models.seckill import Seckill
from models.order import Order
import json
from datetime import datetime


class SecondKillRedis(metaclass=SingletonMeta):

    SECKILL_KEY = "seckill_{}"
    SECKILL_ORDER_KEY = "seckill_order_{user_id}_{seckill_id}"
    SECKILL_STOCK_KEY = "seckill_stock_{}"
    SECKILL_STOCK_LOCK_KEY = "seckill_stock_lock_{}"

    def __init__(self):
        self.client = redis.Redis(host='localhost', port=6379, db=0)

    async def set(self, key, value, ex=5*60*60):
        await self.client.set(key, value, ex)

    async def set_dict(self, key: str, value: dict, ex: int=5*60*60):
        await self.set(key, json.dumps(value), ex)

    async def get(self, key):
        value = await self.client.get(key)
        if type(value) == bytes:
            return value.decode('utf-8')
        return value

    async def get_dict(self, key: str):
        value = await self.get(key)
        if not value:
            return None
        return json.loads(value)

    async def delete(self, key):
        await self.client.delete(key)

    async def decrease(self, key, amount=1):
        await self.client.decrby(key, amount)

    async def increase(self, key, amount=1):
        await self.client.incrby(key, amount)

    async def close(self):
        await self.client.aclose()

    async def add_seckill(self, seckill: Seckill):
        seckill_dict = seckill.to_dict()
        key = self.SECKILL_KEY.format(seckill.id)
        exp = int((seckill.end_time-datetime.now()).total_seconds())
        await self.set(key, json.dumps(seckill_dict), ex=exp)

    async def get_seckill(self, seckill_id: int):
        key = self.SECKILL_KEY.format(seckill_id)
        seckill_dict = await self.get_dict(key)
        return seckill_dict

    async def init_stock(self, seckill_id: int, stock: int):
        key = self.SECKILL_STOCK_KEY.format(seckill_id)
        await self.set(key, stock)

    async def get_stock(self, seckill_id: int):
        key = self.SECKILL_STOCK_KEY.format(seckill_id)
        return self.get(key)

    async def decrease_stock(self, seckill_id: int):
        key = self.SECKILL_STOCK_KEY.format(seckill_id)
        lock_key = self.SECKILL_STOCK_LOCK_KEY.format(seckill_id)
        async with self.client.lock(lock_key):
            # 竞态
            stock = await self.get(key)
            if not stock or int(stock) <= 0:
                return False
            await self.decrease(key, 1)
            return True

    async def increase_stock(self, seckill_id: int):
        key = self.SECKILL_STOCK_KEY.format(seckill_id)
        await self.increase(key, 1)

    async def add_order(self, order: Order, alipay_order: str):
        # user_id, seckill_id
        key = self.SECKILL_ORDER_KEY.format(user_id=order.user_id, seckill_id=order.seckill_id)
        order_dict = order.to_dict()
        order_dict['alipay_order'] = alipay_order
        ex = (order.seckill.end_time-datetime.now()).total_seconds()
        await self.set_dict(key, order_dict, ex=int(ex))

    async def get_order(self, user_id: int, seckill_id: int):
        key = self.SECKILL_ORDER_KEY.format(user_id=user_id, seckill_id=seckill_id)
        order_dict = await self.get_dict(key)
        return order_dict


sk_redis = SecondKillRedis()
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
<summary>utils/sk_alipay.py</summary>

```python
from .single import SingletonMeta
from alipay import AliPay, AliPayConfig
import settings


class Second_Kill_Alipay(metaclass=SingletonMeta):
    def __init__(self):
        with open('keys/app_private.key', mode='r') as f:
            app_private_key_string = f.read()
        with open('keys/alipay_public.pem', mode='r') as f:
            alipay_public_key_string = f.read()

        client = AliPay(
            appid=settings.ALIPAY_APP_ID,
            # app_notify_url="http://www.example.com/notify",  # 默认回调 url
            app_notify_url="http://318621gs38qz.vicp.fun/seckill/alipay/notify",
            app_private_key_string=app_private_key_string,
            # 支付宝的公钥，验证支付宝回传消息使用，不是你自己的公钥,
            alipay_public_key_string=alipay_public_key_string,
            sign_type="RSA2",  # RSA 或者 RSA2
            # 沙箱环境需要设置debug=True
            debug=True,  # 默认 False
            verbose=True,  # 输出调试数据
            config=AliPayConfig(timeout=15)  # 可选，请求超时时间
        )
        self.client = client

    def app_pay(self, out_trade_no: str, total_amount: float, subject: str):
        order_string = self.client.api_alipay_trade_app_pay(
            out_trade_no=out_trade_no,
            total_amount=total_amount,
            subject=subject
        )
        # 获取支付宝的orderStr
        return {"alipay_order": order_string}


sk_alipay = Second_Kill_Alipay()
```

</details>

<details>
<summary>commands.py</summary>

```python
from models import AsyncSessionFactory
from models.seckill import Commodity, Seckill
from datetime import datetime, timedelta
import asyncio
from utils.cache import sk_redis


async def init_seckill_ed():
    title = '联想ThinkPad T14P 2023 可选2024工程师编程 设计师轻薄本 ibm笔记本电脑 i9-13900H 32G内存 512G固态'
    covers = ['https://img12.360buyimg.com/n1/jfs/t1/88086/28/43013/78611/64e9b26cFd2cf3bce/ef3afd998fa46017.jpg',
              'https://img12.360buyimg.com/n1/jfs/t1/223525/20/19283/102058/6460b156F6a457e67/69c39dab7328f4a7.jpg']
    price = 9999
    detail = '<img src="https://img11.360buyimg.com/cms/jfs/t1/81345/8/21825/132140/64ad0e8fFa68ad575/00ed8092a6b95071.jpg" /><img src="https://img11.360buyimg.com/cms/jfs/t1/211324/26/37468/111470/64ad0e8fF623a675d/e3b920a169f75f88.jpg" />'
    commodity = Commodity(title=title, covers=covers, price=price, detail=detail)

    seckill = Seckill(sk_price=6999, start_time=datetime.now() - timedelta(days=1), end_time=datetime.now(),
                      max_sk_count=10, sk_per_max_count=1, stock=10, commodity=commodity)

    async with AsyncSessionFactory() as session:
        async with session.begin():
            session.add(commodity)
            session.add(seckill)
    print('ed秒杀数据添加成功！')


async def init_seckill_ing():
    title = '茅台（MOUTAI）飞天 53%vol 500ml 贵州茅台酒（带杯）'
    covers = ['https://img13.360buyimg.com/n1/jfs/t1/97097/12/15694/245806/5e7373e6Ec4d1b0ac/9d8c13728cc2544d.jpg',
              'https://img13.360buyimg.com/n1/jfs/t1/249760/32/13845/169919/66835f87F26a10873/da4a057761be16f6.jpg']
    price = 2525
    detail = """
            <div>
				<img src="https://img30.360buyimg.com/sku/jfs/t1/154199/7/27952/160501/6371ed18Eae70f83f/3a3c43b823ddfd19.jpg" alt="">
				<img src="https://img30.360buyimg.com/sku/jfs/t1/102199/7/34595/124717/6371eb5bEa1ce165e/92584583e82cc994.jpg" alt="">
				<img src="https://img30.360buyimg.com/sku/jfs/t1/116251/7/29193/130833/6371eb5cEe14bc797/e2cbeb2d2ece1455.jpg" alt="">
			</div>
			"""
    commodity = Commodity(title=title, covers=covers, price=price, detail=detail)
    seckill = Seckill(sk_price=1499, start_time=datetime.now(), end_time=datetime.now() + timedelta(days=365),
                      max_sk_count=10, sk_per_max_count=1, stock=10, commodity=commodity)

    async with AsyncSessionFactory() as session:
        async with session.begin():
            session.add(commodity)
            session.add(seckill)

    print('ing秒杀数据添加成功！')


async def init_seckill_ing_redis():
    title = '茅台（MOUTAI）飞天 53%vol 500ml 贵州茅台酒（带杯）-Redis'
    covers = ['https://img13.360buyimg.com/n1/jfs/t1/97097/12/15694/245806/5e7373e6Ec4d1b0ac/9d8c13728cc2544d.jpg',
              'https://img13.360buyimg.com/n1/jfs/t1/249760/32/13845/169919/66835f87F26a10873/da4a057761be16f6.jpg']
    price = 2525
    detail = """
            <div>
				<img src="https://img30.360buyimg.com/sku/jfs/t1/154199/7/27952/160501/6371ed18Eae70f83f/3a3c43b823ddfd19.jpg" alt="">
				<img src="https://img30.360buyimg.com/sku/jfs/t1/102199/7/34595/124717/6371eb5bEa1ce165e/92584583e82cc994.jpg" alt="">
				<img src="https://img30.360buyimg.com/sku/jfs/t1/116251/7/29193/130833/6371eb5cEe14bc797/e2cbeb2d2ece1455.jpg" alt="">
			</div>
			"""
    commodity = Commodity(title=title, covers=covers, price=price, detail=detail)
    seckill = Seckill(sk_price=1499, start_time=datetime.now(), end_time=datetime.now() + timedelta(days=365),
                      max_sk_count=10, sk_per_max_count=1, stock=10, commodity=commodity)
    # 1. 将秒杀数据添加到数据库中
    async with AsyncSessionFactory() as session:
        async with session.begin():
            session.add(commodity)
            session.add(seckill)
    # 2. 把秒杀数据也要同步到redis
    await sk_redis.add_seckill(seckill)
    await sk_redis.init_stock(seckill.id, seckill.stock)

    print('ing秒杀数据添加成功！')


async def init_seckill_will():
    title = 'ae86车模可开门汽车模型摆件合金男孩藤原豆腐店1比24头文字D 大号AE86全白色+豆腐店场景+防尘 轿车'
    covers = ['https://img14.360buyimg.com/n1/jfs/t1/91732/30/42256/99363/65f178bdF9e38d03f/5947bef9087e36e4.jpg',
              'https://img14.360buyimg.com/n1/jfs/t1/200366/26/40486/86334/65f178baFe9560549/3af2c255c62bad39.jpg']
    price = 1999
    detail = '<img src="https://img10.360buyimg.com/imgzone/jfs/t1/234054/1/16233/81713/65f7a07dF63847f28/1f5c0c7e6db00963.jpg" /><img src="https://img10.360buyimg.com/imgzone/jfs/t1/234054/1/16233/81713/65f7a07dF63847f28/1f5c0c7e6db00963.jpg" />'
    commodity = Commodity(title=title, covers=covers, price=price, detail=detail)

    seckill = Seckill(sk_price=899, start_time=datetime.now()+timedelta(days=365), end_time=datetime.now() + timedelta(days=730),
                      max_sk_count = 10, sk_per_max_count = 1, stock=10, commodity = commodity)

    async with AsyncSessionFactory() as session:
        async with session.begin():
            session.add(commodity)
            session.add(seckill)
    print('will秒杀数据添加成功！')


async def main():
    await init_seckill_ed()
    await init_seckill_ing()
    await init_seckill_will()
    await init_seckill_ing_redis()

if __name__ == '__main__':
    # https://www.cnblogs.com/james-wangx/p/16111485.html
    asyncio.run(main())
    # loop = asyncio.get_event_loop()
    # loop.run_until_complete(main())
```

</details>

<details>
<summary>curls.sh</summary>

```bash
curl -s -X GET http://127.0.0.1:8100/seckill/ing | jq . --color-output

curl -s -X GET http://127.0.0.1:8100/seckill/will | jq . --color-output

curl -s -X GET http://127.0.0.1:8100/seckill/detail/1941486788178608128 | jq . --color-output
curl -s -X GET http://127.0.0.1:8100/seckill/detail/1941486788694507520 | jq . --color-output
curl -s -X GET http://127.0.0.1:8100/seckill/detail/1941486788929388544 | jq . --color-output

curl -s -X POST http://127.0.0.1:8100/seckill/lock | jq . --color-output

curl -s -X POST http://127.0.0.1:8100/seckill/buy \
    -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOjE5Mzg5MDI3NjkyNDI5OTY3MzYsInN1YiI6IjEiLCJleHAiOjE3NTE4NTE4MDV9.vB8Fc-dKWawEy70X_XUkQC2icDgtU126nnpYdz4SAzg' \
    -H 'Content-Type:application/json' \
    -d '{"address": "北京市南京区广州街道", "count": 1, "seckill_id": "1941710239204114432"}' | jq . --color-output

curl -s -X GET http://127.0.0.1:8100/seckill/detail/1941710239204114432 | jq . --color-output

curl -s -X GET http://127.0.0.1:8100/order/list \
    -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOjE5Mzg5MDI3NjkyNDI5OTY3MzYsInN1YiI6IjEiLCJleHAiOjE3NTE4NTE4MDV9.vB8Fc-dKWawEy70X_XUkQC2icDgtU126nnpYdz4SAzg' \
    | jq . --color-output
```

</details>

<details>
<summary>kafka_consumer.py</summary>

```python
from kafka import KafkaConsumer
import settings
import json
import asyncio
from utils.cache import sk_redis
from loguru import logger
from models import AsyncSessionFactory
from models.order import Order
from utils.sk_alipay import sk_alipay


async def seckill_queue_handle():
    consumer = KafkaConsumer(
        'seckill',
        auto_offset_reset='latest',
        bootstrap_servers=[settings.KAFKA_SERVER],
        value_deserializer=lambda m: json.loads(m.decode('utf-8'))
    )
    print('正在监听中...')
    for message in consumer:
        seckill_dict = message.value
        seckill_id = seckill_dict['seckill_id']
        user_id = seckill_dict['user_id']
        count = seckill_dict['count']
        address = seckill_dict['address']

        seckill = await sk_redis.get_seckill(seckill_id)
        if not seckill:
            logger.info(f'{seckill_id}秒杀商品不存在！')
        if count > seckill['sk_per_max_count']:
            logger.info(f"{user_id}抢购了{count}，超过了{seckill['sk_per_max_count']}")
        async with AsyncSessionFactory() as session:
            async with session.begin():
                order = Order(
                    user_id=user_id, seckill_id=seckill_id, count=count,
                    amount=seckill['sk_price']*count,
                    address=address
                )
                session.add(order)
            await session.refresh(order, attribute_names=['seckill'])
        alipay_order = sk_alipay.app_pay(
            out_trade_no=str(order.id),
            total_amount=float(order.amount),
            subject=seckill['commodity']['title']
        )
        await sk_redis.add_order(order, alipay_order['alipay_order'])


async def main():
    await seckill_queue_handle()


if __name__ == '__main__':
    asyncio.run(main())
```

</details>

<details>
<summary>main.py</summary>

```python
from fastapi import FastAPI
from hooks.middlewares import db_session_middleware
from starlette.middleware.base import BaseHTTPMiddleware
from routers import seckill, order
app = FastAPI()

# 添加路由
app.include_router(seckill.router)
app.include_router(order.router)

app.add_middleware(BaseHTTPMiddleware, dispatch=db_session_middleware)

@app.get("/")
async def root():
    return {"message": "Hello World"}
```

</details>

<details>
<summary>README.md</summary>

```bash
# FastAPI 运行命令
fastapi dev main.py --port 8100 --host 0.0.0.0
uvicorn main:app --reload --port 8100 --host 0.0.0.0

# Docker命令
docker compose up -d
docker compose down
docker stop secondkillapi
docker start secondkillapi
docker exec -it secondkillapi /bin/bash

# 环境
source .venv/bin/activate
# set python mirror repo
pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/simple

# install dependencies
pip install -r requirements.txt
pip install fastapi[standard] asyncmy sqlalchemy[asyncio] sqlalchemy-serializer alembic pyjwt python-alipay-sdk aiofiles

# Alembic commands
alembic init alembic --template async
alembic revision --autogenerate -m "add user model"
alembic upgrade head
```

</details>
