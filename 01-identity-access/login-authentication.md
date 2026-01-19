# Login & Authentication Baseline

## 企业级登录与认证需求基线

---

## 1. 文档元信息（Governance）

**Baseline-ID**: ID-AUTH-LOGIN  
**Domain**: Identity & Access Management  
**Baseline-Level**: Enterprise  
**Version**: v1.0.0  
**Status**: Approved  
**Owner**: Security Architecture Committee  
**Effective-Date**: 2024-01-01  
**Review-Cycle**: 12 months

### 1.1 适用范围（Scope）

本 Baseline 适用于：

- 所有 B 端产品
- 所有后端服务提供的用户认证能力
- Web / API / Console / Admin / OpenAPI 登录入口
- 用户名/邮箱/手机号 + 密码认证场景
- 多因素认证（MFA）场景
- 单点登录（SSO）场景

### 1.2 不适用范围（Out of Scope）

- 第三方 IdP 内部实现（详见《SSO Baseline》）
- 非交互式系统账号（详见《Service Account Baseline》）
- API Key / Token 认证（详见《API Authentication Baseline》）
- 生物识别认证实现细节

---

## 2. 设计目标（Security Objectives）

- 防止账号枚举、撞库、爆破攻击
- 确保凭证安全存储与传输
- 支持合规审计与事后追溯
- 满足企业 SDL / 合规基线要求
- 提供一致的用户认证体验

---

## 3. 身份标识与账号模型（Identity Model）

### AUTH-01 用户唯一性

**Level**: MUST

- 系统 **必须** 定义唯一用户标识（User ID）
- 登录标识（用户名 / 邮箱 / 手机）**不得** 作为主键
- 登录标识 **必须** 可变更，User ID 不可变
- User ID **必须** 全局唯一，不可重复使用

### AUTH-02 登录标识支持

**Level**: MUST

- 系统 **必须** 支持至少一种登录标识：
  - 用户名
  - 邮箱地址
  - 手机号
- 系统 **应该** 支持多种登录标识（用户可选择）
- 登录标识 **必须** 唯一性校验（同一类型内）

---

## 4. 凭证管理（Credential Management）

### AUTH-03 密码存储

**Level**: MUST

- 密码 **必须** 使用不可逆算法存储

**允许算法**：
- bcrypt（成本因子 ≥ 10）
- argon2id（推荐）
- scrypt（如适用）

**禁止**：
- 明文存储
- 可逆加密（如 AES）
- MD5、SHA-1、SHA-256（未加盐）
- 自定义加密算法

### AUTH-04 密码复杂度策略

**Level**: MUST

