#!/bin/bash

# 等待MySQL服务启动
echo "Waiting for MySQL to be ready..."
sleep 10

# 初始化Seata数据库
echo "Initializing Seata database..."
mysql -h mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} < /docker-entrypoint-initdb.d/init.sql

echo "Seata database initialization completed."

# 启动Seata服务
echo "Starting Seata server..."
exec /seata-server/bin/seata-server.sh