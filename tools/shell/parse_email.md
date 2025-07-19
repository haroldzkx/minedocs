<details>
<summary>使用Python解析email文件</summary>

```python
from email import policy
from email.parser import BytesParser
from email.utils import parsedate_tz, mktime_tz
from datetime import datetime
import os

def parse_eml(file_path, output_folder):
    # 如果文件夹不存在，则创建文件夹
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    # 打开.eml文件
    with open(file_path, 'rb') as f:
        # 使用 BytesParser 解析.eml文件
        msg = BytesParser(policy=policy.default).parse(f)
    
    # 提取邮件信息
    subject = msg['subject']
    from_ = msg['from']
    to = msg['to']
    date = msg['date']
    
    # 将原始日期转换为友好的格式
    if date:
        # 解析日期并转换为时间戳
        timestamp = mktime_tz(parsedate_tz(date))
        # 使用 datetime 格式化为人类可读格式
        formatted_date = datetime.fromtimestamp(timestamp).strftime('%Y-%m-%d %H:%M:%S')
    else:
        formatted_date = "No date found"
    
    # 初始化正文内容
    body = None
    attachments = []

    if msg.is_multipart():
        # 如果邮件是多部分的（包含附件或不同的格式）
        for part in msg.iter_parts():
            # 处理正文
            if part.get_content_type() == 'text/plain':
                body = part.get_payload(decode=True).decode(part.get_content_charset())
            # 处理附件
            elif part.get_content_disposition() == 'attachment':
                filename = part.get_filename()
                if filename:
                    file_data = part.get_payload(decode=True)
                    file_path = os.path.join(output_folder, filename)
                    with open(file_path, 'wb') as f:
                        f.write(file_data)
                    attachments.append(file_path)
    else:
        # 如果邮件不是多部分的
        body = msg.get_payload(decode=True).decode(msg.get_content_charset())

    # 如果仍然没有获取到正文内容，可以设置一个默认值
    if body is None:
        body = "No text body found"
    
    return {
        'subject': subject,
        'from': from_,
        'to': to,
        'date': formatted_date,
        'body': body,
        'attachments': attachments
    }

# 使用函数解析.eml文件
file_path = './apple.eml'
output_folder = './res'  # 设置保存附件的文件夹
parsed_email = parse_eml(file_path, output_folder)

print()
print("*" * 50)
print(f"Subject: {parsed_email['subject']}")
print(f"From: {parsed_email['from']}")
print(f"To: {parsed_email['to']}")
print(f"Date: {parsed_email['date']}")
print(f"Body:\n{parsed_email['body']}")
print(f"Attachments: {parsed_email['attachments']}")
print("*" * 50)
print()
```

</details>