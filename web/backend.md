应用层：Controller, Service, Model
安全模块
任务队列模块：用于处理异步任务，尤其是长时间运行的任务
缓存模块
部署与容器化模块：容器，CI/CD
监控与报警模块
中间件模块

web 框架

- 身份认证: 用户名/密码, JWT, OAuth
- 权限管理: ALC, RBAC
- ORM，异步 ORM
- 日志记录
- 缓存系统
- 路由
- RESTFul API
- 接口文档
- API 网关
- 错误处理
- IP 限流
- 分页

---

不一定要用 pybind11 将 python 和 cpp 混合，可以使用 cpp 的 drogon 框架做 API，直接调用 drogon 的 API 就行

---

# 认证

1. JWT (JSON Web Token) 认证

- 推荐使用场景：适用于需要用户身份验证和权限管理的电商 API，例如登录、订单管理、支付、用户信息等。

- JWT：适合现代电商网站，尤其是前后端分离的应用。它可以处理大量用户请求，支持分布式架构，也便于跨域认证，能够提供更高的安全性和灵活性。适用于所有需要用户身份验证的场景，如登录、订单管理、购物车等。

2. OAuth 2.0 认证

- 适用场景：适用于需要更复杂的授权和身份验证的电商网站，特别是在需要集成第三方登录（如微信、支付宝、Google 等）时。

- 推荐使用场景：如果需要与第三方支付、社交平台或其他外部服务集成，OAuth 2.0 是一种更灵活、标准的认证方式。例如，允许用户使用微信、支付宝或 Facebook 登录你的电商平台。
