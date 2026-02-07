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

### 序列化数据

序列化：数据库获取 QuerySet 或数据对象 -> JSON

反序列化：JSON -> QuerySet 或数据对象，存入数据库

Tutorial 1: Serialization: [https://www.django-rest-framework.org/tutorial/1-serialization/](https://www.django-rest-framework.org/tutorial/1-serialization/)

Serializers: [https://www.django-rest-framework.org/api-guide/serializers/#serializers](https://www.django-rest-framework.org/api-guide/serializers/#serializers)

ModelSerializers: [https://www.django-rest-framework.org/api-guide/serializers/#modelserializer](https://www.django-rest-framework.org/api-guide/serializers/#modelserializer)

source 参数：[https://www.django-rest-framework.org/api-guide/fields/#source](https://www.django-rest-framework.org/api-guide/fields/#source)

```python
""" 修改前端看到的字段 key 值 -> source 指定的必须是对象的属性 """
book_name = serialiazers.CharField(source='name')

""" 修改前端看到的 value 值 -> source 指定的必须是对象的方法 """
# 表模型中写方法
def sb_name(self):
    return self.name = '_sb'
# 序列化类中
book_name = serializers.CharField(source='sb_name')

""" 可以关联查询(得有关联关系) """
publish_name = serializers.CharField(source='publish.name')
```

自定义钩子：

- SerializerMethodField: [https://www.django-rest-framework.org/api-guide/fields/#serializermethodfield](https://www.django-rest-framework.org/api-guide/fields/#serializermethodfield)

```python
""" 方式1: 在序列化类中写
1.写一个字段 对应的字段类是：SerializerMethodField
2.必须对应一个get_字段名的方法 方法必须接收一个obj 返回什么 这个字段对应的值就是什么
"""
class Depart(models.Model):
    title = models.CharField(verbose_name="部门", max_length=32)
    order = models.IntegerField(verbose_name="顺序")
    count = models.IntegerField(verbose_name="人数")

class UserInfo(models.Model):
    name = models.CharField(verbose_name="姓名", max_length=32)
    age = models.IntegerField(verbose_name="年龄")

    gender = models.SmallIntegerField(verbose_name="性别", choices=((1, "男"), (2, "女")))
    depart = models.ForeignKey(verbose_name="部门", to="Depart", on_delete=models.CASCADE)

    ctime = models.DateTimeField(verbose_name="时间", auto_now_add=True)

class UserSerializer(serializers.ModelSerializer):
    gender_text = serializers.CharField(source="get_gender_display")
    depart = serializers.CharField(source="depart.title")
    ctime = serializers.DateTimeField(format="%Y-%m-%d")

    # custom field
    xxx = serializers.SerializerMethodField()

    class Meta:
        model = models.UserInfo
        fields = ["name", "age", "gender", "gender_text", "depart", "ctime", "xxx"]

    # custom method
    def get_xxx(self, obj):
        return "{}-{}-{}".format(obj.name, obj.age, obj.gender)
```

```python
""" 方式2: 在模型层中写
1.在表模型中写一个方法(可以使用:property)，方法有返回值(字典，字符串，列表)
2.在序列化类中 使用DictField,CharField,ListField
"""
############################### 序列化类 #############################
class BookSerializer(serializers.Serializer):
    name = serializers.CharField()
    price = serializers.CharField()
    # 1.序列化类中这样写
    # 2.到模型表中写一个方法 方法名必须叫publish_detail 这个方法返回什么 这个字段的value就是什么
    publish_detail = serializers.DictField()
    author_list = serializers.ListField()

################################ 表模型 ###########################
class Book(models.Model):
    name = models.CharField(max_length=32)
    price = models.CharField(max_length=32)
    publish = models.ForeignKey(to='Publish', on_delete=models.SET_NULL, null=True)
    authors = models.ManyToManyField(to='Author')

    @property
    def publish_detail(self):
        return {'id': self.publish.pk, 'name': self.publish.name, 'addr': self.publish.addr}

    def author_list(self):
        l = []
        for author in self.authors.all():
            l.append({'id': author.pk, 'name': author.name, 'phone': author.phone, 'age': author.author_detail.age})
        return l
```

序列化器嵌套：针对 ForeignKey 和 ManyToMany 关系

```python
class D1(serializers.ModelSerializer):
    class Meta:
        model = models.Depart
        fields = ["__all__"]

class D2(serializers.ModelSerializer):
    class Meta:
        model = models.Tag
        fields = ["__all__"]

class UserSerializer(serializers.ModelSerializer):
    depart = D1()
    tags = D2(many=True)

    class Meta:
        model = models.UserInfo
        fields = ["name", "age", "depart", "tags"]
```

序列化器继承：

```python
class Base(serializers.Serializer):
    xx = serializers.CharField(source="name")

class UserSerializer(serializers.ModelSerializer, Base):
    class Meta:
        model = models.UserInfo
        fields = ["name", "age", "xx"]
```

### 数据校验

路由 -> 视图 -> request.data -> 校验（序列化器的类） -> 操作（db，序列化器的类）

- [https://www.django-rest-framework.org/api-guide/serializers/#validation](https://www.django-rest-framework.org/api-guide/serializers/#validation)
- [https://www.django-rest-framework.org/api-guide/validators/](https://www.django-rest-framework.org/api-guide/validators/)

1. 内置校验:

   ```python
   class UserSerializer(serializers.Serializer):
       title = serializers.CharField(required=True, max_length=20, min_length=6)
       order = serializers.IntegerField(required=False, max_value=100, min_value=10)
       level = serializers.ChoiceField(choices=[(1, "高级"), (2, "中级")])
   ```

2. 正则校验:

   ```python
   class UserSerializer(serializers.Serializer):
       email = serializers.CharField(
           validators=[
               RegexValidator(r"\d+", message="邮箱格式错误"),
           ]
       )
   ```

3. 钩子校验：

- 局部字段校验（字段钩子）：[https://www.django-rest-framework.org/api-guide/serializers/#field-level-validation](https://www.django-rest-framework.org/api-guide/serializers/#field-level-validation)
- 全局校验（全局钩子）：[https://www.django-rest-framework.org/api-guide/serializers/#object-level-validation](https://www.django-rest-framework.org/api-guide/serializers/#object-level-validation)

4. Model 校验

   ```python
   class RoleSerializer(serializers.ModelSerializer):
       more = serializers.CharField(required=True)

       class Meta:
           model = models.Role
           field = ["title", "order", "more"]
           extra_kwargs = {
               "title": {"validators": [RegexValidator(r"\d+", message="False Format")]},
               "order": {"min_value": 5}
           }

       def validate_more(self, value):
           return value

       def validata(self, attrs):
           return attrs
   ```

### 存入数据到数据库

save 方法：[https://www.django-rest-framework.org/api-guide/serializers/#saving-instances](https://www.django-rest-framework.org/api-guide/serializers/#saving-instances)

save 方法的返回值就是序列化器对应的 Model 对象

```python
class DepartView(APIView):

    def post(self, request, *args, **kwargs):
        # 1.Get Request Data
        print(request.data)
        # 2.Validate
        ser = DepartModelSerializer(data=request.data)
        ser.is_valid(raise_exception=True)
        ser.validated_data.pop("more") # redundant parameter
        ser.save(count=100) # extra parameter
        return Response("success")
```

```python
class DepartView(APIView):

    def post(self, request, *args, **kwargs):
        # 1.Get Request Data
        print(request.data)
        # 2.Validate
        ser = DepartModelSerializer(data=request.data)
        if ser.is_valid():
            print(ser.validated_data)
            more = ser.validated_data.pop("more")
            # ser.validated_data.pop("more")
            ser.save(count=100)
        else:
            print(ser.errors)
        return Response("success")
```

使用 save 存入数据的同时，再序列化数据返回

方法 1: 校验 Serializer + 序列化 Serializer【定义 2 个 Serializer】
方法 2: 校验 Serializer（校验全部字段，序列化全部字段）【定义 1 个 Serializer】
方法 3: 校验 Serializer（校验全部字段，序列化部分字段）【定义 1 个 Serializer，用 read_only + write_only 控制】

- [https://www.django-rest-framework.org/api-guide/fields/#read_only](https://www.django-rest-framework.org/api-guide/fields/#read_only)
- [https://www.django-rest-framework.org/api-guide/fields/#write_only](https://www.django-rest-framework.org/api-guide/fields/#write_only)

### 自定义钩子

需求：

```bash
# 输入：{"name": "xxx", "age": 18, "gender":1}
# 输出：{"id": 44, "name": "xxx", "age": 18, "gender": "男"}
```

方法 1:

```python
# https://www.bilibili.com/video/BV13ZkkYpE2m?p=73
class NbCharField(serializers.IntegerField):
    def __init__(self, method_name=None, **kwargs):
        self.method_name = method_name # None
        super().__init__(**kwargs)

    def bind(self, field_name, parent):
        # The method name defaults to `get_{field_name}`.
        if self.method_name is None:
            self.method_name = 'xget_{field_name}'.format(field_name=field_name) # "get_gender"
        super().bind(field_name, parent)

    def get_attribute(self, instance):
        method = getattr(self.parent, self.method_name)
        return method(instance)

    def to_representation(self, value):
        return str(value)

class NbModelSerializer(serializers.ModelSerializer):
    gender = NbCharField()

    class Meta:
        model = models.NbUserInfo
        fields = ["id", "name", "age", "gender"]
        extra_kwargs = {
            "id": {"read_only": True}
        }

    def xget_gender(self, obj):
        return obj.get_gender_display()

class NbView(APIView):
    def post(self, request, *args, **kwargs):
        ser = NbModelSerializer(data=request.data)
        if ser.is_valid():
            instance = ser.save()
            print(type(instance))
            print(instance.get_gender_display)
            print(instance.id, instance.get_gender_display(), instance.gender)
            return Response(ser.data)
        else:
            return Response(ser.errors)
```

方法 2:

```python
# https://www.bilibili.com/video/BV13ZkkYpE2m?p=74
from collections import OrderedDict
from rest_framework.fields import SkipField
from rest_framework.relations import PKOnlyObject

class SbModelSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.NbUserInfo
        fields = ["id", "name", "age", "gender"]
        extra_kwargs = {
            "id": {"read_only": True}
        }

    def to_representation(self, instance):
        ret = {}
        fields = self._readable_fields

        for field in fields:
            if hasattr(self, 'sb_%s' % field.field_name):
                value = getattr(self, 'nb_%s' % field.field_name)(instance)
                ret[field.field_name] = value
            else:
                try:
                    attribute = field.get_attribute(instance)
                except SkipField:
                    continue
                check_for_none = attribute.pk if isinstance(attribute, PKOnlyObject) else attribute
                if check_for_none is None:
                    ret[field.field_name] = None
                else:
                    ret[field.field_name] = field.to_representation(attribute)

        return ret

    def sb_gender(self, obj):
        return obj.get_gender_display()

class SbView(APIView):
    def post(self, request, *args, **kwargs):
        ser = NbModelSerializer(data=request.data)
        if ser.is_valid():
            ser.save()
            return Response(ser.data)
        else:
            return Response(ser.errors)
```

方法 3（推荐）: 对方法 2 的改进

```python
# api/ext/hook.py
from collections import OrderedDict
from rest_framework.fields import SkipField
from rest_framework.relations import PKOnlyObject

class NbHookSerializer(object):
    def to_representation(self, instance):
        ret = {}
        fields = self._readable_fields

        for field in fields:
            if hasattr(self, 'nb_%s' % field.field_name):
                value = getattr(self, 'nb_%s' % field.field_name)(instance)
                ret[field.field_name] = value
            else:
                try:
                    attribute = field.get_attribute(instance)
                except SkipField:
                    continue
                check_for_none = attribute.pk if isinstance(attribute, PKOnlyObject) else attribute
                if check_for_none is None:
                    ret[field.field_name] = None
                else:
                    ret[field.field_name] = field.to_representation(attribute)

        return ret

# views.py
from api.ext.hook import NbHookSerializer

class SbModelSerializer(NbHookSerializer, serializers.ModelSerializer):
    class Meta:
        model = models.NbUserInfo
        fields = ["id", "name", "age", "gender"]
        extra_kwargs = {
            "id": {"read_only": True}
        }

    def nb_gender(self, obj):
        return obj.get_gender_display()

    def nb_name(self, obj):
        return f"【{name}】被扩展了"

class SbView(APIView):
    def post(self, request, *args, **kwargs):
        ser = NbModelSerializer(data=request.data)
        if ser.is_valid():
            ser.save()
            return Response(ser.data)
        else:
            return Response(ser.errors)
```

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

---
下面的需要整理，归类到上面去

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
