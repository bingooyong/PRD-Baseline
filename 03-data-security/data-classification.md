# 数据分类 Baseline

## 概述

本文档定义了 B 端产品数据分类的标准要求，确保不同级别的数据得到相应的安全保护。

## 数据分类等级

**Level: MUST**

**Requirements:**
- 系统 MUST 建立数据分类体系
- 数据分类等级 MUST 至少包含以下级别：
  - **公开 (Public)**: 可公开访问的数据
  - **内部 (Internal)**: 仅内部使用的数据
  - **机密 (Confidential)**: 需要保护的数据
  - **绝密 (Top Secret)**: 最高级别敏感数据
- 数据分类等级 SHOULD 可扩展（根据业务需求）

### 分类等级定义

**Level: MUST**

**Requirements:**
- 每个分类等级 MUST 明确定义：
  - 数据范围
  - 访问要求
  - 存储要求
  - 传输要求
  - 处理要求
- 分类等级定义 MUST 文档化

## 数据分类标识

**Level: MUST**

**Requirements:**
- 所有数据 MUST 标识分类等级
- 数据分类标识 SHOULD 在以下位置显示：
  - 数据记录（元数据）
  - 数据存储（文件/数据库）
  - 数据传输（API 响应）
  - 用户界面（如适用）
- 数据分类标识 MUST 不能轻易修改

## 数据分类规则

**Level: MUST**

**Requirements:**
- 数据分类规则 MUST 明确文档化
- 数据分类规则 SHOULD 基于以下因素：
  - 数据敏感性
  - 法律法规要求
  - 业务影响
  - 泄露后果
- 数据分类规则 SHOULD 提供示例和指导

### 常见数据分类示例

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 提供常见数据分类示例：
  - **公开**: 产品介绍、公开文档
  - **内部**: 内部文档、非敏感配置
  - **机密**: 用户个人信息、业务数据
  - **绝密**: 密码、密钥、财务数据

## 自动分类

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持自动数据分类
- 自动分类 SHOULD 基于：
  - 数据内容（关键词、模式）
  - 数据来源
  - 数据所有者
  - 数据标签
- 自动分类结果 SHOULD 可人工审核和调整

## 数据分类变更

**Level: MUST**

**Requirements:**
- 数据分类变更 MUST 经过审批
- 数据分类变更 MUST 记录在审计日志中
- 数据分类变更 SHOULD 通知相关方
- 数据分类降级（从高到低）MUST 经过严格审批

## 分类数据访问控制

**Level: MUST**

**Requirements:**
- 数据访问控制 MUST 基于数据分类等级
- 访问控制规则：
  - 公开数据：所有人可访问
  - 内部数据：仅内部用户可访问
  - 机密数据：仅授权用户可访问
  - 绝密数据：仅高级授权用户可访问
- 访问控制 MUST 在服务端执行

## 分类数据存储

**Level: MUST**

**Requirements:**
- 数据存储要求 MUST 基于数据分类等级：
  - **公开/内部**: 标准存储
  - **机密**: 加密存储
  - **绝密**: 强加密存储 + 额外保护
- 存储要求 MUST 强制执行

## 分类数据传输

**Level: MUST**

**Requirements:**
- 数据传输要求 MUST 基于数据分类等级：
  - **公开/内部**: HTTPS（推荐）
  - **机密**: HTTPS（必须）
  - **绝密**: HTTPS + 端到端加密
- 传输要求 MUST 强制执行

## 分类数据处理

**Level: MUST**

**Requirements:**
- 数据处理要求 MUST 基于数据分类等级：
  - 机密/绝密数据 MUST 在安全环境中处理
  - 机密/绝密数据 MUST 限制处理人员
  - 机密/绝密数据处理 MUST 记录审计日志

## 数据分类审计

**Level: MUST**

**Requirements:**
- 数据分类相关操作 MUST 记录在审计日志中：
  - 数据分类标识
  - 数据分类变更
  - 分类数据访问
- 审计日志 MUST 包含数据分类信息

## 数据分类培训

**Level: SHOULD**

**Requirements:**
- 数据分类规则 SHOULD 对用户可见
- 数据分类 SHOULD 提供培训材料
- 用户 SHOULD 了解数据分类的重要性

## References

- ISO/IEC 27001:2022 - A.8.2 Information Classification
- NIST SP 800-60 - Guide for Mapping Types of Information
- GDPR - Data Protection by Design
- Data Classification Best Practices
