# XXL-JOB 在 Laradock 中的配置说明

## 简介

XXL-JOB 是一个轻量级分布式任务调度平台，是一个「任务调度」+「任务执行」的分布式服务。

## 配置说明

### 环境变量

在 `.env` 文件中可以配置以下参数：

- `XXLJOB_PORT`: XXL-JOB 管理平台访问端口，默认为 8800
- `XXLJOB_ACCESS_TOKEN`: XXL-JOB 访问令牌，用于安全验证，默认为 default_token

### 数据库初始化

首次使用需要初始化数据库，XXL-JOB 使用 MySQL 数据库存储任务信息。

1. 创建数据库：

```sql
CREATE database if NOT EXISTS `xxl_job` default character set utf8mb4 collate utf8mb4_unicode_ci;
```

2. 执行初始化脚本：

可以从 [XXL-JOB 官方仓库](https://gitcode.com/xuxueli/xxl-job) 下载源码，在 `/doc/db/tables_xxl_job.sql` 目录下找到初始化脚本并执行。
本地相对路径: `xxljob/db/tables_xxl_job.sql`

### 访问管理平台

启动服务后，可以通过以下地址访问 XXL-JOB 管理平台：

```
![1757252599469](image/README/1757252599469.png)
```

默认登录账号密码：
- 账号：admin
- 密码：123456

## 执行器配置

在实际应用中，需要在业务项目中集成 XXL-JOB 执行器。具体配置请参考 [XXL-JOB 官方文档](https://www.xuxueli.com/xxl-job/)。

## 参考资料

- 官方文档：https://www.xuxueli.com/xxl-job/
- 源码仓库：
  - GitHub: https://github.com/xuxueli/xxl-job
  - Gitee: http://gitee.com/xuxueli0323/xxl-job
  - Gitcode: https://gitcode.com/xuxueli/xxl-job