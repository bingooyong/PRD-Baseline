#!/usr/bin/env python3
"""
Logback XML 配置审计工具
直接审计 logback-spring.xml 或 logback.xml 文件，无需手动转换 JSON
"""

import sys
import json
import xml.etree.ElementTree as ET
import subprocess
import os
from pathlib import Path

def parse_logback_xml(xml_file):
    """解析 logback XML 配置文件，转换为 OPA 可审计的 JSON 格式"""
    try:
        tree = ET.parse(xml_file)
        root = tree.getroot()
    except Exception as e:
        print(f"❌ 错误: 无法解析 XML 文件: {e}", file=sys.stderr)
        sys.exit(1)
    
    config = {
        "appenders": [],
        "root": {},
        "loggers": []
    }
    
    # 解析 appenders
    for appender in root.findall(".//appender"):
        appender_name = appender.get("name", "")
        appender_class = appender.get("class", "")
        
        appender_config = {
            "name": appender_name,
            "class": appender_class
        }
        
        # 解析 rollingPolicy
        rolling_policy = appender.find(".//rollingPolicy")
        if rolling_policy is not None:
            policy_class = rolling_policy.get("class", "")
            appender_config["rollingPolicy"] = {
                "class": policy_class
            }
            
            # 解析 rollingPolicy 的子元素
            max_file_size = rolling_policy.find("maxFileSize")
            if max_file_size is not None:
                appender_config["rollingPolicy"]["maxFileSize"] = max_file_size.text or ""
            
            max_history = rolling_policy.find("maxHistory")
            if max_history is not None:
                max_history_value = max_history.text or ""
                # 尝试转换为数字（如果是变量则保持原样）
                try:
                    appender_config["rollingPolicy"]["maxHistory"] = int(max_history_value)
                except ValueError:
                    appender_config["rollingPolicy"]["maxHistory"] = max_history_value
            
            total_size_cap = rolling_policy.find("totalSizeCap")
            if total_size_cap is not None:
                appender_config["rollingPolicy"]["totalSizeCap"] = total_size_cap.text or ""
            
            file_name_pattern = rolling_policy.find("fileNamePattern")
            if file_name_pattern is not None:
                appender_config["rollingPolicy"]["fileNamePattern"] = file_name_pattern.text or ""
        
        # 检查是否是 AsyncAppender
        if "AsyncAppender" in appender_class:
            appender_ref = appender.find("appender-ref")
            if appender_ref is not None:
                appender_config["appender-ref"] = appender_ref.get("ref", "")
        
        config["appenders"].append(appender_config)
    
    # 解析 root logger 的 appender-ref
    root_logger = root.find("root")
    if root_logger is not None:
        level = root_logger.get("level", "INFO")
        config["root"] = {"level": level}
        
        # 解析 root logger 的 appender-ref
        root_appender_refs = []
        for appender_ref in root_logger.findall("appender-ref"):
            ref_name = appender_ref.get("ref", "")
            if ref_name:
                root_appender_refs.append(ref_name)
        if root_appender_refs:
            config["root"]["appender-ref"] = root_appender_refs
    
    # 解析所有 logger 的 appender-ref
    for logger in root.findall("logger"):
        logger_name = logger.get("name", "")
        logger_level = logger.get("level", "")
        
        logger_config = {
            "name": logger_name
        }
        if logger_level:
            logger_config["level"] = logger_level
        
        # 解析 logger 的 appender-ref
        logger_appender_refs = []
        for appender_ref in logger.findall("appender-ref"):
            ref_name = appender_ref.get("ref", "")
            if ref_name:
                logger_appender_refs.append(ref_name)
        if logger_appender_refs:
            logger_config["appender-ref"] = logger_appender_refs
        
        config["loggers"].append(logger_config)
    
    return {"logback_config": config}

