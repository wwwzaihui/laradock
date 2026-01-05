# Nacos 服务配置说明

## 简介

Nacos 是阿里巴巴开源的一个更易于构建云原生应用的动态服务发现、配置管理和服务管理平台。本文档提供了在 Laradock 环境中使用 Nacos 的配置说明。

## 环境变量配置

在 `.env` 文件中已添加以下 Nacos 相关的环境变量：

```
# Nacos 版本
NACOS_VERSION=latest

# 单机或集群模式
NACOS_MODE=standalone

# 主机模式
NACOS_PREFER_HOST_MODE=hostname

# 认证配置
NACOS_AUTH_ENABLE=true
NACOS_AUTH_TOKEN=SecretKey012345678901234567890123456789012345678901234567890123456789
NACOS_AUTH_IDENTITY_KEY=serverIdentity
NACOS_AUTH_IDENTITY_VALUE=security

# JVM 配置
NACOS_JVM_XMS=512m
NACOS_JVM_XMX=512m
NACOS_JVM_XMN=256m
NACOS_JVM_MS=128m
NACOS_JVM_MMS=320m

# 数据库配置（mysql 或 embedded）
NACOS_SPRING_DATASOURCE_PLATFORM=mysql
NACOS_MYSQL_SERVICE_HOST=mysql
NACOS_MYSQL_SERVICE_PORT=3306
NACOS_MYSQL_SERVICE_DB_NAME=nacos_config
NACOS_MYSQL_SERVICE_USER=root
NACOS_MYSQL_SERVICE_PASSWORD=root

# 端口配置
NACOS_PORT=8848
NACOS_GRPC_PORT=9848
```

## 使用说明

### 启动 Nacos 服务

```bash
docker-compose up -d nacos
```

### 初始化数据库

首次使用时，需要初始化 MySQL 数据库。在 Laradock 目录下执行：

```bash
docker-compose exec mysql mysql -u root -p < ./nacos/nacos-mysql.sql
```

系统会提示输入 MySQL 的 root 密码，默认为 `root`。

### 访问 Nacos 控制台

启动成功后，可以通过浏览器访问 Nacos 控制台：

```
http://localhost:8848/nacos
```

默认的用户名和密码为：
- 用户名：nacos
- 密码：nacos

## 配置说明

### 单机模式与集群模式

- 单机模式（standalone）：适用于开发和测试环境
- 集群模式（cluster）：适用于生产环境，需要额外配置

### 数据持久化

Nacos 的数据默认持久化到 Docker 卷 `nacos` 中，确保数据不会因容器重启而丢失。

### MySQL 数据库

默认配置使用 MySQL 作为数据存储，确保 MySQL 服务已启动并正确配置连接信息。

## 更多资源

- [Nacos 官方文档](https://nacos.io/zh-cn/docs/what-is-nacos.html)
- [Nacos GitHub 仓库](https://github.com/alibaba/nacos)
- [Nacos Docker GitHub 仓库](https://github.com/nacos-group/nacos-docker)