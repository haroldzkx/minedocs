# 连接服务器远程开发

<details>
<summary>Dockerfile</summary>

```dockerfile
# docker build -t NAME .
FROM registry.cn-shenzhen.aliyuncs.com/haroldfinch/python:3.10.16-slim-bookworm

RUN rm /etc/apt/sources.list.d/debian.sources \
    && echo "deb https://mirrors.aliyun.com/debian/ bookworm main non-free non-free-firmware contrib" > /etc/apt/sources.list \
    && echo "deb-src https://mirrors.aliyun.com/debian/ bookworm main non-free non-free-firmware contrib" >> /etc/apt/sources.list \
    && echo "deb https://mirrors.aliyun.com/debian-security/ bookworm-security main" >> /etc/apt/sources.list \
    && echo "deb-src https://mirrors.aliyun.com/debian-security/ bookworm-security main" >> /etc/apt/sources.list \
    && echo "deb https://mirrors.aliyun.com/debian/ bookworm-updates main non-free non-free-firmware contrib" >> /etc/apt/sources.list \
    && echo "deb-src https://mirrors.aliyun.com/debian/ bookworm-updates main non-free non-free-firmware contrib" >> /etc/apt/sources.list \
    && echo "deb https://mirrors.aliyun.com/debian/ bookworm-backports main non-free non-free-firmware contrib" >> /etc/apt/sources.list \
    && echo "deb-src https://mirrors.aliyun.com/debian/ bookworm-backports main non-free non-free-firmware contrib" >> /etc/apt/sources.list \
    && apt update && apt install -y openssh-server openssh-client \
    && echo "root:0" | chpasswd \
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/simple \
    && pip install --upgrade pip
```

</details>

<details>
<summary>docker-compose.yml</summary>

```dockerfile
# docker compose up -d
services:
  NAME:
    image: python:3.10.16-pycharm
    container_name: NAME
    working_dir: /home/work
    ports:
      - 8000:8000
      - 8001:22
    command: ["/bin/sh", "-c", "/etc/init.d/ssh start && tail -f /dev/null"]
```

</details>

设置 PyCharm

1. PyCharm -> Settings -> Project: xxx -> Python Interpreter -> Add Interpreter
2. On SSH... -> 输入 IP，端口号【端口是映射到容器的 22 端口的端口】
3. System Interpreter
4. Sync folders【在这里修改同步的目录，会自动上传本地项目文件到服务器】
5. Create -> Apply -> OK
