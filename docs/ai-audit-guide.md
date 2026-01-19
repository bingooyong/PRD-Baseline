# AI 自动审计指南

## 📋 概述

本文档说明如何使用 AI Agent 自动审计规则（OPA / Rego / GPT Prompt）来检查配置是否符合 Baseline 要求。

## 🎯 目标

基于 **Logback** 和 **Tomcat Console 日志** 两个检查点，实现 AI 自动审计。

## 🏗️ 架构方案

### 三层架构

```
┌─────────────────────────────────────┐
│  Baseline YAML (需求定义层)          │
│  - logback-baseline.yaml            │
│  - logging-baseline.yaml            │
└──────────────┬──────────────────────┘
               │
               ↓
┌─────────────────────────────────────┐
│  AI Prompt (规则生成层)              │
│  - baseline-to-rego-prompt.md       │
│  - GPT-4 / Claude 生成 Rego         │
└──────────────┬──────────────────────┘
               │
               ↓
┌─────────────────────────────────────┐
│  OPA Rego (规则执行层)              │
│  - logback-audit.rego               │
│  - tomcat-console-audit.rego        │
└──────────────┬──────────────────────┘
               │
               ↓
┌─────────────────────────────────────┐
│  审计结果 (CI/CD / 运行时)           │
│  - 通过/拒绝                         │
│  - 违规报告                          │
└─────────────────────────────────────┘
```

## 🚀 实施步骤

### 步骤 1: 准备 Baseline YAML

已有 Baseline 文件：
- `baselines/implementations/logging/logback-baseline.yaml`
- `baselines/implementations/logging/logging-baseline.yaml`

### 步骤 2: 使用 AI 生成 Rego 规则

#### 方法 A: 使用 Prompt 模板（推荐）

```bash
# 1. 读取 Baseline
BASELINE=$(cat baselines/implementations/logging/logback-baseline.yaml)

# 2. 填充 Prompt 模板
PROMPT=$(cat opa/prompts/baseline-to-rego-prompt.md | \
  sed "s/{baseline_yaml_content}/$BASELINE/g" | \
  sed "s/{baseline_id}/ID-LOG-LOGBACK/g" | \
  sed "s/{version}/1.0.0/g" | \
  sed "s/{domain}/logback/g" | \
  sed "s/{config_path}/logback_config/g")

# 3. 调用 GPT-4 / Claude
echo "$PROMPT" | gpt-4-generate > opa/rules/logback-audit.rego
```

#### 方法 B: 直接使用已有规则

已有规则文件：
- `opa/rules/logback-audit.rego` ✅
- `opa/rules/tomcat-console-audit.rego` ✅

### 步骤 3: 测试规则

```bash
# 安装 OPA
brew install opa  # macOS
# 或下载: https://www.openpolicyagent.org/docs/latest/#running-opa

# 运行测试
opa test opa/rules/logback-audit.rego opa/tests/logback-audit.test.rego -v
opa test opa/rules/tomcat-console-audit.rego opa/tests/tomcat-console-audit.test.rego -v
```

### 步骤 4: 集成到 CI/CD

#### GitHub Actions 示例

```yaml
name: Baseline Compliance Audit

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
          # 解析 logback-spring.xml 为 JSON
          python3 scripts/parse_logback_xml.py \
            src/main/resources/logback-spring.xml > /tmp/logback.json
          
          # 运行 OPA 审计
          opa eval \
            --data opa/rules/logback-audit.rego \
            --input /tmp/logback.json \
            --format json \
            'data.logback.audit.audit' | \
            jq -e '.[0].expressions[0].value.allowed == true'
      
      - name: Audit Tomcat Configuration
        run: |
          # 解析 Tomcat 配置为 JSON
          python3 scripts/parse_tomcat_config.py \
            conf/server.xml > /tmp/tomcat.json
          
          # 运行 OPA 审计
          opa eval \
            --data opa/rules/tomcat-console-audit.rego \
            --input /tmp/tomcat.json \
            --format json \
            'data.tomcat.audit.audit' | \
            jq -e '.[0].expressions[0].value.allowed == true'
```

