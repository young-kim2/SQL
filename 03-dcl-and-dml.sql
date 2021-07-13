/*
사용자 생성
CREATE USER C##KIMY IDENTIFIED BY 1234;
-Oracle:사용자 생성->동일 이름의 SCHEMA도 같이 생성
사용자 삭제
DROP USER C##KIMY
DROP USER C##KIMY CASCADE -연결된 객체도 모두 삭제
권한을 가지지 않으면 아무일도 못해요
*/

--system으로 진행
--사용자 정보 확인
--USER_USERS:현재 사용자 관련 정보
--ALL_USERS:DB의 모든 사용자 정보
--DBA_USERS:모든 사용자의 상세정보 DBA Only)

--현재 사용자 확인
SELECT*FROM USER_USERS;
--전체 사용자 확인
SELECT*FROM ALL_USERS;

--로그인 권한 부여
CREATE USER C##KIMY IDENTIFIED BY 1234;
--로그인할 수 없는 상태
--적절한 권한을 부여해야 한다
GRANT create session TO C##KIMY;
--C##KIMY에게 세션 생성(로그인)권한을 부여

/*로그인 해서 다음의 쿼리를 수행해 봅니다.
CREATE TABLE test(a NUMBER);--권한 불충분
*/
GRANT connect, resource TO C##KIMY;
--접속과 자원 접근 롤을 C##KIMY에게 부여
--일반 데이터베이스 사용자로 활용 가능

/*다시 로그인 해서 다음의 쿼리를 수행해 봅니다.
CREATE TABLE test(a NUMBER); --테이블이 생성
SELECT*FROM tab;
DESC test;
INSERT INTO test
VALUES(10);
--테이블 스페이스 'USER'에 대한 권한이 없습니다.
*/

/*
보충 설명
Oracle 12이후
-일반 계정 구분하기 위해 C##접두어
-실제 데이터가 저장될 테이블 스페이스 마련해 줘야 한다
-USERS 테이블 스페이스에 공간을 마련
*/
/*C##없이 계정을 생성하는 방법 -팁*/
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
CREATE USER KIMY IDENTIFIED BY 1234;
/*사용자 데이터 저장 테이블 스페이스 부여
*/
ALTER USER C##KIMY DEFAULT TABLESPACE USERS;
--C##KIMY 사용자의 저장 공간을 USERS에 마련
QUOTA unlimited ON USERS;
--저장 공간 한도를 무한으로 부여

--ROLE의 생성
DROP ROLE dbuser;
CREATE ROLE dbuser;
--dbuser 역할을 만들어 여러개의 권한을 담아둔다
GRANT create session TO dbuser;
--dbuser 역할에 접속할 수 있는 권한을 부여

--ROLE을 GRANT하면 내부에 있는 개별 Privilege(권한)이 모두 부여
GRANT dbuser TO kimy;
--kimy 사용자에게 dbuser 역할을 부여
--권한의 회수 REVOKE
REVOKE dbuser FROM kimy;
--kimy 사용자로부터 dbuser 역할을 회수

--계정 삭제
DROP USER kimy CASCADE;

--현재 사용자에게 부여된 ROLE확인
--사용자 계정으로 로그인
show user;
SELECT*FROM user_role_privs;

--CONNECT 역할에는 어떤 권한이 포함되어 있는가?
DESC role_sys_privs;
SELECT*FROM role_sys_privs WHERE role='CONNECT';
--CONNECT롤이 포함하고 있는 권한
SELECT*FROM role_sys_privs WHERE role='RESOURCE';

SHOW USER;
--System 계정으로 진행
--HR 계정의 employees 테이블의 조회 권한을 C##KIMY에게 부여하고 싶다면(system)
GRANT SELECT ON hr.employees TO C##KIMY;
--권한의 부여
REVOKE SELECT ON hr.employees FROM C##KIMY;
--권한의 회수

--C##KIMY로 진행
SHOW USER;
SELECT*FROM hr.employees;
--hr.employees의 SELECT 권한을 부여받았으므로 테이블 조회 가능

-----------
--DDL
-----------

--내가 가진 table 확인
SELECT*FROM tab;
--테이블의 구조 확인
DESC test;

--테이블 삭제
DROP TABLE test;
SELECT*FROM tab;
--휴지통
PURGE RECYCLEBIN;
--삭제된 테이블은 휴지통에 보관

SELECT*FROM tab;

--CREATE TABLE
CREATE TABLE book(--컬럼 명세
    book_id NUMBER(5), --5자리 숫자
    title VARCHAR2(50), --50글자 가변문자
    author VARCHAR2(10), --10글자 가변 문자열
    put_date DATE DEFAULT SYSDATE --기본값은 현재시간
    );
DESC book;

--서브쿼리를 활용한 테이블 생성
--hr.employees 테이블을 기반으로 일부 데이터를 추출
--새 테이블
SELECT*fROM hr.employees WHERE job_id like 'IT_%';
CREATE TABLE it_emps AS(
       SELECT*FROM hr.employees WHERE job_id like 'IT_%'
       );

SELECT*FROM it_emps;
CREATE TABLE emp_summary AS(
       SELECT employee_id, first_name||' '||last_name full_name,
       hire_date, salary
       FROM hr.employees
       );
DESC emp_summary;

--author 테이블
DESC book;
CREATE TABLE author(
    author_id NUMBER(10),
    author_name VARCHAR2(100) NOT NULL, --NULL일 수 없다
    author_desc VARCHAR2(500),
    PRIMARY KEY(author_id) --author_id 컬럼을 PK로
    );
    DESC author;
    
--book테이블에 author 테이블 연결을 위해
--book 테이블의 author 컬럼을 삭제:DROP COLUMN
ALTER TABLE book
DROP COLUMN author;
DESC book;

--author 테이블 참조를 위한 author_id 컬럼을 book에 추가
ALTER TABLE book
ADD(author_id NUMBER(10));
DESC book;

--book 테이블의 PK로 사용할 book_id도 NUMBER(10)으로 변경
ALTER TABLE book
MODIFY(book_id NUMBER(10));

--제약조건의 추가:ADD CONSTRAINT
--book 테이블의 book_id를 PRIMARY KEY 제약조건 부여
ALTER TABLE book
ADD CONSTRAINT pk_book_id PRIMARY KEY(book_id);
DESC book;

--FOREIGN KEY 추가
--book 테이블의 author_id가 author의 author_id를 참조
ALTER TABLE book
ADD CONSTRAINT fk_author_id FOREIGN KEY(author_id)
REFERENCES author(author_id);

--COMMENT
COMMENT ON TABLE book IS 'Book Information';
COMMENT ON TABLE author IS 'Author Information';

--테이블 커맨트 확인
SELECT*FROM user_tab_comments;
SELECT comments FROM user_tab_comments
WHERE table_name='BOOK';

--Data Dictionary
--Oracle은 내부에서 발생하는 모든 정보를 Data Dictionary에 담아두고 있다.
--계정별로 USER_(일반 사용자), ALL_(전체 사용자), DBA_(관리자 전용) 접근 범위를 제한함
--모든 딕셔너리 확인
SHOW user;
SELECT*FROM dictionary;

--DBA_딕셔너리 확인
--dba로 로그인 필요 as sysdba