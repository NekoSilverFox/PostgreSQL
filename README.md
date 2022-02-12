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







































































