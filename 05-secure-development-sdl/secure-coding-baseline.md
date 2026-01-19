# 安全编码 Baseline

## 概述

本文档定义了 B 端产品安全编码的标准要求，确保代码实现的安全性。

## 输入验证

**Level: MUST**

**Requirements:**
- 所有用户输入 MUST 验证
- 输入验证 MUST 包括：
  - 类型验证
  - 长度验证
  - 格式验证
  - 范围验证
- 输入验证 MUST 在服务端执行（不能仅依赖前端）

## 输出编码

**Level: MUST**

**Requirements:**
- 所有输出到用户的数据 MUST 编码
- 输出编码 MUST 防止 XSS 攻击
- 输出编码 SHOULD 使用框架提供的编码函数

## 身份认证

**Level: MUST**

**Requirements:**
- 身份认证 MUST 使用标准协议（如 OAuth 2.0、SAML）
- 密码存储 MUST 使用加盐哈希（如 bcrypt、Argon2）
- 会话管理 MUST 使用安全的会话令牌
- 身份认证失败 MUST 不泄露账户信息

## 授权

**Level: MUST**

**Requirements:**
- 所有受保护的操作 MUST 进行授权检查
- 授权检查 MUST 在服务端执行
- 授权检查 MUST 基于最小权限原则

## 加密

**Level: MUST**

**Requirements:**
- 敏感数据 MUST 加密存储
- 数据传输 MUST 使用 HTTPS/TLS
- 加密算法 MUST 使用业界标准（如 AES-256、RSA-2048）
- 加密密钥 MUST 使用密钥管理服务

## 错误处理

**Level: MUST**

**Requirements:**
- 错误信息 MUST 不泄露系统内部信息
- 错误信息 MUST 不包含敏感数据（如密码、密钥）
- 错误处理 MUST 记录详细日志（服务端）

## 日志记录

**Level: MUST**

**Requirements:**
- 关键操作 MUST 记录日志
- 日志记录 MUST 不包含敏感信息
- 日志记录 MUST 使用结构化格式

## 依赖管理

**Level: MUST**

**Requirements:**
- 依赖库 MUST 来自可信源
- 依赖库 MUST 定期更新
- 依赖库 MUST 扫描已知漏洞

## 代码审查

**Level: MUST**

**Requirements:**
- 所有代码变更 MUST 经过代码审查
- 代码审查 MUST 检查安全漏洞
- 代码审查结果 MUST 记录

## References

- OWASP Secure Coding Practices
- CWE Top 25 Most Dangerous Software Weaknesses
- OWASP ASVS - Application Security Verification Standard
- NIST Secure Software Development Framework
