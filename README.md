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
- `\du` 查看当前的用户和对应权限的列表

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

日期操作

+ 日期之差

    --**获取秒差**
    ```SELECT round(date_part('epoch', TIMESTAMP '2019-05-05 12:11:20' - TIMESTAMP '2019-05-05 10:10:10'));```

    --**获取分钟差**
    ```SELECT round(date_part('epoch', TIMESTAMP '2019-05-05 12:11:20' - TIMESTAMP '2019-05-05 10:10:10')/60);```

    --**获取小时差**
    ```SELECT round(date_part('epoch', TIMESTAMP '2019-05-05 12:11:20' - TIMESTAMP '2019-05-05 10:10:10')/60/60);```

    --**获取天数差**
    ```SELECT Date('2019-06-05') - Date('2019-05-03');```
    --**获取月份差**
    ```select extract(year from age(TIMESTAMP '2018-04-05',TIMESTAMP '2017-02-04')) * 12  + extract(MONTH from age(TIMESTAMP '2019-04-05',TIMESTAMP '2017-02-04'));```
    --**获取年份差**
    ```SELECT extract(year from age(TIMESTAMP '2018-04-05',TIMESTAMP '2017-02-04'));```





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

    





## 用户操作

- **创建用户：**

    ```sql
    CREATE USER '用户名' WITH PASSWORD '密码'
    ```

    

- **修改密码**

    ```sql
    ALTER USER '用户名' WITH PASSWORD '密码'
    ```

    

- **数据库授权，赋予指定账户指定数据库和表权限**

    ```sql
    -- 注意，这时候用户只是有数据库权限而没有表权限
    GRANT ALL PRIVILEGES ON DATABASE '数据库名' TO '用户名'
    
    -- 然后需要将所有表的读写权限赋予该用户
    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO '用户名'
    ```

    

- **移除指定用户数据库和表的所有权限**

    ```sql
    REVOKE ALL PRIVILEGES ON DATABASE '数据库名' FROM '用户名'
    
    -- 然后移除所有表的读写权
    REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO '用户名'
    ```

    

- **删除用户**

    比如移除权限后才能删除！

    ```sql
    DROP USER '用户名'
    ```

    

## 角色管理



## 自定义函数

**自定义函数语法：**

```sql
CREATE FUNCTION					-- 声明创建函数
	add(integer, integer)		-- 定义函数名称，参数类型

RETURNS integer					-- 定义返回值类型
	AS 'select $1 + $2'			-- 实现函数体

LANGUAGE SQL					-- 用以实现函数的语言名字
RETURNS NULL ON NULL INPUT;		-- 定义参数为 NULL 时处理情况
```



**删除自定义函数：**

```sql
-- 删除函数
DROP FUNCTION 函数名(参数列表)
```





## 索引

索引类似于一本书的目录，提高查找效率

如果数据库中没有建立索引，数据库只能一条一条的往下查，效率很低，如果数据量巨大，那么查找的时间将会非常长。而有了索引之后，数据库能够通过索引快速查找数据



**优点：**

- 提高了数据的查询速度
- 加速表与表之间的连接

**缺点：**

- 创建和维护索引需要耗费时间，这一列数据发生变化，索引就要进行相应的更新
- 需要占用磁盘空间



**PostgreSQL 中具有以下索引：**

| 索引名称    | 使用场景                                         |
| ----------- | ------------------------------------------------ |
| B-Tree 索引 | 适合那些能够按顺序存储的索引（默认）             |
| Hash 索引   | 只能处理简单的等于比较                           |
| GiST 索引   | 是一种索引架构，我们可以按照需求和场景自定义索引 |
| GIN 索引    | 反转索引，处理包含多个值的键                     |



**创建及删除：**

```sql
CREATE INDEX IX_索引名 ON tb_表名(字段名)

DROP INDEX IX_索引名
```





## 视图

视图是一张**虚拟表**，它表示一张表的部分数据或多张表的综合数据，其结构和数据是建立在对表的查询基础上

视图在操作上和数据表没有什么区别，但两者的差异是其本质是不同数据表是实际存储记录的地方，然而视图并不保存任何记录。

