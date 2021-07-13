-------------
--DML:데이터 조작어
-------------
--author 테이블에 데이터 입력
--INSERT
DESC author;

--묵시적 방법:데이터 넣을 컬럼을 지정하지 않는 경우
--정의된 순서에 따라서 값을 입력
INSERT INTO author
VALUES(1,'박경리','토지 작가');

--명시적 방법
--데이터 넣을 컬럼을 지정, 지정한 컬럼 순서대로 데이터 제공,
--명시되지 않은 컬럼은 NULL 입력-> NOT NULL 제약조건이 있는 필드는 오류
INSERT INTO author(author_id,author_name)
--입력 컬럼 제공
VALUES(2,'김영하');

SELECT*FROM author;

--CMD에서 sqlplus

--INSERT, UPDATE, DELETE 작업을 수행하면 Transaction이 수행
--작업이 완료되었을 때
--원래대로 복원:ROLLBACK
--영구 저장: COMMIT
COMMIT;

--BOOK 테이블 데이터 입력
SELECT*FROM book;
INSERT INTO book
VALUES(2,'살인자의 기억법',sysdate,2);
SELECT*FROM book;

INSERT INTO book
VALUES(3,'홍길동전',sysdate,3);
--authot_id는 author.author_id를 FK 참조하고 있으므로
--제약조건 위반

--트랜잭션 이전으로 복구하고 싶다면
ROLLBACK;
SELECT*FROM book;

--UPDATE table SET 컬럼명=값, 컬럼명=값;
UPDATE author SET author_desc='알쓸신잡 출연';
SELECT*FROM author;

--UPDATE시 조건을 부여하지 않으면 모든 레코드 변경->주의
ROLLBACK;
SELECT*FROM author;

UPDATE author SET author_desc='알쓸신잡 출연'
WHERE author_id='2'; --UPDATE~WHERE 절을 부여하도록 하자
SELECT*FROM author;

--임시 테이블 생성
--hr.employees 테이블로부터 department_id가 10,20,30인 사람들만 뽑아서
--새 테이블 생성
CREATE TABLE emp_123 AS
       (SELECT*FROM hr.employees
               WHERE department_id IN(10,20,30));
DESC emp_123;

--연습: 부서가 30인 직원들의 급여를 10% 인상해 봅니다.
SELECT*FROM emp_123 WHERE department_id=30;
UPDATE emp_123
SET salary=salary+salary*0.1
WHERE department_id=30;

COMMIT;

--DELETE FROM 테이블명 WHERE 삭제 조건
SELECT*FROM emp_123;
--job_id가 mk로 시작하는 직원을 삭제
DELETE FROM emp_123
WHERE job_id LIKE 'MK_%';
SELECT*FROM emp_123;

--WHERE 절이 없는 DELETE는 모든 레코드를 삭제
DELETE FROM emp_123;
SELECT*FROM emp_123;

--DELETE는 Transaction의 대상->ROLLBACK 가능
ROLLBACK;
SELECT*FROM emp_123;

--TRUNCATE: 테이블 비우기
TRUNCATE TABLE emp_123;
--주의: TRUNCATE는 Transaction의 대상이 아니다->ROLLBACK 불가
ROLLBACK;
SELECT*FROM emp_123;
