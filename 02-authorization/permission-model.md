# 权限模型 Baseline

## 概述

本文档定义了 B 端产品权限模型的设计标准，包括权限粒度、权限组织、权限继承等。

## 权限粒度

**Level: MUST**

**Requirements:**
- 权限粒度 MUST 细粒度（资源级别）
- 权限格式 MUST 采用"资源:操作"（如：user:create, data:read）
- 资源标识 MUST 唯一
- 操作类型 MUST 标准化（create, read, update, delete, execute 等）

### 权限粒度层次

**Level: SHOULD**

**Requirements:**
- 权限 SHOULD 支持多级粒度：
  - **模块级**: 如 user, data, system
  - **资源级**: 如 user:profile, data:report
  - **字段级**: 如 user:profile:email（可选，高级场景）
- 权限粒度 SHOULD 根据业务需求确定

## 权限组织

**Level: MUST**

**Requirements:**
- 权限 MUST 按功能模块组织
- 权限组织 SHOULD 支持树形结构
- 权限组织 SHOULD 支持标签分类
- 权限组织 SHOULD 便于查找和管理

### 权限模块划分

**Level: SHOULD**

**Requirements:**
- 权限 SHOULD 按以下模块划分：
  - **用户管理**: user:*
  - **角色管理**: role:*
  - **数据管理**: data:*
  - **系统配置**: config:*
  - **审计日志**: audit:*
  - **API 管理**: api:*
- 模块划分 SHOULD 与系统功能模块对应

## 权限继承

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持权限继承机制
- 权限继承场景：
  - **角色继承**: 子角色继承父角色权限
  - **资源继承**: 子资源继承父资源权限
  - **操作继承**: 高级操作继承低级操作权限（如：update 包含 read）
- 权限继承规则 SHOULD 可配置

### 操作权限继承

**Level: SHOULD**

**Requirements:**
- 操作权限 SHOULD 遵循以下继承规则：
  - `*` (所有操作) 包含所有具体操作
  - `update` 包含 `read`
  - `delete` 包含 `read`
  - `execute` 独立（不包含其他操作）
- 继承规则 SHOULD 可配置

## 权限组合

**Level: MUST**

**Requirements:**
- 用户权限 = 所有角色权限的并集
- 权限组合规则：
  - 多个角色权限合并（OR 逻辑）
  - 拒绝权限优先级 > 允许权限优先级
- 权限组合结果 SHOULD 缓存（提高性能）

## 权限验证

**Level: MUST**

**Requirements:**
- 权限验证 MUST 在服务端执行
- 权限验证 MUST 支持以下场景：
  - 单一权限验证（如：user:create）
  - 多权限验证（如：user:create AND user:read）
  - 通配符验证（如：user:*）
- 权限验证失败 MUST 返回明确的错误信息

### 权限验证性能

**Level: SHOULD**

**Requirements:**
- 权限验证 SHOULD 使用缓存（减少数据库查询）
- 权限缓存失效策略 SHOULD 合理
- 权限验证 SHOULD 支持批量验证（如适用）

## 动态权限

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持动态权限（基于上下文）
- 动态权限场景：
  - 基于数据所有权的权限
  - 基于时间的权限
  - 基于地理位置的权限
  - 基于数据分类的权限
- 动态权限规则 SHOULD 可配置

## 权限模板

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 提供权限模板（预定义权限集合）
- 权限模板 SHOULD 覆盖常见角色场景：
  - 管理员模板
  - 普通用户模板
  - 只读用户模板
  - 审计员模板
- 权限模板 SHOULD 可自定义

## 权限导出/导入

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持权限定义导出（JSON/YAML）
- 系统 SHOULD 支持权限定义导入
- 权限导入 MUST 验证格式和完整性
- 权限导入操作 MUST 记录在审计日志中

## 权限版本管理

**Level: SHOULD**

**Requirements:**
- 权限定义 SHOULD 支持版本管理
- 权限变更 SHOULD 记录版本历史
- 权限版本 SHOULD 支持回滚

## 权限审计

**Level: MUST**

**Requirements:**
- 权限相关操作 MUST 记录在审计日志中：
  - 权限定义变更
  - 权限分配变更
  - 权限验证失败（可选）
- 审计日志 MUST 包含：
  - 操作人
  - 操作时间
  - 操作类型
  - 权限内容
  - 操作结果

## 权限模型扩展性

**Level: SHOULD**

**Requirements:**
- 权限模型 SHOULD 支持扩展（新增资源类型、操作类型）
- 权限扩展 SHOULD 不影响现有权限
- 权限扩展 SHOULD 向后兼容

## 多租户权限隔离

**Level: SHOULD**

**Requirements:**
- 多租户场景下，权限 MUST 按租户隔离
- 权限定义 SHOULD 支持租户级别
- 跨租户权限访问 MUST 禁止（除非明确授权）

## References

- NIST RBAC Model (ANSI INCITS 359-2012)
- OWASP ASVS V2.1 - Authorization
- ISO/IEC 27001:2022 - A.9.2 Access Control
