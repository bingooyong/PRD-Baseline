#!/bin/bash
# Logback XML 配置审计工具 (Shell 版本)
# 用法: audit-logback.sh <logback-xml-file>

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASELINE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
OPA_RULE_FILE="$BASELINE_DIR/opa/rules/logback-audit.rego"

if [ $# -lt 1 ]; then
    echo "用法: $0 <logback-xml-file> [opa-rule-file]"
    echo ""
    echo "示例:"
    echo "  $0 logback-spring.xml"
    echo "  $0 logback-spring.xml opa/rules/logback-audit.rego"
    exit 1
fi

XML_FILE="$1"
if [ $# -ge 2 ]; then
    OPA_RULE_FILE="$2"
fi

# 检查文件是否存在
if [ ! -f "$XML_FILE" ]; then
    echo "❌ 错误: XML 文件不存在: $XML_FILE" >&2
    exit 1
fi

if [ ! -f "$OPA_RULE_FILE" ]; then
    echo "❌ 错误: OPA 规则文件不存在: $OPA_RULE_FILE" >&2
    exit 1
fi

# 使用 Python 脚本进行审计
echo "📄 正在审计: $XML_FILE"
python3 "$SCRIPT_DIR/audit-logback-xml.py" "$XML_FILE" "$OPA_RULE_FILE"

exit_code=$?
exit $exit_code
