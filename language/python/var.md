# 【变量与注释】

# 变量名与注释

bad code

```python
#去掉s两边的空格，再处理
value = process(s.strip())
```

good code

```python
#用户输入可能会有空格，使用strip()去掉空格
username = extract_username(input_string.strip())
```

# 变量解包

变量解包（unpacking）是 Python 里的一种特殊赋值操作，允许我们把一个可迭代对象（比如列表）的所有成员，一次性赋值给多个变量：

```python
>>> usernames = ['piglei', 'raymond']
# 注意：左侧变量的个数必须和待展开的列表长度相等，否则会报错
>>> author, reader = usernames
>>> author
'piglei'
```

假如在赋值语句左侧添加小括号(...)，甚至可以一次展开多层嵌套数据：

```python
>>> attrs = [1, ['piglei', 100]]
>>> user_id, (username, score) = attrs
>>> user_id
1
>>> username
'piglei'
```

除了上面的普通解包外，Python 还支持更灵活的动态解包语法。只要用星号表达式(\*variables)作为变量名，它便会贪婪地捕获多个值对象，并将捕获到的内容作为列表赋值给 variables。

比如，下面 data 列表里的数据就分为三段：头为用户，尾为分数，中间的都是水果名称。通过把\*fruits 设置为中间的解包变量，我们就能一次性解包所有变量——fruits 会捕获 data 去头去尾后的所有成员：

```python
>>> data = ['piglei', 'apple', 'orange', 'banana', 100]
>>> username, *fruits, score = data
>>> username
'piglei'
>>> fruits
['apple', 'orange', 'banana']
>>> score
100
```

和常规的切片赋值语句比起来，动态解包语法要直观许多：

```python
#1. 动态解包
>>> username, *fruits, score = data
# 2. 切片赋值
>>> username, fruits, score = data[0], data[1:-1], data[-1]
# 两种变量赋值方式完全等价
```

上面的变量解包操作也可以在任何循环语句里使用：

```python
>>> for username, score in [('piglei', 100), ('raymond', 60)]:
...     print(username)
...
piglei
raymond
```

# 单下划线变量名\_

单下划线`_`作为一个无意义的占位符出现在赋值语句中。

`_`这个名字本身没什么特别之处，这算是大家约定俗成的一种用法。

举个例子，假如你想在解包赋值时忽略某些变量，就可以使用`_`作为变量名：

```python
#忽略展开时的第二个变量
>>> author, _ = usernames
# 忽略第一个和最后一个变量之间的所有变量
>>> username, *_, score = data
```

而在 Python 交互式命令行里，`_`变量还有一层特殊含义——默认保存我们输入的上个表达式的返回值：

```python
>>> 'foo'.upper()
'FOO'
>>> print(_)
# 此时的_变量保存着上一个.upper()表达式的结果
FOO
```

# 给变量注明类型

bad code

```python
def remove_invalid(items):
    """剔除 items 里面无效的元素"""
    ... ...
```

你能告诉我，函数接收的 items 参数是什么类型吗？是一个装满数字的列表，还是一个装满字符串的集合？只看上面这点儿代码，我们根本无从得知。

为了解决动态类型带来的可读性问题，最常见的办法就是函数文档（docstring）和类型注解。

我们可以把每个函数参数的类型与说明全都写在函数文档里。

## 函数文档

good code

```python
def remove_invalid(items):
    """剔除 items 里面无效的元素

    :param items: 待剔除对象
    :type items: 包含整数的列表，[int, ...]
    """
```


# 变量命名原则

bad code

这段代码就是一个充斥着坏名字的“集大成”者。

```python
data1 = process(data)
if data1 > data2:
    data2 = process_new(data1)
    data3 = data2
return process_v2(data3)
```

## 遵循 PEP 8 原则

PEP8 中变量的命名规范：

