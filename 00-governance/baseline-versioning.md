# Baseline 版本管理

## 概述

本文档定义了 PRD Baseline 的版本管理规范，确保 Baseline 的可追溯性、可审计性和向后兼容性。

## 版本号规范

**Level: MUST**

### 版本号格式

采用语义化版本号：`MAJOR.MINOR.PATCH`

- **MAJOR**: 不兼容的变更（删除要求、重大策略调整）
- **MINOR**: 新增要求（向后兼容）
- **PATCH**: 文档修正、澄清说明

### 版本变更要求

**Requirements:**
- 所有 Baseline 文档 MUST 包含版本号
- 版本变更 MUST 记录在变更日志中
- 重大变更（MAJOR）MUST 经过安全评审委员会批准
- 每个版本 MUST 标注生效日期和废弃日期（如适用）

### 版本引用规范

**Requirements:**
- 项目引用 Baseline 时 MUST 明确指定版本号
- 禁止使用 `latest` 或未指定版本号的引用
- 版本引用格式：`baseline-name@MAJOR.MINOR.PATCH`

**Example:**
```yaml
baselines:
  - name: login-authentication
    version: 2.1.0
  - name: password-policy
    version: 1.3.0
```

## 变更管理流程

**Level: MUST**

**Requirements:**
- 所有变更提案 MUST 提交 PR（Pull Request）
- PR MUST 包含变更原因、影响范围、风险评估
- PR MUST 经过至少 2 名安全专家评审
- 变更生效前 MUST 通知所有引用该 Baseline 的项目

## 向后兼容性

**Level: SHOULD**

**Requirements:**
- 新版本 SHOULD 保持向后兼容
- 如需破坏性变更，MUST 提供迁移指南
- 旧版本 SHOULD 保留至少 12 个月的支持期

## 版本归档

**Level: MUST**

**Requirements:**
- 所有历史版本 MUST 永久保留
- 归档版本 MUST 标注状态（Active / Deprecated / Archived）
- 归档版本 MUST 可访问，用于审计追溯

## References

- Semantic Versioning 2.0.0: https://semver.org/
- ISO/IEC 27001:2022 - Information Security Management
- NIST SP 800-53 - Security and Privacy Controls

## 变更日志

### 1.0.0 (2024-01-01)
- 初始版本发布
