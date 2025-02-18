# 开发环境（Docker）

准备如下的目录和文件

```bash
devpack/  # 离线安装的库 *.whl
bash.sh   # 常用命令
docker-compose.yml
```

```yaml
### docker-compose.yml
services:
  djangodev:
    image: registry.cn-shenzhen.aliyuncs.com/haroldfinch/python:3.10.16-slim-bookworm-arm
    container_name: djangodev
    volumes:
      - ./:/home/work
    ports:
      - 8000:8000
    command: ["tail", "-f", "/dev/null"]
    restart: always
    # 这里不完整，还应该有mysql数据库的配置
    # **下面的配置还未验证**
    depends_on:
      - db_mysql
    environment:
      - DATABASE_URL=mysql://dev_user:dev_pass@db_mysql:3306/dev_db
    networks:
      - django-PROJECT_NAME-network

  db_mysql:
    image: registry.cn-shenzhen.aliyuncs.com/haroldfinch/mysql:8.0.40
    container_name: djangodev-mysql
    environment:
      MYSQL_ROOT_PASSWORD: xxx
      MYSQL_DATABASE: xxx
      MYSQL_USER: xxx
      MYSQL_PASSWORD: xxx
    ports:
      - 3306:3306
    volumes:
      - ./mysql/log:/var/log/mysql
      - ./mysql/data:/var/lib/mysql
      - ./mysql/conf.d:/etc/mysql/conf.d
    networks:
      - django-PROJECT_NAME-network

networks:
  django-PROJECT_NAME-network:
    driver: bridge
```

```shell
### bash.sh
# docker
docker compose up -d
docker exec -it djangodev /bin/bash
docker rm -f djangodev

# dependencies
pip install devpack/*.whl
pip install devpack/*.tar.gz
pip uninstall asgiref django sqlparse typing_extensions -y

# django config
django-admin startproject XXX
python XXX/manage.py runserver 0.0.0.0:8000
python XXX/manage.py migrate
# or
cd XXX
python manage.py runserver 0.0.0.0:8000
python manage.py migrate
```

启动步骤：

```bash
# 1. 启动python容器
docker compose up -d

# 2. 进入容器的终端 或者 VSCode中attach进容器

# 3. 安装库（以下3种方式任选其一）
pip install django xxx ...
pip install -r requirements.txt
pip install devpack/*.whl

# 4. 创建django项目
django-admin startproject

# 5. 启动django项目
python manage.py runserver 0.0.0.0:8000
```

# 基础配置

