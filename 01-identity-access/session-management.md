# 会话管理 Baseline

## 概述

本文档定义了 B 端产品会话管理的标准要求，确保会话安全性和用户体验。

## 会话令牌生成

**Level: MUST**

**Requirements:**
- 会话令牌 MUST 使用加密安全的随机数生成器（CSPRNG）
- 会话令牌长度 MUST >= 32 字符（256 bits）
- 会话令牌 MUST 全局唯一
- 会话令牌 MUST 不可预测
- 会话令牌生成算法 MUST 使用业界标准（如 UUID v4、JWT with secure random）

## 会话令牌存储

**Level: MUST**

**Requirements:**
- 会话令牌 MUST 存储在 HttpOnly Cookie 中（防止 XSS）
- 会话令牌 Cookie MUST 设置 Secure 标志（仅 HTTPS）
- 会话令牌 Cookie SHOULD 设置 SameSite 属性（防止 CSRF）
  - 推荐值：Strict 或 Lax
- 会话令牌 MUST 不在 URL 参数中传输
- 会话令牌 MUST 不在客户端 JavaScript 中可访问（HttpOnly）

## 会话超时

**Level: MUST**

**Requirements:**
- 会话绝对超时时间（从登录开始）MUST <= 8 小时
- 会话空闲超时时间（无操作）MUST <= 30 分钟
- 会话超时时间 SHOULD 可配置（按用户组/租户）
- 会话即将超时前 SHOULD 提示用户（提前 5 分钟）
- 会话超时后 MUST 要求用户重新登录

## 会话续期

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持会话自动续期（用户有操作时）
- 会话续期 MUST 不延长绝对超时时间
- 会话续期操作 SHOULD 记录在审计日志中（可选）

## 会话失效

**Level: MUST**

**Requirements:**
- 用户主动登出时，会话令牌 MUST 立即失效
- 会话失效后 MUST 清除服务器端会话数据
- 会话失效后 MUST 清除客户端 Cookie
- 密码修改后 SHOULD 使所有其他会话失效（可选，建议启用）
- 账户锁定后 MUST 使所有会话立即失效
- 账户删除后 MUST 使所有会话立即失效

## 并发会话管理

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持限制同一账户的并发会话数
- 默认并发会话数 SHOULD <= 5
- 超出并发限制时，系统 SHOULD 终止最旧的会话
- 并发会话限制 SHOULD 可配置（按用户组）

## 会话固定攻击防护

**Level: MUST**

**Requirements:**
- 系统 MUST 在用户成功登录后重新生成会话令牌
- 系统 MUST 在用户权限提升后重新生成会话令牌
- 系统 MUST 防止会话令牌被预测或固定

## 会话劫持防护

**Level: MUST**

**Requirements:**
- 会话令牌 MUST 通过 HTTPS 传输
- 会话令牌 MUST 使用 HttpOnly Cookie（防止 XSS 窃取）
- 系统 SHOULD 绑定会话到 IP 地址（可选，可能影响用户体验）
- 系统 SHOULD 检测异常会话行为（地理位置、设备变更）

## 会话状态管理

**Level: MUST**

**Requirements:**
- 会话状态 MUST 存储在服务器端（推荐）或加密的客户端令牌中
- 服务器端会话存储 MUST 支持分布式（如 Redis Cluster）
- 会话数据 MUST 包含：
  - 用户标识
  - 登录时间
  - 最后活动时间
  - IP 地址（可选）
  - User-Agent（可选）
- 会话数据 SHOULD 不包含敏感信息（如密码）

## 会话审计

**Level: MUST**

**Requirements:**
- 会话创建（登录）MUST 记录在审计日志中
- 会话销毁（登出/超时）MUST 记录在审计日志中
- 会话异常终止（如并发限制）MUST 记录在审计日志中
- 审计日志 MUST 包含：
  - 用户标识
  - 会话令牌（哈希值，非明文）
  - 操作时间
  - IP 地址
  - 操作类型（创建/销毁/异常）

## 跨域会话管理

**Level: SHOULD**

**Requirements:**
- 跨域场景下，系统 SHOULD 使用 OAuth 2.0 / OpenID Connect
- 跨域会话令牌传输 MUST 使用安全的 CORS 策略
- 跨域会话令牌 MUST 遵循 SameSite Cookie 策略

## 移动端会话管理

**Level: SHOULD**

**Requirements:**
- 移动端应用 SHOULD 使用长期令牌（Refresh Token）+ 短期令牌（Access Token）
- Refresh Token 有效期 SHOULD <= 30 天
- Access Token 有效期 SHOULD <= 1 小时
- Refresh Token 轮换 SHOULD 支持（每次刷新时生成新的 Refresh Token）

## 会话监控

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 提供会话监控功能（管理员）
- 会话监控信息 SHOULD 包括：
  - 活跃会话数
  - 会话分布（按用户、IP、设备）
  - 异常会话告警
- 管理员 SHOULD 能够强制终止指定会话

## References

- OWASP ASVS V2.1 - Session Management
- OWASP Session Management Cheat Sheet
- RFC 6265 - HTTP State Management Mechanism (Cookies)
- NIST SP 800-63B - Session Management
