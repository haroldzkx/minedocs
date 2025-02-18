# 基础设施

<details>
<summary></summary>

</details>

## 数据类型

| 标准类型名         | 类型名               | 宽度（字节） | 符号 | 说明（Nginx 中的用法）                                                                                         |
| ------------------ | -------------------- | ------------ | ---- | -------------------------------------------------------------------------------------------------------------- |
| signed char        | int8_t               |              |      |                                                                                                                |
| short              | int16_t              |              |      |                                                                                                                |
| int                | int32_t              |              |      |                                                                                                                |
| long long          | int64_t              |              |      |                                                                                                                |
| unsigned char      | uint8_t              |              |      |                                                                                                                |
| unsigned short int | uint16_t             |              |      |                                                                                                                |
| unsigned int       | uint32_t             | 4            | 无   | 标准的 32 位正整数，<br/>主要用于计算散列值                                                                    |
| unsigned long long | uint64_t             | 8            | 无   | 标准的 64 位正整数，<br/>主要用于计算散列值                                                                    |
|                    | size_t               | 4/8          | 无   | 64 位系统里是 8 字节，<br/> 和 u_char 同时出现，表示数据块，如字符串或缓冲区；<br />单独出现用于计算数据的长度 |
| unsigned char      | u_char               | 1            | 无   | 字节                                                                                                           |
| long int           | off_t                | 8            | 有   | 文件偏移量或者文件大小                                                                                         |
|                    |                      |              |      |                                                                                                                |
| long int           | time_t               |              |      |                                                                                                                |
|                    |                      |              |      |                                                                                                                |
| intptr_t           | ngx_int_t            | 4/8          | 有   | Nginx 内部使用的有符号整数                                                                                     |
| uintptr_t          | ngx_uint_t           | 4/8          | 无   | Nginx 内部使用的无符号整数                                                                                     |
| intptr_t           | ngx_flag_t           | 4/8          | 有   | 标志整数类型，即 ngx_int_t，相当于 bool                                                                        |
|                    |                      |              |      |                                                                                                                |
| ngx_uint_t         | ngx_rbtree_key_t     | 4/8          | 无   | 红黑树的键类型                                                                                                 |
| ngx_int_t          | ngx_rbtree_key_int_t | 4/8          | 有   | 红黑树的键类型                                                                                                 |
| ngx_uint_t         | ngx_msec_t           | 4/8          | 无   | 毫秒的整数类型                                                                                                 |
| ngx_int_t          | ngx_msec_int_t       | 4/8          | 有   | 毫秒的整数类型                                                                                                 |

# 高级数据结构

## 动态数组

<details>
<summary>src/core/ngx_array.h</summary>

</details>

<details>
<summary>src/core/ngx_array.c</summary>

</details>

## 单向链表

<details>
<summary>src/core/</summary>

</details>

## 双端队列

<details>
<summary>src/core/</summary>

</details>

## 红黑树

<details>
<summary>src/core/</summary>

</details>
