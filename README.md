# PRD Baseline 仓库

## 📋 概述

PRD Baseline 仓库是 B 端产品的"需求操作系统"，提供企业级产品的标准化需求基线。本仓库专注于：

- ✅ **安全性** - 企业级安全要求
- ✅ **合规性** - 法律法规和行业标准合规
- ✅ **SDL** - 安全开发生命周期集成
- ✅ **可复用** - 标准化的需求基线，可直接引用

## 🎯 核心价值

### 为什么需要 PRD Baseline？

B 端产品 60-70% 的需求是可以"领域标准化"的，真正不可复用的只有业务规则和差异化体验。

PRD Baseline 的价值：

1. **产品经理** - 不再从 0 写需求，选择 + 引用 + 偏离说明
2. **AI 辅助** - 直接作为 Context，生成代码/测试/架构
3. **研发团队** - 明确"不可争论的底线"，减少反复沟通
4. **安全/合规** - 可审计、可追责、可版本对比

## 📁 仓库结构

本仓库提供两种格式的 Baseline：

1. **Markdown 格式** - 人类可读的文档格式（`01-identity-access/` 等目录）
2. **YAML 格式** - 机器可执行的规范格式（`baselines/` 目录）

```
prd-baseline/
├── baselines/                  # YAML 格式 Baseline（机器可执行）
│   ├── identity-access/
│   │   └── login-authentication.yaml
│   ├── capacity/               # 容量管理（TOP1, TOP3）
│   │   ├── logging-storage.yaml      # 日志与文件存储容量治理
│   │   └── database-retention.yaml    # 数据库容量与历史数据治理
│   ├── memory/                 # 内存管理（TOP2）
│   │   └── memory-management.yaml    # 内存管理与 OOM 防护（基础版）
│   ├── resource/               # 资源管理（TOP2 - 专业版）
│   │   └── memory-exhaustion.yaml     # 内存与资源耗尽治理（企业级）
│   ├── config/                 # 配置治理（TOP4）
│   │   └── config-governance.yaml     # 配置治理基线
│   ├── certificate/            # 证书管理（TOP5）
│   │   └── certificate-lifecycle.yaml # 证书与密钥生命周期管理
│   ├── concurrency/            # 并发管理（TOP6）
│   │   └── concurrency-pool.yaml      # 并发与连接池管理
│   ├── time/                   # 时间同步（TOP7）
│   │   └── time-sync.yaml             # 时间同步与时区基线
│   ├── dependency/             # 依赖韧性（TOP8）
│   │   └── dependency-resilience.yaml # 依赖韧性及外部服务基线
│   └── observability/          # 可观测性（TOP10）
│       └── observability-baseline.yaml # 可观测性与监控基线
│   ├── logging/                # 日志基线（抽象层）
│   │   └── logging-baseline.yaml      # ID-LOG-BASE: 统一日志基线要求
│   └── implementations/        # 实现层 Baseline（具体框架）
│       ├── logging/
│       │   ├── logrotate-baseline.yaml    # Logrotate 系统级实现
│       │   ├── logback-baseline.yaml      # Logback Java/Spring 实现
│       │   ├── log4j2-baseline.yaml       # Log4j2 Java 实现
│       │   └── zap-baseline.yaml          # Zap Go 实现
│       └── database/
│           └── database-logging-baseline.yaml # 数据库日志与表容量实现
│
├── schema/                     # YAML Schema 定义
│   └── baseline.schema.yaml
│
├── mappings/                   # 外部标准映射
│   ├── owasp-asvs.yaml
│   └── nist-800-63.yaml
│
├── deviations/                 # 偏离管理
│   └── README.md
├── opa/                       # OPA 审计规则
│   ├── rules/                 # Rego 规则文件
│   ├── tests/                 # 测试用例
│   ├── prompts/               # AI Prompt 模板
│   └── integration/           # 集成示例
└── docs/                      # 文档
    ├── references-and-standards.md  # 参考标准
    └── ai-audit-guide.md           # AI 自动审计指南
│
├── 00-governance/              # 治理层（Markdown）
│   ├── baseline-versioning.md
│   ├── deviation-management.md
│   └── risk-acceptance.md
│
├── 01-identity-access/         # 身份与访问（Markdown）
│   ├── login-authentication.md
│   ├── password-policy.md
│   ├── mfa.md
│   ├── session-management.md
│   ├── account-lifecycle.md
│   └── sso-oauth-saml.md
│
├── 02-authorization/           # 授权（Markdown）
│   ├── rbac.md
│   ├── abac.md
│   ├── permission-model.md
│   ├── privilege-escalation.md
│   └── admin-boundary.md
│
├── 03-data-security/           # 数据安全（Markdown）
│   ├── data-classification.md
│   ├── encryption-at-rest.md
│   ├── encryption-in-transit.md
│   ├── key-management.md
│   ├── secret-management.md
│   └── pii-masking.md
│
├── 04-audit-compliance/        # 审计合规（Markdown）
│   ├── audit-log.md
│   ├── operation-traceability.md
│   ├── compliance-retention.md
│   ├── evidence-export.md
│   └── tamper-resistance.md
│
├── 05-secure-development-sdl/  # 安全开发 SDL（Markdown）
│   ├── threat-modeling.md
│   ├── secure-coding-baseline.md
│   ├── dependency-security.md
│   ├── vulnerability-management.md
│   ├── security-testing.md
│   └── release-gate.md
│
└── [其他目录...]
```

