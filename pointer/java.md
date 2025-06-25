<details>
<summary>1.基础语法与语言特性</summary>

1. Java 概述

* Java 平台结构（JDK、JRE、JVM）
* Java 程序结构（源文件、类文件）
* 编译与执行流程（`javac`, `java`）

---

2. 基本语法结构

* 文件命名规则与类名一致性
* main 方法结构与入口点规则
* 分号与语句结束规范
* 注释类型（单行、多行、文档注释）

---

3. 数据类型与变量

* 原始数据类型（byte, short, int, long, float, double, char, boolean）
* 包装类（Integer, Double, Boolean 等）
* 引用类型与对象创建
* 类型转换（自动类型提升、强制转换）
* 常量与 `final` 关键字

---

4. 运算符

* 算术运算符（+ - \* / %）
* 赋值运算符（=, +=, -=, ...）
* 关系运算符（==, !=, >, <, >=, <=）
* 逻辑运算符（&&, ||, !）
* 位运算符（&, |, ^, \~, <<, >>, >>>）
* 三元运算符（?:）
* 运算符优先级与结合性

---

5. 控制流程

* 条件分支：`if`、`else if`、`else`
* 多分支：`switch-case-default`
* 循环控制：`for`、`while`、`do-while`
* 跳转控制：`break`、`continue`、`return`
* 增强 for-each 循环

---

6. 方法（函数）定义与调用

* 方法声明、方法调用
* 形参与实参
* 返回值类型与 return
* 方法重载（Overloading）
* 访问修饰符（public, private, protected, default）

---

7. 数组

* 一维数组定义与访问
* 多维数组（二维数组）结构与遍历
* 数组初始化方式
* `length` 属性 vs `.length()` 方法

---

8. 字符串与字符处理

* String 类的不可变性
* 常用方法（substring, indexOf, length, replace, equals 等）
* 字符串拼接性能与 StringBuilder
* 字符编码基础（char 与 Unicode）

---

9. 包（Package）与导入机制

* 包的声明与作用
* `import` 导入类与静态导入
* 类的全限定名（FQCN）

---

10. 输入输出（基础）

* 控制台输出（System.out）
* 控制台输入（Scanner）
* 异常处理基础（try-catch）

---

11. Java 关键字（掌握语义）

* 控制类结构：`class`, `interface`, `enum`, `abstract`, `final`
* 控制方法：`static`, `void`, `return`, `native`, `synchronized`
* 控制访问：`public`, `protected`, `private`, `default`
* 控制流程：`if`, `else`, `switch`, `case`, `break`, `continue`
* 控制对象：`new`, `this`, `super`, `null`, `instanceof`
* 异常相关：`try`, `catch`, `finally`, `throw`, `throws`

---

12. 注解语法基础

* 内置注解：`@Override`, `@Deprecated`, `@SuppressWarnings`
* 注解声明规则（预热注解语法）

---

13. Java 编译与运行基础命令

* `javac` 编译器参数（如 `-d` 输出目录）
* `java` 启动参数
* CLASSPATH 与包路径结构
* 简单 IDE 使用规范（编译运行）

---

14. Java 开发习惯与命名规范

* 类名/变量名/方法名命名约定
* Java 代码风格（缩进、花括号风格等）
* 注释与文档注释规范（Javadoc）


</details>

<details>
<summary>2.面向过程 + 函数式 编程</summary>

一、过程式编程（Procedural Programming）

* 方法定义与调用语法
* 方法返回值与参数传递
* 静态方法与实例方法的区别
* 方法重载（Overloading）
* 变量作用域与生命周期
* 局部变量与全局变量
* 代码块与作用域嵌套
* 顺序执行
* 条件判断（if, else if, else）
* 多分支结构（switch-case-default）
* 基本循环结构（for, while, do-while）
* 循环嵌套与控制跳出（break, continue, return）
* 工具类设计与静态工具方法
* 方法中参数校验与防御式编程
* 编写主流程程序（输入 → 处理 → 输出）

---

二、函数式编程（Functional Programming）

* 函数式接口的定义与使用
* Lambda 表达式语法
* 方法引用（静态方法、实例方法、构造器）
* 常用函数式接口

  * `Function<T, R>`
  * `Consumer<T>`
  * `Supplier<T>`
  * `Predicate<T>`
  * `UnaryOperator<T>`
  * `BinaryOperator<T>`
* 函数组合操作

  * `andThen()`
  * `compose()`
  * `negate()`
  * `and()` / `or()`
* Stream API 基础

  * 流的创建方式（集合、数组、生成）
  * 中间操作：`map`, `filter`, `flatMap`, `sorted`, `distinct`, `limit`, `skip`, `peek`
  * 终结操作：`forEach`, `collect`, `reduce`, `count`, `min`, `max`, `anyMatch`, `allMatch`, `noneMatch`
  * 收集器：`Collectors.toList()`, `toSet()`, `joining()`, `groupingBy()`, `partitioningBy()`
* Optional 类型

  * 创建 Optional（of, ofNullable, empty）
  * 获取值（get, isPresent, ifPresent）
  * 链式操作（map, flatMap, filter）
  * 提供默认值（orElse, orElseGet, orElseThrow）
* 不可变集合的使用
* 基本的纯函数思想
* 无状态函数与无副作用函数
* 函数作为参数传递
* 函数作为返回值返回
* 高阶函数表达能力

</details>

<details>
<summary>3.面向对象编程</summary>

一、类与对象基础

* 类的定义
* 对象的创建与使用
* 构造方法（无参构造、有参构造）
* 构造方法重载
* `this` 关键字的使用
* 对象的成员变量与成员方法
* 成员访问权限与可见性规则

---

二、封装

* 成员变量的私有化
* 提供公有的 getter 和 setter 方法
* 构造封装类的标准方式（JavaBean规范）
* 只读属性与只写属性
* 访问控制符（public, protected, private, default）

---

三、继承

* 使用 `extends` 实现继承
* 子类访问父类成员
* 方法的重写（Override）
* 构造器的继承与 `super()` 的使用
* final 类与 final 方法的继承限制
* 父类引用指向子类对象（向上转型）
* 向下转型与 `instanceof` 类型判断

---

四、多态

* 编译时多态（方法重载）
* 运行时多态（方法重写）
* 动态绑定与虚方法调用
* 多态下的成员变量访问规则
* 抽象类与抽象方法的多态实现
* 接口实现与多态行为
* 多态数组与多态参数的使用

---

五、接口

