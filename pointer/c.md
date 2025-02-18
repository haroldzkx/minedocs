
<details>
<summary>基础语法</summary>

一、C语言基础语法与构成

- C语言程序结构
- 关键字（Keywords）
- 标识符命名规则
- 数据类型（基本类型、派生类型、自定义类型）
- 运算符与表达式
- 控制语句
- 函数定义与调用
- 头文件与宏定义
- 变量作用域与存储类型
- 输入输出函数

---

二、数据类型与类型转换

- 整型、字符型、浮点型
- 枚举类型
- typedef 定义别名
- 隐式类型转换
- 显式类型转换（强制转换）

---

三、控制流程结构

- 条件语句（if, if-else, switch）
- 循环语句（while, do-while, for）
- 跳转语句（break, continue, goto）
- return 语句

---

四、数组与字符串

- 一维数组
- 多维数组
- 字符数组与字符串常量
- 字符串处理函数

---

五、函数与参数传递

- 函数声明与定义
- 函数调用约定
- 值传递与指针传递
- 可变参数函数（`stdarg.h`）

---

六、作用域与存储类

- 局部变量与全局变量
- 静态变量（static）
- 寄存器变量（register）
- 外部变量（extern）
- 常量定义（const）

---

七、编译预处理器

- 宏定义（`#define`）
- 文件包含（`#include`）
- 条件编译（`#ifdef`, `#ifndef`, `#if`, `#else`, `#endif`）
- 宏函数与替换陷阱

</details>

<details>
<summary>指针与内存管理（核心）</summary>

一、指针基础

- 指针的定义与声明
- 指针的取值与地址操作符（`*`, `&`）
- 指针与数组的关系
- 空指针（NULL）
- 指针运算

---

二、指针进阶

- 指向指针的指针（二级指针）
- 函数指针
- 指向数组、结构体、函数的指针
- 指针与const的结合使用
- 指针类型转换

---

三、内存分配与释放

- 动态内存管理概述
- `malloc`、`calloc`、`realloc`、`free`
- 内存分配失败的处理
- 内存泄漏的识别与调试

---

四、常见指针问题

- 野指针
- 悬挂指针
- 空悬指针访问
- 双重释放与重复释放
- 指针越界与未初始化指针

---

五、内存模型与地址空间

- 栈与堆的区别
- 全局区、代码段、数据段、BSS段
- 对齐（alignment）与填充（padding）
- 内存访问顺序与缓存一致性

---

六、内存调试与工具

- 常见内存调试工具（Valgrind、ASan）
- 内存检测与内存统计
- 自定义内存分配器的实现思想
- 宏替换监控内存操作

</details>

<details>
<summary>结构体与共用体</summary>

一、结构体基础

- 结构体的定义与声明
- 结构体变量的初始化
- 结构体成员访问（`.` 与 `->`）
- 嵌套结构体
- 结构体数组

---

二、结构体进阶

- 结构体作为函数参数与返回值
- 结构体指针与动态分配
- 不完整类型的使用（不透明结构体）
- 自引用结构体与链表实现

---

三、结构体对齐与内存布局

- 成员排列与内存对齐规则
- 字节对齐（`#pragma pack`）
- 内存填充与结构体大小计算
- 位字段（bit-fields）的使用与限制

---

四、共用体（联合体）基础

- 共用体的定义与声明
- 共用体成员访问
- 共用体与结构体的组合使用
- 共用体的典型用途（节省内存、协议解析等）

---

五、结构体与共用体比较

- 内存占用差异
- 用途与应用场景对比
- 安全性与可读性考量

</details>

<details>
<summary>面向过程编程范式（C语言本质）</summary>

以下是 **第四个方向：面向过程编程*- 的结构化知识点，仅列出标题：

---

一、面向过程编程概述

- 程序=数据结构+算法 的设计思想
- 从功能出发的分解与组织方式
- 顺序执行、模块划分与函数抽象

---

二、函数的模块化设计

- 单一职责函数设计
- 函数命名与文件组织规范
- 函数的声明与定义分离（.h/.c）
- 函数重用与代码复用

