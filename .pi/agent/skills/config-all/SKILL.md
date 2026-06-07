---
name: config-all
description: "统一配置管理技能 — Schema 驱动，安全可靠，覆盖所有可配置系统。触发词：配置、设置、修改、schema、validate、config、model、provider、channel、plugin、agent、secret、gateway、memory、security、sysctl、ulimit、nginx、mysql、docker、k8s、aws。"
license: MIT
---

# Config All — 统一配置管理技能

**Schema 驱动，安全可靠，覆盖所有可配置系统。**

---

## 一、功能概述

### 核心能力
1. **Schema 发现** — 自动发现可配置系统的 Schema
2. **Schema 验证** — 所有配置修改必须通过 Schema 校验
3. **配置查询** — 查看当前配置、Schema、默认值
4. **配置修改** — 安全修改配置，自动备份
5. **配置迁移** — 从旧版本/其他来源迁移配置
6. **配置模板** — 预设配置模板，快速部署
7. **配置诊断** — 检测配置问题，提供修复建议

### 支持的配置范围

#### 1. OpenClaw 配置
- `agents` — Agent 配置（模型、工作区、认证）
- `channels` — 渠道配置（飞书、微信、Discord 等）
- `plugins` — 插件配置（安装、启用、白名单）
- `models` — 模型配置（Provider、API Key）
- `secrets` — 密钥配置（安全存储）
- `gateway` — 网关配置（端口、认证）
- `memory` — 记忆配置（后端、搜索）
- `security` — 安全配置（白名单、权限）

#### 2. 系统配置
- **Linux 内核参数** — sysctl 配置（网络、内存、文件系统）
- **系统限制** — ulimit 配置（文件描述符、进程数）
- **系统服务** — systemd 服务配置
- **网络配置** — 网络接口、路由、防火墙
- **存储配置** — 磁盘、分区、文件系统
- **安全配置** — SSH、防火墙、SELinux

#### 3. 应用配置
- **Web 服务器** — Nginx、Apache、Caddy
- **数据库** — MySQL、PostgreSQL、MongoDB、Redis
- **容器** — Docker、Podman、Kubernetes
- **编程语言** — Node.js、Python、Java、Go
- **开发工具** — Git、VS Code、IDE

#### 4. 云服务配置
- **云平台** — AWS、Azure、GCP、阿里云
- **CDN** — Cloudflare、Akamai
- **DNS** — Cloudflare DNS、Route53
- **存储** — S3、OSS、COS

#### 5. 自定义配置
- **JSON Schema** — 任何符合 JSON Schema 的配置
- **YAML Schema** — 任何符合 YAML Schema 的配置
- **TOML Schema** — 任何符合 TOML Schema 的配置

---

## 二、触发条件

### 显式请求
- "配置 XXX"
- "设置 XXX"
- "修改 XXX"
- "查看 XXX 配置"
- "XXX 怎么配置"
- "配置所有 XXX"
- "Schema XXX"

### 隐式意图
- ✅ **OpenClaw**："换成 openai"、"开飞书"、"装插件"
- ✅ **系统**："优化内核"、"修改 ulimit"、"配置防火墙"
- ✅ **网络**："配置 IP"、"设置 DNS"、"修改路由"
- ✅ **服务**："配置 Nginx"、"设置 MySQL"、"优化 Redis"
- ✅ **容器**："配置 Docker"、"设置 K8s"
- ✅ **云服务**："配置 AWS"、"设置 CDN"
- ✅ **错误**：配置验证错误、Schema 错误、启动失败

### 关键词
`config`、`配置`、`设置`、`schema`、`validate`、`model`、`provider`、`channel`、`plugin`、`agent`、`secret`、`gateway`、`memory`、`security`、`sysctl`、`ulimit`、`nginx`、`mysql`、`docker`、`k8s`、`aws`

---

## 三、核心流程

### 1. Schema 发现（自动）

**自动发现可配置系统的 Schema：**

```bash
# OpenClaw Schema
openclaw config schema

# 系统 Schema（sysctl）
sysctl -a | grep <parameter>

# 应用 Schema（Nginx）
nginx -T

# 容器 Schema（Docker）
docker config inspect
```

### 2. Schema 验证（必须）

**任何配置修改前，必须先查 Schema：**

```bash
# OpenClaw Schema
openclaw config schema agents.defaults.model

# 系统 Schema（sysctl）
sysctl net.ipv4.tcp_congestion_control

# 应用 Schema（Nginx）
nginx -t
```