* 接口的定义与实现
* `implements` 关键字
* 接口中的常量与抽象方法
* 接口默认方法（default）
* 接口静态方法
* 接口的多继承（类的多实现）
* 函数式接口（@FunctionalInterface 注解）

---

六、抽象类

* `abstract` 关键字
* 抽象类不能被实例化
* 抽象方法只能声明不能实现
* 抽象类可以有构造方法
* 抽象类可以包含非抽象方法和成员变量
* 抽象类继承规则

---

七、方法重载与重写

* 方法重载的定义与规则（参数个数、类型顺序不同）
* 方法重写的定义与规则（方法签名一致、访问权限不更严格）
* `@Override` 注解
* 重载与重写的区别

---

八、Object 类相关

* `toString()` 方法重写
* `equals()` 方法重写
* `hashCode()` 方法重写
* `getClass()`、`clone()`、`finalize()` 方法
* 对象比较与引用比较的区别

---

九、类的高级特性

* static 成员变量与方法
* static 代码块
* 初始化顺序（静态变量、实例变量、构造器）
* 内部类（成员内部类、静态内部类、局部内部类、匿名内部类）
* 包访问与类可见性（public、default）

</details>

<details>
<summary>4.泛型与注解</summary>

一、泛型（Generics）

1. 泛型基础

* 泛型类的定义与使用
* 泛型接口的定义与实现
* 泛型方法的定义与调用
* 类型参数声明位置
* 多个类型参数使用方式（如 `<K, V>`）

2. 通配符

* 无界通配符：`<?>`
* 上界通配符：`<? extends T>`
* 下界通配符：`<? super T>`
* 通配符与集合读取/写入规则

3. 泛型擦除与类型推断

* 泛型类型擦除机制
* 类型擦除导致的运行时限制
* 编译器类型推断与 `<T>` 省略写法
* `@SuppressWarnings("unchecked")` 的使用场景

4. 限制与约束

* 泛型不支持基本类型
* 不能使用泛型数组
* 泛型类中不能用 instanceof 判断泛型类型
* 泛型类中的静态方法限制

---

二、注解（Annotations）

1. 注解基础语法

* 注解的定义与使用
* 注解的语法结构（属性、默认值、无参/有参）
* 使用注解修饰类、方法、字段、参数、局部变量等

2. Java 内置注解

* `@Override`
* `@Deprecated`
* `@SuppressWarnings`

3. 元注解（定义注解时使用）

* `@Target`
* `@Retention`
* `@Documented`
* `@Inherited`
* `@Repeatable`

4. 自定义注解

* 自定义注解的语法结构
* 注解属性的定义与默认值设置
* 注解中不能使用可变参数、泛型等非法类型

5. 注解处理

* 运行时注解读取（通过反射）
* 类、方法、字段的注解解析
* 注解与配置驱动开发的关系
* 注解在框架中的典型用途（如 Spring、JPA）

6. 注解与反射结合使用

* 获取类上的注解
* 获取方法、字段、参数上的注解
* 判断注解是否存在
* 获取注解属性值

7. 编译时注解处理（APT）

* 注解处理器（Annotation Processor）
* `javax.annotation.processing` 包概述
* `@SupportedAnnotationTypes`, `@SupportedSourceVersion`
* `AbstractProcessor` 类的继承与注册机制
* 编译时生成代码或提示（如自动生成类、校验语法）

</details>

<details>
<summary>5.标准库与集合框架</summary>

一、Java 标准库（`java.lang`, `java.util`, `java.io`, 等）

* `java.lang` 基础类（Object, Math, String, StringBuilder, Enum, Wrapper classes）
* `java.util` 实用工具类（Arrays, Collections, Objects, Optional）
* `java.time` 日期时间 API（LocalDate, LocalTime, LocalDateTime, ZonedDateTime, Duration, Period, DateTimeFormatter）
* `java.io` 与 `java.nio` 输入输出基础（File, InputStream/OutputStream, Reader/Writer, Channels, Buffers）
* `java.util.regex` 正则表达式处理（Pattern, Matcher）
* `java.util.concurrent` 并发工具（详见并发模块，但与集合交叉处包含）

---

二、集合框架核心接口

* `Collection` 接口层级结构

  * `List`
  * `Set`
  * `Queue`
  * `Deque`
* `Map` 接口层级结构

---

三、主要实现类

* `ArrayList`, `LinkedList`
* `HashSet`, `LinkedHashSet`, `TreeSet`, `EnumSet`
* `PriorityQueue`, `ArrayDeque`
* `HashMap`, `LinkedHashMap`, `TreeMap`, `EnumMap`, `WeakHashMap`, `IdentityHashMap`
* `Stack`, `Vector`（遗留类）

---

四、集合工具类

* `Collections`

  * 不可变集合创建
  * 同步包装（synchronizedList 等）
  * 排序、打乱、二分查找等
* `Arrays`

  * 数组操作：排序、查找、复制、填充、转List等
* `Collectors`（Java 8 Stream API）

---

五、集合框架特性

* 有序性（Order）
* 排序性（Sorted / Navigable）
* 唯一性（Set特性）
* 可变性与不可变集合（Java 9+）
* 空间与时间复杂度
* 可并发访问集合（Concurrent 系列）

---

六、泛型与集合的结合

* 通配符（`?`, `? extends`, `? super`）在集合中的应用
* 类型擦除与泛型数组限制
* 自定义泛型集合类的最佳实践

---

七、并发集合（部分属于并发模块，但此处涉及集合实现）

* `ConcurrentHashMap`
* `CopyOnWriteArrayList`, `CopyOnWriteArraySet`
* `ConcurrentLinkedQueue`, `ConcurrentLinkedDeque`
* `BlockingQueue`, `LinkedBlockingQueue`, `ArrayBlockingQueue`, `PriorityBlockingQueue`
* `ConcurrentSkipListMap`, `ConcurrentSkipListSet`

---

八、集合框架的拓展应用

* 自定义排序器（Comparator 与 Comparable）
* 集合中的视图（subList, subMap, keySet 等）
* 多值映射结构（如使用 `Map<K, List<V>>`）

---

九、集合中的陷阱与边界情况

* 修改时的 `ConcurrentModificationException`
* equals 与 hashCode 的一致性要求
* List 与 Arrays.asList 的固定长度限制
* Null key/value 支持情况（不同集合行为不同）

---

十、Java 8+ 集合新特性

* `Stream` API 与集合结合使用
* `Map` 的新方法（`computeIfAbsent`, `merge`, `forEach`, `getOrDefault` 等）
* `List.of`, `Set.of`, `Map.of` 等简洁构建方法（Java 9+）

