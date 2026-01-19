# 权限提升防护 Baseline

## 概述

本文档定义了 B 端产品权限提升攻击的防护要求，确保用户无法通过非法手段获取超出其授权范围的权限。

## 权限提升类型

**Level: MUST**

**Requirements:**
- 系统 MUST 防护以下权限提升类型：
  - **垂直权限提升**: 普通用户获取管理员权限
  - **水平权限提升**: 用户 A 获取用户 B 的权限
  - **功能权限提升**: 用户获取未授权的功能权限
  - **数据权限提升**: 用户访问未授权的数据

## 权限检查原则

**Level: MUST**

**Requirements:**
- 所有受保护的操作 MUST 进行权限检查
- 权限检查 MUST 在服务端执行（不能仅依赖前端）
- 权限检查 MUST 在每次请求时执行（不能依赖会话状态）
- 权限检查失败 MUST 拒绝请求并记录日志

### 权限检查时机

**Level: MUST**

**Requirements:**
- 权限检查 MUST 在以下时机执行：
  - API 请求处理前
  - 页面/路由访问前
  - 功能操作前
  - 数据访问前（包括查询、修改、删除）

## 参数验证

**Level: MUST**

**Requirements:**
- 所有用户输入参数 MUST 验证
- 参数验证 MUST 包括：
  - 参数类型验证
  - 参数范围验证
  - 参数权限验证（如：用户 ID 是否属于当前用户）
- 参数验证失败 MUST 拒绝请求

### 资源所有权验证

**Level: MUST**

**Requirements:**
- 访问资源时 MUST 验证资源所有权或权限
- 资源标识（如 ID）MUST 不能由用户随意指定
- 资源访问 MUST 基于用户身份和权限，而非仅基于资源 ID
- 跨租户资源访问 MUST 明确禁止

## 会话安全

**Level: MUST**

**Requirements:**
- 会话令牌 MUST 不能包含权限信息（防止篡改）
- 权限信息 MUST 从服务端获取（基于用户身份）
- 会话权限变更后 MUST 重新生成会话令牌
- 会话令牌 MUST 签名验证（如使用 JWT）

## 管理员操作保护

**Level: MUST**

**Requirements:**
- 管理员操作 MUST 要求额外验证（如 MFA）
- 管理员权限变更 MUST 经过审批
- 管理员操作 MUST 记录详细审计日志
- 管理员账户 MUST 不能自我删除或禁用

## 权限变更监控

**Level: MUST**

**Requirements:**
- 权限变更操作 MUST 实时监控
- 异常权限变更 MUST 触发告警：
  - 批量权限授予
  - 权限授予给异常用户
  - 权限变更在异常时间
  - 权限变更在异常地理位置
- 权限变更告警 MUST 通知安全团队

## 最小权限原则

**Level: MUST**

**Requirements:**
- 用户权限分配 MUST 遵循最小权限原则
- 默认用户权限 SHOULD 仅包含必要的基础权限
- 权限授予 MUST 基于业务需求（而非"以防万一"）
- 权限授予 SHOULD 定期审查（如每季度）

## 权限回收

**Level: MUST**

**Requirements:**
- 权限回收 MUST 立即生效
- 权限回收后 MUST 终止相关会话（如适用）
- 权限回收操作 MUST 记录在审计日志中
- 权限回收 SHOULD 通知用户（如适用）

## 测试与验证

**Level: MUST**

**Requirements:**
- 系统 MUST 定期进行权限提升测试
- 权限提升测试 SHOULD 包括：
  - 垂直权限提升测试
  - 水平权限提升测试
  - 功能权限提升测试
  - 数据权限提升测试
- 测试结果 MUST 记录和跟踪

## 安全编码要求

**Level: MUST**

**Requirements:**
- 代码审查 MUST 检查权限验证逻辑
- 权限验证代码 MUST 不能有绕过路径
- 权限验证 MUST 使用统一的权限检查框架
- 权限验证逻辑 MUST 有单元测试覆盖

## 异常处理

**Level: MUST**

**Requirements:**
- 权限验证异常 MUST 默认拒绝（Deny on Error）
- 权限验证异常 MUST 记录详细日志
- 权限验证异常 SHOULD 不泄露系统内部信息

## 权限提升攻击检测

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 检测权限提升攻击尝试：
  - 频繁的权限验证失败
  - 尝试访问未授权资源
  - 尝试执行未授权操作
- 检测到攻击尝试时 SHOULD 触发告警
- 检测到攻击尝试时 SHOULD 记录详细日志

## 权限提升响应

**Level: MUST**

**Requirements:**
- 发现权限提升事件时 MUST 立即响应：
  - 终止相关会话
  - 锁定相关账户（如适用）
  - 记录安全事件
  - 通知安全团队
- 权限提升事件 MUST 进行事后分析

## References

- OWASP Top 10 - A01:2021 Broken Access Control
- OWASP ASVS V2.1 - Authorization
- CWE-269 - Improper Privilege Management
- NIST SP 800-53 - AC-3 Access Enforcement