### 步骤 5: 运行时审计（AI Agent 集成）

```python
# 在 AI Agent 执行前审计配置
from opa.integration.ai_agent_integration import audit_logback_config, audit_tomcat_config

# 审计 Logback
logback_result = audit_logback_config("src/main/resources/logback-spring.xml")
if not logback_result["allowed"]:
    print("❌ Logback configuration violations:")
    for v in logback_result["violations"]:
        print(f"  - {v['requirement_id']}: {v['violation']}")
    # 阻止部署或发送告警

# 审计 Tomcat
tomcat_result = audit_tomcat_config("conf/server.xml")
if not tomcat_result["allowed"]:
    print("❌ Tomcat configuration violations:")
    for v in tomcat_result["violations"]:
        print(f"  - {v['requirement_id']}: {v['violation']}")
```

## 📊 检查点详解

### 检查点 1: Logback 配置

**Baseline 要求**:
- ✅ 必须使用 RollingFileAppender
- ✅ 必须使用 SizeAndTimeBasedRollingPolicy
- ✅ maxFileSize ≤ 50MB（默认），≤ 100MB（绝对最大）
- ✅ maxHistory 必须设置（≤ 30）
- ✅ totalSizeCap 必须配置
- ✅ 必须使用 AsyncAppender
- ✅ 生产环境必须使用 INFO 级别

**Rego 规则**: `opa/rules/logback-audit.rego`

**测试用例**: `opa/tests/logback-audit.test.rego`

### 检查点 2: Tomcat Console 日志

**Baseline 要求**:
- ✅ 生产环境禁止 console 日志输出（catalina.out）
- ✅ 必须启用文件日志
- ✅ 文件日志必须启用滚动（maxFileSize, maxHistory）

**Rego 规则**: `opa/rules/tomcat-console-audit.rego`

**测试用例**: `opa/tests/tomcat-console-audit.test.rego`

## 🤖 AI Prompt 使用

### Prompt 模板位置

`opa/prompts/baseline-to-rego-prompt.md`

### 使用示例

```bash
# 完整流程：Baseline → Rego
cat <<EOF | gpt-4-generate
$(cat opa/prompts/baseline-to-rego-prompt.md)

## Baseline 定义

$(cat baselines/implementations/logging/logback-baseline.yaml)
EOF
```

### Prompt 优化建议

1. **分步骤生成**：先生成主函数，再生成检查函数
2. **迭代优化**：根据测试结果优化规则
3. **版本管理**：生成的 Rego 规则也要版本化

## 🔧 工具链

### 必需工具

- **OPA**: Policy 执行引擎
- **jq**: JSON 处理（CI/CD 脚本）
- **Python 3**: 配置解析脚本

### 可选工具

- **xml2json**: XML 转 JSON（用于解析 logback-spring.xml）
- **GPT-4 / Claude**: AI 规则生成

## 📈 扩展方向

### 1. 支持更多检查点

- [ ] Log4j2 配置审计
- [ ] Zap 配置审计
- [ ] 数据库配置审计
- [ ] 内存配置审计

### 2. 增强 AI 生成能力

- [ ] 自动生成测试用例
- [ ] 自动优化规则性能
- [ ] 自动生成文档

### 3. 运行时集成

- [ ] Kubernetes Admission Controller
- [ ] API Gateway 集成
- [ ] 服务网格集成

## 🎓 最佳实践

1. **规则版本化**: Rego 规则与 Baseline 版本对应
2. **测试覆盖**: 每个规则都要有测试用例
3. **CI/CD 门禁**: 违反 Baseline 的配置不能合并
4. **告警机制**: 运行时违规要发送告警
5. **文档同步**: Rego 规则变更要更新文档

## 🔗 相关资源

- [OPA 官方文档](https://www.openpolicyagent.org/docs/latest/)
- [Rego 语言文档](https://www.openpolicyagent.org/docs/latest/policy-language/)
- [OPA Playground](https://play.openpolicyagent.org/)
- [Baseline 参考标准](./references-and-standards.md)

---

**最后更新**: 2024-01-01