</details>

<details>
<summary>6.并发与多线程编程</summary>

一、线程基础

* 线程的生命周期（新建、就绪、运行、阻塞、死亡）
* 创建线程的方式

  * 继承 `Thread` 类
  * 实现 `Runnable` 接口
  * 实现 `Callable` 接口 + `Future`
* 线程的启动、休眠、加入（`start()`, `sleep()`, `join()`）
* 线程中断机制与标志位检测
* 线程优先级设置

---

二、Java 内存模型（JMM）

* 主内存与工作内存
* 可见性、原子性、有序性
* Happens-Before 原则
* 指令重排与内存屏障

---

三、关键字与线程同步

* `synchronized` 关键字

  * 修饰实例方法、静态方法、代码块
  * 对象锁与类锁
* `volatile` 关键字

  * 可见性保障
  * 不保证原子性
* `final` 的并发语义

---

四、线程通信

* `wait()`, `notify()`, `notifyAll()`（Object 类的方法）
* 条件变量机制
* `Lock` 与 `Condition` 的替代方案

---

五、JUC（`java.util.concurrent` 包）

* 锁机制

  * `ReentrantLock`
  * `ReadWriteLock` 与 `ReentrantReadWriteLock`
  * `StampedLock`
* 原子类

  * `AtomicInteger`, `AtomicLong`, `AtomicReference`
  * `LongAdder`, `DoubleAdder`
* 同步辅助类

  * `CountDownLatch`
  * `CyclicBarrier`
  * `Semaphore`
  * `Exchanger`
  * `Phaser`
* `ThreadLocal` 和 `InheritableThreadLocal`

---

六、线程池（Executor 框架）

* `Executor`, `ExecutorService`, `ScheduledExecutorService`
* `Executors` 工具类方法（fixed thread pool, cached, single, scheduled）
* `ThreadPoolExecutor` 完整参数与运行机制
* 线程池任务拒绝策略（`RejectedExecutionHandler`）
* 线程工厂（`ThreadFactory`）

---

七、Future 与异步编程

* `Future` 接口与 `get()`, `cancel()`
* `Callable` 接口与返回值支持
* `CompletionService`
* `FutureTask` 类
* `CompletableFuture`（Java 8+）

  * 异步链式编程（`thenApply`, `thenAccept`, `thenCompose`, 等）
  * 异常处理（`exceptionally`, `handle`）
  * 并行组合（`allOf`, `anyOf`）

---

八、并发容器

* `ConcurrentHashMap`
* `CopyOnWriteArrayList`, `CopyOnWriteArraySet`
* `ConcurrentLinkedQueue`, `ConcurrentLinkedDeque`
* `BlockingQueue` 接口及实现类

  * `ArrayBlockingQueue`, `LinkedBlockingQueue`
  * `PriorityBlockingQueue`, `DelayQueue`
  * `SynchronousQueue`

---

九、死锁与并发问题分析

* 死锁的四个必要条件
* 活锁、饿死、资源竞争
* 线程安全与非线程安全类的识别
* 死锁检测工具与线程 dump 分析

---

十、高级并发机制与工具

* Fork/Join 框架

  * `ForkJoinPool`, `RecursiveTask`, `RecursiveAction`
* `StampedLock` 的乐观读锁
* CAS（Compare-And-Swap）原理
* Unsafe 类与底层原子操作（了解即可）
* `VarHandle`（Java 9+）

---

十一、并发性能优化与设计模式

* 减少共享资源访问
* 使用局部变量提升线程安全性
* 使用无锁结构（如 `Atomic` 系列）
* 并发设计模式

  * 生产者-消费者
  * 读写锁模型
  * 单例模式的并发实现（双重检查锁等）
  * 工作窃取算法（Work-Stealing）
  * 背压（Backpressure）模型

</details>

<details>
<summary>7.网络编程</summary>

一、基础概念

* 网络通信模型概述（OSI七层模型、TCP/IP模型）
* IP地址、端口号、协议（TCP/UDP）
* Socket 编程基本原理
* 客户端 / 服务端通信模型
* 阻塞 / 非阻塞（BIO/NIO/AIO）

---

二、Java Socket 编程（阻塞式 BIO）

* `Socket` 与 `ServerSocket` 类
* 输入输出流（`InputStream`, `OutputStream`）
* 客户端连接、数据发送、接收
* 多线程处理多个客户端连接

---

三、Java UDP 编程

* `DatagramSocket`, `DatagramPacket` 类
* UDP 数据包的发送与接收
* UDP 与 TCP 编程差异点（仅知识点提示）

---

四、Java NIO（非阻塞 IO）

* `Channel` 接口及其实现（`SocketChannel`, `ServerSocketChannel`, `DatagramChannel`）
* `Buffer` 系列类（`ByteBuffer`, `CharBuffer` 等）
* `Selector` 选择器机制
* 非阻塞模式下的事件驱动通信
* NIO 与传统 IO 的差异及适用场景

---

五、Java AIO（异步 IO，Java 7+）

* `AsynchronousSocketChannel`, `AsynchronousServerSocketChannel`
* 回调处理模型
* CompletionHandler 接口

---

六、Java 网络工具类与辅助包

* `InetAddress` 类（本地与远程 IP 解析）
* `URI`, `URL` 类（统一资源定位与连接）
* `URLConnection`、`HttpURLConnection`
* `Proxy` 类（代理设置）
* `Authenticator` 类（HTTP 鉴权处理）

---

七、HTTP 通信基础（Java 原生支持）

* 发起 GET / POST 请求的方式
* 设置请求头、响应头读取
* Http 状态码识别
* 超时设置与异常处理
* 数据流处理与内容类型识别（如 JSON、XML）

---

八、Java 11 新增 HTTP Client（标准化 API）

* `java.net.http.HttpClient`

  * 异步与同步请求
  * 支持 HTTP/2 协议
  * 使用 `HttpRequest`, `HttpResponse` 类
  * 支持 `CompletableFuture` 异步响应
  * 支持 WebSocket 通信

---

九、WebSocket 编程（Java EE / Jakarta EE / Spring）

* WebSocket 协议基础（握手、数据帧、双向通信）
* Java EE WebSocket API（`@ServerEndpoint` 等注解）
* 消息广播与 session 管理
* Spring Boot 中的 WebSocket 支持（`@EnableWebSocket`, `WebSocketHandler`）

---

十、安全与认证机制（网络通信安全知识）

