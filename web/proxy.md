# 正向代理（前置代理）与反向代理

```mermaid
graph LR
    subgraph 部分A
        direction TB
        A[步骤A]
        B[步骤B]
    end

    subgraph 部分B
        direction LR
        C[步骤C]
        D[步骤D]
    end

    A --> C
    B --> D
```

![img](./images/proxy.png)

正向代理的作用:

1. 访问原来无法访问的资源，如 google
2. 可以做缓存，加速访问资源
3. 对客户端访问授权，上网进行认证
4. 代理可以记录用户访问记录（上网行为管理），对外隐藏用户信息

反向代理的作用:

1. 保证内网的安全，阻止 web 攻击，大型网站，通常将反向代理作为公网访问地址，Web 服务器是内网。
2. 负载均衡，通过反向代理服务器来优化网站的负载。
