# Logback Audit Rules Tests

package logback.audit.test

import rego.v1
import data.logback.audit

# 测试用例 1: 符合 Baseline 的配置
test_valid_config if {
    test_input := {
        "logback_config": {
            "appenders": [
                {
                    "class": "ch.qos.logback.core.rolling.RollingFileAppender",
                    "rollingPolicy": {
                        "class": "ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy",
                        "maxFileSize": "50MB",
                        "maxHistory": 7,
                        "totalSizeCap": "5GB"
                    }
                },
                {
                    "class": "ch.qos.logback.classic.AsyncAppender"
                }
            ],
            "root": {
                "level": "INFO"
            },
            "loggers": []
        }
    }
    
    result := audit.audit with input as test_input
    result.allowed == true
    count(result.violations) == 0
}

# 测试用例 2: 缺少 maxFileSize
test_missing_max_file_size if {
    test_input := {
        "logback_config": {
            "appenders": [
                {
                    "class": "ch.qos.logback.core.rolling.RollingFileAppender",
                    "rollingPolicy": {
                        "class": "ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy",
                        "maxHistory": 7,
                        "totalSizeCap": "5GB"
                    }
                }
            ],
            "root": {
                "level": "INFO"
            },
            "loggers": []
        }
    }
    
    result := audit.audit with input as test_input
    result.allowed == false
    violations := result.violations
    violation := violations[_]
    violation.requirement_id == "LOG-LOGBACK-02"
}

# 测试用例 3: maxFileSize 超过限制
test_max_file_size_exceeded if {
    test_input := {
        "logback_config": {
            "appenders": [
                {
                    "class": "ch.qos.logback.core.rolling.RollingFileAppender",
                    "rollingPolicy": {
                        "class": "ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy",
                        "maxFileSize": "200MB",
                        "maxHistory": 7,
                        "totalSizeCap": "5GB"
                    }
                }
            ],
            "root": {
                "level": "INFO"
            },
            "loggers": []
        }
    }
    
    result := audit.audit with input as test_input
    result.allowed == false
    violations := result.violations
    violation := violations[_]
    violation.requirement_id == "LOG-LOGBACK-02"
    violation.violation == "maxFileSize 200MB exceeds absolute maximum 100MB"
}

# 测试用例 4: 缺少 totalSizeCap
test_missing_total_size_cap if {
    test_input := {
        "logback_config": {
            "appenders": [
                {
                    "class": "ch.qos.logback.core.rolling.RollingFileAppender",
                    "rollingPolicy": {
                        "class": "ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy",
                        "maxFileSize": "50MB",
                        "maxHistory": 7
                    }
                }
            ],
            "root": {
                "level": "INFO"
            },
            "loggers": []
        }
    }
    
    result := audit.audit with input as test_input
    result.allowed == false
    violations := result.violations
    violation := violations[_]
    violation.requirement_id == "LOG-LOGBACK-04"
}

# 测试用例 5: DEBUG 级别（禁止）
test_debug_level_forbidden if {
    test_input := {
        "logback_config": {
            "appenders": [
                {
                    "class": "ch.qos.logback.core.rolling.RollingFileAppender",
                    "rollingPolicy": {
                        "class": "ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy",
                        "maxFileSize": "50MB",
                        "maxHistory": 7,
                        "totalSizeCap": "5GB"
                    }
                }
            ],
            "root": {
                "level": "DEBUG"
            },
            "loggers": []
        }
    }
    
    result := audit.audit with input as test_input
    result.allowed == false
    violations := result.violations
    violation := violations[_]
    violation.requirement_id == "LOG-LOGBACK-06"
    violation.violation == "DEBUG level is forbidden in production"
}

# 测试用例 6: ConsoleAppender 定义了但未使用（应该通过，不报错）
test_console_appender_defined_but_not_used if {
    test_input := {
        "logback_config": {
            "appenders": [
                {
                    "name": "CONSOLE",
                    "class": "ch.qos.logback.core.ConsoleAppender"
                },
                {
                    "name": "FILE",
                    "class": "ch.qos.logback.core.rolling.RollingFileAppender",
                    "rollingPolicy": {
                        "class": "ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy",
                        "maxFileSize": "50MB",
                        "maxHistory": 7,
                        "totalSizeCap": "5GB"
                    }
                },
                {
                    "name": "ASYNC",
                    "class": "ch.qos.logback.classic.AsyncAppender"
                }
            ],
            "root": {
                "level": "INFO",
                "appender-ref": ["ASYNC"]
            },
            "loggers": []
        }
    }
    
    result := audit.audit with input as test_input
    # ConsoleAppender 定义了但未被引用，应该通过
    result.allowed == true
    # 不应该有 LOG-LOGBACK-00 违规
    violations := result.violations
    # 确保没有任何违规项的 requirement_id 是 LOG-LOGBACK-00
    count([v | v := violations[_]; v.requirement_id == "LOG-LOGBACK-00"]) == 0
}

# 测试用例 7: ConsoleAppender 被引用（违反，应该报错）
test_console_appender_referenced if {
    test_input := {
        "logback_config": {
            "appenders": [
                {
                    "name": "CONSOLE",
                    "class": "ch.qos.logback.core.ConsoleAppender"
                },
                {
                    "name": "FILE",
                    "class": "ch.qos.logback.core.rolling.RollingFileAppender",
                    "rollingPolicy": {
                        "class": "ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy",
                        "maxFileSize": "50MB",
                        "maxHistory": 7,
                        "totalSizeCap": "5GB"
                    }
                }
            ],
            "root": {
                "level": "INFO",
                "appender-ref": ["CONSOLE", "FILE"]
            },
            "loggers": []
        }
    }
    
    result := audit.audit with input as test_input
    result.allowed == false
    violations := result.violations
    violation := violations[_]
    violation.requirement_id == "LOG-LOGBACK-00"
    violation.violation == "ConsoleAppender is referenced and used in production environment"
}

# 测试用例 8: ConsoleAppender 定义了但 appender-ref 被注释（应该通过，不报错）
# 模拟 XML 注释的情况：被注释的 appender-ref 不会被解析，所以不会出现在 appender-ref 列表中
test_console_appender_commented_out if {
    test_input := {
        "logback_config": {
            "appenders": [
                {
                    "name": "STDOUT",
                    "class": "ch.qos.logback.core.ConsoleAppender"
                },
                {
                    "name": "all_log",
                    "class": "ch.qos.logback.core.rolling.RollingFileAppender",
                    "rollingPolicy": {
                        "class": "ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy",
                        "maxFileSize": "50MB",
                        "maxHistory": 7,
                        "totalSizeCap": "5GB"
                    }
                }
            ],
            "root": {
                "level": "INFO",
                # 注意：这里只包含 all_log，STDOUT 的引用被注释掉了（不会出现在解析结果中）
                "appender-ref": ["all_log"]
            },
            "loggers": []
        }
    }
    
    result := audit.audit with input as test_input
    # ConsoleAppender 定义了但引用被注释，应该通过（除了可能缺少 AsyncAppender）
    # 不应该有 LOG-LOGBACK-00 违规
    violations := result.violations
    count([v | v := violations[_]; v.requirement_id == "LOG-LOGBACK-00"]) == 0
}
