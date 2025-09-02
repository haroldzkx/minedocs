

<details>
<summary>网络编程</summary>

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
<summary>并发编程</summary>
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
<summary>性能优化与原理</summary>

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