def run_opa_audit(json_config, opa_rule_file):
    """运行 OPA 审计"""
    # 将 JSON 配置写入临时文件
    import tempfile
    with tempfile.NamedTemporaryFile(mode='w', suffix='.json', delete=False) as f:
        json.dump(json_config, f, indent=2, ensure_ascii=False)
        temp_json_file = f.name
    
    try:
        # 运行 OPA eval
        cmd = [
            "opa", "eval",
            "data.logback.audit.audit",
            "-d", opa_rule_file,
            "-i", temp_json_file
        ]
        
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            check=False
        )
        
        if result.returncode != 0:
            print(f"❌ OPA 执行错误:\n{result.stderr}", file=sys.stderr)
            return None
        
        # 解析 OPA 输出
        opa_output = json.loads(result.stdout)
        if opa_output.get("result"):
            return opa_output["result"][0]["expressions"][0]["value"]
        
        return None
        
    finally:
        # 清理临时文件
        os.unlink(temp_json_file)

def format_audit_result(audit_result):
    """格式化审计结果输出"""
    if not audit_result:
        print("❌ 无法获取审计结果")
        return
    
    allowed = audit_result.get("allowed", False)
    violations = audit_result.get("violations", [])
    baseline_id = audit_result.get("baseline_id", "")
    baseline_version = audit_result.get("baseline_version", "")
    
    print(f"\n{'='*60}")
    print(f"📋 Logback 配置审计报告")
    print(f"{'='*60}")
    print(f"Baseline: {baseline_id} v{baseline_version}")
    print(f"审计结果: {'✅ 通过' if allowed else '❌ 不通过'}")
    print(f"{'='*60}\n")
    
    if allowed:
        print("✅ 配置符合 Baseline 要求，可以部署到生产环境。\n")
        return
    
    print(f"⚠️  发现 {len(violations)} 个违规项:\n")
    
    for i, violation in enumerate(violations, 1):
        req_id = violation.get("requirement_id", "")
        title = violation.get("title", "")
        level = violation.get("level", "")
        violation_msg = violation.get("violation", "")
        expected = violation.get("expected", "")
        
        print(f"{i}. [{level}] {req_id}: {title}")
        print(f"   问题: {violation_msg}")
        print(f"   要求: {expected}")
        print()
    
    print(f"{'='*60}")
    print("🚨 建议: 修复上述违规项后再部署到生产环境")
    print(f"{'='*60}\n")

def main():
    if len(sys.argv) < 2:
        print("用法: audit-logback-xml.py <logback-xml-file> [opa-rule-file]")
        print("\n示例:")
        print("  audit-logback-xml.py logback-spring.xml")
        print("  audit-logback-xml.py logback-spring.xml opa/rules/logback-audit.rego")
        sys.exit(1)
    
    xml_file = sys.argv[1]
    
    # 默认使用项目中的 OPA 规则文件
    script_dir = Path(__file__).parent.parent
    default_opa_rule = script_dir / "opa" / "rules" / "logback-audit.rego"
    
    if len(sys.argv) >= 3:
        opa_rule_file = sys.argv[2]
    else:
        opa_rule_file = str(default_opa_rule)
    
    # 检查文件是否存在
    if not os.path.exists(xml_file):
        print(f"❌ 错误: XML 文件不存在: {xml_file}", file=sys.stderr)
        sys.exit(1)
    
    if not os.path.exists(opa_rule_file):
        print(f"❌ 错误: OPA 规则文件不存在: {opa_rule_file}", file=sys.stderr)
        sys.exit(1)
    
    # 解析 XML
    print(f"📄 正在解析: {xml_file}")
    json_config = parse_logback_xml(xml_file)
    
    # 运行审计
    print(f"🔍 正在审计: {opa_rule_file}")
    audit_result = run_opa_audit(json_config, opa_rule_file)
    
    # 输出结果
    format_audit_result(audit_result)
    
    # 返回退出码（0=通过，1=不通过）
    if audit_result and audit_result.get("allowed", False):
        sys.exit(0)
    else:
        sys.exit(1)

if __name__ == "__main__":
    main()
