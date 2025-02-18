Book Mapper:

- b1: C++ Primer 第 5 版
- b2: C++ 程序设计语言（第 1~3 部分）原书第 4 版
- b3: C++ 程序设计语言（第 4 部分：标准库）原书第 4 版
- 例：[b1-p30-c2.1.1]() 表示《C++ Primer 第 5 版》第 30 页 章节 2.1.1

# 1.基础语法

<details>
<summary>1.1 数据类型与类型转换</summary>

内置类型 [b1-p30-c2.1.1]() / [b2-p118-c6.2]()

- 整型：bool, char, wchar_t, char16_t, char32_t, short, int, long, long long
- 带符号的整型：short, int, long, long long
- 无符号的整型：unsigned short, unsigned int, unsigned long, unsigned long long
- 字符型：char, signed char, unsigned char
- 浮点型（默认包含符号）：float, double, long double
- 前缀与后缀

类型转换 [b1-p32-c2.1.2]()

- 隐式类型转换 [b1-p143-c4.11.2]() / [b2-p231-c10.5]()
- 显式类型转换 [b1-p144-c4.11.3]() / [b2-p258-c11.5]()
- C 风格显式类型转换
- C++ 风格类型转换（static_cast, const_cast, reinterpret_cast, dynamic_cast）

复合类型：枚举 [b1-p736-c19.3]() / [b2-p188-c8.4]()

- enum class/struct: 限定作用域的枚举类型【推荐全部使用这种】
- enum（命名的，未命名的）: 不限定作用域的枚举类型

复合类型：引用 [b1-p45-c2.3.1]() / [b2-p163-c7.7]()

- 给变量起别名
- 引用做函数返回值
- 常量引用（修饰形参，防止误操作）

复合类型：指针 [b1-p47-c2.3.2]() / [b1-p51-c2.3.3]() / [b2-p148-c7.2]()

复合类型：结构体 [b1-p64-c2.6]() / [b2-p173-c8.2]()

复合类型：联合体 [b1-p749-c19.6]() / [b2-p183-c8.3]()

复合类型：数组

复合类型：类

复合类型：模板类型

处理类型：

- 类型别名 [b1-p60-c2.5.1]() / [b2-p146-c6.5]()
- 推断类型：auto [b1-p61-c2.5.2]() / [b2-p141-c6.3.6]()
- 推断类型：decltype [b1-p62-c2.5.3]() / [b2-p141-c6.3.6]()

</details>

---

<details>
<summary>1.2 变量，常量，const</summary>

变量定义，初始化，列表初始化 [b1-p38-c2.2.1]() / [b2-p138-c6.3.5]()

变量声明，以及与变量定义的区别 [b1-p41-c2.2.2]()

变量命名规范

作用域（全局作用域、局部作用域、类作用域、名字空间作用域、语句作用域、函数作用域） [b1-p43-c2.2.4]() / [b2-p136-c6.3.4]()

const 变量 [b1-p53-c2.4]()

const 常量引用 [b1-p55-c2.4.1]()

const 与指针 [b1-p56-c2.4.2]() / [b2-p161-c7.5]()

- const修饰指针（常量指针）`const int *a = &b;`

- const修饰常量（指针常量）`int *const a = &b;`

- const修饰指针和常量 `const int *const a = &b;`

顶层 const 与 底层 const [b1-p57-c2.4.3]()

constexpr 与常量表达式 [b1-p58-c2.4.4]() / [b2-p227-c10.4]()

</details>

---

<details>
<summary>1.3 指针</summary>

复合类型：指针 [b1-p47-c2.3.2]() / [b1-p51-c2.3.3]() / [b2-p148-c7.2]()

- 获取对象的地址
- 指针值
- 利用指针访问对象
- 空指针 nullptr [b1-p48-c2.3.2]() / [b2-p150-c7.2.2]()
- 野指针
- void* 指针 [b1-p50-c2.3.2]() / [b2-p149-c7.2.1]()
- 二级指针（指向指针的指针）
- 指向指针的引用
- const 修饰指针
- 指针和数组
- 指针和函数
- 指针与所有权 [b2-p163-c7.6]()

</details>

---

<details>
<summary>1.4 数组与字符串</summary>

数组 [b1-p101-c3.5]() / [b2-p150-c7.3]()

- 数组定义与初始化 [b1-p101-c3.5.1]() / [b2-p152-c7.3.1]()
- 访问数组元素 [b1-p104-c3.5.2]() / [b2-p156-c7.4.1]()
- 数组与指针 [b1-p105-c3.5.3]() / [b2-p155-c7.4]()
- 传递数组 [b2-p159-c7.4.3]()

多维数组（数组的数组）[b1-p112-c3.6]() / [b2-p158-c7.4.2]()

- 初始化
- 下标引用
- 范围 for 语句处理多维数组
- 指针操作多维数组

字符串 [b3-p146-c36]()

- C 风格字符串（cstring） [b1-p109-c3.5.4]()
- std::string [b1-p76-c3.2]()
- string 构造函数 [b3-p151-c36.3.2]()
- string 基本操作 [b3-p152-c36.3.3]()
- string 字符串IO [b3-p153-c36.3.4]()
- string 相关的 STL 操作 [b3-p155-c36.3.6]()
- string 的 find 系列函数 [b3-p157-c36.3.7]()
- string 子串 [b3-p158-c36.3.8]()

</details>

---

<details>
<summary>1.5 语句与表达式</summary>

运算符 / 表达式 [b1-p119-c4]() / [b2-p220-c10.3]()

- 算术运算符
- 逻辑和关系运算符
- 赋值运算符
- 递增和递减运算符
- 成员访问运算符
- 条件运算符
- 位运算符
- sizeof 运算符
- 逗号运算符
- 运算符优先级

语句 [b1-p153-c5]()