- 对于普通变量，使用蛇形命名法，比如 max_value；
- 对于常量，采用全大写字母，使用下划线连接，比如 MAX_VALUE；
- 如果变量标记为“仅内部使用”，为其增加下划线前缀，比如\_local_var；
- 当名字与 Python 关键字冲突时，在变量末尾追加下划线，比如 class\_。

除变量名以外，PEP 8 中还有许多其他命名规范，比如类名应该使用驼峰风格（FooClass）、函数应该使用蛇形风格（bar_function），等等。

给变量起名的第一条原则，就是一定要在格式上遵循以上规范。

## 描述性要强

```python
#描述性弱的名字：看不懂在做什么
value = process(s.strip())

# 描述性强的名字：尝试从用户输入里解析出一个用户名
username = extract_username(input_string.strip())
```

| 描述性弱的名字 | 描述性强的名字   | 说明                                                                                                  |
| -------------- | ---------------- | ----------------------------------------------------------------------------------------------------- |
| data           | file_chunks      | data 泛指所有的“数据”，但如果数据是来自文件的碎块，我们可以直接叫 file_chunks                         |
| temp           | pending_id       | temp 泛指所有“临时”的东西，但其实它存放的是一个等待处理的数据 ID，因此直接叫它 pending_id 更好        |
| result(s)      | active_member(s) | result(s)经常用来表示函数执行的“结果”，但如果结果就是指“活跃会员”，那还是直接叫“active_member(s)”更好 |

判断一个名字是否合适，一定要结合它所在的场景，脱离场景谈名字是片面的，是没有意义的。

因此，在“说明”这一列中，我们强调了这个判断所适用的场景。

## 要尽量短

bad code

```python
def upgrade_to_level3(user):
    """如果积分满足要求，将用户升级到级别 3"""
    how_many_points_needed_for_user_level3 = get_level_points（3）
    if user.points >= how_many_points_needed_for_user_level3:
        upgrade(user)
    else:
        raise Error('积分不够，必须要 {} 分'.format(how_many_points_needed_for_user_level3))
```

为变量命名要结合代码情境和上下文。

比如在上面的代码里，upgrade_to_level3(user)函数已经通过自己的名称、文档表明了其目的，那在函数内部，我们完全可以把 how_many_points_needed_for_user_level3 直接删减成 level3_points。

## 要匹配类型

匹配布尔值类型的变量名

| 变量名       | 含义           | 说明        |
| ------------ | -------------- | ----------- |
| is_superuser | 是否是超级用户 | 是/不是     |
| has_errors   | 有没有错误     | 有/没有     |
| allow_empty  | 是否允许空值   | 允许/不允许 |

匹配 int/float 类型的变量名

- 释义为数字的所有单词，比如 port（端口号）、age（年龄）、radius（半径）等；
- 使用以\_id 结尾的单词，比如 user_id、host_id；
- 使用以 length/count 开头或者结尾的单词，比如 length_of_username、max_length、users_count。  
  最好别拿一个名词的复数形式来作为 int 类型的变量名，比如 apples、trips 等，因为这类名字容易与那些装着 Apple 和 Trip 的普通容器对象（List[Apple]、List[Trip]）混淆，建议用 number_of_apples 或 trips_count 这类复合词来作为 int 类型的名字。

匹配其他类型的变量名

至于剩下的字符串（str）、列表（list）、字典（dict）等其他值类型，我们很难归纳出一个“由名字猜测类型”的统一公式。

拿 headers 这个名字来说，它既可能是一个装满头信息的列表（List[Header]），也可能是一个包含头信息的字典（Dict[str, Header]）。

对于这些值类型，建议在代码中明确标注它们的类型详情。

## 超短命名

在众多变量名里，有一类非常特别，那就是只有一两个字母的短名字。

这些短名字一般可分为两类，一类是那些大家约定俗成的短名字，比如：

- 数组索引三剑客 i、j、k
- 某个整数 n
- 某个字符串 s
- 某个异常 e
- 文件对象 fp

