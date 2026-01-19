# API Security Baseline
# API 安全基线

## 企业级 API 安全需求基线

---

## 1. 文档元信息（Governance）

**Baseline-ID**: ID-API-SECURITY  
**Domain**: API Integration  
**Baseline-Level**: Enterprise  
**Version**: v1.0.0  
**Status**: Approved  
**Owner**: Security Architecture Committee  
**Effective-Date**: 2024-01-01  
**Review-Cycle**: 12 months

### 1.1 适用范围（Scope）

本 Baseline 适用于：

- 所有 RESTful API
- GraphQL API
- RPC API（gRPC、Dubbo 等）
- WebSocket API
- 第三方 API 集成

### 1.2 不适用范围（Out of Scope）

- 内部服务间调用（同一信任域）
- 文件上传下载接口（详见《File Upload Baseline》）

---

## 2. 设计目标（Security Objectives）

- 防止未授权访问
- 防止 API 滥用和攻击
- 保护敏感数据传输
- 支持 API 版本管理
- 提供完整的审计日志

---

## 3. 认证与授权（Authentication & Authorization）

### API-AUTH-01 API 认证

**Level**: MUST

- 所有 API **必须** 要求认证
- 认证方式 **必须** 支持：API Key、OAuth 2.0、JWT
- API Key **必须** 定期轮换（建议 90 天）
- API Key **必须** 支持撤销

**验证方法**: API 测试、认证机制审查

### API-AUTH-02 授权检查

**Level**: MUST

- API **必须** 实现基于角色的访问控制（RBAC）
- 授权检查 **必须** 在业务逻辑之前执行
- 授权失败 **必须** 返回 403 Forbidden
- 授权决策 **必须** 记录审计日志

**验证方法**: 代码审查、授权测试

### API-AUTH-03 Token 管理

**Level**: MUST

- JWT Token **必须** 设置过期时间（默认 1 小时）
- Token **必须** 支持刷新机制
- Token **必须** 支持撤销（黑名单）
- Token **禁止** 在 URL 参数中传递

**验证方法**: Token 实现审查、安全测试

---

## 4. 输入验证（Input Validation）

### API-VAL-01 参数验证

**Level**: MUST

- 所有输入参数 **必须** 验证
- 参数类型 **必须** 验证（字符串、数字、日期等）
- 参数长度 **必须** 限制
- 参数格式 **必须** 验证（邮箱、URL、正则等）

**验证方法**: 代码审查、输入验证测试

### API-VAL-02 SQL 注入防护

**Level**: MUST

- **禁止** 拼接 SQL 语句
- **必须** 使用参数化查询或 ORM
- 动态 SQL **必须** 使用白名单验证
- SQL 注入尝试 **必须** 记录和告警

**验证方法**: 代码审查、安全扫描

### API-VAL-03 XSS 防护

**Level**: MUST

- 输出数据 **必须** 转义或编码
- Content-Type **必须** 正确设置
- CSP 头 **应该** 配置
- 用户输入 **禁止** 直接输出到 HTML

**验证方法**: 代码审查、XSS 测试

### API-VAL-04 文件上传验证

**Level**: MUST

- 文件类型 **必须** 白名单验证
- 文件大小 **必须** 限制
- 文件名 **必须** 验证和清理
- 上传文件 **必须** 病毒扫描

**验证方法**: 文件上传测试、安全审查

---

## 5. 速率限制（Rate Limiting）

### API-RATE-01 限流策略

**Level**: MUST

- API **必须** 实现速率限制
- 限流 **必须** 基于：IP、用户、API Key
- 限流阈值 **必须** 可配置
- 限流触发 **必须** 返回 429 Too Many Requests

**验证方法**: 限流测试、配置审查

### API-RATE-02 限流粒度

**Level**: MUST

- 限流 **必须** 支持时间窗口（秒、分钟、小时）
- 限流 **应该** 支持滑动窗口
- 限流 **应该** 支持令牌桶算法
- 限流配置 **必须** 有文档说明

**验证方法**: 限流实现审查、性能测试

---

## 6. 数据传输安全（Data Transmission Security）

### API-TLS-01 HTTPS 强制

**Level**: MUST

- 生产环境 API **必须** 使用 HTTPS
- TLS 版本 **必须** ≥ 1.2
- TLS 配置 **必须** 禁用弱加密算法
- HTTP **禁止** 在生产环境使用

**验证方法**: TLS 配置审查、安全扫描

### API-TLS-02 证书管理

**Level**: MUST

- SSL 证书 **必须** 有效
- 证书 **必须** 定期更新（到期前 30 天）
- 证书链 **必须** 完整
- 自签名证书 **禁止** 在生产环境使用

**验证方法**: 证书检查、证书管理流程审查

---

## 7. API 版本管理（API Versioning）

### API-VER-01 版本策略

**Level**: MUST

- API **必须** 支持版本控制
- 版本 **必须** 在 URL 或 Header 中指定
- 版本格式 **必须** 统一（v1、v2 等）
- 旧版本 **必须** 有弃用计划

**验证方法**: API 文档审查、版本策略检查

### API-VER-02 向后兼容

**Level**: SHOULD

- API 变更 **应该** 保持向后兼容
- 不兼容变更 **必须** 发布新版本
- 旧版本 **应该** 保留至少 6 个月
- 版本弃用 **必须** 提前通知（至少 3 个月）

**验证方法**: 版本兼容性测试、文档审查

---

## 8. 错误处理（Error Handling）

### API-ERR-01 错误响应

**Level**: MUST

- 错误响应 **必须** 使用标准 HTTP 状态码
- 错误消息 **必须** 不泄露敏感信息
- 错误响应 **必须** 包含错误码和错误消息
- 错误响应 **必须** 结构化（JSON 格式）

**验证方法**: 错误处理测试、安全审查

### API-ERR-02 错误日志

**Level**: MUST

- 错误 **必须** 记录日志
- 错误日志 **必须** 包含：时间、用户、请求、错误信息
- 敏感信息 **禁止** 记录到日志
- 错误日志 **必须** 支持查询和分析

**验证方法**: 日志审查、错误追踪测试

---

## 9. API 文档（API Documentation）

### API-DOC-01 API 文档

**Level**: MUST

- API **必须** 提供完整文档
- 文档 **必须** 包含：接口说明、参数、响应、示例
- 文档 **应该** 支持在线测试（Swagger UI）
- 文档 **必须** 与代码同步更新

**验证方法**: 文档审查、文档完整性检查

---

## 10. 禁止项（Forbidden）

- 无认证的 API
- HTTP 协议（生产环境）
- 无输入验证的 API
- 无速率限制的 API
- 泄露敏感信息的错误消息

---

## 11. 验收标准（Acceptance Criteria）

### API-AC-01 安全测试

**场景**: API 安全扫描

**预期结果**:
- 无高危漏洞
- 认证授权正常
- 输入验证完整

### API-AC-02 性能测试

**场景**: API 压力测试

**预期结果**:
- 限流机制正常
- 响应时间可接受
- 无内存泄漏

---

## 12. 参考标准（References）

- OWASP API Security Top 10
- RESTful API 设计规范
- OAuth 2.0 规范
- JWT 规范

---

## 13. 变更日志（Changelog）

- v1.0.0 (2024-01-01): 初始版本
