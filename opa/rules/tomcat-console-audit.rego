# Tomcat Console Logging Audit Rules
# Tomcat Console 日志审计规则

package tomcat.audit

import rego.v1

# 默认允许，除非明确拒绝
default allow := false
default violations := []

# 主审计函数：检查 Tomcat console 日志配置
audit := result if {
    config := input.tomcat_config
    violations := check_tomcat_console_logging(config)
    result := {
        "allowed": count(violations) == 0,
        "violations": violations,
        "baseline_id": "ID-LOG-BASE",
        "baseline_version": "1.0.0"
    }
}

# 检查所有 Baseline 要求
check_tomcat_console_logging(config) := violations if {
    all_checks := [
        check_console_logging_disabled(config),
        check_file_logging_enabled(config),
        check_log_rotation_enabled(config)
    ]
    violations := [v | v := all_checks[_]; v != null]
}

# 禁止：生产环境禁止 console 日志输出
check_console_logging_disabled(config) := msg if {
    console_logging_enabled(config)
    msg := {
        "requirement_id": "LOG-CONSOLE-01",
        "level": "MUST",
        "title": "Console Logging Disabled",
        "violation": "Console logging is enabled in production",
        "expected": "Console logging must be disabled, use file logging instead"
    }
}

check_console_logging_disabled(config) := null if {
    not console_logging_enabled(config)
}

# 要求：必须启用文件日志
check_file_logging_enabled(config) := msg if {
    not file_logging_enabled(config)
    msg := {
        "requirement_id": "LOG-CONSOLE-02",
        "level": "MUST",
        "title": "File Logging Required",
        "violation": "File logging is not enabled",
        "expected": "File logging must be enabled with rotation"
    }
}

check_file_logging_enabled(config) := null if {
    file_logging_enabled(config)
}

# 要求：文件日志必须启用滚动
check_log_rotation_enabled(config) := msg if {
    file_logging_enabled(config)
    not log_rotation_enabled(config)
    msg := {
        "requirement_id": "LOG-CONSOLE-03",
        "level": "MUST",
        "title": "Log Rotation Required",
        "violation": "Log rotation is not enabled",
        "expected": "Log rotation must be enabled (maxFileSize, maxHistory)"
    }
}

check_log_rotation_enabled(config) := null if {
    not file_logging_enabled(config)
}

check_log_rotation_enabled(config) := null if {
    file_logging_enabled(config)
    log_rotation_enabled(config)
}

# 辅助函数
console_logging_enabled(config) if {
    # 检查 catalina.out 是否启用
    config.catalina_out.enabled == true
}

console_logging_enabled(config) if {
    # 检查是否有 console appender
    appender := config.appenders[_]
    appender.type == "console"
    appender.enabled == true
}

file_logging_enabled(config) if {
    # 检查是否有文件 appender
    appender := config.appenders[_]
    appender.type == "file"
    appender.enabled == true
}

log_rotation_enabled(config) if {
    appender := config.appenders[_]
    appender.type == "file"
    appender.rotation.maxFileSize != null
    appender.rotation.maxHistory != null
}
