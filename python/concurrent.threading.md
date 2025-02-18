# 【多线程 threading】

[https://www.bilibili.com/video/BV1jW411Y7Wj](https://www.bilibili.com/video/BV1jW411Y7Wj)

# 常用函数

```python
import threading
from loguru import logger


def main():
    logger.debug( threading.active_count() )    # 查看当前有多少激活的线程
    logger.debug( threading.enumerate() )       # 查看当前激活的线程是什么（线程名）
    logger.debug( threading.current_thread() )  # 查看当前正在运行的线程


if __name__ == '__main__':
    main()
```

# 添加线程

```python
import threading
from loguru import logger


# 2.定义新线程要做的工作
def thread_1_job():
    logger.debug( f'Add Thread 1, number is {threading.current_thread()}' )


def main():
    # 1.定义一个新线程，这个新线程要做的工作是 thread_1_job 函数的功能，命名为 T1
    thread_1 = threading.Thread(target=thread_1_job, name='T1')
    # 3.开始执行新线程
    thread_1.start()


if __name__ == '__main__':
    main()
```

# join 功能

```python
import threading
from loguru import logger
import time


def thread_1_job():
    logger.debug( 'Thread 1 start.' )
    for i in range(10):
        time.sleep(0.1)
    logger.debug( 'Thread 1 finish.' )


def thread_2_job():
    logger.debug( 'Thread 2 start.' )
    logger.debug( 'Thread 2 finish.' )


def main():
    thread_1 = threading.Thread(target=thread_1_job, name='T1')
    thread_2 = threading.Thread(target=thread_2_job, name='T2')
    thread_1.start()
    thread_2.start()

    # join()函数可以阻塞当前线程，直到当前线程完成才可以往下执行代码
    # 即将当前线程附加到主线程中
    thread_1.join()
    thread_2.join()

    logger.debug( 'All thread done.' )


if __name__ == '__main__':
    main()
```

# Queue 功能

线程是不能返回值的，这时候就需要 Queue 了

```python
import threading
from loguru import logger
from queue import Queue


def job(my_list, q):
    for i in range(len(my_list)):
        my_list[i] = my_list[i]**2
    # 线程返回结果不能用 return，用 q.put() 将结果放入 Queue 中
    q.put(my_list)


def multithreading():
    q = Queue()
    threads = []    # 定义线程池
    data = [[1, 2, 3], [4, 9, 6], [7, 7, 7], [5, 5, 6]]

    # 为 data 中的每一维元素开一个线程，并加入线程池
    for i in range(4):
        # args参数用来向线程传递参数
        t = threading.Thread(target=job, args=(data[i], q))
        t.start()
        threads.append(t)

    # 将创建的所有线程加入到主线程中
    for thread in threads:
        thread.join()

    results = []

    for _ in range(4):
        # 从 q 里按顺序拿值，每次拿一个，然后依次加入到 results 列表中
        results.append(q.get())

    # 打印结果
    logger.debug( results )


def main():
    multithreading()


if __name__ == '__main__':
    main()
```

# lock 功能

```python
import threading
from loguru import logger

share_data = 0
lock = threading.Lock()

def job_1():
    global share_data, lock
    lock.acquire()
    for i in range(10):
        share_data += 1
        logger.debug( f'job 1 share_data -> {share_data}' )
    lock.release()

""" lock 支持上下文管理器
def job_1():
    global share_data, lock
    with lock:
        for i in range(10):
            share_data += 1
            logger.debug( f'job 1 share_data -> {share_data}' )
"""

def job_2():
    global share_data, lock
    lock.acquire()
    for i in range(10):
        share_data += 10
        logger.debug( f'job 2 share_data -> {share_data}' )
    lock.release()

""" lock 支持上下文管理器
def job_2():
    global share_data, lock
    with lock:
        for i in range(10):
            share_data += 10
            logger.debug( f'job 2 share_data -> {share_data}' )
"""

def main():
    t1 = threading.Thread(target=job_1)
    t2 = threading.Thread(target=job_2)
    t1.start()
    t2.start()
    t1.join()
    t2.join()


if __name__ == '__main__':
    main()
```
