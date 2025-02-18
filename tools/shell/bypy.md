# bash

```bash
apt update
pip install --upgrade pip -i https://pypi.mirrors.ustc.edu.cn/simple
pip install -i https://pypi.mirrors.ustc.edu.cn/simple bypy
apt install aria2 -y

bypy --downloader aria2 download testpy testpy
```

# docker-compose.yml

```yml
# docker compose up -d
services:
  bypy:
    image: registry.cn-shenzhen.aliyuncs.com/haroldfinch/python:3.10.16-slim-bookworm-arm
    container_name: bypy
    volumes:
      - ./:/home/work
    command: ["tail", "-f", "/dev/null"]
    restart: always
```
