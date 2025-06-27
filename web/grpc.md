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

# gRPC进阶

进阶内容的代码都是通过article.proto来是实现的

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

## 拦截器

## 错误处理

## 超时机制

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

实现逻辑：先创建一个app（例如叫做rpc），然后创建一个命令runrpcserver，将服务端的rpc代码放到命令中

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

<details>
<summary></summary>

</details>




