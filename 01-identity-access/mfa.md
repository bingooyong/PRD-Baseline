# 多因素认证（MFA）Baseline

## 概述

本文档定义了 B 端产品多因素认证（MFA）功能的标准要求，增强账户安全性。

## MFA 支持要求

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持多因素认证
- 对于管理员账户和高权限账户，MFA SHOULD 为强制要求
- 系统 SHOULD 支持多种 MFA 方式，用户可选择

## MFA 方式

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持以下 MFA 方式（至少一种）：
  - **TOTP**（基于时间的一次性密码，如 Google Authenticator）
  - **短信验证码**（SMS）
  - **邮件验证码**（Email）
  - **硬件密钥**（FIDO2/WebAuthn）
  - **推送通知**（Push Notification）

### TOTP 要求

**Level: SHOULD**

**Requirements:**
- TOTP 密钥长度 MUST >= 160 bits
- TOTP 时间窗口 MUST 为 30 秒
- TOTP 验证码长度 SHOULD 为 6 位数字
- TOTP 密钥 MUST 在设置时以 QR 码形式展示
- TOTP 密钥 MUST 允许手动输入（备用恢复码）
- 系统 SHOULD 支持备用恢复码（至少 10 个）

### 短信验证码要求

**Level: SHOULD**

**Requirements:**
- 短信验证码长度 MUST >= 6 位数字
- 短信验证码有效期 MUST <= 5 分钟
- 短信验证码 MUST 只能使用一次
- 短信发送 MUST 实施速率限制（防止滥用）
- 短信内容 MUST 不包含敏感信息（仅验证码）

### 邮件验证码要求

**Level: SHOULD**

**Requirements:**
- 邮件验证码长度 MUST >= 6 位数字或字母
- 邮件验证码有效期 MUST <= 15 分钟
- 邮件验证码 MUST 只能使用一次
- 邮件发送 MUST 实施速率限制

### 硬件密钥要求（FIDO2/WebAuthn）

**Level: MAY**

**Requirements:**
- 系统 MAY 支持 FIDO2/WebAuthn 标准
- 硬件密钥注册 MUST 要求用户验证（如 PIN、生物识别）
- 硬件密钥认证 MUST 验证签名

## MFA 启用流程

**Level: MUST**

**Requirements:**
- 用户 MUST 能够自主启用 MFA
- 启用 MFA 时 MUST 验证用户身份（如输入密码）
- 启用 MFA 时 MUST 要求用户完成至少一次验证测试
- MFA 启用操作 MUST 记录在审计日志中

## MFA 认证流程

**Level: MUST**

**Requirements:**
- 当用户启用 MFA 后，登录流程 MUST 要求验证第二因素
- 第二因素验证失败处理：
  - 连续失败 3 次后锁定 MFA 验证 15 分钟
  - 错误信息 MUST 不泄露 MFA 方式或账户信息
- MFA 验证失败 MUST 记录在审计日志中

## MFA 会话管理

**Level: MUST**

**Requirements:**
- MFA 验证成功后，会话令牌 MUST 标记为"已通过 MFA"
- 系统 SHOULD 支持"信任设备"功能（30 天内免 MFA）
- 信任设备功能 SHOULD 可配置（管理员可禁用）
- 信任设备列表 MUST 用户可见可管理

## MFA 恢复

**Level: MUST**

**Requirements:**
- 系统 MUST 提供 MFA 恢复机制（用户丢失设备时）
- MFA 恢复方式：
  - 备用恢复码
  - 管理员协助重置
  - 已验证的备用邮箱/手机号
- MFA 恢复操作 MUST 经过严格身份验证
- MFA 恢复操作 MUST 记录在审计日志中

## MFA 禁用

**Level: MUST**

**Requirements:**
- 用户 SHOULD 能够自主禁用 MFA（如适用）
- 禁用 MFA 时 MUST 验证用户身份（密码 + 当前 MFA）
- 禁用 MFA 操作 MUST 记录在审计日志中
- 禁用 MFA 后 SHOULD 发送通知邮件

## 强制 MFA 策略

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持按用户组强制启用 MFA
- 强制 MFA 的用户组：
  - 管理员账户
  - 财务相关账户
  - 高权限操作账户
- 强制 MFA 的用户 MUST 在首次登录时设置 MFA
- 强制 MFA 的用户 MUST 不能禁用 MFA

## MFA 审计

**Level: MUST**

**Requirements:**
- 所有 MFA 相关操作 MUST 记录在审计日志中：
  - MFA 启用/禁用
  - MFA 验证成功/失败
  - MFA 恢复操作
  - MFA 方式变更
- 审计日志 MUST 包含：
  - 用户标识
  - 操作时间
  - IP 地址
  - MFA 方式
  - 操作结果

## 安全要求

**Level: MUST**

**Requirements:**
- MFA 验证接口 MUST 使用 HTTPS
- MFA 验证接口 MUST 实施速率限制
- MFA 令牌/验证码 MUST 使用加密随机值生成
- MFA 相关数据 MUST 加密存储
- 系统 MUST 防止 MFA 验证码重放攻击

## 异常检测

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 检测异常 MFA 行为：
  - 频繁的 MFA 验证失败
  - 异常地理位置的 MFA 请求
  - 异常时间的 MFA 请求
- 检测到异常时 SHOULD 要求额外验证或发送告警

## References

- NIST SP 800-63B - Authenticator Requirements
- OWASP ASVS V2.1 - Multi-Factor Authentication
- FIDO2 / WebAuthn Specification
- RFC 6238 - TOTP: Time-Based One-Time Password Algorithm
