# Baseline 工具脚本

## audit-logback-xml.py / audit-logback.sh

**Logback XML 配置审计工具** - 直接审计 logback-spring.xml 或 logback.xml 文件，无需手动转换 JSON。

### 使用方法

```bash
# Python 版本（推荐）
python3 scripts/audit-logback-xml.py logback-spring.xml

# Shell 版本（更简单）
./scripts/audit-logback.sh logback-spring.xml

# 指定自定义 OPA 规则文件
python3 scripts/audit-logback-xml.py logback-spring.xml opa/rules/logback-audit.rego
```

### 输出示例

```
📄 正在解析: logback-spring.xml
🔍 正在审计: opa/rules/logback-audit.rego

============================================================
📋 Logback 配置审计报告
============================================================
Baseline: ID-LOG-LOGBACK v1.0.0
审计结果: ❌ 不通过
============================================================

⚠️  发现 4 个违规项:

1. [MUST] LOG-LOGBACK-01: RollingFileAppender Configuration
   问题: TimeBasedRollingPolicy alone is forbidden
   要求: SizeAndTimeBasedRollingPolicy

2. [MUST] LOG-LOGBACK-02: File Size Limit
   问题: maxFileSize is not configured
   要求: maxFileSize <= 50MB (absolute max 100MB)
...
```

### CI/CD 集成

```yaml
# GitHub Actions 示例
- name: Audit Logback Configuration
  run: |
    python3 scripts/audit-logback-xml.py \
      src/main/resources/logback-spring.xml
  continue-on-error: false
```

### 退出码

- `0`: 配置通过审计，符合 Baseline
- `1`: 配置未通过审计，存在违规项

---

## check_baseline.py

Baseline 合规性检查工具。

### 使用方法

```bash
# 检查所有要求
python scripts/check_baseline.py \
  --baseline baselines/identity-access/login-authentication.yaml

# 只检查 MUST 级别要求
python scripts/check_baseline.py \
  --baseline baselines/identity-access/login-authentication.yaml \
  --level MUST

# 输出 JSON 格式
python scripts/check_baseline.py \
  --baseline baselines/identity-access/login-authentication.yaml \
  --output json
```

### 输出示例

```
============================================================
Baseline Compliance Report (Level: MUST)
============================================================

Total Requirements: 15
  MUST:  15
  SHOULD: 0
  MAY:   0

ID           Level    Verification          Status
------------------------------------------------------------
AUTH-01      MUST     design_review         pending
AUTH-03      MUST     code_review           pending
AUTH-04      MUST     automated_test        pending
...
```

## 扩展功能

可以扩展脚本以支持：

- 实际验证证据文件是否存在
- 生成合规性报告
- 集成到 CI/CD 流程
- 生成测试用例
