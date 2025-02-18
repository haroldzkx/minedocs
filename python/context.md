# 上下文管理器

# 1.什么是上下文管理器

这里先了解下**上下文**，上下文是 context 直译的叫法，在程序中用来表示代码执行过程中所处的前后环境，比如在文件操作时，文件需要打开关闭，而文件读写操作就处于文件操作的上下文环境中。

**上下文管理器**，上下文管理器是指在一段代码执行之前，执行一些预处理的工作，代码执行之后再执行一些清理工作。

上下文管理器中有`__enter__()`和 `__exit__()` 两个方法，`__enter__()`方法在执行 with 后面的语句时执行，一般用来处理操作前的内容,比如一些创建对象，初始化等； `__exit__()` 方法在 with 内的代码执行完毕后执行，一般用来处理一些善后收尾工作，比如文件的关闭，数据库的关闭等。

简单来说，上下文管理器的原理过程如下：

- 调用`__enter__()`方法，进行预处理操作
- 执行用户操作
- 调用 `__exit__()` 方法，完成清理操作

# 2.应用场景

资源管理功能，即文件处理、网络连接、数据库连接等操作时需要关闭资源。

也可以在代码执行前后增加功能，类似于装饰器，比如代码之前做权限验证等。

如数据库连接的使用：

```python
import pymysql

class DBConnection(object):
    def __init__(self,ip,user,passwd,db):
        self.ip = ip
        self.user = user
        self.passwd = passwd
        self.db = db

    def __enter__(self):
        self.conn = pymysql.connect(self.ip, user=self.user, passwd=self.passwd, db=self.db)
        self.cur = conn.cursor()
        return self.cur

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.cur.close()
        self.conn.close()

with DBConnection('192.168.121.xxx', user="xxx", passwd="123456", db="xxx") as cur:
    cur.execute("select * from studnet;")
    result = cur.fetchall()
    print(result)
```

完成 DBConnection 这个类，每次连接数据库时，只要简单的调用 with 语句即可，不需要关心数据库的关闭、异常等。

# 3.上下文管理器的使用

## 3.1 用类实现

```python
#自定义一个上下文管理类
class MyOpen():
    def __init__(self):
        print("初始化方法")
    def __enter__(self):
        print("执行enter方法")
    def __exit__(self, exc_type, exc_val, exc_tb):
        print("执行exit方法")

print("===实例化对象====")
t= MyOpen()
print("===with语句====")
with MyOpen() as f:
    print("执行代码")
```

输出结果如下：

```plain
===实例化对象====
初始化方法
===with语句====
初始化方法
执行enter方法
执行代码
执行exit方法
```

在实例化对象时，并不会调用`__enter__()`方法，一般使用 with 语句，开启一个上下文环境，进入 with 语句块调用`__enter__()`方法，然后执行语句体，离开 with 语句块时，调用 `__exit__()` 方法。

## 3.2 用模块 contextlib

[@contextmanager ](/contextmanager) 装饰器能减少创建上下文管理器的样板代码量，因为不用编写一个完整的类，定义 `__enter__()`和 `__exit__()`方法，而只需实现有一个 `yield`语句的生成器，生成想让 `__enter__()`方法返回的值。

在使用 [@contextmanager ](/contextmanager) 装饰的生成器中，yield 语句的作用是把函数的定义体分成两部分：yield 语句前面的所有代码在 with 块开始时（即解释器调用 `__enter__()`方法时）执行， yield 语句后面的代码在 with 块结束时（即调用 `__exit__()`方法时）执行。

```python
import contextlib

@contextlib.contextmanager
def context_manager():
    conn = pymysql.connect('192.168.121.xxx', user="xxx", passwd="123456", db="xxx")
    cur = conn.cursor()
    yield cur
    cur.close()
    conn.close()

with context_manager() as cur:
    cur.execute("select * from student;")
    result = cur.fetchall()
    print(result)
```

# 4.上下文管理器的异常处理

根据上下文管理的原理,上下文管理器的原理是实现了`__enter__()`和 `__exit__()` 这两个方法,所以我们可以根据此原理来自定义自己的上下文管理器。

```python
class MyOpen(object):
    """自定义上下文管理类"""

    def __init__(self, file, mode):
        self._file = file
        self._mode = mode

    def __enter__(self):
        self._handle = open(self._file, self._mode)
        return self._handle

    def __exit__(self, exc_type, exc_val, exc_tb):
        print('Type: ', exc_type)
        print('Value:', exc_val)
        print('TreacBack:', exc_tb)
        self._handle.close()
# 读的模式打开文件,进行写操作，不支持
with MyOpen('123.txt', 'r') as f:
    f.write('python')
```

当 with 中执行的语句发生异常时，异常信息会被发送到 `__exit__()`方法的参数中， `__exit__()` 方法有如下三个参数:

- exc_type : 异常类型
- exc_val : 异常值
- exc_tb : 异常回溯追踪

这三个参数都与异常有关，with 语句会把异常的 exc_type ,exc_val 和 exc_tb 传递给 `__exit__()` 方法，它让`__exit__()` 方法来处理异常 ，如果`__exit__()`返回的是 True，那么这个异常就被忽略，并按照我们定义的方式进行抛出。如果`__exit__()`返回的是 True 以外的任何东西，那么这个异常将被 with 语句抛出。

```python
class MyOpen(object):
    """自定义上下文管理类"""

    def __init__(self, file, mode):
        self._file = file
        self._mode = mode

    def __enter__(self):
        self._handle = open(self._file, self._mode)
        return self._handle

    def __exit__(self, exc_type, exc_val, exc_tb):
        print("代码执行到了__exit__......")
        # 在这里进行异常处理
        if exc_type == None:
            print('程序没问题')
        else:
            print('程序有问题，如果你能你看懂，问题如下：')
            print('Type: ', exc_type)
            print('Value:', exc_val)
            print('TreacBack:', exc_tb)

# 读的模式打开文件,进行写操作，不支持
with MyOpen('123.txt', 'r') as f:
    f.write('python')
```

所以，with 语法不仅可以简化资源操作的后续清除操作，还可以代替 try/finally 进行异常处理。