## 📖 文档格式说明

### Markdown 格式（人类可读）

每个 Baseline 文档遵循统一的格式：

1. **文档元信息** - Baseline-ID、版本、所有者等
2. **适用范围** - In Scope / Out of Scope
3. **设计目标** - Security Objectives
4. **要求条款** - 每个要求有唯一编号（如 AUTH-01）
5. **验收标准** - Acceptance Criteria
6. **合规映射** - 外部标准引用
7. **偏离管理** - Deviation Process

### YAML 格式（机器可执行）

YAML 格式提供结构化、可验证的规范：

#### 核心优势

1. **AI 友好** - 结构化数据，语义清晰
2. **可验证** - 支持 Schema 验证
3. **可自动化** - CI/CD 可直接消费
4. **可映射** - 映射到外部标准（OWASP、NIST）

#### YAML 结构

```yaml
baseline:
  id: ID-AUTH-LOGIN
  name: Login & Authentication Baseline
  version: "1.0.0"
  status: Approved

requirements:
  - id: AUTH-08
    title: Failure Count and Account Lockout
    level: MUST
    rules:
      max_failed_attempts: 5
      lockout_duration_minutes: 15
    verification:
      type: security_test
      evidence: account_lockout_scenarios
    references:
      - standard: OWASP-ASVS
        section: V2.2

acceptance:
  - id: AUTH-AC-01
    scenario: Account lockout after consecutive failures
    expected_result:
      account_locked: true
      login_denied: true
```

### 要求级别定义

- **MUST** - 必须满足，不允许偏离
- **SHOULD** - 应该满足，偏离需要说明理由
- **MAY** - 可选，根据实际情况决定

## 🚀 使用方法

### 1. 引用 Baseline

#### Markdown 格式（人类可读）

在项目 PRD 中引用 Baseline：

```yaml
baselines:
  - name: login-authentication
    version: 1.0.0
    path: 01-identity-access/login-authentication.md
  - name: password-policy
    version: 1.0.0
    path: 01-identity-access/password-policy.md
```

#### YAML 格式（机器可执行）

YAML 格式可直接被 AI 和自动化工具消费：

```yaml
# 在 CI/CD 中验证 Baseline 合规性
baseline_validation:
  baseline_file: baselines/identity-access/login-authentication.yaml
  schema: schema/baseline.schema.yaml
  check_requirements:
    - AUTH-08  # 登录失败锁定
    - AUTH-13  # 会话生成
    - AUTH-20  # 审计日志
```

### 2. AI 辅助使用

#### 使用 Markdown 格式

将 Baseline 文档作为 AI 的 Context，生成：

- 技术架构设计
- 代码实现
- 测试用例
- 安全评审清单

#### 使用 YAML 格式（推荐）

YAML 格式对 AI 更友好，结构化数据便于：

