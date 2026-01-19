# Baseline 偏离管理

## 概述

本目录用于存储 Baseline 偏离申请和审批记录。

## 偏离申请流程

1. 创建偏离申请文件（YAML 格式）
2. 提交 PR 进行评审
3. 安全团队审批
4. 记录在偏离管理系统中

## 偏离申请文件格式

文件名：`{baseline-id}-{project-name}-{date}.yaml`

示例：

```yaml
deviation:
  id: DEV-2024-001
  baseline_id: ID-AUTH-LOGIN
  project: Project-Name
  date: "2024-01-15"
  requester: developer@example.com
  
  requirements:
    - requirement_id: AUTH-08
      requirement_title: Failure Count and Account Lockout
      deviation_type: modification
      current_requirement: "连续失败 ≥ 5 次锁定"
      proposed_change: "连续失败 ≥ 3 次锁定"
      reason: >
        业务场景特殊，需要更严格的锁定策略
        用户反馈 5 次失败次数过多
      risk_assessment:
        security_risk: low
        compliance_risk: low
        business_risk: medium
        risk_details: >
          更严格的锁定策略可能影响正常用户体验
          但安全性更高
      alternative_solution: >
        实施更严格的锁定策略（3 次失败）
        增加自动解锁时间到 30 分钟
        增加用户通知机制
      approval:
        status: pending
        approver: null
        approval_date: null
```

## 偏离状态

- `pending` - 待审批
- `approved` - 已批准
- `rejected` - 已拒绝
- `withdrawn` - 已撤回

## 注意事项

- 所有偏离申请必须经过安全团队审批
- 偏离记录必须永久保留（用于审计）
- 偏离申请不应包含敏感信息
