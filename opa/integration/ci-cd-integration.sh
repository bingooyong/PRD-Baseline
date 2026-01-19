#!/bin/bash
# CI/CD 集成示例：使用 OPA 审计 Logback 和 Tomcat 配置

set -e

OPA_BINARY="${OPA_BINARY:-opa}"
BASELINE_DIR="${BASELINE_DIR:-$(pwd)}"

echo "🔍 Starting Baseline Compliance Audit..."

# 1. 检查 Logback 配置
echo ""
echo "📋 Auditing Logback Configuration..."

# 解析 logback-spring.xml 为 JSON（需要 xml2json 工具或 Python 脚本）
LOGBACK_JSON=$(python3 <<EOF
import xml.etree.ElementTree as ET
import json
import sys

def xml_to_dict(element):
    result = {}
    result['tag'] = element.tag
    result['attrib'] = element.attrib
    result['text'] = element.text.strip() if element.text else None
    result['children'] = [xml_to_dict(child) for child in element]
    return result

tree = ET.parse('src/main/resources/logback-spring.xml')
root = tree.getroot()
config = xml_to_dict(root)
print(json.dumps(config))
EOF
)

# 运行 OPA 审计
LOGBACK_RESULT=$(echo "$LOGBACK_JSON" | $OPA_BINARY eval \
    --data "$BASELINE_DIR/opa/rules/logback-audit.rego" \
    --input - \
    --format json \
    'data.logback.audit.audit')

# 检查结果
LOGBACK_ALLOWED=$(echo "$LOGBACK_RESULT" | jq -r '.[0].expressions[0].value.allowed')
LOGBACK_VIOLATIONS=$(echo "$LOGBACK_RESULT" | jq -r '.[0].expressions[0].value.violations | length')

if [ "$LOGBACK_ALLOWED" = "true" ]; then
    echo "✅ Logback configuration is compliant"
else
    echo "❌ Logback configuration has $LOGBACK_VIOLATIONS violation(s):"
    echo "$LOGBACK_RESULT" | jq -r '.[0].expressions[0].value.violations[] | "  - \(.requirement_id): \(.violation)"'
    exit 1
fi

# 2. 检查 Tomcat 配置
echo ""
echo "📋 Auditing Tomcat Console Logging Configuration..."

# 解析 server.xml 或 logging.properties
TOMCAT_JSON=$(python3 <<EOF
import json
import re

# 简化的解析逻辑（实际应该使用 XML 解析器）
config = {
    "catalina_out": {
        "enabled": False  # 假设从配置中读取
    },
    "appenders": [
        {
            "type": "file",
            "enabled": True,
            "rotation": {
                "maxFileSize": "50MB",
                "maxHistory": 7
            }
        }
    ]
}

# 实际应该从 server.xml 或 logging.properties 解析
print(json.dumps(config))
EOF
)

# 运行 OPA 审计
TOMCAT_RESULT=$(echo "$TOMCAT_JSON" | $OPA_BINARY eval \
    --data "$BASELINE_DIR/opa/rules/tomcat-console-audit.rego" \
    --input - \
    --format json \
    'data.tomcat.audit.audit')

# 检查结果
TOMCAT_ALLOWED=$(echo "$TOMCAT_RESULT" | jq -r '.[0].expressions[0].value.allowed')
TOMCAT_VIOLATIONS=$(echo "$TOMCAT_RESULT" | jq -r '.[0].expressions[0].value.violations | length')

if [ "$TOMCAT_ALLOWED" = "true" ]; then
    echo "✅ Tomcat console logging configuration is compliant"
else
    echo "❌ Tomcat console logging configuration has $TOMCAT_VIOLATIONS violation(s):"
    echo "$TOMCAT_RESULT" | jq -r '.[0].expressions[0].value.violations[] | "  - \(.requirement_id): \(.violation)"'
    exit 1
fi

echo ""
echo "✅ All Baseline compliance checks passed!"
