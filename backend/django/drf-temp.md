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

# 异步DRF

DRF 框架目前是不支持异步的，如果想要在异步 Django 中使用 DRF，那么需要借助插件adrf

Adrf Github：[https://github.com/em1208/adrf](https://github.com/em1208/adrf)

Adrf支持异步权限验证、异步限速节流、异步视图、异步视图集，异步序列化等功能。


<details>
<summary>安装配置</summary>

使用adrf，在已经安装django和DRF的基础上，再进行安装：

```bash
pip install adrf
```

然后再项目的settings.py中添加adrf

```python
INSTALLED_APPS = [
   ...
   'adrf',
]
```

</details>

## 异步API视图

<details>
<summary>APIView（类视图）</summary>

要使用异步的API视图，集成时需要从之前rest_framework.views.APIView，修改为adrf.views.APIView，其他写法与用rest_framework类似。

```python
from adrf.views import APIView
from django.http.response import JsonResponse

class IndexView(APIView):
    async def get(self, request):
        return JsonResponse({"message": "请求正常！"})


class MessageView(APIView):
    async def post(self, request):
        title = request.data.get('title')
        content = request.data.get('content')
        print(title, content)
        return JsonResponse({"message": "您的建议已收到！"})
```

</details>

<details>
<summary>APIView（函数视图）</summary>

如果使用函数视图，可以通过adrf.decorators.api_view装饰器来实现异步视图。

```python
from adrf.decorators import api_view

@api_view(['GET'])
async def async_view(request):
   return Response({"message": "This is an async function based view."})
```

</details>

<details>
<summary>Authentication</summary>

如要实现自己的验证用户的操作，那么可以通过继承自 rest_framework.authentications.BaseAuthentication，然后将继承后的authenticate方法写成异步的即可。

```python
from rest_framework.authentication import BaseAuthentication, get_authorization_header
from django.contrib.auth import get_user_model
from rest_framework import exceptions

User = get_user_model()

class AsyncAuthentication(BaseAuthentication):
    keyword = 'JWT'

    async def authenticate(self, request):
        # Authorization: JWT xxx
        auth = get_authorization_header(request).split()
        token = auth[1].decode('utf-8')
        if token == 'zhiliao':
            user = await User.objects.afirst()
            setattr(request, 'user', user)
            return user, token
        else:
            raise exceptions.ValidationError("JWToken验证失败！")
```

然后再settings.py中全局配置AsyncAuthentication

```python
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': ['front.authentications.AsyncAuthentication']
}
```

或者在视图中通过authentication_classes属性配置

```python
class UserInfoView(APIView):
    authentication_classes = [AsyncAuthentication]
    
    async def get(self, request):
        return JsonResponse(data={
            "user": {
               "username": request.user.username,
               "email": request.user.email
            }
         })
```

</details>

<details>
<summary>Permission</summary>

如果需要对API进行自定义的权限限制，那么可以实现自己的权限类，在该类中实现异步的has_permission方法即可。

```python
import random

class AsyncPermission:
    async def has_permission(self, request, view) -> bool:
        if random.random() < 0.7:
            return False
        return True

    async def has_object_permission(self, request, view, obj):
        if obj.user == request.user or request.user.is_superuser:
            return True
        return False
```

然后再settings.py中全局配置AsyncAuthentication

```python
REST_FRAMEWORK = {
    'DEFAULT_PERMISSION_CLASSES': ['front.permissions.AsyncPermission']
}
```

或者在视图中通过permission_classes属性配置

```python
class UserInfoView(APIView):
    permission_classes = [AsyncPermission]
    
    async def get(self, request):
        return JsonResponse(data={
            "user": {
               "username": request.user.username,
               "email": request.user.email
            }
         })
```

</details>

<details>
<summary>Throttle</summary>

继承rest_framework.BaseThrottle，然后在子类中实现异步的allow_request方法，即可实现异步版的限速节流。

```python
from rest_framework.throttling import BaseThrottle
import random

class AsyncThrottle(BaseThrottle):
    async def allow_request(self, request, view):
        if random.random() < 0.7:
            return False
        return True

    def wait(self):
        return 3
```

然后再settings.py中全局配置

```python
REST_FRAMEWORK = {
    'DEFAULT_THROTTLE_CLASSES': ['front.throttles.AsyncThrottle']
}
```

或者在视图中通过throttle_classes属性配置

```python
class UserInfoView(APIView):
    throttle_classes = [AsyncThrottle]
    
    async def get(self, request):
        return JsonResponse(data={
            "user": {
               "username": request.user.username,
               "email": request.user.email
            }
         })
```

</details>

注意：在 DRF 中，已经内置了许多permission, throttle的类，这些类由于不涉及到 I/O 操作，所以可以直接使用。而authentication模块有很多都是需要查找数据库的，那么针对这些类，就不能直接使用，而应该自定义。

## 异步视图集

异步视图集中，所有方法都必须是异步的。

<details>
<summary>代码实现</summary>

```python
from django.contrib.auth import get_user_model
from rest_framework.response import Response

from adrf.viewsets import ViewSet

User = get_user_model()

class AsyncViewSet(ViewSet):
   async def list(self, request):
      return Response(
         {"message": "This is the async list method of the viewset."}
      )
   
   async def retrieve(self, request, pk):
      user = await User.object.filter(pk=pk).afirst()
      return Response({"user_pk": user and user.pk})
```

```python
from adrf.viewsets import ViewSet
from django.contrib.auth import get_user_model

User = get_user_model()

# 异步的用户视图集
class AsyncViewSet(ViewSet):
    
    async def list(self, request):
        return JsonResponse({"message": "这是异步视图集的list方法"})

    async def retrieve(self, request, pk):
        user = await User.objects.aget(pk=pk)
        return JsonResponse({"user": {"username": user.username}})
```

在urls.py中，还是可以使用DefaultRouter批量生成路由。

```python
from django.urls import path, include
from rest_framework import routers

from . import views

router = routers.DefaultRouter()
router.register(r"user", views.AsyncViewSet, basename="async")

urlpatterns = [
   path("", include(router.urls)),
]
```

</details>

## 异步序列化

序列化类承担起两个角色，一个是校验前端传的数据是否符合格式，另外一个是将 ORM 对象转换为字典，方便通过 JSON 的格式返回给前端。

<details>
<summary>校验表单数据</summary>

以登录API为例，假设要校验username和password，可以编写AsyncLoginSerializer

```python
from adrf.serializers import Serializer
from rest_framework import fields
import re

class AsyncLoginSerializer(Serializer):
    username = fields.CharField(max_length=200)
    password = fields.CharField(min_length=6, max_length=200)

    def validate(self, attrs):
        username = attrs.get("username")
        pattern = re.compile(r'^[a-zA-Z][a-zA-Z0-9_]{4,19}$')
        if pattern.match(username):
            return attrs
        else:
            raise fields.ValidationError("用户名不符合规则！")
```

由于 adrf 没有对validate_[field]、validate 方法编写异步处理的逻辑，因此自定义验证相关的方法只能是同步的，从而不能在校验的逻辑中出现 I/O 阻塞式代码。当然也可以定义成异步的，但是 adrf 的作者并没有处理异步验证的逻辑，如果要将validate_[field]和validate方法定义成异步的，那么就必须在视图函数中调用await serializer.validated_data才能执行validate函数中的代码，且需要通过 await field 才能获取到对应字段的值，所以不建议将验证方法定义成异步的。

在视图函数中调用 Serializer 相关的代码，则和同步模式下是一样的，示例代码如下。

```python
from .serializers import AsyncLoginSerializer

class LoginView(APIView):
    async def post(self, request):
        print(request.headers)
        serializer = AsyncLoginSerializer(data=request.data)
        if serializer.is_valid():
            validated_data = serializer.validated_data
            username = validated_data['username']
            password = validated_data['password']
            # authenticate是一个需要查找数据库的阻塞式I/O代码，所以不能直接这样写
            # user = authenticate(request, username=username, password=password)
            user = await aauthenticate(request, username=username, password=password)
            if user:
                # 这里在用户验证通过后，user对象实际上已经存在内存中了，那么将user对象转换为字典
                # 其实可以不用进行异步等待了，那为什么Serializer类，用于获取异步数据，还要用.adata呢？
                # 这是因为，如果UserSerializer中还定义了有外键参与的字段，那么就需要再次查找数据库了
                # 所以应该用异步版本的.adata来获取数据，更加统一。
                user_serializer = UserSerializer(user)
                user_dict = await user_serializer.adata
                return JsonResponse({"message": "登录成功！", "user": user_dict})
            else:
                return JsonResponse({"message": "用户名或密码错误！"})
        else:
            print(serializer.errors)
            return JsonResponse({"message": "表单校验失败！"})
```

</details>

<details>
<summary>将ORM对象转换为字典</summary>

由于将 ORM 转换为字典过程中可能会涉及到 SQL 查询（阻塞式 I/O），所以adrf提供了异步的用于获取转换后数据的属性adata。这里以序列化用户信息为例，来说明其用法。

```python
class UserSerializer(Serializer):
    username = fields.CharField(max_length=200)
    email = fields.EmailField()
    is_active = fields.BooleanField()
    is_staff = fields.BooleanField()
```

在视图中，可以将QuerySet<User>转换为字典

```python
class UserListView(APIView):
    async def get(self, request):
        queryset = User.objects.all()
        serializer = UserSerializer(queryset, many=True)
        data = await serializer.adata
        return JsonResponse({"users": data})
```

或者也可以继承ModelSerializer类来创建序列化类

```python
class UserModelSerializer(ModelSerializer):
    class Meta:
        model = User
        fields = ['username', 'email', 'is_active', 'is_staff']
```

</details>
