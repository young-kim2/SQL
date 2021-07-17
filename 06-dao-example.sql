--DAO 객체 생성 연습
--사용자 계정으로 접속
DROP TABLE author CASCADE CONSTRAINTS;
DROP TABLE book;
SELECT*FROM user_objects;
DROP SEQUENCE seq_author_id;

CREATE TABLE author(
id NUMBER(10),
name VARCHAR2(50) NOT NULL,
bio VARCHAR2(100),
PRIMARY KEY(id)
);