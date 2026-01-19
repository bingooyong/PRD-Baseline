# Logback Configuration Audit Rules
# 基于 ID-LOG-LOGBACK Baseline 的 OPA 审计规则

package logback.audit

import rego.v1

# 默认允许，除非明确拒绝
default allow := false
default violations := []

# 主审计函数：检查 logback 配置是否符合 Baseline
audit := result if {
    config := input.logback_config
    violations := check_logback_baseline(config)
    result := {
        "allowed": count(violations) == 0,
        "violations": violations,
        "baseline_id": "ID-LOG-LOGBACK",
        "baseline_version": "1.0.0"
    }
}

# 检查所有 Baseline 要求
check_logback_baseline(config) := violations if {
    all_checks := [
        check_console_appender_forbidden(config),
        check_rolling_file_appender(config),
        check_file_size_limit(config),
        check_max_history(config),
        check_total_size_cap(config),
        check_async_appender(config),
        check_log_level(config)
    ]
    violations := [v | v := all_checks[_]; v != null]
}

# LOG-LOGBACK-00: 禁止使用 ConsoleAppender（生产环境）
# 只检查实际被引用的 ConsoleAppender，未使用的定义不报错
check_console_appender_forbidden(config) := msg if {
    console_appender_used(config)
    msg := {
        "requirement_id": "LOG-LOGBACK-00",
        "level": "MUST",
        "title": "Console Appender Forbidden",
        "violation": "ConsoleAppender is referenced and used in production environment",
        "expected": "Remove ConsoleAppender reference, use file logging with rotation instead"
    }
}

check_console_appender_forbidden(config) := null if {
    not console_appender_used(config)
}

# LOG-LOGBACK-01: 必须使用 RollingFileAppender + SizeAndTimeBasedRollingPolicy
check_rolling_file_appender(config) := msg if {
    not has_rolling_file_appender(config)
    msg := {
        "requirement_id": "LOG-LOGBACK-01",
        "level": "MUST",
        "title": "RollingFileAppender Configuration",
        "violation": "Missing RollingFileAppender",
        "expected": "RollingFileAppender with SizeAndTimeBasedRollingPolicy"
    }
}

check_rolling_file_appender(config) := msg if {
    has_rolling_file_appender(config)
    not has_size_and_time_based_policy(config)
    msg := {
        "requirement_id": "LOG-LOGBACK-01",
        "level": "MUST",
        "title": "RollingFileAppender Configuration",
        "violation": "TimeBasedRollingPolicy alone is forbidden",
        "expected": "SizeAndTimeBasedRollingPolicy"
    }
}

check_rolling_file_appender(config) := null if {
    has_rolling_file_appender(config)
    has_size_and_time_based_policy(config)
}

# LOG-LOGBACK-02: 文件大小限制 (50MB 默认，100MB 绝对最大)
check_file_size_limit(config) := msg if {
    has_rolling_file_appender(config)
    max_size := get_max_file_size(config)
    max_size == null
    msg := {
        "requirement_id": "LOG-LOGBACK-02",
        "level": "MUST",
        "title": "File Size Limit",
        "violation": "maxFileSize is not configured",
        "expected": "maxFileSize <= 50MB (absolute max 100MB)"
    }
}

check_file_size_limit(config) := msg if {
    has_rolling_file_appender(config)
    max_size := get_max_file_size(config)
    max_size != null
    max_size_mb := parse_size_mb(max_size)
    max_size_mb > 100
    msg := {
        "requirement_id": "LOG-LOGBACK-02",
        "level": "MUST",
        "title": "File Size Limit",
        "violation": sprintf("maxFileSize %v exceeds absolute maximum 100MB", [max_size]),
        "expected": "maxFileSize <= 100MB"
    }
}

check_file_size_limit(config) := null if {
    not has_rolling_file_appender(config)
}

check_file_size_limit(config) := null if {
    has_rolling_file_appender(config)
    max_size := get_max_file_size(config)
    max_size != null
    max_size_mb := parse_size_mb(max_size)
    max_size_mb <= 100
}

# LOG-LOGBACK-03: maxHistory 必须设置且有限
check_max_history(config) := msg if {
    has_rolling_file_appender(config)
    max_history := get_max_history(config)
    max_history == null
    msg := {
        "requirement_id": "LOG-LOGBACK-03",
        "level": "MUST",
        "title": "File History Limit",
        "violation": "maxHistory is not configured",
        "expected": "maxHistory must be set (default 7, max 30)"
    }
}

