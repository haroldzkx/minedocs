Python 标准库: [https://docs.python.org/zh-cn/3.13/library/index.html](https://docs.python.org/zh-cn/3.13/library/index.html)

<details>
<summary>1.基础语法</summary>

变量与数据类型：int、str、float、bool、list、dict、set、tuple

控制流：if/elif/else、for、while、break/continue

函数定义：def、参数、默认参数、可变参数、返回值

模块与包管理：

- `import xxx` / `from xxx import xxx` / `from xxx import xxx as xxx`
- `__init__.py`、模块路径、搜索顺序
- `__name__ == '__main__'`

异常与调试：

- try/except/finally、raise、assert
- 自定义异常类
- traceback、pdb
- logging, loguru

文件与IO操作：

- 文件读写：open()、with 上下文管理
- 文本文件、二进制文件、JSON、CSV
- os.path / pathlib

</details>

<details>
<summary>2.高级语法特性</summary>

装饰器：函数装饰器、带参数的装饰器、类装饰器

迭代器：`__iter__` / `__next__`、yield、生成器表达式

生成器：

上下文管理器：

- with
- 自定义类实现 `__enter__` 与 `__exit__`

列表/集合/字典推导式

类型注解与静态检查：

- typing 模块：List、Dict、Union、Optional
- mypy、pyright

模式匹配：match/case

</details>

<details>
<summary>3.函数式编程</summary>

匿名函数：lambda

内建函数：map()、filter()、reduce()、zip()、enumerate()

闭包与作用域：nonlocal、自由变量

装饰器再次加强（函数是“一等对象”）

偏函数：functools.partial

高阶函数：函数返回函数 / 接收函数

不可变性思想与纯函数设计

</details>

<details>
<summary>4.面向对象编程</summary>

类定义与实例化

属性、方法、类变量、实例变量

`__init__`、`__str__`、`__repr__`、`__eq__` 等魔术方法

继承

多态

封装

组合

抽象类与接口：abc 模块

类方法与静态方法：@classmethod / @staticmethod

数据类：@dataclass

元类 metaclass

</details>

<details>
<summary>5.网络编程</summary>

socket 编程基础

- 创建 TCP / UDP 套接字
- 套接字绑定与监听
- 客户端连接与数据发送接收
- 服务端接收连接与响应
- 套接字关闭与资源释放
- 设置超时 / 非阻塞模式

并发网络通信模型（基于 socket）

- 多线程 socket 通信模型
- 线程池处理客户端连接
- select I/O 多路复用模型
- 非阻塞 socket 与事件驱动处理
- asyncio 异步网络通信模型
- 协程式 TCP 服务器 / 客户端构建

HTTP 请求客户端库（高层接口）

- 使用 requests 发送常见请求（GET、POST 等）
- 添加请求参数与请求头
- 处理响应文本 / JSON 内容
- 使用 Session 管理连接与 Cookie
- 请求超时设置与异常处理

Python 标准库中的 HTTP 支持

- 使用 http.client 构建底层 HTTP 请求
- 使用 urllib.request 下载网页 / 文件
- 响应体读取与字符编码处理

网络编程实战方向（仅基于 Python）

- TCP 聊天室服务端与客户端
- UDP 简易收发程序
- 多客户端并发服务端模型（线程 / asyncio）
- 基于 requests / urllib 的网络爬取工具
- 基于 socket 的端口扫描器

</details>

<details>
<summary>6.并发编程</summary>
多线程，多进程，协程，异步IO，并发模型，GIL机制

多线程：threading 模块

- 线程启动、锁、死锁、Queue

多进程：multiprocessing 模块

- 进程间通信、共享变量、进程池

协程：async def、await、asyncio、事件循环

并发模型对比：同步 vs 异步、并发 vs 并行、协程适合IO密集

GIL 机制：

- 解释什么是 GIL，为何影响 CPU 密集性能
- 如何用进程或 C 扩展绕开 GIL

</details>

<details>
<summary>7.库</summary>

常用标准库：os、sys、datetime、collections、itertools、json

实用第三方库：

- 数据分析：numpy、pandas
- 可视化：matplotlib, seaborn
- 网络请求：requests

调试工具：logging、pdb、traceback、warnings

虚拟环境与包管理：

- venv、pip、requirements.txt
- pipenv、poetry

</details>

<details>
<summary>8.性能优化与原理</summary>

Python 解释器：

- CPython 工作机制
- PyPy
- MicroPython
- Cython

GIL 深入解析

内存与引用计数机制

性能分析工具：timeit、cProfile、line_profiler

C 扩展：

- Python C API 入门
- 使用 ctypes / cffi 调用 C 库

C++扩展：

- pybind11
- Boost.Python

JIT 编译器

并行计算框架：numba、joblib

分布式框架：Ray

</details>

<details>
<summary>9.架构设计与项目组织</summary>

</details>

---

<details>
<summary>使用 C/C++ 扩展 Python</summary>

在大型项目中，Cython 处理高层逻辑，pybind11 封装底层 C++ 模块。

Cython 的使用场景：

- 需要优化纯 Python 代码（如科学计算、数据处理）。
- 混合 Python 与 C/C++的项目，逐步迁移关键代码到 C。
- 对 C++高级特性（如模板）依赖较少。

pybind11

pybind11官网: [https://pybind11.readthedocs.io/en/stable/](https://pybind11.readthedocs.io/en/stable/)

pybind11 使用场景：已有 C++ 代码，封装起来让 python 调用

</details>