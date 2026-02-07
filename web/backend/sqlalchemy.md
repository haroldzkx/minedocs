SQLAlchemy: [https://www.sqlalchemy.org/](https://www.sqlalchemy.org/)

# 安装相关库

- 安装 SQLAlchemy（异步版本）: [https://docs.sqlalchemy.org/en/20/orm/extensions/asyncio.html#asyncio-install](https://docs.sqlalchemy.org/en/20/orm/extensions/asyncio.html#asyncio-install)

- 安装 asyncmy 驱动: [https://github.com/long2ice/asyncmy?tab=readme-ov-file#install](https://github.com/long2ice/asyncmy?tab=readme-ov-file#install)

- 安装 cryptography（数据库加密连接）: [https://cryptography.io/en/latest/installation/](https://cryptography.io/en/latest/installation/)

```bash
pip install sqlalchemy[asyncio]
pip install asyncmy
pip install cryptography
```

# 异步连接 MySQL

- 配置连接参数: [https://docs.sqlalchemy.org/en/20/dialects/mysql.html#asyncmy](https://docs.sqlalchemy.org/en/20/dialects/mysql.html#asyncmy)

- 创建 Engine 对象: [https://docs.sqlalchemy.org/en/20/orm/extensions/asyncio.html#sqlalchemy.ext.asyncio.AsyncEngine](https://docs.sqlalchemy.org/en/20/orm/extensions/asyncio.html#sqlalchemy.ext.asyncio.AsyncEngine)

- create_async_engine 参数: [https://docs.sqlalchemy.org/en/20/core/engines.html#sqlalchemy.create_engine.params.connect_args](https://docs.sqlalchemy.org/en/20/core/engines.html#sqlalchemy.create_engine.params.connect_args)

- 创建会话工厂: [https://docs.sqlalchemy.org/en/20/orm/session_api.html](https://docs.sqlalchemy.org/en/20/orm/session_api.html)

- 创建会话工厂的参数配置: [https://docs.sqlalchemy.org/en/20/orm/session_api.html#sqlalchemy.orm.sessionmaker](https://docs.sqlalchemy.org/en/20/orm/session_api.html#sqlalchemy.orm.sessionmaker.__init__)

<details>
<summary>数据库连接模板代码</summary>

```python
# models/__init__.py
from sqlalchemy.ext.asyncio import create_async_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.ext.declarative import declarative_base

DB_URI = "mysql+asyncmy://user:password@host:port/db_name?charset=utf8mb4"

engine = create_async_engine(
    DB_URI,
    echo=True,  # 输出所有执行SQL的日志，默认是关闭的
    pool_size=10,   # 连接池大小，默认为5
    max_overflow=20,    # 允许连接池最大的连接数，默认为10
    pool_timeout=10,    # 获得连接超时时间，默认是30s
    pool_recycle=3600,  # 连接回收时间，默认是-1，表示永不回收
    pool_pre_ping=True, # 连接前是否预检查，默认是False
)

AsyncSessionFactory = sessionmaker(
    bind=engine,    # Engine或者其子类对象，这里是AsyncEngine
    class_=AsyncSession,    # Session类的替代，默认是Session类
    autoflush=True, # 是否在查找之前执行flush的操作（默认是True）
    expire_on_commit=False, # 是否在执行commit操作后Session就过期，默认是True
)

Base = declarative_base()

# 导入其他模型的python文件
from . import user
```

</details>

# 创建模型

定义 Base 类并创建 ORM 模型:

- [https://docs.sqlalchemy.org/en/20/orm/quickstart.html#declare-models](https://docs.sqlalchemy.org/en/20/orm/quickstart.html#declare-models)

- [https://docs.sqlalchemy.org/en/20/orm/mapping_styles.html#declarative-mapping](https://docs.sqlalchemy.org/en/20/orm/mapping_styles.html#declarative-mapping)

# alembic迁移模型

模型定义后，将模型表映射到数据库中

<details>
<summary>alembic命令</summary>

```bash
# 1.创建迁移仓库
# 异步
alembic init alembic --template async
# 同步
alembic init alembic

# 2.修改alembic.ini中的连接数据库的配置
sqlalchemy.url = mysql+asyncmy://user:password@host:port/database?charset=utf8mb4

# 3.修改env.py
# 将alembic/env.py中的target_metadata修改为
from models import Base
target_metadata = Base.metadata

# 4.生成迁移脚本
alembic revision --autogenerate -m "修改的内容"

# 5.执行迁移脚本
alembic upgrade head
# 回到上一个版本
alembic downgrade
```

</details>

alembic: [https://alembic.sqlalchemy.org/en/latest/](https://alembic.sqlalchemy.org/en/latest/)

安装: [https://alembic.sqlalchemy.org/en/latest/front.html#installation](https://alembic.sqlalchemy.org/en/latest/front.html#installation)

创建迁移仓库（异步 MySQL 需要加上参数`--template async`）: [https://alembic.sqlalchemy.org/en/latest/tutorial.html#creating-an-environment](https://alembic.sqlalchemy.org/en/latest/tutorial.html#creating-an-environment)

修改 alembic.ini（主要是 sqlalchemy.url 参数）: [https://alembic.sqlalchemy.org/en/latest/tutorial.html#editing-the-ini-file](https://alembic.sqlalchemy.org/en/latest/tutorial.html#editing-the-ini-file)

修改 env.py: 修改 target_metadata

生成迁移脚本（添加参数 `--autogenerate`）: [https://alembic.sqlalchemy.org/en/latest/tutorial.html#create-a-migration-script](https://alembic.sqlalchemy.org/en/latest/tutorial.html#create-a-migration-script)

执行迁移脚本: [https://alembic.sqlalchemy.org/en/latest/tutorial.html#running-our-first-migration](https://alembic.sqlalchemy.org/en/latest/tutorial.html#running-our-first-migration)

版本回退: [https://alembic.sqlalchemy.org/en/latest/tutorial.html#downgrading](https://alembic.sqlalchemy.org/en/latest/tutorial.html#downgrading)

# 外键

表关系: [https://docs.sqlalchemy.org/en/20/orm/relationships.html](https://docs.sqlalchemy.org/en/20/orm/relationships.html)

一对一: [https://docs.sqlalchemy.org/en/20/orm/basic_relationships.html#one-to-one](https://docs.sqlalchemy.org/en/20/orm/basic_relationships.html#one-to-one)

一对多: [https://docs.sqlalchemy.org/en/20/orm/basic_relationships.html#one-to-many](https://docs.sqlalchemy.org/en/20/orm/basic_relationships.html#one-to-many)

多对一: [https://docs.sqlalchemy.org/en/20/orm/basic_relationships.html#many-to-one](https://docs.sqlalchemy.org/en/20/orm/basic_relationships.html#many-to-one)

多对多: [https://docs.sqlalchemy.org/en/20/orm/basic_relationships.html#many-to-many](https://docs.sqlalchemy.org/en/20/orm/basic_relationships.html#many-to-many)

# CURD

<details>
<summary>创建 Session 对象（依赖项）</summary>

```python
async def get_session():
    session = AsyncSessionFactory()
    try:
        yield session
    finally:
        await session.close()

@app.post('/article/add', response_model=UserResp)
async def add_article(req: UserCreateReq, session: AsyncSession = Depends(get_session)):
    async with session.begin():
        user = User(username = req.username, email = req.email, password = req.password)
        session.add(user)
    return user
```

</details>

<details>
<summary>创建 Session 对象（异步上下文管理器）</summary>

```python
from pydantici import BaseModel
from db import AsyncSessionFactory

class UserRespSchema(basemodel):
    id: int
    email: str
    username: str

    class Config:
        orm_mode = true

class UserCreateRegSchema(BaseModel):
    email: str
    username: str
    password: str

@app.post('/article/add', response_model=UserRespSchema)
async def add_article(req: UserCreateRegSchema):
    async with AsyncSessionFactory() as session:
        try:
            async with session.begin():
                user = User(username=reg.username, email=req.email, password=req.password)
                session.add(user)
        except Exception as e:
            raise HTTPException(status_code=400, detail='xxx')
        return user
```

</details>

<details>
<summary>创建 Session 对象（中间件）</summary>

```python
@app.middleware('http')
async def create_session_middleware(request: Request, call_next):
    # 请求前的中间件（调用call_next前）
    session = AsyncSessionFactory()
    setattr(request.state, 'session', session)
    response = await call_next(request)
    # 响应后的中间件（调用call_next后）
    await session.close()
    return response

@app.post('/article/add', response_model=UserResp)
async def add_article(user_body: UserCreateReq, request: AsyncSession):
    async with request.state.session.begin():
        user = User(username = user_body.username, email = user_body.email, password = user_body.password)
        request.state.session.add(user)
    return user
```

</details>

使用 ORM 进行数据操作: [https://docs.sqlalchemy.org.cn/en/20/tutorial/orm_data_manipulation.html](https://docs.sqlalchemy.org.cn/en/20/tutorial/orm_data_manipulation.html)

新增数据: [https://docs.sqlalchemy.org/en/20/tutorial/orm_data_manipulation.html#inserting-rows-using-the-orm-unit-of-work-pattern](https://docs.sqlalchemy.org/en/20/tutorial/orm_data_manipulation.html#inserting-rows-using-the-orm-unit-of-work-pattern)

删除数据: [https://docs.sqlalchemy.org/en/20/tutorial/orm_data_manipulation.html#deleting-orm-objects-using-the-unit-of-work-pattern](https://docs.sqlalchemy.org/en/20/tutorial/orm_data_manipulation.html#deleting-orm-objects-using-the-unit-of-work-pattern)

修改数据:

- 查找，修改，保存

- 直接修改

- [https://docs.sqlalchemy.org.cn/en/20/tutorial/orm_data_manipulation.html#updating-orm-objects-using-the-unit-of-work-pattern](https://docs.sqlalchemy.org.cn/en/20/tutorial/orm_data_manipulation.html#updating-orm-objects-using-the-unit-of-work-pattern)

查询数据:

- [https://docs.sqlalchemy.org.cn/en/20/orm/queryguide/index.html](https://docs.sqlalchemy.org.cn/en/20/orm/queryguide/index.html)

- [https://docs.sqlalchemy.org/en/20/orm/queryguide/index.html](https://docs.sqlalchemy.org/en/20/orm/queryguide/index.html)