### 3. 配置查询

```bash
# OpenClaw 配置
openclaw config get

# 系统配置（sysctl）
sysctl -a | grep <parameter>

# 应用配置（Nginx）
cat /etc/nginx/nginx.conf

# 容器配置（Docker）
docker config inspect <config>
```

### 4. 配置修改

```bash
# OpenClaw 配置
openclaw config set <path> <value>

# 系统配置（sysctl）
sysctl -w <parameter>=<value>

# 应用配置（Nginx）
edit /etc/nginx/nginx.conf

# 容器配置（Docker）
docker config create <name> <file>
```

### 5. 配置验证

```bash
# OpenClaw 配置
openclaw config validate

# 系统配置（sysctl）
sysctl -p

# 应用配置（Nginx）
nginx -t

# 容器配置（Docker）
docker config inspect <config>
```

### 6. 配置备份与恢复

```bash
# OpenClaw 配置
openclaw config backup
openclaw config restore <backup-file>

# 系统配置（sysctl）
cp /etc/sysctl.conf /etc/sysctl.conf.bak
cp /etc/sysctl.conf.bak /etc/sysctl.conf

# 应用配置（Nginx）
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
cp /etc/nginx/nginx.conf.bak /etc/nginx/nginx.conf
```

---

## 四、配置模板

### 1. OpenClaw 配置模板

#### 模型配置
```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "minimax-portal/MiniMax-M3",
        "fallbacks": [
          "xiaomi-token-plan-cn/mimo-v2.5-pro",
          "openrouter/owl-alpha"
        ]
      }
    }
  }
}
```

#### 渠道配置
```json
{
  "channels": {
    "feishu": {
      "enabled": true,
      "appId": "cli_xxx",
      "appSecret": "xxx",
      "domain": "feishu",
      "connectionMode": "websocket",
      "streaming": true,
      "requireMention": true,
      "dmPolicy": "allowlist",
      "allowFrom": ["ou_xxx"],
      "agent": "xiaohe"
    }
  }
}
```

#### 插件配置
```json
{
  "plugins": {
    "entries": {
      "memory-tencentdb": {
        "enabled": true,
        "config": {
          "embedding": {
            "enabled": true,
            "provider": "openai",
            "baseUrl": "https://api.siliconflow.cn/v1",
            "apiKey": "sk-xxx",
            "model": "Qwen/Qwen3-Embedding-8B",
            "dimensions": 4096,
            "sendDimensions": false
          }
        }
      }
    },
    "allow": ["memory-tencentdb", "openclaw-lark"]
  }
}
```

### 2. 系统配置模板

#### 网络优化（sysctl）
```bash
# /etc/sysctl.d/99-network-optimization.conf

# TCP 拥塞控制
net.ipv4.tcp_congestion_control = bbr

# TCP 缓冲区
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216

# TCP 连接
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_max_syn_backlog = 8192

# 文件描述符
fs.file-max = 1000000
fs.inotify.max_user_watches = 524288
```

#### 内存优化（sysctl）
```bash
# /etc/sysctl.d/99-memory-optimization.conf

# 虚拟内存
vm.swappiness = 10
vm.dirty_ratio = 15
vm.dirty_background_ratio = 5
vm.vfs_cache_pressure = 50

# 内存分配
vm.overcommit_memory = 1
vm.max_map_count = 262144
```

#### 文件限制（ulimit）
```bash
# /etc/security/limits.d/99-ai-server.conf

# 文件描述符
* soft nofile 65535
* hard nofile 65535
root soft nofile 65535
root hard nofile 65535

# 进程数
* soft nproc 65535
* hard nproc 65535
root soft nproc 65535
root hard nproc 65535
```

### 3. 应用配置模板

#### Nginx 配置
```nginx
# /etc/nginx/nginx.conf

user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
    use epoll;
    multi_accept on;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log main;

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;

    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

    include /etc/nginx/conf.d/*.conf;
}
```

