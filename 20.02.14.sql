--report group function
--1. ROLLUP
--      - GROUP BY ROLLUP(컬럼1, 컬럼2)
--      - ROLLUP절에 기술한 컬럼을 오른쪽에서 하나씩 제거한 컬럼으로 SUBGROUP
--      - GROUP BY 컬럼1, 컬럼2
--        UNION
--        GROUP BY 컬럼1
--        UNION
--        GROUP BY
--2. CUBE
--3. GROUPING SETS
--3, 1 >>>>>>>> 2 순으로 사용빈도

--GROUPING SETS
--순서와 관계없이 서브 그룹을 사용자가 직접 선언
--사용방법 : GROUP BY GROUPING SETS(col1, col2..)
--GROUP BY GROUPING SETS(col1, col2)
-->GROUP BY col1
-- UNION ALL
-- GROUP BY col2

--GROUP BY GROUPING SETS ((col1, col2), col3, col4)
-->GROUP BT col1, col2
-- UNION ALL
-- GROUP BY col3 col4

--GROUP BY GROUPING SETS (col1, col2)
-->GROUP BY col1
-- UNION ALL
-- GROUP BY col2
--GROUP BY GROUPING SETS (col2, col1)
-->GROUP BY col2
-- UNION ALL
-- GROUP BY col1
-- ==> 컬럼의 순서가 바뀌어도 결과에 영향을 미치지 않는다(!ROLLUP)

SELECT job, deptno, SUM(sal) sal
FROM emp
GROUP BY GROUPING SETS(job, deptno);
--> GROUP BY job
--  UNION ALL
--  GROUP BY deptno;

SELECT job, SUM(sal) sal
FROM emp
GROUP BY GROUPING SETS(job, job);

--job, deptno로 GROUP BY 한 결과와
--mgr GROUP BY한 결과를 조회하는 sql을 GROUPING SETS로 급여합을 SUM(sal)작성
SELECT job, deptno, mgr, SUM(sal) sal
FROM emp
GROUP BY GROUPING SETS((job, deptno), mgr);

--CUBE : 가능한 모든 조합으로 컬럼을 조합한 SUB GROUP을 생성한다
--       단, 기술한 컬럼의 순서는 지킨다
--EX) GROUP BY CUBE(col1, col2);
--(col1, col2) 
-- ==> (null, col2) == GROUP BY col2
-- ==> (null, null) == GROUP BY 전체
-- ==> (col1, null) == GROUP BY col1
-- ==> (col1, col2) == GROUP BY col1, col2
--만약 컬럼 3개를 cube절에 기술할 경우 나올 수 있는 가지수는?
--  ==>8개

SELECT job, deptno, SUM(sal) sal
FROM emp
GROUP BY CUBE(job, deptno);

SELECT job, deptno, mgr, SUM(sal) sal
FROM emp
GROUP BY job, ROLLUP(deptno), CUBE(mgr);
-- 과제 : 서브 그룹별로 색칠해오기

-- GROUP BY job, deptno, mgr == GROUP BY job, deptno, mgr
-- GROUP BY job, deptno == GROUP BY job, deptno
-- GROUP BY job, null, mgr == GROUP BY job, mgr
-- GROUP BY job, null, null == GROUP BY job

--서브쿼리 update
--1. emp_test 삭제
--2. emp테이블을 이용해서 emp_test 테이블생성(CTAS)
--3. emp_test 테이블에 dname varchar2(14) 컬럼추가
--4. emp_test.dname 컬럼을 dept 테이블을 이용해서 부서명을 업데이트
DROP TABLE emp_test;

CREATE TABLE emp_test AS
SELECT * 
FROM emp;

ALTER TABLE emp_test ADD (dname VARCHAR2(14));

UPDATE emp_test 
SET dname = (SELECT dname 
             FROM dept
             WHERE dept.deptno = emp_test.deptno);

SELECT
    *
FROM emp_test;


--서브쿼리 1번
DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT * 
FROM dept;

ALTER TABLE dept_test ADD (empcnt NUMBER);

UPDATE dept_test 
SET empcnt = (SELECT COUNT(deptno)
              FROM emp
              WHERE emp.deptno = dept_test.deptno);

SELECT
    *
FROM emp_test;

--2번
--dept_test 테이블에 있는 부서중에 직원이 속하지 않은 부서 정보를 삭제
--*dept_test.empcnt 컬럼은 사용하지 않고
--emp 테이블을 이용하여 삭제
INSERT INTO dept_test VALUES (99, 'it1', 'deajeon', 0);
INSERT INTO dept_test VALUES (98, 'it2', 'deajeon', 0);

SELECT COUNT(*)
FROM emp 
WHERE deptno = 10;

SELECT  *
FROM dept_test
WHERE 0 =  (SELECT COUNT(*)
            FROM emp
            WHERE deptno = dept_test.deptno);
            
