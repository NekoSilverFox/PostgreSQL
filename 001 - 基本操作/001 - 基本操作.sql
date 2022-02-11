CREATE TABLE test(
	id serial PRIMARY KEY, -- serial 表示 id 是自增的
	name varchar(255)
);


INSERT INTO test(name) VALUES ('fox')  --【重点】INTO 不能省略
INSERT INTO test(name) VALUES ('cat')


SELECT * FROM test;


UPDATE test SET NAME='Silverfox' WHERE ID=1


SELECT * FROM test;


DELETE FROM test WHERE NAME='cat';  -- 【重点】FROM 不能省略