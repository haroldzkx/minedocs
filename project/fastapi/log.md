# 日志配置

loguru库是线程安全的，但不是进程安全。

在FastAPI中，可以在lifespan中，先配置好日志。

```python
from contextlib import asynccontextmanager
from loguru import logger
import sys

@asynccontextmanager
async def lifespan(app: FastAPI):
    # FastAPI程序即将运行时执行的代码
    logger.remove()
    logger.add("logs/file_{time}.log", rotation="500 MB", enqueue=True)
    yield
    # FastAPI程序执行后，即将退出时执行的代码

app = FastAPI(lifespan=lifespan)
```

这样，在程序启动时，就会配置好日志。然后可以添加一个日志的中间件，在执行完视图函数后再执行 await logger.complete()。

```python
@app.middleware('http')
async def log_middleware(request: Request, call_next):
    response = await call_next(request)
    await logger.complete()
    return response

# 或
from starlette.middleware.base import BaseHTTPMiddleware
app.add_middleware(BaseHTTPMiddleware, dispatch=log_middleware)
```