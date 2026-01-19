# 操作可追溯性 Baseline

## 概述

本文档定义了 B 端产品操作可追溯性的标准要求，确保所有关键操作都可以追溯到具体用户和时间。

## 可追溯操作范围

**Level: MUST**

**Requirements:**
- 以下操作 MUST 可追溯：
  - 数据创建、修改、删除
  - 配置变更
  - 权限变更
  - 系统设置变更
  - 批量操作
  - 数据导出
  - API 调用（如适用）
- 可追溯操作范围 SHOULD 根据业务需求扩展

## 追溯信息要求

**Level: MUST**

**Requirements:**
- 每个可追溯操作 MUST 记录以下信息：
  - 操作人（用户 ID、用户名）
  - 操作时间（精确到毫秒）
  - 操作类型
  - 操作对象
  - 操作内容（变更前后值，如适用）
  - 操作来源（IP 地址、User-Agent）
  - 操作结果
- 追溯信息 MUST 存储在审计日志中

## 数据变更追溯

**Level: MUST**

**Requirements:**
- 数据变更 MUST 记录变更历史
- 数据变更历史 SHOULD 包括：
  - 变更前值
  - 变更后值
  - 变更字段
  - 变更原因（如适用）
- 数据变更历史 SHOULD 支持版本对比

## 配置变更追溯

**Level: MUST**

**Requirements:**
- 配置变更 MUST 记录变更历史
- 配置变更历史 SHOULD 包括：
  - 变更前配置
  - 变更后配置
  - 变更原因
  - 变更审批（如适用）
- 配置变更 SHOULD 支持回滚（如适用）

## 批量操作追溯

**Level: MUST**

**Requirements:**
- 批量操作 MUST 记录详细信息
- 批量操作追溯 SHOULD 包括：
  - 操作范围（影响的记录数）
  - 操作内容
  - 操作结果（成功/失败数量）
  - 失败详情（如适用）
- 批量操作追溯 SHOULD 支持明细查询

## 追溯信息存储

**Level: MUST**

**Requirements:**
- 追溯信息 MUST 存储在独立的存储系统中
- 追溯信息存储 MUST 支持：
  - 长期保留
  - 快速查询
  - 完整性保护
- 追溯信息存储 SHOULD 使用专门的审计系统

## 追溯信息查询

**Level: MUST**

**Requirements:**
- 系统 MUST 提供追溯信息查询功能
- 追溯信息查询 SHOULD 支持：
  - 按用户查询
  - 按时间查询
  - 按操作类型查询
  - 按资源查询
  - 组合查询
- 追溯信息查询 SHOULD 支持导出

## 追溯信息保留

**Level: MUST**

**Requirements:**
- 追溯信息 MUST 保留至少 1 年（在线）
- 追溯信息 SHOULD 保留至少 7 年（归档，如合规要求）
- 追溯信息保留期 SHOULD 符合法律法规要求
- 追溯信息保留策略 SHOULD 可配置

## 追溯信息防篡改

**Level: MUST**

**Requirements:**
- 追溯信息 MUST 防篡改
- 防篡改措施 SHOULD 包括：
  - 只追加存储
  - 数字签名（如适用）
  - 访问控制
  - 完整性校验
- 追溯信息修改/删除 MUST 禁止（除非合规要求）

## 追溯信息访问控制

**Level: MUST**

**Requirements:**
- 追溯信息访问 MUST 严格控制
- 追溯信息访问 SHOULD 基于角色（如审计员、合规员）
- 追溯信息访问操作 MUST 记录在审计日志中
- 追溯信息导出 MUST 经过审批

## 追溯信息合规

**Level: MUST**

**Requirements:**
- 追溯信息 MUST 符合相关法律法规要求：
  - 等保要求（如适用）
  - 行业标准（如 SOX、GDPR）
- 追溯信息 SHOULD 通过合规审计

## References

- ISO/IEC 27001:2022 - A.12.4 Logging and Monitoring
- NIST SP 800-53 - AU-2 Audit Events
- SOX Compliance Requirements
- Data Lineage and Traceability
