# OPA 审计快速开始

## 🎯 目标

基于 **Logback** 和 **Tomcat Console 日志** 两个检查点，实现 AI 自动审计。

## ⚡ 5 分钟快速开始

### 1. 安装 OPA

```bash
# macOS
brew install opa

# Linux
curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64
chmod +x opa
sudo mv opa /usr/local/bin/
```

### 2. 测试规则

```bash
# 测试 Logback 规则
opa test opa/rules/logback-audit.rego opa/tests/logback-audit.test.rego -v

# 测试 Tomcat 规则
opa test opa/rules/tomcat-console-audit.rego opa/tests/tomcat-console-audit.test.rego -v
```

### 3. 手动审计示例

```bash
# 审计 Logback 配置（示例输入）
cat > /tmp/logback-input.json <<JSON
{
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
    }
  }
}
JSON

# 运行审计
cat /tmp/logback-input.json | opa eval \
  --data opa/rules/logback-audit.rego \
  --input - \
  --format json \
  'data.logback.audit.audit' | jq
```

### 4. 集成到 CI/CD

```bash
# 使用集成脚本
bash opa/integration/ci-cd-integration.sh

# 或使用 Python 脚本
python3 opa/integration/ai-agent-integration.py \
  src/main/resources/logback-spring.xml \
  conf/server.xml
```

## 📋 检查点说明

### Logback 检查点

- ✅ RollingFileAppender + SizeAndTimeBasedRollingPolicy
- ✅ maxFileSize ≤ 50MB（默认），≤ 100MB（最大）
- ✅ maxHistory 必须设置（≤ 30）
- ✅ totalSizeCap 必须配置
- ✅ AsyncAppender 必须使用
- ✅ 生产环境必须使用 INFO 级别

### Tomcat Console 检查点

- ✅ 生产环境禁止 console 日志输出
- ✅ 必须启用文件日志
- ✅ 文件日志必须启用滚动

## 🔗 更多信息

- [完整文档](./README.md)
- [AI 自动审计指南](../docs/ai-audit-guide.md)