命令行创建项目: [https://docs.djangoproject.com/zh-hans/5.1/intro/tutorial01/#creating-a-project](https://docs.djangoproject.com/zh-hans/5.1/intro/tutorial01/#creating-a-project)

运行 Django 项目: [https://docs.djangoproject.com/zh-hans/5.1/intro/tutorial01/#the-development-server](https://docs.djangoproject.com/zh-hans/5.1/intro/tutorial01/#the-development-server)

创建应用 app（project 与 app 的区别）: [https://docs.djangoproject.com/zh-hans/5.1/intro/tutorial01/#creating-the-polls-app](https://docs.djangoproject.com/zh-hans/5.1/intro/tutorial01/#creating-the-polls-app)

纯净版 Django:

```python
# settings.py
......
# Application definition
INSTALLED_APPS = [
    # 'django.contrib.admin',
    # 'django.contrib.auth',
    # 'django.contrib.contenttypes',
    # 'django.contrib.sessions',
    # 'django.contrib.messages',
    'django.contrib.staticfiles',
]
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    # 'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    # 'django.contrib.auth.middleware.AuthenticationMiddleware',
    # 'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]
......
TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                # 'django.contrib.auth.context_processors.auth',
                # 'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]
......
```

# 路由

模块化路由: [https://docs.djangoproject.com/zh-hans/5.1/intro/tutorial01/#write-your-first-view](https://docs.djangoproject.com/zh-hans/5.1/intro/tutorial01/#write-your-first-view)

- app 中的视图与 url 进行映射，每个 app 配置自己的 url，然后在项目中全局导入 url

- 在 app 里的 urls.py 中，记得使用 url 的命名空间

- url 命名空间: [https://docs.djangoproject.com/zh-hans/5.1/topics/http/urls/#url-namespaces](https://docs.djangoproject.com/zh-hans/5.1/topics/http/urls/#url-namespaces)

url 传参数：

- 通过查询字符串传参数（https://www.xxx.com/test?name=xxx），使用`request.GET.get('name')`来取参数

- 在 PATH 中携带参数（https://www.xxx.com/test/12）[https://docs.djangoproject.com/zh-hans/5.1/intro/tutorial03/#writing-more-views](https://docs.djangoproject.com/zh-hans/5.1/intro/tutorial03/#writing-more-views)

- [https://docs.djangoproject.com/zh-hans/5.1/topics/http/urls/#how-django-processes-a-request](https://docs.djangoproject.com/zh-hans/5.1/topics/http/urls/#how-django-processes-a-request)

url 中的 path 函数: [https://docs.djangoproject.com/zh-hans/5.1/ref/urls/#path](https://docs.djangoproject.com/zh-hans/5.1/ref/urls/#path)

路由反转（在 name 属性里还可以加上命名空间 `namespace:url`）: [https://docs.djangoproject.com/zh-hans/5.1/topics/http/urls/#reverse-resolution-of-urls](https://docs.djangoproject.com/zh-hans/5.1/topics/http/urls/#reverse-resolution-of-urls)

# 配置

数据库配置: [https://docs.djangoproject.com/zh-hans/5.1/ref/settings/#databases](https://docs.djangoproject.com/zh-hans/5.1/ref/settings/#databases)

MySQL 配置: [https://docs.djangoproject.com/zh-hans/5.1/ref/databases/#mysql-notes](https://docs.djangoproject.com/zh-hans/5.1/ref/databases/#mysql-notes)

连接 MySQL 数据库: [https://docs.djangoproject.com/zh-hans/5.1/ref/databases/#connecting-to-the-database](https://docs.djangoproject.com/zh-hans/5.1/ref/databases/#connecting-to-the-database)

# 视图层 View

函数视图(FBV): [https://docs.djangoproject.com/zh-hans/5.1/#the-view-layer](https://docs.djangoproject.com/zh-hans/5.1/#the-view-layer)

类视图(CBV): [https://docs.djangoproject.com/zh-hans/5.1/topics/class-based-views/](https://docs.djangoproject.com/zh-hans/5.1/topics/class-based-views/)

异步视图: [https://docs.djangoproject.com/zh-hans/5.1/topics/async/](https://docs.djangoproject.com/zh-hans/5.1/topics/async/)

- 异步函数视图: 定义函数时，加上 async

- 异步类视图: 定义方法时，加上 async

# 模型层 Model

模型和数据库: [https://docs.djangoproject.com/zh-hans/5.1/topics/db/](https://docs.djangoproject.com/zh-hans/5.1/topics/db/)

两种方式操作数据库:

- 原生 SQL 语句:

  - [https://docs.djangoproject.com/zh-hans/5.1/topics/db/sql/#executing-custom-sql-directly](https://docs.djangoproject.com/zh-hans/5.1/topics/db/sql/#executing-custom-sql-directly)
  - [https://docs.djangoproject.com/zh-hans/5.1/topics/db/sql/](https://docs.djangoproject.com/zh-hans/5.1/topics/db/sql/)
  - Python DB API: [https://peps.python.org/pep-0249/](https://peps.python.org/pep-0249/)

- ORM 模型（推荐）

## ORM 模型

[https://docs.djangoproject.com/zh-hans/5.1/topics/db/models/](https://docs.djangoproject.com/zh-hans/5.1/topics/db/models/)

在 `models.py` 中定义 ORM 模型: [https://docs.djangoproject.com/zh-hans/5.1/topics/db/models/#quick-example](https://docs.djangoproject.com/zh-hans/5.1/topics/db/models/#quick-example)

映射模型到数据库中: [https://docs.djangoproject.com/zh-hans/5.1/topics/db/models/#using-models](https://docs.djangoproject.com/zh-hans/5.1/topics/db/models/#using-models)

Meta 选项（自定义一些属性，例如数据库表名、排序选项等属性）:

- [https://docs.djangoproject.com/zh-hans/5.1/topics/db/models/#meta-options](https://docs.djangoproject.com/zh-hans/5.1/topics/db/models/#meta-options)

- [https://docs.djangoproject.com/zh-hans/5.1/ref/models/options/](https://docs.djangoproject.com/zh-hans/5.1/ref/models/options/)

## 增删改查 CURD

插入新数据:

- [https://docs.djangoproject.com/zh-hans/5.1/ref/models/instances/#saving-objects](https://docs.djangoproject.com/zh-hans/5.1/ref/models/instances/#saving-objects)

- [https://docs.djangoproject.com/zh-hans/5.1/topics/db/queries/#creating-objects](https://docs.djangoproject.com/zh-hans/5.1/topics/db/queries/#creating-objects)

修改数据: [https://docs.djangoproject.com/zh-hans/5.1/topics/db/queries/#saving-changes-to-objects](https://docs.djangoproject.com/zh-hans/5.1/topics/db/queries/#saving-changes-to-objects)

删除数据: [https://docs.djangoproject.com/zh-hans/5.1/topics/db/queries/#deleting-objects](https://docs.djangoproject.com/zh-hans/5.1/topics/db/queries/#deleting-objects)

查找数据:

- 查询到所有数据: [https://docs.djangoproject.com/zh-hans/5.1/topics/db/queries/#retrieving-all-objects](https://docs.djangoproject.com/zh-hans/5.1/topics/db/queries/#retrieving-all-objects)

- 根据条件查找数据: [https://docs.djangoproject.com/zh-hans/5.1/topics/db/queries/#retrieving-specific-objects-with-filters](https://docs.djangoproject.com/zh-hans/5.1/topics/db/queries/#retrieving-specific-objects-with-filters)

- 查询获取单个对象: [https://docs.djangoproject.com/zh-hans/5.1/topics/db/queries/#retrieving-a-single-object-with-get](https://docs.djangoproject.com/zh-hans/5.1/topics/db/queries/#retrieving-a-single-object-with-get)

- 查询到的数据进行数据排序: [https://docs.djangoproject.com/zh-hans/5.1/ref/models/querysets/#order-by](https://docs.djangoproject.com/zh-hans/5.1/ref/models/querysets/#order-by)

- 字段查询（根据具体的字段和条件进行查询）:

  - [https://docs.djangoproject.com/zh-hans/5.1/ref/models/querysets/#field-lookups](https://docs.djangoproject.com/zh-hans/5.1/ref/models/querysets/#field-lookups)

  - [https://docs.djangoproject.com/zh-hans/5.1/topics/db/queries/#field-lookups](https://docs.djangoproject.com/zh-hans/5.1/topics/db/queries/#field-lookups)

  - 跨关系查询: [https://docs.djangoproject.com/zh-hans/5.1/topics/db/queries/#lookups-that-span-relationships](https://docs.djangoproject.com/zh-hans/5.1/topics/db/queries/#lookups-that-span-relationships)

聚合函数:

- [https://docs.djangoproject.com/zh-hans/5.1/topics/db/aggregation/](https://docs.djangoproject.com/zh-hans/5.1/topics/db/aggregation/)

- [https://docs.djangoproject.com/zh-hans/5.1/ref/models/querysets/#aggregation-functions](https://docs.djangoproject.com/zh-hans/5.1/ref/models/querysets/#aggregation-functions)

- annotate() 与 aggregate()的区别

F 表达式: [https://docs.djangoproject.com/zh-hans/5.1/ref/models/expressions/#f-expressions](https://docs.djangoproject.com/zh-hans/5.1/ref/models/expressions/#f-expressions)

Q 表达式:

- [https://docs.djangoproject.com/zh-hans/5.1/ref/models/querysets/#q-objects](https://docs.djangoproject.com/zh-hans/5.1/ref/models/querysets/#q-objects)

- [https://docs.djangoproject.com/zh-hans/5.1/ref/models/querysets/#operators-that-return-new-querysets](https://docs.djangoproject.com/zh-hans/5.1/ref/models/querysets/#operators-that-return-new-querysets)

## 模型常用 Field 和参数

[https://docs.djangoproject.com/zh-hans/5.1/ref/models/fields/](https://docs.djangoproject.com/zh-hans/5.1/ref/models/fields/)

模型字段类型（模型常见的 Field）:

- [https://docs.djangoproject.com/zh-hans/5.1/ref/models/fields/#field-types](https://docs.djangoproject.com/zh-hans/5.1/ref/models/fields/#field-types)

- [https://docs.djangoproject.com/zh-hans/5.1/topics/db/models/#field-types](https://docs.djangoproject.com/zh-hans/5.1/topics/db/models/#field-types)

Field 的常见参数:

- [https://docs.djangoproject.com/zh-hans/5.1/topics/db/models/#field-options](https://docs.djangoproject.com/zh-hans/5.1/topics/db/models/#field-options)

- [https://docs.djangoproject.com/zh-hans/5.1/ref/models/fields/#common-model-field-options](https://docs.djangoproject.com/zh-hans/5.1/ref/models/fields/#common-model-field-options)

## 外键和表关系

一对一

- [https://docs.djangoproject.com/zh-hans/5.1/topics/db/models/#one-to-one-relationships](https://docs.djangoproject.com/zh-hans/5.1/topics/db/models/#one-to-one-relationships)

- [https://docs.djangoproject.com/zh-hans/5.1/topics/db/examples/one_to_one/](https://docs.djangoproject.com/zh-hans/5.1/topics/db/examples/one_to_one/)

多对一（一对多）关联：外键

- [https://docs.djangoproject.com/zh-hans/5.1/topics/db/models/#many-to-one-relationships](https://docs.djangoproject.com/zh-hans/5.1/topics/db/models/#many-to-one-relationships)

- [https://docs.djangoproject.com/zh-hans/5.1/ref/models/fields/#foreignkey](https://docs.djangoproject.com/zh-hans/5.1/ref/models/fields/#foreignkey)

- [https://docs.djangoproject.com/zh-hans/5.1/topics/db/examples/many_to_one/](https://docs.djangoproject.com/zh-hans/5.1/topics/db/examples/many_to_one/)

多对多

- [https://docs.djangoproject.com/zh-hans/5.1/topics/db/models/#many-to-many-relationships](https://docs.djangoproject.com/zh-hans/5.1/topics/db/models/#many-to-many-relationships)

- [https://docs.djangoproject.com/zh-hans/5.1/topics/db/examples/many_to_many/](https://docs.djangoproject.com/zh-hans/5.1/topics/db/examples/many_to_many/)

## 异步 ORM

[https://docs.djangoproject.com/zh-hans/5.1/topics/async/#queries-the-orm](https://docs.djangoproject.com/zh-hans/5.1/topics/async/#queries-the-orm)

[https://docs.djangoproject.com/zh-hans/5.1/topics/db/queries/#asynchronous-queries](https://docs.djangoproject.com/zh-hans/5.1/topics/db/queries/#asynchronous-queries)

两种操作：

- 返回 QuerySet 的方法（这些方法不运行数据库查询，因此它们 可以安全地在异步代码中运行，而且没有单独的异步版本）：使用`async for` [https://docs.djangoproject.com/zh-hans/5.1/ref/models/querysets/#methods-that-return-new-querysets](https://docs.djangoproject.com/zh-hans/5.1/ref/models/querysets/#methods-that-return-new-querysets)

- 不返回 QuerySet 的方法（每次被调用时都会查询数据库，因此，每个方法都有一个带有 a 前缀的相应异步版本）：[https://docs.djangoproject.com/zh-hans/5.1/ref/models/querysets/#methods-that-do-not-return-querysets](https://docs.djangoproject.com/zh-hans/5.1/ref/models/querysets/#methods-that-do-not-return-querysets)

事务目前不支持异步模式，如果想实现事务的异步模式，需要借助 `sync_to_async` 方法实现。

异步适配函数`sync_to_async`, `async_to_sync`: [https://docs.djangoproject.com/zh-hans/5.1/topics/async/#async-adapter-functions](https://docs.djangoproject.com/zh-hans/5.1/topics/async/#async-adapter-functions)

# 中间件

异步函数中间件的三个装饰器:

- sync_only_middleware(): 只执行同步部分
- async_only_middleware(): 只执行异步部分
- sync_and_async_middleware(): 具体执行异步还是同步，依赖于部署的 web 服务器是什么，如果是异步的 asgi 服务器，就只会执行异步的部分，否则就只会执行同步的部分

异步函数中间件: [https://docs.djangoproject.com/zh-hans/5.1/topics/http/middleware/#asynchronous-support](https://docs.djangoproject.com/zh-hans/5.1/topics/http/middleware/#asynchronous-support)

异步类中间件: 在类中加入 sync_capable，async_capable 属性 [https://docs.djangoproject.com/zh-hans/5.1/topics/http/middleware/#asynchronous-support](https://docs.djangoproject.com/zh-hans/5.1/topics/http/middleware/#asynchronous-support)

# ASGI 服务器

wsgi 协议服务器：uwsgi

asgi 协议服务器：

- Daphne（Django 官方，开发环境使用）[https://docs.djangoproject.com/zh-hans/5.1/howto/deployment/asgi/daphne/](https://docs.djangoproject.com/zh-hans/5.1/howto/deployment/asgi/daphne/)
- Uvicorn（基于 uvloop，生产环境使用）[https://docs.djangoproject.com/zh-hans/5.1/howto/deployment/asgi/uvicorn/](https://docs.djangoproject.com/zh-hans/5.1/howto/deployment/asgi/uvicorn/)
- Hypercorn [https://docs.djangoproject.com/zh-hans/5.1/howto/deployment/asgi/hypercorn/](https://docs.djangoproject.com/zh-hans/5.1/howto/deployment/asgi/hypercorn/)

集成 Daphne: [https://docs.djangoproject.com/zh-hans/5.1/howto/deployment/asgi/daphne/](https://docs.djangoproject.com/zh-hans/5.1/howto/deployment/asgi/daphne/)

# 异步装饰器

[https://docs.djangoproject.com/zh-hans/5.1/topics/async/#decorators](https://docs.djangoproject.com/zh-hans/5.1/topics/async/#decorators)

# 安全防范

CSRF:

- [https://docs.djangoproject.com/zh-hans/5.1/topics/security/#cross-site-request-forgery-csrf-protection](https://docs.djangoproject.com/zh-hans/5.1/topics/security/#cross-site-request-forgery-csrf-protection)

- [https://docs.djangoproject.com/zh-hans/5.1/howto/csrf/](https://docs.djangoproject.com/zh-hans/5.1/howto/csrf/)

SQL 注入:

- [https://docs.djangoproject.com/zh-hans/5.1/topics/security/#sql-injection-protection](https://docs.djangoproject.com/zh-hans/5.1/topics/security/#sql-injection-protection)
