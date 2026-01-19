# 密码策略 Baseline

## 概述

本文档定义了 B 端产品密码策略的标准要求，确保密码强度和安全性。

## 密码复杂度要求

**Level: MUST**

**Requirements:**
- 密码最小长度 MUST >= 8 字符
- 密码最大长度 SHOULD <= 128 字符（防止 DoS）
- 密码 MUST 包含以下字符类型中的至少 3 种：
  - 大写字母 (A-Z)
  - 小写字母 (a-z)
  - 数字 (0-9)
  - 特殊字符 (!@#$%^&*()_+-=[]{}|;:,.<>?)
- 密码 MUST 不能包含用户名
- 密码 MUST 不能包含邮箱地址
- 密码 MUST 不能是常见弱密码（如：password123, admin123）

### 弱密码检测

**Level: MUST**

**Requirements:**
- 系统 MUST 维护弱密码字典（至少包含 Top 10000 常见密码）
- 系统 MUST 在设置/修改密码时检查弱密码
- 系统 MUST 拒绝弱密码并提示用户

## 密码历史策略

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 禁止重用最近 N 次使用的密码（N >= 5）
- 密码历史记录 SHOULD 保留至少 12 个月
- 密码历史记录 MUST 仅存储哈希值，不存储明文

## 密码有效期

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持密码有效期策略
- 默认密码有效期 SHOULD <= 90 天
- 密码过期前 SHOULD 提前 7 天提醒用户
- 密码过期后 MUST 强制用户修改密码
- 系统 SHOULD 支持不同用户组设置不同的密码有效期

## 密码修改

**Level: MUST**

**Requirements:**
- 用户 MUST 能够自主修改密码
- 修改密码时 MUST 验证当前密码
- 修改密码时 MUST 应用所有密码复杂度规则
- 修改密码后 MUST 使所有其他会话失效（可选，建议启用）
- 密码修改操作 MUST 记录在审计日志中

## 密码重置

**Level: MUST**

**Requirements:**
- 系统 MUST 支持"忘记密码"功能
- 密码重置 MUST 通过已验证的邮箱或手机号
- 密码重置链接/验证码 MUST 有时效性（<= 15 分钟）
- 密码重置链接/验证码 MUST 只能使用一次
- 密码重置链接/验证码使用后 MUST 立即失效
- 密码重置操作 MUST 记录在审计日志中
- 密码重置成功后 SHOULD 发送通知邮件

### 密码重置安全要求

**Level: MUST**

**Requirements:**
- 密码重置请求 MUST 实施速率限制（防止枚举攻击）
- 密码重置错误信息 MUST 不泄露账户是否存在
- 密码重置链接 MUST 包含不可预测的随机令牌（>= 32 字符）
- 密码重置链接 MUST 通过 HTTPS 传输

## 密码存储

**Level: MUST**

**Requirements:**
- 密码 MUST 使用加盐哈希存储，禁止明文存储
- 推荐哈希算法：bcrypt、Argon2、scrypt
- 盐值 MUST 为每个密码唯一生成
- 盐值长度 MUST >= 16 字节
- 哈希轮数/成本参数 SHOULD >= 10（bcrypt）或 >= 2（Argon2）

## 密码传输

**Level: MUST**

**Requirements:**
- 密码传输 MUST 使用 HTTPS
- 密码字段 MUST 在客户端使用 HTTPS POST 提交
- 密码字段 MUST 不在 URL 参数中传输
- 密码字段 SHOULD 不在浏览器历史记录中保存

## 密码策略配置

**Level: SHOULD**

**Requirements:**
- 系统 SHOULD 支持按用户组/租户配置不同的密码策略
- 密码策略配置变更 MUST 经过审批
- 密码策略配置变更 MUST 记录在审计日志中

## 密码策略提示

**Level: MUST**

**Requirements:**
- 系统 MUST 在密码输入界面显示密码复杂度要求
- 系统 MUST 实时验证密码复杂度（前端 + 后端双重验证）
- 系统 MUST 提供清晰的错误提示，说明密码不符合哪些要求

## 管理员密码策略

**Level: MUST**

**Requirements:**
- 管理员账户密码策略 MUST 更严格：
  - 最小长度 >= 12 字符
  - 必须包含所有 4 种字符类型
  - 密码有效期 <= 60 天
  - 禁止重用最近 10 次密码

## References

- NIST SP 800-63B - Digital Identity Guidelines (Section 5.1.1)
- OWASP ASVS V2.1 - Password Security Requirements
- OWASP Password Storage Cheat Sheet
- PCI-DSS Requirement 8.2.3 - Password Complexity
