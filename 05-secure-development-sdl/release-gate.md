# 发布门禁 Baseline

## 概述

本文档定义了 B 端产品发布前的安全检查门禁要求。

## 发布检查项

**Level: MUST**

**Requirements:**
- 发布前 MUST 完成以下检查：
  - 安全测试通过（SAST、DAST）
  - 依赖扫描无高危漏洞
  - 威胁建模完成
  - 安全评审通过
  - 审计日志配置正确
- 发布检查项 MUST 强制执行（不能绕过）

## 安全检查清单

**Level: MUST**

**Requirements:**
- 安全检查清单 MUST 包括：
  - 身份认证配置
  - 授权配置
  - 加密配置
  - 日志配置
  - 安全配置
- 安全检查清单 MUST 逐项确认

## 发布审批

**Level: MUST**

**Requirements:**
- 发布 MUST 经过安全团队审批
- 发布审批 MUST 记录
- 发布审批 SHOULD 自动化（如适用）

## References

- Microsoft SDL Release Gate
- OWASP ASVS - Application Security Verification Standard
