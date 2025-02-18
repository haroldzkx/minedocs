# 项目结构

```bash
alembic/	# 使用alembic命令生成的

models/__init__.py

protos/__init__.py

services/__init__.py

settings/__init__.py

utils/__init__.py

alembic.ini	# 使用alembic命令生成的
main.py
```

## models

```python
# models/__init__.py
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

```python
# models/user.py
from . import Base
from sqlalchemy import Column, Integer, String, Boolean, DateTime
import random
import string

def generate_username():
    code = "".join(random.sample(string.digits, 6))
    return "用户" + code

class User(Base):
    __tablename__ = 'user'
    id = Column(Integer, primary_key=True)
    mobile = Column(String(20), unique=True, index=True)
    username = Column(String(20), default=generate_username)
    password = Column(String(300), nullable=True)
    avatar = Column(String(200), nullable=True)
    is_active = Column(Boolean, default=True)
    is_staff = Column(Boolean, default=False)
    last_login = Column(DateTime, nullable=True)

```

## settings

```python
# settings/__init__.py
MYSQL_HOST = ''
MYSQL_PORT = ''
MYSQL_USER = ''
MYSQL_PASSWORD = ""
MYSQL_DB = ''

DB_URI = f"mysql+asyncmy://{MYSQL_USER}:{MYSQL_PASSWORD}@{MYSQL_HOST}:{MYSQL_PORT}/{MYSQL_DB}?charset=utf8mb4"
```

# 模型迁移 alembic

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

# 定义 gRPC 服务接口

# 定义 RESTFul API 接口

# 服务注册与发现
