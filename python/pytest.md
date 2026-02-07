# pytest

官网: [https://docs.pytest.org/en/stable/index.html](https://docs.pytest.org/en/stable/index.html)

学习内容

1. pytest及其插件
2. 用例规则
3. 参数
4. 配置文件
5. marks
6. fixture
7. 参数化测试（数据驱动测试）
8. allure测试报告

# 环境搭建

```bash
pip install pytest pytest-html pytest-xdist pytest-rerunfailures pytest-order pytest-result-log allure-pytest
```

# 用例规则

1. 创建test_开头的文件
2. 创建test_开头的函数
3. 使用assert断言


# 参数

pytest -h

- 冒烟测试
- 回归测试
- 逐步测试
- 增量测试
- 分布式测试
- 其他

常用的参数及其效果

- s: 停止捕获
- v: 增加输出详细程序
- x: fast fail快速失败，冒烟测试效果
- pdb: 进入调试模式，可以进行调试

# 配置文件

放在项目根目录，叫pytest.ini

1. 自动加载
2. 插件的主要使用方式

```ini
[pytest]

addopts = -vsx -n2 --reruns 5 

log_file = ./logs/pytest.log
log_file_level = info
log_file_format = %(levelname)-9s %(asctime)s [%(name)s:%(lineno)s] : %(message)s
log_file_date_format = %Y-%m-%d %H:%M:%S

; 记录用例执行结果
result_log_enable = 1
; 记录用例分割线
result_log_separator = 1
; 分割线等级
result_log_level_separator = warning
; 异常信息等级
result_log_level_verbose = info
```

# mark标记

主要用途：给用例打标签，让用例之间显得不同，实现用例筛选和分组

用法：

1. 注册标记
```ini
[pytest]

addopts = -vsx

; 注册标记
markers = 
    api: 接口测试
    ui: UI测试
    ut: 单元测试
    e2e: 端到端测试
    login: 登录相关
    pay: 支付相关
```

2. 使用标记

```python
import pytest

@pytest.mark.api
@pytest.mark.ui
def test_a():
    print("a")

@pytest.mark.ut
def test_b():
    print("b")

@pytest.mark.e2e
def test_c():
    print("c")
```

3. 筛选标记

```ini
[pytest]

; 筛选标记
addopts = -vsx -m api

; 注册标记
markers = 
    api
    ui
    ut
    e2e
```

特殊的内置标记：不需要注册的标记，除了可以实现用例的筛选，可以给用例增加特殊的功能效果

- skip: 无条件跳过
- skipif: 有条件（条件被满足时）跳过
- xfail: 预期失败（把失败改为通过）
- parametrize: 参数化测试（数据驱动测试）
- usefixture: 为用例使用夹具

# fixture夹具

在用例执行之前、执行之后，自动运行代码。使用生成器的方式实现前后置操作（类似Python里的装饰器的功能）

场景：

- 之前：加密参数 / 之后：解密结果
- 之前：启动浏览器 / 之后：关闭浏览器
- 之前：注册、登录账号 / 之后：删除账号

```python
import pytest

@pytest.fixture()
def f():
    print("前置代码，执行")
    yield
    print("后置代码，执行")

@pytest.mark.usefixtures('f')
@pytest.mark.my_fixture
def test_abc():
    print('测试用例，执行')
```

```python
import pytest

# 定义fixture
@pytest.fixture()
def f():
    print("前置代码，执行")
    yield
    print("后置代码，执行")

# 使用fixture
@pytest.mark.my_fixture
def test_abc(f):
    print('测试用例，执行')
```

fixture的作用域：5级作用域

1. function: 默认，在函数内进行共享
2. class: 在类内进行共享
3. module: 在文件内进行共享
4. package: 在文件夹内进行共享
5. session: 在全局进行共享

fixture的高级用法

1. 自动使用 @pytest.fixture(autouse=True)
2. 依赖使用（嵌套fixture）
3. 返回内容（接口自动化封装，接口关联）：yield返回数据，用例函数的参数里接受数据
4. 范围共享
 
# conftest.py

实现跨文件的fixture：conftest.py

```python
import pytest

# 定义fixture
@pytest.fixture()
def f():
    print("前置代码，执行")
    yield
    print("后置代码，执行")
```

在其他文件中可以使用

```python
# 使用fixture
@pytest.mark.my_fixture
def test_abc(f):
    print('测试用例，执行')
```

# 数据驱动测试参数

数据驱动测试 = 参数化测试 + 数据文件

根据数据文件的内容，动态决定用例的数量、内容

```csv
a, b, c
1, 1, 2
2, 3, 5
3, 3, 6
4, 4, 7
```

```python
import pytest

def read_csv(path):
    f = open(path)
    reader = csv.reader(f)
    return list(reader)[1:]

@pytest.mark.ddt
@pytest.mark.parametrize(
    "a, b, c",
    read_csv("data.csv")
)
def test_ddt(a, b, c):
    res = add(int(a), int(b))
    assert res == int(c)
```

# 插件

```bash
# 启用插件
pytest -p html

# 禁用插件
pytest -p no:html
```

插件使用方式：参数 / 配置文件 / fixture / mark

# 企业级测试报告

```bash
# 安装
pip install allure-pytest

# 配置
--alluredirs=temps --clean-alluredir

# 生成报告
allure generate -o report -c temps
```

allure支持对用例进行分组和关联（敏捷开发术语）

使用相同装饰器的用例，自动并入一组

```bash
@allure.epic    史诗    项目
@allure.feature 主题    模块
@allure.story   故事    功能
@allure.title   标题    用例
```

```python
import pytest
import allure

@allure.epic('自动化测试')
@allure.feature('框架训练营')
@allure.story('mark标记和筛选')
@allure.title('实现筛选的用例')
@pytest.mark.ut
def test_a():
    pass

@allure.epic('自动化测试')
@allure.feature('框架训练营')
@allure.story('fixture前置和后置')
@allure.title('使用fixture的用例')
@pytest.mark.ut
def test_b():
    pass
```