- **语义理解** - AI 可以稳定抽取 requirements、rules、verification
- **代码生成** - 基于 requirements 生成实现代码
- **测试生成** - 基于 acceptance criteria 生成测试用例
- **合规检查** - 基于 verification 类型生成检查清单

示例 Prompt：

```
请基于以下 Baseline YAML 生成登录认证功能的实现代码：

[baselines/identity-access/login-authentication.yaml 内容]

重点关注：
- AUTH-08: 登录失败锁定机制
- AUTH-13: 会话生成逻辑
- AUTH-20: 审计日志记录
```

### 3. 自动化检查

#### OPA 审计（推荐）

使用 OPA Rego 规则进行自动化审计：

```bash
# 审计 Logback 配置
echo '{"logback_config": {...}}' | opa eval \
  --data opa/rules/logback-audit.rego \
  --input - \
  --format json \
  'data.logback.audit.audit'

# 审计 Tomcat Console 日志配置
echo '{"tomcat_config": {...}}' | opa eval \
  --data opa/rules/tomcat-console-audit.rego \
  --input - \
  --format json \
  'data.tomcat.audit.audit'
```

详见：[AI 自动审计指南](./docs/ai-audit-guide.md) | [OPA 快速开始](./opa/QUICKSTART.md)

#### CI/CD 集成

```yaml
# .github/workflows/baseline-check.yml
name: Baseline Compliance Check

on: [push, pull_request]

jobs:
  audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Install OPA
        run: |
          curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64
          chmod +x opa && sudo mv opa /usr/local/bin/
      
      - name: Audit Logback Configuration
        run: |
          python3 opa/integration/ai-agent-integration.py \
            src/main/resources/logback-spring.xml \
            conf/server.xml
      
      - name: Validate Baseline YAML
        run: |
          # 验证 YAML 格式
          yamllint baselines/**/*.yaml
          # 验证 Schema
          check-jsonschema --schemafile schema/baseline.schema.yaml \
            baselines/**/*.yaml
```

#### SDL Gate 集成

在发布门禁中检查 Baseline 合规性：

```yaml
release_gate:
  baseline_compliance:
    - baseline: ID-AUTH-LOGIN
      requirements:
        - AUTH-08  # MUST
        - AUTH-13  # MUST
        - AUTH-20  # MUST
      verification:
        - code_review
        - security_test
        - functional_test
```

### 4. 偏离说明

如果需要偏离 Baseline，必须说明：

#### Markdown 格式

```markdown
## 偏离说明

### 偏离的 Baseline
- `login-authentication@1.0.0` - 登录失败锁定策略

### 偏离原因
业务场景特殊，需要更严格的锁定策略

### 替代方案
- 连续失败 3 次锁定（而非 5 次）
- 锁定时间 30 分钟（而非 15 分钟）

### 风险评估
- 安全风险：低（更严格）
- 用户体验风险：中（可能影响正常用户）
```

#### YAML 格式（推荐）

创建偏离申请文件：`deviations/ID-AUTH-LOGIN-project-2024-01-15.yaml`

```yaml
deviation:
  id: DEV-2024-001
  baseline_id: ID-AUTH-LOGIN
  requirement_id: AUTH-08
  deviation_type: modification
  reason: "业务场景特殊，需要更严格的锁定策略"
  risk_assessment:
    security_risk: low
    compliance_risk: low
    business_risk: medium
  approval:
    status: approved
    approver: security-officer@example.com
    approval_date: "2024-01-15"
```

详见 `deviations/README.md`

## 📚 标准化需求分类

### 必须标准化的需求（60-70%）

#### 安全与合规
1. **身份与访问** - 登录、认证、会话管理
2. **授权** - RBAC、ABAC、权限模型
3. **数据安全** - 加密、密钥管理、数据分类
4. **审计合规** - 日志、追溯、合规保留
5. **安全开发** - 威胁建模、安全编码、漏洞管理