如果条件允许，建议尽量用更精确的名字替代。

比如，在表示用户输入的字符串时，用 input_str 替代 s 会更明确一些。

另一类短名字，则是对一些其他常用名的缩写。

比如，在使用 Django 框架做国际化内容翻译时，常常会用到 gettext 方法。为了方便，常把 gettext 缩写成\_：

```python
from django.utils.translation import gettext as _
print(_('待翻译文字'))
```

如果你的项目中有一些长名字反复出现，可以效仿上面的方式，为它们设置一些短名字作为别名。这样可以让代码变得更紧凑、更易读。但同一个项目内的超短缩写不宜太多，否则会适得其反。

## 其他技巧

除了上面这些规则外，下面再分享几个给变量命名的小技巧：

- 在同一段代码内，不要出现多个相似的变量名，比如同时使用 users、users1、users3 这种序列；
- 可以尝试换词来简化复合变量名，比如用 is_special 来代替 is_not_normal；
- 如果你苦思冥想都想不出一个合适的名字，请打开 GitHub，到其他人的开源项目里找找灵感吧！

# 注释

Python 里的注释主要分为两种，一种是最常见的代码内注释，通过在行首输入#号来表示：

```python
#用户输入可能会有空格，使用strip去掉空格
username = extract_username(input_string.strip())
```

当注释包含多行内容时，同样使用#号：

```python
#使用strip()去掉空格的好处：
# 1. 数据库保存时占用空间更小
# 2. 不必因为用户多打了一个空格而要求用户重新输入
username = extract_username(input_string.strip())
```

除使用#的注释外，另一种注释则是我们前面看到过的函数（类）文档（docstring），这些文档也称接口注释（interface comment）。

```python
class Person:
    """人

    :param name: 姓名
    :param age: 年龄
    :param favorite_color: 最喜欢的颜色
    """

    def __init__(self, name, age, favorite_color):
        self.name = name
        self.age = age
        self.favorite_color = favorite_color
```

接口注释有好几种流行的风格，比如 Sphinx 文档风格、Google 风格等，其中 Sphinx 文档风格目前应用得最为广泛。上面的 Person 类的接口注释就属于 Sphinx 文档风格。

虽然注释一般不影响代码的执行效果，却会极大地影响代码的可读性。在编写注释时，编程新手们常常会犯同类型的错误，以下是最常见的 3 种。

## 用注释屏蔽代码

有时，人们会把注释当作临时屏蔽代码的工具。当某些代码暂时不需要执行时，就把它们都注释了，未来需要时再解除注释。

```python
# 源码里有大段大段暂时不需要执行的代码
# trip = get_trip(request)
# trip.refresh()
# ... ...
```

其实根本没必要这么做。这些被临时注释掉的大段内容，对于阅读代码的人来说是一种干扰，没有任何意义。

对于不再需要的代码，我们应该直接把它们删掉，而不是注释掉。

如果未来有人真的需要用到这些旧代码，他直接去 Git 仓库历史里就能找到，毕竟版本控制系统就是专门干这个的。

## 用注释复述代码

在编写注释时，新手常犯的另一类错误是用注释复述代码。就像这样：

```python
#调用strip()去掉空格
input_string = input_string.strip()
```

上面代码里的注释完全是冗余的，因为读者从代码本身就能读到注释里的信息。好的注释应该像下面这样：

```python
#如果直接把带空格的输入传递到后端处理，可能会造成后端服务崩溃
# 因此使用strip() 去掉首尾空格
input_string = input_string.strip()
```

注释作为代码之外的说明性文字，应该尽量提供那些读者无法从代码里读出来的信息。描述代码为什么要这么做，而不是简单复述代码本身。除了描述“为什么”的解释性注释外，还有一种注释也很常见：指引性注释。

这种注释并不直接复述代码，而是简明扼要地概括代码功能，起到“代码导读”的作用。

