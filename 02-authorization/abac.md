# 基于属性的访问控制（ABAC）Baseline

## 概述

本文档定义了 B 端产品基于属性的访问控制（ABAC）功能的标准要求，适用于需要细粒度、上下文相关的访问控制场景。

## ABAC 模型

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持 ABAC 模型（作为 RBAC 的补充或替代）
- ABAC 模型基于以下属性：
  - **主体属性 (Subject Attributes)**: 用户属性（角色、部门、级别等）
  - **资源属性 (Resource Attributes)**: 资源属性（类型、所有者、分类等）
  - **环境属性 (Environment Attributes)**: 环境属性（时间、位置、IP 等）
  - **操作属性 (Action Attributes)**: 操作类型（读、写、删除等）

## 属性定义

**Level: MUST**

**Requirements:**
- 属性定义 MUST 包含：
  - 属性名称（唯一标识）
  - 属性类型（字符串、数字、布尔、日期等）
  - 属性值域（可选值范围）
  - 属性来源（用户属性、资源属性、环境属性）
- 属性定义 MUST 可配置
- 属性定义变更 MUST 记录在审计日志中

### 主体属性

**Level: MUST**

**Requirements:**
- 主体属性 SHOULD 包括：
  - 用户 ID
  - 角色列表
  - 部门
  - 职位级别
  - 安全级别
  - 所属租户
- 主体属性 SHOULD 从用户管理系统获取

### 资源属性

**Level: MUST**

**Requirements:**
- 资源属性 SHOULD 包括：
  - 资源类型
  - 资源 ID
  - 资源所有者
  - 资源分类/标签
  - 资源敏感级别
  - 资源创建时间
- 资源属性 SHOULD 存储在资源元数据中

### 环境属性

**Level: SHOULD**

**Requirements:**
- 环境属性 SHOULD 包括：
  - 当前时间
  - 用户 IP 地址
  - 地理位置
  - 设备类型
  - 网络类型（内网/外网）
- 环境属性 SHOULD 实时获取

## 策略定义

**Level: MUST**

**Requirements:**
- 访问控制策略 MUST 使用标准策略语言（如 XACML、Rego、自定义 DSL）
- 策略定义 MUST 包含：
  - 策略名称
  - 策略描述
  - 策略规则（条件表达式）
  - 策略效果（允许/拒绝）
  - 策略优先级
- 策略定义 MUST 可配置（无需代码修改）

### 策略规则格式

**Level: SHOULD**

**Requirements:**
- 策略规则 SHOULD 支持以下操作符：
  - 比较操作：==, !=, <, >, <=, >=
  - 逻辑操作：AND, OR, NOT
  - 集合操作：IN, NOT IN
  - 字符串操作：CONTAINS, STARTS WITH, ENDS WITH
- 策略规则 SHOULD 支持函数调用（如：时间函数、字符串函数）

### 策略示例

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 提供策略示例和模板
- 常见策略场景：
  - 基于时间的访问控制（如：仅工作时间可访问）
  - 基于位置的访问控制（如：仅内网可访问）
  - 基于数据所有权的访问控制（如：仅所有者可修改）
  - 基于数据分类的访问控制（如：高敏感数据仅高级别用户可访问）

## 策略评估

**Level: MUST**

**Requirements:**
- 策略评估引擎 MUST 支持实时评估
- 策略评估 MUST 在服务端执行
- 策略评估结果 MUST 缓存（提高性能）
- 策略评估失败时 MUST 默认拒绝（Deny by Default）
- 策略评估 SHOULD 支持策略组合（多个策略的 AND/OR 组合）

### 策略优先级

**Level: MUST**

**Requirements:**
- 当多个策略匹配时，MUST 按优先级处理
- 优先级规则：
  - 拒绝策略优先级 > 允许策略优先级
  - 明确策略优先级 > 默认策略优先级
  - 高优先级策略 > 低优先级策略

## 策略管理

**Level: MUST**

**Requirements:**
- 策略管理 MUST 支持 CRUD 操作
- 策略创建/修改 MUST 经过审批（如适用）
- 策略变更 MUST 记录在审计日志中
- 策略变更 SHOULD 支持版本管理
- 策略变更 SHOULD 支持回滚

### 策略测试

**Level: SHOULD**

**Requirements:**
- 策略定义后 SHOULD 支持测试验证
- 策略测试 SHOULD 支持：
  - 模拟不同属性组合
  - 验证策略效果
  - 性能测试
- 策略测试 SHOULD 在策略生效前执行

## ABAC 与 RBAC 集成

**Level: SHOULD**

**Requirements:**
- ABAC 和 RBAC SHOULD 可以同时使用
- 集成方式：
  - ABAC 作为 RBAC 的补充（细粒度控制）
  - ABAC 和 RBAC 结果合并（AND/OR）
- 集成策略 SHOULD 可配置

## 属性提供者

**Level: MUST**

**Requirements:**
- 系统 MUST 支持属性提供者（Attribute Provider）
- 属性提供者 SHOULD 支持：
  - 用户属性服务
  - 资源属性服务
  - 环境属性服务
  - 外部属性服务（如 LDAP、数据库）
- 属性提供者 SHOULD 支持缓存
- 属性提供者失败时 SHOULD 有降级策略

## 性能优化

**Level: SHOULD**

**Requirements:**
- 策略评估 SHOULD 使用缓存（减少重复计算）
- 策略索引 SHOULD 优化（快速匹配相关策略）
- 属性获取 SHOULD 批量处理（减少网络请求）
- 策略评估 SHOULD 支持异步处理（如适用）

## ABAC 审计

**Level: MUST**

**Requirements:**
- 所有 ABAC 相关操作 MUST 记录在审计日志中：
  - 策略创建/修改/删除
  - 属性定义变更
  - 策略评估结果（可选，用于调试）
- 审计日志 MUST 包含：
  - 操作人
  - 操作时间
  - 操作类型
  - 策略内容（如适用）
  - 评估结果（如适用）

## 策略语言选择

**Level: SHOULD**

**Requirements:**
- 策略语言 SHOULD 选择标准语言（如 XACML、Rego）
- 如使用自定义 DSL，MUST 提供完整的语法文档
- 策略语言 SHOULD 支持策略导入/导出

## References

- NIST SP 800-162 - Guide to Attribute Based Access Control
- XACML 3.0 Specification
- OWASP ASVS V2.1 - Attribute-Based Access Control
- ISO/IEC 27001:2022 - A.9.2 Access Control
