# 威胁建模 Baseline

## 概述

本文档定义了 B 端产品威胁建模的标准要求，在需求阶段识别和评估安全威胁。

## 威胁建模范围

**Level: MUST**

**Requirements:**
- 以下场景 MUST 进行威胁建模：
  - 新系统设计
  - 重大功能变更
  - 架构变更
  - 第三方集成
- 威胁建模 SHOULD 在需求/设计阶段执行

## 威胁建模方法

**Level: SHOULD**

**Requirements:**
- 威胁建模 SHOULD 使用标准方法（如 STRIDE、PASTA、Attack Trees）
- 威胁建模 SHOULD 覆盖以下维度：
  - **S**poofing（身份伪造）
  - **T**ampering（数据篡改）
  - **R**epudiation（否认）
  - **I**nformation Disclosure（信息泄露）
  - **D**enial of Service（拒绝服务）
  - **E**levation of Privilege（权限提升）

## 威胁识别

**Level: MUST**

**Requirements:**
- 威胁识别 MUST 覆盖：
  - 身份认证威胁
  - 授权威胁
  - 数据保护威胁
  - 输入验证威胁
  - 错误处理威胁
  - 日志监控威胁
- 威胁识别 SHOULD 参考 OWASP Top 10、CWE Top 25

## 威胁评估

**Level: MUST**

**Requirements:**
- 威胁评估 MUST 包括：
  - 威胁可能性（高/中/低）
  - 威胁影响（严重/高/中/低）
  - 风险等级（基于可能性和影响）
- 威胁评估 SHOULD 使用标准矩阵

## 威胁缓解

**Level: MUST**

**Requirements:**
- 识别的威胁 MUST 制定缓解措施
- 缓解措施 SHOULD 包括：
  - 安全控制措施
  - 安全编码要求
  - 安全测试要求
- 缓解措施 MUST 纳入开发计划

## 威胁建模文档

**Level: MUST**

**Requirements:**
- 威胁建模结果 MUST 文档化
- 威胁建模文档 SHOULD 包括：
  - 系统架构图
  - 数据流图
  - 威胁列表
  - 威胁评估结果
  - 缓解措施
- 威胁建模文档 MUST 版本管理

## 威胁建模评审

**Level: MUST**

**Requirements:**
- 威胁建模结果 MUST 经过安全团队评审
- 威胁建模评审 SHOULD 在需求评审前完成
- 威胁建模评审结果 MUST 记录

## References

- OWASP Threat Modeling
- STRIDE Threat Modeling
- NIST SP 800-154 - Guide to Data-Centric System Threat Modeling
- Microsoft SDL Threat Modeling
