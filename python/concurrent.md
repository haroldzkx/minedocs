# 并发

并发执行: [https://docs.python.org/zh-cn/3.13/library/concurrency.html](https://docs.python.org/zh-cn/3.13/library/concurrency.html)

Queue:[https://docs.python.org/zh-cn/3.13/library/queue.html](https://docs.python.org/zh-cn/3.13/library/queue.html)

网络和进程间通信: [https://docs.python.org/zh-cn/3.13/library/ipc.html](https://docs.python.org/zh-cn/3.13/library/ipc.html)

## 对 Python 并发编程的理解

并发编程是刚需，尤其是在多 I/O 操作时，多线程，协程，多进程三路英雄各显神通。

多线程，协程属于并发操作，多进程属于并行操作。

并发与并行的区别：

- 你吃饭吃到一半，电话来了，你一直到吃完了以后才去接，这就说明你不支持并发也不支持并行。
- 你吃饭吃到一半，电话来了，你停了下来接了电话，接完后继续吃饭，这说明你支持并发。
- 你吃饭吃到一半，电话来了，你一边打电话一边吃饭，这说明你支持并行。
- 并发的关键是你有处理多个任务的能力，不一定要同时。
- 并行的关键是你有同时处理多个任务的能力。

多线程，多进程，协程的概念：

- 多线程（threading）在 Python 里，由于有全局锁 (GIL) 的存在，并发就是多个线程轮流使用 CPU，同一时刻只一个线程在工作，操作系统会在合适的时间进行切换，由于线程的切换速度非常快，给人的感觉是多个任务都在运行。在 I/O 密集型任务场景中，线程切换后，I/O 操作仍然在进行，线程 1 在进行 I/O 操作时，线程 2 可以获得 CPU 资源进行计算，虽然增加了切换成本，却提高了效率。
- 协程（asyncio）协程是轻量级线程，是单线程，却可以执行并发任务，原因是协程把切换的权利交给程序员，与程序员决定在哪些环节进行切换。协程可以处理上万的并发，多线程即不可以，因为切换成本太大，会耗尽计算机资源。
- 多进程（futures、Multiprocessing）
  并行，真正的同一时刻多个任务同时进行。如果想使用多核，就选多进程。

在 Python 语言中，单线程+异步 I/O 的编程模型称为协程，有了协程的支持，就可以基于事件驱动编写高效的多任务程序。
协程最大的优势就是极高的执行效率，因为子程序切换不是线程切换，而是由程序自身控制，因此，没有线程切换的开销。
协程的第二个优势就是不需要多线程的锁机制，因为只有一个线程，也不存在同时写变量冲突，在协程中控制共享资源不用加锁，只需要判断状态就好了，所以执行效率比多线程高很多。

**如果想要充分利用 CPU 的多核特性，最简单的方法是多进程+协程，既充分利用多核，又充分发挥协程的高效率，可获得极高的性能。**

**Python 中实现并发编程的三种方案：多线程、多进程和异步 I/O。**

并发编程的好处在于可以提升程序的执行效率以及改善用户体验；

坏处在于并发的程序不容易开发和调试，同时对其他程序来说它并不友好。

当线程仅包含纯 Python 代码时，使用线程来加速程序没有什么意义，因为 GIL 会将其串行化。但 GIL 只是强制在任何时候只有一个线程可以执行 Python 代码。实际上，全局解释器锁在许多阻塞系统调用上被释放，并且可以在不使用任何 Python/C API 函数的 C 扩展的部分中被释放。这意味着，多个线程可以执行 I/O 操作或在某些第三方扩展中并行执行 C 代码。即当用 C/C++扩展 Python 时可以绕过 GIL 锁。

1. 多线程和多进程的比较
   以下情况需要使用多线程： - 程序需要维护许多共享的状态（尤其是可变状态），Python 中的列表、字典、集合都是线程安全的，所以使用线程而不是进程维护共享状态的代价相对较小。 - 程序会花费大量时间在 I/O 操作上，没有太多并行计算的需求且不需占用太多的内存。

以下情况需要使用多进程：

- 程序执行计算密集型任务（如：字节码操作、数据处理、科学计算）。
- 程序的输入可以并行的分成块，并且可以将运算结果合并。
- 程序在内存使用方面没有任何限制且不强依赖于 I/O 操作（如：读写文件、套接字等）。

2. 异步 I/O 与多进程的比较
   当程序不需要真正的并发性或并行性，而是更多的依赖于异步处理和回调时，asyncio 就是一种很好的选择。
   如果程序中有大量的等待与休眠时，也应该考虑 asyncio，它很适合编写没有实时数据处理需求的 Web 应用服务器。

IO 密集型（不用 CPU）：多线程

计算密集型（用 CPU）：多进程

协程不是计算机提供的，是程序员认为创造。

协程（Coroutine），也被称为微线程，是一种用户态内的上下文切换技术。

简而言之，其实就是通过一个线程实现代码相互切换执行。

协程的意义：在一个线程中如果遇到 IO 等待时间，线程不会傻傻等，利用空闲的时候再去干点其他事。

## 效率对比：多线程，多进程

将不加线程和进程的代码、多线程、多进程的三种代码进行效率对比。

```python
import functools
import time
import multiprocessing as mp
import threading as td
from loguru import logger

def count_time(level):
    def outwrapper(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            start = time.time()
            func(*args, **kwargs)
            end = time.time()
            logger.debug( f'{level}: count time -> {end - start}' )
        return wrapper
    return outwrapper

def job_1(q, numb):
    res = 0
    for i in range(numb):
        res += i + i**2 + i**3
    q.put(res)

@count_time(level='Multiprocess')
def multicore():
    q = mp.Queue()
    p1 = mp.Process(target=job_1, args=(q, 10000000))
    p2 = mp.Process(target=job_1, args=(q, 10000000))
    p1.start()
    p2.start()
    p1.join()
    p2.join()
    res1 = q.get()
    res2 = q.get()
    logger.debug( f'Multiprocess: res1 -> {res1}, res2 -> {res2}' )

@count_time(level='Normal')
def normal():
    res = 0
    for _ in range(2):
        for i in range(10000000):
            res += i + i**2 + i**3
    logger.debug( f'Normal: {res}' )

@count_time(level='Thread')
def multithread():
    q = mp.Queue()
    t1 = td.Thread(target=job_1, args=(q, 10000000))
    t2 = td.Thread(target=job_1, args=(q, 10000000))
    t1.start()
    t2.start()
    t1.join()
    t2.join()
    res1 = q.get()
    res2 = q.get()
    logger.debug( f'Thread: res1 -> {res1}, res2 -> {res2}' )

def main():
    normal()
    multithread()
    multicore()


if __name__ == '__main__':
    main()
```

输出结果：

```python
Normal: 4999999666666716666660000000
Normal: count time -> 15.261656045913696
Thread: res1 -> 2499999833333358333330000000, res2 -> 2499999833333358333330000000
Thread: count time -> 14.838425874710083
Multiprocess: res1 -> 2499999833333358333330000000, res2 -> 2499999833333358333330000000
Multiprocess: count time -> 7.743632078170776
```

从结果可以看到，单线程与多线程的耗时没有什么区别

而多进程明显用时少了很多。

# 多线程 threading

常用函数: [https://docs.python.org/zh-cn/3.13/library/threading.html](https://docs.python.org/zh-cn/3.13/library/threading.html#threading.active_count)

线程对象: [https://docs.python.org/zh-cn/3.13/library/threading.html#thread-objects](https://docs.python.org/zh-cn/3.13/library/threading.html#thread-objects)

锁对象: [https://docs.python.org/zh-cn/3.13/library/threading.html#lock-objects](https://docs.python.org/zh-cn/3.13/library/threading.html#lock-objects)

线程是不能返回值的，如果需要返回值，就需要使用 Queue 存入线程产生的数据

# 多进程 multiprocessing

Process 类: [https://docs.python.org/zh-cn/3.13/library/multiprocessing.html#the-process-class](https://docs.python.org/zh-cn/3.13/library/multiprocessing.html#the-process-class)

在进程之间交换对象（数据）: [https://docs.python.org/zh-cn/3.13/library/multiprocessing.html#exchanging-objects-between-processes](https://docs.python.org/zh-cn/3.13/library/multiprocessing.html#exchanging-objects-between-processes) 每个进程运算结果都存入队列中，等所有进程运算结束，再从队列中取得结果。

使用工作进程（进程池 Pool）: [https://docs.python.org/zh-cn/3.13/library/multiprocessing.html#using-a-pool-of-workers](https://docs.python.org/zh-cn/3.13/library/multiprocessing.html#using-a-pool-of-workers)

进程池 Pool 类: [https://docs.python.org/zh-cn/3.13/library/multiprocessing.html#multiprocessing.pool.Pool](https://docs.python.org/zh-cn/3.13/library/multiprocessing.html#multiprocessing.pool.Pool)

# 协程 asyncio

Asyncio: [https://docs.python.org/zh-cn/3.13/library/asyncio.html](https://docs.python.org/zh-cn/3.13/library/asyncio.html)

协程与任务: [https://docs.python.org/zh-cn/3.13/library/asyncio-task.html](https://docs.python.org/zh-cn/3.13/library/asyncio-task.html)

uvloop: 是 asyncio 的事件循环替代方案。用 Cython 写的，使 asyncio 更快。[https://uvloop.readthedocs.io/](https://uvloop.readthedocs.io/)

异步和非异步模块混合编程:

```python
"""异步和非异步模块混合编程"""
# 案例：asyncio+不支持异步的模块
import asyncio
import requests
from loguru import logger

async def download_image(url):
    # 发送网络请求，下载图片（遇到网络下载图片的IO请求，自动化切换到其他任务）
    logger.debug(f'开始下载：{url}')
    loop = asyncio.get_event_loop()
    # requests模块默认不支持异步操作，所以就使用线程池来配合实现了
    future = loop.run_in_executor(None, requests.get, url)

    response = await future
    logger.info('下载完成')
    # 图片保存到本地文件
    file_name = url.rsplit('_')[-1]
    with open(file_name, mode='wb') as file_object:
        file_object.write(response.content)

if __name__ == '__main__':
    url_list = {
        'https://img.dahepiao.com/uploads/image/2021/01/05/122deec15b82d43186bc1e64a886af6e.jpg',
        'https://img.zcool.cn/community/01a0b65c9f429ea801208f8bf23be1.jpg@1280w_1l_2o_100sh.jpg',
        'https://www.qqkw.com/d/file/p/2018/05-09/e38a7138efaf9a87efaaf40ed75d52ed.jpg'
    }

    tasks = [ download_image(url) for url in url_list ]
    loop = asyncio.get_event_loop()
    loop.run_until_complete( asyncio.wait(tasks) )
```

异步迭代器: [https://docs.python.org/zh-cn/3.13/reference/datamodel.html#asynchronous-iterators](https://docs.python.org/zh-cn/3.13/reference/datamodel.html#asynchronous-iterators)

异步上下文管理器: [https://docs.python.org/zh-cn/3.13/reference/datamodel.html#asynchronous-context-managers](https://docs.python.org/zh-cn/3.13/reference/datamodel.html#asynchronous-context-managers)

异步装饰器:

```python
"""异步装饰器"""
from function import wraps
import time

def count_time(func):
    @wraps(func)
    async def wrapper(*args, **kwargs):
        print(f"Start execuate function {func}, The function Parameter is {*args}, {**kwargs}")
        start = time.time()
        try:
            await func(*args, **kwargs)
        finally:
            end = time.time()
            total = end - start
            print(f"End execuate function {func}, Time use {total: .4f}")
    return wrapper
```