- 语句作用域
- 条件语句（if, else if, else, switch）
- 迭代语句（传统 for 语句, 范围 for 语句, while, do-while）
- 跳转语句（break, continue, goto）

</details>

---

<details>
<summary>1.6 文件操作与IO流</summary>

IO流 [b1-p277-c8]() / [b1-p666-c17.5]() / [b3-p178-c38]()

- istream（输入流）、cin (istream 对象)、输入操作 [b3-p185-c38.4]()
- ostream（输出流）、cout (ostream 对象)、cerr (ostream 对象)、输出操作 [b3-p187-c38.5]()
- iostream
- `>>` 运算符、`<<` 运算符
- getline 函数
- sstream (string流) [b1-p287-c8.3]() / [b3-p182-c38.2.2]()
- 格式化输入与输出 [b1-p666-c17.5.1]() / [b3-p194-c38.4.5]()
- 流随机访问 [b1-p676-c17.5.3]()
- 错误处理 [b3-p183-c38.3]()
- 流迭代器 [b3-p200-c38.5]()

文件操作 [b1-p283-c8.2]() / [b3-p180-c38.2.1]()

- 文件类型：文本文件、二进制文件
- ifstream
- ofstream
- fstream
- 文件模式：文件打开的方式 [b1-p286-c8.2.2]()

</details>

---

<details>
<summary>1.7 源文件与程序组织方式、命名空间</summary>

分离编译 [b2-p45-c2.4.1]() / [b2-p362-c15.1]()

- 接口与实现的分离 .h .cpp

链接 [b2-p363-c15.2]()

- 头文件 .h [b2-p366-c15.2.2]()
- 标准库头文件 [b2-p369-c15.2.4]()

使用头文件 [b2-p373-c15.3]()

- 单头文件组织
- 多头文件组织
- 头文件保护

main 函数 [b2-p381-c15.4]()

命名空间（namespace, using） [b1-p695-c18.2]() / [b2-p46-c2.4.2]() / [b2-p337-c14]()

</details>

---

<details>
<summary>1.8 函数</summary>

- 函数定义 [b1-p182-c6.1]() / [b2-p266-c12.1.3]()
- 函数声明 [b1-p186-c6.1.2]() / [b2-p264-c12.1]()
- 函数参数传递（值传递、引用传递、列表传递、数组传递），形参与实参，默认参数 [b1-p187-c6.2.1]() / [b2-p273-c12.2]()
- 函数返回类型和 return 语句 [b1-p199-c6.3]() / [b2-p267-c12.1.4]()
- 函数重载 [b1-p207-c6.4]() / [b2-p282-c12.3]()
- 函数指针 [b1-p221-c6.7]() / [b2-p288-c12.5]()
- lambda 表达式 [b2-p251-c11.4]()
- 递归函数
- 内联函数（inline）[b2-p269-c12.1.5]()
- constexpr 函数 [b2-p269-c12.1.6]()

</details>

---

# 2.面向对象编程

<details>
<summary>面向对象编程</summary>

面向对象基本概念

- 类（Class）与对象（Object）
- 封装（Encapsulation）
- 继承（Inheritance）
- 多态（Polymorphism）
- 抽象（Abstraction）
- this 指针
- 面向对象 vs 面向过程 编程思想比较

类的定义与成员

- 成员变量
- 成员函数
- 构造函数
- 析构函数
- 拷贝构造函数
- 拷贝赋值运算符
- 移动构造函数
- 移动赋值运算符
- 访问控制修饰符（`public`, `private`, `protected`）

构造函数与对象生命周期

- 默认构造函数
- 带参构造函数
- 构造函数初始化列表
- 构造函数重载
- 析构函数的自动调用机制
- 静态成员与静态成员函数
- 静态对象与局部静态对象

对象的复制与移动

- 拷贝构造与深浅拷贝
- 拷贝赋值函数
- 移动构造函数（C++11 起）
- 移动赋值运算符
- Rule of Three / Five / Zero

成员函数相关特性

- const 成员函数
- 内联成员函数
- 成员函数重载
- 类内定义与类外定义

继承与派生类

- 公有继承、私有继承、保护继承
- 基类与派生类的关系
- 构造函数调用顺序
- 多层继承
- 对象切片问题

多态（动态绑定）

- 虚函数（virtual）
- 纯虚函数与抽象类
- 重写（override）
- 虚函数表（vtable）机制
- 基类指针调用派生类对象
- 多态与资源释放（虚析构函数）

运算符重载

- 成员函数重载运算符
- 非成员函数重载运算符
- 友元函数与运算符重载
- 常用可重载运算符（+、-、==、\[]、()、-> 等）

友元与访问控制扩展

- 友元函数
- 友元类
- 访问权限控制原则

this 指针与指针操作

- this 指针的定义与用途
- 链式调用
- 检测自赋值

静态成员与类属性

- 静态变量与类共享属性
- 静态函数与访问限制
- 静态成员初始化方式

命名空间与作用域管理（OOP 中使用）

- 命名冲突规避
- 类作用域解析符（`::`）

类之间的关系建模

- “has-a” 关系（组合 / 聚合）
- “is-a” 关系（继承）
- 依赖关系（参数、局部变量）
- 多重继承（基础）
- 虚继承（菱形继承问题）

</details>

# 3.模板与泛型编程

<details>
<summary>模板与泛型编程</summary>

模板基础

- 函数模板
- 类模板
- 模板参数的类型推导
- 默认模板参数
- 显式指定模板参数
- 模板的分离编译问题

模板特化

- 模板特化（全特化）
- 偏特化（Partial Specialization）
- 成员函数特化
- 静态成员变量特化

非类型模板参数

- 整数常量作为模板参数
- 枚举值作为模板参数
- 指针/引用作为非类型模板参数
- 字符串字面量与数组作为模板参数（C++20）

变参模板（可变参数模板）

