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
