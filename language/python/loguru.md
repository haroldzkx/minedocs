# loguru

推荐用法：用类和 yaml 配置文件实现 loguru 使用的二次封装。

loguru库是线程安全的，但不是进程安全。在多进程和协程中，可以在logger.add中加上enqueue参数，那么数据将会先存放到队列中，最后在执行logger.complete()时才会将日志信息保存到文件中。

<details>
<summary>安装</summary>

```bash
pip install loguru
```

</details>

<details>
<summary>配置日志输出到文件中</summary>

```python
from loguru import logger

logger.add("info_{time:YYYY-MM-DD}.log", level="INFO", encoding="utf-8", retention="10 day")

logger.add("file_1.log", rotation="500 MB")
logger.add("file_2.log", rotation="12:00")
logger.add("file_3.log", rotation="1 week")

logger.add("file_4.log", rotation="10 days")

logger.add("file_5.log", rotation="zip")

logger.add("file_7.log", format="{time:YYYY-MM-DD at HH:mm:ss} | {level} | {message}")

# 清除之前添加的日志输出方式
logger.remove()
```

</details>

<details>
<summary>异常记录</summary>

可以在可能发生异常的函数上，加上logger.catch装饰器。如果该函数在执行过程中发生异常，就会记录到日志中。代码如下：

```python
@router.get("/test")
@logger.catch(reraise=True)
async def test_view(arg: str):
    a = 1
    b = 0
    c = a / b
    return 'test'
```

```python
# 或者可以统一加载日志中间件上
@app.middleware('http')
@logger.catch(reraise=True)
async def log_middleware(request: Request, call_next):
    response = await call_next(request)
    await logger.complete()
    return response
```

</details>



<details>
<summary>temp</summary>

```python
folder_ = "./log/"
prefix_ = "polaris-"
rotation_ = "10 MB"
retention_ = "30 days"
encoding_ = "utf-8"
backtrace_ = True
diagnose_ = True

# 格式里面添加了process和thread记录，方便查看多进程和线程程序
format_ = '<green>{time:YYYY-MM-DD HH:mm:ss.SSS}</green> | <level>{level: <8}</level> ' \
            '| <magenta>{process}</magenta>:<yellow>{thread}</yellow> ' \
            '| <cyan>{name}</cyan>:<cyan>{function}</cyan>:<yellow>{line}</yellow> - <level>{message}</level>'

# 这里面采用了层次式的日志记录方式，就是低级日志文件会记录比他高的所有级别日志，这样可以做到低等级日志最丰富，高级别日志更少更关键
# debug
logger.add(folder_ + prefix_ + "debug.log", level="DEBUG", backtrace=backtrace_, diagnose=diagnose_,
            format=format_, colorize=False,
            rotation=rotation_, retention=retention_, encoding=encoding_,
            filter=lambda record: record["level"].no >= logger.level("DEBUG").no)

# info
logger.add(folder_ + prefix_ + "info.log", level="INFO", backtrace=backtrace_, diagnose=diagnose_,
            format=format_, colorize=False,
            rotation=rotation_, retention=retention_, encoding=encoding_,
            filter=lambda record: record["level"].no >= logger.level("INFO").no)

# warning
logger.add(folder_ + prefix_ + "warning.log", level="WARNING", backtrace=backtrace_, diagnose=diagnose_,
            format=format_, colorize=False,
            rotation=rotation_, retention=retention_, encoding=encoding_,
            filter=lambda record: record["level"].no >= logger.level("WARNING").no)

# error
logger.add(folder_ + prefix_ + "error.log", level="ERROR", backtrace=backtrace_, diagnose=diagnose_,
            format=format_, colorize=False,
            rotation=rotation_, retention=retention_, encoding=encoding_,
            filter=lambda record: record["level"].no >= logger.level("ERROR").no)

# critical
logger.add(folder_ + prefix_ + "critical.log", level="CRITICAL", backtrace=backtrace_, diagnose=diagnose_,
            format=format_, colorize=False,
            rotation=rotation_, retention=retention_, encoding=encoding_,
            filter=lambda record: record["level"].no >= logger.level("CRITICAL").no)

logger.add(sys.stderr, level="CRITICAL", backtrace=backtrace_, diagnose=diagnose_,
            format=format_, colorize=True,
            filter=lambda record: record["level"].no >= logger.level("CRITICAL").no)
```

</details>
