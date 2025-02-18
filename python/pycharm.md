# 连接服务器远程开发

---

> 也推荐用这种方式连接【Docker（本地）】与【Docker（远程）】

---

1. 配置 Docker

   ```dockerfile
   FROM python:3.8-slim

   # install ssh
   RUN echo "root:0" | chpasswd \
       && apt-get update --yes \
       && apt-get install openssh-server openssh-client --yes \
       && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

   # install python third-party package
   COPY requirements.txt /tmp/
   RUN pip install -r /tmp/requirements.txt -i https://pypi.mirrors.ustc.edu.cn/simple
   ```

   ```dockerfile
   services:
   testcompose:
       container_name: pycharm-test-container
       build:
       context: .
       dockerfile: Dockerfile
       image: pycharm-test-image
       ports:
       - 8080:22
       command: /bin/sh -c "/etc/init.d/ssh start && tail -f /dev/null"
   ```

2. 构建镜像并启动容器

   ```dockerfile
   docker compose up
   ```

   然后按 Ctrl+C 关闭

3. 启动/关闭容器环境

   ```dockerfile
   docker start container_name/container_id
   docker stop container_name/container_id
   ```

4. 设置 PyCharm
   1. PyCharm
   2. Settings
   3. Project: xxx
   4. Python Interpreter
   5. Add Interpreter
   6. On SSH...
   7. 输入 IP，端口号，点 Next / 本地：127.0.0.1:xxxx / 远程：ip:xxxx【这里的 xxxx 是映射到容器的 22 端口的端口】
   8. System Interpreter
   9. Sync folders【在这里修改同步的目录，会自动上传本地项目文件到服务器】
   10. Create
   11. Apply
   12. OK

# 连接 Docker（本地）

---

> 不推荐这种，推荐这个【连接服务器远程开发】

---

1. PyCharm
2. Settings
3. Project: xxx
4. Python Interpreter
5. Add Interpreter
6. On Docker... / On Docker Compose...
7. Build / Pull or use existing
8. Image tag【输入 docker 镜像名】
9. Next
10. Virtualenv Environment / System Interpreter【推荐】 / Conda Environment【推荐】
11. Create
12. Apply
13. OK

# 连接 Docker（服务器）

---

> 不推荐这种，推荐这个【连接服务器远程开发】

---

服务器操作：

1. 启动具有 SSH 的容器，参考这里【连接服务器远程开发】的启动容器操作

本地操作：

1. PyCharm
2. Settings
3. Project: xxx
4. Python Interpreter
5. Add Interpreter
6. On SSH...
7. 输入 IP 地址，容器端口号，点 Next
8. System Interpreter
9. Sync folders【在这里修改同步的目录，会自动上传本地项目文件到服务器】
10. Create
11. Apply
12. OK