* HTTPS 与 SSL/TLS 加密通信
* 证书配置与校验（KeyStore, TrustStore）
* Basic Auth、Token 验证
* 防止中间人攻击、数据包重放等

---

十一、高性能与分布式通信机制（拓展知识）

* 长连接 / 短连接 管理策略
* 心跳机制与连接保活
* 粘包与拆包问题（TCP 协议特性）
* Netty 框架基础知识点（高性能通信框架）

  * EventLoopGroup、ChannelPipeline、Handler
  * 编解码器（Codec）
  * 零拷贝（Zero Copy）

</details>

<details>
<summary>8.构建工具与开发工具链</summary>

一、构建工具基础概念

* 什么是构建（Build）：编译、打包、测试、部署、依赖管理等流程
* 构建生命周期与阶段划分（Clean、Compile、Test、Package、Install、Deploy）

---

二、Maven（最主流构建工具）

* Maven 项目结构（标准目录约定）
* `pom.xml` 配置文件

  * 项目信息：groupId, artifactId, version
  * 依赖管理：dependencies、dependencyManagement
  * 插件管理：build、plugins、executions
  * 生命周期绑定：compile, test, package, install 等
  * Profiles 配置与环境隔离
  * 继承与聚合（parent、modules）
  * 仓库配置：本地仓库、私服（Nexus、Artifactory）、中央仓库
* 常用插件（Surefire、Compiler、Assembly、Shade 等）

---

三、Gradle（现代构建工具）

* 基于 Groovy / Kotlin DSL 的构建脚本
* 与 Maven 的兼容支持
* `build.gradle` 核心语法结构
* 任务（Task）定义与依赖配置
* 插件管理与依赖管理方式
* 多模块项目配置
* Wrapper（Gradle Wrapper）机制
* 性能优化机制（增量构建、构建缓存、守护进程）

---

四、依赖管理机制

* 传递依赖与冲突解决策略
* 依赖作用域（compile, provided, test, runtime, system）
* SNAPSHOT 与 RELEASE 版本控制
* 排除依赖（exclusions）
* BOM（Bill of Materials）依赖对齐策略（Spring Cloud、Alibaba Cloud 等常用）

---

五、项目构建输出

* 可执行 JAR、Fat JAR、WAR 包、EAR 包
* 多环境配置（dev, test, prod）
* 自定义打包与资源过滤
* 构建产物部署至 Maven 私服

---

六、集成开发环境（IDE）

* IntelliJ IDEA（JetBrains）

  * Maven/Gradle 集成
  * 编码辅助（重构、补全、生成）
  * 插件生态（Lombok、CheckStyle、SonarLint、MyBatisX 等）
  * 调试工具（断点、表达式监视、变量观察）
  * 配置管理（运行配置、环境变量）
* Eclipse（了解层面）
* VS Code（配合 Java 插件支持）

---

七、代码质量工具

* 静态代码分析：Checkstyle, PMD, FindBugs, SpotBugs
* 格式化工具：Google Java Format、Prettier Java
* Lint 插件与规则集管理

---

八、单元测试构建集成（与构建工具配合）

* `mvn test`, `gradle test` 生命周期集成
* 测试覆盖率工具集成（JaCoCo、Cobertura）
* 报告生成（Surefire Reports, Allure）

---

九、自动化与持续集成工具

* 本地脚本自动化（Shell, Batch, Ant）
* CI 工具集成

  * Jenkins Pipelines
  * GitHub Actions / GitLab CI / CircleCI / Travis CI
* 构建触发器（Push、PR、定时构建）
* 多环境部署与测试（Dev/Test/Staging/Prod）

---

十、版本控制工具与流程

* Git（命令、分支管理、冲突解决）
* Git 工作流（Git Flow, GitHub Flow）
* 标签与发布版本控制（Tag、Release Notes）

---

十一、容器化与部署集成

* Docker 构建支持（Dockerfile、Docker Maven/Gradle 插件）
* 本地与远程镜像构建推送
* 构建产物部署到容器中（Java App → Docker → Kubernetes）

---

十二、构建性能与稳定性

* 本地缓存与构建加速（Gradle Daemon, Maven 本地仓库）
* 离线构建模式
* 构建失败排查日志与错误栈分析
* CI/CD 构建缓存优化策略

</details>

<details>
<summary>9.数据库与 ORM</summary>

一、JDBC（Java Database Connectivity）基础

* JDBC API 架构概览
* 数据库驱动加载（`DriverManager`, SPI）
* 连接数据库（`Connection`）
* 执行 SQL（`Statement`, `PreparedStatement`, `CallableStatement`）
* 结果集处理（`ResultSet`）
* 参数绑定与防止 SQL 注入
* 批处理操作（`addBatch`, `executeBatch`）
* 事务管理（提交、回滚、保存点）
* JDBC 连接池原理与常见实现（C3P0、DBCP、HikariCP）

---

二、数据库连接池（DataSource）

* `javax.sql.DataSource` 接口
* 配置连接池参数（最小空闲连接、最大连接数、超时等）
* 常用连接池实现

  * HikariCP（性能优先）
  * Druid（阿里巴巴，监控强大）
  * Apache DBCP
  * C3P0（老牌实现）

---

三、ORM 基础概念

* 什么是 ORM（对象关系映射）
* 表-对象、字段-属性映射规则
* 一对一 / 一对多 / 多对多 关系映射
* 懒加载与立即加载
* 脏检查机制
* 缓存机制（一级缓存、二级缓存）

---

四、MyBatis 框架（半自动 ORM）

* `SqlSessionFactory`, `SqlSession`, `Mapper` 接口
* XML 映射文件配置

  * `resultMap`, `parameterType`, `resultType`
  * 动态 SQL（`<if>`, `<choose>`, `<foreach>` 等）
* 注解方式的映射配置（`@Select`, `@Insert`, `@Update`, `@Delete`）
* 分页插件（如 PageHelper）
* 自定义类型处理器（`TypeHandler`）
* 缓存配置与插件机制
* 与 Spring 集成方式（`SqlSessionTemplate`）

---

五、JPA（Java Persistence API）规范

* `Entity`、`@Id`、`@GeneratedValue`、`@Table`、`@Column` 注解
* 属性映射（基本类型、嵌套对象、枚举、集合）
* 查询方式：

  * JPQL（Java Persistence Query Language）
  * 原生 SQL
  * Criteria API（类型安全查询）
