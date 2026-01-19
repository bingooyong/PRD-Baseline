# XSS & CSRF Protection Baseline
# XSS 与 CSRF 防护基线

## 企业级前端安全需求基线

---

## 1. 文档元信息（Governance）

**Baseline-ID**: ID-FRONT-XSS-CSRF  
**Domain**: Frontend Security  
**Baseline-Level**: Enterprise  
**Version**: v1.0.0  
**Status**: Approved  
**Owner**: Security Architecture Committee  
**Effective-Date**: 2024-01-01  
**Review-Cycle**: 12 months

### 1.1 适用范围（Scope）

本 Baseline 适用于：

- 所有 Web 前端应用
- 单页应用（SPA）
- 移动端 H5 应用
- 管理后台前端

### 1.2 不适用范围（Out of Scope）

- 原生移动应用
- 桌面应用

---

## 2. 设计目标（Security Objectives）

- 防止跨站脚本攻击（XSS）
- 防止跨站请求伪造（CSRF）
- 保护用户会话安全
- 防止敏感信息泄露
- 支持安全的内容安全策略（CSP）

---

## 3. XSS 防护（XSS Protection）

### XSS-01 输出编码

**Level**: MUST

- 所有用户输入 **必须** 在输出时编码
- HTML 输出 **必须** 使用 HTML 实体编码
- JavaScript 输出 **必须** 使用 JavaScript 编码
- URL 输出 **必须** 使用 URL 编码

**验证方法**: 代码审查、XSS 测试工具

### XSS-02 内容安全策略（CSP）

**Level**: MUST

- **必须** 配置 Content-Security-Policy 头
- CSP **必须** 禁止内联脚本（'unsafe-inline'）
- CSP **必须** 禁止 eval（'unsafe-eval'）
- CSP **必须** 配置允许的资源源（白名单）

**验证方法**: CSP 头检查、CSP 测试

### XSS-03 输入验证

**Level**: MUST

- 用户输入 **必须** 在客户端和服务端双重验证
- 输入长度 **必须** 限制
- 输入格式 **必须** 验证
- 特殊字符 **必须** 过滤或转义

**验证方法**: 输入验证测试、代码审查

### XSS-04 富文本编辑器

**Level**: MUST

- 富文本编辑器 **必须** 使用白名单标签和属性
- HTML 内容 **必须** 在服务端清理（HTML Sanitization）
- 禁止的标签和属性 **必须** 过滤
- 富文本内容 **必须** 在输出时再次验证

**验证方法**: 富文本编辑器测试、HTML 清理审查

---

## 4. CSRF 防护（CSRF Protection）

### CSRF-01 CSRF Token

**Level**: MUST

- 所有状态变更操作 **必须** 使用 CSRF Token
- CSRF Token **必须** 在服务端生成和验证
- CSRF Token **必须** 绑定到用户会话
- CSRF Token **必须** 在每次请求中验证

**验证方法**: CSRF 测试、Token 实现审查

### CSRF-02 SameSite Cookie

**Level**: MUST

- 会话 Cookie **必须** 设置 SameSite 属性
- SameSite **必须** 设置为 Strict 或 Lax
- SameSite=None **必须** 配合 Secure 使用
- Cookie **必须** 设置 HttpOnly 和 Secure

**验证方法**: Cookie 配置检查、浏览器测试

### CSRF-03 请求头验证

**Level**: SHOULD

- **应该** 验证 Origin 或 Referer 头
- Origin/Referer **应该** 在白名单中
- 缺失 Origin/Referer **应该** 拒绝请求

**验证方法**: 请求头验证测试、配置审查

---

## 5. 会话安全（Session Security）

### SESSION-01 会话管理

**Level**: MUST

- 会话 ID **必须** 随机生成（至少 128 位）
- 会话 ID **必须** 在 Cookie 中传递
- 会话 Cookie **必须** 设置 HttpOnly
- 会话 Cookie **必须** 设置 Secure（HTTPS）

**验证方法**: 会话实现审查、Cookie 配置检查

### SESSION-02 会话超时

**Level**: MUST

- 会话 **必须** 设置超时时间（默认 30 分钟）
- 会话超时 **必须** 在服务端验证
- 会话超时 **必须** 提示用户重新登录
- 会话 **应该** 支持"记住我"功能（延长超时）

**验证方法**: 会话超时测试、配置审查

### SESSION-03 会话固定

**Level**: MUST

- 登录后 **必须** 重新生成会话 ID
- 权限变更后 **必须** 重新生成会话 ID
- 旧会话 ID **必须** 立即失效

**验证方法**: 会话固定测试、代码审查

---

## 6. 敏感信息保护（Sensitive Data Protection）

### DATA-01 敏感信息处理

**Level**: MUST

- 敏感信息 **禁止** 存储在 localStorage
- 敏感信息 **禁止** 存储在 sessionStorage
- 敏感信息 **禁止** 在 URL 参数中传递
- 敏感信息 **必须** 加密存储（如需要）

**验证方法**: 代码审查、存储检查

### DATA-02 密码处理

**Level**: MUST

- 密码 **禁止** 在前端存储
- 密码 **禁止** 在日志中记录
- 密码输入 **必须** 使用 type="password"
- 密码 **必须** 在传输时加密（HTTPS）

**验证方法**: 密码处理审查、安全测试

### DATA-03 错误信息

**Level**: MUST

- 错误信息 **禁止** 泄露敏感信息
- 错误信息 **禁止** 泄露系统内部信息
- 错误信息 **必须** 用户友好
- 详细错误 **必须** 记录到服务端日志

**验证方法**: 错误处理测试、安全审查

---

## 7. 第三方资源安全（Third-Party Resource Security）

### THIRD-01 外部资源

**Level**: MUST

- 外部 JavaScript **必须** 使用 Subresource Integrity (SRI)
- 外部资源 **必须** 使用 HTTPS
- 外部资源 **必须** 在白名单中
- 外部资源 **禁止** 加载不可信内容

**验证方法**: 外部资源审查、SRI 检查

### THIRD-02 CDN 安全

**Level**: MUST

- CDN 资源 **必须** 使用 HTTPS
- CDN 资源 **必须** 配置 CORS
- CDN 资源 **应该** 使用 SRI
- CDN 域名 **必须** 在白名单中

**验证方法**: CDN 配置审查、安全测试

---

## 8. 禁止项（Forbidden）

- 内联 JavaScript（CSP 禁止）
- eval() 函数使用
- 未编码的用户输入输出
- 无 CSRF Token 的状态变更操作
- 敏感信息存储在客户端
- 无 HttpOnly 的会话 Cookie

---

## 9. 验收标准（Acceptance Criteria）

### FRONT-AC-01 XSS 测试

**场景**: XSS 攻击测试

**预期结果**:
- 所有 XSS 攻击被阻止
- 用户输入正确编码
- CSP 策略生效

### FRONT-AC-02 CSRF 测试

**场景**: CSRF 攻击测试

**预期结果**:
- 无 CSRF Token 的请求被拒绝
- CSRF Token 正确验证
- SameSite Cookie 生效

---

## 10. 参考标准（References）

- OWASP Top 10 - XSS、CSRF
- Content Security Policy (CSP)
- SameSite Cookies
- Subresource Integrity (SRI)

---

## 11. 变更日志（Changelog）

- v1.0.0 (2024-01-01): 初始版本