check_max_history(config) := msg if {
    has_rolling_file_appender(config)
    max_history := get_max_history(config)
    max_history != null
    # 只有当 maxHistory 是数字时才检查是否超过限制
    is_number(max_history)
    max_history > 30
    msg := {
        "requirement_id": "LOG-LOGBACK-03",
        "level": "MUST",
        "title": "File History Limit",
        "violation": sprintf("maxHistory %v exceeds maximum 30", [max_history]),
        "expected": "maxHistory <= 30"
    }
}

# 如果 maxHistory 是变量（字符串），给出警告
check_max_history(config) := msg if {
    has_rolling_file_appender(config)
    max_history := get_max_history(config)
    max_history != null
    # 如果是变量（包含 ${}），给出警告
    regex.match(".*\\$\\{.*\\}.*", max_history)
    msg := {
        "requirement_id": "LOG-LOGBACK-03",
        "level": "MUST",
        "title": "File History Limit",
        "violation": sprintf("maxHistory uses variable %v, cannot verify if it exceeds maximum 30", [max_history]),
        "expected": "maxHistory must be <= 30 (use explicit value or ensure variable resolves to <= 30)"
    }
}

check_max_history(config) := null if {
    not has_rolling_file_appender(config)
}

check_max_history(config) := null if {
    has_rolling_file_appender(config)
    max_history := get_max_history(config)
    max_history != null
    # 只有当 maxHistory 是数字且 <= 30 时才通过
    is_number(max_history)
    max_history <= 30
}

# 如果 maxHistory 是变量（字符串），不自动通过，需要人工验证
check_max_history(config) := null if {
    has_rolling_file_appender(config)
    max_history := get_max_history(config)
    max_history != null
    # 如果是变量，暂时不报错（但上面的规则会先匹配并报错）
    not is_number(max_history)
    not regex.match(".*\\$\\{.*\\}.*", max_history)
}

# LOG-LOGBACK-04: totalSizeCap 必须配置
check_total_size_cap(config) := msg if {
    has_rolling_file_appender(config)
    total_size_cap := get_total_size_cap(config)
    total_size_cap == null
    msg := {
        "requirement_id": "LOG-LOGBACK-04",
        "level": "MUST",
        "title": "Total Size Cap",
        "violation": "totalSizeCap is not configured",
        "expected": "totalSizeCap must be set (default 5GB)"
    }
}

check_total_size_cap(config) := null if {
    not has_rolling_file_appender(config)
}

check_total_size_cap(config) := null if {
    has_rolling_file_appender(config)
    total_size_cap := get_total_size_cap(config)
    total_size_cap != null
}

# LOG-LOGBACK-05: 必须使用 AsyncAppender
check_async_appender(config) := msg if {
    not has_async_appender(config)
    msg := {
        "requirement_id": "LOG-LOGBACK-05",
        "level": "MUST",
        "title": "Async Appender",
        "violation": "AsyncAppender is not configured",
        "expected": "AsyncAppender required in production"
    }
}

check_async_appender(config) := null if {
    has_async_appender(config)
}

# LOG-LOGBACK-06: 生产环境必须使用 INFO 级别
check_log_level(config) := msg if {
    root_level := get_root_level(config)
    root_level == "DEBUG"
    msg := {
        "requirement_id": "LOG-LOGBACK-06",
        "level": "MUST",
        "title": "Log Level Configuration",
        "violation": "DEBUG level is forbidden in production",
        "expected": "Production must use INFO level"
    }
}

check_log_level(config) := null if {
    root_level := get_root_level(config)
    root_level != "DEBUG"
}

# 辅助函数：检查配置元素
# 检查是否存在 ConsoleAppender（仅定义，未使用）
has_console_appender(config) if {
    appender := config.appenders[_]
    appender.class == "ch.qos.logback.core.ConsoleAppender"
}

# 检查 ConsoleAppender 是否被实际使用（被 logger 引用）
console_appender_used(config) if {
    # 获取所有 ConsoleAppender 的名称
    console_appender_name := get_console_appender_name(config)
    console_appender_name != null
    
    # 检查 root logger 是否引用了 ConsoleAppender
    root_refs := config.root["appender-ref"]
    root_refs != null
    console_appender_name in root_refs
}