比如，以下代码里的注释就属于指引性注释：

```python
#初始化访问服务的client对象
token = token_service.get_token()
service_client = ServiceClient(token=token)
service_client.ready()
# 调用服务获取数据，然后进行过滤
data = service_client.fetch_full_data()
for item in data:
    if item.value > SOME_VALUE:
        ...
```

指引性注释并不提供代码里读不到的东西——假如没有注释，耐心读完所有代码，你也能知道代码做了什么事儿。指引性注释的主要作用是降低代码的认知成本，让我们能更容易理解代码的意图。

在编写指引性注释时，有一点需要注意，那就是你得判断何时该写注释，何时该将代码提炼为独立的函数（或方法）。

比如上面的代码，其实可以通过抽象两个新函数改成下面这样：

```python
service_client = make_client()
data = fetch_and_filter(service_client)
```

这么改以后，代码里的指引性注释就可以删掉了，因为有意义的函数名已经达到了概括和指引的作用。

正是因为如此，一部分人认为：只要代码里有指引性注释，就说明代码的可读性不高，无法“自说明”，一定得抽象新函数把其优化成第二种样子。

但事情没那么绝对。无论代码写得多好，多么“自说明”，同读代码相比，读注释通常让人觉得更轻松。注释会让人们觉得亲切（尤其当注释是中文时），高质量的指引性注释确实会让代码更易读。

有时抽象一个新函数，不见得就一定比一行注释加上几行代码更好。

## 弄错接口注释的受众

在编写接口注释时，人们有时会写出下面这样的内容：

```python
def resize_image(image, size):
    """将图片缩放到指定尺寸，并返回新的图片。
    该函数将使用Pilot 模块读取文件对象，然后调用.resize() 方法将其缩放到指定尺寸。
    但由于Pilot 模块自身限制，这个函数不能很好地处理过大的文件，当文件大小超过 5MB 时，
    resize() 方法的性能就会因为内存分配问题急剧下降，详见 Pilot 模块的Issue #007。因此，
    对于超过 5MB 的图片文件，请使用resize_big_image() 替代，后者基于Pillow 模块开发，
    很好地解决了内存分配问题，确保性能更好了。
    :param image: 图片文件对象
    :param size: 包含宽高的元组：（width, height）
    :return: 新图片对象
    """
```

这段接口注释最主要的问题在于过多阐述了函数的实现细节，提供了太多其他人并不关心的内容。

接口文档主要是给函数（或类）的使用者看的，它最主要的存在价值，是让人们不用逐行阅读函数代码，也能很快通过文档知道该如何使用这个函数，以及在使用时有什么注意事项。

在编写接口文档时，我们应该站在函数设计者的角度，着重描述函数的功能、参数说明等。而函数自身的实现细节，比如调用了哪个第三方模块、为何有性能问题等，无须放在接口文档里。

对于上面的 resize_image()函数来说，文档里提供以下内容就足够了：

```python
def resize_image(image, size):
    """将图片缩放到指定尺寸，并返回新的图片。
    注意：当文件超过 5MB 时，请使用resize_big_image()
    :param image: 图片文件对象
    :param size: 包含宽高的元组：（width, height）
    :return: 新图片对象
    """
```

至于那些使用了 Pilot 模块、为何有内存问题的细节说明，全都可以丢进函数内部的代码注释里。

# 小例子

冒泡排序算法：请用 Python 语言实现冒泡排序算法，把较大的数字放在后面。注意：默认所有的偶数都比奇数大。

```python
>>> numbers = [23, 32, 1, 3, 4, 19, 20, 2, 4]
>>> magic_bubble_sort(numbers)
[1, 3, 19, 23, 2, 4, 4, 20, 32]
```

bad code

