# Baseline 偏离管理

## 概述

本文档定义了当项目需要偏离 Baseline 要求时的管理流程和审批机制。

## 偏离定义

**Level: MUST**

偏离是指项目在实现过程中，无法完全满足 Baseline 要求的情况。

**偏离类型:**
- **技术偏离**: 技术限制导致无法实现
- **业务偏离**: 业务需求与 Baseline 冲突
- **临时偏离**: 短期方案，计划后续补齐
- **永久偏离**: 经评估后决定永久不遵循

## 偏离申请流程

**Level: MUST**

**Requirements:**
- 所有偏离 MUST 提交偏离申请文档
- 偏离申请 MUST 包含以下信息：
  - 偏离的 Baseline 条目（精确到章节）
  - 偏离原因和背景
  - 风险评估（安全、合规、业务）
  - 替代方案或补偿措施
  - 偏离期限（临时/永久）
  - 责任人签名

### 偏离申请模板

```markdown
## 偏离申请

**Baseline**: `baseline-name@version` - Section X.Y
**偏离类型**: [技术偏离/业务偏离/临时偏离/永久偏离]
**申请日期**: YYYY-MM-DD
**申请人**: Name
**项目**: Project Name

### 偏离内容
[详细描述偏离的具体要求]

### 偏离原因
[说明为什么需要偏离]

### 风险评估
- 安全风险: [高/中/低] - [详细说明]
- 合规风险: [高/中/低] - [详细说明]
- 业务风险: [高/中/低] - [详细说明]

### 替代方案
[描述替代实现方案或补偿措施]

### 审批记录
- 安全评审: [通过/拒绝] - Reviewer - Date
- 合规评审: [通过/拒绝] - Reviewer - Date
- 最终审批: [通过/拒绝] - Approver - Date
```

## 审批权限

**Level: MUST**

**Requirements:**
- **低风险偏离**（仅影响 SHOULD/MAY 级别）: 安全团队负责人审批
- **中风险偏离**（影响 MUST 级别，但有补偿措施）: 安全委员会审批
- **高风险偏离**（影响 MUST 级别，无有效补偿）: CISO + 合规负责人联合审批
- 所有偏离审批 MUST 记录在审计日志中

## 偏离跟踪

**Level: MUST**

**Requirements:**
- 所有偏离申请 MUST 登记在偏离管理系统中
- 临时偏离 MUST 设置到期提醒
- 偏离状态 MUST 定期审查（每季度）
- 偏离记录 MUST 纳入安全审计范围

## 补偿措施

**Level: SHOULD**

当无法满足 Baseline 要求时，SHOULD 提供补偿措施：

**常见补偿措施:**
- 增强监控和告警
- 增加人工审核流程
- 缩短审计日志保留期
- 限制功能使用范围
- 增加额外的安全控制

## 偏离关闭

**Level: MUST**

**Requirements:**
- 临时偏离到期前 MUST 评估是否已补齐
- 如未补齐，MUST 申请延期或转为永久偏离
- 偏离关闭时 MUST 更新状态并归档

## 禁止偏离的场景

**Level: MUST**

以下场景 **禁止偏离**，必须满足 Baseline 要求：

- 法律法规强制要求（如 GDPR、等保）
- 行业合规标准强制要求（如 PCI-DSS）
- 涉及客户数据安全的核心控制
- 涉及财务审计的关键要求

## References

- ISO/IEC 27001:2022 - Risk Management
- NIST SP 800-53 - Security Control Assessment
- OWASP ASVS - Application Security Verification Standard