DELETE FROM dept_test
WHERE 0 =(SELECT COUNT(*)
          FROM emp
          WHERE deptno = dept_test.deptno);
          
--3번
SELECT deptno, ROUND(AVG(sal),0) avg_sal
FROM emp_test
GROUP BY deptno
ORDER BY deptno;

UPDATE emp_test a
SET sal = sal + 200
WHERE sal < (SELECT ROUND(AVG(sal))
             FROM emp_test b
             WHERE a.deptno = b.deptno);
           
SELECT
    *
FROM emp_test;

--WITH절
--하나의 쿼리에서 반복되는 서브쿼리가 있을 때
--해당 서브쿼리를 별도로 선언하여 재사용

--메인쿼리가 실행될 때 WITH 선언한 쿼리 블럭이 메모리에 임시적으로 저장
-->메인 쿼리가 종료되면 메모리 해제

--서브쿼리 작성시에는 해당 서브쿼리의 결과를 조회하기 위해서 I/O 반복적으로 일어나지만
--WITH절을 통해 선언하면 한번만 서브쿼리가 실행되고 그 결과를 메모리에 저장해놓고 재사용한다
--단, 하나의 쿼리에서 동일한 서브쿼리가 반복적으로 나오는거는 잘못 작성한 sql일 확률이 높음

--WITH 쿼리블록이름 AS (
--       서브쿼리
--                   )
--SELECT *
--FROM 쿼리블록이름;

--직원의 부서별 급여 평균을 조회하는 쿼리블록을 WITH절을 통해 선언
WITH sal_avg_dept AS (
    SELECT deptno, ROUND(AVG(sal),2) sal
    FROM emp
    GROUP BY deptno
    ),
    dept_empcnt AS (
    SELECT deptno, COUNT(*) empcnt
    FROM emp
    GROUP BY deptno
    )
SELECT *
FROM sal_avg_dept a, dept_empcnt b
WHERE a.deptno = b.deptno;

WITH temp AS (
    SELECT sysdate -1 FROM dual UNION ALL
    SELECT sysdate -2 FROM dual UNION ALL
    SELECT sysdate -3 FROM dual 
    )
SELECT *
FROM temp;

--달력만들기
--CONNERCT BY LEVEL <[=] 정수
--해당 테이블의 행을 정수 만큼 복제하고 복제된 행을 구별하기 위해서 LEVEL을 부여
--LEVEL은 1부터 시작

--열 10개 생성
SELECT dummy, LEVEL
FROM dual
CONNECT BY LEVEL <= 10;

SELECT dept.*, LEVEL
FROM dept
CONNECT BY LEVEL <= 5;

--2020년 2월의 달력 생성
--일 월 화 수 목 금 토
--:dt = 202002, 202003
SELECT LAST_DAY(ADD_MONTHS(TO_DATE('202002', 'YYYYMM'),-1)) + LEVEL
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202002', 'YYYYMM')),'DD');

SELECT TO_DATE('202002', 'YYYYMM') + (LEVEL -1),
       TO_CHAR(TO_DATE('202002', 'YYYYMM') + (LEVEL -1), 'D'),
       DECODE(TO_CHAR(TO_DATE('202002', 'YYYYMM') + (LEVEL -1), 'D'), 
                1, TO_DATE('202002', 'YYYYMM') + (LEVEL -1)) s,
       DECODE(TO_CHAR(TO_DATE('202002', 'YYYYMM') + (LEVEL -1), 'D'), 
                2, TO_DATE('202002', 'YYYYMM') + (LEVEL -1)) m,
       DECODE(TO_CHAR(TO_DATE('202002', 'YYYYMM') + (LEVEL -1), 'D'), 
                3, TO_DATE('202002', 'YYYYMM') + (LEVEL -1)) t,
       DECODE(TO_CHAR(TO_DATE('202002', 'YYYYMM') + (LEVEL -1), 'D'), 
                4, TO_DATE('202002', 'YYYYMM') + (LEVEL -1)) w,
       DECODE(TO_CHAR(TO_DATE('202002', 'YYYYMM') + (LEVEL -1), 'D'), 
                5, TO_DATE('202002', 'YYYYMM') + (LEVEL -1)) tu,
       DECODE(TO_CHAR(TO_DATE('202002', 'YYYYMM') + (LEVEL -1), 'D'), 
                6, TO_DATE('202002', 'YYYYMM') + (LEVEL -1)) f,
       DECODE(TO_CHAR(TO_DATE('202002', 'YYYYMM') + (LEVEL -1), 'D'), 
                7, TO_DATE('202002', 'YYYYMM') + (LEVEL -1)) sa
                
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202002', 'YYYYMM')),'DD');

SELECT TO_CHAR(LAST_DAY(TO_DATE('202002', 'YYYYMM')),'D')
FROM dual;
