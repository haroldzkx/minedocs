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