```python
def magic_bubble_sort(numbers):
    j = len(numbers) - 1　　
    while j > 0:
        for i in range(j):
            if numbers[i] % 2 == 0 and numbers[i + 1] % 2 == 1:
                numbers[i], numbers[i + 1] = numbers[i + 1], numbers[i]
                continue
        elif (numbers[i + 1] % 2 == numbers[i] % 2) and numbers[i] > numbers[i + 1]:
            numbers[i], numbers[i + 1] = numbers[i + 1], numbers[i]
            continue
    j -= 1
return numbers
```

good code

```python
def magic_bubble_sort(numbers: List[int]):
    """有魔力的冒泡排序算法，默认所有的偶数都比奇数大
    :param numbers: 需要排序的列表，函数会直接修改原始列表
    """
    stop_position = len(numbers) - 1
    while stop_position > 0:
        for i in range(stop_position):
            current, next_ = numbers[i], numbers[i + 1]
            current_is_even, next_is_even = current % 2 == 0, next_ % 2 == 0
            should_swap = False
            # 交换位置的两个条件：
            # - 前面是偶数，后面是奇数
        # - 前面和后面同为奇数或者偶数，但是前面比后面大
        if current_is_even and not next_is_even:
            should_swap = True
        elif current_is_even == next_is_even and current > next_:
            should_swap = True
        if should_swap:
            numbers[i], numbers[i + 1] = numbers[i + 1], numbers[i]
    stop_position -= 1
return numbers
```

（1）变量名变成了可读的、有意义的名字，比如在旧代码里，“停止位”是无意义的 j，新代码里变成了 stop_position。

（2）增加了有意义的临时变量，比如 current/next\_代表前一个/后一个元素、{}\_is_even 代表元素是否为偶数、should_swap 代表是否应该交换元素。

（3）多了一点儿恰到好处的指引性注释，比如说明交换元素顺序的详细条件。

这些变化让整段代码变得更易读，也让整个算法变得更好理解。所以，哪怕是一段不到 10 行代码的简单函数，对变量和注释的不同处理方式，也会让代码发生质的变化。

# 编程建议

## 保持变量的一致性

在使用变量时，你需要保证它在两个方面的一致性：名字一致性与类型一致性。

名字一致性是指在同一个项目（或者模块、函数）中，对一类事物的称呼不要变来变去。如果你把项目里的“用户头像”叫作 user_avatar_url，那么在其他地方就别把它改成 user_profile_url。否则会让读代码的人犯迷糊：“user_avatar_url 和 user_profile_url 到底是不是一个东西？”

类型一致性则是指不要把同一个变量重复指向不同类型的值，举个例子：

```python
def foo():
    # users 本身是一个 Dict
    users = {'data': ['piglei', 'raymond']}
    ...
    # users 这个名字真不错！尝试复用它，把它变成 List 类型
    users = []
    ...
```

在 foo()函数的作用域内，users 变量被使用了两次：第一次指向字典，第二次则变成了列表。虽然 Python 的类型系统允许我们这么做，但这样做其实有很多坏处，比如变量的辨识度会因此降低，还很容易引入 bug。

所以，建议在这种情况下启用一个新变量：

```python
def foo():
    users = {'data': ['piglei', 'raymond']}
    ...
    # 使用一个新名字
    user_list = []
    ...
```

## 变量定义尽量靠近使用

很多人在初学编程时有一种很不好的习惯——喜欢把所有变量初始化定义写在一起，放在函数最前面，就像下面这样：

```python
def generate_trip_png(trip):
    """
    根据旅途数据生成 PNG 图片
    """
    # 预先定义好所有的局部变量
    waypoints = []
    photo_markers, text_markers = [], []
    marker_count = 0

    # 开始初始化 waypoints 数据
    waypoints.append(...)
    ...
    # 经过几行代码后，开始处理 photo_markers、text_markers
    photo_markers.append(...)
    ...
    # 经过更多代码后，开始计算 marker_count
    marker_count += ...

    # 拼接图片：已省略……
```