相同的数据表，根据不同用户的不同需求，可以创建不同的视图（不同的查询语句）



**作用：**

- 简单化，屏蔽底层的查询
- 安全性，比如与另一个公司进行数据交互，屏蔽敏感数据
- 逻辑数据独立性，上层业务在调用时，不需要考虑数据表的改变



## 事务



### 事务隔离级别（MySQL）

| 问题       | 说明                                               |
| ---------- | -------------------------------------------------- |
| 可重复读   | 不管执行多少次查询的都是相同的结果                 |
| 不可重复读 | 如果别的事务更新了数据，则查询到的是更新之后的数据 |
| 幻读       | 明明有数据但是读读不到，插插不进去                 |
| 脏读       | 读到了别的事务还没 commit 的数据                   |

**说明及特点：**

| 隔离界别          | 说明                                                         | 脏读 | 不可重复读 | 幻读 |
| ----------------- | ------------------------------------------------------------ | ---- | ---------- | ---- |
| `serializable`    | 一个时间段只能有一个事物，安全最高，但性能最差               | -    | -          | -    |
| `repeatable read` | （默认）可重复读 \| 幻读，在同一个事务中执行相同的 SQL，不管执行多少次查询的都是相同的结果。看不到别的事务提交的数据 | -    | -          | +    |
| `read commited`   | 不可重复读 \| 幻读；可以读到提交后的数据。能看到别的事务提交的数据 | -    | +          | +    |
| `read uncommited` | 不可重复读 \| 幻读 \| 脏读，脏读是读到别的事务没有提交的数据 | +    | +          | +    |



测试：

- **serializable**

|                                                              |                                                              |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `set session transaction isolation level serializable`       | 设置事务隔离级别                                             |
|                                                              | `start transaction`<br />`update user set money=100 where name='张三'` |
| `start transaction`<br />`update user set money=99 where name='张三'`<br /><br />>>> **在转圈，因为设置了模式为 `serializable`，某一时刻只能有一个事物执行。等待右侧试执行完成才能开始** |                                                              |
|                                                              | `committ;` 提交事务，money 变成 100                          |
| 事务可以（开始）执行，上面两句被执行                         |                                                              |
| `commit;` 提交事务，money 变成 99                            |                                                              |



- **repeatable read**

    | 窗口 1                                                       | 窗口 2                                                       |
    | ------------------------------------------------------------ | ------------------------------------------------------------ |
    | `set session transaction isolation level repeatable read`    | `set session transaction isolation level repeatable read`    |
    | `start transaction`<br />`select money from user where name='张三'`<br />>>><br />99 |                                                              |
    |                                                              | `start transaction`<br />`update user set money=100 where name='张三'`<br />`committ;` |
    |                                                              | `select money from user where name='张三'`<br />>>><br />100 |
    | `select money from user where name='张三'`<br />>>><br />99  |                                                              |
    | `commit`                                                     |                                                              |
    | `select money from user where name='张三'`<br />>>><br />100 |                                                              |

    

- **幻读**

    案例现象：读读不到，插插不进去

    | 窗口 1                                                       | 窗口 2                                                       |
    | ------------------------------------------------------------ | ------------------------------------------------------------ |
    | `set session transaction isolation level repeatable read`    | `set session transaction isolation level repeatable read`    |
    | `start transaction`<br />`select money from user where name='王五'`<br />>>><br />无结果 |                                                              |
    |                                                              | `start transaction`<br />`insert user(name, money) values('王五', 1)`<br />`commit` |
    | `select money from user where name='王五'`<br />>>><br />无结果 |                                                              |
    | `insert user(name, money) values('王五', 1)`<br />>>><br />报错，王五已经存在 |                                                              |

    

- `read committed`

    | 窗口 1                                                       | 窗口 2                                                       |
    | ------------------------------------------------------------ | ------------------------------------------------------------ |
    | `set session transaction isolation level read committed`     | `set session transaction isolation level read committed`     |
    | `start transaction`<br />`select money from user where name='张三'`<br />>>><br />100 |                                                              |
    |                                                              | `start transaction`<br />`update user set money=101 where name='张三'`<br />`commit;` |
    | `select money from user where name='张三'`<br />>>><br />101 |                                                              |