---

三、全局状态管理

- 全局变量的作用与限制
- 静态变量用于局部状态保持
- 状态机实现方式

---

四、错误处理机制

- 错误码定义（返回值约定）
- errno 与标准错误处理
- 分层错误传递与处理封装

---

五、项目结构与组织方式

- 多文件程序组织（头文件与源文件）
- 接口暴露与实现隐藏
- 模块解耦与依赖关系管理

---

六、函数式技巧在过程式中的体现

- 回调函数与策略模式模拟
- 函数指针表（dispatch table）
- 参数封装结构体（context参数）

</details>

<details>
<summary>标准库使用</summary>

一、标准输入输出库（`<stdio.h>`）

- 输入函数（`scanf`、`gets`、`fgets`）
- 输出函数（`printf`、`puts`、`fputs`）
- 文件操作（`fopen`、`fread`、`fwrite`、`fclose`）
- 文件定位与缓冲控制

---

二、标准通用工具库（`<stdlib.h>`）

- 内存分配与释放（`malloc`、`calloc`、`realloc`、`free`）
- 程序控制（`exit`、`abort`、`atexit`）
- 字符串转换函数（`atoi`、`strtol`、`strtod` 等）
- 随机数生成（`rand`、`srand`）
- 排序与查找（`qsort`、`bsearch`）

---

三、字符串处理库（`<string.h>`）

- 字符串拷贝与拼接（`strcpy`、`strncpy`、`strcat`、`strncat`）
- 字符串比较（`strcmp`、`strncmp`）
- 字符串搜索（`strchr`、`strstr`）
- 内存操作函数（`memcpy`、`memset`、`memcmp`）

---

四、字符处理与分类（`<ctype.h>`）

- 字符判断函数（`isalpha`、`isdigit`、`isspace` 等）
- 大小写转换函数（`toupper`、`tolower`）

---

五、时间与日期处理（`<time.h>`）

- 时间类型与结构体（`time_t`、`struct tm`）
- 时间获取与格式化（`time`、`localtime`、`strftime`）
- 程序延迟与时间间隔计算

---

六、数学函数库（`<math.h>`）

- 常用数学函数（`sqrt`、`pow`、`sin`、`cos`、`log` 等）
- 误差处理与特殊值（`isnan`、`isinf` 等）
- 数值近似与精度控制

---

七、断言与错误处理（`<assert.h>`、`<errno.h>`）

- 使用 `assert` 进行调试检查
- 错误码与全局变量 `errno`
- 错误信息输出（`perror`、`strerror`）

</details>

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
<summary>编译工具链</summary>

一、GCC 编译器使用

- 基本编译流程（预处理、编译、汇编、链接）
- 常用参数（`-Wall`, `-g`, `-O`, `-std`, `-I`, `-L`, `-l`）
- 多文件编译与依赖管理
- 静态库与动态库编译（`.a`, `.so`）
- 链接顺序与符号解析

---

二、GDB 调试器使用

- 设置断点、单步执行（`break`, `next`, `step`）
- 查看变量与内存（`print`, `x`, `info locals`）
- 调用栈分析（`backtrace`）
- 条件断点与自动化脚本
- 栈溢出与段错误调试

---

三、Make 与 Makefile 编写

- 基本语法与变量定义
- 目标、依赖与命令块
- 自动依赖生成与 `.d` 文件
- 多目标与伪目标（`clean`, `all` 等）
- 通用模板与自动化构建逻辑

---

四、CMake 入门与项目组织

- CMakeLists.txt 编写基础
- 添加子目录与模块化构建
- 编译选项与条件控制
- 与 IDE（如 CLion、VSCode）集成
- 生成 Makefile / Ninja 构建文件

---

五、静态检查与代码分析工具

- `clang-format` / `astyle` 代码风格统一
- `cppcheck` / `splint` 静态分析工具
- `gcov` / `lcov` 覆盖率分析
- `valgrind` 内存检测（泄漏、越界、未初始化）
- `address sanitizer`, `undefined behavior sanitizer`

---

