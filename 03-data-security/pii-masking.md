# 个人身份信息（PII）脱敏 Baseline

## 概述

本文档定义了 B 端产品个人身份信息（PII）脱敏的标准要求，确保敏感个人信息在非必要场景下得到保护。

## PII 定义

**Level: MUST**

**Requirements:**
- 系统 MUST 明确定义 PII 范围
- PII 包括但不限于：
  - 姓名
  - 身份证号
  - 手机号
  - 邮箱地址
  - 银行卡号
  - 地址
  - 生物识别信息
- PII 定义 MUST 符合相关法律法规（如 GDPR、个人信息保护法）

## 脱敏场景

**Level: MUST**

**Requirements:**
- 以下场景 MUST 对 PII 进行脱敏：
  - 日志记录
  - 错误信息返回
  - 非授权用户查看
  - 数据导出（如适用）
  - 测试环境数据
  - 数据分析（如适用）

## 脱敏规则

**Level: MUST**

**Requirements:**
- 脱敏规则 MUST 明确文档化
- 脱敏规则 SHOULD 基于数据类型：
  - **姓名**: 保留首字，其余用 * 替代（如：张**）
  - **手机号**: 保留前 3 位和后 4 位（如：138****1234）
  - **邮箱**: 保留用户名首字符和域名（如：z***@example.com）
  - **身份证号**: 保留前 6 位和后 4 位（如：110101****1234）
  - **银行卡号**: 保留前 4 位和后 4 位（如：6222****1234）
- 脱敏规则 SHOULD 可配置

## 脱敏实现

**Level: MUST**

**Requirements:**
- 脱敏实现 MUST 在服务端执行
- 脱敏实现 MUST 不能在前端执行（防止绕过）
- 脱敏实现 SHOULD 使用统一的脱敏框架
- 脱敏实现 SHOULD 支持多种脱敏算法（如：掩码、哈希、加密）

### 脱敏算法

**Level: SHOULD**

**Requirements:**
- 脱敏算法 SHOULD 支持：
  - **掩码脱敏**: 部分字符用 * 替代
  - **哈希脱敏**: 使用哈希算法（不可逆）
  - **加密脱敏**: 使用加密算法（可逆，需授权）
- 脱敏算法选择 SHOULD 基于使用场景

## 可逆脱敏

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持可逆脱敏（加密脱敏）
- 可逆脱敏 MUST 仅授权用户可解密
- 可逆脱敏密钥 MUST 安全管理
- 可逆脱敏操作 MUST 记录在审计日志中

## 脱敏配置

**Level: SHOULD**

**Requirements:**
- 脱敏规则 SHOULD 可配置（无需代码修改）
- 脱敏配置 SHOULD 支持：
  - 按字段配置脱敏规则
  - 按用户角色配置脱敏级别
  - 按场景配置脱敏策略
- 脱敏配置变更 MUST 经过审批
- 脱敏配置变更 MUST 记录在审计日志中

## 脱敏性能

**Level: SHOULD**

**Requirements:**
- 脱敏操作 SHOULD 考虑性能影响
- 脱敏操作 SHOULD 使用缓存（如适用）
- 脱敏操作 SHOULD 异步处理（如适用，不影响用户体验）

## 脱敏测试

**Level: SHOULD**

**Requirements:**
- 脱敏实现 SHOULD 进行测试：
  - 功能测试（脱敏效果）
  - 性能测试
  - 安全测试（防止绕过）
- 测试结果 SHOULD 记录

## 脱敏审计

**Level: SHOULD**

**Requirements:**
- 脱敏相关操作 SHOULD 记录在审计日志中：
  - 脱敏配置变更
  - 可逆脱敏操作（解密）
- 审计日志 MUST 不包含原始 PII（已脱敏）

## 数据导出脱敏

**Level: MUST**

**Requirements:**
- 数据导出时 MUST 对 PII 进行脱敏（除非明确授权）
- 数据导出脱敏规则 MUST 明确告知用户
- 数据导出操作 MUST 记录在审计日志中

## 测试数据脱敏

**Level: MUST**

**Requirements:**
- 测试环境数据 MUST 使用脱敏数据
- 测试数据脱敏 MUST 不能使用真实 PII
- 测试数据生成 SHOULD 使用数据脱敏工具

## 日志脱敏

**Level: MUST**

**Requirements:**
- 日志记录时 MUST 对 PII 进行脱敏
- 日志脱敏 MUST 在日志记录前执行
- 日志脱敏规则 MUST 覆盖所有 PII 字段

## 错误信息脱敏

**Level: MUST**

**Requirements:**
- 错误信息返回时 MUST 对 PII 进行脱敏
- 错误信息脱敏 MUST 不泄露敏感信息
- 错误信息脱敏 SHOULD 提供足够的调试信息（不影响安全）

## 合规要求

**Level: MUST**

**Requirements:**
- PII 脱敏 MUST 符合相关法律法规要求：
  - GDPR（如适用）
  - 个人信息保护法（如适用）
  - 等保要求（如适用）
- PII 脱敏 SHOULD 通过安全审计

## References

- GDPR Article 25 - Data Protection by Design
- NIST SP 800-122 - Guide to Protecting the Confidentiality of PII
- OWASP Privacy Risks Cheat Sheet
- Data Masking Best Practices
