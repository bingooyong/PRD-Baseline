# 传输中数据加密 Baseline

## 概述

本文档定义了 B 端产品数据传输加密的标准要求，确保数据在传输过程中的安全性。

## HTTPS 要求

**Level: MUST**

**Requirements:**
- 所有 Web 通信 MUST 使用 HTTPS
- HTTPS MUST 使用 TLS 1.2 或更高版本（推荐 TLS 1.3）
- HTTPS 连接 MUST 验证服务器证书
- HTTPS 证书 MUST 有效且未过期
- HTTPS 证书 MUST 来自受信任的 CA

### TLS 配置

**Level: MUST**

**Requirements:**
- TLS 配置 MUST 禁用弱加密套件
- TLS 配置 MUST 禁用不安全的协议版本（SSL 2.0/3.0, TLS 1.0/1.1）
- TLS 配置 SHOULD 使用前向保密（Perfect Forward Secrecy）
- TLS 配置 SHOULD 使用强加密套件（如 AES-256-GCM）

## API 通信加密

**Level: MUST**

**Requirements:**
- 所有 API 通信 MUST 使用 HTTPS
- API 通信 MUST 验证 TLS 证书
- API 通信 SHOULD 使用客户端证书认证（如适用）
- API 通信 SHOULD 使用 API 密钥或 OAuth 2.0 认证

## 数据库连接加密

**Level: MUST**

**Requirements:**
- 数据库连接 MUST 使用加密连接（如 SSL/TLS）
- 数据库连接加密 MUST 验证服务器证书
- 数据库连接 SHOULD 使用客户端证书认证（如适用）

## 内部服务通信加密

**Level: SHOULD**

**Requirements:**
- 内部服务通信 SHOULD 使用加密（如 mTLS）
- 内部服务通信加密 SHOULD 使用服务网格（如 Istio）
- 内部服务通信 SHOULD 验证服务身份

## 文件传输加密

**Level: MUST**

**Requirements:**
- 文件传输 MUST 使用加密协议（如 SFTP、HTTPS）
- 文件传输 MUST 验证服务器身份
- 大文件传输 SHOULD 使用分块加密（如适用）

## 邮件传输加密

**Level: SHOULD**

**Requirements:**
- 邮件传输 SHOULD 使用 TLS/SSL
- 敏感邮件 SHOULD 使用端到端加密（如 PGP）
- 邮件服务器 SHOULD 支持 STARTTLS

## 移动应用通信加密

**Level: MUST**

**Requirements:**
- 移动应用通信 MUST 使用 HTTPS
- 移动应用通信 MUST 实施证书绑定（Certificate Pinning）
- 移动应用通信 MUST 验证服务器证书

## 证书管理

**Level: MUST**

**Requirements:**
- TLS 证书 MUST 有效且未过期
- TLS 证书 SHOULD 自动续期（如使用 Let's Encrypt）
- TLS 证书过期前 SHOULD 提前告警（至少 30 天）
- TLS 证书 MUST 安全存储
- TLS 证书私钥 MUST 不能泄露

### 证书验证

**Level: MUST**

**Requirements:**
- 客户端 MUST 验证服务器证书
- 证书验证 MUST 检查：
  - 证书有效性
  - 证书链完整性
  - 证书域名匹配
  - 证书未过期
  - 证书未被撤销

## 协议版本要求

**Level: MUST**

**Requirements:**
- 系统 MUST 支持 TLS 1.2 或更高版本
- 系统 SHOULD 支持 TLS 1.3（推荐）
- 系统 MUST 禁用以下协议：
  - SSL 2.0
  - SSL 3.0
  - TLS 1.0
  - TLS 1.1（如适用）

## 加密强度要求

**Level: MUST**

**Requirements:**
- 加密算法 MUST 使用强加密：
  - 对称加密：AES-128（最低），AES-256（推荐）
  - 非对称加密：RSA-2048（最低），RSA-4096 或 ECC-256（推荐）
  - 哈希算法：SHA-256（最低），SHA-384 或 SHA-512（推荐）

## 前向保密

**Level: SHOULD**

**Requirements:**
- TLS 配置 SHOULD 支持前向保密（Perfect Forward Secrecy）
- 前向保密 SHOULD 使用 ECDHE 或 DHE 密钥交换
- 前向保密配置 SHOULD 优先使用 ECDHE（性能更好）

## 传输加密审计

**Level: SHOULD**

**Requirements:**
- 传输加密相关事件 SHOULD 记录在审计日志中：
  - TLS 握手失败
  - 证书验证失败
  - 协议版本不匹配
- 审计日志 SHOULD 不包含敏感数据（如密钥、证书私钥）

## 传输加密测试

**Level: SHOULD**

**Requirements:**
- 传输加密 SHOULD 定期测试：
  - TLS 配置测试（如 SSL Labs）
  - 证书有效性测试
  - 协议版本测试
- 测试结果 SHOULD 记录和跟踪

## 合规要求

**Level: MUST**

**Requirements:**
- 传输加密 MUST 符合相关法律法规要求：
  - GDPR（如适用）
  - 等保要求（如适用）
  - 行业标准（如 PCI-DSS）
- 传输加密 SHOULD 通过安全审计

## References

- OWASP Transport Layer Protection Cheat Sheet
- NIST SP 800-52 - Guidelines for the Selection and Use of TLS
- PCI-DSS Requirement 4.1 - Use strong cryptography
- TLS 1.3 RFC 8446