#### 生产稳定性（本地化/私有化部署 TOP10 事故防护）
6. **容量管理** - 磁盘、日志、数据库容量（TOP1, TOP3）
7. **内存管理** - OOM 防护、内存泄漏（TOP2）
8. **配置治理** - 配置验证、版本控制、配置漂移（TOP4）
9. **证书管理** - 证书生命周期、自动续期（TOP5）
10. **并发管理** - 线程池、连接池、资源限制（TOP6）
11. **时间同步** - NTP、时区、时间一致性（TOP7）
12. **依赖韧性** - 超时、熔断、降级（TOP8）
13. **可观测性** - 监控、告警、SLO（TOP10）

#### 其他标准化需求
14. **可用性与韧性** - 限流、熔断、灾备
15. **API 安全** - 认证、限流、版本管理
16. **前端安全** - XSS、CSRF、CSP
17. **多租户** - 隔离、生命周期、配额

### 不可标准化的需求（30-40%）

- 业务规则
- 差异化体验
- 特定行业需求

## 🎯 生产事故防护 Baseline 覆盖

基于本地化/私有化部署场景的 TOP10 生产事故，本仓库提供对应的 Baseline：

| 排名 | 事故类型 | Baseline | 状态 |
|------|---------|----------|------|
| 🥇 TOP1 | 磁盘耗尽 | `ID-CAP-LOG`, `ID-CAP-DATA` | ✅ 已覆盖 |
| 🥈 TOP2 | 内存泄漏/OOM | `ID-MEM-MGMT`<br>`ID-RES-MEM` | ✅ 已覆盖<br>（推荐使用 `ID-RES-MEM`） |
| 🥉 TOP3 | 数据库容量/性能劣化 | `ID-CAP-DATA` | ✅ 已覆盖 |
| 🏅 TOP4 | 配置错误/配置漂移 | `ID-CFG-GOV` | ✅ 已覆盖 |
| 🏅 TOP5 | 证书/密钥过期 | `ID-CERT-LC` | ✅ 已覆盖 |
| 🏅 TOP6 | 线程/连接池耗尽 | `ID-CONC-POOL` | ✅ 已覆盖 |
| 🏅 TOP7 | 时间问题 | `ID-TIME-SYNC` | ✅ 已覆盖 |
| 🏅 TOP8 | 依赖不可用/阻塞 | `ID-DEP-RES` | ✅ 已覆盖 |
| 🏅 TOP9 | 权限/误操作 | `02-authorization/` | ✅ 已覆盖 |
| 🏅 TOP10 | 监控缺失/告警失效 | `ID-OBS-BASE` | ✅ 已覆盖 |

**结论**: TOP10 生产事故中，**至少 7 个可以在需求阶段通过 Baseline 消灭**。

## 🔒 安全与合规

### 覆盖的安全标准

- OWASP ASVS (Application Security Verification Standard)
- OWASP Top 10
- NIST SP 800 系列
- ISO/IEC 27001:2022
- PCI-DSS（如适用）
- 等保要求（如适用）

### 覆盖的合规要求

- GDPR（如适用）
- 个人信息保护法（如适用）
- SOX（如适用）
- 行业特定合规要求

## 📝 贡献指南

### 如何贡献

1. Fork 本仓库
2. 创建特性分支
3. 提交 PR，说明：
   - 新增/修改的 Baseline
   - 变更原因
   - 影响范围

### Baseline 更新原则

- **MAJOR 版本** - 不兼容变更（删除要求、重大策略调整）
- **MINOR 版本** - 新增要求（向后兼容）
- **PATCH 版本** - 文档修正、澄清说明

## 📄 许可证

[待定]

## 🔗 相关资源

### 外部标准

- [OWASP ASVS](https://owasp.org/www-project-application-security-verification-standard/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)
- [Microsoft SDL](https://www.microsoft.com/en-us/securityengineering/sdl/)

### 参考开源项目

- [OSSF Security Baseline](https://github.com/ossf/security-baseline) - 开源项目安全基线（YAML 格式）
- [ComplianceAsCode](https://github.com/ComplianceAsCode/content) - 安全与系统配置规则库
- [Kubernetes PodSecurity](https://kubernetes.io/docs/concepts/security/pod-security-standards/) - Pod 安全基线策略

### 文档

- [参考标准与开源仓库](./docs/references-and-standards.md) - 详细的参考项目说明

## 📧 联系方式

[待定]

---

**最后更新**: 2024-01-01

**版本**: 1.0.0