- 参数包（parameter pack）
- 展开参数包（pack expansion）
- 递归展开 vs 折叠表达式（C++17 起）
- 模板中的递归与分支控制

模板元编程（TMP 基础）

- 编译期常量计算
- 类型萃取（Type Traits 基础）
- 条件编译与 `std::enable_if`
- SFINAE（Substitution Failure Is Not An Error）
- tag dispatching（标签分发）

类型萃取与判断

- `std::is_same`, `std::is_integral`, `std::remove_reference`, 等
- `std::decay`, `std::enable_if`, `std::conditional`
- 使用 `type_traits` 库实现编译期类型判断

模板与继承

- 模板类的继承
- CRTP（Curiously Recurring Template Pattern）
- 多态与模板的组合使用
- 模板中使用 `typedef` / `using` 别名

模板别名与特性宏

- `template <typename T> using Alias = ...`
- `decltype`, `decltype(auto)` 与模板联动
- `auto` 与模板推导结合（C++14+）

Concepts（C++20 起）

- 基本概念（`concept` 定义）
- 模板参数约束
- `requires` 表达式
- 标准库提供的 Concepts（如 `std::integral`, `std::floating_point`）
- Concepts 与 enable\_if 的区别与替代关系

泛型编程范式

- 类型无关的算法设计
- STL 中的泛型思想体现
- 迭代器适配器与类型抽象
- 类型参数解耦实现算法复用
- 编译期 vs 运行时多态（策略选择）

</details>

# 4.标准库与STL的使用

<details>
<summary>标准库与STL的使用</summary>

（掌握好怎么用就行，不需要深入到源码去分析）

STL 基础概念

- STL 的六大组件（容器、算法、迭代器、函数对象、适配器、分配器）
- 模板与泛型在 STL 中的体现
- 标准库命名空间（`std`）

---

容器（Containers）

顺序容器

- `std::vector`
- `std::deque`
- `std::list`
- `std::array`（C++11）
- `std::forward_list`（C++11）

关联容器

- `std::set`, `std::multiset`
- `std::map`, `std::multimap`

无序容器（哈希容器，C++11 起）

- `std::unordered_set`, `std::unordered_multiset`
- `std::unordered_map`, `std::unordered_multimap`

容器常见操作

- 插入、删除、查找
- 访问元素方式（`at`, `[]`, `front`, `back`）
- 容器大小与容量管理（`size`, `capacity`, `reserve`, `shrink_to_fit`）
- 遍历方式（迭代器、范围 for 循环）

---

迭代器（Iterators）

- 迭代器种类（输入、输出、前向、双向、随机访问）
- 容器提供的迭代器（`begin`, `end`, `rbegin`, `rend`）
- `std::advance`, `std::next`, `std::prev`
- 插入迭代器（`std::back_inserter`, `std::front_inserter`, `std::inserter`）
- 迭代器失效问题（插入、删除导致的无效引用）

算法（Algorithms）

- 通用算法（`std::sort`, `std::find`, `std::copy`, `std::accumulate`, `std::for_each`）
- 修改型算法（`remove`, `replace`, `transform`, `fill`）
- 查找与比较（`find_if`, `all_of`, `any_of`, `none_of`）
- 排序与搜索（`binary_search`, `lower_bound`, `upper_bound`）
- 数值算法（`std::accumulate`, `std::inner_product`）

函数对象与 Lambda

- 函数对象（仿函数）
- STL 提供的函数对象（`std::less`, `std::greater`, `std::plus` 等）
- Lambda 表达式（与算法结合使用）
- 捕获变量与闭包类型

适配器（Adapters）

- 容器适配器：`std::stack`, `std::queue`, `std::priority_queue`
- 函数适配器：`std::bind`, `std::function`（C++11 起）

字符串处理

- `std::string` 基本操作
- 拼接、查找、截取、替换
- 字符串转数字：`std::stoi`, `std::stod`, `std::to_string`
- 字符数组与 `std::string` 转换
- C++20 中的 `std::string_view`

智能指针（C++11 起）

- `std::unique_ptr`
- `std::shared_ptr`
- `std::weak_ptr`
- `make_unique`, `make_shared`
- 引用计数与生命周期管理

时间与日期（<chrono>）

- `std::chrono::duration`, `time_point`
- `std::this_thread::sleep_for`
- `std::chrono::high_resolution_clock`

通用工具类

- `std::pair`, `std::tuple`
- `std::optional`（C++17）
- `std::variant`, `std::any`（C++17）
- `std::bitset`, `std::array`, `std::valarray`

标准输入输出（I/O）

- 流对象：`std::cin`, `std::cout`, `std::cerr`, `std::clog`
- 文件流：`std::ifstream`, `std::ofstream`, `std::fstream`
- 字符串流：`std::stringstream`, `std::istringstream`, `std::ostringstream`
- I/O 格式控制：`std::setw`, `std::setprecision`, `std::fixed`

异常处理相关

- 标准异常类型（`std::exception`, `std::runtime_error`, `std::logic_error` 等）
- 自定义异常
- `try-catch` 机制的使用

</details>

# 5.并发编程

<details>
<summary>并发编程</summary>

> 多线程，多进程，协程，并发（核心，重中之重）

并发编程基础概念

- 并发 vs 并行
- 线程 vs 进程
- 同步 vs 异步
- CPU 多核与上下文切换
- 数据竞争（Data Race）
- 原子性、可见性、有序性（C++ 内存模型基础）

---

线程（`std::thread`）

- 创建与启动线程
- 线程函数传参
- 主线程等待（`join`）
- 分离线程（`detach`）
- 检查线程状态（`joinable`）

---

线程同步机制

- 互斥锁（`std::mutex`）
- RAII 锁管理（`std::lock_guard`, `std::unique_lock`）
- 条件变量（`std::condition_variable`）
- 递归互斥锁（`std::recursive_mutex`）
- 多线程死锁与避免技巧

---

原子操作（`std::atomic`）

