#!/usr/bin/env python3
"""
AI Agent 集成示例：在 AI Agent 执行前后进行 Baseline 审计
"""

import json
import subprocess
import sys
from pathlib import Path

OPA_BINARY = "opa"
BASELINE_DIR = Path(__file__).parent.parent


def audit_logback_config(config_path: str) -> dict:
    """审计 Logback 配置"""
    # 1. 解析 XML 配置为 JSON
    config_json = parse_logback_xml(config_path)
    
    # 2. 调用 OPA 审计
    input_data = {"logback_config": config_json}
    
    result = run_opa_audit(
        policy="logback.audit",
        input_data=input_data
    )
    
    return result


def audit_tomcat_config(config_path: str) -> dict:
    """审计 Tomcat 配置"""
    # 1. 解析 Tomcat 配置为 JSON
    config_json = parse_tomcat_config(config_path)
    
    # 2. 调用 OPA 审计
    input_data = {"tomcat_config": config_json}
    
    result = run_opa_audit(
        policy="tomcat.audit",
        input_data=input_data
    )
    
    return result


def run_opa_audit(policy: str, input_data: dict) -> dict:
    """运行 OPA 审计"""
    policy_file = BASELINE_DIR / "opa" / "rules" / f"{policy.replace('.', '-')}.rego"
    
    # 构建 OPA 命令
    cmd = [
        OPA_BINARY,
        "eval",
        "--data", str(policy_file),
        "--input", "-",
        "--format", "json",
        f"data.{policy}.audit"
    ]
    
    # 执行 OPA
    process = subprocess.Popen(
        cmd,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )
    
    stdout, stderr = process.communicate(input=json.dumps(input_data))
    
    if process.returncode != 0:
        raise RuntimeError(f"OPA audit failed: {stderr}")
    
    # 解析结果
    result = json.loads(stdout)
    audit_result = result[0]["expressions"][0]["value"]
    
    return audit_result


def parse_logback_xml(xml_path: str) -> dict:
    """解析 Logback XML 配置为 JSON（简化版）"""
    import xml.etree.ElementTree as ET
    
    tree = ET.parse(xml_path)
    root = tree.getroot()
    
    # 简化的解析逻辑
    config = {
        "appenders": [],
        "root": {}
    }
    
    # 解析 appenders
    for appender in root.findall(".//appender"):
        appender_data = {
            "class": appender.get("class", ""),
            "name": appender.get("name", "")
        }
        
        # 解析 rollingPolicy
        rolling_policy = appender.find(".//rollingPolicy")
        if rolling_policy is not None:
            appender_data["rollingPolicy"] = {
                "class": rolling_policy.get("class", ""),
                "maxFileSize": rolling_policy.findtext("maxFileSize"),
                "maxHistory": rolling_policy.findtext("maxHistory"),
                "totalSizeCap": rolling_policy.findtext("totalSizeCap")
            }
        
        config["appenders"].append(appender_data)
    
    # 解析 root level
    root_elem = root.find(".//root")
    if root_elem is not None:
        config["root"]["level"] = root_elem.get("level", "")
    
    return config


def parse_tomcat_config(config_path: str) -> dict:
    """解析 Tomcat 配置为 JSON（简化版）"""
    # 实际应该解析 server.xml 或 logging.properties
    # 这里返回示例结构
    return {
        "catalina_out": {
            "enabled": False
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


def main():
    """主函数"""
    if len(sys.argv) < 3:
        print("Usage: python ai-agent-integration.py <logback_xml> <tomcat_config>")
        sys.exit(1)
    
    logback_path = sys.argv[1]
    tomcat_path = sys.argv[2]
    
    print("🔍 Auditing Logback Configuration...")
    logback_result = audit_logback_config(logback_path)
    
    if logback_result["allowed"]:
        print("✅ Logback configuration is compliant")
    else:
        print("❌ Logback configuration violations:")
        for violation in logback_result["violations"]:
            print(f"  - {violation['requirement_id']}: {violation['violation']}")
        sys.exit(1)
    
    print("\n🔍 Auditing Tomcat Console Logging Configuration...")
    tomcat_result = audit_tomcat_config(tomcat_path)
    
    if tomcat_result["allowed"]:
        print("✅ Tomcat console logging configuration is compliant")
    else:
        print("❌ Tomcat console logging configuration violations:")
        for violation in tomcat_result["violations"]:
            print(f"  - {violation['requirement_id']}: {violation['violation']}")
        sys.exit(1)
    
    print("\n✅ All Baseline compliance checks passed!")


if __name__ == "__main__":
    main()
