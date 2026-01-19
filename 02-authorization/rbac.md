# 基于角色的访问控制（RBAC）Baseline

## 概述

本文档定义了 B 端产品基于角色的访问控制（RBAC）功能的标准要求。

## RBAC 模型

**Level: MUST**

**Requirements:**
- 系统 MUST 实现标准的 RBAC 模型
- RBAC 模型 MUST 包含以下核心概念：
  - **用户 (User)**: 系统使用者
  - **角色 (Role)**: 权限集合
  - **权限 (Permission)**: 具体操作权限
  - **资源 (Resource)**: 被保护的对象

### 角色层次

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持角色继承（Role Hierarchy）
- 子角色 SHOULD 自动继承父角色的权限
- 角色层次深度 SHOULD <= 5 层（防止过度复杂）

## 角色管理

**Level: MUST**

**Requirements:**
- 系统 MUST 支持角色的创建、修改、删除
- 角色名称 MUST 唯一
- 角色描述 SHOULD 清晰说明角色用途
- 系统角色（预定义）MUST 不能删除
- 角色删除前 MUST 检查用户依赖
- 角色管理操作 MUST 记录在审计日志中

### 预定义角色

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 提供以下预定义角色：
  - **超级管理员 (Super Admin)**: 所有权限
  - **管理员 (Admin)**: 管理权限（受限）
  - **普通用户 (User)**: 基础使用权限
  - **只读用户 (Viewer)**: 仅查看权限
- 预定义角色权限 SHOULD 可配置（如适用）

## 权限管理

**Level: MUST**

**Requirements:**
- 权限 MUST 采用"资源:操作"格式（如：user:create, data:read）
- 权限粒度 SHOULD 细粒度（资源级别）
- 权限定义 MUST 包含：
  - 权限标识（唯一）
  - 权限名称
  - 权限描述
  - 关联资源
- 权限管理操作 MUST 记录在审计日志中

### 权限分类

**Level: SHOULD**

**Requirements:**
- 权限 SHOULD 按功能模块分类：
  - 用户管理权限
  - 数据管理权限
  - 系统配置权限
  - 审计日志权限
- 权限分类 SHOULD 支持多级分类

## 角色-权限分配

**Level: MUST**

**Requirements:**
- 系统 MUST 支持为角色分配权限
- 权限分配 MUST 支持批量操作
- 权限分配变更 MUST 立即生效（或下次登录生效）
- 权限分配操作 MUST 记录在审计日志中

### 最小权限原则

**Level: MUST**

**Requirements:**
- 角色权限分配 MUST 遵循最小权限原则
- 默认角色 SHOULD 仅包含必要的基础权限
- 权限授予 MUST 经过审批（如适用）

## 用户-角色分配

**Level: MUST**

**Requirements:**
- 系统 MUST 支持为用户分配角色
- 用户 SHOULD 可以拥有多个角色
- 用户权限 = 所有角色权限的并集
- 用户-角色分配变更 MUST 立即生效（或下次登录生效）
- 用户-角色分配操作 MUST 记录在审计日志中

## 权限检查

**Level: MUST**

**Requirements:**
- 所有受保护的操作 MUST 进行权限检查
- 权限检查 MUST 在服务端执行（不能仅依赖前端）
- 权限检查失败 MUST 返回明确的错误信息（不泄露系统信息）
- 权限检查 SHOULD 缓存结果（提高性能）

### 权限检查时机

**Level: MUST**

**Requirements:**
- 权限检查 MUST 在以下时机执行：
  - API 请求处理前
  - 页面访问前
  - 功能操作前
  - 数据访问前

## 动态权限

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持基于上下文的动态权限
- 动态权限场景：
  - 基于数据所有权的权限（如：只能操作自己创建的数据）
  - 基于时间的权限（如：仅在特定时间段可访问）
  - 基于地理位置的权限（如：仅特定区域可访问）
- 动态权限规则 SHOULD 可配置

## 权限继承

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持权限继承机制
- 权限继承场景：
  - 角色继承（子角色继承父角色权限）
  - 资源继承（子资源继承父资源权限）
- 权限继承 SHOULD 可配置（允许或禁止）

## 权限审计

**Level: MUST**

**Requirements:**
- 所有权限相关操作 MUST 记录在审计日志中：
  - 角色创建/修改/删除
  - 权限创建/修改/删除
  - 角色-权限分配
  - 用户-角色分配
  - 权限检查失败（可选）
- 审计日志 MUST 包含：
  - 操作人
  - 操作时间
  - 操作类型
  - 操作对象
  - 操作结果

## 权限模型扩展

**Level: MAY**

**Requirements:**
- 系统 MAY 支持以下扩展：
  - **条件权限**: 基于条件的权限（如：仅工作日可访问）
  - **临时权限**: 有时效性的权限
  - **委托权限**: 权限临时委托给他人
- 扩展功能 SHOULD 不影响核心 RBAC 模型

## 多租户权限隔离

**Level: SHOULD**

**Requirements:**
- 多租户场景下，权限 MUST 按租户隔离
- 跨租户权限访问 MUST 禁止（除非明确授权）
- 租户管理员权限 SHOULD 限制在租户范围内

## 权限性能优化

**Level: SHOULD**

**Requirements:**
- 权限检查 SHOULD 使用缓存（减少数据库查询）
- 权限缓存失效策略 SHOULD 合理（权限变更时失效）
- 权限数据 SHOULD 支持分页查询（大量权限时）

## References

- NIST RBAC Model (ANSI INCITS 359-2012)
- ISO/IEC 27001:2022 - A.9.2 Access Control
- OWASP ASVS V2.1 - Authorization
- RBAC vs ABAC: A Comparative Analysis
