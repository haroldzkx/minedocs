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

# Python

## 基础

gRPC Python Asyncio API: [https://grpc.github.io/grpc/python/grpc_asyncio.html](https://grpc.github.io/grpc/python/grpc_asyncio.html)

安装 gRPC: [https://grpc.io/docs/languages/python/quickstart/#prerequisites](https://grpc.io/docs/languages/python/quickstart/#prerequisites)

PyCharm 安装 Protobuf 插件: [https://plugins.jetbrains.com/plugin/14004-protocol-buffers](https://plugins.jetbrains.com/plugin/14004-protocol-buffers)

VSCode 安装 Protobuf 插件: [https://marketplace.visualstudio.com/items?itemName=zxh404.vscode-proto3](https://marketplace.visualstudio.com/items?itemName=zxh404.vscode-proto3)

Quick Start: [https://grpc.io/docs/languages/python/quickstart/](https://grpc.io/docs/languages/python/quickstart/)

步骤:

1. 安装依赖: [https://grpc.io/docs/languages/python/quickstart/#prerequisites](https://grpc.io/docs/languages/python/quickstart/#prerequisites)

2. 生成 .proto 文件

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

## 集成到 Django

1. 创建 gRPC 服务

2. 运行 rpc 服务

3. 调用 gRPC 服务
