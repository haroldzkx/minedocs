# gRPC 简介

gRPC 适用于构建分布式系统和服务化架构，可以简化服务之间的通信和数据的交换。它特别适用于需要高性能和低延迟的场景，如移动应用，云服务和微服务架构等。

gRPC 官网: [https://grpc.io/](https://grpc.io/)

gRPC GitHub: [https://github.com/grpc/grpc](https://github.com/grpc/grpc)

# Protocol Buffers

gRPC Working with Protocol Buffers: [https://grpc.io/docs/what-is-grpc/introduction/#working-with-protocol-buffers](https://grpc.io/docs/what-is-grpc/introduction/#working-with-protocol-buffers)

Protocol Buffers (Protobuf) 官网: [https://protobuf.dev/overview/](https://protobuf.dev/overview/)

How do Protocol Buffers Work: [https://protobuf.dev/overview/#work](https://protobuf.dev/overview/#work)

## proto3

proto3 语法: [https://protobuf.dev/programming-guides/proto3/](https://protobuf.dev/programming-guides/proto3/)

版本: [https://protobuf.dev/editions/overview/](https://protobuf.dev/editions/overview/)

注释: [https://protobuf.dev/programming-guides/proto3/#adding-comments](https://protobuf.dev/programming-guides/proto3/#adding-comments)

定义消息: [https://protobuf.dev/programming-guides/proto3/#simple](https://protobuf.dev/programming-guides/proto3/#simple)

定义服务: [https://protobuf.dev/programming-guides/proto3/#services](https://protobuf.dev/programming-guides/proto3/#services)

基本数据类型: [https://protobuf.dev/programming-guides/proto3/#scalar](https://protobuf.dev/programming-guides/proto3/#scalar)

枚举: [https://protobuf.dev/programming-guides/proto3/#enum](https://protobuf.dev/programming-guides/proto3/#enum)

列表: [https://protobuf.dev/programming-guides/proto3/#other](https://protobuf.dev/programming-guides/proto3/#other)

Map: [https://protobuf.dev/programming-guides/proto3/#maps](https://protobuf.dev/programming-guides/proto3/#maps)

Oneof: [https://protobuf.dev/programming-guides/proto3/#oneof](https://protobuf.dev/programming-guides/proto3/#oneof)

保留字段: [https://protobuf.dev/programming-guides/proto3/#deleting](https://protobuf.dev/programming-guides/proto3/#deleting)

默认值: [https://protobuf.dev/programming-guides/proto3/#default](https://protobuf.dev/programming-guides/proto3/#default)

# gRPC 进阶

进阶内容的代码都是通过 article.proto 来是实现的

<details>
<summary>article.proto</summary>

```proto
// 指定版本号为3
syntax = "proto3";

/*
这是一个Article消息
*/
message Article{
  int32 id = 1;
  string title = 2;
  string content = 3;
  string create_time = 4;
}

message ArticleListRequest{
  int32 page = 1;
  int32 page_size = 2;
}

message ArticleListResponse{
  // repeated Article：这是数据类型，文章的列表
  repeated Article articles = 1;
}

message ArticleDetailRequest {
  int32 pk = 1;
}

message ArticleDetailResponse {
  Article article = 1;
}

service ArticleService{
  rpc ArticleList(ArticleListRequest) returns (ArticleListResponse);
  rpc ArticleDetail(ArticleDetailRequest) returns (ArticleDetailResponse);
}
```

</details>

## 元数据

元数据，或者说是 gRPC 协议中的请求头，类似于 HTTP 协议中的 header，可以让我们在客户端和服务端数据交互过程中携带一些额外的数据。

客户端的元数据的 key，不能出现大写字母以及中文。

<details>
<summary>服务端代码实现</summary>

```python
# server.py
from proto import article_pb2, article_pb2_grpc
import grpc
from concurrent import futures

class ArticleService(article_pb2_grpc.ArticleServiceServicer):
    def ArticleList(self, request, context):
        # 元数据的操作，都是通过context去实现的
        # 1. 获取客户端上传来的元数据：context.invocation_metadata()
        # 2. 返回给客户端的元数据：context.set_trailing_metadata()
        for key, value in context.invocation_metadata():
            print(key, value)
        response = article_pb2.ArticleListResponse()
        articles = [
            article_pb2.Article(id=1, title='xx', content='yy', create_time='2030-10-10')
        ]
        context.set_trailing_metadata((
            ('allow', 'True'),
            ('status', 'Healthy')
        ))
        response.articles.extend(articles)
        return response

def main():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    article_pb2_grpc.add_ArticleServiceServicer_to_server(ArticleService(), server)
    server.add_insecure_port("[::]:5000")
    server.start()
    server.wait_for_termination()

if __name__ == '__main__':
    main()
```

</details>

<details>
<summary>客户端代码实现</summary>

```python
# client.py
import grpc
from proto import article_pb2, article_pb2_grpc
# from grpc._server import _Context

def main():
    with grpc.insecure_channel("localhost:5000") as channel:
        stub = article_pb2_grpc.ArticleServiceStub(channel)
        request = article_pb2.ArticleListRequest(page=1)
        metadata = (
            ('username', "zhiliao"),
            ('token', 'abc')
        )
        # 调用RPC接口的时，不再是直接调用，而是通过with_call函数调用，然后把metadata传过去
        response, call = stub.ArticleList.with_call(request, metadata=metadata)
        print(response.articles)
        # 获取服务端返回的元数据，通过call.trailing_metadata来获取
        print('从服务端获取到的元数据：')
        for key, value in call.trailing_metadata():
            print(key, value)

if __name__ == '__main__':
    main()
```

</details>

## 拦截器

gRPC 中，可以设置类似 Django 或 FastAPI 中的中间件，不过它不叫中间件，而叫做 Interceptor（拦截器）。我们可以在拦截器中模仿 Django 的中间件一样，做一些请求服务前的拦截处理，比如校验用户信息。这里我们以拦截器的使用示例代码如下。

<details>
<summary>服务端代码实现</summary>

服务端实现拦截器，需要继承自 grpc.ServerInterceptor，在 intercept_service 方法中实现具体的拦截逻辑。然后再把写好的拦截器，传给 grpc.server 的 interceptors 参数中。

```python
from typing import Callable, Any

from proto import article_pb2, article_pb2_grpc
import grpc
from concurrent import futures

# 拦截器
class MyInterceptor(grpc.ServerInterceptor):
    def intercept_service(self, continuation, handler_call_details):
        print('my 拦截开始')
        print(continuation)
        print(handler_call_details)
        next_handler = continuation(handler_call_details)
        print("my 拦截结束")
        return next_handler

class YourInterceptor(grpc.ServerInterceptor):
    def intercept_service(self, continuation, handler_call_details):
        print('your 拦截开始')
        next_handler = continuation(handler_call_details)
        print("your 拦截结束")
        return next_handler

class ArticleService(article_pb2_grpc.ArticleServiceServicer):
    def ArticleList(self, request, context):
        print("user:", context.user)
        response = article_pb2.ArticleListResponse()
        articles = [
            article_pb2.Article(id=1, title='xx', content='yy', create_time='2030-10-10')
        ]
        response.articles.extend(articles)
        return response

def main():
    server = grpc.server(
        futures.ThreadPoolExecutor(max_workers=10),
        interceptors=[MyInterceptor(), YourInterceptor()]
    )
    article_pb2_grpc.add_ArticleServiceServicer_to_server(ArticleService(), server)
    server.add_insecure_port("[::]:5000")
    server.start()
    server.wait_for_termination()

if __name__ == '__main__':
    main()
```

</details>

<details>
<summary>客户端代码实现</summary>

客户端的拦截器需要继承自grpc.UnaryUnaryClientInterceptor，然后实现intercept_unary_unary方法。接着再在创建channel时，使用grpc.intercept_channel接收拦截器，并将返回的interceptor_channel传给Stub对象。

```python
import grpc
from proto import article_pb2, article_pb2_grpc

# 客户端拦截器
class ClientInterceptor(grpc.UnaryUnaryClientInterceptor):
    def intercept_unary_unary(self, continuation, client_call_details, request):
        print('拦截开始')
        next_handler = continuation(client_call_details, request)
        print('拦截结束')
        return next_handler

def main():
    with grpc.insecure_channel("localhost:5000") as channel:
        intercept_channel = grpc.intercept_channel(channel, ClientInterceptor())
        stub = article_pb2_grpc.ArticleServiceStub(intercept_channel)
        request = article_pb2.ArticleListRequest(page=1)
        metadata = (
            ('authorization', 'zhiliao'),
        )
        response, call = stub.ArticleList.with_call(request, metadata=metadata)
        print(response.articles)

if __name__ == '__main__':
    main()
```

</details>

---

拦截器结合元数据实现用户token认证：

<details>
<summary>服务端代码实现</summary>

```python
from typing import Callable, Any

from proto import article_pb2, article_pb2_grpc
import grpc
from concurrent import futures

# 拦截器
class AuthenticateInterceptor(grpc.ServerInterceptor):
    def intercept_service(self, continuation, handler_call_details):
        metadata = dict(handler_call_details.invocation_metadata)
        # 验证用户的逻辑：在元数据中寻找authorization，并且这个值为zhiliao
        if 'authorization' in metadata and metadata['authorization'] == 'zhiliao':
            return continuation(handler_call_details)
        else:
            # 也是要返回一个method_handler对象
            def terminate(request, context):
                context.abort(grpc.StatusCode.UNAUTHENTICATED, '请传入Token！')
            return grpc.unary_unary_rpc_method_handler(terminate)

class ArticleService(article_pb2_grpc.ArticleServiceServicer):
    def ArticleList(self, request, context):
        print("user:", context.user)
        response = article_pb2.ArticleListResponse()
        articles = [
            article_pb2.Article(id=1, title='xx', content='yy', create_time='2030-10-10')
        ]
        response.articles.extend(articles)
        return response

def main():
    server = grpc.server(
        futures.ThreadPoolExecutor(max_workers=10),
        interceptors=[AuthenticateInterceptor()]
    )
    article_pb2_grpc.add_ArticleServiceServicer_to_server(ArticleService(), server)
    server.add_insecure_port("[::]:5000")
    server.start()
    server.wait_for_termination()

if __name__ == '__main__':
    main()
```

</details>

---

gRPC 自带的拦截器功能比较有限，用起来不是很方便。为了改善拦截器的用户体验，有一位大神开发了一个 grpc—interceptor 的插件，让我们能非常方便的在拦截器中使用 request 和 context 对象。首先通过以下命令安装：

grpc-interceptor github: [https://github.com/d5h-foss/grpc-interceptor](https://github.com/d5h-foss/grpc-interceptor)

```bash
pip install grpc-interceptor
```

<details>
<summary>服务端代码实现</summary>

```python
from typing import Callable, Any

from proto import article_pb2, article_pb2_grpc
import grpc
from concurrent import futures
from grpc_interceptor import ServerInterceptor

# 拦截器
class UserInterceptor(ServerInterceptor):
    def intercept(
        self,
        method: Callable,
        request_or_iterator: Any,
        context: grpc.ServicerContext,
        method_name: str,
    ) -> Any:
        context.user = self.user
        return method(request_or_iterator, context)

    def intercept_service(self, continuation, handler_call_details):
        metadata = dict(handler_call_details.invocation_metadata)
        # 验证用户的逻辑：在元数据中寻找authorization，并且这个值为zhiliao
        if 'authorization' in metadata and metadata['authorization'] == 'zhiliao':
            # 从数据库中查找用户数据
            self.user = {"id": 1, 'username': 'zhiliao'}
        else:
            self.user = None
        return super().intercept_service(continuation, handler_call_details)

class ArticleService(article_pb2_grpc.ArticleServiceServicer):
    def ArticleList(self, request, context):
        print("user:", context.user)
        response = article_pb2.ArticleListResponse()
        articles = [
            article_pb2.Article(id=1, title='xx', content='yy', create_time='2030-10-10')
        ]
        response.articles.extend(articles)
        return response

def main():
    server = grpc.server(
        futures.ThreadPoolExecutor(max_workers=10),
        interceptors=[UserInterceptor()]
    )
    article_pb2_grpc.add_ArticleServiceServicer_to_server(ArticleService(), server)
    server.add_insecure_port("[::]:5000")
    server.start()
    server.wait_for_termination()

if __name__ == '__main__':
    main()
```

</details>

## 错误处理

gRPC 与 http 协议类似，也可以在请求结果非正常时返回错误状态码和错误信息。服务端通过在 context 中设 置状态码和错误信息即可返回错误。

gRPC的错误状态码：[https://grpc.io/docs/guides/status-codes](https://grpc.io/docs/guides/status-codes)

<details>
<summary>服务端代码实现</summary>

```python
from proto import article_pb2, article_pb2_grpc
import grpc
from concurrent import futures

class ArticleService(article_pb2_grpc.ArticleServiceServicer):
    def ArticleList(self, request, context):
        response = article_pb2.ArticleListResponse()
        context.set_code(grpc.StatusCode.NOT_FOUND)
        context.set_details('您找的资源不存在！')
        return response

def main():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    article_pb2_grpc.add_ArticleServiceServicer_to_server(ArticleService(), server)
    server.add_insecure_port("[::]:5000")
    server.start()
    server.wait_for_termination()

if __name__ == '__main__':
    main()
```

</details>

<details>
<summary>客户端代码实现</summary>

```python
import grpc
from proto import article_pb2, article_pb2_grpc

def main():
    with grpc.insecure_channel("localhost:5000") as channel:
        stub = article_pb2_grpc.ArticleServiceStub(channel)
        request = article_pb2.ArticleListRequest(page=1)
        try:
            response = stub.ArticleList(request)
            print(response.articles)
        except grpc.RpcError as e:
            print(e.code())
            print(e.details())

if __name__ == '__main__':
    main()
```

</details>

## 超时机制

由于微服务间是通过网络通信的，那么很有可能在微服务通信过程中出现异常，这时候如果无限制等待，那么将会影响客户体验。我们可以设置客户端在请求服务端时等待的最长时间，即通过 timeout 参数指定。示例代码如下。

<details>
<summary>服务端代码实现</summary>

```python
from proto import article_pb2, article_pb2_grpc
import grpc
from concurrent import futures
import time

class ArticleService(article_pb2_grpc.ArticleServiceServicer):
    def ArticleList(self, request, context):
        time.sleep(4)
        response = article_pb2.ArticleListResponse()
        return response

def main():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    article_pb2_grpc.add_ArticleServiceServicer_to_server(ArticleService(), server)
    server.add_insecure_port("[::]:5000")
    server.start()
    server.wait_for_termination()

if __name__ == '__main__':
    main()
```

</details>

<details>
<summary>客户端代码实现</summary>

```python
import grpc
from proto import article_pb2, article_pb2_grpc

def main():
    with grpc.insecure_channel("localhost:5000") as channel:
        stub = article_pb2_grpc.ArticleServiceStub(channel)
        request = article_pb2.ArticleListRequest(page=1)
        try:
            response = stub.ArticleList(request, timeout=2)
            print(response.articles)
        except grpc.RpcError as e:
            print(e.code())
            print(e.details())

if __name__ == '__main__':
    main()
```

</details>

<details>
<summary>服务端异步代码实现</summary>

```python
from proto import book_pb2, book_pb2_grpc
import grpc
import asyncio

class BookService(book_pb2_grpc.BookServiceServicer):
    async def BookList(self, request, context):
        response = book_pb2.BookListResponse()
        await aysncio.sleep(3)
        return response

async def main():
    server = grpc.aio.server()
    book_pb2_grpc.add_BookServiceServicer_to_server(BookService(), server)
    server.add_insecure_port("[::]:5000")
    await server.start()
    print('gRPC服务器已经启动！监听0.0.0.0:5000')
    await server.wait_for_termination()

if __name__ == '__main__':
    asyncio.run(main())
```

</details>

<details>
<summary>客户端异步代码实现</summary>

```python
import grpc
from proto import book_pb2, book_pb2_grpc
import asyncio

async def main():
    async with grpc.aio.insecure_channel("localhost:5000") as channel:
        stub = book_pb2_grpc.BookServiceStub(channel)
        request = book_pb2.BookListRequest()
        request.page = 100
        try:
            response = await stub.BookList(request, timeout=1)
            print(response.books)
        except grpc.RpcError as e:
            print(e.code())
            print(e.details())

if __name__ == '__main__':
    asyncio.run(main())
```

</details>

# Python

## 基础

gRPC Python Asyncio API: [https://grpc.github.io/grpc/python/grpc_asyncio.html](https://grpc.github.io/grpc/python/grpc_asyncio.html)

安装 gRPC: [https://grpc.io/docs/languages/python/quickstart/#prerequisites](https://grpc.io/docs/languages/python/quickstart/#prerequisites)

PyCharm 安装 Protobuf 插件: [https://plugins.jetbrains.com/plugin/14004-protocol-buffers](https://plugins.jetbrains.com/plugin/14004-protocol-buffers)

VSCode 安装 Protobuf 插件: [https://marketplace.visualstudio.com/items?itemName=zxh404.vscode-proto3](https://marketplace.visualstudio.com/items?itemName=zxh404.vscode-proto3)

Quick Start: [https://grpc.io/docs/languages/python/quickstart/](https://grpc.io/docs/languages/python/quickstart/)

步骤:

1. 安装依赖: [https://grpc.io/docs/languages/python/quickstart/#prerequisites](https://grpc.io/docs/languages/python/quickstart/#prerequisites)

2. 编写 .proto 文件

3. 定义消息: [https://protobuf.dev/programming-guides/proto3/#simple](https://protobuf.dev/programming-guides/proto3/#simple)

4. 定义服务: [https://protobuf.dev/programming-guides/proto3/#services](https://protobuf.dev/programming-guides/proto3/#services)

5. 生成代码:

   - [https://grpc.io/docs/languages/python/basics/#generating-client-and-server-code](https://grpc.io/docs/languages/python/basics/#generating-client-and-server-code)

   - [https://grpc.io/docs/languages/python/basics/#generating-grpc-interfaces-with-custom-package-path](https://grpc.io/docs/languages/python/basics/#generating-grpc-interfaces-with-custom-package-path)

6. 创建 Server 和 Client

   - [https://grpc.io/docs/languages/python/basics/#server](https://grpc.io/docs/languages/python/basics/#server)

   - [https://grpc.io/docs/languages/python/basics/#client](https://grpc.io/docs/languages/python/basics/#client)

同步与异步代码例子: [https://github.com/grpc/grpc/tree/v1.71.0/examples/python/route_guide](https://github.com/grpc/grpc/tree/v1.71.0/examples/python/route_guide)

异步版本: [https://grpc.github.io/grpc/python/grpc_asyncio.html](https://grpc.github.io/grpc/python/grpc_asyncio.html)

## 目录结构（推荐）

```bash
# 单独创建一个protos包，将所有的xxx.proto文件放到这里
main.py
/protos/__init__.py
/protos/book/__init__.py
/protos/book/book.proto
/protos/book/book_pb2.py
/protos/book/book_pb2_grpc.py
/protos/article/__init__.py
/protos/article/article.proto
/protos/article/article_pb2.py
/protos/article/article_pb2_grpc.py
```

```python
# 在xxx_pb2_grpc.py中，将
import xxx_pb2 as xxx__pb2
# 改为
from protos.xxx import xxx_pb2 as xxx__pb2
```

## 实战例子

同步的：

<details>
<summary>1.在服务端编写article.proto文件</summary>

```proto
// grpc_server/article.proto
// 指定版本号为3
syntax = "proto3";

/*
这是一个Article消息
*/
message Article{
  int32 id = 1;
  string title = 2;
  string content = 3;
  string create_time = 4;
}

message ArticleListRequest{
  int32 page = 1;
  int32 page_size = 2;
}

message ArticleListResponse{
  // repeated Article：这是数据类型，文章的列表
  repeated Article articles = 1;
}

message ArticleDetailRequest {
  int32 pk = 1;
}

message ArticleDetailResponse {
  Article article = 1;
}

service ArticleService{
  rpc ArticleList(ArticleListRequest) returns (ArticleListResponse);
  rpc ArticleDetail(ArticleDetailRequest) returns (ArticleDetailResponse);
}
```

</details>

<details>
<summary>2.在服务端生成Python代码（会生成article_pb2.py和article_pb2_grpc.py文件）</summary>

```bash
python -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. article.proto
# grpc_server/article_pb2.py
# grpc_server/article_pb2_grpc.py
```

</details>

<details>
<summary>3.编写服务端代码</summary>

```python
# grpc_server/main.py
import article_pb2
import article_pb2_grpc
# pip install grpcio
import grpc
from concurrent.futures import ThreadPoolExecutor

class ArticleService(article_pb2_grpc.ArticleServiceServicer):
    def ArticleList(self, request, context):
        page = request.page
        page_size = request.page_size
        print('page:', page, "page_size:", page_size)
        response = article_pb2.ArticleListResponse()
        articles = [
            article_pb2.Article(id=101, title='11', content='22', create_time='2030-10-10'),
            article_pb2.Article(id=102, title='xx', content='yy', create_time='2030-10-10'),
        ]
        # response.articles = articles # 这种写法是错误的
        response.articles.extend(articles) # 这种写法才正确
        return response

def main():
    # 1. 创建一个grpc服务器对象
    server = grpc.server(ThreadPoolExecutor(max_workers=10))
    # 2. 将文章服务，添加到server服务器中
    article_pb2_grpc.add_ArticleServiceServicer_to_server(ArticleService(), server)
    # 3. 绑定ip和端口号
    server.add_insecure_port("0.0.0.0:5001")
    # 4. 启动服务
    server.start()
    print('gRPC服务器已经启动！')
    # 5. 死循环，等待关闭
    server.wait_for_termination()

if __name__ == '__main__':
    main()
```

</details>

<details>
<summary>4.编写客户端代码</summary>

```python
# 先将服务端生成的article_pb2.py和article_pb2_grpc.py拷贝到客户端项目中
# 注意：因为服务端和客户端都是python实现，所以可以直接拷贝
#      如果服务端和客户端是不同语言实现，那么就要把article.proto文件拿到客户端来编译出文件
# grpc_client/main.py
# grpc_client/article_pb2.py
# grpc_client/article_pb2_grpc.py
import article_pb2
import article_pb2_grpc
import grpc

def main():
    # 1. 使用上下文管理器创建一个channel对象
    with grpc.insecure_channel("127.0.0.1:5001") as channel:
        # 2. 要发起grpc请求，需要借助Stub对象
        stub = article_pb2_grpc.ArticleServiceStub(channel)
        # 3. 构建一个请求对象
        request = article_pb2.ArticleListRequest()
        request.page = 100
        request.page_size = 20
        # 4. 发起请求
        response = stub.ArticleList(request)
        for article in response.articles:
            print(article.id, article.title)

if __name__ == '__main__':
    main()
```

</details>

---

异步的：

<details>
<summary>1.重构服务端代码</summary>

```python
# grpc_server/main.py
import article_pb2
import article_pb2_grpc
# pip install grpcio
import grpc
import asyncio

class ArticleService(article_pb2_grpc.ArticleServiceServicer):
    async def ArticleList(self, request, context):
        page = request.page
        page_size = request.page_size
        print('page:', page, "page_size:", page_size)
        # 模拟：阻塞
        await asyncio.sleep(1)
        response = article_pb2.ArticleListResponse()
        articles = [
            article_pb2.Article(id=101, title='11', content='22', create_time='2030-10-10'),
            article_pb2.Article(id=102, title='xx', content='yy', create_time='2030-10-10'),
        ]
        # response.articles = articles # 这种写法是错误的
        response.articles.extend(articles) # 这种写法才正确
        return response

async def main():
    # 1. 创建一个grpc服务器对象
    server = grpc.aio.server()
    # 2. 将文章服务，添加到server服务器中
    article_pb2_grpc.add_ArticleServiceServicer_to_server(ArticleService(), server)
    # 3. 绑定ip和端口号
    server.add_insecure_port("0.0.0.0:5001")
    # 4. 启动服务
    await server.start()
    print('gRPC服务器已经启动！')
    # 5. 死循环，等待关闭
    await server.wait_for_termination()

if __name__ == '__main__':
    asyncio.run(main())
```

</details>

<details>
<summary>2.重构客户端代码</summary>

```python
# grpc_client/main.py
import article_pb2
import article_pb2_grpc
import grpc
import asyncio

async def main():
    # 1. 使用上下文管理器创建一个channel对象
    async with grpc.aio.insecure_channel("127.0.0.1:5001") as channel:
        # 2. 要发起grpc请求，需要借助Stub对象
        stub = article_pb2_grpc.ArticleServiceStub(channel)
        # 3. 构建一个请求对象
        request = article_pb2.ArticleListRequest()
        request.page = 100
        request.page_size = 20
        # 4. 发起请求
        response = await stub.ArticleList(request)
        for article in response.articles:
            print(article.id, article.title)

if __name__ == '__main__':
    asyncio.run(main())
```

</details>

## 集成到 Django

实现逻辑：先创建一个 app（例如叫做 rpc），然后创建一个命令 runrpcserver，将服务端的 rpc 代码放到命令中

<details>
<summary>1. 创建 gRPC 服务</summary>

<details>
<summary>1.1 创建app名称为rpc，并在settings的INSTALLED_APPS中添加app</summary>

```bash
mkdir rpc
touch rpc/__init__.py
```

</details>

<details>
<summary>1.2 创建python manage.py rungrpcserver命令来启动grpc服务，同时导入文件</summary>

```bash
# 第1步：创建python manage.py rungrpcserver命令
# 第2步：生成/导入article_pb2.py和article_pb2_grpc.py文件
rpc/__init__.py
rpc/article_pb2.py
rpc/article_pb2_grpc.py
rpc/management/__init__.py
rpc/management/commands/__init__.py
rpc/management/commands/rungrpcserver.py

# 第3步：将article_pb2_grpc.py文件中的
import article_pb2 as article__pb2
# 改为下面这一行的形式
from rpc import article_pb2 as article__pb2
```

</details>

<details>
<summary>1.3 编写grpc服务端代码</summary>

```python
# rpc/management/commands/rungrpcserver.py
from django.core.management.base import BaseCommand
from article.models import Article as ArticleModel
from rpc import article_pb2, article_pb2_grpc
import grpc
import asyncio

class ArticleService(article_pb2_grpc.ArticleServiceServicer):
    async def ArticleList(self, request, context):
        page = request.page
        page_size = request.page_size
        print('page:', page, "page_size:", page_size)
        response = article_pb2.ArticleListResponse()
        articles = []
        queryset = ArticleModel.objects.all()
        async for article in queryset:
            articles.append(article_pb2.Article(
                id=article.id,
                title=article.title,
                content=article.content,
                create_time=article.create_time.strftime("%Y-%m-%d")
            ))
        response.articles.extend(articles)
        return response

class Command(BaseCommand):
    async def start(self):
        # 1. 创建一个grpc服务器对象
        server = grpc.aio.server()
        # 2. 将文章服务，添加到server服务器中
        article_pb2_grpc.add_ArticleServiceServicer_to_server(ArticleService(), server)
        # 3. 绑定ip和端口号
        server.add_insecure_port("0.0.0.0:5000")
        # 4. 启动服务
        await server.start()
        print('gRPC服务器已经启动！监听：0.0.0.0:5000')
        # 5. 死循环，等待关闭
        await server.wait_for_termination()

    def handle(self, *args, **options):
        asyncio.run(self.start())
```

</details>
</details>

<details>
<summary>2.启动grpc服务</summary>

```bash
python manage.py rungrpcserver
```

</details>

<details>
<summary>3.实现客户端代码，调用gRPC服务</summary>

```python
# 在另一个django项目的views.py中实现客户端代码
from django.shortcuts import render
import grpc
from rpc import article_pb2, article_pb2_grpc
from django.http.response import JsonResponse

# Create your views here.
async def article_list(request):
    # 通过微服务调用文章列表
    async with grpc.aio.insecure_channel("127.0.0.1:5000") as channel:
        stub = article_pb2_grpc.ArticleServiceStub(channel)
        article_request = article_pb2.ArticleListRequest()
        article_request.page = 2
        article_request.page_size = 10
        response = await stub.ArticleList(request)
        articles = []
        for article in response.articles:
            articles.append({"id": article.id, "title": article.title, "content": article.content})
        return JsonResponse({"articles": articles})
```

</details>
