FROM apache/seata-server:latest

RUN apt-get update && apt-get install -y default-mysql-client && apt-get clean

WORKDIR /seata-server

COPY config/registry.conf /seata-server/resources/registry.conf
COPY config/file.conf /seata-server/resources/file.conf
COPY sql/init.sql /docker-entrypoint-initdb.d/
COPY scripts/entrypoint.sh /

RUN chmod +x /entrypoint.sh

EXPOSE 8091

ENTRYPOINT ["/entrypoint.sh"]