- **幻读**

    | 窗口 1                                                       | 窗口 2                                                       |
    | ------------------------------------------------------------ | ------------------------------------------------------------ |
    | `set session transaction isolation level read committed`     | `set session transaction isolation level read committed`     |
    | `start transaction`<br />`select money from user where name='王五'`<br />>>><br />无结果 |                                                              |
    |                                                              | `start transaction`<br />`select money from user where name='王五'`<br />>>><br />无结果 |
    |                                                              | `insert user(name, money) values('王五', 1)`<br />>>><br />陷入等待 |
    |                                                              |                                                              |
    |                                                              |                                                              |
    |                                                              |                                                              |



- read UNcommitted **脏读**

    | 窗口 1                                                       | 窗口 2                                                       |
    | ------------------------------------------------------------ | ------------------------------------------------------------ |
    | `set session transaction isolation level read UNcommitted`   | `set session transaction isolation level read committed`     |
    | `start transaction`<br />`select money from user where name='王五'`<br />>>><br />1 |                                                              |
    |                                                              | `start transaction`<br />`update user set money=101 where name='张三'`<br /> |
    | `select money from user where name='王五'`<br />>>>**脏读 \| 不可重复读（右边还没 commit）**<br />101 |                                                              |
    |                                                              |                                                              |
    |                                                              |                                                              |
    |                                                              |                                                              |



- read UNcommitted 幻读

    | 窗口 1                                                       | 窗口 2                                                       |
    | ------------------------------------------------------------ | ------------------------------------------------------------ |
    | `set session transaction isolation level read UNcommitted`   | `set session transaction isolation level read committed`     |
    | `start transaction`<br />`select * from user`<br />>>><br />张三 101<br />李四 1<br />王五 101 |                                                              |
    |                                                              | `start transaction`<br />`insert user(name, money) values('赵六', 1)`<br /> |
    | `select * from user`<br />>>><br />张三 101<br />李四 1<br />王五 101<br />赵六 1 |                                                              |
    | `delete user where name='赵六'`<br />>>> <br />陷入等待，因为右侧还没提交。明明有赵六这条数据但是删不掉，产生幻读 |                                                              |
    |                                                              |                                                              |
    |                                                              |                                                              |
    |                                                              |                                                              |
    |                                                              |                                                              |





## 事务（经过测试后的结果）

| 隔离界别          | 脏读 | 不可重复读 | 幻读 |
| ----------------- | ---- | ---------- | ---- |
| `serializable`    | -    | -          | -    |
| `repeatable read` | -    | -          | -    |
| `read commited`   | -    | +          | +    |
| `read uncommited` | -    | +          | +    |

---





### READ UNCOMMITTED

- 脏读、不可重复读

    | 窗口 1                                                       | 窗口 2                                                       |
    | ------------------------------------------------------------ | ------------------------------------------------------------ |
    | `BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;`<br />`SHOW TRANSACTION_ISOLATION;`<br /><br />>>><br />*read uncommitted* |                                                              |
    |                                                              | `BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;`<br />`SHOW TRANSACTION_ISOLATION;`<br /><br />>>><br />*read uncommitted* |
    | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>><br />1000 |                                                              |
    |                                                              | `UPDATE tb_ports SET price=2000 WHERE nameport='baku';`      |
    |                                                              | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>><br />2000 |
    | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>>==[无]脏读==<br />1000 |                                                              |
    |                                                              | `COMMIT;`                                                    |
    | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>>==不可重复读==<br />2000 |                                                              |
    | `COMMIT;`                                                    |                                                              |



- 更改丢失

    | 窗口 1                                                       | 窗口 2                                                       |
    | ------------------------------------------------------------ | ------------------------------------------------------------ |
    | `BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;`<br />`SHOW TRANSACTION_ISOLATION;`<br /><br />>>><br />*read uncommitted* |                                                              |
    |                                                              | `BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;`<br />`SHOW TRANSACTION_ISOLATION;`<br /><br />>>><br />*read uncommitted* |
    | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>><br />1000 |                                                              |
    |                                                              | `UPDATE tb_ports SET price=2000 WHERE nameport='baku';`      |
    |                                                              | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>><br />2000 |
    | `UPDATE tb_ports SET price=3000 WHERE nameport='baku';`<br /><br />>>> <br />**窗口等待中** |                                                              |
    |                                                              | `COMMIT;`                                                    |
    | `COMMIT;`                                                    |                                                              |
    |                                                              | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>>==[无]丢失的更改==<br />3000 |





