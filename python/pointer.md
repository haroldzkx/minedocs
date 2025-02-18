GIL 全局解释器锁: [https://time.geekbang.org/column/intro/100026901?tab=catalog](https://time.geekbang.org/column/intro/100026901?tab=catalog)

垃圾回收机制: [https://time.geekbang.org/column/intro/100026901?tab=catalog](https://time.geekbang.org/column/intro/100026901?tab=catalog)

代码调试 debug: [https://time.geekbang.org/column/intro/100026901?tab=catalog](https://time.geekbang.org/column/intro/100026901?tab=catalog)

# 基础

模块与包: [https://docs.python.org/zh-cn/3.13/tutorial/modules.html](https://docs.python.org/zh-cn/3.13/tutorial/modules.html)

生成器:

- [https://docs.python.org/zh-cn/3/library/stdtypes.html#generator-types](https://docs.python.org/zh-cn/3/library/stdtypes.html#generator-types)
- 生成器表达式: [https://docs.python.org/zh-cn/3/reference/expressions.html#generator-expressions](https://docs.python.org/zh-cn/3/reference/expressions.html#generator-expressions)
- yield 表达式: [https://docs.python.org/zh-cn/3/reference/expressions.html#yield-expressions](https://docs.python.org/zh-cn/3/reference/expressions.html#yield-expressions)

迭代器:

- [https://docs.python.org/zh-cn/3/library/stdtypes.html#iterator-types](https://docs.python.org/zh-cn/3/library/stdtypes.html#iterator-types)

- 类迭代器: [https://docs.python.org/zh-cn/3.13/tutorial/classes.html#iterators](https://docs.python.org/zh-cn/3.13/tutorial/classes.html#iterators)

装饰器: [decorator](./decorator.md)

- 普通装饰器 functools.wraps: [https://docs.python.org/zh-cn/3.13/library/functools.html#functools.wraps](https://docs.python.org/zh-cn/3.13/library/functools.html#functools.wraps)

- 类装饰器

  ```python
  # 使用类装饰器主要依靠类的 __call__ 方法
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
  # 运行结果
  class decorator runing
  bar
  class decorator ending
  ```

- 带参数的装饰器

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
  # 运行结果：
  [INFO]: enter hello()
  hello, good morning
  ```

- 带参数的类装饰器

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
  # 运行结果：
  [TEST]: enter hello()
  hello, good morning
  ```

上下文管理器:

- [https://docs.python.org/zh-cn/3/library/stdtypes.html#context-manager-types](https://docs.python.org/zh-cn/3/library/stdtypes.html#context-manager-types)
- [https://docs.python.org/zh-cn/3/library/contextlib.html](https://docs.python.org/zh-cn/3/library/contextlib.html)
- [https://docs.python.org/zh-cn/3/reference/datamodel.html#context-managers](https://docs.python.org/zh-cn/3/reference/datamodel.html#context-managers)

并发: [concurrent](./concurrent.md)

- 多线程: [thread](./concurrent.md#多线程-threading)
- 多进程: [multiprocessing](./concurrent.md#多进程-multiprocessing)
- 协程: [asyncio](./concurrent.md#协程-asyncio)

# 第三方库

邮件处理：notifiers
日志：logging, loguru(rec)
路径操作：pathlib(rec)
测试：unittest, pytest
虚拟环境：venv, virtualenv, pipenv, poetry, miniconda
参数解析与配置管理：argparse, yacs(rec)
数据处理：numpy, numba, pandas, Swifter