#### MySQL 配置
```ini
# /etc/mysql/mysql.conf.d/mysqld.cnf

[mysqld]
# 基础配置
user = mysql
pid-file = /var/run/mysqld/mysqld.pid
socket = /var/run/mysqld/mysqld.sock
port = 3306
basedir = /usr
datadir = /var/lib/mysql
tmpdir = /tmp

# 连接配置
max_connections = 1000
max_connect_errors = 100
wait_timeout = 600
interactive_timeout = 600

# 缓冲配置
key_buffer_size = 256M
max_allowed_packet = 64M
table_open_cache = 1024
sort_buffer_size = 4M
read_buffer_size = 4M
read_rnd_buffer_size = 8M
myisam_sort_buffer_size = 64M
thread_cache_size = 8

# InnoDB 配置
innodb_buffer_pool_size = 1G
innodb_log_file_size = 256M
innodb_file_per_table = 1
innodb_flush_log_at_trx_commit = 2
innodb_log_buffer_size = 16M

# 日志配置
log_error = /var/log/mysql/error.log
slow_query_log = 1
slow_query_log_file = /var/log/mysql/slow.log
long_query_time = 2
```

#### Redis 配置
```conf
# /etc/redis/redis.conf

# 网络配置
bind 127.0.0.1
port 6379
tcp-backlog 511
timeout 0
tcp-keepalive 300

# 通用配置
daemonize yes
supervised systemd
pidfile /var/run/redis/redis-server.pid
loglevel notice
logfile /var/log/redis/redis-server.log
databases 16

# 内存配置
maxmemory 1gb
maxmemory-policy allkeys-lru

# 持久化配置
save 900 1
save 300 10
save 60 10000
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
dbfilename dump.rdb
dir /var/lib/redis

# AOF 配置
appendonly yes
appendfilename "appendonly.aof"
appendfsync everysec
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb

# 客户端配置
maxclients 10000

# 慢查询日志
slowlog-log-slower-than 10000
slowlog-max-len 128
```

### 4. 容器配置模板

#### Docker 配置
```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m",
    "max-file": "3"
  },
  "storage-driver": "overlay2",
  "default-runtime": "runc",
  "runtimes": {
    "runc": {
      "path": "runc"
    }
  }
}
```

#### Docker Compose 配置
```yaml
version: '3.8'

services:
  app:
    image: nginx:latest
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./html:/usr/share/nginx/html
    restart: unless-stopped
    networks:
      - app-network

  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: mydb
      MYSQL_USER: myuser
      MYSQL_PASSWORD: mypassword
    volumes:
      - db-data:/var/lib/mysql
    restart: unless-stopped
    networks:
      - app-network

  redis:
    image: redis:latest
    command: redis-server --appendonly yes
    volumes:
      - redis-data:/data
    restart: unless-stopped
    networks:
      - app-network

volumes:
  db-data:
  redis-data:

networks:
  app-network:
    driver: bridge
```

### 5. 云服务配置模板

#### AWS CLI 配置
```ini
# ~/.aws/config

[default]
region = us-east-1
output = json

[profile production]
region = us-east-1
output = json
role_arn = arn:aws:iam::123456789012:role/ProductionRole
source_profile = default
```

#### AWS CLI 凭证
```ini
# ~/.aws/credentials

[default]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

[production]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

---

## 五、常用操作

### 1. OpenClaw 配置

```bash
# 查看配置
openclaw config get

# 修改配置
openclaw config set agents.defaults.model.primary minimax-portal/MiniMax-M3

# 验证配置
openclaw config validate

# 重启网关
openclaw gateway restart
```

### 2. 系统配置

```bash
# 查看 sysctl 配置
sysctl -a | grep <parameter>

# 修改 sysctl 配置
sysctl -w net.ipv4.tcp_congestion_control=bbr

# 永久修改 sysctl 配置
echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.d/99-custom.conf
sysctl -p

# 查看 ulimit 配置
ulimit -a

# 修改 ulimit 配置
ulimit -n 65535
```

### 3. 应用配置

```bash
# Nginx 配置
nginx -t
nginx -s reload

# MySQL 配置
mysql -u root -p -e "SHOW VARIABLES;"

# Redis 配置
redis-cli CONFIG GET *
redis-cli CONFIG SET <parameter> <value>
```

### 4. 容器配置

```bash
# Docker 配置
docker info
docker config inspect <config>

# Docker Compose 配置
docker-compose config
docker-compose up -d
```

---

## 六、安全规范

### 1. Schema 验证
- 所有配置修改必须通过 Schema 校验
- 禁止手动编辑配置文件（除非 Schema 不支持）
- 修改前必须备份

### 2. 权限控制
- 敏感配置（密钥、白名单）需要确认
- 修改安全配置需要二次验证
- 记录所有配置变更

### 3. 回滚机制
- 自动备份修改前的配置
- 支持一键回滚
- 保留最近 10 个备份

### 4. 最小权限原则
- 只授予必要的权限
- 定期审查权限配置
- 及时撤销不再需要的权限

---

## 七、故障排查

### 1. 配置验证失败
```bash
# 查看详细错误
openclaw config validate

