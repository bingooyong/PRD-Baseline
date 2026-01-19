# 审计日志 Baseline

## 概述

本文档定义了 B 端产品审计日志功能的标准要求，确保系统操作的可追溯性和合规性。

## 审计日志范围

**Level: MUST**

**Requirements:**
- 以下操作 MUST 记录在审计日志中：
  - 用户登录/登出
  - 权限变更
  - 数据访问（创建、读取、更新、删除）
  - 配置变更
  - 安全事件
  - 管理员操作
  - API 调用（如适用）
- 审计日志范围 SHOULD 根据业务需求扩展

## 审计日志内容

**Level: MUST**

**Requirements:**
- 审计日志 MUST 包含以下信息：
  - 时间戳（UTC，精确到毫秒）
  - 用户标识（用户 ID、用户名）
  - 操作类型（操作名称）
  - 操作对象（资源类型、资源 ID）
  - 操作结果（成功/失败）
  - IP 地址
  - User-Agent
  - 请求 ID（如适用）
- 审计日志 SHOULD 包含操作前后状态（如适用）

## 审计日志格式

**Level: MUST**

**Requirements:**
- 审计日志格式 MUST 标准化（如 JSON）
- 审计日志格式 MUST 包含所有必需字段
- 审计日志格式 SHOULD 支持扩展字段
- 审计日志格式 MUST 文档化

### 日志格式示例

```json
{
  "timestamp": "2024-01-01T12:00:00.000Z",
  "user_id": "user123",
  "username": "john.doe",
  "action": "user.update",
  "resource_type": "user",
  "resource_id": "user456",
  "result": "success",
  "ip_address": "192.168.1.1",
  "user_agent": "Mozilla/5.0...",
  "request_id": "req-123456"
}
```

## 审计日志存储

**Level: MUST**

**Requirements:**
- 审计日志 MUST 存储在独立的存储系统中（与业务数据分离）
- 审计日志存储 MUST 支持：
  - 高可用性
  - 可扩展性
  - 快速查询
- 审计日志存储 SHOULD 使用专门的日志管理系统（如 ELK、Splunk）

## 审计日志保留

**Level: MUST**

**Requirements:**
- 审计日志 MUST 保留至少 90 天（在线）
- 审计日志 SHOULD 保留至少 1 年（归档）
- 审计日志保留期 SHOULD 符合法律法规要求（如 GDPR、等保）
- 审计日志保留策略 SHOULD 可配置

## 审计日志防篡改

**Level: MUST**

**Requirements:**
- 审计日志 MUST 防篡改
- 防篡改措施 SHOULD 包括：
  - 只追加（Append-only）存储
  - 数字签名（如适用）
  - 访问控制（仅授权用户可访问）
  - 完整性校验
- 审计日志修改/删除 MUST 禁止（除非合规要求）

## 审计日志访问控制

**Level: MUST**

**Requirements:**
- 审计日志访问 MUST 严格控制
- 审计日志访问 SHOULD 基于角色（如审计员角色）
- 审计日志访问操作 MUST 记录在审计日志中（元审计）
- 审计日志导出 MUST 经过审批

## 审计日志查询

**Level: MUST**

**Requirements:**
- 系统 MUST 提供审计日志查询功能
- 审计日志查询 SHOULD 支持：
  - 按时间范围查询
  - 按用户查询
  - 按操作类型查询
  - 按资源查询
  - 组合查询
- 审计日志查询 SHOULD 支持导出（如适用）

## 审计日志性能

**Level: SHOULD**

**Requirements:**
- 审计日志记录 SHOULD 异步处理（不影响业务性能）
- 审计日志查询 SHOULD 优化（支持索引）
- 审计日志存储 SHOULD 支持分片（大数据量场景）

## 审计日志告警

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持审计日志告警
- 告警场景 SHOULD 包括：
  - 异常操作（如批量删除）
  - 权限提升尝试
  - 安全事件
  - 审计日志存储异常
- 告警 MUST 通知安全团队

## 审计日志合规

**Level: MUST**

**Requirements:**
- 审计日志 MUST 符合相关法律法规要求：
  - GDPR（如适用）
  - 等保要求（如适用）
  - 行业标准（如 PCI-DSS、SOX）
- 审计日志 SHOULD 通过合规审计

## References

- ISO/IEC 27001:2022 - A.12.4 Logging and Monitoring
- NIST SP 800-92 - Guide to Computer Security Log Management
- PCI-DSS Requirement 10 - Track and Monitor Access
- OWASP Logging Cheat Sheet
