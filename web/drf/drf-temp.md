# 路由

Routers: [https://www.django-rest-framework.org/api-guide/routers/](https://www.django-rest-framework.org/api-guide/routers/)

# 请求和响应

[https://www.django-rest-framework.org/api-guide/requests/](https://www.django-rest-framework.org/api-guide/requests/)

# 认证 Authentication

Authentication: [https://www.django-rest-framework.org/api-guide/authentication/](https://www.django-rest-framework.org/api-guide/authentication/)

步骤:

1. 编写类（认证组件）:

   - 自定义授权类: [https://www.django-rest-framework.org/api-guide/authentication/#custom-authentication](https://www.django-rest-framework.org/api-guide/authentication/#custom-authentication)
   - 例子: [https://www.django-rest-framework.org/api-guide/authentication/#example](https://www.django-rest-framework.org/api-guide/authentication/#example)

2. 应用组件（两种方式）: [https://www.django-rest-framework.org/api-guide/authentication/#setting-the-authentication-scheme](https://www.django-rest-framework.org/api-guide/authentication/#setting-the-authentication-scheme)

   - 全局配置
   - 给每个视图手动添加

优先级: 先读取全局配置的认证组件，后读取局部配置的认证组件，局部的会覆盖全局的

注意: 认证组件不能写在视图文件中（会有循环引用的问题）（解决方法就是单独创建认证文件或包）

多个认证类的认证流程: [https://www.django-rest-framework.org/api-guide/authentication/#how-authentication-is-determined](https://www.django-rest-framework.org/api-guide/authentication/#how-authentication-is-determined)

多个认证类是 `or` 的关系

状态码一致问题: 在编写认证类（组件）时添加 `authenticate_header` 方法

```python
from django.contrib.auth.models import User
from rest_framework import authentication
from rest_framework import exceptions

class ExampleAuthentication(authentication.BaseAuthentication):
    def authenticate(self, request):
        pass

    def authenticate_header(self, request):
        return "API"
```

# 权限 Permissions

Permissions: [https://www.django-rest-framework.org/api-guide/permissions/](https://www.django-rest-framework.org/api-guide/permissions/)

## 权限 permissions

步骤:

1. 编写类（权限组件）:

   - 自定义权限类: [https://www.django-rest-framework.org/api-guide/permissions/#custom-permissions](https://www.django-rest-framework.org/api-guide/permissions/#custom-permissions)
   - 例子: [https://www.django-rest-framework.org/api-guide/permissions/#examples](https://www.django-rest-framework.org/api-guide/permissions/#examples)

2. 应用组件（两种方式）: [https://www.django-rest-framework.org/api-guide/permissions/#setting-the-permission-policy](https://www.django-rest-framework.org/api-guide/permissions/#setting-the-permission-policy)

   - 全局配置
   - 给每个视图手动添加

优先级: 先读取全局配置的权限组件，后读取局部配置的权限组件，局部的会覆盖全局的

多个权限类是 `and` 的关系

自定义权限错误信息（给权限类添加类属性 message）: [https://www.django-rest-framework.org/api-guide/permissions/#custom-permissions](https://www.django-rest-framework.org/api-guide/permissions/#custom-permissions)

扩展权限组件（思路: 继承，重写方法）: 如果想自定义验证权限的逻辑，在视图中重写 `check_permissions` 函数就够了

## ALC

ALC: 基于用户权限控制

## RBAC

RBAC: 基于角色的访问控制

DRF + RBAC: [https://www.bilibili.com/video/BV1JTNnetEmi?p=24](https://www.bilibili.com/video/BV1JTNnetEmi?p=24)

# 限流 Throttling

使用：

1. 编写类

   1. 编写类: [https://www.django-rest-framework.org/api-guide/throttling/#custom-throttles](https://www.django-rest-framework.org/api-guide/throttling/#custom-throttles)
   2. 编辑 django-redis 配置，settings.py
   3. 安装 django-redis
   4. 启动 redis 服务

2. 应用类（主要是局部应用）: [https://www.django-rest-framework.org/api-guide/throttling/#setting-the-throttling-policy](https://www.django-rest-framework.org/api-guide/throttling/#setting-the-throttling-policy)

# 版本 Versioning

版本: [https://www.django-rest-framework.org/api-guide/versioning/](https://www.django-rest-framework.org/api-guide/versioning/)

1.基于 GET 参数传递版本:

- [https://www.django-rest-framework.org/api-guide/versioning/#queryparameterversioning](https://www.django-rest-framework.org/api-guide/versioning/#queryparameterversioning)
- [https://www.django-rest-framework.org/api-guide/versioning/#configuring-the-versioning-scheme](https://www.django-rest-framework.org/api-guide/versioning/#configuring-the-versioning-scheme)

基于 GET 参数（反向生成 URL）: [https://www.django-rest-framework.org/api-guide/versioning/#reversing-urls-for-versioned-apis](https://www.django-rest-framework.org/api-guide/versioning/#reversing-urls-for-versioned-apis)

2.URL 路径传递版本【主流】: [https://www.django-rest-framework.org/api-guide/versioning/#urlpathversioning](https://www.django-rest-framework.org/api-guide/versioning/#urlpathversioning)

3.请求头传递版本: [https://www.django-rest-framework.org/api-guide/versioning/#acceptheaderversioning](https://www.django-rest-framework.org/api-guide/versioning/#acceptheaderversioning)

# 解析器 Parsers

解析器: [https://www.django-rest-framework.org/api-guide/parsers/](https://www.django-rest-framework.org/api-guide/parsers/)

设置解析器: [https://www.django-rest-framework.org/api-guide/parsers/#setting-the-parsers](https://www.django-rest-framework.org/api-guide/parsers/#setting-the-parsers)

文件解析器: [https://www.django-rest-framework.org/api-guide/parsers/#fileuploadparser](https://www.django-rest-framework.org/api-guide/parsers/#fileuploadparser)

MultiPartParser: [https://www.django-rest-framework.org/api-guide/parsers/#multipartparser](https://www.django-rest-framework.org/api-guide/parsers/#multipartparser)

# 过滤

# 分页

# 异常

# JWT

# 接口文档

# 部署

# 思考

如何扩展各种组件: 思路就是使用类继承并重写类方法

DRF 中的 request 对象不好用，如何换成另一个 request 对象？[https://www.bilibili.com/video/BV1JTNnetEmi?p=25](https://www.bilibili.com/video/BV1JTNnetEmi?p=24)

DRF 中的认证，权限组件与 Django 中的中间件有什么关系，先后顺序是怎样的？[https://www.bilibili.com/video/BV1JTNnetEmi?p=25](https://www.bilibili.com/video/BV1JTNnetEmi?p=24)
