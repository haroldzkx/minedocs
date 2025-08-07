业务都用 Python 来做，后面再考虑优化性能，因为绝大多数项目到不了性能优化的地步，也没有很高的并发量

用户登录服务可以抽离成一个单独的 gRPC 服务，用 Python / C++ 实现

# FastAPI

- [ ] CRUD操作
- [ ] 分页
- [ ] 搜索与过滤
- [ ] 排序
- [ ] 数据校验pydantic
- [ ] 数据库迁移Alembic
- [ ] 认证（JWT, OAuth2, Session, API Key）
- [ ] 授权（RBAC，ABAC，Scopes）
- [ ] 密码管理
- [ ] 防止 CSRF, XSS, SQL注入
- [ ] 限流（IP/用户/接口级别限速）
- [ ] CORS（配置跨域资源访问）
- [ ] 安全Headers
- [ ] 日志记录
- [ ] 错误追踪Sentry
- [ ] 性能监控
- [ ] OpenTelemetry链路追踪
- [ ] 审计日志：用户行为记录
- [ ] 邮件服务
- [ ] 短信服务
- [ ] WebSocket支持
- [ ] Webhook支持
- [ ] 消息队列
- [ ] 异步任务（发送邮件、图像处理等延迟任务）
- [ ] 定时任务（每日统计、清理任务）
- [ ] 缓存 redis
- [ ] 事务支持
- [ ] 分层架构（路由层，服务层，DAO层，模型层）
- [ ] 配置管理（多环境配置加载.env）
- [ ] 依赖管理（pip, uv）
- [ ] 脚本工具（初始化数据库，创建用户）
- [ ] 容器化Docker
- [ ] 测试Pytest + httpx
- [ ] 自动API文档
- [ ] 版本管理 api/v1, api/v2
- [ ] 应用服务器 uvicorn gunicorn hypercorn
- [ ] CI / CD 集成
- [ ] 配置热更新 Consul / ETCD
- [ ] 负载均衡
- [ ] 多语言支持
- [ ] 文件上传与下载
- [ ] 图像处理（验证码，缩略图）
- [ ] Excel, CSV, PDF到处
- [ ] CDN集成