之所以这么写代码，是因为我们觉得“初始化变量”语句是类似的，应该将其归类到一起，放到最前面，这样代码会整洁很多。

但是，这样的代码只是看上去整洁，它的可读性不会得到任何提升，反而会变差。

在组织代码时，我们应该谨记：总是从代码的职责出发，而不是其他东西。

比如，在上面的 generate_trip_png()函数里，代码的职责主要分为三块：

- 初始化 waypoints 数据
- 处理 markers 数据
- 计算 marker_count

那代码可以这么调整：

```python
def generate_trip_png(trip):
    """
    根据旅途数据生成 PNG 图片
    """
    # 开始初始化 waypoints 数据
    waypoints = []
    waypoints.append(...)
    ...

    # 开始处理 photo_markers、text_markers
    photo_markers, text_markers = [], []
    photo_markers.append(...)
    ...

    # 开始计算 marker_count
    marker_count = 0
    marker_count += ...

    # 拼接图片：已省略……
```

通过把变量定义移动到每段“各司其职”的代码头部，大大缩短了变量从初始化到被使用的“距离”。当读者阅读代码时，可以更容易理解代码的逻辑，而不是来回翻阅代码，心想：“这个变量是什么时候定义的？是干什么用的？”

## 定义临时变量提升可读性

随着业务逻辑变得复杂，我们的代码里也会经常出现一些复杂的表达式，就像下面这样：

```python
#为所有性别为女或者级别大于3的活跃用户发放 10000个金币
if user.is_active and (user.sex == 'female' or user.level > 3):
    user.add_coins(10000)
    return
```

看见 if 后面那一长串代码了吗？有点儿难读对不对？但这也没办法，毕竟产品经理就是明明白白这么跟我说的——业务逻辑如此。

逻辑虽然如此，不代表我们就得把代码直白地写成这样。如果把后面的复杂表达式赋值为一个临时变量，代码可以变得更易读：

```python
#为所有性别为女或者级别大于3的活跃用户发放10000个金币
user_is_eligible = user.is_active and (user.sex == 'female' or user.level > 3)

if user_is_eligible:
    user.add_coins(10000)
    return
```

在新代码里，“计算用户合规的表达式”和“判断合规发送金币的条件分支”这两段代码不再直接杂糅在一起，而是添加了一个可读性强的变量 user_is_elegible 作为缓冲。不论是代码的可读性还是可维护性，都因为这个变量而增强了。

直接翻译业务逻辑的代码，大多不是好代码。

优秀的程序设计需要在理解原需求的基础上，`恰到好处地抽象`，只有这样才能同时满足可读性和可扩展性方面的需求。抽象有许多种方式，比如定义新函数、定义新类型，“定义一个临时变量”是诸多方式里不太起眼的一个，但用得恰当的话效果也很巧妙。

## 同一作用域内不要有太多变量

通常来说，函数越长，用到的变量也会越多。但是人脑的记忆力是很有限的。研究表明，人类的短期记忆只能同时记住不超过 10 个名字。变量过多，代码肯定就会变得难读

```python
def import_users_from_file(fp):
    """尝试从文件对象读取用户，然后导入数据库

    :param fp: 可读文件对象
    :return: 成功与失败的数量
    """
    # 初始化变量：重复用户、黑名单用户、正常用户
    duplicated_users, banned_users, normal_users = [], [], []
    for line in fp:
        parsed_user = parse_user(line)
        # …… 进行判断处理，修改前面定义的{X}_users 变量

    succeeded_count, failed_count = 0, 0
    # …… 读取 {X}_users 变量，写入数据库并修改成功与失败的数量
    return succeeded_count, failed_count
```

import_users_from_file()函数里的变量数量就有点儿多，比如用来暂存用户的{duplicated| banned|normal}\_users，用来保存结果的 succeeded_count、failed_count 等。

