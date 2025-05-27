# 【Django REST Framework】

# 安装与注册

安装: [https://www.django-rest-framework.org/tutorial/quickstart/#project-setup](https://www.django-rest-framework.org/tutorial/quickstart/#project-setup)

```bash
# Install Django and DRF
pip install djangorestframework
```

注册 drf（drf 本质上是一个 django app，需要注册）: [https://www.django-rest-framework.org/tutorial/quickstart/#settings](https://www.django-rest-framework.org/tutorial/quickstart/#settings)

```python
# settings.py
INSTALLED_APPS = [
    ...
    'rest_framework',
]
```

# 纯净版 DRF

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
    'rest_framework',
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
# DRF Configure
REST_FRAMEWORK = {
    "UNAUTHENTICATED_USER": None,
}
```

# 配置

settings.py: [https://www.django-rest-framework.org/api-guide/settings/](https://www.django-rest-framework.org/api-guide/settings/)

# 框架基础组件

Django + DRF 将后端变成一种声明式的工作流，只要按照 models -> serializers -> views -> urls 的模式去一个个 py 文件去配置，即可生成一个很全面的通用的后端。

## 序列化与反序列化

Tutorial 1: Serialization: [https://www.django-rest-framework.org/tutorial/1-serialization/](https://www.django-rest-framework.org/tutorial/1-serialization/)

Serializers: [https://www.django-rest-framework.org/api-guide/serializers/#serializers](https://www.django-rest-framework.org/api-guide/serializers/#serializers)

ModelSerializers: [https://www.django-rest-framework.org/api-guide/serializers/#modelserializer](https://www.django-rest-framework.org/api-guide/serializers/#modelserializer)

## 视图

Views (Function Based View): Django 中的视图基类

- [https://www.django-rest-framework.org/api-guide/views/#function-based-views](https://www.django-rest-framework.org/api-guide/views/#function-based-views)

APIView (Class Based Views): 继承自 View，用于简化和处理 API 请求。

- [https://www.django-rest-framework.org/tutorial/3-class-based-views/#tutorial-3-class-based-views](https://www.django-rest-framework.org/tutorial/3-class-based-views/#tutorial-3-class-based-views)

- [https://www.django-rest-framework.org/api-guide/views/#class-based-views](https://www.django-rest-framework.org/api-guide/views/#class-based-views)

ViewSet: 基于 ModelSerializer 构建的，是 APIView 的高级封装，自动处理 CRUD 操作，专门与模型和数据库交互。

- [https://www.django-rest-framework.org/tutorial/6-viewsets-and-routers/](https://www.django-rest-framework.org/tutorial/6-viewsets-and-routers/)

- [https://www.django-rest-framework.org/api-guide/viewsets/](https://www.django-rest-framework.org/api-guide/viewsets/)

Generic Views: 基于 APIView 的预定义视图，提供了标准的 CRUD 操作，简化了代码。

- [https://www.django-rest-framework.org/tutorial/3-class-based-views/#using-generic-class-based-views](https://www.django-rest-framework.org/tutorial/3-class-based-views/#using-generic-class-based-views)

- [https://www.django-rest-framework.org/api-guide/generic-views/](https://www.django-rest-framework.org/api-guide/generic-views/)

Mixins: 一组类，提供 CRUD 操作的基础功能，可以与 APIView 或 ViewSets 结合使用，以便创建具有基本操作功能的视图。

- [https://www.django-rest-framework.org/tutorial/3-class-based-views/#using-mixins](https://www.django-rest-framework.org/tutorial/3-class-based-views/#using-mixins)

- [https://www.django-rest-framework.org/api-guide/generic-views/#mixins](https://www.django-rest-framework.org/api-guide/generic-views/#mixins)

# 其他功能

## 权限

## 认证
