#!/bin/bash

echo "Waiting for MySQL to start..."
sleep 10

echo "Initializing Seata database..."
mysql -h mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} < /docker-entrypoint-initdb.d/init.sql

echo "Seata database initialization completed."