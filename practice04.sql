/*
문제1.
평균 급여보다 적은 급여를 받는 직원은 몇명인지 구하시요
(56건)
*/
SELECT AVG(salary) FROM employees;
--서브 쿼리로 사용할 쿼리
SELECT COUNT(*)FROM employees
WHERE salary<(SELECT AVG(salary) FROM
employees);

/*
문제2.
평균급여 이상, 최대급여 이하의 월급을 받는 사원의
직원번호(employee_id), 이름(first_name),
급여(salary),평균급여, 최대급여를 
급여의 오름차순으로 정렬하여 출력하세요
(51건)
*/
--평균 급여, 최대 급여 쿼리->SUBQUERY->임시 테이블
--두 테이블을 Theta JOIN: BETWEEN 연산
SELECT ROUND(AVG(salary),0) avgSalary, MAX(salary) maxSalary
FROM employees;
--임시 테이블로 활용할 쿼리

SELECT employee_id, first_name, salary, avgSalary, maxSalary
FROM employees emp, (SELECT ROUND(AVG(salary),0) avgSalary, MAX(salary) maxSalary
FROM employees) t WHERE emp.salary between t.avgSalary and t.maxSalary
ORDER BY salary asc;

/*
문제3.
직원중 Steven(first_name) king(last_name)이 
소속된 부서 (departments)가 있는 곳의 
주소를 알아보려고 한다. 도시아이디(location_id), 거리명(street_address),
우편 번호(postal_code), 도시명(city), 주(state_province),
나라아이디(country_id)를 출력하세요
(1건)
*/
SELECT department_id FROM employees WHERE first_name='Steven' AND last_name='King';
SELECT location_id FROM departments WHERE
department_id=90;
SELECT location_id, city FROM locations WHERE
location_id=1700;

--최종 쿼리
SELECT location_id, street_address, postal_code, city,
       state_province, country_id
FROM locations
WHERE location_id=(SELECT location_id FROM departments
WHERE department_id=(SELECT department_id FROM employees
WHERE first_name='Steven' AND last_name='King')
);

/*
문제4
job_id가 'ST_MAN'인 직원의 급여보다 적은 직원의 
사번 이름 급여를 
급여의 내림차순으로 출력하세요 ALL연산자 사용
(74건)
*/
SELECT salary FROM employees WHERE job_id='ST_MAN';
--Multiline Subquery
SELECT employee_id, first_name, salary
FROM employees
WHERE salary < ALL(SELECT salary FROM employees
WHERE job_id='ST_MAN')
ORDER BY salary DESC;

/*
문제5.
각 부서별로 최고의 급여를 받는 사원의 
직원번호(employee_id), 이름(first_name)
과 급여(salary)
부서번호(department_id)를 조회하세요
단 조회결과는 급여의 내림차순으로 정렬되어
나타나야 합니다.
조건절 비교, 테이블 조인 2가지 방법으로 작성 하세요
(11건)
*/
--(조건별 비교)
--부서별 최고 급여를 받는 쿼리 (department_id, 최대급여)
--조건절 비교 IN
SELECT department_id, max(salary)
FROM employees
GROUP BY department_id; --부서별 최고 급여

SELECT employee_id, first_name, salary, department_id
FROM employees
WHERE (department_id, salary) IN (SELECT department_id,
max(salary)
FROM employees
GROUP BY department_id)
ORDER BY salary DESC;

--테이블 조인
SELECT employee_id, first_name, emp.salary, emp.department_id
FROM employees emp,(SELECT department_id, max(salary) salary
FROM employees
GROUP BY department_id)t
WHERE emp.salary=t.salary AND
emp.department_id=t.department_id;

/*
문제6
각 업무 (job)별로 연봉(salary)의 총합을 구하고자 합니다.
연봉총합이 가장 높은 업무부터 업무명(job_title)과 연봉 총합을 조회하시오
(19건)
*/
SELECT job_id, SUM(salary) sumSalary
FROM employees
GROUP BY job_id;

SELECT j.job_title,
       t.sumSalary,
       t.job_id,
       j.job_id
FROM jobs j, (SELECT job_id, SUM(salary)
sumSalary
FROM employees
GROUP BY job_id)t
WHERE j.job_id=t.job_id
ORDER BY sumSalary DESC;

/*
문제7
자신의 부서 평균 급여보다 연봉(salary)이 많은 직원의
직원번호(employee_id), 이름(first_name)과
급여(salary)를 조회하세요
(38건)
*/
SELECT department_id, AVG(salary) salary
FROM employees 
GROUP BY department_id;

SELECT employee_id, first_name, emp.salary 
FROM employees emp,(SELECT department_id,
AVG(salary) salary
FROM employees
GROUP BY department_id)t
WHERE emp.department_id=t.department_id
AND emp.salary > t.salary;

/*
문제8
직원 입사일이 11번째에서 15번째의 직원의 사번,
이름, 급여, 입사일을 입사일 순서로 출력하세요
*/
--입사일 순 정렬 쿼리
SELECT employee_id, first_name, salary, hire_date
FROM employees ORDER BY hire_date;
SELECT rownum rn, employee_id, first_name, salary, hire_date
FROM (SELECT employee_id, first_name, salary, hire_date
FROM employees ORDER BY hire_date);

SELECT rn, employee_id, first_name, salary, hire_date 
FROM (SELECT rownum rn, employee_id, first_name,salary, hire_date
FROM (SELECT employee_id, first_name, salary, hire_date FROM employees ORDER BY hire_date)
)
WHERE rn BETWEEN 11 AND 15;