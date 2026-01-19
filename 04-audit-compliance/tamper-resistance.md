# 防篡改 Baseline

## 概述

本文档定义了 B 端产品防篡改的标准要求，确保审计日志和关键数据的完整性。

## 防篡改范围

**Level: MUST**

**Requirements:**
- 以下数据 MUST 防篡改：
  - 审计日志
  - 操作记录
  - 配置变更历史
  - 权限变更记录
  - 安全事件记录
- 防篡改范围 SHOULD 根据业务需求扩展

## 防篡改措施

**Level: MUST**

**Requirements:**
- 防篡改措施 MUST 包括：
  - **只追加存储**: 禁止修改和删除
  - **访问控制**: 仅授权用户可访问
  - **完整性校验**: 使用哈希值或数字签名
  - **加密存储**: 防止未授权访问
- 防篡改措施 SHOULD 多层防护

## 只追加存储

**Level: MUST**

**Requirements:**
- 审计日志和关键数据 MUST 只追加存储（Append-only）
- 只追加存储 MUST 禁止：
  - 修改已有记录
  - 删除已有记录
  - 插入历史记录
- 只追加存储 SHOULD 在存储层面强制执行（如使用 WORM 存储）

## 完整性校验

**Level: MUST**

**Requirements:**
- 审计日志和关键数据 MUST 完整性校验
- 完整性校验 SHOULD 使用：
  - **哈希值**: SHA-256 或更高
  - **数字签名**: RSA-2048 或更高
  - **区块链**: 如适用（高级场景）
- 完整性校验 SHOULD 定期执行（如每天）

### 哈希链

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 使用哈希链（Hash Chain）确保日志完整性
- 哈希链 SHOULD 包括：
  - 每条记录的哈希值
  - 前一条记录的哈希值（形成链）
  - 链的根哈希值（定期计算）
- 哈希链 SHOULD 定期验证

## 数字签名

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 使用数字签名确保数据完整性
- 数字签名 SHOULD 使用：
  - RSA-2048 或更高
  - ECC-256 或更高
- 数字签名私钥 MUST 安全存储（如 HSM）
- 数字签名验证 SHOULD 自动化

## 访问控制

**Level: MUST**

**Requirements:**
- 审计日志和关键数据访问 MUST 严格控制
- 访问控制 SHOULD 基于角色（如审计员、合规员）
- 访问控制 SHOULD 支持：
  - 只读访问（大多数用户）
  - 写入访问（仅系统服务）
  - 无访问（禁止修改/删除）
- 访问控制操作 MUST 记录在审计日志中

## 加密存储

**Level: MUST**

**Requirements:**
- 审计日志和关键数据存储 MUST 加密
- 加密存储 SHOULD 使用：
  - AES-256（对称加密）
  - 密钥管理服务（KMS）
- 加密密钥 MUST 安全管理

## 防篡改检测

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 实时检测篡改尝试
- 篡改检测 SHOULD 包括：
  - 完整性校验失败
  - 异常访问尝试
  - 异常修改尝试
- 检测到篡改尝试时 MUST 立即告警
- 检测到篡改尝试时 MUST 记录安全事件

## 防篡改审计

**Level: MUST**

**Requirements:**
- 防篡改相关操作 MUST 记录在审计日志中：
  - 完整性校验
  - 篡改检测
  - 访问控制变更
- 审计日志 MUST 防篡改（元审计）

## 防篡改合规

**Level: MUST**

**Requirements:**
- 防篡改实现 MUST 符合相关法律法规要求：
  - 等保要求（如适用）
  - 行业标准（如 SOX、PCI-DSS）
- 防篡改实现 SHOULD 通过安全审计

## References

- ISO/IEC 27001:2022 - A.12.4 Logging and Monitoring
- NIST SP 800-57 - Key Management Guidelines
- OWASP Logging Cheat Sheet
- Blockchain for Audit Trail
