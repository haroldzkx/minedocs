# 语法基础

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
- 为什么要加上 `@functools.wraps(func)` 这一行语句
- 类装饰器：依靠类的 `__call__` 方法实现
- 带参数的装饰器：在普通装饰器外面再加一层函数，三层函数嵌套。外层函数接收参数，内层函数接收被装饰的函数
- 带参数的类装饰器：在 `__init__`方法里添加参数，然后在 `__call__` 中使用 `self.xxx`调用传入的参数

上下文管理器:

- [https://docs.python.org/zh-cn/3/library/stdtypes.html#context-manager-types](https://docs.python.org/zh-cn/3/library/stdtypes.html#context-manager-types)
- [https://docs.python.org/zh-cn/3/library/contextlib.html](https://docs.python.org/zh-cn/3/library/contextlib.html)
- [https://docs.python.org/zh-cn/3/reference/datamodel.html#context-managers](https://docs.python.org/zh-cn/3/reference/datamodel.html#context-managers)

并发: [concurrent](./concurrent.md)

- 多线程: [thread](./concurrent.md#多线程-threading)
- 多进程: [multiprocessing](./concurrent.md#多进程-multiprocessing)
- 协程: [asyncio](./concurrent.md#协程-asyncio)

日志处理: [logging, loguru](./log.md)

编程规范（变量与注释）: [var](./var.md)

# 工具

[Python Docker 环境](./env.md)

[Mkdocs 构建网站](./mkdocs.md)

# Python 与 C++ 混合编程

Cython 的使用场景：

- 需要优化纯 Python 代码（如科学计算、数据处理）。
- 混合 Python 与 C/C++的项目，逐步迁移关键代码到 C。
- 对 C++高级特性（如模板）依赖较少。

pybind11 使用场景：已有 C++ 代码，封装起来让 python 调用

在大型项目中，Cython 处理高层逻辑，pybind11 封装底层 C++ 模块。

# 第三方库

邮件处理：notifiers
日志：logging, loguru(rec)
路径操作：pathlib(rec)
测试：unittest, pytest
虚拟环境：venv, virtualenv, pipenv, poetry, miniconda
参数解析与配置管理：argparse, yacs(rec)
数据处理：numpy, numba, pandas, Swifter

[PyTorch](./pytorch.md)

# Web

同步和异步的 web 部署方式：

- WSGI：同步。通过多进程+多线程的方式实现并发。
- ASGI：异步。通过多进程+主线程（不存在多线程）+协程的方式实现并发。
