业务都用 Python 来做，后面再考虑优化性能，因为绝大多数项目到不了性能优化的地步，也没有很高的并发量

用户登录服务可以抽离成一个单独的 gRPC 服务，用 Python / C++ 实现

# Pipeline - Web

1. 前端：React
2. 后端：REST API ( FastAPI ) + gRPC API ( cpp 实现，Python 实现 )
3. ORM：SQLAlchemy, ODB
4. 数据库：MySQL, PostgreSQL, Redis

# FastAPI

API数据接口

- [ ] CRUD操作
- [ ] 分页
- [ ] 搜索与过滤
- [ ] 排序
- [ ] 数据校验pydantic
- [ ] 文件上传与下载
- [ ] 图像处理（验证码，缩略图）
- [ ] 数据导出Excel, CSV, PDF

安全与权限控制

- [ ] 认证（JWT, OAuth2, Session, API Key）
- [ ] 授权（RBAC，ABAC，Scopes）
- [ ] 密码管理
- [ ] 防止 CSRF, XSS, SQL注入
- [ ] 限流（IP/用户/接口级别限速）
- [ ] CORS（配置跨域资源访问）
- [ ] 安全Headers
- [ ] 统一异常处理与错误码设计

通讯与消息系统

- [ ] 邮件服务
- [ ] 短信服务
- [ ] WebSocket支持（实时推送）
- [ ] Webhook支持（发送，接受）
- [ ] 消息队列

异步任务与定时调度

- [ ] 异步任务（发送邮件、图像处理等延迟任务）
- [ ] 定时任务（每日统计、清理任务）
- [ ] 任务失败重试机制
- [ ] 任务状态查询 / 审核

系统基础能力

- [ ] 配置管理（多环境配置加载.env）
- [ ] 数据库迁移Alembic
- [ ] 事务支持
- [ ] 缓存 redis
- [ ] 多语言支持
- [ ] 版本管理 api/v1, api/v2
- [ ] 配置热更新 Consul / ETCD
- [ ] 分层架构（路由层，服务层，DAO层，模型层）

开发与维护工具

- [ ] 依赖管理（pip, uv）
- [ ] 脚本工具（初始化数据库，创建用户）
- [ ] 自动API文档
- [ ] 测试Pytest + httpx
- [ ] Mock 数据生成工具

可观测性与监控

- [ ] 日志记录（结构化JSON日志）
- [ ] 错误追踪（Sentry / Rollbar）
- [ ] 性能监控（Prometheus / Grafana）
- [ ] 链路追踪（OpenTelemetry）
- [ ] 审计日志：用户行为记录

部署与运维

- [ ] 应用服务器 uvicorn gunicorn hypercorn
- [ ] 容器化 Docker
- [ ] 负载均衡
- [ ] CI / CD 集成
- [ ] CDN集成

