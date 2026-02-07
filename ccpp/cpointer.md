# Resource

Nginx C编码风格: [https://openresty.org/en/c-coding-style-guide.html](https://openresty.org/en/c-coding-style-guide.html)


# Knowledge

<details>
<summary>并发与多进程编程（重点）</summary>

一、多线程编程（POSIX Threads）

- 线程创建与销毁（`pthread_create`、`pthread_exit`、`pthread_join`）
- 线程函数与参数传递
- 线程属性（detach状态、栈大小等）
- 线程同步（互斥锁 `pthread_mutex_t`）
- 条件变量（`pthread_cond_t`）
- 读写锁（`pthread_rwlock_t`）
- 局部线程存储（`pthread_key_t`）
- 死锁与避免策略

---

二、多进程编程（UNIX Process Model）

- 进程创建（`fork`）
- 进程替换（`exec` 系列）
- 进程终止与回收（`exit`、`_exit`、`wait`、`waitpid`）
- 父子进程通信基础
- 僵尸进程与孤儿进程处理

---

三、协程实现基础

- 协程概念与区别于线程
- `setjmp`/`longjmp` 实现用户态协程
- 状态机与调度器模拟
- 栈切换基础（高级技巧）
- 用户空间协程库（如libco、libtask）

---

四、并发控制与通信机制

- 原子操作（`__sync_*`, `__atomic_*` built-ins）
- 内存屏障与可见性
- 信号量（`sem_t`）
- 进程间通信（IPC）

  - 管道（`pipe`, `popen`）
  - 命名管道（FIFO）
  - 消息队列（`msgget`, `msgsnd`, `msgrcv`）
  - 信号（`signal`, `sigaction`）
  - 共享内存（`shmget`, `shmat`）
  - 套接字通信（UNIX domain sockets）

---

五、线程池与任务调度模型

- 简易线程池实现结构
- 任务队列与消费者模型
- 线程安全的数据结构
- 工作窃取与负载均衡模型（高级）

</details>

<details>
<summary>网络编程（重点）</summary>

一、Socket 编程基础（基于 BSD Socket API）

- 套接字创建与关闭（`socket`, `close`）
- 地址结构（`sockaddr_in`, `sockaddr`, `inet_pton`, `inet_ntop`）
- 端口与 IP 地址的绑定（`bind`）
- 连接建立（`connect`、`listen`、`accept`）
- 数据发送与接收（`send`, `recv`, `read`, `write`）
- 字节序转换函数（`htons`, `htonl`, `ntohs`, `ntohl`）

---

二、客户端与服务器模型

- TCP 客户端与服务端基本结构
- UDP 编程模型（`sendto`, `recvfrom`）
- 并发服务器设计（多线程、多进程、I/O 多路复用）
- 非阻塞 Socket 与超时处理

---

三、I/O 多路复用技术

- `select` 模型
- `poll` 模型
- `epoll` 模型（Linux）
- 事件驱动框架基础设计
- 文件描述符与事件管理

---

四、协议解析与封装

- 应用层协议设计（报文格式、长度头、状态码）
- 自定义二进制协议与文本协议
- HTTP 协议解析基础
- 粘包与拆包处理方法
- 使用状态机解析复杂协议

---

五、进阶网络编程技巧

- 多端口监听与负载均衡
- 网络连接池设计
- 超时与重试机制
- 心跳检测与连接保活（TCP Keepalive）
- 使用 `getsockopt` / `setsockopt` 进行 Socket 配置

---

六、网络调试与工具使用

- `netstat`, `ss`, `lsof` 查看端口与连接
- `tcpdump` 抓包分析
- `telnet`, `nc`, `curl` 进行连接测试
- `wireshark` 进行协议层分析
- 利用 `strace`, `ltrace` 追踪网络调用

</details>

<details>
<summary>工程项目目录结构</summary>

```bash
your_project/
├── CMakeLists.txt            # 或 Makefile：构建入口
├── README.md                 # 项目说明文档
├── LICENSE                   # 项目许可证
├── .gitignore                # Git 忽略配置

├── build/                    # 构建输出目录（推荐外部构建）
│   └── ...                   # 中间文件、可执行文件、库等

├── src/                      # 源码目录
│   ├── main.c                # 程序入口
│   ├── core/                 # 核心逻辑模块
│   │   ├── core.c
│   │   └── core.h
│   ├── net/                  # 网络相关模块
│   │   ├── server.c
│   │   ├── client.c
│   │   └── net.h
│   ├── util/                 # 工具函数模块
│   │   ├── logger.c
│   │   ├── logger.h
│   │   └── config.c
│   │   └── config.h
│   └── db/                   # 数据库接口层
│       ├── db_sqlite.c
│       ├── db_sqlite.h
│       └── orm.c
│       └── orm.h

├── include/                  # 公共头文件（暴露给外部模块）
│   └── your_project/         # 命名空间目录，防止头文件污染
│       ├── api.h
│       └── version.h

├── lib/                      # 外部库（可选：源码或二进制）
│   └── third_party_lib/      # 如 uthash, cJSON 等源码引入

├── tests/                    # 单元测试目录
│   ├── test_main.c
│   ├── test_core.c
│   ├── test_net.c
│   └── mocks/                # 测试替代接口（Mock）
│       └── mock_db.c

├── docs/                     # 项目文档
│   ├── architecture.md
│   ├── api_reference.md
│   └── design_notes.md

├── scripts/                  # 构建、部署、测试相关脚本
│   ├── build.sh
│   ├── test.sh
│   └── deploy.sh

├── examples/                 # 示例代码或用法演示
│   └── demo_client.c

└── tools/                    # 工具/生成器/辅助程序
    └── config_gen.c
```

</details>