- 原子类型与原子变量
- 原子加载/存储/交换/比较交换操作
- 内存顺序（`memory_order_relaxed` 等）
- 原子操作 vs 互斥锁

---

多线程通信

- 条件变量实现生产者-消费者模型
- 自旋锁（简易实现）
- 信号量（`std::counting_semaphore`，C++20）

---

线程管理与线程池

- 简单线程池设计
- 任务队列封装
- 工作线程模型
- 动态扩展线程池（进阶）

---

C++ 标准库中的并发工具

- `std::async` 与 `std::future`
- `std::packaged_task`
- `std::promise`
- `std::thread::hardware_concurrency`

---

并发容器（基础）

- 并发安全容器的设计思路
- STL 容器的线程安全性说明
- `concurrent_queue`、`concurrent_map`（自定义或基于第三方库）

---

协程（Coroutines, C++20）

- 协程的语法结构（`co_await`, `co_yield`, `co_return`）
- `std::generator` 与 `std::task`
- promise\_type 与 awaiter 对象
- 协程调度器设计基础
- 协程与线程的区别与混用

---

多进程编程（系统编程接口）

- 进程创建（`fork`）
- 可执行替换（`exec` 系列）
- 父子进程通信（`pipe`、`socketpair`）
- 进程间通信（IPC）基础：共享内存、消息队列、信号量
- 僵尸进程与孤儿进程处理

---

高级并发模式

- 生产者-消费者模型
- 多读单写（读写锁）
- 读写分离缓存设计
- 双缓冲队列（Double Buffering）
- 事件驱动并发模型（Reactor / Proactor）

---

内存模型与同步原理（进阶）

- happens-before 关系
- 指令重排
- CPU 缓存一致性
- C++ 原子操作的内存序模型

---

性能调试与并发诊断

- 死锁检测技巧
- 竞态条件定位（race detector 工具）
- 线程活跃性分析（CPU 占用 / 抢占问题）
- 工具链支持（如 `valgrind`, `perf`, `gdb` 多线程调试）


</details>

# 6.网络编程

<details>
<summary>网络编程</summary>

网络编程基础概念

- TCP vs UDP
- 客户端 / 服务端模型
- 套接字（Socket）基础
- 阻塞 vs 非阻塞 IO
- 同步 vs 异步通信
- 半连接队列 / 全连接队列（backlog）

---

套接字编程基础（BSD Socket 接口）

- socket 创建
- 地址结构（IPv4 / IPv6）
- 绑定（`bind`）
- 监听（`listen`）
- 接收连接（`accept`）
- 连接服务器（`connect`）
- 数据收发（`send`, `recv`, `read`, `write`）

---

IP 地址与端口操作

- IP 地址转换函数（`inet_ntoa`, `inet_pton`, `inet_ntop`）
- 网络字节序与主机字节序（`htons`, `htonl`, `ntohs`, `ntohl`）
- 域名解析（`gethostbyname`, `getaddrinfo`）

---

IO 模型

- 阻塞 IO（blocking IO）
- 非阻塞 IO（non-blocking IO）
- IO 多路复用：

  - `select`
  - `poll`
  - `epoll`（边沿触发 ET / 水平触发 LT）
- 信号驱动 IO
- 异步 IO（AIO）

---

多线程与网络通信结合

- 每个连接一个线程模型
- 线程池 + IO 复用模型
- 同步通信中的线程安全
- 高并发连接管理策略

---

高性能网络服务模型

- Reactor 模式（事件分发 + 任务处理）
- Proactor 模式（IO 完成事件驱动）
- 单线程 + epoll 模型
- 多线程 Reactor 模型
- 主从 Reactor 架构

---

连接管理

- 连接超时与心跳机制
- 长连接与短连接
- 连接池基础（TCP/HTTP）
- Keep-Alive 策略

---

网络通信协议基础

- TCP 三次握手 / 四次挥手
- 粘包与拆包问题
- 应用层协议设计（TLV、JSON、Protobuf）
- 自定义协议头解析
- 序列化与反序列化

---

网络库与封装

- 封装 socket 接口为类（面向对象网络层）
- 封装 IO 与 buffer 管理
- 异步网络库使用（如 Boost.Asio、libevent、libuv）
- HTTP 客户端 / 服务端简单实现
- WebSocket 基础支持（基于 TCP）

</details>

# 7.工具链

<details>
<summary>工具链模块分类</summary>

```bash
1. 编译与构建：g++, CMake, Make, Ninja
2. 调试与测试：gdb, core dump, valgrind, asan
3. 性能分析：perf, gprof, Google Benchmark
4. 静态分析与格式化：clang-tidy, cppcheck, clang-format
5. 包管理与依赖：vcpkg, conan
6. 辅助工具：ccache, objdump, ldd, clangd
```

</details>

---

<details>
<summary>编译器 gcc / g++</summary>

- 编译流程：预处理 → 编译 → 汇编 → 链接
- 多文件编译与目标文件管理
- 常用编译参数：

  - `-std=c++xx`、`-Wall`、`-Wextra`、`-Werror`
  - `-O0 ~ -O3`, `-Ofast` 优化等级
  - `-g`, `-c`, `-o`, `-I`, `-L`, `-l`
  - `-pthread`（多线程支持）
  - `-fPIC`, `-shared`, `-static`（用于构建库）
  - `-fsanitize=address/leak/undefined/...`（Sanitizer）

</details>

---

<details>
<summary>调试工具 gdb</summary>

- 启动调试程序
- 设置断点、查看变量、栈帧分析
- 单步执行、修改变量、条件断点
- 调试 core dump 文件
- 查看汇编代码、寄存器、内存状态
- 多线程调试

</details>

---

<details>
<summary>构建系统 Make / Makefile / CMake</summary>

GNU Make / Makefile

