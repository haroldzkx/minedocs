# 路由

模块化路由: [https://docs.djangoproject.com/zh-hans/5.1/intro/tutorial01/#write-your-first-view](https://docs.djangoproject.com/zh-hans/5.1/intro/tutorial01/#write-your-first-view)

- app 中的视图与 url 进行映射，每个 app 配置自己的 url，然后在项目中全局导入 url
- 在 app 里的 urls.py 中，记得使用 url 的命名空间
- url 命名空间: [https://docs.djangoproject.com/zh-hans/5.1/topics/http/urls/#url-namespaces](https://docs.djangoproject.com/zh-hans/5.1/topics/http/urls/#url-namespaces)

url 传参数：

- 通过查询字符串传参数（https://www.xxx.com/test?name=xxx），使用 `request.GET.get('name')`来取参数
- 在 PATH 中携带参数（https://www.xxx.com/test/12）[https://docs.djangoproject.com/zh-hans/5.1/intro/tutorial03/#writing-more-views](https://docs.djangoproject.com/zh-hans/5.1/intro/tutorial03/#writing-more-views)
- [https://docs.djangoproject.com/zh-hans/5.1/topics/http/urls/#how-django-processes-a-request](https://docs.djangoproject.com/zh-hans/5.1/topics/http/urls/#how-django-processes-a-request)

url 中的 path 函数: [https://docs.djangoproject.com/zh-hans/5.1/ref/urls/#path](https://docs.djangoproject.com/zh-hans/5.1/ref/urls/#path)

路由反转（在 name 属性里还可以加上命名空间 `namespace:url`）: [https://docs.djangoproject.com/zh-hans/5.1/topics/http/urls/#reverse-resolution-of-urls](https://docs.djangoproject.com/zh-hans/5.1/topics/http/urls/#reverse-resolution-of-urls)

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

数据库驱动 mysqlclient（推荐，同步）: [https://docs.djangoproject.com/zh-hans/5.1/ref/databases/#mysql-db-api-drivers](https://docs.djangoproject.com/zh-hans/5.1/ref/databases/#mysql-db-api-drivers)

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

- 返回 QuerySet 的方法（这些方法不运行数据库查询，因此它们 可以安全地在异步代码中运行，而且没有单独的异步版本）：使用 `async for` [https://docs.djangoproject.com/zh-hans/5.1/ref/models/querysets/#methods-that-return-new-querysets](https://docs.djangoproject.com/zh-hans/5.1/ref/models/querysets/#methods-that-return-new-querysets)
- 不返回 QuerySet 的方法（每次被调用时都会查询数据库，因此，每个方法都有一个带有 a 前缀的相应异步版本）：[https://docs.djangoproject.com/zh-hans/5.1/ref/models/querysets/#methods-that-do-not-return-querysets](https://docs.djangoproject.com/zh-hans/5.1/ref/models/querysets/#methods-that-do-not-return-querysets)

事务目前不支持异步模式，如果想实现事务的异步模式，需要借助 `sync_to_async` 方法实现。

异步适配函数 `sync_to_async`, `async_to_sync`: [https://docs.djangoproject.com/zh-hans/5.1/topics/async/#async-adapter-functions](https://docs.djangoproject.com/zh-hans/5.1/topics/async/#async-adapter-functions)

## 多数据库路由

应用场景：

1. 可以整合多个业务的数据库
2. 数据库读写分离

[https://docs.djangoproject.com/zh-hans/5.2/topics/db/multi-db/](https://docs.djangoproject.com/zh-hans/5.2/topics/db/multi-db/)

# 信号 Signals

什么是 signals?

- django 框架内置的信号发送器，这个信号发送器在框架里面
- 有动作发生的时候，帮助解耦的应用接收到消息通知
- 当动作发生时，允许特定的信号发送者发送消息到一系列的消息接收者
- signals 是同步调用

信号的应用场景

- 系统解耦，代码复用：实现统一处理逻辑的框架中间件；（可维护性提升）
- 记录操作日志，增加/清除缓存，数据变化接入审批流程；评论通知；
- 关联业务变化通知
- 例：通讯录变化的异步事件处理，比如员工入职时发送消息通知团队新人入职，员工离职时异步清理员工的权限等等；

[https://docs.djangoproject.com/zh-hans/5.2/topics/signals/](https://docs.djangoproject.com/zh-hans/5.2/topics/signals/)

Django 内置信号: [https://docs.djangoproject.com/zh-hans/5.2/ref/signals/](https://docs.djangoproject.com/zh-hans/5.2/ref/signals/)

# 中间件

异步函数中间件的三个装饰器:

- sync_only_middleware(): 只执行同步部分
- async_only_middleware(): 只执行异步部分
- sync_and_async_middleware(): 具体执行异步还是同步，依赖于部署的 web 服务器是什么，如果是异步的 asgi 服务器，就只会执行异步的部分，否则就只会执行同步的部分

异步函数中间件: [https://docs.djangoproject.com/zh-hans/5.1/topics/http/middleware/#asynchronous-support](https://docs.djangoproject.com/zh-hans/5.1/topics/http/middleware/#asynchronous-support)

异步类中间件: 在类中加入 sync_capable，async_capable 属性 [https://docs.djangoproject.com/zh-hans/5.1/topics/http/middleware/#asynchronous-support](https://docs.djangoproject.com/zh-hans/5.1/topics/http/middleware/#asynchronous-support)

# ASGI 服务器

wsgi 协议服务器：uwsgi【同步，通过多进程+多线程的方式来实现并发】

asgi 协议服务器：【异步，通过多进程+主线程(不存在多线程)+协程的方式来实现并发】

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

# django-admin 和 manage.py

- django-admin 和 manage.py: [https://docs.djangoproject.com/zh-hans/5.1/ref/django-admin/](https://docs.djangoproject.com/zh-hans/5.1/ref/django-admin/)
- 编写自定义 django-admin 命令: [https://docs.djangoproject.com/zh-hans/5.1/howto/custom-management-commands/](https://docs.djangoproject.com/zh-hans/5.1/howto/custom-management-commands/)

# Django Admin

集成 registration: [django-registration-redux](https://django-registration-redux-referrals.readthedocs.io/en/stable/index.html#)

定制页面样式: [django-bootstrap4]()

## 遗留系统集成

遗留系统集成：为已有数据库生成管理后台

问题：已经有内部系统在运行了，缺少管理功能，希望能有一个权限后台。比如人事系统，crm,erp 的产品，缺少部分数据的维护功能

诉求

1. 3 分钟生成一个管理后台；
2. 可以灵活定制页面
3. 不影响正在运行的业务系统

解决方案：

第 1 步：创建新的空项目，创建 APP

第 2 步：编辑 settings.py 中的数据库配置，将生产环境中的数据库配置写入

第 3 步：生成 Model

```bash
python manage.py inspectdb > APP/models.py
```

第 4 步：修改 models.py 里的模型，再调整模型的细节内容

```python
class XXX(models.Model):
    ...
    class Meta:
        # 这个属性改为False表示这个对象实体不再跟数据库里的结构保持一致
        # 因为模型是从数据库生成的，如果再反向同步到数据库
        # 会把生产环境的数据库改掉，影响生产环境的系统
        managed = False
        db_table = "xxx"

```

第 5 步：开发自己想要的功能

# GitHub Gist

批量导入 CSV 数据: [https://gist.github.com/haroldzkx/c47b029214190da9fa2d50c5a2fa0949](https://gist.github.com/haroldzkx/c47b029214190da9fa2d50c5a2fa0949)

# 缓存

django-redis: [https://django-redis-chs.readthedocs.io/zh-cn/latest/](https://django-redis-chs.readthedocs.io/zh-cn/latest/)

Django 缓存框架: [https://docs.djangoproject.com/zh-hans/5.1/topics/cache/](https://docs.djangoproject.com/zh-hans/5.1/topics/cache/)

# 文件存储

文件和图片的存储：

- 使用服务器本地磁盘
- 自建分布式文件服务器
- 阿里云 OSS

# 插件

Django debug toolbar: 提供一个可以查看 debug 信息的面板（包括 SQL 执行时间，页面耗时）

django-sik: 性能瓶颈分析

Simple UI: 基于 Element UI 和 VUE 的 Django Admin 主题

Havstack Django: 模块化搜索方案

Dianqo notifications: 发送消息通知，你有 xx 条未处理简历

Django markdown editor: markdown 编辑器

djanqo-crispy-forms: Crispy 表单，以一种非常优雅，干净的方式来创建美观的表单

diango-simple-captcha: Django 表单验证码

# 测试

[https://docs.djangoproject.com/zh-hans/5.2/topics/testing/](https://docs.djangoproject.com/zh-hans/5.2/topics/testing/)

# 多语言支持 i18n

1. 代码中使用 gettext, gettext_lazy 获取多语言资源对应的文本内容

- gettext: [https://docs.djangoproject.com/zh-hans/5.2/topics/i18n/translation/#standard-translation](https://docs.djangoproject.com/zh-hans/5.2/topics/i18n/translation/#standard-translation)
- gettext_lazy: [https://docs.djangoproject.com/zh-hans/5.2/topics/i18n/translation/#lazy-translation](https://docs.djangoproject.com/zh-hans/5.2/topics/i18n/translation/#lazy-translation)

2. 生成文本格式的多语言资源文件 xxx.po 文件

- [https://docs.djangoproject.com/zh-hans/5.2/topics/i18n/translation/#localization-how-to-create-language-files](https://docs.djangoproject.com/zh-hans/5.2/topics/i18n/translation/#localization-how-to-create-language-files)

3. 翻译多语言内容：翻译 po 文件中的内容到不同语言
4. 生成二进制多语言资源文件：编译生成可以高效使用的二进制文件（.mo）

- 编译消息文件: [https://docs.djangoproject.com/zh-hans/5.2/topics/i18n/translation/#compiling-message-files](https://docs.djangoproject.com/zh-hans/5.2/topics/i18n/translation/#compiling-message-files)

# 目录结构

```bash
curl      # 存放测试 API 的接口
    /xxx.sh
```

```bash
# 存放项目配置文件
settings/__init__.py
        /base.py
        /local.py
        /prod.py
```

```bash
app/__init__.py
   /admin.py
   /apps.py
   /migrations/__init__.py
   /models.py
   /tasks.py  # 放置需要丢到celery中去执行的任务
   /tests.py  # 有了testcase这个包，这个文件可以删除
   /testcase/__init__.py  # 放单元测试
            /test_forms.py
            /test_views.py
   /views.py
```

```bash
project/__init__.py
       /asgi.py
       /urls.py
       /wsgi.py
       /celery.py
```

```bash
manage.py
```

# Django

<details>
<summary>创建项目</summary>

命令行创建项目: [https://docs.djangoproject.com/zh-hans/5.1/intro/tutorial01/#creating-a-project](https://docs.djangoproject.com/zh-hans/5.1/intro/tutorial01/#creating-a-project)

```bash
django-admin startproject PROJECT_NAME
# or
mkdir djangotutorial
django-admin startproject mysite djangotutorial
# 目录结构：djangotutorial/mysite/...
```

</details>

<details>
<summary>运行项目</summary>

运行 Django 项目: [https://docs.djangoproject.com/zh-hans/5.1/intro/tutorial01/#the-development-server](https://docs.djangoproject.com/zh-hans/5.1/intro/tutorial01/#the-development-server)

```bash
python XXX/manage.py runserver
python XXX/manage.py runserver 0.0.0.0:8000
python XXX/manage.py migrate
# or
cd XXX
python manage.py runserver
python manage.py runserver 0.0.0.0:8000
python manage.py migrate
```

</details>

<details>
<summary>创建应用</summary>

创建应用 app（project 与 app 的区别）: [https://docs.djangoproject.com/zh-hans/5.1/intro/tutorial01/#creating-the-polls-app](https://docs.djangoproject.com/zh-hans/5.1/intro/tutorial01/#creating-the-polls-app)

```bash
python manage.py startapp APP_NAME
```

</details>

<details>
<summary>纯净版 Django</summary>

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

</details>

# Django 配置

## 生产环境与开发环境配置分离

<details>
<summary>第 1 步：创建项目配置的 settings 包</summary>

```bash
mkdir settings
touch settings/__init__.py
```

</details>

<details>
<summary>第 2 步：重命名 settings.py 文件</summary>

```bash
mv xxx/settings.py settings/base.py
```

</details>

<details>
<summary>第 3 步：修改 manage.py</summary>

```python
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'xxx.settings')
# 改为
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'settings.base')
```

</details>

<details>
<summary>第 4 步：创建开发环境配置文件</summary>

```bash
touch settings/local.py
```

```python
from .base import *

ALLOWED_HOSTS = ["127.0.0.1"]

SECRET_KEY = 'django-insecure-73@ne%ad1#c$821jq-9=073e!w6q7gz+m7lskhe!++r2wje+jr'

DEBUG = True

INSTALLED_APPS += [
    # other app for local development
    # 'xxx',
]
```

</details>

<details>
<summary>第 5 步：创建生产环境配置文件</summary>

```bash
touch settings/prod.py
```

```python
from .base import *

ALLOWED_HOSTS = ["127.0.0.1"]

DEBUG = False

INSTALLED_APPS += [
    # 'xxx',
]
```

</details>

<details>
<summary>第 6 步：在 .gitignore 文件中添加 settings/local.py</summary>

</details>

<details>
<summary>第 7 步：根据不同的配置文件启动项目</summary>

```bash
python manage.py runserver 0.0.0.0:8000 --settings=settings.local
python manage.py runserver 0.0.0.0:8000 --settings=settings.prod
```

</details>

# 数据库配置

数据库配置: [https://docs.djangoproject.com/zh-hans/5.1/ref/settings/#databases](https://docs.djangoproject.com/zh-hans/5.1/ref/settings/#databases)

MySQL 配置: [https://docs.djangoproject.com/zh-hans/5.1/ref/databases/#mysql-notes](https://docs.djangoproject.com/zh-hans/5.1/ref/databases/#mysql-notes)

连接 MySQL 数据库: [https://docs.djangoproject.com/zh-hans/5.1/ref/databases/#connecting-to-the-database](https://docs.djangoproject.com/zh-hans/5.1/ref/databases/#connecting-to-the-database)


# Django 发布到生产环境的步骤

1. 配置生产环境配置（settings）：DEBUG & Secret 相关信息

   密钥的存储和管理：

   1）从环境变量读取配置，或从配置文件中读取；

   2）从 KMS 系统中读取配置的密钥

2. 选择 Django App 的托管环境（IaaS/PaaS，比如阿里云/AWS/Azure/GAE/Heroku 等等）
3. 部署前的安全检查 `python manage.py check --deploy`
4. 选择静态资源文件的托管环境（包括 JS/CSS/图片/文件等）& 部署静态资源

   静态资源文件的托管环境

   - 静态内容 web 服务器：Apache / Nginx
   - CDN 服务器

   collectstatic 工具：用来收集静态资源文件，settings 中的相关设置：

   - STATIC_URL: 能够访问到静态文件的 URL 路径。
   - STATIC_ROOT: collectstatic 工具用来保存收集到的项目引用到的任何静态文件的路径
   - STATICFILES_DIRS: 这列出了 django 的 collectstatic 工具应该搜索静态文件的其他目录

   ```bash
   python manage.py collectstatic --settings=settings.local
   ```

   收集完成后，可以将这些静态文件，上传到托管文件的服务器 / CDN

5. 部署 Django 应用容器 & Web 服务器：托管动态资源

   同步应用：uWSGI, gunicorn

   异步应用：Daphne, Hypercorn, Uvicorn
