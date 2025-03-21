30T 精选资源: [https://www.aliyundrive.com/s/FERKFwRNjKt/folder/63b2595cef44bad3984842d5b4622a4258c9089b](https://www.aliyundrive.com/s/FERKFwRNjKt/folder/63b2595cef44bad3984842d5b4622a4258c9089b)

网易云课程: [https://www.aliyundrive.com/s/FERKFwRNjKt/folder/637f0b4c7578fe9bb3eb4f68bf05e8c9160c19ec](https://www.aliyundrive.com/s/FERKFwRNjKt/folder/637f0b4c7578fe9bb3eb4f68bf05e8c9160c19ec)

[网易云课程](./netease.md)

极客时间: [https://www.aliyundrive.com/s/FERKFwRNjKt/folder/637f0f18cb3babcf096c433d88d8969ac806cba6](https://www.aliyundrive.com/s/FERKFwRNjKt/folder/637f0f18cb3babcf096c433d88d8969ac806cba6)

[极客时间](./geektime.md)

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
import re

# 读取原始数据
with open('output.txt', 'r', encoding='utf-8') as file:
    lines = file.readlines()

# 创建一个列表存储（数字，链接）元组
data = []

# 提取每行中的数字并按数字排序
for line in lines:
    match = re.match(r'(\d+)-(.+)', line.strip())
    if match:
        number = match.group(1)  # 提取数字部分
        link = match.group(2)    # 提取链接部分
        # 在数字部分如果是01则转化为001
        if len(number) < 3:
            number = "0" + number
        data.append((int(number), line.strip()))  # 按照数字排序

# 按数字排序
data.sort(key=lambda x: x[0])

# 将排序后的数据写入到新的文件
with open('sorted_output.txt', 'w', encoding='utf-8') as output_file:
    for _, line in data:
        output_file.write(line + "\n")

print("排序完成，结果已保存到 sorted_output.txt")
```

```python
import json

# 模拟读取数据（你可以替换为读取文件的内容）
# data = [
#     {
#         "drive_id": "451437261",
#         "domain_id": "bj29",
#         "file_id": "637f0fa9fce8318163a84a9092836d880cc27884",
#         "share_id": "FERKFwRNjKt",
#         "name": "【极客时间】Web安全攻防实战",
#         "type": "folder",
#         "created_at": "2022-11-24T06:31:05.110Z",
#         "updated_at": "2023-04-01T10:31:34.783Z",
#         "parent_file_id": "637f0f18cb3babcf096c433d88d8969ac806cba6"
#     },
#     {
#         "drive_id": "451437261",
#         "domain_id": "bj29",
#         "file_id": "637f1086926769c472b44095b3a565379150fb0b",
#         "share_id": "FERKFwRNjKt",
#         "name": "99-JavaScript核心原理解析",
#         "type": "folder",
#         "created_at": "2022-11-24T06:34:46.313Z",
#         "updated_at": "2022-11-24T06:34:46.313Z",
#         "parent_file_id": "637f0f18cb3babcf096c433d88d8969ac806cba6"
#     }
# ]

with open('file.txt', 'r', encoding='utf-8') as file:
    data = json.load(file)

# 创建新文件用于写入链接
with open('output.txt', 'w', encoding='utf-8') as output_file:
    for item in data:
        name = item.get('name')
        share_id = item.get('share_id')
        file_type = item.get('type')
        file_id = item.get('file_id')

        # 构造链接
        link = f"{name}: [https://www.aliyundrive.com/s/{share_id}/{file_type}/{file_id}](https://www.aliyundrive.com/s/{share_id}/{file_type}/{file_id})\n"

        # 将链接写入到新文件中
        output_file.write(link)

print("处理完毕，链接已写入到 output.txt")
```