- Makefile 结构（目标、依赖、命令）
- 自动变量：`$@`, `$<`, `$^`
- 模式规则、通配符、伪目标 `.PHONY`
- 自动生成依赖文件（`gcc -MMD`）

CMake

- 基本命令：`project`, `add_executable`, `add_library`
- 构建控制：`target_include_directories`, `target_link_libraries`
- 构建类型：Debug / Release
- 多模块项目结构（`add_subdirectory`）
- 编译数据库：`CMAKE_EXPORT_COMPILE_COMMANDS`
- 生成 Ninja 构建文件（`-G Ninja`）

</details>

---

<details>
<summary>静态库与动态库</summary>

- 静态库 `.a` 的创建与链接
- 动态库 `.so` 的构建与使用
- `-fPIC`, `-shared` 编译选项说明
- 运行时库路径配置（`LD_LIBRARY_PATH`）

</details>

---

<details>
<summary>内存分析与内存泄漏检测</summary>

- `valgrind`（内存错误、越界、泄漏）
- `memcheck`, `massif`, `cachegrind`, `callgrind`
- `AddressSanitizer`（`-fsanitize=address`）
- `LeakSanitizer`（`-fsanitize=leak`）
- `MemorySanitizer`（`-fsanitize=memory`）

</details>

---

<details>
<summary>性能分析工具</summary>

- `gprof`（函数级性能统计）
- `perf`（Linux 原生高性能分析工具）
- `callgrind`（配合 KCachegrind 可视化）
- `Google Benchmark`（微基准测试）
- `cachegrind`（缓存命中率模拟）
- Intel VTune Profiler（企业级工具）

</details>

---

<details>
<summary>静态分析与代码质量检查</summary>

- `cppcheck`
- `clang-tidy`
- `clang static analyzer`
- `include-what-you-use`
- `PVS-Studio`（商业工具）
- `-fanalyzer`（GCC 10+ 内建分析器）

</details>

---

<details>
<summary>代码风格与格式化</summary>

- `clang-format`
- `.clang-format` 配置文件书写
- `astyle`

</details>

---

<details>
<summary>包管理与依赖工具</summary>

- `vcpkg`（Microsoft 提供，支持主流 C++ 库）
- `conan`（跨平台 C++ 包管理器）
- `hunter`（CMake 集成包管理）
- 手动添加第三方库（头文件 + `.a`/`.so`）

</details>

---

<details>
<summary>编译器语言支持工具</summary>

- `clangd`（C++ 语言服务器）
- `ccls`（高性能 C/C++/Obj-C LSP）
- `compile_commands.json`（IDE 支持配置）
- 自动补全 / 跳转 / 静态语义分析

</details>

---

<details>
<summary>构建优化与辅助</summary>

- `ccache`（编译缓存加速）
- `ninja`（高性能构建工具，配合 CMake）
- 并行编译：`make -jN`
- 增量构建与 out-of-source 构建（CMake）

</details>

---

<details>
<summary>二进制与符号分析工具</summary>

- `nm`（查看符号表）
- `readelf`（查看 ELF 文件结构）
- `objdump`（反汇编和节信息）
- `ldd`（查看动态依赖库）
- `strip`（移除调试符号）

</details>

---

# 8.数据库与ORM

<details>
<summary>数据库与ORM</summary>

> ODB，看看怎么使用ORM操作数据库，并跟多线程结合起来，实现高并发

C++ 操作数据库的常见方式

- 使用原生驱动（如 `libpq`, `MySQL Connector/C++`）
- 使用封装库（如 SOCI, SQLiteCpp）
- 使用 ORM 框架（如 ODB）
- 通过 C 接口调用数据库客户端库

---

ORM（对象-关系映射）基础

- ORM 的核心概念（类 ↔ 表，成员变量 ↔ 字段）
- 映射类型支持（基础类型、枚举、时间、字符串）
- 持久化（insert/update/delete）
- 数据查询（主键查询、条件查询、范围查询）
- 事务支持与嵌套事务
- 延迟加载 vs 立即加载
- 映射一对多 / 多对多关系
- 映射继承关系（单表、多表）

---

ODB 框架使用（C++ ORM）

- ODB 安装与编译器插件（odb 编译器）
- 数据库驱动支持（PostgreSQL, MySQL, SQLite）
- 类与表的映射定义（`#pragma db`）
- 数据库 schema 自动生成
- 会话（`odb::session`）与对象缓存
- 查询语言表达式（`query<>`, `result<>`）
- 事务控制（`odb::transaction`）
- 数据库连接配置与连接池整合

---

ORM 与多线程结合

- 每个线程一个数据库连接 vs 连接池共享
- ORM 对象生命周期与线程安全
- 查询任务在线程池中调度
- 数据库访问锁与写操作并发控制
- 查询与结果处理的并发优化

---

高并发下的数据库访问优化

- 使用连接池避免频繁连接开销
- 批量插入与批量查询
- 延迟提交事务减少锁竞争
- 数据分区与分表策略（ORM 兼容性）
- 数据缓存机制（热数据前置）

---

ORM 局限与风险控制

- ORM 性能损耗对比手写 SQL
- N+1 查询问题
- 复杂 JOIN 查询处理能力
- 对 SQL 语法封装的限制
- ORM 模型变更的数据库迁移成本

---

第三方数据库操作库（补充）

- SOCI（轻量级 C++ 数据库访问库）
- SQLiteCpp（封装 SQLite 的 C++ 库）
- libpqxx（PostgreSQL 官方 C++ 接口）
- mysql++ / MySQL Connector C++
- nanodbc（跨平台 ODBC 封装）

---

与现代 C++ 结合点

- 使用 `std::shared_ptr` 管理 ORM 对象
- `std::optional` 表示可空字段（C++17 起）
- 协程 + 异步数据库接口（C++20 进阶）
- 使用现代容器与结构绑定处理查询结果

</details>

# 9.内存模型与性能优化

<details>
<summary>内存模型与性能优化</summary>

