普通装饰器，带参数的装饰器，类装饰器，带参数的类装饰器

# 装饰器

```python
import functools
def decorator(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        return func(*args, **kwargs)
    return wrapper
```

# 带参数的装饰器

```python
def logging(level):
    def outwrapper(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            print("[{0}]: enter {1}()".format(level, func.__name__))
            return func(*args, **kwargs)
        return wrapper
    return outwrapper

@logging(level="INFO")
def hello(a, b, c):
    print(a, b, c)

hello("hello,","good","morning")
```

运行结果：

```python
[INFO]: enter hello()
hello, good morning
```

# 类装饰器

使用类装饰器主要依靠类的`__call__`方法

```python
class Foo(object):
    def __init__(self, func):
        self._func = func

    def __call__(self, *args, **kwargs):
        print('class decorator runing')
        self._func(*args, **kwargs)
        print('class decorator ending')

@Foo
def bar():
    print('bar')

bar()
```

运行结果

```latex
class decorator runing
bar
class decorator ending
```

# 带参数的类装饰器

```python
class logging(object):
    def __init__(self, level):
        self.level = level

    def __call__(self, func):
        def wrapper(*args, **kwargs):
            print(f"[{self.level}]: enter {func.__name__}()")
            return func(*args, **kwargs)
        return wrapper

@logging(level="TEST")
def hello(a, b, c):
    print(a, b, c)

hello("hello,","good","morning")
```

运行结果：

```latex
[TEST]: enter hello()
hello, good morning
```

# 实例

## 计时装饰器

```python
import functools
import time
from loguru import logger

def count_time(module_name):
    def outwrapper(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            start = time.time()
            func(*args, **kwargs)
            end = time.time()
            logger.debug( f'{module_name} cost time -> {end - start} s.' )
        return wrapper
    return outwrapper

@count_time(module_name='test_func')
def test_func():
    pass
```
