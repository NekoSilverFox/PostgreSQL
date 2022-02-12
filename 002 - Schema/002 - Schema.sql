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