内存模型基础

- 栈内存与堆内存的区别
- 静态存储区（.bss / .data）
- 内存对齐（alignment）
- padding 与结构体大小优化
- 字节序（大小端）

---

C++ 内存分配与释放机制

- `new` / `delete`
- `malloc` / `free`
- 智能指针与资源释放（RAII）
- 对象构造与析构时的内存生命周期
- 内存泄漏与悬垂指针

---

自定义内存管理

- 重载 `operator new` / `operator delete`
- 自定义分配器（Allocator）
- 内存池（Memory Pool）
- Arena 分配器（区域式内存分配）
- 对齐分配（`std::aligned_alloc`, C++17）

---

内存访问性能

- 缓存命中率（L1/L2/L3 Cache）
- Cache Line 与 false sharing
- 数据局部性（spatial / temporal locality）
- 预取机制（Prefetch）
- 内存访问顺序对性能的影响

---

STL 与内存效率

- `std::vector` 动态扩容机制
- `std::string` SSO（小字符串优化）
- 容器复制、移动语义与临时对象开销
- 内存复用与 `shrink_to_fit`
- 使用 `reserve` 减少 realloc 次数

---

移动语义与性能优化

- 移动构造函数与移动赋值
- `std::move` 使用场景
- RVO（返回值优化）
- NRVO（命名返回值优化）
- 消除不必要的拷贝构造

---

函数调用与内联优化

- 内联函数（`inline`）的作用与限制
- 编译器自动内联（静态分析决定）
- 参数传递方式对性能的影响（值传递 vs 引用）

---

编译器优化选项

- `-O1`, `-O2`, `-O3`, `-Ofast` 含义与区别
- `-flto`（链接时间优化）
- `-march=native`（启用本地 CPU 指令集优化）
- `-ffast-math`（浮点优化）

---

多线程下的内存模型

- 原子操作与内存序（memory\_order）
- happens-before 关系
- 指令重排与同步屏障
- volatile 与原子变量的区别

---

性能测试与分析工具（配套）

- `valgrind` / `cachegrind`
- `perf`
- `gprof`
- `Google Benchmark`
- AddressSanitizer / MemorySanitizer

---

程序启动与运行时优化

- 静态初始化与懒初始化（静态局部变量）
- 减少动态内存分配频次
- 延迟加载（lazy loading）
- 热路径函数优化
- 冷数据与热数据分离

---

编码层面的优化技巧

- 减少临时变量创建
- 避免隐式类型转换
- 避免频繁构造/析构大对象
- 减少虚函数调用（去虚拟化）
- 使用 `final`, `noexcept`, `inline` 提示编译器优化

</details>

# 10.测试

<details>
<summary>测试</summary>

测试基础概念

- 单元测试（Unit Testing）
- 集成测试（Integration Testing）
- 回归测试（Regression Testing）
- 验收测试（Acceptance Testing）
- 测试覆盖率（Code Coverage）

---

单元测试框架

- Google Test（gtest）
- Catch2
- doctest
- Boost.Test
- QTest（Qt 项目中）

---

Google Test（重点）

- 测试用例定义（`TEST`, `TEST_F`）
- 测试夹具（Test Fixture）
- 断言分类：

  - 基本断言（`EXPECT_EQ`, `ASSERT_NE` 等）
  - 条件断言（`EXPECT_TRUE`, `ASSERT_FALSE`）
  - 浮点断言（`EXPECT_NEAR`）
- 参数化测试（`TEST_P`, `INSTANTIATE_TEST_SUITE_P`）
- 自定义断言与输出
- 死亡测试（Death Tests）
- main 函数自定义与默认入口

---

Mock 测试（模拟依赖）

- Google Mock（gmock）集成
- Mock 类定义与行为配置
- `EXPECT_CALL` 机制
- 使用 mock 替代外部依赖组件（数据库、文件系统等）

---

Catch2 / doctest 简介

- 单头文件集成（轻量级）
- 自动注册测试用例
- Section 测试结构
- BDD 风格测试语法支持（Given/When/Then）

---

断言与异常测试

- 条件判断类断言
- 异常捕获与抛出验证
- 自定义类型比较与消息输出支持

---

测试工程组织

- test/ 目录结构组织
- 测试与源码分离原则
- 测试专用的构建配置（Debug 启用断言 / 日志）
- CMake 中添加测试（`add_test`, `enable_testing`）

---

自动化测试集成

- 使用 CI 工具运行测试（GitHub Actions / GitLab CI / Jenkins）
- 测试日志输出与归档
- 测试失败快照（截图、日志等）

---

性能测试（微基准）

- Google Benchmark 使用
- Catch2 Benchmark 支持（`BENCHMARK` 宏）
- 精确时间测量（`<chrono>`）
- 热路径性能对比

---

测试覆盖率分析

- 使用 `gcov` 生成覆盖率数据
- 使用 `lcov` 可视化覆盖率报告
- `llvm-cov`（Clang 下的覆盖率工具）
- 将覆盖率集成到 CI 中展示

---

辅助测试技巧

- 使用 mock 替代第三方服务
- 使用临时文件 / 文件夹作为输入输出
- 使用条件编译控制测试接口（如 `#ifdef TESTING`）
- 隔离全局变量影响（重构代码使其更易测）

</details>

# 11.第三方库

<details>
<summary>第三方库</summary>

常用实用功能类库

- `Boost`（超大综合性库集合）
- `fmt`（现代格式化库，替代 `printf` / `ostringstream`）
- `spdlog`（高性能日志库）
- `nlohmann/json`（现代 C++ JSON 解析库）
- `cereal`（序列化库）
- `yaml-cpp`（YAML 配置解析）

---

网络与异步通信库

