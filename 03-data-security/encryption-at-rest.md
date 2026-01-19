# 静态数据加密 Baseline

## 概述

本文档定义了 B 端产品静态数据（数据存储）加密的标准要求。

## 加密范围

**Level: MUST**

**Requirements:**
- 以下数据 MUST 加密存储：
  - 密码（使用加盐哈希，非加密）
  - 个人身份信息（PII）
  - 财务数据
  - 密钥和证书
  - 敏感配置信息
  - 分类为"机密"或"绝密"的数据
- 加密范围 SHOULD 根据数据分类确定

## 加密算法

**Level: MUST**

**Requirements:**
- 加密算法 MUST 使用业界标准算法
- 对称加密推荐算法：
  - AES-256（推荐）
  - AES-128（最低要求）
- 非对称加密推荐算法：
  - RSA-2048（最低要求）
  - RSA-4096（推荐）
  - ECC-256（推荐，性能更好）
- 禁止使用弱加密算法（如 DES、RC4、MD5）

## 加密密钥管理

**Level: MUST**

**Requirements:**
- 加密密钥 MUST 使用密钥管理服务（KMS）管理
- 加密密钥 MUST 不能硬编码在代码中
- 加密密钥 MUST 不能存储在代码仓库中
- 加密密钥 MUST 定期轮换（至少每年一次）
- 加密密钥 MUST 安全存储（加密存储）

### 密钥生成

**Level: MUST**

**Requirements:**
- 密钥生成 MUST 使用加密安全的随机数生成器（CSPRNG）
- 密钥长度 MUST 符合算法要求：
  - AES-256: 256 bits
  - RSA-2048: 2048 bits
  - ECC-256: 256 bits

### 密钥存储

**Level: MUST**

**Requirements:**
- 主密钥（Master Key）MUST 存储在密钥管理服务中
- 数据加密密钥（DEK）MUST 使用主密钥加密后存储
- 密钥存储 MUST 访问控制（仅授权服务可访问）
- 密钥存储 MUST 备份（安全备份）

### 密钥轮换

**Level: MUST**

**Requirements:**
- 加密密钥 MUST 定期轮换（至少每年一次）
- 密钥轮换 SHOULD 支持在线轮换（不中断服务）
- 密钥轮换后，旧密钥 SHOULD 保留一段时间（用于解密旧数据）
- 密钥轮换操作 MUST 记录在审计日志中

## 数据库加密

**Level: MUST**

**Requirements:**
- 数据库 SHOULD 支持透明数据加密（TDE）
- 数据库加密 SHOULD 在以下层面实施：
  - 表级加密（敏感表）
  - 列级加密（敏感列）
  - 全库加密（推荐）
- 数据库备份 MUST 加密

### 数据库加密实现

**Level: SHOULD**

**Requirements:**
- 数据库加密 SHOULD 使用数据库原生加密功能
- 如使用应用层加密，MUST 考虑性能影响
- 数据库加密密钥 MUST 独立管理（与数据库管理员分离）

## 文件存储加密

**Level: MUST**

**Requirements:**
- 文件存储 MUST 加密（如对象存储、文件系统）
- 文件加密 SHOULD 使用服务端加密（SSE）
- 文件加密密钥 MUST 使用密钥管理服务
- 文件备份 MUST 加密

## 备份加密

**Level: MUST**

**Requirements:**
- 所有备份数据 MUST 加密
- 备份加密密钥 MUST 独立管理
- 备份恢复时 MUST 验证加密完整性

## 加密性能

**Level: SHOULD**

**Requirements:**
- 加密实现 SHOULD 考虑性能影响
- 加密操作 SHOULD 使用硬件加速（如适用）
- 加密操作 SHOULD 异步处理（如适用，不影响用户体验）

## 加密审计

**Level: MUST**

**Requirements:**
- 加密相关操作 MUST 记录在审计日志中：
  - 密钥生成
  - 密钥轮换
  - 加密/解密操作（如适用）
- 审计日志 MUST 包含密钥标识（非密钥本身）

## 加密合规

**Level: MUST**

**Requirements:**
- 加密实现 MUST 符合相关法律法规要求：
  - GDPR（如适用）
  - 等保要求（如适用）
  - 行业标准（如 PCI-DSS）
- 加密实现 SHOULD 通过安全审计

## 加密测试

**Level: SHOULD**

**Requirements:**
- 加密实现 SHOULD 进行安全测试：
  - 加密强度测试
  - 密钥管理测试
  - 性能测试
- 测试结果 SHOULD 记录

## References

- NIST SP 800-57 - Key Management Guidelines
- OWASP Cryptographic Storage Cheat Sheet
- PCI-DSS Requirement 3.4 - Render PAN unreadable
- ISO/IEC 27001:2022 - A.10.1 Cryptographic Controls
