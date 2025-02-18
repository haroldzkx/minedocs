# 封装接口自动化框架

## 前置准备

接口自动化封装内容：

- 使用yaml作为用例，降低自动化门槛
- 自动请求接口、断言接口
- 自动在日志记录HTTP报文
- 自动生成allure测试报告

接口测试用例：设计用例内容

1. 名字：请求首页数据接口
2. 标记【可选】
3. 步骤：
    1. 请求接口：GET https://www.baidu.com/
    2. 响应断言：status_code == 200
    3. 提取变量: json()['code']

YAML表示用例

```yaml
name: 登录成功用例
steps:
    - request: # 发送请求
        method: POST
        url: http://ip/shop/api.php?aplication=app&application_client_type=weixin
        params:
            s: user/login
        json: {
            "accounts": "xxx",
            "pwd": "xxx",
            "type": "username"
        }

    - response: # 响应断言
        status_code: 200
        json:
            code: 0
            msg: 登录成功
            data:
                username: xxx
    
    - extract: # 提取变量
        token: [json, $.data.token]
```

## 具体封装步骤

```python
import requests

method = 'POST'
url = 'http:/ip/uri'

""" 1.请求接口 """
response = request.request(
    method,
    url,
    headers={
        "a": 1,
        "b": [1, 2, 3],
        "c": {}
    }
    headers={
        "a": 1,
        "b": [1, 2, 3],
        "c": {}
    }
)

""" 2.响应断言 """
# response 就是响应内容
print(response.status_code)
print(response.headers) # 响应头
print(response.text)    # 响应正文
print(response.json())  # 响应正文转成JSON

# 断言单个内容是否正确
assert response.status_code == 200
assert '美酒' in response.text
assert response.json()['data']['banner_list'][0]["name"] == "美酒"

# 断言全部内容
from responses_validator import validator

validator(
    response,
    status_code=200,
    text='*美酒*',
    json={
        "data": {
            "banner_list": [{"name": "美酒"}]
        }
    }
)

""" 3.变量提取 """
from extract_utils import extract

var = mextract(response, 'json', '$.data.banner_list[0].name')
print(var)
```

变量提取

基本原则：

- JSON: JSONPATH
- HTML: XPATH
- 字符串: RE（兜底）

```python
# extract_utils.py
import jsonpath

def extract(response, attr_name, exp):
    try:
        response.json = response.json()
    except Exception:
        response.json = {}
    attr = getattr(response, attr_name)
    res = jsonpath.jsonpath(attr, exp)
    return res[0]
```

## 框架落地封装

<details>
<summary>项目结构</summary>

```bash
commons/__init__.py
commons/extract_utils.py
commons/runner_utils.py
commons/yaml_utils.py

data/data.yaml

logs/   # 生成的日志放这里

report/ # allure生成的报告放这里

temps/  # allure生成报告需要的材料放这里

tests/test_api.yaml
tests/test_yaml.py

conftest.py
main.py
pytest.ini
```

</details>

<details>
<summary>commons/extract_utils.py</summary>

```python
import jsonpath

def extract(response, attr_name, exp):
    try:
        response.json = response.json()
    except Exception:
        response.json = {}
    attr = getattr(response, attr_name)
    res = jsonpath.jsonpath(attr, exp)
    return res[0]
```

</details>

<details>
<summary>commons/runner_utils.py</summary>

```python
import requests
import responses_validator
from commons.extract_utils import extract

import logging

logger = logging.getLogger("Project Name")

def runner(k, v):
    match k:
        case 'request': # 发送请求
            logger.info("1. 正在发送请求...")
            logger.info(f"{v}")
            my_var['resp'] = requests.request(**v)   # 字典使用 **
        case 'response':    # 断言响应
            logger.info("2. 正在断言响应...")
            logger.info(f"{v}")
            responses_validator.validator(my_var['resp'], **v)  # 字典使用 **
        case 'extract': # 变量提取
            logger.info("3. 正在提取变量...")
            for var_name, var_exp in v.items():
                value = extract(my_var['resp'], *var_exp) # 列表使用 *
                logger.info(f" {var_name}  = {value} ")
        # 查询数据库...
```

</details>

<details>
<summary>commons/yaml_utils.py</summary>

```python
import yaml

def load_yaml(path):
    f = open(path, encoding="utf-8")
    s = f.read()
    data = yaml.safe_load(s)
    return data
```

</details>

<details>
<summary>data/data.yaml</summary>

```yaml
数字:
    - 1
    - -1
    - 1.1

字符串:
    - 'fadsfasdf'
    - "fagjasdlfjla"
    - fjalsdjfla

空值: null # JSON写法

列表: [ 1, 2, 3 ] # JSON写法

字典: { "a": 1, "b": 2 } # JSON写法
```

</details>

<details>
<summary>tests/test_api.yaml</summary>

```yaml
name: 登录成功用例
steps:
    - request: # 发送请求
        method: POST
        url: http://ip/shop/api.php?aplication=app&application_client_type=weixin
        params:
            s: user/login
        json: {
            "accounts": "xxx",
            "pwd": "xxx",
            "type": "username"
        }

    - response: # 响应断言
        status_code: 200
        json:
            code: 0
            msg: 登录成功
            data:
                username: xxx
    
    - extract: # 提取变量
        token: [json, $.data.token]
```

</details>

<details>
<summary>tests/test_yaml.py</summary>

```python
import allure
from commons.yaml_utils import load_yaml
from commons.runner_utils import runner

def test_yaml():
    my_var = {}
    data = load_yaml("tests/test_api.yaml")
    allure.title(data['name'])

    for step in data['steps']:
        for k, v in step.items():
            runner(k, v, my_var)
```

</details>

<details>
<summary>conftest.py</summary>

```python

```

</details>

<details>
<summary>main.py</summary>

```python
import os
import pytest

pytest.main()
os.system(f"allure generate -c -o report temps")
```

</details>

<details>
<summary>pytest.ini</summary>

```ini
[pytest]

addopts = --alluredir=./temps --clean-alluredir

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

</details>



<details>
<summary>可以进一步完善的内容</summary>

1. yaml用例测试文件上传？

2. yaml用例进行数据驱动测试？

3. yaml用例进行自定义的断言

4. yaml用例进行数据库查询？

</details>

<details>
<summary>可以参考的项目结构</summary>

```bash
commons/__init__.py
commons/assert_utils.py
commons/extract_utils.py
commons/hotload_utils.py
commons/model_util.py
commons/request_utils.py
commons/to_python.py
commons/to_yaml.py
commons/runner_utils.py
commons/yaml_utils.py

data/data.yml

logs/   # 生成的日志放这里

report/ # allure生成的报告放这里

temps/  # allure生成报告需要的材料放这里

tests/yaml_case/note.txt
tests/yaml_case/test_01_get_token.yaml
tests/yaml_case/test_02_good_favor.yaml
tests/yaml_case/test_03_md5.yaml
tests/yaml_case/test_04_base64.yaml
tests/yaml_case/test_05_rsa.yaml
tests/test_yaml_case.py

.dockerignore
.gitignore
conftest.py
Dockerfile
main.py
index.html
pytest.ini
requirements.txt
run.py
url.txt
```

</details>