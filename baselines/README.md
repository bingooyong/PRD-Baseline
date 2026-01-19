# Baselines 目录结构说明

## 📁 目录层次

Baseline 文件按以下层次组织：

### 1. 抽象层 Baseline（`baselines/` 根目录）

抽象的、框架无关的 Baseline 要求，适用于所有技术栈：

- `baselines/logging/` - **日志基线（抽象层）**
  - `logging-baseline.yaml` (ID-LOG-BASE) - 统一日志基线要求
  - 适用于：所有日志框架（Logback, Log4j2, Zap, Python logging 等）

- `baselines/capacity/` - **容量管理基线**
  - `logging-storage.yaml` (ID-CAP-LOG) - 日志与文件存储容量治理
  - `database-retention.yaml` (ID-CAP-DATA) - 数据库容量与历史数据治理

- `baselines/identity-access/` - **身份与访问基线**
  - `login-authentication.yaml` - 登录认证基线

- `baselines/resource/` - **资源管理基线**
  - `memory-exhaustion.yaml` (ID-RES-MEM) - 内存与资源耗尽治理

- 其他抽象层 Baseline...

### 2. 实现层 Baseline（`baselines/implementations/`）

具体技术框架的实现基线，继承并细化抽象层要求：

- `baselines/implementations/logging/` - **日志框架实现**
  - `logback-baseline.yaml` (ID-LOG-LOGBACK) - Logback Java/Spring 实现
  - `log4j2-baseline.yaml` (ID-LOG-LOG4J2) - Log4j2 Java 实现
  - `zap-baseline.yaml` (ID-LOG-ZAP) - Zap Go 实现
  - `logrotate-baseline.yaml` (ID-LOG-LOGROTATE) - Logrotate 系统级实现

- `baselines/implementations/database/` - **数据库实现**
  - `database-logging-baseline.yaml` - 数据库日志与表容量实现

## 🔗 Baseline 引用关系

```
抽象层 (ID-LOG-BASE)
    ↓ 引用
实现层 (ID-LOG-LOGBACK, ID-LOG-LOG4J2, ...)
    ↓ 引用
容量层 (ID-CAP-LOG)
```

### 示例：Logback Baseline 引用关系

```yaml
# baselines/implementations/logging/logback-baseline.yaml
baseline:
  id: ID-LOG-LOGBACK
  name: Logback Baseline

requirements:
  - id: LOG-LOGBACK-00
    references:
      - standard: ID-LOG-BASE    # 引用抽象层
        section: LOG-BASE-00     # Console Logging Forbidden
  
  - id: LOG-LOGBACK-01
    references:
      - standard: ID-LOG-BASE
        section: LOG-BASE-06    # Log Rotation Strategy
  
  - id: LOG-LOGBACK-02
    references:
      - standard: ID-CAP-LOG    # 引用容量层
        section: CAP-LOG-02     # Maximum Log File Size
```

## 📋 使用指南

### 选择 Baseline 的层次

1. **如果你需要通用的日志要求**（不限定技术栈）
   - 使用：`baselines/logging/logging-baseline.yaml` (ID-LOG-BASE)

2. **如果你使用 Logback**
   - 使用：`baselines/implementations/logging/logback-baseline.yaml` (ID-LOG-LOGBACK)
   - 它会自动继承 ID-LOG-BASE 的要求

3. **如果你需要容量管理要求**
   - 使用：`baselines/capacity/logging-storage.yaml` (ID-CAP-LOG)
   - 与日志基线配合使用

### 审计工具使用

```bash
# 审计 Logback 配置（会自动检查所有相关 Baseline）
python3 scripts/audit-logback-xml.py logback-spring.xml
```

审计工具会自动：
1. 检查实现层 Baseline (ID-LOG-LOGBACK)
2. 检查抽象层 Baseline (ID-LOG-BASE)
3. 检查容量层 Baseline (ID-CAP-LOG)

## 🎯 设计原则

1. **抽象与实现分离** - 抽象层定义"做什么"，实现层定义"怎么做"
2. **可复用性** - 抽象层可被多个实现层引用
3. **可扩展性** - 新增框架只需创建新的实现层 Baseline
4. **可追溯性** - 通过 references 字段建立清晰的引用关系
