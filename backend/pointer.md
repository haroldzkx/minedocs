django 做后台管理系统，前台用 fastapi+微服务

```mermaid
flowchart TB

client["Client"]
CDN["CDN"]
static["`Apache/Nginx/Tengine
（负载均衡，反向代理，
托管静态资源）`"]
ds["`Django Server
uWSGI/Gunicorn
Daphne/Hypercorn/Uvicorn
（托管动态资源）`"]
sentry["`Sentry
应用级别的异常监控，
性能分析`"]

client --> CDN
CDN --> client
client -- request --> static
static --> ds
ds --> sentry
```

# Django 与 DRF

![](https://gitee.com/haroldzkx/pbed1/raw/main/web/django.jpg)

![](https://gitee.com/haroldzkx/pbed1/raw/main/web/drf.jpg)

Django+DRF 将后端变成一种声明式的工作流，只要按照 models -> serializers -> views -> urls 的模式去一个个 py 文件去配置，即可生成一个很全面的通用的后端。当然，如果需求不那么通用，这种设计就变成了一个累赘。


同步和异步的 web 部署方式：

- WSGI：同步。通过多进程+多线程的方式实现并发。
- ASGI：异步。通过多进程+主线程（不存在多线程）+协程的方式实现并发。