- 最小长度 ≥ 12 字符
- **必须** 包含以下类型中的至少三类：
  - 大写字母 (A-Z)
  - 小写字母 (a-z)
  - 数字 (0-9)
  - 特殊字符 (!@#$%^&*()_+-=[]{}|;:,.<>?)
- **必须** 拒绝弱密码：
  - 常见密码（如 password123）
  - 泄露密码库中的密码
  - 与用户名高度相似的密码
  - 连续字符（如 123456、abcdef）

### AUTH-05 密码历史

**Level**: SHOULD

- 最近 N（≥ 5）次密码 **不得** 重复
- 密码历史记录 **应该** 保留至少 12 个月
- 密码变更 **必须** 立即失效所有活跃会话（除当前会话）

### AUTH-06 密码有效期

**Level**: SHOULD

- 系统 **应该** 支持密码有效期策略
- 默认密码有效期 **应该** ≤ 90 天
- 密码过期前 **应该** 提前 7 天提醒用户
- 密码过期后 **必须** 强制用户修改密码

---

## 5. 登录流程（Authentication Flow）

### AUTH-07 登录失败处理

**Level**: MUST

- 登录失败提示 **不得** 区分：
  - 用户不存在
  - 密码错误
- 错误信息 **必须** 统一返回："用户名或密码错误"
- 所有登录失败尝试 **必须** 记录在审计日志中

### AUTH-08 失败次数与锁定

**Level**: MUST

- 连续失败 ≥ 5 次：
  - **必须** 触发账号锁定
  - 锁定时长 **必须** ≥ 15 分钟
- 锁定期间：
  - 所有登录请求 **必须** 拒绝
  - **必须** 记录审计日志
  - **应该** 发送锁定通知（如配置了邮箱）

### AUTH-09 账号解锁

**Level**: MUST

- 系统 **必须** 支持以下解锁方式：
  - 自动解锁（锁定期满）
  - 管理员手动解锁
  - 用户自助解锁（通过已验证的邮箱/手机）
- 解锁操作 **必须** 记录在审计日志中
- 解锁后 **应该** 要求用户修改密码（如因安全原因锁定）

### AUTH-10 自动化防护

**Level**: SHOULD

- 登录失败 **应该** 触发验证码（如连续失败 3 次）
- **必须** 支持接口级限流（防止暴力破解）
- **应该** 支持异常 IP / 地域检测
- **应该** 支持设备指纹识别

---

## 6. 多因素认证（MFA）

### AUTH-11 MFA 能力

**Level**: SHOULD

- 系统 **应该** 支持至少一种 MFA 方式：
  - TOTP（基于时间的一次性密码，如 Google Authenticator）
  - 短信 OTP
  - 邮件 OTP
  - 硬件密钥（FIDO2/WebAuthn，可选）
- 管理员账号 **必须** 强制启用 MFA
- MFA 启用后，登录流程 **必须** 要求验证第二因素

### AUTH-12 MFA 失败处理

**Level**: MUST

- MFA 验证失败 **必须** 遵循与登录失败相同的锁定策略
- MFA 验证失败 **必须** 记录在审计日志中
- MFA 验证失败 **不得** 泄露 MFA 方式或账户信息

---

## 7. 会话与 Token 管理（Session / Token）

### AUTH-13 会话生成

**Level**: MUST

- 登录成功 **必须** 生成唯一会话标识
- 会话标识：
  - **不得** 包含业务含义（如用户 ID、时间戳）
  - **必须** 不可预测（使用 CSPRNG）
  - 长度 **必须** ≥ 32 字符（256 bits）

### AUTH-14 会话存储

**Level**: MUST

- 会话令牌 **必须** 存储在 HttpOnly Cookie 中（防止 XSS）
- 会话令牌 Cookie **必须** 设置 Secure 标志（仅 HTTPS）
- 会话令牌 Cookie **应该** 设置 SameSite 属性（防止 CSRF）
- 会话令牌 **不得** 在 URL 参数中传输

### AUTH-15 会话生命周期

**Level**: MUST

- 会话 **必须** 设置过期时间：
  - 空闲超时：≤ 30 分钟（无操作）
  - 绝对超时：≤ 8 小时（从登录开始）
- 退出登录：
  - **必须** 立即失效会话
  - **必须** 清除服务器端会话数据
- 密码修改：
  - **必须** 失效所有活跃会话（除当前会话）

### AUTH-16 并发登录策略

**Level**: MAY

- 系统 **可以** 配置：
  - 是否允许多端同时登录
  - 是否支持挤下线策略
  - 最大并发会话数（如 ≤ 5）

### AUTH-17 会话续期

**Level**: SHOULD

- 系统 **应该** 支持会话自动续期（用户有操作时）
- 会话续期 **不得** 延长绝对超时时间
- 会话续期操作 **应该** 记录在审计日志中（可选）

---

## 8. 接口安全（API Authentication）

### AUTH-18 登录接口安全

**Level**: MUST

- 登录接口 **必须**：
  - 使用 HTTPS（TLS 1.2 或更高）
  - 禁止明文凭证传输
  - 禁止在 URL 中传输凭证
  - 禁止在 HTTP Header 中传输凭证（除 Authorization）
- 登录接口 **必须** 实施速率限制：
  - 单 IP 限制：≤ 5 次/分钟
  - 单账号限制：≤ 10 次/小时

### AUTH-19 时序攻击防护

**Level**: MUST

- 系统 **必须** 防止时序攻击
- 登录验证 **必须** 统一响应时间（无论用户是否存在、密码是否正确）
- 密码比较 **必须** 使用常量时间比较函数

---

## 9. 审计与日志（Audit & Logging）

### AUTH-20 登录审计日志

**Level**: MUST

- 登录相关事件 **必须** 记录：
  - 登录成功
  - 登录失败
  - 账号锁定 / 解锁
  - MFA 验证成功 / 失败
  - 会话创建 / 销毁
- 日志字段 **至少** 包含：
  - User ID（若存在）
  - 登录标识（用户名/邮箱/手机）
  - 时间戳（UTC，精确到毫秒）
  - 来源 IP 地址
  - User-Agent
  - 客户端类型（Web/API/Mobile）
  - 操作类型（登录/登出/锁定）
  - 结果状态（成功/失败）
  - 失败原因（如适用）

### AUTH-21 审计日志保留

**Level**: MUST

- 审计日志 **必须** 保留至少 90 天（在线）
- 审计日志 **应该** 保留至少 1 年（归档）
- 审计日志 **必须** 防篡改
- 审计日志 **必须** 支持查询和导出

---

## 10. 错误与异常处理

### AUTH-22 异常一致性

**Level**: MUST

- 所有认证异常：
  - **不得** 返回堆栈信息
  - **不得** 暴露内部逻辑
  - **不得** 泄露系统版本信息
  - **必须** 返回统一的错误格式

### AUTH-23 错误信息规范

**Level**: MUST

- 错误信息 **必须** 用户友好
- 错误信息 **不得** 包含敏感信息（如密码、密钥）
- 错误信息 **应该** 提供足够的调试信息（不影响安全）

---

## 11. 单点登录（SSO）

### AUTH-24 SSO 支持

**Level**: SHOULD

- 系统 **应该** 支持 SSO（单点登录）
- SSO 协议 **应该** 支持：
  - SAML 2.0
  - OAuth 2.0 / OpenID Connect
- SSO 实现详见《SSO Baseline》

---

## 12. 异常检测

### AUTH-25 异常登录检测

**Level**: SHOULD

- 系统 **应该** 检测异常登录行为：
  - 异常地理位置
  - 异常 IP 地址
  - 异常时间（非工作时间）
  - 异常设备
- 检测到异常时 **应该**：
  - 要求额外验证（如 MFA）
  - 发送告警通知
  - 记录安全事件

---

## 13. 合规与引用（Compliance）

### 13.1 外部标准映射

**OWASP ASVS**:
- V2.1 Authentication
- V3.1 Session Management

**NIST**:
- SP 800-63B - Digital Identity Guidelines

**ISO/IEC 27001:2022**:
- A.9.2 User Access Management
- A.9.4 Access Control

**OWASP Top 10**:
- A07:2021 Identification and Authentication Failures

---

## 14. 偏离与豁免（Deviation）

任何偏离本 Baseline 的实现 **必须**：

1. 记录偏离条目（精确到条款编号，如 AUTH-08）
2. 说明偏离原因和背景
3. 进行风险评估（安全、合规、业务）
4. 提供替代方案或补偿措施
5. 由安全负责人审批
6. 记录在偏离管理系统中

详见《Baseline 偏离管理》。

---

## 15. 验收标准（Acceptance）

### AUTH-AC-01 登录失败锁定

- 连续 5 次失败 → 账号锁定
- 锁定期间无法登录
- 锁定 15 分钟后自动解锁
- 解锁后登录成功

### AUTH-AC-02 密码策略

- 密码长度 < 12 字符 → 拒绝
- 密码不符合复杂度要求 → 拒绝
- 密码为弱密码 → 拒绝
- 密码符合要求 → 接受

### AUTH-AC-03 会话管理

- 登录成功 → 生成会话令牌
- 会话令牌存储在 HttpOnly Cookie
- 30 分钟无操作 → 会话过期
- 退出登录 → 会话立即失效

### AUTH-AC-04 审计日志

- 所有登录尝试（成功/失败）→ 记录日志
- 日志包含必需字段
- 日志可查询和导出
- 日志防篡改

---

## 16. 版本记录（Changelog）

### v1.0.0 (2024-01-01)
- Initial Enterprise Baseline
- 涵盖登录认证核心要求
- 支持密码认证、MFA、SSO
- 完整的审计和合规要求

---

## 附录：配置示例

### 登录失败策略配置

```yaml
login_failure_policy:
  max_attempts: 5
  lockout_duration_minutes: 15
  error_message: "用户名或密码错误"
  audit_log: true
  rate_limit:
    per_ip: 5  # 每分钟
    per_account: 10  # 每小时
```

### 密码策略配置

```yaml
password_policy:
  min_length: 12
  require_uppercase: true
  require_lowercase: true
  require_digit: true
  require_special: true
  min_character_types: 3
  history_count: 5
  max_age_days: 90
```

### 会话策略配置

```yaml
session_policy:
  idle_timeout_minutes: 30
  absolute_timeout_hours: 8
  token_length: 32
  http_only: true
  secure: true
  same_site: "Lax"
```
