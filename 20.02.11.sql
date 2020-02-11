--�������� Ȯ�� ���
--1. tool
--2. �������� : USER_CONSTRAINTS
--3. �������� �÷� : USER_CON_COLUMNS
--4. ���������� ��� �÷��� ���õǾ� �ִ��� �� �� ���� ������ ���̺��� ������ �и��Ͽ� ����

SELECT * 
FROM USER_CONSTRAINTS
WHERE table_name IN ('EMP', 'DEPT', 'EMP_TEST', 'DEPT_TEST');

--EMP, DEPT, PK, FK ������ �������� ����
--���̺� �������� �������� �߰�
--1. EMP : PK(empno)
--2.     : FK(deptno) - dept.deptno
--3.       (FK ������ �����ϱ� ���ؼ��� �����ϴ� ���̺� �÷��� �ε����� �����ؾ� �Ѵ�)

--1. DEPT : PK(deptno)
SELECT * 
FROM USER_CONSTRAINTS
WHERE table_name IN ('EMP', 'DEPT', 'EMP_TEST', 'DEPT_TEST');
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);
ALTER TABLE emp ADD CONSTRAINT pk_emp_dept FOREIGN KEY (deptno)
                    REFERENCES dept(deptno);

--���̺� �÷� �ּ� : dictionary Ȯ�ΰ���
--���̺� �ּ� : USER_TAB_COMMENTS
--�÷� �ּ� : USER_COL_COMMENTS

--�ּ� ����
--���̺� �ּ� : COMMENT ON TABLE ���̺�� IS '�ּ�';
--�÷� �ּ� : COMMENT ON COLUMN ���̺�.�÷� IS '�ּ�';
--emp : ����
--dept : �μ�

COMMENT ON TABLE emp IS '����';
COMMENT ON TABLE dept IS '�μ�';

SELECT
    *
FROM USER_TAB_COMMENTS
WHERE TABLE_NAME IN ('EMP', 'DEPT');


SELECT
    *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME IN ('EMP', 'DEPT');

--DEPT	DEPTNO : �μ���ȣ
--DEPT	DNAME : �μ���
--DEPT	LOC : �μ���ġ
--EMP	EMPNO : ������ȣ
--EMP	ENAME : �����̸�
--EMP	JOB : ������
--EMP	MGR : �Ŵ��� ������ȣ
--EMP	HIREDATE : �Ի�����
--EMP	SAL : �޿�
--EMP	COMM : ������
--EMP	DEPTNO : �ҼӺμ���ȣ

COMMENT ON COLUMN dept.deptno IS '�μ���ȣ';
COMMENT ON COLUMN dept.dname IS '�μ���';
COMMENT ON COLUMN dept.loc IS '�μ���ġ';

COMMENT ON COLUMN emp.empno IS '������ȣ';
COMMENT ON COLUMN emp.ename IS '�����̸�';
COMMENT ON COLUMN emp.job IS '������';
COMMENT ON COLUMN emp.mgr IS '�Ŵ��� ������ȣ';
COMMENT ON COLUMN emp.hiredate IS '�Ի�����';
COMMENT ON COLUMN emp.sal IS '�޿�';
COMMENT ON COLUMN emp.comm IS '������';
COMMENT ON COLUMN emp.deptno IS '�ҼӺμ���ȣ';

SELECT *
FROM USER_TAB_COMMENTS t, USER_COL_COMMENTS c
WHERE t.table_name = c.table_name
AND t.table_name IN ('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY');

--view : query
--���̺�ó�� DBMS�� �̸� �ۼ��� ��ü
--  ->�ۼ����� �ʰ� QUERY���� �ٷ� �ۼ��� VIEW : �ζ��κ� -> �̸��� ���� ������ ��Ȱ��Ұ�
--view�� ���̺��� �ƴϴ�.

--������
--1. ���� ����(Ư�� �÷��� �����ϰ� ������ ����� �����ڿ� ����)
--2.�ζ��κ並 ��� �����ؼ� ��Ȱ�� -> �������� ����

--�������
--CREATE [OR REPLACE] VIEW �� ��Ī[ (column1, column2..)] AS 
--SUBQUERY
--emp ���̺��� 8���� �÷� �� sal, comm �÷��� ������ 6�� �÷��� �����ϴ� v_emp VIEW����
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

--�ý��� �������� sua �������� view �������� �߰�
GRANT CREATE VIEW TO SUA;

--���� �ζ��κ�� �ۼ��� 
SELECT
    *
FROM (SELECT empno, ename, job, mgr, hiredate, deptno
      FROM emp);
      
