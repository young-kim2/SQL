CREATE TABLE emaillist(
no number PRIMARY KEY,
last_name VARCHAR2(20),
first_name VARCHAR2(20),
email VARCHAR2(128),
create_at DATE DEFAULT sysdate);

CREATE SEQUENCE seq_emaillist_pk
START WITH 1
INCREMENT BY 1
NOCACHE;

INSERT INTO emaillist
VALUES(seq_emaillist_pk.NEXTVAL,
'홍',
'길동',
'hong@hwalbin.org',
sysdate);

INSERT INTO emaillist
VALUES(seq_emaillist_pk.NEXTVAL,
'고',
'길동',
'go@dooly.net',
sysdate);

SELECT*FROM emaillist;

commit;