* 事务管理（`@Transactional` 注解）
* 生命周期回调（`@PrePersist`, `@PostLoad`, 等）
* 映射关系：

  * `@OneToOne`
  * `@OneToMany`
  * `@ManyToOne`
  * `@ManyToMany`
  * `@JoinColumn`, `@JoinTable`
* 乐观锁与悲观锁支持（`@Version`）

---

六、Hibernate（JPA 实现）

* Hibernate 配置文件（hibernate.cfg.xml、application.properties）
* Hibernate Session 与缓存机制
* 映射文件与注解支持
* Hibernate Validator（JSR-380 校验注解支持）
* 查询缓存、实体缓存、集合缓存配置
* 延迟加载策略（懒加载、强制初始化）
* Hibernate 工具集（Schema 自动生成、统计分析）

---

七、Spring Data JPA

* Repository 接口层设计（`CrudRepository`, `JpaRepository`, `PagingAndSortingRepository`）
* 命名规则自动生成查询方法（`findByName`, `findByAgeGreaterThan`）
* 自定义 JPQL 与原生 SQL 查询（`@Query` 注解）
* 分页与排序支持（`Pageable`, `Sort`）
* 投影与 DTO 查询（接口投影、构造函数表达式）
* 动态查询（`Specification`、`QueryDSL`）

---

八、事务管理

* 本地事务与分布式事务
* Spring 中声明式事务（`@Transactional`）
* 传播行为（Propagation）与隔离级别（Isolation）
* 回滚规则与异常处理
* 多数据源事务处理
* 分布式事务框架（Seata, Atomikos, Narayana 等）

---

九、数据库迁移与版本控制

* 数据库脚本版本管理工具

  * Flyway
  * Liquibase
* 与 Spring Boot 集成方式
* 自动执行迁移脚本
* 环境差异配置（dev/test/prod）

---

十、SQL 性能优化基础（与开发紧密相关）

* 索引设计与常见陷阱（联合索引、覆盖索引、最左匹配）
* 执行计划（EXPLAIN）分析
* 慢查询日志查看
* SQL 注入预防机制
* 数据库连接泄漏检测与日志审计

---

十一、常见数据库及支持

* MySQL / MariaDB（主流开源数据库）
* PostgreSQL（强类型数据库支持 JSON, GIS）
* Oracle / SQL Server（企业级商用）
* SQLite / H2 / Derby（嵌入式数据库）
* NoSQL 简要（MongoDB, Redis：Spring Data Mongo/Redis 支持）

</details>

<details>
<summary>10.JVM 内存模型与性能优化</summary>

一、JVM 架构总览

* 类加载子系统（ClassLoader）
* 运行时数据区（Runtime Data Areas）
* 执行引擎（Execution Engine）
* 本地接口（Native Interface）
* 垃圾回收器（GC）
* JIT 编译器（Just-In-Time Compiler）
* 字节码解释器

---

二、JVM 内存结构（运行时数据区域）

* 方法区（Method Area）/ 元空间（Metaspace）【Java 8+】
* 堆（Heap）

  * 新生代（Young Generation）
  * 老年代（Old Generation）
* 虚拟机栈（Java Stack）——每个线程独立
* 本地方法栈（Native Method Stack）
* 程序计数器（Program Counter Register）
* 直接内存（Direct Memory）

---

三、类加载机制

* 双亲委派模型
* 类的生命周期：

  * 加载（Load）
  * 验证（Verify）
  * 准备（Prepare）
  * 解析（Resolve）
  * 初始化（Initialize）
* 自定义类加载器
* 热部署与破坏双亲委派机制的场景

---

四、Java 内存模型（JMM）与并发可见性

* 主内存与工作内存模型
* 原子性、可见性、有序性
* `volatile`、`synchronized`、`final` 的并发语义
* Happens-Before 原则
* 指令重排序与内存屏障

---

五、GC（垃圾回收）机制与算法

* 对象的存活判断

  * 引用计数算法
  * 可达性分析（GC Roots）
* 垃圾回收算法

  * 标记-清除（Mark-Sweep）
  * 复制算法（Copying）
  * 标记-整理（Mark-Compact）
  * 分代收集（Generational Collection）
* GC Roots 来源：静态变量、栈帧引用、本地方法引用等

---

六、垃圾收集器（GC 选择与行为）

* Serial GC（单线程，适合小内存）
* Parallel GC（吞吐量优先）
* CMS（并发标记清除，低延迟）
* G1 GC（区域化、预测停顿时间，Java 9 默认）
* ZGC（低延迟 GC，适合超大内存）
* Shenandoah（OpenJDK 的低延迟 GC）
* Epsilon（无 GC，性能测试用）

---

七、GC 调优与观察

* JVM 启动参数调优（如 `-Xms`, `-Xmx`, `-XX:+UseG1GC` 等）
* GC 日志分析（`-Xlog:gc`, `-XX:+PrintGCDetails`）
* 堆转储（Heap Dump）分析
* OOM 触发日志与诊断工具（`-XX:+HeapDumpOnOutOfMemoryError`）
* GC 工具：

  * `jstat`, `jmap`, `jstack`, `jinfo`, `jcmd`
  * VisualVM、JConsole、MAT（Memory Analyzer Tool）

---

八、类元信息管理（Java 8+）

* 永久代（PermGen）被移除，改为元空间（Metaspace）
* 元空间内存由本地内存管理
* 参数调优（`-XX:MaxMetaspaceSize`）

---

九、性能监控与调优工具

* 命令行工具

  * `jps`, `jstack`, `jstat`, `jmap`, `jinfo`, `jcmd`
* 可视化工具

  * JConsole（内置）
  * VisualVM（性能快照、内存分析）
  * JFR（Java Flight Recorder）
  * Mission Control（JMC）
  * GCViewer（查看 GC 日志图表）
* 远程监控（JMX）

---

十、JVM 参数分类

* 标准参数（`-cp`, `-Xms`, `-Xmx`）
* 非标准参数（`-X` 开头）
* 高级参数（`-XX` 开头）
* 诊断参数（需要解锁：`-XX:+UnlockDiagnosticVMOptions`）
* 实验参数（`-XX:+UnlockExperimentalVMOptions`）

---

十一、内存泄漏与溢出分析

* 内存泄漏检测方法与常见场景（静态变量、集合缓存等）
* 堆外内存泄漏（DirectBuffer、JNI）
* 各类异常详解：

  * `OutOfMemoryError: Java heap space`
  * `OutOfMemoryError: GC overhead limit exceeded`
  * `OutOfMemoryError: Metaspace`
  * `StackOverflowError`