要减少函数里的变量数量，最直接的方式是给这些变量分组，建立新的模型。比如，我们可以将代码里的 succeeded_count、failed_count 建模为 ImportedSummary 类，用 ImportedSummary.succeeded_count 来替代现有变量；对{duplicated|banned|normal}\_users 也可以执行同样的操作。

```python
class ImportedSummary:
    """保存导入结果摘要的数据类"""

    def __init__(self):
        self.succeeded_count = 0
        self.failed_count = 0

class ImportingUserGroup:
    """用于暂存用户导入处理的数据类"""

    def __init__(self):
        self.duplicated = []
        self.banned = []
        self.normal = []

def import_users_from_file(fp):
    """尝试从文件对象读取用户，然后导入数据库　　

    :param fp: 可读文件对象
    :return: 成功与失败的数量
    """
    importing_user_group = ImportingUserGroup()
    for line in fp:
        parsed_user = parse_user(line)
        # …… 进行判断处理，修改上面定义的importing_user_group 变量

    summary = ImportedSummary()
    # …… 读取 importing_user_group，写入数据库并修改成功与失败的数量

    return summary.succeeded_count, summary.failed_count
```

通过增加两个数据类，函数内的变量被更有逻辑地组织了起来，数量变少了许多。

需要说明的一点是，大多数情况下，只是执行上面这样的操作是远远不够的。函数内变量的数量太多，通常意味着函数过于复杂，承担了太多职责。只有把复杂函数拆分为多个小函数，代码的整体复杂度才可能实现根本性的降低。

## 能不定义变量就别定义

前面提到过，定义临时变量可以提高代码的可读性。但有时，把不必要的东西赋值为临时变量，反而会让代码显得啰唆：

```python
def get_best_trip_by_user_id(user_id):
    # 心理活动：嗯，这个值未来说不定会修改/二次使用，我们先把它定义成变量吧！
    user = get_user(user_id)
    trip = get_best_trip(user_id)
    result = {
        'user': user,
        'trip': trip
    }
    return result
```

在编写代码时，我们会下意识地定义很多变量，好为未来调整代码做准备。但其实，你所想的未来也许永远不会来。上面这段代码里的三个临时变量完全可以去掉，变成下面这样：

```python
def get_best_trip_by_user_id(user_id):
    return {
        'user': get_user(user_id),
        'trip': get_best_trip(user_id)
    }
```

这样的代码就像删掉赘语的句子，变得更精练、更易读。

所以，不必为了那些未来可能出现的变动，牺牲代码此时此刻的可读性。如果以后需要定义变量，那就以后再做。

## 不要使用 locals()

locals()是 Python 的一个内置函数，调用它会返回当前作用域中的所有局部变量：

```python
def foo():
    name = 'piglei'
    bar = 1
    print(locals())

# 调用foo() 将输出：
{'name': 'piglei', 'bar': 1}
```

在有些场景下，我们需要一次性拿到当前作用域下的所有（或绝大部分）变量，比如在渲染 Django 模板时：

```python
def render_trip_page(request, user_id, trip_id):
    """渲染旅程页面"""
    user = User.objects.get(id=user_id)
    trip = get_object_or_404(Trip, pk=trip_id)
    is_suggested = check_if_suggested(user, trip)
    return render(request, 'trip.html', {
        'user': user,
        'trip': trip,
        'is_suggested': is_suggested
    })
```

看上去使用 locals()函数正合适，假如调用 locals()，上面的代码会简化许多：

```python
def render_trip_page(request, user_id, trip_id):
    ...

    # 利用locals() 把当前所有变量作为模板渲染参数返回
    # 节约了三行代码，我简直是个天才！
    return render(request, 'trip.html', locals())
```

第一眼看上去非常“简洁”，但是，这样的代码真的更好吗？

答案并非如此。locals()看似简洁，但其他人在阅读代码时，为了搞明白模板渲染到底用了哪些变量，必须记住当前作用域里的所有变量。假如函数非常复杂，“记住所有局部变量”简直是个不可能完成的任务。

