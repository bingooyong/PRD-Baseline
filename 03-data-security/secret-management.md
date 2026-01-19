# 密钥和敏感信息管理 Baseline

## 概述

本文档定义了 B 端产品密钥和敏感信息（如 API 密钥、密码、令牌等）管理的标准要求。

## 敏感信息类型

**Level: MUST**

**Requirements:**
- 系统 MUST 识别和管理以下敏感信息：
  - API 密钥
  - 访问令牌（Access Token）
  - 刷新令牌（Refresh Token）
  - 数据库密码
  - 第三方服务凭证
  - 加密密钥
  - 证书私钥
  - 其他敏感配置

## 敏感信息存储

**Level: MUST**

**Requirements:**
- 敏感信息 MUST 存储在密钥管理服务（Secrets Management）中
- 敏感信息 MUST 不能存储在以下位置：
  - 代码仓库（Git）
  - 配置文件（明文）
  - 环境变量（明文，生产环境）
  - 日志文件
  - 注释或文档
- 敏感信息存储 MUST 加密

### 密钥管理服务要求

**Level: MUST**

**Requirements:**
- 密钥管理服务 SHOULD 使用业界标准方案（如 HashiCorp Vault、AWS Secrets Manager）
- 密钥管理服务 MUST 支持：
  - 敏感信息的 CRUD 操作
  - 访问控制
  - 版本管理
  - 审计日志
  - 自动轮换（如适用）

## 敏感信息访问

**Level: MUST**

**Requirements:**
- 敏感信息访问 MUST 通过密钥管理服务 API
- 敏感信息访问 MUST 身份认证和授权
- 敏感信息访问 MUST 基于最小权限原则
- 敏感信息访问操作 MUST 记录在审计日志中

## 敏感信息轮换

**Level: MUST**

**Requirements:**
- 敏感信息 MUST 定期轮换（如 API 密钥、密码）
- 敏感信息轮换周期 SHOULD 基于：
  - 信息类型
  - 安全要求
  - 使用频率
- 敏感信息轮换 SHOULD 自动化
- 敏感信息轮换操作 MUST 记录在审计日志中

### 自动轮换

**Level: SHOULD**

**Requirements:**
- 密钥管理服务 SHOULD 支持自动轮换
- 自动轮换 SHOULD 支持：
  - 定期轮换（如每 90 天）
  - 事件触发轮换（如泄露事件）
  - 手动触发轮换
- 自动轮换 SHOULD 不中断服务

## 敏感信息传输

**Level: MUST**

**Requirements:**
- 敏感信息传输 MUST 使用加密通道（如 HTTPS、TLS）
- 敏感信息传输 MUST 不能通过以下方式：
  - 明文 HTTP
  - 未加密的邮件
  - 未加密的即时消息
- 敏感信息传输 SHOULD 使用密钥包装（Key Wrapping）

## 敏感信息使用

**Level: MUST**

**Requirements:**
- 敏感信息使用 MUST 不能泄露：
  - 不在日志中记录
  - 不在错误信息中返回
  - 不在 URL 参数中传输
  - 不在浏览器历史中保存
- 敏感信息使用 SHOULD 限制使用范围

## 敏感信息扫描

**Level: MUST**

**Requirements:**
- 系统 MUST 定期扫描代码仓库中的敏感信息
- 敏感信息扫描 SHOULD 自动化（如 Git Hooks、CI/CD）
- 扫描到敏感信息时 MUST 立即告警
- 扫描到敏感信息时 MUST 立即移除和轮换

### 扫描工具

**Level: SHOULD**

**Requirements:**
- 敏感信息扫描 SHOULD 使用专业工具（如 GitGuardian、TruffleHog）
- 扫描工具 SHOULD 支持：
  - 多种敏感信息类型
  - 历史提交扫描
  - 实时扫描
  - 误报处理

## 敏感信息泄露响应

**Level: MUST**

**Requirements:**
- 发现敏感信息泄露时 MUST 立即响应：
  - 撤销泄露的敏感信息
  - 生成新的敏感信息
  - 通知相关方
  - 记录安全事件
  - 进行事后分析

## 环境隔离

**Level: MUST**

**Requirements:**
- 不同环境（开发、测试、生产）MUST 使用不同的敏感信息
- 生产环境敏感信息 MUST 不能用于开发/测试环境
- 环境隔离 MUST 强制执行

## 敏感信息审计

**Level: MUST**

**Requirements:**
- 所有敏感信息操作 MUST 记录在审计日志中：
  - 敏感信息创建
  - 敏感信息访问
  - 敏感信息修改
  - 敏感信息轮换
  - 敏感信息删除
- 审计日志 MUST 包含：
  - 操作人
  - 操作时间
  - 操作类型
  - 敏感信息标识（非敏感信息本身）

## 敏感信息合规

**Level: MUST**

**Requirements:**
- 敏感信息管理 MUST 符合相关法律法规要求：
  - 等保要求（如适用）
  - 行业标准（如 PCI-DSS）
- 敏感信息管理 SHOULD 通过安全审计

## 敏感信息最佳实践

**Level: SHOULD**

**Requirements:**
- 敏感信息管理 SHOULD 遵循以下最佳实践：
  - 最小化敏感信息（仅创建必要的敏感信息）
  - 定期轮换敏感信息
  - 监控敏感信息使用
  - 及时响应泄露事件

## References

- OWASP Secrets Management Cheat Sheet
- NIST SP 800-57 - Key Management Guidelines
- PCI-DSS Requirement 3.4 - Protect stored cardholder data
- Git Secrets Best Practices
