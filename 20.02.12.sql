--1. table full
--2. idx1 : empno
--3. idx2 : job
EXPLAIN PLAN FOR
SELECT
    *
FROM emp 
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT
    *
FROM TABLE(dbms_xplan.display);

CREATE INDEX idx_emp_03 ON emp(job, ename);
EXPLAIN PLAN FOR
SELECT
    *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT job, ename, rowid
FROM emp
WHERE job = 'MANAGER';

--1. table full
--2. idx1 : empno
--3. idx2 : job
--4. idx3 : job + enmae
--5. idx4 : ename + job

CREATE INDEX idx_emp_04 ON emp(ename, job);
SELECT ename, job, rowid
FROM emp
ORDER BY ename, job;
--3번째 인덱스를 지워야한다
--3,4번째 인덱스가 컬럼 구성이 동일하고 순서만 다르다
DROP INDEX idx_emp_03;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT
    *
FROM TABLE(dbms_xplan.display);

--emp : table full pk_emp(empno)
--dept : table full pk_dept(deptno)

--emp -> table full, dept -> table full
--detp -> table full, emp -> table full

--emp -> table full, dept -> pk_dept
--detp -> pk_dept, emp -> table full

--emp -> pk_emp, dept -> table full
--detp -> table full, emp -> pk_emp

--emp -> pk_emp, dept -> pk_dept
--dept -> pk_dept, emp -> pk_emp

--1.순서
--oracle -> 실시간 응답 : OLTP (ON LINE TRANSACTION PROCESSING)
--       -> 전체 처리시간 : OLAP (ON LINE ANALISYS PROCESSING) - 복잡한 쿼리의 실행계획을 세우는데 30M~1H
--2개 테이블 조인
--각각의 테이블에 인덱스 5개씩 있다면 한 테이블에 접근 전략 : 6
--36 * 2 = 72

--EMP부터 읽을까 DEPT부터 읽을까?
EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.empno = 7788;
 
SELECT
    *
FROM TABLE(DBMS_XPLAN.DISPLAY);
--읽는 순서 : 4 - 3 - 5 - 2 - 6 - 1 - 0

--인덱스 1번
--WHERE 1 = 1 의 의미 : 테이블의 구조와 내용 전부 복사
--ctas : 제약조건 복사가 not null만 가능
--      ->백업이나 테스트용으로 사용
CREATE TABLE dept_test2 AS
SELECT
    *
FROM dept
WHERE 1 = 1;

CREATE UNIQUE INDEX pk_dept2_deptno
ON dept_test2(deptno);

CREATE INDEX pk_dept2_dname 
ON dept_test2(dname);

CREATE INDEX pk_dept2_deptno_dname 
ON dept_test2(deptno, dname);

--2번
DROP INDEX pk_dept2_deptno;
DROP INDEX pk_dept2_dname;
DROP INDEX pk_dept2_deptno_dname;

--3번
--3-1
CREATE UNIQUE INDEX idx_u_emp_01  
ON emp(empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = :empno;

SELECT
    *
FROM TABLE(dbms_xplan.display);

--3-2
CREATE INDEX idx_n_emp_02  
ON emp(ename);

EXPLAIN PLAN FOR
SELECT
    *
FROM emp
WHERE ename = :ename;

SELECT
    *
FROM TABLE(dbms_xplan.display);

--3-3




--3-4
CREATE UNIQUE INDEX idx_u_emp_04 
ON emp(deptno, sal, empno);

EXPLAIN PLAN FOR
SELECT *
FROM EMP
WHERE sal BETWEEN :st_sal AND :ed_sal
AND deptno = :deptno;

SELECT
    *
FROM TABLE(dbms_xplan.display);

--3-5

CREATE UNIQUE INDEX idx_u_emp_05 
ON emp(deptno, mgr, empno);

drop index idx_u_emp_05; 

--3-6
CREATE UNIQUE INDEX idx_u_dept_06  
ON emp(deptno);

--3번 답
--empno(=)
--ename(=) ==>밑에서 기술하기 때문에 없어도 된다
--deptno(=), empno(LIKE 직원번호%) ==>empno, deptno(empno는 대체 가능)
--deptno(=), sal (between)
--deptno(=)/ mgr 동반하면 유리
--deptno, hiredate가 인덱스 존재하면 유리

--4번