* OOM 定位与分析流程（堆快照 → MAT 工具分析 → 可疑对象定位）

---

十二、JIT 编译器与性能

* JIT 与 AOT（提前编译）机制
* 热点代码探测与优化
* 编译优化触发条件
* JVM 内联、循环展开、逃逸分析
* 逃逸分析与锁消除、栈上分配、标量替换
* `-XX:+PrintCompilation`, `-XX:+UnlockDiagnosticVMOptions`

---

十三、常见性能调优策略

* 减少对象创建频率（对象池、重用）
* 降低 GC 压力（零拷贝、缓存、并发容器）
* 合理设置线程栈大小（`-Xss`）
* 优化类加载顺序与惰性加载
* 合理使用软引用、弱引用、虚引用

</details>

<details>
<summary>11.单元测试与自动化测试</summary>

一、测试基础概念

* 什么是单元测试（Unit Test）
* 集成测试、端到端测试、冒烟测试的区别
* 白盒测试 vs 黑盒测试
* TDD（测试驱动开发）与 BDD（行为驱动开发）
* 测试金字塔模型（单元测试、服务测试、UI测试比例）

---

二、JUnit 框架（主流单元测试框架）

* JUnit 4 与 JUnit 5 的核心区别
* 注解用法

  * `@Test`, `@BeforeEach`, `@AfterEach`
  * `@BeforeAll`, `@AfterAll`, `@Disabled`
  * `@Nested`, `@DisplayName`
* 断言方法（`assertEquals`, `assertThrows`, `assertAll`, `assertTimeout` 等）
* 参数化测试（`@ParameterizedTest`）
* 测试生命周期与执行顺序控制
* 自定义测试运行器（JUnit 4 的 `@RunWith`）

---

三、断言库与扩展

* Hamcrest 匹配器（`Matchers.*`）
* AssertJ（链式断言）
* Truth（Google 出品的断言库）

---

四、Mock 框架

* Mockito 基础

  * 模拟对象（`@Mock`, `Mockito.mock()`）
  * 行为验证（`verify()`）
  * 打桩与返回值控制（`when(...).thenReturn(...)`）
  * 参数匹配器（`any()`, `eq()`, `argThat()`）
  * 部分 Mock（`spy`）
  * 静态方法 Mock（Mockito 3.4+ 配合插件）
* PowerMock（已逐步弃用，了解其作用）
* EasyMock（了解层面）

---

五、Spring 测试支持

* `@SpringBootTest` 启动完整上下文
* `@WebMvcTest`、`@DataJpaTest`、`@MockBean`
* 嵌入式数据库测试（H2、Derby）
* 测试配置隔离（`@TestConfiguration`, `@TestPropertySource`）
* 使用 `@Transactional` 保证测试数据回滚
* MockMvc 测试 Controller 接口（模拟 HTTP 请求）

---

六、数据库测试

* 嵌入式数据库测试（如 H2）
* DBUnit（数据库状态前后对比）
* 使用 Testcontainers 容器化数据库进行集成测试
* 数据准备与清理策略（脚本、SQL 插件）

---

七、接口与自动化 API 测试

* REST Assured（Java 中用于 HTTP 接口测试）
* Postman / Newman 脚本集成
* 使用 Mock Server 模拟外部依赖
* JSONPath / XMLPath 数据断言
* 使用 WireMock / MockServer 构建 API 测试环境

---

八、持续集成中的自动化测试

* 与 Maven/Gradle 集成（`mvn test`, `gradle test`）
* 测试阶段集成到 CI 流程（Jenkins、GitHub Actions、GitLab CI）
* 分组执行测试（标签、类别、Profile）
* 测试失败邮件通知 / 构建失败中断
* 并行测试配置

---

九、测试覆盖率分析

* JaCoCo 插件集成（Maven/Gradle）
* 报告生成（HTML、XML、Sonar 支持）
* 覆盖率指标：行覆盖率、分支覆盖率、方法覆盖率、类覆盖率
* 结合 SonarQube 实现测试质量网关

---

十、端到端自动化测试（了解层面）

* Selenium（UI 自动化测试）
* Selenide（Selenium 的简化封装）
* Playwright / Cypress（跨端自动化测试框架，非 Java 专属）
* 页面元素定位、等待策略、测试脚本结构

---

十一、性能与压力测试（辅助方向）

* JMeter（负载测试）
* Gatling（Scala为主，但支持 Java 脚本）
* Locust（了解层面）

---

十二、最佳实践

* 测试命名规范与可读性
* 单一职责测试类、独立测试用例
* 使用 `@TempDir` / `@TempFile` 管理临时资源
* 保持测试幂等性与独立性
* Mock 不要过度（留出真实调用路径）

</details>

<details>
<summary>12.常用第三方库</summary>

一、通用工具类库

* **Apache Commons 系列**

  * `commons-lang3`：字符串处理、对象工具、反射、数学等
  * `commons-io`：文件与流的操作
  * `commons-collections`：增强集合操作
  * `commons-codec`：编码解码（Base64, MD5, SHA）
  * `commons-beanutils`：JavaBean 操作工具
  * `commons-cli`：命令行参数解析
* **Google Guava**

  * 不可变集合、缓存（Cache）、函数式编程支持
  * Optional、Preconditions、Joiner、Splitter 等实用工具

---

二、JSON/XML 序列化解析

* **Jackson**

  * JSON 序列化与反序列化
  * Tree Model 与 Data Binding
* **Gson（Google）**

  * 轻量级 JSON 序列化库
* **Fastjson（阿里）**

  * 快速 JSON 处理库（注意安全问题）
* **XStream / JAXB / Jackson XML**

  * XML 与 Java 对象互转

---

三、日志框架

* **SLF4J（Simple Logging Facade for Java）**

  * 日志抽象层，与其他日志框架配合使用
* **Logback**

  * SLF4J 默认实现，支持高级功能（异步日志、配置重载等）
* **Log4j / Log4j2**

  * 经典日志实现（Log4j2 推荐）
* **TinyLog / JBoss Logging / JUL（Java Util Logging）**（了解层面）

---

四、日期时间工具库

* **Joda-Time**（旧时代主流）
* Java 8+ 自带 `java.time`（JSR-310）取代 Joda-Time

---

五、HTTP 客户端与网络通信

* **OkHttp**

  * 高性能 HTTP 客户端，支持连接池、拦截器
* **Apache HttpClient**

  * 传统 HTTP 请求库，功能完善
* **Retrofit**

  * 基于注解的 HTTP API 声明式客户端（依赖 OkHttp）
