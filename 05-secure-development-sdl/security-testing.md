# 安全测试 Baseline

## 概述

本文档定义了 B 端产品安全测试的标准要求。

## 测试类型

**Level: MUST**

**Requirements:**
- 安全测试 MUST 包括：
  - **SAST**（静态应用安全测试）
  - **DAST**（动态应用安全测试）
  - **依赖扫描**
  - **渗透测试**（如适用）
- 安全测试 SHOULD 自动化

## SAST

**Level: MUST**

**Requirements:**
- SAST MUST 在代码提交时执行
- SAST SHOULD 集成到 CI/CD
- SAST 结果 MUST 评审和修复

## DAST

**Level: SHOULD**

**Requirements:**
- DAST SHOULD 在测试环境执行
- DAST SHOULD 定期执行（如每周）
- DAST 结果 MUST 评审和修复

## 渗透测试

**Level: SHOULD**

**Requirements:**
- 渗透测试 SHOULD 在发布前执行
- 渗透测试 SHOULD 由专业团队执行
- 渗透测试结果 MUST 评审和修复

## References

- OWASP Testing Guide
- NIST SP 800-115 - Technical Guide to Information Security Testing
