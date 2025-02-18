# 安装与注册

安装: [https://www.django-rest-framework.org/tutorial/quickstart/#project-setup](https://www.django-rest-framework.org/tutorial/quickstart/#project-setup)

注册 drf（drf 本质上是一个 django app，需要注册）: [https://www.django-rest-framework.org/tutorial/quickstart/#settings](https://www.django-rest-framework.org/tutorial/quickstart/#settings)

# 配置

settings.py: [https://www.django-rest-framework.org/api-guide/settings/](https://www.django-rest-framework.org/api-guide/settings/)

## 纯净版 DRF

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

# 视图

函数视图(FBV): [https://www.django-rest-framework.org/api-guide/views/#function-based-views](https://www.django-rest-framework.org/api-guide/views/#function-based-views)

类视图(CBV, 以这个为主): [https://www.django-rest-framework.org/api-guide/views/#class-based-views](https://www.django-rest-framework.org/api-guide/views/#class-based-views)

# 序列化与反序列化

# 路由

Routers: [https://www.django-rest-framework.org/api-guide/routers/](https://www.django-rest-framework.org/api-guide/routers/)

# 请求和响应

[https://www.django-rest-framework.org/api-guide/requests/](https://www.django-rest-framework.org/api-guide/requests/)

# 认证组件

Authentication: [https://www.django-rest-framework.org/api-guide/authentication/](https://www.django-rest-framework.org/api-guide/authentication/)

# 权限

## 权限 permissions

## ALC

ALC: 基于用户权限控制

## RBAC

RBAC: 基于角色的访问控制

# 限流

# 过滤

# 分页

# 异常

# JWT

# 接口文档

# 部署
