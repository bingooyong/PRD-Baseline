# 管理员边界 Baseline

## 概述

本文档定义了 B 端产品管理员权限的边界和控制要求，防止管理员权限滥用。

## 管理员角色定义

**Level: MUST**

**Requirements:**
- 系统 MUST 明确定义管理员角色
- 管理员角色 SHOULD 分级：
  - **超级管理员 (Super Admin)**: 系统级最高权限
  - **租户管理员 (Tenant Admin)**: 租户级管理权限
  - **功能管理员 (Feature Admin)**: 特定功能管理权限
- 管理员角色权限 MUST 明确文档化

## 管理员权限范围

**Level: MUST**

**Requirements:**
- 管理员权限范围 MUST 明确界定
- 管理员权限 SHOULD 遵循最小权限原则
- 管理员权限 MUST 不能包含以下操作（除非必要）：
  - 查看其他用户密码（即使是哈希值）
  - 绕过审计日志
  - 修改系统安全配置（如适用）
  - 删除关键系统数据

## 管理员操作保护

**Level: MUST**

**Requirements:**
- 管理员操作 MUST 要求额外验证：
  - 强制 MFA（多因素认证）
  - 操作确认（二次确认）
  - 操作审批（高风险操作）
- 管理员登录 MUST 记录详细审计日志
- 管理员操作 MUST 记录详细审计日志

### 高风险操作保护

**Level: MUST**

**Requirements:**
- 以下操作 MUST 要求额外保护：
  - 删除用户/数据
  - 修改权限配置
  - 修改安全策略
  - 导出敏感数据
  - 修改系统配置
- 高风险操作 MUST 要求：
  - MFA 验证
  - 操作确认
  - 审批流程（如适用）

## 管理员账户管理

**Level: MUST**

**Requirements:**
- 管理员账户创建 MUST 经过审批
- 管理员账户删除 MUST 经过审批（且不能自我删除）
- 管理员账户权限变更 MUST 经过审批
- 管理员账户操作 MUST 记录在审计日志中

### 管理员账户安全

**Level: MUST**

**Requirements:**
- 管理员账户密码策略 MUST 更严格：
  - 最小长度 >= 12 字符
  - 必须包含所有字符类型
  - 密码有效期 <= 60 天
- 管理员账户 MUST 强制启用 MFA
- 管理员账户 MUST 不能共享

## 管理员操作审计

**Level: MUST**

**Requirements:**
- 所有管理员操作 MUST 记录在审计日志中
- 审计日志 MUST 包含：
  - 操作人（管理员标识）
  - 操作时间
  - 操作类型
  - 操作对象
  - 操作前状态（如适用）
  - 操作后状态（如适用）
  - IP 地址
  - User-Agent
- 管理员审计日志 MUST 防篡改
- 管理员审计日志 MUST 永久保留（合规要求）

## 管理员权限分离

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持管理员权限分离（Separation of Duties）
- 权限分离场景：
  - 用户管理与权限管理分离
  - 数据管理与审计管理分离
  - 系统配置与安全配置分离
- 权限分离 SHOULD 可配置

## 管理员操作限制

**Level: SHOULD**

**Requirements:**
- 管理员操作 SHOULD 支持以下限制：
  - 操作时间限制（如：仅工作时间）
  - 操作地理位置限制（如：仅内网）
  - 操作频率限制（防止误操作）
- 操作限制 SHOULD 可配置

## 管理员会话管理

**Level: MUST**

**Requirements:**
- 管理员会话超时时间 MUST <= 15 分钟（无操作）
- 管理员会话绝对超时时间 MUST <= 4 小时
- 管理员会话 MUST 绑定 IP 地址（可选，建议启用）
- 管理员会话 MUST 记录详细日志

## 管理员操作监控

**Level: MUST**

**Requirements:**
- 管理员操作 MUST 实时监控
- 异常管理员操作 MUST 触发告警：
  - 异常时间操作
  - 异常地理位置操作
  - 批量操作
  - 高风险操作
- 告警 MUST 通知安全团队

## 管理员权限审查

**Level: MUST**

**Requirements:**
- 管理员权限 MUST 定期审查（至少每季度）
- 权限审查 SHOULD 包括：
  - 权限使用情况
  - 权限必要性
  - 权限合规性
- 权限审查结果 MUST 记录

## 管理员账户生命周期

**Level: MUST**

**Requirements:**
- 管理员账户创建 MUST 经过审批
- 管理员账户激活 MUST 经过验证
- 管理员账户禁用 MUST 经过审批
- 管理员账户删除 MUST 经过严格审批
- 管理员账户操作 MUST 记录在审计日志中

## 紧急管理员访问

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持紧急管理员访问（Break-glass）
- 紧急访问 MUST 要求：
  - 额外审批
  - 详细记录
  - 事后审查
- 紧急访问 SHOULD 有时效性（如 24 小时）

## 管理员培训与认证

**Level: SHOULD**

**Requirements:**
- 管理员 SHOULD 接受安全培训
- 管理员 SHOULD 通过安全认证
- 管理员培训记录 SHOULD 保留

## References

- ISO/IEC 27001:2022 - A.9.2 User Access Management
- NIST SP 800-53 - AC-5 Separation of Duties
- OWASP ASVS V2.1 - Administrative Functions
- Principle of Least Privilege