--view ��ü Ȱ��
SELECT
    *
FROM v_emp;

--emp ���̺��� �μ����� ���� => dept ���̺�� ������ ����ϰ� ����
--���ε� ����� view�� ���� �س����� �ڵ带 �����ϰ� �ۼ��ϴ°��� ����
--�μ���, ������ȣ, �����̸�, ������, �Ի�����
CREATE OR REPLACE VIEW v_emp_dept AS
SELECT d.dname, e.empno, e.ename, e.job, e.hiredate
FROM emp e , dept d
WHERE e.deptno = d.deptno;

--�ζ��κ�� �ۼ���
SELECT *
FROM (SELECT d.dname, e.empno, e.ename, e.job, e.hiredate
      FROM emp e , dept d
      WHERE e.deptno = d.deptno);

--view �ۼ���
SELECT
    *
FROM v_emp_dept;

--SMITH ���� ���� �� v_emp_dept view �Ǽ� ��ȭ Ȯ��
DELETE emp 
WHERE ename = 'SMITH';

--view�� �������� �����͸� ���� �ʰ�, ������ �������� ���� ����(SQL)�̱� ������
--view���� �����ϴ� ���̺��� �����Ͱ� ������ �Ǹ� view�� ��ȸ ����� ������ �޴´�.

--SEQUENCE : ������ -> �ߺ����� �ʴ� �������� �������ִ� ����Ŭ ��ü
--CREATE SEQUENCE ������_�̸�
--[OPTION....];
--����Ģ : SEQ_���̺��
--emp ���̺��� ����� ������ ����
CREATE SEQUENCE seq_emp;

--������ ���� �Լ�
--NEXTVAL : ���������� ���� ���� ������ �� ���
--CURRVAL : NEXTVAL�� ����ϰ��� ���� �о� ���� ���� ��Ȯ��
SELECT seq_emp.NEXTVAL, seq_emp.CURRVAL
FROM DUAL;

INSERT INTO emp_test VALUES (SEQ_EMP.NEXTVAL, 'james', 99, '017');

--������ ������
--rollback�� �ϴ��� nextval�� ���� ���� ���� �������� �ʴ´�.
--nextval�� ���� ���� �޾ƿ��� �� ���� �ٽ� ����� �� ����.

--index
SELECT ROWID, emp.*
FROM emp;

SELECT  *
FROM emp
WHERE ROWID ='AAAE5dAAFAAAACLAAA';

--�ε����� ���� �� empno ������ ��ȸ �ϴ� ���
--emp ���̺��� pk_emp���������� �����Ͽ� empno �÷����� �ε����� �������� �ʴ� ȯ���� ����
alter table emp drop CONSTRAINT pk_emp;

EXPLAIN PLAN FOR
SELECT
    *
FROM emp
WHERE empno = 7782;

SELECT
    *
FROM TABLE(dbms_xplan.display);

--emp���̺��� empno �÷����� pk ������ �����ϰ� ������ sql�� ����
--pk : unique + not null
--      (unique �ε����� �������ش�)
-->empno �÷����� unique �ε����� ������

--�ε����� sql�� �����ϰ� �Ǹ� �ε����� �������� ��� �ٸ��� �������� Ȯ��

alter table emp add constraint pk_emp primary key (empno);

select empno, rowid
from emp
order by empno;

select * from emp
where empno = 7782;

--select ��ȸ �÷��� ���̺� ���ٿ� ��ġ�� ����
select empno from emp where empno = 7782;

explain plan for
select empno
from emp
where empno = 7782;

SELECT
    *
FROM table(dbms_xplan.display);

--����ũ�� ������ũ �ε����� ���� Ȯ��
--1. pk_emp����
--2. empno�÷����� non-unique �ε��� ����
--3. �����ȹ Ȯ��

ALTER TABLE emp DROP CONSTRAINT pk_emp;
create index idx_n_emp_01 on emp (empno);

explain plan for
SELECT
    *
FROM emp
where empno = 7782;

SELECT
    *
FROM table(dbms_xplan.display);

--emp ���̺� job �÷��� �������� �ϴ� ���ο� non-unique �ε����� ����
create index idx_n_emp_02 on emp (job);

select job, rowid
from emp
order by job;

--���� ������ ����
--1. emp ���̺��� ��ü �б�
--2. idx_n_emp_01(empno) �ε��� Ȱ��
--3. idx_n_emp_02(job) �ε��� Ȱ��

explain plan for
SELECT
    *
FROM emp 
WHERE job = 'MANAGER';
