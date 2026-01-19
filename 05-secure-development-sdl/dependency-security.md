# 依赖安全 Baseline

## 概述

本文档定义了 B 端产品依赖库安全管理的标准要求。

## 依赖来源

**Level: MUST**

**Requirements:**
- 依赖库 MUST 来自可信源（如官方仓库、知名 CDN）
- 依赖库 MUST 验证完整性（如校验和、签名）
- 依赖库 SHOULD 使用锁定版本（如 package-lock.json）

## 依赖扫描

**Level: MUST**

**Requirements:**
- 依赖库 MUST 定期扫描已知漏洞
- 依赖扫描 SHOULD 自动化（如 CI/CD）
- 依赖扫描 SHOULD 使用专业工具（如 Snyk、OWASP Dependency-Check）
- 扫描到漏洞时 MUST 立即告警

## 漏洞修复

**Level: MUST**

**Requirements:**
- 发现依赖漏洞时 MUST 评估影响
- 高危漏洞 MUST 在 7 天内修复
- 中危漏洞 MUST 在 30 天内修复
- 低危漏洞 SHOULD 在 90 天内修复
- 漏洞修复 MUST 测试验证

## 依赖更新

**Level: MUST**

**Requirements:**
- 依赖库 MUST 定期更新
- 依赖更新 SHOULD 测试验证
- 依赖更新 MUST 记录变更日志

## References

- OWASP Dependency-Check
- NIST NVD - National Vulnerability Database
- CVE - Common Vulnerabilities and Exposures
