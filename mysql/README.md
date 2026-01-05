
mysql 驱动5.x,老版本,com.mysql.jdbc.Driver.
```xml
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>5.x.x</version> <!-- 具体版本号，如 5.1.49 -->
</dependency>
```


mysql 驱动8.x,新版本格式,com.mysql.cj.jdbc.Driver.
```xml
<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <version>8.x.x</version> <!-- 具体版本号，如 5.1.49 -->
</dependency>
```


MySQL 服务被配置为使用 mysql_native_password 认证插件（5.x 驱动可用），这保证了 5.x 驱动与后端 MySQL 的兼容性，从而不会因为认证插件不匹配而报错。参见 `my.cnf` 以及镜像构建的默认设置（默认强制为 mysql_native_password）。