使用 locals()还有一个缺点，那就是它会把一些并没有真正使用的变量也一并暴露。

因此，比起使用 locals()，建议老老实实把代码写成这样：

```python
return render(request, 'trip.html', {
    'user': user,
    'trip': trip,
    'is_suggested': is_suggested
})
```

## 空行也是一种“注释”

代码里的注释不只是那些常规的描述性语句，有时候，没有一个字符的空行，也算得上一种特殊的“注释”。

在写代码时，我们可以适当地在代码中插入空行，把代码按不同的逻辑块分隔开，这样能有效提升代码的可读性。

举个例子，拿前面案例故事里的代码来说，假如删掉所有空行，代码会变成下面这样，请你试着读读看。

```python
def magic_bubble_sort(numbers: List[int]):
    stop_position = len(numbers) - 1
    while stop_position > 0:
        for i in range(stop_position):
            current, next_ = numbers[i], numbers[i + 1]
            current_is_even, next_is_even = current % 2 == 0, next_ % 2 == 0
            should_swap = False
            if current_is_even and not next_is_even:
            should_swap = True
        elif current_is_even == next_is_even and current > next_:
            should_swap = True
        if should_swap:
            numbers[i], numbers[i + 1] = numbers[i + 1], numbers[i]
    stop_position -= 1
return numbers
```

是不是感觉代码特别局促，连喘口气的机会都找不到？这就是缺少空行导致的。只要在代码里加上一丁点儿空行（不多，就两行），函数的可读性马上会得到可观的提升

```python
def magic_bubble_sort(numbers: List[int]):
    stop_position = len(numbers) - 1
    while stop_position > 0:
        for i in range(stop_position):
            previous, latter = numbers[i], numbers[i + 1]
            previous_is_even, latter_is_even = previous % 2 == 0, latter % 2 == 0
            should_swap = False

            if previous_is_even and not latter_is_even:
                should_swap = True
            elif previous_is_even == latter_is_even and previous > latter:
                should_swap = True

            if should_swap:
                numbers[i], numbers[i + 1] = numbers[i + 1], numbers[i]
        stop_position -= 1
    return numbers
```

## 先写注释，后写代码

在编写了许多函数以后，我总结出了一个值得推广的好习惯：先写注释，后写代码。

每个函数的名称与接口注释（也就是 docstring），其实是一种比函数内部代码更为抽象的东西。你需要在函数名和短短几行注释里，把函数内代码所做的事情，高度浓缩地表达清楚。

正因如此，接口注释其实完全可以当成一种协助你设计函数的前置工具。这个工具的用法很简单：假如你没法通过几行注释把函数职责描述清楚，那么整个函数的合理性就应该打一个问号。

举个例子，你在编辑器里写下了 def process_user(...):，准备实现一个名为 process_user 的新函数。在编写函数注释时，你发现在写了好几行文字后，仍然没法把 process_user()的职责描述清楚，因为它可以同时完成好多件不同的事情。

这时你就应该意识到，process_user()函数承担了太多职责，解决办法就是直接删掉它，设计更多单一职责的子函数来替代之。

先写注释的另一个好处是：不会漏掉任何应该写的注释。

我常常在审查代码时发现，一些关键函数的 docstring 位置一片空白，而那里本该备注详尽的接口注释。每当遇到这种情况，我都会不厌其烦地请代码提交者补充和完善接口注释。

为什么大家总会漏掉注释？我的一个猜测是：程序员在编写函数时，总是跳过接口注释直接开始写代码。而当写完代码，实现函数的所有功能后，他就对这个函数失去了兴趣。这时，他最不愿意做的事，就是回过头去补写函数的接口注释，即便写了，也只是草草对付了事。

如果遵守“先写注释，后写代码”的习惯，我们就能完全避免上面的问题。要养成这个习惯其实很简单：在写出一句有说服力的接口注释前，别写任何函数代码。