六、构建自动化与持续集成

- Make 与 shell 脚本集成构建流程
- 与 Git Hooks 集成自动测试
- GitHub Actions / GitLab CI + CMake 编译测试
- 版本号与构建信息注入（`__DATE__`, `__TIME__`, Git hash）

</details>

<details>
<summary>数据库访问与轻量 ORM</summary>

一、数据库基础与类型选择

- 常用嵌入式数据库（如 SQLite）
- 客户端-服务端架构数据库（如 PostgreSQL）
- 数据模型与表结构设计基础
- SQL 基础语法（SELECT、INSERT、UPDATE、DELETE）

---

二、C语言数据库接口

- SQLite C API 使用

  - 打开与关闭数据库（`sqlite3_open`, `sqlite3_close`）
  - 执行 SQL（`sqlite3_exec`, `sqlite3_prepare_v2`）
  - 查询与结果遍历（`sqlite3_step`, `sqlite3_column_*`）
  - 事务处理（BEGIN, COMMIT, ROLLBACK）
- PostgreSQL libpq 接口使用

  - 连接与关闭（`PQconnectdb`, `PQfinish`）
  - 查询执行与结果处理（`PQexec`, `PQgetvalue`）
  - 错误处理与状态检查

---

三、ORM思想在C中的模拟

- 数据结构与表字段映射
- 动态 SQL 构造与格式化（`snprintf` + SQL语句拼接）
- 结构体与数据库映射辅助函数封装
- CRUD 操作的函数抽象
- ORM 与事务封装

---

四、与多线程结合的高并发访问

- 数据库句柄线程安全性分析
- SQLite 多线程模式配置（单线程、多线程、序列化）
- 线程内连接复用与连接池管理
- 批量操作与锁粒度控制
- 任务队列与数据库操作线程分离（生产者-消费者模型）

---

五、数据库调试与性能优化

- SQL语句性能分析（`EXPLAIN`, `ANALYZE`）
- 准备语句与缓存优化
- 连接复用与连接数限制处理
- 锁冲突分析与死锁检测
- 日志记录与异常恢复机制设计

</details>

<details>
<summary>性能优化与内存模型</summary>

一、C语言运行时内存模型

- 内存分区结构（代码段、数据段、BSS、堆、栈）
- 局部变量与栈帧布局
- 全局变量与初始化状态
- 静态变量生命周期与作用域

---

二、CPU缓存与内存访问优化

- 局部性原理（时间局部性、空间局部性）
- Cache 行大小与 false sharing
- 数据对齐与内存填充（padding）
- 内存预取优化
- 避免跨缓存行访问的数据结构设计

---

三、编译器优化与选项

- 编译优化等级（`-O0`, `-O1`, `-O2`, `-O3`, `-Ofast`）
- 内联展开与函数内联（`inline` 与 `-finline-functions`）
- 循环展开、循环交换、矢量化（`-funroll-loops`, `-ftree-vectorize`）
- LTO（Link Time Optimization）
- 冷热路径分离与 branch prediction hints

---

四、内存使用优化

- 动态内存池与对象复用策略
- 避免频繁 malloc/free 操作
- 内存碎片分析与管理
- 自定义内存分配器设计（arena, slab）
- 内存泄漏检测与分析工具使用（Valgrind, ASan）

---

五、性能分析工具与方法

- `gprof`, `perf` CPU profiling
- Cache miss 统计与分析（`perf stat`）
- 实时内存监测（`htop`, `top`, `vmstat`）
- 反汇编分析（`objdump`, `nm`, `readelf`, `disas` in gdb）
- Benchmark 测试与性能回归对比

</details>

<details>
<summary>单元测试与持续集成</summary>

一、测试基础

- 单元测试定义与粒度选择
- 手动测试与调试输出
- 使用断言进行逻辑校验（`assert.h`）
- 边界条件与非法输入测试

---

二、C语言常用测试框架

- CMocka 框架使用
- Check 框架使用
- Unity（轻量测试框架）
- Criterion（现代结构化单元测试框架）
- 测试框架选择比较