* **Feign（Spring Cloud）**

  * 微服务远程调用声明式客户端
* **WebSocket 客户端库**（如 Tyrus、Java-WebSocket）

---

六、Excel/Office 操作

* **Apache POI**

  * 操作 Office 文档（XLS, DOC, PPT 等）
* **EasyExcel（阿里）**

  * 高性能 Excel 读写（基于 POI）
* **JXLS**

  * 模板驱动的 Excel 生成工具

---

七、数据库辅助工具

* **HikariCP**

  * 高性能数据库连接池
* **Druid**

  * 数据源 + SQL 监控、日志记录、慢 SQL 分析
* **Flyway / Liquibase**

  * 数据库版本控制与迁移管理工具
* **MyBatis-Plus**

  * MyBatis 增强工具，简化 CRUD 操作
* **JOOQ**

  * 类型安全的 SQL 构建器

---

八、对象拷贝与映射

* **MapStruct**

  * 编译期自动生成映射代码（高性能）
* **ModelMapper**

  * 运行时映射，适合复杂嵌套对象
* **Dozer**（了解层面）

---

九、安全与加密

* **Jasypt**

  * 配置加密解密工具，集成 Spring Boot 使用广泛
* **Bouncy Castle**

  * 加密算法库（支持 PGP、SM 系列等）
* **JWT（Java JWT、jjwt、nimbus-jose-jwt）**

  * JSON Web Token 的生成与校验

---

十、验证与规则引擎

* **Hibernate Validator / Jakarta Bean Validation**

  * Java Bean 参数校验（JSR-380）
* **Apache Commons Validator**

  * 表单校验工具库
* **Easy Rules / Drools**

  * 轻量级规则引擎 / 企业级规则引擎

---

十一、异步任务与调度

* **Quartz**

  * 分布式调度框架，支持 CRON 表达式
* **xxl-job**

  * 分布式任务调度平台（带可视化 UI）
* **Elastic-Job（京东开源）**

  * 分布式弹性调度框架

---

十二、缓存与中间件客户端

* **Redis 客户端**

  * Jedis（传统）
  * Lettuce（Spring 推荐）
  * Redisson（高阶特性支持：分布式锁、限流等）
* **Ehcache / Caffeine**

  * 本地缓存解决方案

---

十三、文件上传与处理

* **Apache Commons FileUpload**

  * Multipart 文件上传解析
* **Tika**

  * 文件内容提取与 MIME 类型识别
* **Thumbnailator / Imgscalr**

  * 图片压缩与缩放工具

---

十四、测试与模拟

* **JUnit / TestNG**
* **Mockito / PowerMock**
* **REST Assured**
* **WireMock / MockServer**

---

十五、开发效率工具类库

* **Lombok**

  * 注解生成 getter/setter、构造方法、builder 等
* **Vavr**

  * 函数式编程增强（Option, Try, Tuple 等）
* **Reflections**

  * 扫描类路径、获取注解信息
* **Apache Curator**

  * ZooKeeper 客户端封装
* **Hutool**

  * 国人开发的 Java 工具包合集（字符串、日期、集合、加解密、IO 等）

</details>

<details>
<summary>13.架构设计与项目组织</summary>

一、软件架构基础概念

* 什么是架构（Architecture）与设计（Design）的区别
* 架构原则：

  * SOLID 原则
  * 高内聚、低耦合
  * 关注点分离（SoC）
  * 单一职责、开闭原则
* 架构风格：

  * 单体架构（Monolith）
  * 微服务架构（Microservices）
  * 服务化架构（SOA）
  * 无服务器架构（Serverless）
  * 分层架构、管道-过滤器架构、事件驱动架构

---

二、常见分层架构模式

* 三层架构（Controller → Service → DAO）
* 四层架构（增加领域层/Facade 层）
* Hexagonal Architecture（六边形架构 / Ports & Adapters）
* Clean Architecture（清晰架构）
* Onion Architecture（洋葱架构）
* DDD 架构模型（领域驱动设计）

---

三、项目模块组织结构

* Maven 多模块（parent + 子模块划分）

  * API 模块、Domain 模块、Service 模块、Web 模块
* 分包结构命名规范（controller, service, repository, dto, vo, config, exception）
* 分层职责划分与访问限制（包内可见性、模块边界控制）
* 公共模块提取（工具类、通用配置、基础依赖）
* 分库分表支持的项目结构设计
* 跨模块调用方式（接口依赖、事件驱动、RPC）

---

四、领域驱动设计（DDD）核心知识

* 通用语言（Ubiquitous Language）
* 聚合（Aggregate）
* 聚合根（Aggregate Root）
* 实体（Entity）与值对象（Value Object）
* 领域服务（Domain Service）
* 仓储（Repository）
* 领域事件（Domain Event）
* 限界上下文（Bounded Context）
* 应用服务 vs 领域服务

---

五、架构设计常见模式（设计模式应用于架构层）

* 控制反转（IoC）与依赖注入（DI）
* MVC / MVVM 模式
* 工厂模式用于 Bean 初始化
* 观察者模式用于事件驱动
* 模板方法用于流程控制
* 策略模式用于业务策略扩展
* 责任链模式用于请求处理链
* 装饰器、适配器、代理模式在系统解耦中的应用

---

六、微服务架构设计关键点（与 Spring Cloud 配合）

* 服务拆分粒度原则
* 服务注册与发现（如 Eureka、Nacos、Consul）
* 配置中心（Spring Cloud Config、Apollo）
* API 网关（Spring Cloud Gateway、Kong）
* 服务调用方式（RestTemplate、Feign、gRPC）
* 服务容错机制（Hystrix、Resilience4j）
* 服务链路追踪（Sleuth、Zipkin、SkyWalking）
* 服务监控与告警（Prometheus、Grafana、Micrometer）

---

七、接口与 DTO 设计

* VO、DTO、PO、DO 的职责划分
* 参数对象封装（分页参数、查询条件）
* Bean 映射工具（MapStruct、ModelMapper）
* 接口幂等性设计
* API 返回结构标准化（Result 封装、错误码设计）

---

八、统一异常与日志处理

* 全局异常处理机制（`@ControllerAdvice`, `@ExceptionHandler`）
* 自定义异常层次结构
* 统一日志记录规范
* 日志链路标识（traceId、spanId）
* 操作日志与审计日志系统设计

---

九、安全架构设计

