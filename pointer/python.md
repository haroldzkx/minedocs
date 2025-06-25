# 资源链接

Python 标准库: [https://docs.python.org/zh-cn/3.13/library/index.html](https://docs.python.org/zh-cn/3.13/library/index.html)

# 基础语法

<details>
<summary>数据类型</summary>

1. Numbers: [简介](https://docs.python.org/zh-cn/3.13/library/stdtypes.html#numeric-types-int-float-complex)

2. String: [简介](https://docs.python.org/zh-cn/3.13/library/stdtypes.html#text-sequence-type-str)

3. List: [简介](https://docs.python.org/zh-cn/3.13/library/stdtypes.html#lists) / [列表详解1](https://docs.python.org/zh-cn/3.13/tutorial/datastructures.html#more-on-lists) / [列表详解2](https://docs.python.org/zh-cn/3.13/tutorial/introduction.html#lists)

4. Tuple: [简介](https://docs.python.org/zh-cn/3.13/library/stdtypes.html#tuples) / [元组详解](https://docs.python.org/zh-cn/3.13/tutorial/datastructures.html#tuples-and-sequences)

5. Dict: [简介](https://docs.python.org/zh-cn/3.13/library/stdtypes.html#mapping-types-dict) / [字典详解](https://docs.python.org/zh-cn/3.13/tutorial/datastructures.html#dictionaries)

6. bool: [简介](https://docs.python.org/zh-cn/3.13/library/stdtypes.html#boolean-type-bool)

7. set: [简介](https://docs.python.org/zh-cn/3.13/library/stdtypes.html#set-types-set-frozenset) / [集合详解](https://docs.python.org/zh-cn/3.13/tutorial/datastructures.html#sets)

8. 列表推导式: [基础用法](https://docs.python.org/zh-cn/3.13/tutorial/datastructures.html#list-comprehensions) / [嵌套的列表推导式](https://docs.python.org/zh-cn/3.13/tutorial/datastructures.html#nested-list-comprehensions)

9. 枚举类型Enum: [详细用法](https://docs.python.org/zh-cn/3.13/howto/enum.html)

</details>

<details>
<summary>控制流工具</summary>

1. if 语句: [简介](https://docs.python.org/zh-cn/3.13/tutorial/controlflow.html#if-statements)

2. for 循环: [简介](https://docs.python.org/zh-cn/3.13/tutorial/controlflow.html#for-statements)

3. range() 函数: [简介](https://docs.python.org/zh-cn/3.13/tutorial/controlflow.html#the-range-function)

4. break 和 continue: [简介](https://docs.python.org/zh-cn/3.13/tutorial/controlflow.html#break-and-continue-statements)

5. pass 语句: [简介](https://docs.python.org/zh-cn/3.13/tutorial/controlflow.html#pass-statements)

6. match 语句: [简介](https://docs.python.org/zh-cn/3.13/tutorial/controlflow.html#match-statements)

</details>

<details>
<summary>函数</summary>

1. 定义函数: [简介](https://docs.python.org/zh-cn/3.13/tutorial/controlflow.html#defining-functions)

2. 函数定义详解: [详细内容](https://docs.python.org/zh-cn/3.13/tutorial/controlflow.html#more-on-defining-functions)

3. lambda 表达式: [基础用法](https://docs.python.org/zh-cn/3.13/tutorial/controlflow.html#lambda-expressions)

4. 函数注解: [简介](https://docs.python.org/zh-cn/3.13/tutorial/controlflow.html#function-annotations) / [函数标注](https://peps.python.org/pep-3107/) / [类型提示](https://peps.python.org/pep-0484/)

</details>

<details>
<summary>模块与包</summary>

</details>

<details>
<summary>类与对象</summary>

</details>

<details>
<summary>异常处理</summary>

</details>

<details>
<summary>多线程 / 多进程 / 协程 / 并发</summary>

</details>

# 工具

# 使用 C/C++ 扩展 Python

在大型项目中，Cython 处理高层逻辑，pybind11 封装底层 C++ 模块。

<details>
<summary>Cython</summary>

Cython官网: [https://cython.org/](https://cython.org/)

Cython 的使用场景：

- 需要优化纯 Python 代码（如科学计算、数据处理）。
- 混合 Python 与 C/C++的项目，逐步迁移关键代码到 C。
- 对 C++高级特性（如模板）依赖较少。

</details>

<details>
<summary>pybind11</summary>

pybind11官网: [https://pybind11.readthedocs.io/en/stable/](https://pybind11.readthedocs.io/en/stable/)

pybind11 使用场景：已有 C++ 代码，封装起来让 python 调用

</details>