- **幻读**

    | 窗口 1                                                       | 窗口 2                                                       |
    | ------------------------------------------------------------ | ------------------------------------------------------------ |
    | `BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;`<br />`SHOW TRANSACTION_ISOLATION;`<br /><br />>>><br />*read uncommitted* |                                                              |
    |                                                              | `BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;`<br />`SHOW TRANSACTION_ISOLATION;`<br /><br />>>><br />*read uncommitted* |
    | `SELECT price FROM tb_ports WHERE nameport='baku2';`<br /><br />>>><br />(0 rows) |                                                              |
    |                                                              | `INSERT INTO tb_Ports(Country, NamePort, Price, LevelID)`<br />` VALUES('Azerbaijan', 'baku2', 2222, 3);` |
    | `SELECT price FROM tb_ports WHERE nameport='baku2';`<br /><br />>>><br />(0 rows) |                                                              |
    |                                                              | `COMMIT;`                                                    |
    | `SELECT price FROM tb_ports WHERE nameport='baku2';`<br /><br />>>>==幻读==<br />2222 |                                                              |
    | `DELETE FROM tb_ports WHERE nameport='baku2';`               |                                                              |
    | `COMMIT;`                                                    |                                                              |






---





### READ COMMITTED

- 脏读、不可重复读

    | 窗口 1                                                       | 窗口 2                                                       |
    | ------------------------------------------------------------ | ------------------------------------------------------------ |
    | `BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;`<br />`SHOW TRANSACTION_ISOLATION;`<br /><br />>>><br />*read committed* |                                                              |
    |                                                              | `BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;`<br />`SHOW TRANSACTION_ISOLATION;`<br /><br />>>><br />*read committed* |
    | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>><br />1000 |                                                              |
    |                                                              | `UPDATE tb_ports SET price=2000 WHERE nameport='baku';`      |
    |                                                              | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>><br />2000 |
    | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>>==[无]脏读==<br />1000 |                                                              |
    |                                                              | `COMMIT;`                                                    |
    | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>>==不可重复读==<br />2000 |                                                              |
    | `COMMIT;`                                                    |                                                              |





- 更改丢失

    | 窗口 1                                                       | 窗口 2                                                       |
    | ------------------------------------------------------------ | ------------------------------------------------------------ |
    | `BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;`<br />`SHOW TRANSACTION_ISOLATION;`<br /><br />>>><br />*read committed* |                                                              |
    |                                                              | `BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;`<br />`SHOW TRANSACTION_ISOLATION;`<br /><br />>>><br />*read committed* |
    | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>><br />1000 |                                                              |
    |                                                              | `UPDATE tb_ports SET price=2000 WHERE nameport='baku';`      |
    |                                                              | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>><br />2000 |
    | `UPDATE tb_ports SET price=3000 WHERE nameport='baku';`<br /><br />>>> <br />**窗口等待中** |                                                              |
    |                                                              | `COMMIT;`                                                    |
    | `COMMIT;`                                                    |                                                              |
    |                                                              | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>>==[无]丢失的更改==<br />3000 |





- **幻读**

    | 窗口 1                                                       | 窗口 2                                                       |
    | ------------------------------------------------------------ | ------------------------------------------------------------ |
    | `BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;`<br />`SHOW TRANSACTION_ISOLATION;`<br /><br />>>><br />*read committed* |                                                              |
    |                                                              | `BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;`<br />`SHOW TRANSACTION_ISOLATION;`<br /><br />>>><br />*read committed* |
    | `SELECT price FROM tb_ports WHERE nameport='baku2';`<br /><br />>>><br />(0 rows) |                                                              |
    |                                                              | `INSERT INTO tb_Ports(Country, NamePort, Price, LevelID)`<br />` VALUES('Azerbaijan', 'baku2', 2222, 3);` |
    | `SELECT price FROM tb_ports WHERE nameport='baku2';`<br /><br />>>><br />(0 rows) |                                                              |
    |                                                              | `COMMIT;`                                                    |
    | `SELECT price FROM tb_ports WHERE nameport='baku2';`<br /><br />>>>==幻读==<br />2222 |                                                              |
    | `DELETE FROM tb_ports WHERE nameport='baku2';`               |                                                              |
    | `COMMIT;`                                                    |                                                              |



