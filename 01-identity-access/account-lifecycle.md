# 账户生命周期管理 Baseline

## 概述

本文档定义了 B 端产品账户生命周期管理的标准要求，包括账户创建、激活、禁用、删除等全流程。

## 账户创建

**Level: MUST**

**Requirements:**
- 账户创建 MUST 经过身份验证（如邮箱验证、手机验证）
- 账户创建时 MUST 应用密码策略
- 账户创建时 MUST 分配默认角色和权限
- 账户创建操作 MUST 记录在审计日志中
- 账户创建成功后 SHOULD 发送欢迎邮件

### 账户创建流程

**Level: MUST**

**Requirements:**
- 注册邮箱/手机号 MUST 验证唯一性
- 注册邮箱 MUST 通过邮件验证链接激活
- 注册手机号 MUST 通过短信验证码验证
- 验证链接/验证码有效期 MUST <= 24 小时
- 验证链接/验证码 MUST 只能使用一次

## 账户激活

**Level: MUST**

**Requirements:**
- 新创建的账户 MUST 处于"未激活"状态
- 账户激活 MUST 通过已验证的邮箱/手机号完成
- 账户激活后 MUST 要求用户设置初始密码
- 账户激活操作 MUST 记录在审计日志中
- 账户未激活超过 7 天 SHOULD 自动禁用（可选）

## 账户状态管理

**Level: MUST**

**Requirements:**
- 系统 MUST 支持以下账户状态：
  - **活跃 (Active)**: 正常使用
  - **未激活 (Inactive)**: 已创建但未激活
  - **已禁用 (Disabled)**: 管理员禁用
  - **已锁定 (Locked)**: 因安全原因锁定
  - **已删除 (Deleted)**: 软删除（可恢复）
  - **已归档 (Archived)**: 永久删除前归档

### 账户状态转换规则

**Level: MUST**

**Requirements:**
- 账户状态变更 MUST 记录在审计日志中
- 账户状态变更 MUST 经过授权（用户自主或管理员）
- 账户禁用/锁定后 MUST 禁止登录
- 账户禁用/锁定后 SHOULD 发送通知（如配置了邮箱）

## 账户禁用

**Level: MUST**

**Requirements:**
- 系统 MUST 支持管理员禁用账户
- 账户禁用原因 MUST 记录
- 账户禁用后 MUST 立即终止所有活跃会话
- 账户禁用操作 MUST 记录在审计日志中
- 账户禁用后 SHOULD 发送通知邮件

### 自动禁用场景

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持以下自动禁用场景：
  - 长期未登录（如 90 天）
  - 密码过期超过一定期限（如 30 天）
  - 多次安全违规
- 自动禁用规则 SHOULD 可配置
- 自动禁用前 SHOULD 发送提醒通知

## 账户解锁

**Level: MUST**

**Requirements:**
- 系统 MUST 支持账户解锁功能
- 账户解锁方式：
  - 自动解锁（锁定期满）
  - 管理员手动解锁
  - 用户自助解锁（通过已验证的邮箱/手机）
- 账户解锁操作 MUST 记录在审计日志中
- 账户解锁后 SHOULD 要求用户修改密码（如因安全原因锁定）

## 账户删除

**Level: MUST**

**Requirements:**
- 账户删除 MUST 支持软删除（可恢复）和硬删除（永久）
- 软删除保留期 SHOULD >= 30 天
- 硬删除前 MUST 经过审批（管理员或用户确认）
- 账户删除前 MUST 检查数据依赖关系
- 账户删除操作 MUST 记录在审计日志中

### 账户删除安全要求

**Level: MUST**

**Requirements:**
- 删除账户前 MUST 要求验证身份（密码或 MFA）
- 删除账户前 MUST 显示影响范围（关联数据、权限等）
- 删除账户后 MUST 立即终止所有会话
- 删除账户后 SHOULD 发送确认邮件

### 数据保留与清理

**Level: MUST**

**Requirements:**
- 软删除的账户数据 MUST 保留至少 30 天
- 硬删除的账户数据 MUST 从生产环境删除
- 审计日志中的账户信息 MUST 永久保留（合规要求）
- 个人数据删除 MUST 遵循 GDPR/数据保护法规

## 账户恢复

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持账户恢复功能（软删除后）
- 账户恢复 MUST 在保留期内（如 30 天）
- 账户恢复 MUST 经过身份验证
- 账户恢复后 MUST 要求用户重新设置密码
- 账户恢复操作 MUST 记录在审计日志中

## 账户归档

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持账户归档功能
- 归档适用于长期不活跃的账户（如 1 年）
- 归档前 MUST 通知用户
- 归档的账户数据 MUST 从活跃数据库移除
- 归档的账户数据 MUST 保留在归档存储中（用于审计）

## 批量账户操作

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持批量账户操作（导入、禁用、删除等）
- 批量操作 MUST 经过审批
- 批量操作 MUST 提供预览和确认机制
- 批量操作 MUST 记录详细的操作日志
- 批量操作 SHOULD 支持回滚（如适用）

## 账户导入

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持批量账户导入（CSV/Excel）
- 账户导入 MUST 验证数据格式和完整性
- 账户导入 MUST 应用密码策略（如生成初始密码）
- 账户导入 MUST 记录导入日志
- 导入的账户 SHOULD 处于"未激活"状态，要求首次登录时激活

## 账户导出

**Level: SHOULD**

**Requirements:**
- 账户导出功能 MUST 经过授权
- 导出的账户数据 MUST 不包含密码（仅哈希值，如需要）
- 导出的账户数据 MUST 加密传输和存储
- 账户导出操作 MUST 记录在审计日志中

## 账户审计

**Level: MUST**

**Requirements:**
- 所有账户生命周期操作 MUST 记录在审计日志中：
  - 账户创建
  - 账户激活
  - 账户状态变更
  - 账户禁用/解锁
  - 账户删除/恢复
  - 账户归档
- 审计日志 MUST 包含：
  - 操作人（用户或管理员）
  - 操作时间
  - 操作类型
  - 操作原因（如适用）
  - IP 地址

## References

- ISO/IEC 27001:2022 - A.9.2 User Access Management
- NIST SP 800-53 - AC-2 Account Management
- GDPR Article 17 - Right to Erasure
- OWASP ASVS V2.1 - User Management
