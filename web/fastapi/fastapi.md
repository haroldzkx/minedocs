# FastAPI

安装: [https://fastapi.tiangolo.com/zh/#\_3](https://fastapi.tiangolo.com/zh/#_3)

```bash
pip install fastapi
pip install uvicorn[standard]
```

示例: [https://fastapi.tiangolo.com/zh/#\_4](https://fastapi.tiangolo.com/zh/#_4)

运行: [https://fastapi.tiangolo.com/zh/#\_6](https://fastapi.tiangolo.com/zh/#_6)

```bash
# 开发环境
fastapt dev
fastapi dev main.py
fastapi dev main.py --port 8081 --host xxxx

# 生产环境（底层也是基于uvicorn）
fastapi run

uvicorn main:app --reload
uvicorn main:app --reload --port 8082 --host xxxx
```

# 类型提示

类型提示简介: [https://fastapi.tiangolo.com/zh/python-types/](https://fastapi.tiangolo.com/zh/python-types/)

对类型提示的支持(typing): [https://docs.python.org/zh-cn/3/library/typing.html](https://docs.python.org/zh-cn/3/library/typing.html)

类型种类: [https://mypy.readthedocs.io/en/stable/kinds_of_types.html](https://mypy.readthedocs.io/en/stable/kinds_of_types.html)

类型检查 mypy: [https://mypy.readthedocs.io/en/stable/index.html](https://mypy.readthedocs.io/en/stable/index.html)

额外数据类型: [https://fastapi.tiangolo.com/zh/tutorial/extra-data-types/](https://fastapi.tiangolo.com/zh/tutorial/extra-data-types/)

# Pydantic数据校验

Pydantic 是做数据校验的。

官方文档: [https://docs.pydantic.dev/latest/](https://docs.pydantic.dev/latest/)

安装: [https://docs.pydantic.dev/latest/install/](https://docs.pydantic.dev/latest/install/)

基本使用: [https://docs.pydantic.dev/latest/#pydantic-examples](https://docs.pydantic.dev/latest/#pydantic-examples)

# 请求数据

Request Parameters: [https://fastapi.tiangolo.com/zh/reference/parameters/](https://fastapi.tiangolo.com/zh/reference/parameters/)

路由参数

- 路径参数: [https://fastapi.tiangolo.com/zh/tutorial/path-params/](https://fastapi.tiangolo.com/zh/tutorial/path-params/)

- 路径参数和数值校验: [https://fastapi.tiangolo.com/zh/tutorial/path-params-numeric-validations/](https://fastapi.tiangolo.com/zh/tutorial/path-params-numeric-validations/)

- 查询参数: [https://fastapi.tiangolo.com/zh/tutorial/query-params/](https://fastapi.tiangolo.com/zh/tutorial/query-params/)

- 查询参数和字符串校验: [https://fastapi.tiangolo.com/zh/tutorial/query-params-str-validations/](https://fastapi.tiangolo.com/zh/tutorial/query-params-str-validations/)

Body 参数

- 请求体: [https://fastapi.tiangolo.com/zh/tutorial/body/](https://fastapi.tiangolo.com/zh/tutorial/body/)

- 自定义验证逻辑: [https://docs.pydantic.dev/latest/concepts/validators/](https://docs.pydantic.dev/latest/concepts/validators/)

- 查询参数模型: [https://fastapi.tiangolo.com/zh/tutorial/query-param-models/](https://fastapi.tiangolo.com/zh/tutorial/query-param-models/)

- 请求体（字段）: [https://fastapi.tiangolo.com/zh/tutorial/body-fields/](https://fastapi.tiangolo.com/zh/tutorial/body-fields/)

- 请求体(多个参数): [https://fastapi.tiangolo.com/zh/tutorial/body-multiple-params/](https://fastapi.tiangolo.com/zh/tutorial/body-multiple-params/)

- 请求体(嵌套模型): [https://fastapi.tiangolo.com/zh/tutorial/body-nested-models/](https://fastapi.tiangolo.com/zh/tutorial/body-nested-models/)

Cookie 参数

- Cookie 参数: [https://fastapi.tiangolo.com/zh/tutorial/cookie-params/](https://fastapi.tiangolo.com/zh/tutorial/cookie-params/)

- Cookie 参数模型: [https://fastapi.tiangolo.com/zh/tutorial/cookie-param-models/](https://fastapi.tiangolo.com/zh/tutorial/cookie-param-models/)

- set_cookie:

  - [https://fastapi.tiangolo.com/zh/reference/response/#fastapi.Response.set_cookie](https://fastapi.tiangolo.com/zh/reference/response/#fastapi.Response.set_cookie)

  - [https://fastapi.tiangolo.com/zh/reference/responses/#fastapi.responses.JSONResponse.set_cookie](https://fastapi.tiangolo.com/zh/reference/responses/#fastapi.responses.JSONResponse.set_cookie)

Header 参数

- Header 参数: [https://fastapi.tiangolo.com/zh/tutorial/header-params/](https://fastapi.tiangolo.com/zh/tutorial/header-params/)

- Header 参数模型: [https://fastapi.tiangolo.com/zh/tutorial/header-param-models/](https://fastapi.tiangolo.com/zh/tutorial/header-param-models/)

模式的额外信息: [https://fastapi.tiangolo.com/zh/tutorial/schema-extra-example/](https://fastapi.tiangolo.com/zh/tutorial/schema-extra-example/)

# 依赖注入

依赖注入，可以让我们的视图函数在执行之前，先执行一段逻辑代码，这段逻辑代码可以返回新的值给视图函数。在以下场景中可以使用依赖注入：

- 共享业务逻辑（复用相同的代码逻辑）
- 共享数据库连接
- 实现安全、验证、角色权限
- ...

总之，就是将一些重复性的代码，单独写成依赖，然后在需要的视图函数中，注入这个依赖。

函数作为依赖: [https://fastapi.tiangolo.com/zh/tutorial/dependencies/](https://fastapi.tiangolo.com/zh/tutorial/dependencies/)

类作为依赖项: [https://fastapi.tiangolo.com/zh/tutorial/dependencies/classes-as-dependencies/](https://fastapi.tiangolo.com/zh/tutorial/dependencies/classes-as-dependencies/)

子依赖项: [https://fastapi.tiangolo.com/zh/tutorial/dependencies/sub-dependencies/](https://fastapi.tiangolo.com/zh/tutorial/dependencies/sub-dependencies/)

路径操作装饰器依赖项: [https://fastapi.tiangolo.com/zh/tutorial/dependencies/dependencies-in-path-operation-decorators/](https://fastapi.tiangolo.com/zh/tutorial/dependencies/dependencies-in-path-operation-decorators/)

全局依赖项: [https://fastapi.tiangolo.com/zh/tutorial/dependencies/global-dependencies/](https://fastapi.tiangolo.com/zh/tutorial/dependencies/global-dependencies/)

使用 yield 的依赖项: [https://fastapi.tiangolo.com/zh/tutorial/dependencies/dependencies-with-yield/](https://fastapi.tiangolo.com/zh/tutorial/dependencies/dependencies-with-yield/)

模块化依赖项: 使用 APIRouter 来为路由分模块。[https://fastapi.tiangolo.com/zh/tutorial/bigger-applications/#apirouter_3](https://fastapi.tiangolo.com/zh/tutorial/bigger-applications/#apirouter_3)

# APIRouter

使用多个文件构建大型应用: [https://fastapi.tiangolo.com/zh/tutorial/bigger-applications/](https://fastapi.tiangolo.com/zh/tutorial/bigger-applications/)

# 中间件

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