---



### REPEATABLE READ

- 脏读、不可重复读

    | 窗口 1                                                       | 窗口 2                                                       |
    | ------------------------------------------------------------ | ------------------------------------------------------------ |
    | `BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;`<br />`SHOW TRANSACTION_ISOLATION;`<br /><br />>>><br />*repeatable read* |                                                              |
    |                                                              | `BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;`<br />`SHOW TRANSACTION_ISOLATION;`<br /><br />>>><br />*repeatable read* |
    | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>><br />1000 |                                                              |
    |                                                              | `UPDATE tb_ports SET price=2000 WHERE nameport='baku';`      |
    |                                                              | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>><br />2000 |
    | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>>==[无]脏读==<br />1000 |                                                              |
    |                                                              | `COMMIT;`                                                    |
    | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>>==可重复读==<br />1000 |                                                              |
    | `COMMIT;`                                                    |                                                              |





- 更改丢失

    | 窗口 1                                                       | 窗口 2                                                       |
    | ------------------------------------------------------------ | ------------------------------------------------------------ |
    | `BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;`<br />`SHOW TRANSACTION_ISOLATION;`<br /><br />>>><br />*repeatable read* |                                                              |
    |                                                              | `BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;`<br />`SHOW TRANSACTION_ISOLATION;`<br /><br />>>><br />*repeatable read* |
    | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>><br />1000 |                                                              |
    |                                                              | `UPDATE tb_ports SET price=2000 WHERE nameport='baku';`      |
    |                                                              | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>><br />2000 |
    | `UPDATE tb_ports SET price=3000 WHERE nameport='baku';`<br /><br />>>> <br />**窗口等待中** |                                                              |
    |                                                              | `COMMIT;`                                                    |
    | >>><br />ERROR:  could not serialize access due to concurrent update |                                                              |
    | `ROLLBACK;`                                                  |                                                              |
    |                                                              | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>>==丢失的更改==<br />2000 |





- **幻读**

    | 窗口 1                                                       | 窗口 2                                                       |
    | ------------------------------------------------------------ | ------------------------------------------------------------ |
    | `BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;`<br />`SHOW TRANSACTION_ISOLATION;`<br /><br />>>><br />*repeatable read* |                                                              |
    |                                                              | `BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;`<br />`SHOW TRANSACTION_ISOLATION;`<br /><br />>>><br />*repeatable read* |
    | `SELECT price FROM tb_ports WHERE nameport='baku2';`<br /><br />>>><br />(0 rows) |                                                              |
    |                                                              | `INSERT INTO tb_Ports(Country, NamePort, Price, LevelID)`<br />` VALUES('Azerbaijan', 'baku2', 2222, 3);` |
    | `SELECT price FROM tb_ports WHERE nameport='baku2';`<br /><br />>>><br />(0 rows) |                                                              |
    |                                                              | `COMMIT;`                                                    |
    | `SELECT price FROM tb_ports WHERE nameport='baku2';`<br /><br />>>>==[无] 幻读==<br />(0 rows) |                                                              |
    | `DELETE FROM tb_ports WHERE nameport='baku2';`               |                                                              |
    | `COMMIT;`                                                    |                                                              |



---



### SERIALIZABLE

- **脏读、不可重复读**

    | 窗口 1                                                       | 窗口 2                                                       |
    | ------------------------------------------------------------ | ------------------------------------------------------------ |
    | `BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;`<br />`SHOW TRANSACTION_ISOLATION;`<br /><br />>>><br />*serializable* |                                                              |
    |                                                              | `BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;`<br />`SHOW TRANSACTION_ISOLATION;`<br /><br />>>><br />*serializable* |
    | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>><br />1000 |                                                              |
    |                                                              | `UPDATE tb_ports SET price=2000 WHERE nameport='baku';`      |
    |                                                              | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>><br />2000 |
    | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>>==[无]脏读==<br />1000 |                                                              |
    |                                                              | `COMMIT;`                                                    |
    | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>>==可重复读==<br />1000 |                                                              |
    | `COMMIT;`                                                    |                                                              |





