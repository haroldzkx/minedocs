# 资源链接

Python 标准库: [https://docs.python.org/zh-cn/3.13/library/index.html](https://docs.python.org/zh-cn/3.13/library/index.html)

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