# 恢复备份
openclaw config restore <backup-file>

# 运行 doctor
openclaw doctor --fix
```

### 2. 系统配置问题
```bash
# 查看系统日志
journalctl -xe

# 检查配置文件语法
sysctl -p

# 恢复默认配置
cp /etc/sysctl.conf.bak /etc/sysctl.conf
sysctl -p
```

### 3. 应用配置问题
```bash
# Nginx 配置问题
nginx -t
tail -f /var/log/nginx/error.log

# MySQL 配置问题
mysql -u root -p -e "SHOW VARIABLES;"
tail -f /var/log/mysql/error.log

# Redis 配置问题
redis-cli CONFIG GET *
tail -f /var/log/redis/redis-server.log
```

### 4. 容器配置问题
```bash
# Docker 配置问题
docker info
docker logs <container>

# Docker Compose 配置问题
docker-compose config
docker-compose logs
```

---

## 八、最佳实践

### 1. 配置修改流程
1. 查询当前配置：`openclaw config get <path>`
2. 查看 Schema：`openclaw config schema <path>`
3. 备份配置：`openclaw config backup`
4. 修改配置：`openclaw config set <path> <value>`
5. 验证配置：`openclaw config validate`
6. 重启服务：`openclaw gateway restart`
7. 检查状态：`openclaw health`

### 2. 密钥管理
- 使用 `secrets.json` 存储密钥
- 文件权限设置为 `600`
- 不要在配置文件中硬编码密钥
- 使用 SecretRef 引用密钥

### 3. 配置版本控制
- 使用 Git 管理配置文件
- 记录配置变更历史
- 定期备份配置

### 4. 配置文档化
- 为每个配置项添加注释
- 记录配置变更原因
- 维护配置文档

---

## 九、示例场景

### 场景 1：OpenClaw 模型切换
```bash
# 查看当前模型
openclaw config get agents.defaults.model

# 切换到 MiniMax-M3
openclaw config set agents.defaults.model.primary minimax-portal/MiniMax-M3

# 验证
openclaw config validate

# 重启网关
openclaw gateway restart
```

### 场景 2：系统网络优化
```bash
# 查看当前网络配置
sysctl -a | grep net.ipv4.tcp

# 优化 TCP 配置
cat > /etc/sysctl.d/99-network-optimization.conf << EOF
net.ipv4.tcp_congestion_control = bbr
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
EOF

# 应用配置
sysctl -p /etc/sysctl.d/99-network-optimization.conf
```

### 场景 3：Nginx 配置优化
```bash
# 备份配置
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

# 编辑配置
vim /etc/nginx/nginx.conf

# 验证配置
nginx -t

# 重载配置
nginx -s reload
```

### 场景 4：Docker 配置优化
```bash
# 查看当前配置
docker info

# 编辑配置
vim /etc/docker/daemon.json

# 重启 Docker
systemctl restart docker

# 验证配置
docker info
```

---

## 十、注意事项

1. **Schema 优先** — 所有配置修改必须通过 Schema 校验
2. **备份优先** — 修改前必须备份配置
3. **验证优先** — 修改后必须验证配置
4. **重启生效** — 大部分配置需要重启服务才能生效
5. **日志排查** — 遇到问题先看日志
6. **最小权限** — 只授予必要的权限
7. **定期审查** — 定期审查配置安全性

---

## 十一、配置检查清单

### OpenClaw 配置检查
- [ ] 模型配置正确
- [ ] 渠道配置正确
- [ ] 插件配置正确
- [ ] 安全配置正确
- [ ] 密钥配置正确

### 系统配置检查
- [ ] 内核参数优化
- [ ] 文件限制配置
- [ ] 网络配置优化
- [ ] 安全配置正确

### 应用配置检查
- [ ] Web 服务器配置
- [ ] 数据库配置
- [ ] 缓存配置
- [ ] 日志配置

### 容器配置检查
- [ ] Docker 配置
- [ ] Docker Compose 配置
- [ ] 网络配置
- [ ] 存储配置

---

**版本**: 1.0.0  
**更新**: 2026-06-05  
**维护**: Config All Skill
