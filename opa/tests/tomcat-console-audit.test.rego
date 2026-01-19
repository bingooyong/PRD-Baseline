# Tomcat Console Audit Rules Tests

package tomcat.audit.test

import rego.v1
import data.tomcat.audit

# 测试用例 1: 符合 Baseline 的配置（禁用 console，启用文件日志）
test_valid_config if {
    test_input := {
        "tomcat_config": {
            "catalina_out": {
                "enabled": false
            },
            "appenders": [
                {
                    "type": "file",
                    "enabled": true,
                    "rotation": {
                        "maxFileSize": "50MB",
                        "maxHistory": 7
                    }
                }
            ]
        }
    }
    
    result := audit.audit with input as test_input
    result.allowed == true
    count(result.violations) == 0
}

# 测试用例 2: Console 日志启用（违反）
test_console_logging_enabled if {
    test_input := {
        "tomcat_config": {
            "catalina_out": {
                "enabled": true
            },
            "appenders": [
                {
                    "type": "file",
                    "enabled": true,
                    "rotation": {
                        "maxFileSize": "50MB",
                        "maxHistory": 7
                    }
                }
            ]
        }
    }
    
    result := audit.audit with input as test_input
    result.allowed == false
    violations := result.violations
    violation := violations[_]
    violation.requirement_id == "LOG-CONSOLE-01"
    violation.violation == "Console logging is enabled in production"
}

# 测试用例 3: 文件日志未启用（违反）
test_file_logging_disabled if {
    test_input := {
        "tomcat_config": {
            "catalina_out": {
                "enabled": false
            },
            "appenders": []
        }
    }
    
    result := audit.audit with input as test_input
    result.allowed == false
    violations := result.violations
    violation := violations[_]
    violation.requirement_id == "LOG-CONSOLE-02"
}

# 测试用例 4: 文件日志未启用滚动（违反）
test_log_rotation_disabled if {
    test_input := {
        "tomcat_config": {
            "catalina_out": {
                "enabled": false
            },
            "appenders": [
                {
                    "type": "file",
                    "enabled": true
                }
            ]
        }
    }
    
    result := audit.audit with input as test_input
    result.allowed == false
    violations := result.violations
    violation := violations[_]
    violation.requirement_id == "LOG-CONSOLE-03"
}