- `Boost.Asio`（异步 IO，TCP/UDP 支持）
- `libevent`（事件驱动网络编程）
- `libuv`（跨平台异步 IO 库）
- `httplib`（轻量级 HTTP 服务器/客户端）
- `cpp-httplib`, `cpr`（现代 HTTP 客户端库）
- `WebSocket++`（WebSocket 协议支持）

---

数据库操作类库

- `ODB`（C++ ORM 框架）
- `libpqxx`（PostgreSQL C++ 接口）
- `mysql++` / `MySQL Connector C++`
- `SQLiteCpp`（SQLite 封装）
- `SOCI`（轻量 SQL 封装库）
- `nanodbc`（ODBC 封装）

---

并发与协程库

- `Boost.Thread`, `Boost.Fiber`, `Boost.Coroutine`
- `libco`（协程库，广泛用于高并发服务器）
- `libgo`（Golang 风格 C++ 协程）
- `libtask`, `cppcoro`（现代协程封装）
- `asio::awaitable`（结合 C++20 协程）

---

算法与数据结构辅助库

- `absl`（Google 的基础库集合）
- `range-v3`（C++20 Ranges 的前身）
- `EASTL`（EA 发布的高性能 STL 替代）
- `tsl::robin_map`, `sparsepp`（高性能哈希表）

---

图形与 GUI 库（可选）

- `ImGui`（即时 GUI，用于工具开发）
- `Qt`（大型 GUI 与网络框架）
- `SFML`, `SDL2`（跨平台图形与音频）

---

数值与科学计算库

- `Eigen`（矩阵运算库）
- `Armadillo`（线性代数）
- `Cerres Solver`（数值优化）
- `NLopt`（非线性优化）
- `dlib`（图像处理 + 机器学习支持）

---

测试与调试类库（补充）

- `Google Test`, `Google Benchmark`
- `Catch2`, `doctest`
- `backward-cpp`（打印可读的调用栈）
- `dbg-macro`（调试输出宏）

---

库管理与集成工具

- `vcpkg`
- `conan`
- `hunter`
- `pkg-config`（系统库查找工具）
- `CMake FetchContent`（拉取第三方依赖）

---

与现代 C++ 结合紧密的库

- 支持 C++11/14/17/20/23 特性的库
- 使用 Concepts、Ranges、Modules 的实验性项目
- Header-only 设计（更易集成与编译）

</details>

# 12.架构设计与项目组织

<details>
<summary>架构设计与项目组织</summary>

项目结构与模块划分

- 头文件与源文件分离
- include / src / lib / test / build 目录组织
- 公共模块（utils, base, common）的设计
- 第三方库与本地模块分层管理
- 接口文件与实现文件的命名规范（.h / .cpp）

---

面向接口编程（抽象设计）

- 接口与实现分离（interface / implementation）
- 使用纯虚类定义接口
- 面向依赖编程（依赖倒置原则）
- 使用工厂模式实例化接口对象
- PIMPL（Pointer to Implementation）设计模式

---

模块化设计原则

- 单一职责原则（SRP）
- 最小化模块耦合（低耦合高内聚）
- 模块边界清晰化（职责清晰）
- 使用命名空间隔离逻辑模块

---

常见架构模式

- 单例模式（Singleton）
- 工厂模式（Factory / AbstractFactory）
- 策略模式（Strategy）
- 观察者模式（Observer）
- 责任链模式（Chain of Responsibility）
- 状态机（State Machine）
- MVC / MVVM（工程级别）

---

插件化与扩展性设计

- 动态库插件加载机制（`dlopen`, `dlsym`）
- 插件注册系统（工厂 + 注册宏）
- 反射机制模拟（注册表 + 类型标识）
- 热插拔模块的生命周期管理

---

项目配置与构建体系

- CMake 多模块构建配置
- 外部库管理（FetchContent / find\_package / vcpkg / conan）
- Debug / Release 构建类型管理
- 编译选项按模块定制（target\_compile\_options）
- 安装路径配置（CMAKE\_INSTALL\_PREFIX）

---

日志与错误处理框架

- 使用日志库统一日志格式（如 spdlog）
- 日志等级（trace/debug/info/warn/error/fatal）
- 错误码体系设计（模块级错误 + 全局错误）
- 异常机制与日志联动

---

配置管理

- 配置文件格式支持（JSON / YAML / INI）
- 配置热加载机制（文件监控 + 解析）
- 配置项校验与默认值机制
- 层级配置（全局配置 + 模块配置）

---

服务启动流程设计

- 初始化顺序控制（配置 → 日志 → 线程池 → 网络层）
- 组件注册与生命周期管理
- 资源释放与优雅退出机制
- 守护进程支持（后台运行）

---

工程实践与协作规范

- 代码风格规范与自动格式化（clang-format）
- 命名规范（类名 / 文件名 / 变量名 / 宏名）
- 模块级 README / 文档注释规范
- Git 分支管理策略（main/dev/feature/hotfix）
- CI/CD 管道集成（编译 + 测试 + 分析）

---

架构演进与重构策略

- 技术债清理与模块拆分计划
- 抽象提取与复用设计
- 单元测试覆盖提升
- 渐进式重构（refactor by interface）
- 性能瓶颈模块隔离与优化空间识别

---

跨平台设计基础

- 平台无关接口抽象
- 条件编译与平台宏管理
- 使用 CMake 配置多平台选项（Windows/Linux/macOS）

</details>

---

<details>
<summary>C++ 工程目录结构，适用于服务端程序、工具类项目、中型组件库等</summary>

