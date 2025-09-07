# Seata 部署说明

## 参考信息

- 官网文档地址: https://seata.apache.org/zh-cn/docs/user/quickstart/
- Docker Compose 部署： https://seata.apache.org/zh-cn/docs/ops/deploy-by-docker-compose

## 部署步骤

### 1. 初始化 MySQL 数据库

在启动 Seata 服务之前，需要先手动初始化 MySQL 数据库。执行以下命令：

```bash
# 连接到 MySQL 容器
docker exec -it laradock_mysql_1 bash

# 在容器内执行 SQL 脚本
mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} < ${实际路径}/seata/sql/init.sql
```

或者直接使用 MySQL 客户端执行：

```bash
mysql -h127.0.0.1 -P3306 -u${MYSQL_USER} -p${MYSQL_PASSWORD} < ${实际路径}/seata/sql/init.sql
```

### 2. 启动 Seata 服务

初始化数据库后，可以启动 Seata 服务：

```bash
docker-compose up -d seata
```

> **注意**：Seata 服务的内部端口为 8091，对外映射端口为 18091。如果 18091 端口也被占用，请修改 `docker-compose.yml` 文件中的端口映射即可，无需修改 `file.conf` 中的配置。

## 配置说明

### 目录结构

```
seata/
├── config/
│   ├── file.conf     # Seata 服务配置文件
│   └── registry.conf # 注册中心和配置中心配置文件
├── sql/
│   └── init.sql      # 数据库初始化脚本
└── scripts/          # 辅助脚本目录
```

### 关键配置

- **存储模式**：当前配置使用 `db` 模式存储事务日志
- **数据库**：使用 MySQL 存储事务数据
- **端口**：Seata 服务默认内部端口为 8091，对外映射端口为 18091