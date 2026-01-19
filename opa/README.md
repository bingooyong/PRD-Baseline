# OPA 审计规则

## 📋 概述

本目录包含基于 Baseline 的 OPA (Open Policy Agent) 审计规则，用于自动化检查配置是否符合 Baseline 要求。

## 🏗️ 目录结构

```
opa/
├── rules/                    # Rego 规则文件
│   ├── logback-audit.rego          # Logback 配置审计规则
│   └── tomcat-console-audit.rego   # Tomcat Console 日志审计规则
├── tests/                   # 测试用例
│   ├── logback-audit.test.rego
│   └── tomcat-console-audit.test.rego
├── prompts/                 # AI Prompt 模板
│   └── baseline-to-rego-prompt.md  # Baseline 转 Rego 的 Prompt
└── integration/             # 集成示例
    ├── ci-cd-integration.sh        # CI/CD 集成脚本
    └── ai-agent-integration.py     # AI Agent 集成示例
```

## 🚀 快速开始

### 1. 安装 OPA

```bash
# macOS
brew install opa

# Linux
curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64
chmod +x opa
sudo mv opa /usr/local/bin/
```

### 2. 测试规则

```bash
# 运行 Logback 审计规则测试
opa test opa/rules/logback-audit.rego opa/tests/logback-audit.test.rego

# 运行 Tomcat 审计规则测试
opa test opa/rules/tomcat-console-audit.rego opa/tests/tomcat-console-audit.test.rego
```

### 3. 手动审计

```bash
# 审计 Logback 配置
echo '{"logback_config": {...}}' | opa eval \
  --data opa/rules/logback-audit.rego \
  --input - \
  --format json \
  'data.logback.audit.audit'

# 审计 Tomcat 配置
echo '{"tomcat_config": {...}}' | opa eval \
  --data opa/rules/tomcat-console-audit.rego \
  --input - \
  --format json \
  'data.tomcat.audit.audit'
```

## 📝 规则说明

### Logback 审计规则

**文件**: `rules/logback-audit.rego`

**检查项**:
- ✅ LOG-LOGBACK-01: RollingFileAppender + SizeAndTimeBasedRollingPolicy
- ✅ LOG-LOGBACK-02: 文件大小限制（50MB 默认，100MB 最大）
- ✅ LOG-LOGBACK-03: maxHistory 必须设置且有限（≤30）
- ✅ LOG-LOGBACK-04: totalSizeCap 必须配置
- ✅ LOG-LOGBACK-05: 必须使用 AsyncAppender
- ✅ LOG-LOGBACK-06: 生产环境必须使用 INFO 级别

### Tomcat Console 日志审计规则

**文件**: `rules/tomcat-console-audit.rego`

**检查项**:
- ✅ LOG-CONSOLE-01: 生产环境禁止 console 日志输出
- ✅ LOG-CONSOLE-02: 必须启用文件日志
- ✅ LOG-CONSOLE-03: 文件日志必须启用滚动

## 🤖 AI 自动生成规则

### 使用 Prompt 模板生成 Rego

```bash
# 1. 读取 Baseline YAML
BASELINE=$(cat baselines/implementations/logging/logback-baseline.yaml)

# 2. 填充 Prompt 模板
PROMPT=$(cat opa/prompts/baseline-to-rego-prompt.md | \
  sed "s/{baseline_yaml_content}/$BASELINE/g" | \
  sed "s/{baseline_id}/ID-LOG-LOGBACK/g" | \
  sed "s/{version}/1.0.0/g" | \
  sed "s/{domain}/logback/g" | \
  sed "s/{config_path}/logback_config/g")

# 3. 调用 AI 生成 Rego（示例，实际使用 GPT API）
echo "$PROMPT" | gpt-4-generate > opa/rules/logback-audit-generated.rego
```

## 🔗 CI/CD 集成

### GitHub Actions 示例

```yaml
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
          chmod +x opa
          sudo mv opa /usr/local/bin/
      
      - name: Audit Logback Configuration
        run: |
          python3 opa/integration/ai-agent-integration.py \
            src/main/resources/logback-spring.xml \
            conf/server.xml
```

### 本地 CI 脚本

```bash
# 运行 CI/CD 集成脚本
bash opa/integration/ci-cd-integration.sh
```

## 🧪 测试

### 运行所有测试

```bash
# 测试 Logback 规则
opa test opa/rules/logback-audit.rego opa/tests/logback-audit.test.rego -v

# 测试 Tomcat 规则
opa test opa/rules/tomcat-console-audit.rego opa/tests/tomcat-console-audit.test.rego -v
```

### 测试输出示例

```
PASS: logback.audit.test.test_valid_config
PASS: logback.audit.test.test_missing_max_file_size
PASS: logback.audit.test.test_max_file_size_exceeded
PASS: logback.audit.test.test_missing_total_size_cap
PASS: logback.audit.test.test_debug_level_forbidden
```

## 📊 审计结果格式

### 成功示例

```json
{
  "allowed": true,
  "violations": [],
  "baseline_id": "ID-LOG-LOGBACK",
  "baseline_version": "1.0.0"
}
```

### 失败示例

```json
{
  "allowed": false,
  "violations": [
    {
      "requirement_id": "LOG-LOGBACK-02",
      "level": "MUST",
      "title": "File Size Limit",
      "violation": "maxFileSize is not configured",
      "expected": "maxFileSize <= 50MB (absolute max 100MB)"
    }
  ],
  "baseline_id": "ID-LOG-LOGBACK",
  "baseline_version": "1.0.0"
}
```

## 🔄 工作流程

### 1. Baseline → Rego 生成流程

```
Baseline YAML
    ↓
AI Prompt (baseline-to-rego-prompt.md)
    ↓
GPT-4 / Claude 生成
    ↓
Rego 规则文件
    ↓
OPA 测试验证
    ↓
集成到 CI/CD
```

### 2. 运行时审计流程

```
配置文件 (XML/Properties)
    ↓
解析为 JSON
    ↓
OPA 审计 (Rego 规则)
    ↓
返回审计结果
    ↓
CI/CD 门禁 / 告警
```

## 🛠️ 扩展指南

### 添加新的审计规则

1. **创建 Baseline YAML**（如果还没有）
2. **使用 Prompt 模板生成 Rego**
3. **编写测试用例**
4. **集成到 CI/CD**

### 示例：添加 Log4j2 审计规则

```bash
# 1. 使用 Prompt 生成
BASELINE=$(cat baselines/implementations/logging/log4j2-baseline.yaml)
PROMPT=$(cat opa/prompts/baseline-to-rego-prompt.md | ...)
echo "$PROMPT" | gpt-4-generate > opa/rules/log4j2-audit.rego

# 2. 编写测试
# 参考 opa/tests/logback-audit.test.rego

# 3. 运行测试
opa test opa/rules/log4j2-audit.rego opa/tests/log4j2-audit.test.rego
```

## 📚 参考资源

- [OPA 官方文档](https://www.openpolicyagent.org/docs/latest/)
- [Rego 语言文档](https://www.openpolicyagent.org/docs/latest/policy-language/)
- [OPA Playground](https://play.openpolicyagent.org/) - 在线测试 Rego

## 🔗 相关文档

- [Baseline 参考标准](../docs/references-and-standards.md)
- [Logback Baseline](../baselines/implementations/logging/logback-baseline.yaml)
- [统一日志 Baseline](../baselines/implementations/logging/logging-baseline.yaml)
