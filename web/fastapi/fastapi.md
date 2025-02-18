# FastAPI

安装: [https://fastapi.tiangolo.com/zh/#\_3](https://fastapi.tiangolo.com/zh/#_3)

示例: [https://fastapi.tiangolo.com/zh/#\_4](https://fastapi.tiangolo.com/zh/#_4)

运行: [https://fastapi.tiangolo.com/zh/#\_6](https://fastapi.tiangolo.com/zh/#_6)

```bash
# 开发环境
fastapt dev
fastapi dev main.py
fastapi dev main.py --port 8081 --host xxxx

# 生产环境（低层也是基于uvicorn）
fastapi run

uvicorn main:app --reload
uvicorn main:app --reload --port 8082 --host xxxx
```

# 类型提示

类型提示简介: [https://fastapi.tiangolo.com/zh/python-types/](https://fastapi.tiangolo.com/zh/python-types/)

对类型提示的支持(typing): [https://docs.python.org/zh-cn/3/library/typing.html](https://docs.python.org/zh-cn/3/library/typing.html)

类型种类: [https://mypy.readthedocs.io/en/stable/kinds_of_types.html](https://mypy.readthedocs.io/en/stable/kinds_of_types.html)

类型检查 mypy: [https://mypy.readthedocs.io/en/stable/index.html](https://mypy.readthedocs.io/en/stable/index.html)

额外数据类型: [https://fastapi.tiangolo.com/zh/tutorial/extra-data-types/](https://fastapi.tiangolo.com/zh/tutorial/extra-data-types/)

# Pydantic

Pydantic 是做数据校验的。

官方文档: [https://docs.pydantic.dev/latest/](https://docs.pydantic.dev/latest/)

安装: [https://docs.pydantic.dev/latest/install/](https://docs.pydantic.dev/latest/install/)

基本使用: [https://docs.pydantic.dev/latest/#pydantic-examples](https://docs.pydantic.dev/latest/#pydantic-examples)

# 请求数据

Request Parameters: [https://fastapi.tiangolo.com/zh/reference/parameters/](https://fastapi.tiangolo.com/zh/reference/parameters/)

路由参数

- 路径参数: [https://fastapi.tiangolo.com/zh/tutorial/path-params/](https://fastapi.tiangolo.com/zh/tutorial/path-params/)

- 路径参数和数值校验: [https://fastapi.tiangolo.com/zh/tutorial/path-params-numeric-validations/](https://fastapi.tiangolo.com/zh/tutorial/path-params-numeric-validations/)

- 查询参数: [https://fastapi.tiangolo.com/zh/tutorial/query-params/](https://fastapi.tiangolo.com/zh/tutorial/query-params/)

- 查询参数和字符串校验: [https://fastapi.tiangolo.com/zh/tutorial/query-params-str-validations/](https://fastapi.tiangolo.com/zh/tutorial/query-params-str-validations/)

Body 参数

- 请求体: [https://fastapi.tiangolo.com/zh/tutorial/body/](https://fastapi.tiangolo.com/zh/tutorial/body/)

- 自定义验证逻辑: [https://docs.pydantic.dev/latest/concepts/validators/](https://docs.pydantic.dev/latest/concepts/validators/)

- 查询参数模型: [https://fastapi.tiangolo.com/zh/tutorial/query-param-models/](https://fastapi.tiangolo.com/zh/tutorial/query-param-models/)

- 请求体（字段）: [https://fastapi.tiangolo.com/zh/tutorial/body-fields/](https://fastapi.tiangolo.com/zh/tutorial/body-fields/)

- 请求体(多个参数): [https://fastapi.tiangolo.com/zh/tutorial/body-multiple-params/](https://fastapi.tiangolo.com/zh/tutorial/body-multiple-params/)

- 请求体(嵌套模型): [https://fastapi.tiangolo.com/zh/tutorial/body-nested-models/](https://fastapi.tiangolo.com/zh/tutorial/body-nested-models/)

Cookie 参数

- Cookie 参数: [https://fastapi.tiangolo.com/zh/tutorial/cookie-params/](https://fastapi.tiangolo.com/zh/tutorial/cookie-params/)

- Cookie 参数模型: [https://fastapi.tiangolo.com/zh/tutorial/cookie-param-models/](https://fastapi.tiangolo.com/zh/tutorial/cookie-param-models/)

- set_cookie:

  - [https://fastapi.tiangolo.com/zh/reference/response/#fastapi.Response.set_cookie](https://fastapi.tiangolo.com/zh/reference/response/#fastapi.Response.set_cookie)

  - [https://fastapi.tiangolo.com/zh/reference/responses/#fastapi.responses.JSONResponse.set_cookie](https://fastapi.tiangolo.com/zh/reference/responses/#fastapi.responses.JSONResponse.set_cookie)

Header 参数

- Header 参数: [https://fastapi.tiangolo.com/zh/tutorial/header-params/](https://fastapi.tiangolo.com/zh/tutorial/header-params/)

- Header 参数模型: [https://fastapi.tiangolo.com/zh/tutorial/header-param-models/](https://fastapi.tiangolo.com/zh/tutorial/header-param-models/)

模式的额外信息: [https://fastapi.tiangolo.com/zh/tutorial/schema-extra-example/](https://fastapi.tiangolo.com/zh/tutorial/schema-extra-example/)

# 依赖注入

函数作为依赖: [https://fastapi.tiangolo.com/zh/tutorial/dependencies/](https://fastapi.tiangolo.com/zh/tutorial/dependencies/)

类作为依赖项: [https://fastapi.tiangolo.com/zh/tutorial/dependencies/classes-as-dependencies/](https://fastapi.tiangolo.com/zh/tutorial/dependencies/classes-as-dependencies/)

子依赖项: [https://fastapi.tiangolo.com/zh/tutorial/dependencies/sub-dependencies/](https://fastapi.tiangolo.com/zh/tutorial/dependencies/sub-dependencies/)

路径操作装饰器依赖项: [https://fastapi.tiangolo.com/zh/tutorial/dependencies/dependencies-in-path-operation-decorators/](https://fastapi.tiangolo.com/zh/tutorial/dependencies/dependencies-in-path-operation-decorators/)

全局依赖项: [https://fastapi.tiangolo.com/zh/tutorial/dependencies/global-dependencies/](https://fastapi.tiangolo.com/zh/tutorial/dependencies/global-dependencies/)

使用 yield 的依赖项: [https://fastapi.tiangolo.com/zh/tutorial/dependencies/dependencies-with-yield/](https://fastapi.tiangolo.com/zh/tutorial/dependencies/dependencies-with-yield/)

模块化依赖项: 使用 APIRouter 来为路由分模块。[https://fastapi.tiangolo.com/zh/tutorial/bigger-applications/#apirouter_3](https://fastapi.tiangolo.com/zh/tutorial/bigger-applications/#apirouter_3)

# APIRouter

使用多个文件构建大型应用: [https://fastapi.tiangolo.com/zh/tutorial/bigger-applications/](https://fastapi.tiangolo.com/zh/tutorial/bigger-applications/)

# 数据库操作 ORM

SQLAlchemy: [https://www.sqlalchemy.org/](https://www.sqlalchemy.org/)

## 安装相关库

- 安装 SQLAlchemy（异步版本）: [https://docs.sqlalchemy.org/en/20/orm/extensions/asyncio.html#asyncio-install](https://docs.sqlalchemy.org/en/20/orm/extensions/asyncio.html#asyncio-install)

- 安装 asyncmy 驱动: [https://github.com/long2ice/asyncmy?tab=readme-ov-file#install](https://github.com/long2ice/asyncmy?tab=readme-ov-file#install)

- 安装 cryptography: [https://cryptography.io/en/latest/installation/](https://cryptography.io/en/latest/installation/)

## 异步连接 MySQL

- 配置连接参数: [https://docs.sqlalchemy.org/en/20/dialects/mysql.html#asyncmy](https://docs.sqlalchemy.org/en/20/dialects/mysql.html#asyncmy)

- 创建 Engine 对象: [https://docs.sqlalchemy.org/en/20/orm/extensions/asyncio.html#sqlalchemy.ext.asyncio.AsyncEngine](https://docs.sqlalchemy.org/en/20/orm/extensions/asyncio.html#sqlalchemy.ext.asyncio.AsyncEngine)

- create_async_engine 参数: [https://docs.sqlalchemy.org/en/20/core/engines.html#sqlalchemy.create_engine.params.connect_args](https://docs.sqlalchemy.org/en/20/core/engines.html#sqlalchemy.create_engine.params.connect_args)

- 创建会话工厂: [https://docs.sqlalchemy.org/en/20/orm/session_api.html](https://docs.sqlalchemy.org/en/20/orm/session_api.html)

- 创建会话工厂的参数配置: [https://docs.sqlalchemy.org/en/20/orm/session_api.html#sqlalchemy.orm.sessionmaker](https://docs.sqlalchemy.org/en/20/orm/session_api.html#sqlalchemy.orm.sessionmaker.__init__)

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

## 创建模型

定义 Base 类并创建 ORM 模型:

- [https://docs.sqlalchemy.org/en/20/orm/quickstart.html#declare-models](https://docs.sqlalchemy.org/en/20/orm/quickstart.html#declare-models)

- [https://docs.sqlalchemy.org/en/20/orm/mapping_styles.html#declarative-mapping](https://docs.sqlalchemy.org/en/20/orm/mapping_styles.html#declarative-mapping)

## 迁移模型

模型定义后，将模型表映射到数据库中

alembic: [https://alembic.sqlalchemy.org/en/latest/](https://alembic.sqlalchemy.org/en/latest/)

安装: [https://alembic.sqlalchemy.org/en/latest/front.html#installation](https://alembic.sqlalchemy.org/en/latest/front.html#installation)

创建迁移仓库（异步 MySQL 需要加上参数`--template async`）: [https://alembic.sqlalchemy.org/en/latest/tutorial.html#creating-an-environment](https://alembic.sqlalchemy.org/en/latest/tutorial.html#creating-an-environment)

修改 alembic.ini（主要是 sqlalchemy.url 参数）: [https://alembic.sqlalchemy.org/en/latest/tutorial.html#editing-the-ini-file](https://alembic.sqlalchemy.org/en/latest/tutorial.html#editing-the-ini-file)

修改 env.py: 修改 target_metadata

生成迁移脚本（添加参数 `--autogenerate`）: [https://alembic.sqlalchemy.org/en/latest/tutorial.html#create-a-migration-script](https://alembic.sqlalchemy.org/en/latest/tutorial.html#create-a-migration-script)

执行迁移脚本: [https://alembic.sqlalchemy.org/en/latest/tutorial.html#running-our-first-migration](https://alembic.sqlalchemy.org/en/latest/tutorial.html#running-our-first-migration)

版本回退: [https://alembic.sqlalchemy.org/en/latest/tutorial.html#downgrading](https://alembic.sqlalchemy.org/en/latest/tutorial.html#downgrading)

## 外键

表关系: [https://docs.sqlalchemy.org/en/20/orm/relationships.html](https://docs.sqlalchemy.org/en/20/orm/relationships.html)

一对一: [https://docs.sqlalchemy.org/en/20/orm/basic_relationships.html#one-to-one](https://docs.sqlalchemy.org/en/20/orm/basic_relationships.html#one-to-one)

一对多: [https://docs.sqlalchemy.org/en/20/orm/basic_relationships.html#one-to-many](https://docs.sqlalchemy.org/en/20/orm/basic_relationships.html#one-to-many)

多对一: [https://docs.sqlalchemy.org/en/20/orm/basic_relationships.html#many-to-one](https://docs.sqlalchemy.org/en/20/orm/basic_relationships.html#many-to-one)

多对多: [https://docs.sqlalchemy.org/en/20/orm/basic_relationships.html#many-to-many](https://docs.sqlalchemy.org/en/20/orm/basic_relationships.html#many-to-many)

## CURD

创建 Session 对象（依赖项）:

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

创建 Session 对象（异步上下文管理器）:

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

创建 Session 对象（中间件）:

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

# 中间件