```bash
my_project/
├── CMakeLists.txt             # 顶层构建配置
├── README.md                  # 项目简介
├── .clang-format              # 代码风格统一配置
├── .gitignore                 # 忽略文件配置
│
├── cmake/                     # CMake 模块文件（如 FindXXX.cmake）
│   └── modules/
│       └── FindMyLib.cmake    # 自定义包查找模块
│
├── config/                    # 配置文件目录
│   ├── config.yaml            # 主配置文件（支持 YAML/JSON/INI）
│   └── logging.conf           # 日志配置
│
├── include/                   # 对外暴露的头文件
│   └── my_project/
│       ├── version.hpp
│       ├── core.hpp
│       └── utils.hpp
│
├── src/                       # 项目核心源代码
│   ├── main.cpp               # 程序入口
│   ├── core/                  # 业务核心逻辑
│   │   ├── processor.cpp
│   │   └── processor.hpp
│   ├── utils/                 # 通用工具模块
│   │   ├── logger.cpp
│   │   └── logger.hpp
│   ├── net/                   # 网络模块（可选）
│   │   ├── server.cpp
│   │   └── server.hpp
│   └── db/                    # 数据库访问封装（可选）
│       ├── orm.cpp
│       └── orm.hpp
│
├── lib/                       # 静态库/动态库（自建或第三方）
│   └── mylib.a                # 示例库文件
│
├── third_party/               # 外部依赖（源码方式引入）
│   └── fmt/
│
├── build/                     # 构建输出目录（不入 Git）
│   └── (CMake 编译生成文件)
│
├── test/                      # 单元测试代码
│   ├── CMakeLists.txt
│   ├── test_main.cpp
│   └── test_utils.cpp
│
├── benchmark/                 # 基准性能测试
│   └── bench_sort.cpp
│
├── docs/                      # 项目文档（架构图、说明书等）
│   └── architecture.md
│
└── scripts/                   # 构建 / 测试 / 发布脚本
    ├── build.sh
    └── run_tests.sh
```

</details>

<details>
<summary>gRPC + ODB 项目目录结构</summary>

```bash
my_grpc_backend/
CMakeLists.txt                  # 手动创建：CMake 主构建文件，定义项目结构、编译规则
README.md                       # 手动创建：项目说明文档（建议写清架构、依赖、构建说明）
.clang-format                   # 可选：统一代码风格配置（推荐使用）
.gitignore                      # 手动创建：忽略 build、临时文件、自动生成文件等

cmake/                          # 手动创建：存放自定义 CMake 模块（如查找 ODB）
cmake/modules/
cmake/modules/FindODB.cmake           # 手动创建：用于 find_package 查找 ODB 编译器及库

proto/                          # 手动创建：放置 .proto 文件（服务和数据结构定义）
proto/service.proto               # 手动创建：定义 gRPC 服务接口
proto/model.proto                 # 手动创建：定义消息结构、数据库模型等
proto/CMakeLists.txt              # 手动创建：集成 protoc & grpc 插件自动生成代码

generated/                      # 自动生成：由 protoc / gRPC / ODB 编译器生成的 .pb.h/.pb.cc/.-odb.hxx 文件
generated/...                         # 注意：不建议手动编辑，应由构建流程管理

include/                        # 手动创建：项目对外暴露的公共头文件
include/mygrpc/
include/mygrpc/server.hpp              # 手动创建：gRPC 服务类声明（可能引用 .proto 定义）
include/mygrpc/db.hpp                  # 手动创建：数据库操作接口或桥接定义
include/mygrpc/config.hpp              # 手动创建：配置加载相关接口定义

src/                            # 手动创建：主业务代码目录
src/main.cpp                    # 手动创建：程序入口（创建 gRPC 服务器、加载配置等）
src/grpc/
src/grpc/service_impl.cpp        # 手动创建：gRPC 服务实现（继承自动生成的 stub）

src/db/user.hpp                # 手动创建：业务模型类 + ODB 映射注解
src/db/user-odb.hxx            # 自动生成：由 ODB 编译器根据 user.hpp 生成（不要手动修改）
src/db/user.cpp                # 手动创建：实现数据库操作（插入、查询、更新等）

src/utils/logger.cpp              # 手动创建：封装日志系统（如 spdlog）
src/utils/logger.hpp              # 手动创建：日志模块头文件

src/config/config_loader.cpp       # 手动创建：配置解析实现（通常使用 yaml-cpp）
src/config/                         # 手动创建：项目运行时配置文件目录
src/config/db.yaml                     # 手动创建：数据库连接配置（DSN、池大小等）
src/config/server.yaml                 # 手动创建：服务配置（端口号、线程数、日志级别）

scripts/                        # 手动创建：常用命令脚本（构建、运行、协议编译等）
scripts/build.sh                    # 手动创建：一键构建脚本
scripts/run_dev.sh                  # 手动创建：开发环境启动服务
scripts/generate_proto.sh           # 手动创建：调用 protoc 和 ODB 编译器生成代码

test/                           # 手动创建：单元测试代码（建议使用 Google Test）
test/test_db.cpp                 # 手动创建：数据库相关功能测试
test/test_grpc.cpp               # 手动创建：gRPC 接口测试

benchmark/                      # 可选：性能测试模块（推荐用于关键路径分析）
benchmark/CMakeLists.txt              # 手动创建：benchmark 模块的构建文件
benchmark/bench_insert_vs_batch.cpp   # 手动创建：示例性能测试代码（可测试批量插入效率等）

docs/                           # 可选：文档目录，适用于团队协作或开源项目
docs/architecture.md             # 手动创建：项目架构图、模块关系说明
docs/database-design.md          # 手动创建：数据模型及 ODB 映射说明
docs/grpc-api.md                 # 手动或自动生成：gRPC 接口说明文档
docs/deployment.md               # 手动创建：部署说明，运行环境依赖、命令示例等

third_party/                    # 可选：手动引入的第三方库（建议用 vcpkg/conan 管理）
third_party/...                         # 可用于 header-only 库，如 fmt, nlohmann/json 等

docker/                         # 可选：用于容器化部署
docker/Dockerfile                  # 手动创建：构建服务镜像的 Dockerfile

build/                          # 自动生成：构建输出目录，CMake/Ninja 编译生成文件
build/...                         # 通常通过 `.gitignore` 忽略
```

</details>
