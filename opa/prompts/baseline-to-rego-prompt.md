# Baseline to Rego 规则生成 Prompt 模板

## 用途

将 Baseline YAML 转换为 OPA Rego 审计规则。

## Prompt 模板

```
你是一个 Policy-as-Code 专家，擅长将 Baseline 需求转换为 OPA Rego 规则。

## 任务

基于以下 Baseline YAML 定义，生成对应的 OPA Rego 审计规则。

## Baseline 定义

{baseline_yaml_content}

## 要求

1. 生成完整的 Rego 规则文件
2. 每个 Baseline 要求（requirement）对应一个检查函数
3. 函数命名格式：check_{requirement_id}
4. 返回格式：
   - 如果符合要求：返回 null
   - 如果违反要求：返回 violation 对象，包含：
     - requirement_id: Baseline 要求 ID
     - level: MUST/SHOULD/MAY
     - title: 要求标题
     - violation: 违反描述
     - expected: 期望值

5. 主审计函数格式：
```rego
package {domain}.audit

audit[result] {
    config := input.{config_path}
    violations := check_all_requirements(config)
    result := {
        "allowed": count(violations) == 0,
        "violations": violations,
        "baseline_id": "{baseline_id}",
        "baseline_version": "{version}"
    }
}
```

6. 使用 future.keywords.if 和 future.keywords.in（OPA 新语法）

## 输出

生成完整的 Rego 规则文件，包含：
- Package 声明
- 导入语句
- 主审计函数
- 所有检查函数
- 辅助函数

## 示例格式

参考以下结构：

```rego
package {domain}.audit

import future.keywords.if
import future.keywords.in

default allow = false
default violations = []

audit[result] {
    config := input.{config_path}
    violations := check_all_requirements(config)
    result := {
        "allowed": count(violations) == 0,
        "violations": violations,
        "baseline_id": "{baseline_id}",
        "baseline_version": "{version}"
    }
}

check_all_requirements(config) = violations {
    violations := [
        v | v := check_requirement_01(config)
        v := check_requirement_02(config)
        v != null
    ]
}

check_requirement_01(config) = msg {
    # 检查逻辑
    condition_violated
    msg := {
        "requirement_id": "REQ-01",
        "level": "MUST",
        "title": "Requirement Title",
        "violation": "Violation description",
        "expected": "Expected value"
    }
}
```

现在请基于提供的 Baseline YAML 生成 Rego 规则。
```

## 使用示例

### 针对 Logback Baseline

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

# 3. 调用 AI 生成 Rego
echo "$PROMPT" | gpt-4-generate > opa/rules/logback-audit.rego
```

### 针对 Tomcat Console 日志

```bash
# 创建简化的 Baseline 定义
TOMCAT_BASELINE=$(cat <<EOF
requirements:
  - id: LOG-CONSOLE-01
    title: Console Logging Disabled
    level: MUST
    description: Production must disable console logging
  - id: LOG-CONSOLE-02
    title: File Logging Required
    level: MUST
    description: File logging must be enabled
EOF
)

# 生成 Rego
PROMPT=$(cat opa/prompts/baseline-to-rego-prompt.md | \
  sed "s/{baseline_yaml_content}/$TOMCAT_BASELINE/g" | \
  sed "s/{baseline_id}/ID-LOG-CONSOLE/g" | \
  sed "s/{version}/1.0.0/g" | \
  sed "s/{domain}/tomcat/g" | \
  sed "s/{config_path}/tomcat_config/g")

echo "$PROMPT" | gpt-4-generate > opa/rules/tomcat-console-audit.rego
```

## 优化建议

1. **分步骤生成**：先生成主函数，再生成检查函数
2. **迭代优化**：根据测试结果优化规则
3. **版本管理**：生成的 Rego 规则也要版本化