---

三、测试组织与策略

- 测试用例设计（正常路径、异常路径、边界路径）
- 测试模块结构（tests 目录、test\_\*.c 文件）
- Mock 技术模拟外部依赖
- 参数化测试与数据驱动测试
- 回归测试与持续集成中的测试运行

---

四、覆盖率分析

- 使用 `gcov` 进行覆盖率检测
- `lcov` 生成可视化报告
- 分支覆盖与条件覆盖
- 避免测试遗漏的关键点

---

五、集成测试与自动化工具链

- 与 Make/CMake 集成测试构建
- 使用脚本批量执行测试集
- Git Hooks 自动化执行测试
- CI 平台测试集成（GitHub Actions, GitLab CI）
- 编译型测试与运行时测试分离设计

</details>

<details>
<summary>常用第三方库</summary>

一、通用工具与辅助功能库

- `glib`（数据结构、哈希表、字符串处理、线程抽象）
- `uthash`（哈希表实现）
- `inih`（INI 配置解析）
- `argp` / `argparse`（命令行参数解析）
- `log.c` / `zlog`（日志系统）

---

二、数据格式与序列化处理

- `cJSON` / `jansson`（JSON 解析与构建）
- `libxml2`（XML 解析）
- `protobuf-c`（Protocol Buffers 支持）
- `flatcc`（FlatBuffers 支持）

---

三、网络通信与协议支持

- `libcurl`（HTTP/HTTPS 客户端）
- `libwebsockets`（WebSocket 支持）
- `libevent`（事件驱动模型）
- `libuv`（跨平台异步 I/O 与线程池）
- `nanomsg` / `zeromq`（消息传递与通信中间件）

---

四、安全与加密

- `OpenSSL`（加密、TLS/SSL 通信）
- `libsodium`（现代加密与认证库）
- `mbedTLS`（轻量级加密通信库）
- 哈希与摘要函数库（如 `md5`, `sha1`, `bcrypt`）

---

五、系统与平台支持库

- `SDL2`（跨平台图形与输入支持）
- `ncurses`（终端图形界面）
- `libpthread`（线程抽象）
- `libpcap`（抓包与网络分析）
- `readline`（命令行输入支持）

---

六、构建与集成

- 第三方库的获取与管理（源码引入、pkg-config、系统安装）
- 与 CMake/Makefile 集成方式（`find_package`, `add_subdirectory`）
- 静态链接与动态链接注意事项
- 跨平台兼容性与头文件处理

</details>

<details>
<summary>架构设计与项目组织</summary>

一、项目结构设计

- 基本目录结构（`src/`, `include/`, `lib/`, `tests/`, `build/`, `docs/`）
- 头文件与源文件分离策略
- 公共模块与私有模块的划分
- 单体项目与多模块项目组织

---

二、模块化与分层架构

- 功能模块封装（逻辑模块、I/O模块、协议模块等）
- 分层设计（表示层、业务层、数据访问层）
- 依赖关系最小化与模块解耦
- 使用接口与抽象层代替硬编码依赖

---

三、接口设计与抽象方式

- 头文件接口设计规范（命名、结构体、函数原型）
- 函数指针与回调实现策略模式
- 虚拟接口模拟（函数表 dispatch table）
- 封装上下文结构体传递状态

---

四、工程可维护性设计

- 编码规范与风格统一（缩进、命名、注释）
- 日志系统集成（log 级别、输出控制）
- 全局错误处理机制（错误码设计、错误描述映射）
- 配置文件系统与启动参数解析

---

五、编译与构建系统设计

- 多平台构建支持（Linux, Windows, macOS）
- 依赖库管理（本地源码、pkg-config、CMake FetchContent）
- Debug/Release 模式区分
- 版本管理与构建元信息注入（Git hash、编译时间）

---

六、部署与发布流程

- 构建产物（静态库、动态库、可执行文件）
- 打包与安装脚本（Make install、CMake install、shell）
- 多平台打包（tar, zip, deb, rpm）
- 项目文档自动生成与集成（如 Doxygen）

</details>

---

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