* 鉴权授权架构（RBAC、ABAC）
* 单点登录（SSO）
* OAuth2/OpenID Connect 接入设计
* 接口权限控制（注解拦截器、方法级别权限）
* 防护机制：CSRF、XSS、接口签名、防重放攻击等

---

十、架构演进与治理

* 架构评审机制
* 技术选型流程与原则
* 可插拔架构设计
* 多环境部署（dev/test/staging/prod）
* 中台建设与复用机制（用户中台、支付中台等）
* 配置管理与灰度发布机制
* 技术债识别与重构计划制定

---

十一、系统非功能性设计

* 可扩展性（横向扩展、垂直扩展）
* 可用性与容错设计（降级、限流、熔断）
* 高并发处理（异步化、队列、缓存）
* 可观测性（日志、指标、追踪）
* 安全性、稳定性、可维护性

</details>

<details>
<summary>14.Spring 企业开发与微服务架构</summary>

一、Spring 核心框架知识

* 控制反转（IoC）与依赖注入（DI）
* 面向切面编程（AOP）

  * 动态代理（JDK vs CGLIB）
  * 切面定义：`@Aspect`, `@Before`, `@After`, `@Around`
* Bean 生命周期与作用域（singleton, prototype, request, session）
* 注解驱动配置（`@Component`, `@Service`, `@Repository`, `@Configuration`, `@Bean`）
* 条件装配与 Profile（`@Conditional`, `@Profile`）
* 容器事件机制（ApplicationEvent、监听器）

---

二、Spring Boot 基础

* 自动配置机制（@EnableAutoConfiguration）
* Spring Boot 启动器（Starter）
* 核心配置文件（`application.yml` / `application.properties`）
* 多环境配置与激活（`spring.profiles.active`）
* 自定义 Starter 开发
* Spring Boot Actuator 监控与指标暴露
* 配置绑定（`@ConfigurationProperties`, `@Value`）

---

三、Spring MVC（Web开发）

* 请求映射与参数处理（`@RequestMapping`, `@GetMapping`, `@PostMapping`）
* 请求参数绑定（`@RequestParam`, `@PathVariable`, `@RequestBody`）
* 响应处理与序列化（`@ResponseBody`, Jackson/Gson）
* 表单校验（JSR-303 / JSR-380、`@Valid`, `@Validated`）
* 拦截器（HandlerInterceptor）
* 异常处理（`@ControllerAdvice`, `@ExceptionHandler`）
* 文件上传与多媒体接口支持

---

四、Spring Data 与数据库集成

* Spring Data JPA / Spring Data JDBC
* Repository 接口定义与查询派生方法
* 原生 SQL 与 JPQL 查询（`@Query`）
* 分页与排序支持（Pageable, Sort）
* 事务控制（`@Transactional`, 事务传播与隔离级别）
* 多数据源配置与路由
* Redis 数据访问支持（Spring Data Redis）

---

五、Spring AOP 与声明式编程

* 声明式事务管理
* 日志审计切面
* 接口权限切面
* 幂等校验、重复提交拦截
* 防刷限流实现（AOP + Redis）

---

六、缓存与中间件集成

* Spring Cache 抽象（`@Cacheable`, `@CachePut`, `@CacheEvict`）
* 缓存管理器配置（Ehcache, Caffeine, Redis）
* 分布式锁实现（基于 Redis, Zookeeper）
* 消息中间件集成：

  * RabbitMQ（Spring AMQP）
  * Kafka（Spring Kafka）
  * RocketMQ（Spring Cloud Stream）

---

七、Spring Security 与认证授权

* 安全过滤器链（FilterChain）
* 用户认证流程（UsernamePasswordAuthenticationToken）
* 方法级权限控制（`@PreAuthorize`, `@Secured`）
* OAuth2 客户端与资源服务器配置
* JWT 鉴权与 Token 管理
* Spring Authorization Server（替代 Spring OAuth）

---

八、Spring 定时任务与异步处理

* `@Scheduled` 注解与 CRON 表达式
* `@EnableScheduling` 与线程池配置
* 异步方法调用（`@Async`, 异步执行器配置）
* 分布式定时任务调度（Quartz、ElasticJob、xxl-job）

---

九、Spring Cloud 微服务体系

* 服务注册与发现：

  * Eureka（已废弃）、Consul、Nacos
* 配置中心：

  * Spring Cloud Config、Nacos Config、Apollo
* 负载均衡：

  * Ribbon（已废弃）、Spring Cloud LoadBalancer
* 服务调用：

  * RestTemplate、Feign、WebClient（响应式）
* 服务网关：

  * Spring Cloud Gateway、Zuul（已废弃）
* 服务容错：

  * Hystrix（已废弃）、Resilience4j
  * 熔断、降级、重试、限流
* 服务追踪与监控：

  * Spring Cloud Sleuth + Zipkin / SkyWalking / Jaeger
* 消息驱动微服务：

  * Spring Cloud Stream（Kafka / RocketMQ / RabbitMQ 支持）

---

十、配置、灰度与 DevOps 集成

* 动态刷新配置（`@RefreshScope`）
* 灰度发布方案设计（配置中心 + 标签路由）
* Canary 发布支持（服务网关 + 版本策略）
* 服务探活与自愈机制（Actuator + Prometheus）
* Docker 与 K8s 中的 Spring 微服务部署
* Helm 配置管理与 Spring Boot 的容器打包（Jib、Dockerfile）

---

十一、Spring WebFlux（响应式编程）

* Mono 与 Flux 数据类型
* 响应式 Controller（`@RestController`, `@GetMapping`）
* 响应式数据库支持（R2DBC）
* 响应式安全控制（Spring Security Reactive）
* 与传统 MVC 模型的核心差异

---

十二、Spring 企业级开发最佳实践

* 配置中心 + 多环境管理
* 多模块拆分与治理结构（统一依赖、统一接口、统一异常）
* 接口幂等性、幂等 Token
* 通用返回体封装（Result/Response）
* API 版本管理设计（路径、Header、参数方式）
* 统一异常处理与错误码体系
* 接口文档生成（Swagger / SpringDoc OpenAPI）
* CI/CD + 自动化测试集成（SonarQube, Jenkins, GitOps）

---

十三、企业级常用整合点

* MyBatis / JPA 持久层选择与集成
* DDD 分层 + Spring 模块化实践
* MQ（Kafka、RocketMQ）业务解耦与异步处理
* Redis 缓存策略（缓存穿透、击穿、雪崩防护）
* 防重提交（基于 Token、分布式锁）
* 限流（注解 + Redis + Lua 脚本 / Bucket4j）

</details>