console_appender_used(config) if {
    # 获取所有 ConsoleAppender 的名称
    console_appender_name := get_console_appender_name(config)
    console_appender_name != null
    
    # 检查任何 logger 是否引用了 ConsoleAppender（如果 loggers 字段存在）
    config.loggers != null
    logger := config.loggers[_]
    logger_refs := logger["appender-ref"]
    logger_refs != null
    console_appender_name in logger_refs
}

console_appender_used(config) if {
    # 获取所有 ConsoleAppender 的名称
    console_appender_name := get_console_appender_name(config)
    console_appender_name != null
    
    # 检查 AsyncAppender 是否引用了 ConsoleAppender（间接使用）
    async_appender := config.appenders[_]
    async_appender.class == "ch.qos.logback.classic.AsyncAppender"
    async_appender["appender-ref"] == console_appender_name
    
    # 检查这个 AsyncAppender 是否被使用（通过 root logger）
    root_refs := config.root["appender-ref"]
    root_refs != null
    async_appender.name in root_refs
}

console_appender_used(config) if {
    # 获取所有 ConsoleAppender 的名称
    console_appender_name := get_console_appender_name(config)
    console_appender_name != null
    
    # 检查 AsyncAppender 是否引用了 ConsoleAppender（间接使用）
    async_appender := config.appenders[_]
    async_appender.class == "ch.qos.logback.classic.AsyncAppender"
    async_appender["appender-ref"] == console_appender_name
    
    # 检查这个 AsyncAppender 是否被使用（通过普通 logger，如果 loggers 字段存在）
    config.loggers != null
    logger := config.loggers[_]
    logger_refs := logger["appender-ref"]
    logger_refs != null
    async_appender.name in logger_refs
}

# 获取 ConsoleAppender 的名称
get_console_appender_name(config) := name if {
    appender := config.appenders[_]
    appender.class == "ch.qos.logback.core.ConsoleAppender"
    name := appender.name
    name != null
}

has_rolling_file_appender(config) if {
    appender := config.appenders[_]
    appender.class == "ch.qos.logback.core.rolling.RollingFileAppender"
}

has_size_and_time_based_policy(config) if {
    appender := config.appenders[_]
    appender.class == "ch.qos.logback.core.rolling.RollingFileAppender"
    policy := appender.rollingPolicy
    policy.class == "ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy"
}

has_async_appender(config) if {
    appender := config.appenders[_]
    appender.class == "ch.qos.logback.classic.AsyncAppender"
}

get_max_file_size(config) := size if {
    appender := config.appenders[_]
    appender.class == "ch.qos.logback.core.rolling.RollingFileAppender"
    policy := appender.rollingPolicy
    size := policy.maxFileSize
    size != null
}

get_max_file_size(config) := null if {
    appender := config.appenders[_]
    appender.class == "ch.qos.logback.core.rolling.RollingFileAppender"
    policy := appender.rollingPolicy
    not policy.maxFileSize
}

get_max_history(config) := history if {
    appender := config.appenders[_]
    appender.class == "ch.qos.logback.core.rolling.RollingFileAppender"
    policy := appender.rollingPolicy
    history := policy.maxHistory
    history != null
}

get_max_history(config) := null if {
    appender := config.appenders[_]
    appender.class == "ch.qos.logback.core.rolling.RollingFileAppender"
    policy := appender.rollingPolicy
    not policy.maxHistory
}

get_total_size_cap(config) := cap if {
    appender := config.appenders[_]
    appender.class == "ch.qos.logback.core.rolling.RollingFileAppender"
    policy := appender.rollingPolicy
    cap := policy.totalSizeCap
    cap != null
}

get_total_size_cap(config) := null if {
    appender := config.appenders[_]
    appender.class == "ch.qos.logback.core.rolling.RollingFileAppender"
    policy := appender.rollingPolicy
    not policy.totalSizeCap
}

get_root_level(config) := level if {
    level := config.root.level
}

# 解析大小（MB）
parse_size_mb(size_str) := mb if {
    # 处理 "50MB" 格式
    regex.match("([0-9]+)MB", size_str)
    # 提取数字部分
    parts := regex.find_all_string_submatch_n("([0-9]+)MB", size_str, -1)
    mb := to_number(parts[0][1])
}

parse_size_mb(size_str) := mb if {
    # 处理 "50" 格式（假设是 MB）
    not regex.match(".*MB", size_str)
    mb := to_number(size_str)
}
