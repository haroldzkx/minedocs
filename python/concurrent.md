# 并发

并发执行: [https://docs.python.org/zh-cn/3.13/library/concurrency.html](https://docs.python.org/zh-cn/3.13/library/concurrency.html)

Queue: [https://docs.python.org/zh-cn/3.13/library/queue.html](https://docs.python.org/zh-cn/3.13/library/queue.html)

网络和进程间通信: [https://docs.python.org/zh-cn/3.13/library/ipc.html](https://docs.python.org/zh-cn/3.13/library/ipc.html)

## 对 Python 并发编程的理解

并发：多线程，协程（单线程 + 异步 I/O）

并行：多进程

Python 高并发方案：多进程 + 主线程 + 协程

IO 密集型（不用 CPU）：多线程

计算密集型（用 CPU）：多进程

并发与并行的区别：

- 你吃饭吃到一半，电话来了，你一直到吃完了以后才去接，这就说明你不支持并发也不支持并行。
- 你吃饭吃到一半，电话来了，你停了下来接了电话，接完后继续吃饭，这说明你支持并发。
- 你吃饭吃到一半，电话来了，你一边打电话一边吃饭，这说明你支持并行。
- 并发的关键是你有处理多个任务的能力，不一定要同时。（轮换使用 CPU 资源）
- 并行的关键是你有同时处理多个任务的能力。

当线程仅包含纯 Python 代码时，使用线程来加速程序没有什么意义，因为 GIL 会将其串行化。但 GIL 只是强制在任何时候只有一个线程可以执行 Python 代码。实际上，全局解释器锁在许多阻塞系统调用上被释放，并且可以在不使用任何 Python/C API 函数的 C 扩展的部分中被释放。这意味着，多个线程可以执行 I/O 操作或在某些第三方扩展中并行执行 C 代码。即当用 C/C++ 扩展 Python 时可以绕过 GIL 锁。

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

- 高层级 API 索引: [https://docs.python.org/zh-cn/3.13/library/asyncio-api-index.html](https://docs.python.org/zh-cn/3.13/library/asyncio-api-index.html)
- 低层级 API 索引: [https://docs.python.org/zh-cn/3.13/library/asyncio-llapi-index.html](https://docs.python.org/zh-cn/3.13/library/asyncio-llapi-index.html)
- 用 asyncio 开发: [https://docs.python.org/zh-cn/3.13/library/asyncio-dev.html](https://docs.python.org/zh-cn/3.13/library/asyncio-dev.html)

协程: [https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#coroutines](https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#coroutines)

协程函数, `async for`, `async with`: [https://docs.python.org/zh-cn/3.13/reference/compound_stmts.html#coroutines](https://docs.python.org/zh-cn/3.13/reference/compound_stmts.html#coroutines)

协程内置函数 `current_task`, `all_tasks`, `iscoroutine`: [https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#introspection](https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#introspection)

协程与任务: [https://docs.python.org/zh-cn/3.13/library/asyncio-task.html](https://docs.python.org/zh-cn/3.13/library/asyncio-task.html)

可等待对象: 协程, 任务和 Future。【也就是可以加await关键字的对象】

- [https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#awaitables](https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#awaitables)
- [https://docs.python.org/zh-cn/3.13/reference/datamodel.html#awaitable-objects](https://docs.python.org/zh-cn/3.13/reference/datamodel.html#awaitable-objects)
- 协程对象: [https://docs.python.org/zh-cn/3.13/reference/datamodel.html#coroutine-objects](https://docs.python.org/zh-cn/3.13/reference/datamodel.html#coroutine-objects)

任务 Task（并发运行多个协程）:

- Task 对象: [https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#task-object](https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#task-object)
- 创建任务: [https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#creating-tasks](https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#creating-tasks)
- 取消任务: [https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#task-cancellation](https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#task-cancellation)
- 任务组: [https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#task-groups](https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#task-groups)
- 终结一个任务组: [https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#terminating-a-task-group](https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#terminating-a-task-group)
- 并发运行任务（不推荐，推荐使用 TaskGroup）: [https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#running-tasks-concurrently](https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#running-tasks-concurrently)
- 主动任务工厂: [https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#eager-task-factory](https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#eager-task-factory)

休眠函数 sleep: [https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#sleeping](https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#sleeping)

超时 timeout: [https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#timeouts](https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#timeouts)

屏蔽取消操作: [https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#shielding-from-cancellation](https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#shielding-from-cancellation)

简单等待: [https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#waiting-primitives](https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#waiting-primitives)

线程中的协程

- 协程调用阻塞函数（将阻塞操作放入新的线程中）: [https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#running-in-threads](https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#running-in-threads)
- 跨线程调度: [https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#scheduling-from-other-threads](https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#scheduling-from-other-threads)

运行 asyncio 程序（运行器）

- 运行 asyncio 程序: [https://docs.python.org/zh-cn/3.13/library/asyncio-runner.html#running-an-asyncio-program](https://docs.python.org/zh-cn/3.13/library/asyncio-runner.html#running-an-asyncio-program)
- 使用上下文管理器运行 asyncio 程序: [https://docs.python.org/zh-cn/3.13/library/asyncio-runner.html#runner-context-manager](https://docs.python.org/zh-cn/3.13/library/asyncio-runner.html#runner-context-manager)
- 处理键盘中断: [https://docs.python.org/zh-cn/3.13/library/asyncio-runner.html#handling-keyboard-interruption](https://docs.python.org/zh-cn/3.13/library/asyncio-runner.html#handling-keyboard-interruption)

同步原语

- Lock: [https://docs.python.org/zh-cn/3.13/library/asyncio-sync.html#lock](https://docs.python.org/zh-cn/3.13/library/asyncio-sync.html#lock)
- Event: [https://docs.python.org/zh-cn/3.13/library/asyncio-sync.html#event](https://docs.python.org/zh-cn/3.13/library/asyncio-sync.html#event)
- Condition: [https://docs.python.org/zh-cn/3.13/library/asyncio-sync.html#condition](https://docs.python.org/zh-cn/3.13/library/asyncio-sync.html#condition)
- Semaphore: [https://docs.python.org/zh-cn/3.13/library/asyncio-sync.html#semaphore](https://docs.python.org/zh-cn/3.13/library/asyncio-sync.html#semaphore)
- BoundedSemaphore: [https://docs.python.org/zh-cn/3.13/library/asyncio-sync.html#boundedsemaphore](https://docs.python.org/zh-cn/3.13/library/asyncio-sync.html#boundedsemaphore)
- Barrier: [https://docs.python.org/zh-cn/3.13/library/asyncio-sync.html#barrier](https://docs.python.org/zh-cn/3.13/library/asyncio-sync.html#barrier)

队列集 Queue: [https://docs.python.org/zh-cn/3.13/library/asyncio-queue.html](https://docs.python.org/zh-cn/3.13/library/asyncio-queue.html)

事件循环:

- [https://docs.python.org/zh-cn/3.13/library/asyncio-eventloop.html#](https://docs.python.org/zh-cn/3.13/library/asyncio-eventloop.html#)
- uvloop: 是 asyncio 的事件循环替代方案。用 Cython 写的，使 asyncio 更快。[https://uvloop.readthedocs.io/](https://uvloop.readthedocs.io/)
- 事件循环策略: [https://docs.python.org/zh-cn/3.13/library/asyncio-policy.html#policies](https://docs.python.org/zh-cn/3.13/library/asyncio-policy.html#policies)

异步和非异步模块混合编程:

- 异步调用阻塞的同步函数（线程池的方式，使用多线程来将同步代码变成异步代码）: 使用 `asyncio.to_thread` 或 `loop.run_in_executor`。[https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#running-in-threads](https://docs.python.org/zh-cn/3.13/library/asyncio-task.html#running-in-threads)
- 非异步调用异步: 使用 `asyncio.run`。

异步迭代器: [https://docs.python.org/zh-cn/3.13/reference/datamodel.html#asynchronous-iterators](https://docs.python.org/zh-cn/3.13/reference/datamodel.html#asynchronous-iterators)

异步上下文管理器: [https://docs.python.org/zh-cn/3.13/reference/datamodel.html#asynchronous-context-managers](https://docs.python.org/zh-cn/3.13/reference/datamodel.html#asynchronous-context-managers)

异步装饰器: 在最内层的函数里添加 `async`和 `await`就行，其他的跟同步装饰器一样
