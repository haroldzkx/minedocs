```python
# Python 扫码登录 B 站
# 1. 生成二维码
# 2. 解析二维码内容：从B站登录二维码中提取 auth_key
# 3. 模拟扫码操作：使用 auth_key 调用B站的接口，模拟手机客户端的扫码行为
# 4. 模拟确认登录：调用B站的确认登录接口，完成登录流程
# 5. 获取登录凭证：确认登录后，B站会返回 cookies，你可以用这些 cookies 模拟登录状态
import cv2
from pyzbar import pyzbar
import requests

# 扫描二维码
def scan_qrcode(image_path):
    pass

# 模拟扫码
def simulate_scan(auth_key):
    pass

# 模拟确认登录
def simulate_confirm(auth_key):
    pass

# 获取用户信息
def get_user_info(cookies):
    pass

# 主程序
if __name__ == "__main__":
    # 扫描二维码
    qrcode_data = scan_qrcode("bilibili_qrcode.png")
    if qrcode_data:
        # 提取auth_key
        auth_key = qrcode_data.split("auth_key=")[1]
        print("提取的auth_key:", auth_key)

        # 模拟扫码
        simulate_scan(auth_key)

        # 模拟确认登录
        cookies = simulate_confirm(auth_key)

        # 获取用户信息
        if cookies:
            get_user_info(cookies)
```

```python
# import cv2
from pyzbar import pyzbar
import requests
from PIL import Image


# 扫描二维码
def scan_qrcode(image_path):
    image = Image.open(image_path)
    barcodes = pyzbar.decode(image)
    if barcodes:
        barcode_data = barcodes[0].data.decode("utf-8")
        print("解析到的二维码内容:", barcode_data)
        return barcode_data
    else:
        print("未找到二维码")
        return None

# 模拟扫码
def simulate_scan(auth_key):
    url = "https://passport.bilibili.com/x/passport-tv-login/qrcode/tv_scan_code"
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
        "Referer": "https://passport.bilibili.com/"
    }
    data = {
        "auth_code": auth_key,
        "source": "main_web"
    }
    response = requests.post(url, headers=headers, data=data)
    result = response.json()
    if result["code"] == 0:
        print("模拟扫码成功！")
    else:
        print("模拟扫码失败:", result["message"])

# 模拟确认登录
def simulate_confirm(auth_key):
    url = "https://passport.bilibili.com/x/passport-tv-login/qrcode/tv_login"
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
        "Referer": "https://passport.bilibili.com/"
    }
    data = {
        "auth_code": auth_key,
        "source": "main_web"
    }
    response = requests.post(url, headers=headers, data=data)
    result = response.json()
    if result["code"] == 0:
        print("模拟确认登录成功！")
        print("Cookies:", response.cookies.get_dict())
        return response.cookies
    else:
        print("模拟确认登录失败:", result["message"])
        return None

# 获取用户信息
def get_user_info(cookies):
    url = "https://api.bilibili.com/x/web-interface/nav"
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    }
    response = requests.get(url, headers=headers, cookies=cookies)
    result = response.json()
    print("用户信息:", result)

# 主程序
if __name__ == "__main__":
    # 扫描二维码
    qrcode_data = scan_qrcode("./bili.png")
    if qrcode_data:
        # 提取auth_key
        auth_key = qrcode_data.split("auth_key=")[1]
        print("提取的auth_key:", auth_key)

    #     # 模拟扫码
    #     simulate_scan(auth_key)

    #     # 模拟确认登录
    #     cookies = simulate_confirm(auth_key)
    #     print(cookies)

    #     # 获取用户信息
    #     if cookies:
    #         get_user_info(cookies)
```

```yml
# docker compose up -d
services:
  qrcode:
    image: registry.cn-shenzhen.aliyuncs.com/haroldfinch/python:3.10.16-slim-bookworm-arm
    container_name: qrcode
    volumes:
      - ./src:/home/work
    command: tail -f /dev/null
    restart: always
```
