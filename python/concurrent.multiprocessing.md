# 【多进程 multiprocessing】

[https://www.bilibili.com/video/BV1jW411Y7pv](https://www.bilibili.com/video/BV1jW411Y7pv)

# 创建进程

```python
import multiprocessing as mp
from loguru import logger


def job_1(a, b):
    logger.debug( f'a -> {a}, b -> {b}' )


def main():
    # args 参数用来向进程中传参数
    p1 = mp.Process(target=job_1, args=(2, 1))
    # 启动进程
    p1.start()
    # 阻塞进程
    p1.join()


if __name__ == '__main__':
    main()
```

# queue 进程输出

每个进程运算结果都存入队列中，等所有进程运算结束，再从队列中取得结果。

```python
import multiprocessing as mp
from loguru import logger


def job_1(q, numb):
    res = 0
    for i in range(numb):
        res += i + i**2 + i**3
    # 将运算结果存入队列 q 中
    q.put(res)


def main():
    # 定义队列
    q = mp.Queue()
    # 在 args 参数中传入 q
    # args 中只有一个参数时必须写成 args=(q,) 而不能写成 args=(q)
    p1 = mp.Process(target=job_1, args=(q, 100))
    p2 = mp.Process(target=job_1, args=(q, 10))
    # 启动进程
    p1.start()
    p2.start()
    # 阻塞进程
    p1.join()
    p2.join()
    # 从队列取值，以下两种方法任选其一即可，但不可同时使用
    # 方法1:
    res1 = q.get()
    res2 = q.get()
    logger.debug( f'res1 -> {res1}, res2 -> {res2}' )
    # 方法2:
    results = []
    for _ in range(2):
        results.append(q.get())
    logger.debug(f'results -> {results}')


if __name__ == '__main__':
    main()
```

# 效率对比

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

# 进程池 pool

用 queue 时进程任务里不能有 return，而 pool 里有 return。

进程池会自动帮你执行任务。

```python
import multiprocessing as mp
from loguru import logger


def job(x):
    return x * x


def multicore():
    # 定义进程池
    # processes 参数用来指定要用到的核心数目
    pool = mp.Pool(processes=3)
    # 往 pool 里放 进程任务 及 要运算的值
    # 也可以用 pool.imap，这是一个迭代器，可以显示每个任务的处理进度
    # 可以结合 tqdm 用实时进度条来显示过程
    res = pool.map(job, range(10))
    logger.debug( f'pool.map Result -> {res}')

    # 下面是与 map 类似的另外一种实现，但要复杂更多
    multi_res = [pool.apply_async(job, (i,)) for i in range(10)]
    logger.debug( f'pool.apple_async Result -> {[res.get() for res in multi_res]}' )


if __name__ == '__main__':
    multicore()
```

输出结果：

```python
pool.map Result -> [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
pool.apple_async Result -> [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
```

# 共享内存 shared memory

```python
import multiprocessing as mp

# 设置共享内存，这个内存可以被CPU每一个内核读取
# 多个内核之间的数据交换只能通过共享内存
# 第一个参数为类型，i 为整数，d 为浮点数
value = mp.Value('i', 1)
# 注：Array后面的数据只能放一维列表，不能是多维的
array = mp.Array('i', [1, 2, 3])
```

# lock

不加锁时

```python
import multiprocessing as mp
from loguru import logger
import time


def job(v, num):
    for _ in range(10):
        time.sleep(0.1)
        # 共享内存取值要用 v.value 而不是直接用 v
        v.value += num
        logger.debug( f'v.value -> {v.value}' )

def multicore():
    v = mp.Value('i', 0)
    p1 = mp.Process(target=job, args=(v, 1))
    p2 = mp.Process(target=job, args=(v, 3))
    p1.start()
    p2.start()
    p1.join()
    p2.join()


if __name__ == '__main__':
    multicore()
```

输出结果会很比较混乱。

加锁：

```python
import multiprocessing as mp
from loguru import logger
import time


def job(v, num, lock):
    lock.acquire()
    for _ in range(10):
        time.sleep(0.1)
        # 共享内存取值要用 v.value 而不是直接用 v
        v.value += num
        logger.debug( f'v.value -> {v.value}' )
    lock.release()

    """ lock 同样可以用上下文管理器，如下所示
    with lock:
        for _ in range(10):
            time.sleep(0.1)
            v.value += num
            logger.debug( f'v.value -> {v.value}' )
    """


def multicore():
    lock = mp.Lock()
    v = mp.Value('i', 0)
    p1 = mp.Process(target=job, args=(v, 1, lock))
    p2 = mp.Process(target=job, args=(v, 3, lock))
    p1.start()
    p2.start()
    p1.join()
    p2.join()


if __name__ == '__main__':
    multicore()
```