- **更改丢失**

    | 窗口 1                                                       | 窗口 2                                                       |
    | ------------------------------------------------------------ | ------------------------------------------------------------ |
    | `BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;`<br />`SHOW TRANSACTION_ISOLATION;`<br /><br />>>><br />*serializable* |                                                              |
    |                                                              | `BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;`<br />`SHOW TRANSACTION_ISOLATION;`<br /><br />>>><br />*serializable* |
    | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>><br />1000 |                                                              |
    |                                                              | `UPDATE tb_ports SET price=2000 WHERE nameport='baku';`      |
    |                                                              | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>><br />2000 |
    | `UPDATE tb_ports SET price=3000 WHERE nameport='baku';`<br /><br />>>> <br />**窗口等待中** |                                                              |
    |                                                              | `COMMIT;`                                                    |
    | >>><br />ERROR:  could not serialize access due to concurrent update |                                                              |
    | `ROLLBACK;`                                                  |                                                              |
    |                                                              | `SELECT price FROM tb_ports WHERE nameport='baku';`<br /><br />>>>==丢失的更改==<br />2000 |







- **幻读**

    | 窗口 1                                                       | 窗口 2                                                       |
    | ------------------------------------------------------------ | ------------------------------------------------------------ |
    | `BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;`<br />`SHOW TRANSACTION_ISOLATION;`<br /><br />>>><br />*serializable* |                                                              |
    |                                                              | `BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;`<br />`SHOW TRANSACTION_ISOLATION;`<br /><br />>>><br />*serializable* |
    | `SELECT price FROM tb_ports WHERE nameport='baku2';`<br /><br />>>><br />(0 rows) |                                                              |
    |                                                              | `INSERT INTO tb_Ports(Country, NamePort, Price, LevelID)`<br />` VALUES('Azerbaijan', 'baku2', 2222, 3);` |
    | `SELECT price FROM tb_ports WHERE nameport='baku2';`<br /><br />>>><br />(0 rows) |                                                              |
    |                                                              | `COMMIT;`                                                    |
    | `SELECT price FROM tb_ports WHERE nameport='baku2';`<br /><br />>>>==[无] 幻读==<br />(0 rows) |                                                              |
    | `DELETE FROM tb_ports WHERE nameport='baku2';`               |                                                              |
    | `COMMIT;`                                                    |                                                              |











## 触发器

概述：

触发器是某个数据库操作发生时被自动调用的函数。可以在INSERT、UPDATE或DELETE操作之前或之后调用触发器。PostgreSQL支持两种类型的触发器，一种是数据行级触发器，另外一种是语句级触发器。对于**数据行级的触发器，触发触发器的语句每操作一个数据行，它就被执行一次**。对于**语句级的触发器，它只会被执行一次**。



创建：

创建触发器以前，必须定义触发器使用的函数。这个**函数不能有任何参数**，它的返回值的类型必须是trigger。函数定义好以后，用命令CREATE TRIGGER创建触发器。多个触发器可以使用同一个函数。



参数：

定义触发器的时候，也可以为它指定参数（在CREATE TRIGGER命令中中指定）。系统提供了特殊的接口来访问这些参数。



执行顺序：

- 触发器按按执行的时间被分为**before触发器**和**after触发器**。**语句级的before触发器在语句开始执行前被调用，语句级的after触发器在语句开始执行结束后被调用。**
- 数据行级的before触发器在操作每个数据行以前被调用，数据行级的after触发器在操作每个数据行以后被调用。
- 如果同一表上同对同一个事件定义了多个触发器，这些触发器将按它们的名字的字母顺序被触发。
- 对于行级before触发器来说，前一个触发器返回的数据行作为后一个触发器的输入。如果任何一个行级before触发器返回NULL，后面的触发器将停止执行，触发触发器的INSERT/UPDATE/DELETE命令也不会被执行。



































