# 【协程 & asyncio & 异步编程】

[https://www.bilibili.com/video/BV1Yr4y1L7bM](https://www.bilibili.com/video/BV1Yr4y1L7bM)

# 协程

协程不是计算机提供的，是程序员认为创造。

协程（Coroutine），也被称为微线程，是一种用户态内的上下文切换技术。

简而言之，其实就是通过一个线程实现代码相互切换执行。

实现协程有这么几种方法：

- greenlet，早期使用的模块
- yield 关键字
- asyncio 装饰器（python3.4 以后的）
- async、await 关键字（python3.5 以后的）【推荐】

## asyncio 实现协程

在 python3.4 及之后的版本中使用

```python
import asyncio

@asyncio.coroutine
def func1():
    print(1)
    yield from asyncio.sleep(2) # 遇到IO耗时操作，自动化切换到tasks中的其他任务
    print(2)

@asyncio.coroutine
def func2():
    print(3)
    yield from asyncio.sleep(2) # 遇到IO耗时操作，自动化切换到tasks中的其他任务
    print(4)

tasks = [
    asyncio.ensure_future( func1() ),
    asyncio.ensure_future( func2() )
]

loop = asyncio.get_event_loop()
loop.run_until_complete(asyncio.wait(tasks))
```

注：遇到 IO 阻塞自动切换

## async & await 关键字实现协程

在 python3.5 及之后的版本中使用

```python
import asyncio

async def func1():
    print(1)
    await asyncio.sleep(2) # 遇到IO耗时操作，自动化切换到tasks中的其他任务
    print(2)

async def func2():
    print(3)
    await asyncio.sleep(2) # 遇到IO耗时操作，自动化切换到tasks中的其他任务
    print(4)

tasks = [
    asyncio.ensure_future( func1() ),
    asyncio.ensure_future( func2() )
]

loop = asyncio.get_event_loop()
loop.run_until_complete(asyncio.wait(tasks))
```

## 总结

协程的意义：在一个线程中如果遇到 IO 等待时间，线程不会傻傻等，利用空闲的时候再去干点其他事。

# 异步编程

## 事件循环

理解成为一个死循环，去检测并执行某些代码。

```python
# 伪代码

任务列表 = [ 任务1, 任务2, 任务3, ...]

while True:
    可执行的任务列表, 已完成的任务列表 = 去任务列表中检查所有的任务，将‘可执行’和‘已完成’的任务返回

    for 就绪任务 in 可执行的任务列表:
        执行已就绪的任务

    for 已完成的任务 in 已完成的任务列表:
        在任务列表中移除 已完成的任务

    如果 任务列表 中的任务都已完成，则终止循环
```

```python
import asyncio

# 去生成或获取一个事件循环
loop = asyncio.get_event_loop()
# 将 任务 放到 任务列表
loop.run_until_complete( 任务 )
```

## 快速上手

协程函数，定义函数时候`async def 函数名`。

协程对象，执行`协程函数()`得到的就是协程对象。

```python
# 这就是一个协程函数
async def func():
    pass

# result就是一个协程对象
result = func()
```

注意：执行协程函数创建协程对象，函数内部代码不会执行。

如果想要运行协程函数内部代码，必须要将协程对象交给事件循环来处理。

```python
import asyncio

async def func():
    print('exec func for coroutine.')

result = func()

# python3.7及之前的版本
loop = asyncio.get_event_loop()
loop.run_until_complete( result )

# python3.7及之后的版本有一个简便写法
asyncio.run( result )
```

## await

await + 可等待的对象（协程对象、Future 对象、Task 对象 $\to$ IO 等待）

示例 1：

```python
import asyncio

async def func():
    print('step 1')
    response = await asyncio.sleep(2)
    print(f'result is {response}')

asyncio.run( func() )
```

示例 2：

```python
import asyncio

async def others():
    print('start')
    await asyncio.sleep(2)
    print('end')
    return 'return value'

async def func():
    print('execuate coroutine function inline code')
    # 遇到IO操作挂起当前协程（任务），等IO操作完成之后再继续往下执行，
    # 当前协程挂起时，事件循环可以去执行其他协程（任务）
    response = await others()
    print(f'IO request end, result is {response}')

asyncio.run( func() )
```

示例 3：

```python
import asyncio

async def others():
    print('start')
    await asyncio.sleep(2)
    print('end')
    return 'return value'

async def func():
    print('execuate coroutine function inline code')
    # 遇到IO操作挂起当前协程（任务），等IO操作完成之后再继续往下执行，
    # 当前协程挂起时，事件循环可以去执行其他协程（任务）
    response_1 = await others()
    print(f'IO request end, result-1 is {response_1}')
    response_2 = await others()
    print(f'IO request end, result-2 is {response_2}')

asyncio.run( func() )
```

await 就是等待对象的值得到结果之后再继续往下执行代码。

## Task 对象

在事件循环中添加多个任务的。

Tasks 用于并发调度协程，通过`asyncio.create_task(协程对象)`的方式创建 Task 对象，这样可以让协程加入事件循环中等待被调度执行。

除了使用`asyncio.create_task()`函数之外，还可以用低层级的`loop.create_task()`或`ensure_future()`函数。

不建议手动示例化 Task 对象。

注意：`asyncio.create_task()`函数在 Python3.7 中被加入，在 Python3.7 之前，可以改用低层级的`asyncio.ensure_future()`函数。

示例 1：（这种方式基本用不到）

```python
import asyncio

async def func():
    print(1)
    await asyncio.sleep(2)
    print(2)
    return 'return value'

async def main():
    print('main func start')

    # 创建Task对象，将当前执行func函数任务添加到事件循环中
    task_1 = asyncio.create_task( func() )
    # 创建Task对象，将当前执行func函数任务添加到事件循环中
    task_2 = asyncio.create_task( func() )

    print('main func end')

    # 当执行某协程遇到IO操作时，会自动化切换执行其他任务
    # 此时的await是等待相对应的协程全都执行完毕并获取结果
    ret_1 = await task_1
    ret_2 = await task_2
    print(ret1, ret2)

asyncio.run( main() )
```

示例 2：

```python
import asyncio

async def func():
    print(1)
    await asyncio.sleep(2)
    print(2)
    return 'return value'

async def main():
    print('main func start')

    task_list = [
        # 参数name可以自定义任务名称
        asyncio.create_task(func(), name='t1'),
        asyncio.create_task(func(), name='t2')
    ]

    print('main func end')
    # await后面只能跟task队形，协程对象，future对象，
    # 所以不能直接跟task_list
    # 需要用 asyncio.wait( task_list )来逐个等待对象
    # 参数timeout表示最长等待时间
    done, pending = await asyncio.wait(task_list, timeout=None)
    print(done)

asyncio.run( main() )
```

示例 3：

```python
import asyncio

async def func():
    print(1)
    await asyncio.sleep(2)
    print(2)
    return 'return value'

task_list = [
    func(),
    func(),
]

done, pending = asyncio.run( asyncio.wait( task_list ) )
print(done)
```

示例 4：

```python
async def greet(name, delay):
    await asyncio.sleep(delay)
    return f"hello, {name}"

async def main():
    async with asyncio.TaskGroup() as group:
        task1 = group.create_task(greet('xx', 2))
        task2 = group.create_task(greet('yy', 4))
    print(task1.result())
    print(task2.result())

if __name__ == "__main__":
    asyncio.run(main())
```

```python

```

## asyncio.Future 对象

Task 继承 Future，Task 对象内部 await 结果的处理基于 Future 对象来的。

```python
async def main():
    # 获取当前事件循环
    loop = asyncio.get_running_loop()

    # 创建一个任务（Future对象），这个任务什么都不干
    fut = loop.create_future()

    # 等待任务最终结果（Future对象），没有结果则会一直等下去
    await fut

asyncio.run( main() )
```

示例 2：

```python
import asyncio

async def set_after(fut):
    await asyncio.sleep(2)
    fut.set_result('666')

async def main():
    # 获取当前事件循环
    loop = asyncio.get_running_loop()

    # 创建一个任务（Future对象），没绑定任何行为，则这个任务永远不知道什么时候结束
    fut = loop.create_future()

    # 创建一个任务（Task对象），绑定了set_after函数，函数内部在2s之后，会给fut赋值
    # 即手动设置future任务的最终结果，那么fut就可以结束了
    await loop.create_task( set_after(fut) )

    # 等待Future对象获取 最终结果，否则一直等下去
    data = await fut
    print(data)

asyncio.run( main() )
```

## concurrent.futures.Future 对象

使用线程池、进程池实现异步操作时用到的对象

```python
import time
from concurrent.futures import Future
from concurrent.futures.thread import ThreadPoolExecutor
from concurrent.futures.process import ProcessPoolExecutor

def func(value):
    time.sleep(1)
    print(value)
    return 123

# 创建线程池
pool = ThreadPoolExecutor(max_workers=5)

# 创建进程池
# pool = ProcessPoolExecutor(max_workers=5)

for i in range(10):
    fut = pool.submit(func, i)
    print(fut)
```

以后写代码可能会交叉使用。

例如：CRM 项目 80%都是基于协程异步编程+MySQL（即第三方模块不支持异步时）【解决方案是用线程、进程做异步编程】

```python
import time
import asyncio
import concurrent.futures

def func1():
    # 某个耗时操作
    time.sleep(2)
    return 'func1 result'

async def main():
    loop = asyncio.get_running_loop()

    # 1.Run in the default loop's executor(默认ThreadPoolExecutor)
    # 第1步：内部会先调用ThreadPoolExecutor的submit方法去线程池中申请一个线程去执行func1函数，
    # 并返回一个concurrent.futures.Future对象
    # 第2步：调用asyncio.wrap_future将concurrent.futures.Future对象包装为asyncio.Future对象。
    # 因为concurrent.futures.Future对象不支持await语法，所以需要包装为asyncio.Future对象才能使用。
    fut = loop.run_in_executor(None, func1)
    result = await fut
    print(f'default thead pool {result}')

    # 2.Run in a custom thread pool:
    # with concurrent.futures.ThreadPoolExecutor() as pool:
    #     result = await loop.run_in_executor(
    #         pool, func1)
    #     print(f'custom thread pool {result}')

    # 3.Run in a custom process pool:
    # with concurrent.futures.ProcessPoolExecutor() as pool:
    #     result = await loop.run_in_executor(
    #         pool, func1)
    #     print(f'custom process pool {result}')

asyncio.run( main() )
```

## 异步和非异步模块混合编程

案例：asyncio+不支持异步的模块

```python
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

## 异步迭代器

**什么是异步迭代器？**

实现了`__aiter__()`和`__anext__()`方法的对象。`__anext__`必须返回一个`awaitable`对象，`async_for`会处理异步迭代器的`__anext__()`方法所返回的可等待对象，直到其引发一个`StopAsyncIteration`异常。

**什么是异步可迭代对象？**

可在`async_for`语句中被使用的对象。必须通过它的`__aiter__()`方法返回一个`asynchronous.iterator`。

```python
import asyncio

class Reader(object):
    """ 自定义异步迭代器（同时也是异步可迭代对象） """

    def __init__(self):
        self.count = 0

    async def readline(self):
        # await asyncio.sleep(1)
        self.count += 1
        if self.count == 100:
            return None
        return self.count

    def __aiter__(self):
        return self

    async def __anext__(self):
        val = await self.readline()
        if val == None:
            raise StopAsyncIteration
        return val

async def func():
    obj = Reader()
    # async for必须写在协程函数内部，如果写在外面，会报错
    async for item in obj:
        print(item)

asyncio.run( func() )
```

## 异步上下文管理器

此种对象通过定义`__aenter__()`和`__aexit__()`方法来对`async with`语句中的环境进行控制。

```python
import asyncio

class AsyncContextManager:

    def __init__(self):
        self.conn = conn

    async def do_something(self):
        # 异步操作数据库
        return 666

    async def __aenter__(self):
        # 异步连接数据库
        self.conn = await asyncio.sleep(1)
        return self

    async def __aexit__(self, exc_type, exc, tb):
        # 异步关闭数据库连接
        await asyncio.sleep(1)

async def func():
    # async with 同样不能单独使用，必须在协程函数内部才能使用
    # 第1种用法
    obj = AsyncContextManager()
    async with obj:
        pass

    # 第2种用法
    async with AsyncContextManager() as f:
        result = await f.do_something()
        print(result)

asyncio.run( func() )
```

## uvloop

是 asyncio 的事件循环替代方案。

uvloop 事件循环的效率 > 默认 asyncio 的事件循环效率

```python
pip install uvloop
```

```python
import asyncio
import uvloop
asyncio.set_event_loop_policy(uvloop.EventLoopPolicy())

# 编写asyncio的代码，与之前写的代码一致

# 内部的事件循环自动化会变为uvloop
asyncio.run(...)
```

注意：一个 agsi $\to$ uvicorn 内部使用的就是 uvloop。

## 异步装饰器

```python
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
