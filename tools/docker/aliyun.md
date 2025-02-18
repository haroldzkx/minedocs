# 【阿里云镜像仓库】

[容器镜像服务-阿里云](https://www.aliyun.com/product/acr)

| Docker Hub          | 阿里云镜像中心                     |
| ------------------- | ---------------------------------- |
| 用户名              | 命名空间                           |
| 镜像名              | 镜像仓库                           |
| tag                 | tag                                |
| `用户名/镜像名:tag` | `服务器地址/命名空间/镜像仓库:tag` |

# GitHub 仓库构建镜像

1. 容器镜像服务中使用“个人实例” [https://cr.console.aliyun.com/cn-shenzhen/instances](https://cr.console.aliyun.com/cn-shenzhen/instances)
2. 在个人实例中创建命名空间
3. 在个人实例中创建镜像仓库

![](https://gitee.com/haroldzkx/pbed1/raw/main/docker/aliyun.4.png)

先关联 GitHub 账号，然后选择仓库

> GitHub 仓库自己去 Fork 官方的 GitHub 或者别人项目的 GitHub 就行
>
> 关联的是自己的 GitHub 账户

![](https://gitee.com/haroldzkx/pbed1/raw/main/docker/aliyun.5.png)

![](https://gitee.com/haroldzkx/pbed1/raw/main/docker/aliyun.6.png)

4. 构建规则

![](https://gitee.com/haroldzkx/pbed1/raw/main/docker/aliyun.7.png)

5. 构建镜像并查看构建日志

![](https://gitee.com/haroldzkx/pbed1/raw/main/docker/aliyun.8.png)

# Skopeo 同步镜像

首先安装 skopeo

```bash
apt install skopeo -y
```

```bash
#!/bin/bash
# nginx.skopeo.sh
IMAGE="nginx"
TAGS=(
  "1.27.3"
  "1.27.3-perl"
  "1.27.3-otel"
  "1.27.3-alpine"
  "1.27.3-alpine-perl"
  "1.27.3-alpine-slim"
  "1.27.3-alpine-otel"
  "1.26.2"
  "1.26.2-perl"
  "1.26.2-otel"
  "1.26.2-alpine"
  "1.26.2-alpine-perl"
  "1.26.2-alpine-slim"
  "1.26.2-alpine-otel"
)

for TAG in "${TAGS[@]}"; do
  skopeo copy --src-tls-verify=false docker://m.daocloud.io/docker.io/library/$IMAGE:$TAG docker://registry.cn-shenzhen.aliyuncs.com/haroldfinch/$IMAGE:$TAG
done
```

```bash
chmod +x nginx.skopeo.sh
./nginx.skopeo.sh
```

# 使用

## 登录 Registry

本地登录阿里云 Docker Registry

```bash
docker login --username=happyhammer registry.cn-shenzhen.aliyuncs.com
```

## 拉取镜像

本地拉取镜像如下所示

```bash
docker pull registry.cn-shenzhen.aliyuncs.com/haroldfinch/python:[镜像版本号]
```

这里名称太长可以在 `.bashrc`或 `.zshrc` 中添加如下内容，然后 `source .bashrc`

```bash
export ali=registry.cn-shenzhen.aliyuncs.com/haroldfinch
```

本地使用时就可以如下所示

```bash
docker pull $ali/[镜像名]:[镜像版本号]
```

## 推送镜像

```bash
docker tag [ImageId / Image Name] registry.cn-shenzhen.aliyuncs.com/haroldfinch/[镜像名]:[镜像版本号]
docker push registry.cn-shenzhen.aliyuncs.com/haroldfinch/[镜像名]:[镜像版本号]
```
