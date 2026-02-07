# GET

```bash
curl https://www.baidu.com/
curl -X GET https://www.baidu.com/

# 带参数的GET请求
curl https://api.example.com/users?id=123&name=John
```

# POST

```bash
curl -X POST https://www.baidu.com/ -d '{"key": "value"}'
curl -XPOST https://www.baidu.com/ -d '{"key": "value"}'
curl -X POST https://www.baidu.com/ \
    -H 'Content-Type:application/json' \
    -H 'Authorization: Bearer token123' \
    -d '{"key": "value"}'
```

# Header

```bash
# 查看请求头信息
curl -I https://www.baidu.com/
```

# 文件处理

```bash
# 下载文件
curl -O https://xxxx.xx/fjalsfjjfasjfla.png

# 下载文件并重命名
curl -o hello.png https://xxxx.xx/fjalsfjjfasjfla.png

# 下载文件并限制下载速度
curl --limit-rate 100k -o hello.png https://xxxx.xx/fjalsfjjfasjfla.png

# 断点续传
curl -C - -o hello.png https://xxxx.xx/fjalsfjjfasjfla.png
```

# 其他

```bash
# 跟随重定向
curl https://www.baidu.com/ -L

# 显示底层信息
curl -v -L https://www.baidu.com/

# 通过代理访问网站
curl --proxy 协议://用户名:密码@代理地址:端口 URL
curl --proxy "http://egg:123@127.0.0.1:1234" https://www.baidu.com/

# 通过FTP下载文件
curl -u 用户名:密码 -O ftp://server/egg.avi
# 通过FTP上传文件
curl -u 用户名:密码 -T 文件 ftp://server/

# 带语法高亮的查看
curl -s https://api.example.com/users | jq . --color-output

# 查看特定字段
curl -s https://api.example.com/users/1 | jq '.name'

# 只显示响应体（过滤掉头信息）
curl -s -w "\n" https://api.example.com/users
```

# 脚本 1

```bash
# !/bin/bash
# base.sh
api_request() {
    local method="$1"
    local base_url="$2"
    local endpoint="$3"
    local headers=("${!4}")
    local body="$5"

    ########################################################
    # Auto handle URL path (prevent //)
    local full_url="${base_url%/}/${endpoint#/}"

    # Build curl command
    local cmd=("curl" "-s" "-X" "$method")

    # Add request Headers
    for header in "${headers[@]}"; do
        cmd+=("-H" "$header")
    done

    # Add request Body (if exists)
    if [ -n "$body" ]; then
        cmd+=("-d" "$body")
    fi

    ########################################################
    # build curl command for display
    local display_cmd="curl -s -X $method"
    for header in "${headers[@]}"; do
        display_cmd+=" -H \"$header\""
    done
    [ -n "$body" ] && display_cmd+=" -d \"$body\""
    display_cmd+=" \"$full_url\""
    # display command
    echo
    echo "---------- [ Executing Command ] ----------"
    echo
    echo "$display_cmd"
    echo
    echo "---------- [ Results... ] ----------"
    echo

    ########################################################
    # Add full_url and execute command
    cmd+=("$full_url")
    "${cmd[@]}"

    echo
    echo
    echo "---------- [ End Output ] ----------"
    echo
}
```

```bash
# !/bin/bash
# user_get.sh
# import function api_request
source ./base.sh

BASE_URL="https://www.baidu.com/"
METHOD="GET"
ENDPOINT=""
HEADERS=(
    # "Authorization: Bearer token123"
    "User-Agent: MyApp/1.0"
)
BODY=""

echo "---------- [ Sending $METHOD Request... ] ----------"
api_request "$METHOD" "$BASE_URL" "$ENDPOINT" HEADERS[@] "$BODY"
```

```bash
# !/bin/bash
# user_post.sh
# import function api_request
source ./base.sh

BASE_URL="https://api.example.com/v1"
METHOD="POST"
ENDPOINT="/create"
HEADERS=(
    "Content-Type: application/json"
    "Authorization: Bearer token123"
)
BODY='{"name": "John", "age": 30}'

echo "---------- [ Sending $METHOD Request... ] ----------"
api_request "$METHOD" "$BASE_URL" "$ENDPOINT" HEADERS[@] "$BODY"
```

```bash
# !/bin/bash
# user_path_parameters.sh
# import function api_request
source ./base.sh

BASE_URL="https://api.example.com/v1"
METHOD="PUT"
ENDPOINT="users/12345/profile"
HEADERS=(
    "Content-Type: application/json"
    "Authorization: Bearer token123"
)
BODY_FILE="update_payload.json"

if [ -f "$BODY_FILE" ]; then
    echo "---------- [ Sending $METHOD Request... ] ----------"
    api_request "$METHOD" "$BASE_URL" "$ENDPOINT" HEADERS[@] "$(cat "$BODY_FILE")"
else
    echo "---------- [ Error: $BODY_FILE not found ] ----------"
fi
```

# 脚本 2

```bash
#!/bin/bash

# 设置请求的URL、方法和数据
endpoint="https://api.example.com/users"
method="POST"
data='{"name":"John"}'

# 打印完整的curl命令到控制台
echo "curl -X $method $endpoint -H \"Content-Type: application/json\" -d '$data'"

# 使用curl发送请求
curl -X $method $endpoint \
  -H "Content-Type: application/json" \
  -d "$data"
```
