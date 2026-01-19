# 密钥管理 Baseline

## 概述

本文档定义了 B 端产品密钥管理的标准要求，确保加密密钥的安全生成、存储、使用和销毁。

## 密钥管理服务（KMS）

**Level: MUST**

**Requirements:**
- 系统 MUST 使用密钥管理服务（KMS）管理密钥
- KMS SHOULD 使用业界标准方案（如 AWS KMS、Azure Key Vault、HashiCorp Vault）
- KMS MUST 支持密钥的完整生命周期管理
- KMS MUST 提供密钥访问控制

## 密钥类型

**Level: MUST**

**Requirements:**
- 系统 MUST 区分以下密钥类型：
  - **主密钥 (Master Key)**: 用于加密数据加密密钥
  - **数据加密密钥 (DEK)**: 用于加密实际数据
  - **密钥加密密钥 (KEK)**: 用于加密其他密钥
  - **签名密钥**: 用于数字签名
  - **认证密钥**: 用于身份认证

## 密钥生成

**Level: MUST**

**Requirements:**
- 密钥生成 MUST 使用加密安全的随机数生成器（CSPRNG）
- 密钥生成 MUST 使用 KMS 或硬件安全模块（HSM）
- 密钥生成 MUST 不能使用弱随机数生成器
- 密钥长度 MUST 符合算法要求：
  - AES: 128/192/256 bits
  - RSA: >= 2048 bits
  - ECC: >= 256 bits

### 密钥生成安全

**Level: MUST**

**Requirements:**
- 密钥生成过程 MUST 在安全环境中执行
- 密钥生成 MUST 不能泄露密钥材料
- 密钥生成操作 MUST 记录在审计日志中

## 密钥存储

**Level: MUST**

**Requirements:**
- 密钥 MUST 存储在 KMS 或 HSM 中
- 密钥 MUST 不能存储在以下位置：
  - 代码仓库
  - 配置文件（明文）
  - 环境变量（明文）
  - 日志文件
- 密钥存储 MUST 加密（主密钥除外）
- 密钥存储 MUST 访问控制

### 密钥存储备份

**Level: MUST**

**Requirements:**
- 密钥 MUST 安全备份
- 密钥备份 MUST 加密
- 密钥备份 MUST 存储在安全位置
- 密钥备份访问 MUST 严格控制

## 密钥分发

**Level: MUST**

**Requirements:**
- 密钥分发 MUST 使用安全通道（如 TLS）
- 密钥分发 MUST 验证接收方身份
- 密钥分发操作 MUST 记录在审计日志中
- 密钥分发 SHOULD 使用密钥包装（Key Wrapping）

## 密钥使用

**Level: MUST**

**Requirements:**
- 密钥使用 MUST 通过 KMS API
- 密钥使用 MUST 记录在审计日志中
- 密钥使用 MUST 不能泄露密钥材料
- 密钥使用 SHOULD 限制使用范围

## 密钥轮换

**Level: MUST**

**Requirements:**
- 加密密钥 MUST 定期轮换（至少每年一次）
- 密钥轮换 SHOULD 支持在线轮换（不中断服务）
- 密钥轮换后，旧密钥 SHOULD 保留一段时间（用于解密旧数据）
- 密钥轮换操作 MUST 记录在审计日志中

### 密钥轮换策略

**Level: SHOULD**

**Requirements:**
- 密钥轮换策略 SHOULD 基于：
  - 密钥类型
  - 使用频率
  - 安全要求
- 密钥轮换策略 SHOULD 可配置
- 密钥轮换 SHOULD 自动化

## 密钥撤销

**Level: MUST**

**Requirements:**
- 系统 MUST 支持密钥撤销
- 密钥撤销场景：
  - 密钥泄露
  - 密钥过期
  - 安全事件
- 密钥撤销后 MUST 立即生效
- 密钥撤销操作 MUST 记录在审计日志中

## 密钥销毁

**Level: MUST**

**Requirements:**
- 密钥销毁 MUST 安全执行（确保密钥材料完全清除）
- 密钥销毁前 MUST 确认不再需要
- 密钥销毁操作 MUST 记录在审计日志中
- 密钥销毁后 MUST 不能恢复

## 密钥访问控制

**Level: MUST**

**Requirements:**
- 密钥访问 MUST 基于最小权限原则
- 密钥访问 MUST 身份认证和授权
- 密钥访问 SHOULD 支持基于角色的访问控制（RBAC）
- 密钥访问操作 MUST 记录在审计日志中

## 密钥审计

**Level: MUST**

**Requirements:**
- 所有密钥操作 MUST 记录在审计日志中：
  - 密钥生成
  - 密钥存储
  - 密钥使用
  - 密钥轮换
  - 密钥撤销
  - 密钥销毁
- 审计日志 MUST 包含：
  - 操作人
  - 操作时间
  - 操作类型
  - 密钥标识（非密钥本身）
  - 操作结果

## 密钥合规

**Level: MUST**

**Requirements:**
- 密钥管理 MUST 符合相关法律法规要求：
  - 等保要求（如适用）
  - 行业标准（如 PCI-DSS）
- 密钥管理 SHOULD 通过安全审计

## 硬件安全模块（HSM）

**Level: SHOULD**

**Requirements:**
- 高安全要求场景 SHOULD 使用 HSM
- HSM SHOULD 用于：
  - 主密钥存储
  - 密钥生成
  - 密钥操作（加密/解密/签名）
- HSM 配置 MUST 安全（访问控制、审计）

## 密钥管理最佳实践

**Level: SHOULD**

**Requirements:**
- 密钥管理 SHOULD 遵循以下最佳实践：
  - 密钥分离（不同用途使用不同密钥）
  - 密钥最小化（仅授予必要的密钥访问权限）
  - 密钥监控（实时监控密钥使用）
  - 密钥备份（安全备份密钥）

## References

- NIST SP 800-57 - Key Management Guidelines
- NIST SP 800-130 - A Framework for Designing Cryptographic Key Management Systems
- OWASP Key Management Cheat Sheet
- PCI-DSS Requirement 3.5 - Protect cryptographic keys
