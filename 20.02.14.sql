--report group function
--1. ROLLUP
--      - GROUP BY ROLLUP(�÷�1, �÷�2)
--      - ROLLUP���� ����� �÷��� �����ʿ��� �ϳ��� ������ �÷����� SUBGROUP
--      - GROUP BY �÷�1, �÷�2
--        UNION
--        GROUP BY �÷�1
--        UNION
--        GROUP BY
--2. CUBE
--3. GROUPING SETS
--3, 1 >>>>>>>> 2 ������ ����

--GROUPING SETS
--������ ������� ���� �׷��� ����ڰ� ���� ����
--����� : GROUP BY GROUPING SETS(col1, col2..)
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
-- ==> �÷��� ������ �ٲ� ����� ������ ��ġ�� �ʴ´�(!ROLLUP)

SELECT job, deptno, SUM(sal) sal
FROM emp
GROUP BY GROUPING SETS(job, deptno);
--> GROUP BY job
--  UNION ALL
--  GROUP BY deptno;

SELECT job, SUM(sal) sal
FROM emp
GROUP BY GROUPING SETS(job, job);

--job, deptno�� GROUP BY �� �����
--mgr GROUP BY�� ����� ��ȸ�ϴ� sql�� GROUPING SETS�� �޿����� SUM(sal)�ۼ�
SELECT job, deptno, mgr, SUM(sal) sal
FROM emp
GROUP BY GROUPING SETS((job, deptno), mgr);

--CUBE : ������ ��� �������� �÷��� ������ SUB GROUP�� �����Ѵ�
--       ��, ����� �÷��� ������ ��Ų��
--EX) GROUP BY CUBE(col1, col2);
--(col1, col2) 
-- ==> (null, col2) == GROUP BY col2
-- ==> (null, null) == GROUP BY ��ü
-- ==> (col1, null) == GROUP BY col1
-- ==> (col1, col2) == GROUP BY col1, col2
--���� �÷� 3���� cube���� ����� ��� ���� �� �ִ� ��������?
--  ==>8��

SELECT job, deptno, SUM(sal) sal
FROM emp
GROUP BY CUBE(job, deptno);

SELECT job, deptno, mgr, SUM(sal) sal
FROM emp
GROUP BY job, ROLLUP(deptno), CUBE(mgr);
-- ���� : ���� �׷캰�� ��ĥ�ؿ���

-- GROUP BY job, deptno, mgr == GROUP BY job, deptno, mgr
-- GROUP BY job, deptno == GROUP BY job, deptno
-- GROUP BY job, null, mgr == GROUP BY job, mgr
-- GROUP BY job, null, null == GROUP BY job

--�������� update
--1. emp_test ����
--2. emp���̺��� �̿��ؼ� emp_test ���̺����(CTAS)
--3. emp_test ���̺� dname varchar2(14) �÷��߰�
--4. emp_test.dname �÷��� dept ���̺��� �̿��ؼ� �μ����� ������Ʈ
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


--�������� 1��
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

--2��
--dept_test ���̺� �ִ� �μ��߿� ������ ������ ���� �μ� ������ ����
--*dept_test.empcnt �÷��� ������� �ʰ�
--emp ���̺��� �̿��Ͽ� ����
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
          
--3��
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

--WITH��
--�ϳ��� �������� �ݺ��Ǵ� ���������� ���� ��
--�ش� ���������� ������ �����Ͽ� ����

--���������� ����� �� WITH ������ ���� ���� �޸𸮿� �ӽ������� ����
-->���� ������ ����Ǹ� �޸� ����

--�������� �ۼ��ÿ��� �ش� ���������� ����� ��ȸ�ϱ� ���ؼ� I/O �ݺ������� �Ͼ����
--WITH���� ���� �����ϸ� �ѹ��� ���������� ����ǰ� �� ����� �޸𸮿� �����س��� �����Ѵ�
--��, �ϳ��� �������� ������ ���������� �ݺ������� �����°Ŵ� �߸� �ۼ��� sql�� Ȯ���� ����

--WITH ��������̸� AS (
--       ��������
--                   )
--SELECT *
--FROM ��������̸�;

--������ �μ��� �޿� ����� ��ȸ�ϴ� ��������� WITH���� ���� ����
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

--�޷¸����
--CONNERCT BY LEVEL <[=] ����
--�ش� ���̺��� ���� ���� ��ŭ �����ϰ� ������ ���� �����ϱ� ���ؼ� LEVEL�� �ο�
--LEVEL�� 1���� ����

--�� 10�� ����
SELECT dummy, LEVEL
FROM dual
CONNECT BY LEVEL <= 10;

SELECT dept.*, LEVEL
FROM dept
CONNECT BY LEVEL <= 5;

--2020�� 2���� �޷� ����
--�� �� ȭ �� �� �� ��
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
