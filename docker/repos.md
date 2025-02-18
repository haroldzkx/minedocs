# 【Docker 国内镜像源】

## DaoCloud

https://docs.daocloud.io/community/mirror.html

```bash
# 使用方法
# 1.增加前缀（推荐）:
k8s.gcr.io/coredns/coredns => m.daocloud.io/k8s.gcr.io/coredns/coredns

# 2.修改镜像仓库的前缀
k8s.acr.io/coredns/coredns => k8s-gcr.m.daocloud.io/coredns/coredns

docker pull m.daocloud.io/docker.io/library/node:17.5.0-stretch-slim
```
