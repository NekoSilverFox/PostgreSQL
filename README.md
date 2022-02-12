<p align="center">
 <img width="100px" src="https://raw.githubusercontent.com/NekoSilverFox/NekoSilverfox/403ab045b7d9adeaaf8186c451af7243f5d8f46d/icons/silverfox.svg" align="center" alt="NekoSilverfox" />
 <h1 align="center">PostgreSQL</h1>
 <p align="center"><b>笔记及代码</b></p>
</p>


<div align=center>


[![License](https://img.shields.io/badge/license-Apache%202.0-brightgreen)](LICENSE)



<div align=left>
<!-- 顶部至此截止 -->
[toc]



# 基本使用

## 登录

输入 `psql` 链接数据库，默认是进入数据库的控制面板（默认用户和数据库都是 `postgres`）。如果系统提示符变成了`postgres=#` 说明进入了控制台

- `\l` 显示所有数据库列表
- `\c 数据库名称` 切换到数据库
- `\q` 退出控制台

```sql
【模板】
psql -h 服务器 -U 用户名 -d 数据库 -p 端口地址


```



## 数据类型

创建表格时每列都必须使用数据类型。 PotgresSQL 中主要有三类数据类型：

- 数值数据类型
- 字符串数据类型
- 日期/时间数据类



**数值型：**

| 类型名称   | 存储长度 | 描述                 | 范围                                         |
| ---------- | -------- | -------------------- | -------------------------------------------- |
| `smallint` | 2 字节   | 小范围整数           | [-32768, +32768)                             |
| `integer`  | 4 字节   | 常用范围整数         | [-2147483648, +2147483648)                   |
| `bigint`   | 8 字节   | 大范围整数           | [-9223372036854775807, +9223372036854775807) |
| `decimal`  | 可变长度 | 用户指定的精度，精确 | 小数点前 131072 位，小数点后 16383 位        |
| `numeric`  | 可变长度 | 用户指定的精度，精确 | 小数点前 131072 位，小数点后 16383 位        |
| `real`     | 4 字节   | 可变精度，不精确     | 6 位十进制数字精度                           |
| `double`   | 8 字节   | 可变精度，不精确     | 15 位十进制数字精度                          |



**字符串数据类型：**

`varchar` 不指定长度，可以存储最大长度（1GB）的字符串，而 `char` 不指定长度，默认则为 1

注意：如果超出规定长度，字符串会被截断，但不会报错。这个是 SQL 规定的

| 类型名称                  | 描述                                                    |
| ------------------------- | ------------------------------------------------------- |
| `char(size)`              | 固定长度字符数组，size 指定字符数，不足便以**空格**补齐 |
| `character(size)`         |                                                         |
| `varchar(size)`           | 可变长度字符数组，自动收缩，**不会以空格**补齐          |
| `character varying(size)` |                                                         |
| `text`                    | 可变长度字符串，无长度限制                              |



**日期和时间：**

| 类型名称    | 描述        |
| ----------- | ----------- |
| `timestamp` | 日期 & 时间 |
| `date`      | 仅日期      |
| `time`      | 仅时间      |



**其他数据类型：**

| 类型名称  | 描述                    |
| --------- | ----------------------- |
| `boolean` | 布尔值（true 或 false） |
| `money`   | 货币                    |
| ...       |                         |





## PostgresSQL 的差异化

PostgresSQL 与 MySQL、SQL Server 有 在编写 SQL 命令时有几点差异需要注意：

- `INSERT` 语句中的 `INTO` **不能省略**
- `DELECT` 语句中的 `FROM` **不能省略**
- 指定某个键（比如主键）自增的时候要用 `serial` 关键字，**且不能指定数据类型（会自动设为 int）**



```sql
INSERT INTO test(name) VALUES ('fox');  -- 【重点】INTO 不能省略
INSERT 		test(name) VALUES ('fox');  -- 报错


DELETE FROM test WHERE NAME='cat';  -- 【重点】FROM 不能省略
DELETE 		test WHERE NAME='cat';  --报错
```





## Schema

PostgreSQL 模式（Schema）可以看作是一个表的集合。一个 Schema 可以包含**视图、索引、数据类型、函数和操作符**。**相同的对象名称可以被用于不同模式中而不会冲突，**例如在同一数据库下 Schema1 和 Schema2 都可以包含同名的表。

使用 Schema 的优势：

- 允许多个用户使用一个数据库而不会相互干扰
- 将数据库对象组织成逻辑组以便更容易的管理
- 第三方应用的对象可以放在独立模式中，这样它们就不会与其他对象的名称发生冲突



Schema 类似于操作系统底层的目录，但是**不能嵌套**！

```sql
-- 创建 Schema
CREATE SCHEMA mySchema;

-- 在 Schema 中创建表
CREATE TABLE mySchema.student(
	id 			int						NOT NULL,
	name 		VARCHAR(255)	NOT NULL
);

-- 删除 Schema
DROP SCHEMA mySchema; -- 【重要】报错！如果 Schema 中不为空的话，不能删除！
DROP SCHEMA mySchema CASCADE; -- 【重要】加上 `CASCADE` 可以连同 Schema 中所有的对象一起删除
```





## 备份

**注意是在 shell 下执行，而不是数据库中**



**单数据库**

PostgreSQL 提供了 `pg_dump` 实用程序来简化备份单个数据库的过程。必须要以对备份数据库具有读取权限的用户身份运行命令。

1. 以 postgre 身份登录：

    ```sql
    sudo su - postgre
    ```

2. 通过一下命令将数据库中的内容转存至文件中：

    ```sql
    pg_dump 数据库名 > 备份文件名.bak
    ```

    运行此命令会生成备份文件：`备份文件名.bak`
    
3. 恢复数据库：

    1. 需要先创建一个空数据库
    2. 使用命令恢复备份

    ```sql
    psql 新数据库名 < 备份文件名.bak
    ```

    

备份格式有几种选择：

- `*.bak` 压缩二进制格式
- `*.sql` 明文转储
- `*.tar` tarball



> 注意：**默认情况下，PostgreSQL 将忽略备份过程中发生的任何错误。这可能会导致备份不完整！**
>
> 要防止这种情况，要使用 `-1` 选项运行 `pg_dump` 命令；这将会使整个备份视为单个事务，这将在发生错误时组织部分备份



---



**所有数据库**

由于 `pg_dump` ー次只创建一个数据库的备份，因此它**不会存储有关数据库角色或其他群集范围配置的信息**。 要存储此信息并同时备份所有数据库，可以使用 `pg_dumpall`

````sql
pg_dumpall > 备份文件名.bak
````

从备份还原所有数据库：

```sql
psql -f 备份文件名.bak 数据库名字
```



- **常用备份**

```sql
-- 导出指定数据库为 sql
pg_dump -U 用户名 -f /路径/文件名.sql 数据库名

-- 导出指定数据库的【表】为 sql
pg_dump -U 用户名 -f /路径/文件名.sql -t 表名 数据库名

-- 导出指定数据库为 tar 格式
pg_dump -U 用户名 -F t -f /路径/文件名.sql 数据库名

```



- **常用恢复**

    `pg_restore` 从 `pg_dump` 创建的备份文件中恢复 postgresSQL 数据库，用于恢复由 `pg_dump` 转储的任何非纯文本格式中的 PostgreSQL 数据库

    ```sql
    -- 恢复数据到指定数据库
    psql -U 用户名 -f /路径/文件名.sql 数据库名
    
    -- 恢复 文件名.tar 到指定数据库
    psql -U 用户名 -d 数据库名 /路径/文件名.tar
    ```

    







































































