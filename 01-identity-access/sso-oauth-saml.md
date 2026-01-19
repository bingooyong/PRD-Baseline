# 单点登录（SSO）Baseline

## 概述

本文档定义了 B 端产品单点登录（SSO）功能的标准要求，支持 OAuth 2.0、OpenID Connect 和 SAML 2.0 协议。

## SSO 协议支持

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持 OAuth 2.0 / OpenID Connect
- 系统 SHOULD 支持 SAML 2.0
- 系统 SHOULD 支持至少一种 SSO 协议
- 协议选择 SHOULD 根据企业客户需求确定

## OAuth 2.0 / OpenID Connect

### 基本要求

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持 OAuth 2.0 Authorization Code Flow（推荐）
- 系统 SHOULD 支持 PKCE（Proof Key for Code Exchange）
- 系统 SHOULD 支持 OpenID Connect 进行用户身份识别
- 系统 MUST 验证客户端身份（Client ID + Client Secret）

### 授权码流程

**Level: MUST**

**Requirements:**
- 授权码 MUST 只能使用一次
- 授权码有效期 MUST <= 10 分钟
- 授权码 MUST 与客户端绑定（验证 redirect_uri）
- 授权码交换 Access Token 时 MUST 验证 Client Secret
- Access Token 有效期 SHOULD <= 1 小时

### Token 管理

**Level: MUST**

**Requirements:**
- Access Token MUST 使用 JWT 格式（推荐）或随机令牌
- Access Token MUST 包含过期时间（exp）
- Access Token MUST 签名验证（如使用 JWT）
- Refresh Token SHOULD 支持（用于长期会话）
- Refresh Token 有效期 SHOULD <= 30 天
- Refresh Token 轮换 SHOULD 支持（每次刷新生成新 Token）

### 安全要求

**Level: MUST**

**Requirements:**
- OAuth 端点 MUST 使用 HTTPS
- redirect_uri MUST 白名单验证
- 授权请求 MUST 验证 state 参数（防止 CSRF）
- Token 传输 MUST 使用 POST 方法
- Token 存储 MUST 安全（HttpOnly Cookie 或安全存储）

## SAML 2.0

### 基本要求

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持 SAML 2.0 Web SSO Profile
- 系统 SHOULD 支持 SP（Service Provider）和 IdP（Identity Provider）角色
- 系统 SHOULD 支持 SAML 断言签名验证
- 系统 SHOULD 支持 SAML 响应加密（可选）

### SAML 断言验证

**Level: MUST**

**Requirements:**
- SAML 断言 MUST 验证签名（使用 IdP 公钥）
- SAML 断言 MUST 验证时效性：
  - NotBefore: 当前时间 >= NotBefore
  - NotOnOrAfter: 当前时间 < NotOnOrAfter
- SAML 断言时效窗口 SHOULD <= 5 分钟
- SAML 断言 MUST 验证 Audience（目标服务）
- SAML 断言 MUST 防止重放攻击（检查 InResponseTo 和 Response ID）

### SAML 请求/响应

**Level: MUST**

**Requirements:**
- SAML 请求 MUST 包含唯一 RequestID
- SAML 请求 MUST 签名（如配置）
- SAML 响应 MUST 包含对应 RequestID（InResponseTo）
- SAML 响应 MUST 签名
- SAML 绑定 SHOULD 使用 HTTP POST（推荐）或 HTTP Redirect

### 属性映射

**Level: MUST**

**Requirements:**
- 系统 MUST 支持 SAML 属性到本地用户属性的映射
- 必需属性映射：
  - NameID / Email → 用户标识
  - DisplayName → 显示名称
- 可选属性映射：
  - Department → 部门
  - Role → 角色
- 属性映射配置 MUST 可配置

## SSO 配置管理

**Level: MUST**

**Requirements:**
- SSO 配置 MUST 支持多租户（不同租户不同 IdP）
- SSO 配置 MUST 包含：
  - IdP 元数据 URL 或文件
  - SP 实体 ID
  - 证书和密钥管理
  - 属性映射规则
- SSO 配置变更 MUST 经过审批
- SSO 配置变更 MUST 记录在审计日志中

## SSO 登录流程

**Level: MUST**

**Requirements:**
- SSO 登录失败 MUST 提供清晰的错误信息
- SSO 登录失败 MUST 记录在审计日志中
- SSO 登录成功后 MUST 创建本地会话
- SSO 登录成功后 MUST 应用本地权限策略
- SSO 登录 SHOULD 支持"首次登录自动创建账户"（如配置）

## SSO 登出

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持单点登出（SLO）
- SAML SLO MUST 支持 LogoutRequest 和 LogoutResponse
- OAuth 登出 SHOULD 撤销 Access Token 和 Refresh Token
- 登出后 MUST 清除本地会话
- 登出操作 MUST 记录在审计日志中

## SSO 安全要求

**Level: MUST**

**Requirements:**
- SSO 通信 MUST 使用 HTTPS
- SSO 证书 MUST 有效且未过期
- SSO 证书 SHOULD 定期轮换（如每年）
- SSO 密钥 MUST 安全存储（密钥管理服务）
- SSO 配置 MUST 加密存储

## SSO 异常处理

**Level: MUST**

**Requirements:**
- SSO 失败时 MUST 提供降级方案（如本地登录）
- SSO 超时 MUST 有明确的错误提示
- SSO 断言验证失败 MUST 记录详细日志
- SSO 异常 SHOULD 发送告警（如连续失败）

## SSO 审计

**Level: MUST**

**Requirements:**
- 所有 SSO 操作 MUST 记录在审计日志中：
  - SSO 登录请求
  - SSO 登录成功/失败
  - SSO 登出
  - SSO 配置变更
- 审计日志 MUST 包含：
  - 用户标识（来自 SSO 断言）
  - 操作时间
  - IP 地址
  - SSO 协议类型
  - 操作结果

## 多 IdP 支持

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持配置多个 IdP
- 多 IdP 场景下，用户 SHOULD 能够选择 IdP
- 多 IdP 配置 MUST 相互独立
- 多 IdP 登录 MUST 记录使用的 IdP 信息

## References

- OAuth 2.0 RFC 6749
- OpenID Connect Core 1.0
- SAML 2.0 Technical Overview
- OWASP ASVS V2.1 - Single Sign-On
- NIST SP 800-63C - Federation and Assertions
