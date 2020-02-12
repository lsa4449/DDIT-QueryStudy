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
--3��° �ε����� �������Ѵ�
--3,4��° �ε����� �÷� ������ �����ϰ� ������ �ٸ���
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

--1.����
--oracle -> �ǽð� ���� : OLTP (ON LINE TRANSACTION PROCESSING)
--       -> ��ü ó���ð� : OLAP (ON LINE ANALISYS PROCESSING) - ������ ������ �����ȹ�� ����µ� 30M~1H
--2�� ���̺� ����
--������ ���̺� �ε��� 5���� �ִٸ� �� ���̺� ���� ���� : 6
--36 * 2 = 72

--EMP���� ������ DEPT���� ������?
EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.empno = 7788;
 
SELECT
    *
FROM TABLE(DBMS_XPLAN.DISPLAY);
--�д� ���� : 4 - 3 - 5 - 2 - 6 - 1 - 0

--�ε��� 1��
--WHERE 1 = 1 �� �ǹ� : ���̺��� ������ ���� ���� ����
--ctas : �������� ���簡 not null�� ����
--      ->����̳� �׽�Ʈ������ ���
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

--2��
DROP INDEX pk_dept2_deptno;
DROP INDEX pk_dept2_dname;
DROP INDEX pk_dept2_deptno_dname;

--3��
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

--3�� ��
--empno(=)
--ename(=) ==>�ؿ��� ����ϱ� ������ ��� �ȴ�
--deptno(=), empno(LIKE ������ȣ%) ==>empno, deptno(empno�� ��ü ����)
--deptno(=), sal (between)
--deptno(=)/ mgr �����ϸ� ����
--deptno, hiredate�� �ε��� �����ϸ� ����

--4��

