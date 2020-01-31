--JOIN �� ���̺��� �����ϴ� �۾�
--JOIN ����
--1. ANSI ���� 
--2. ORACLE ����

--Natural Joio
--�� ���̺� �÷����� ���� �� �ش� �÷����� ����
--emp, dept ���̺��� deptno��� �ø��� ����
SELECT
    *
FROM emp NATURAL JOIN dept;

--Natural Join�� ���� ���� �÷�(deptno)�� ������(ex : ���̺��, ���̺� ��Ī)�� ������� �ʰ�
--�÷��� ����Ѵ�. (dept.deptno --> deptno)
SELECT emp.ename, emp.empno, dept.dname, deptno
FROM emp NATURAL JOIN dept;

--���̺� ���� ��Ī�� ��� ����
SELECT e.ename, e.empno, d.dname, deptno
FROM emp e NATURAL JOIN dept d;

--ORACLE Join
--FROM ���� ������ ���̺� ����� ,�� �����Ͽ� �����Ѵ�
--������ ���̺��� ���� ������ WHERE ���� ����Ѵ�
--emp, dept ���̺� �����ϴ� deptno �÷��� ���� �� ����
SELECT emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--����Ŭ ������ ���̺� ��Ī
SELECT e.empno, e.ename, d.dname, e.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno;

--ANSI join: join with USING
--���� �Ϸ��� �ΰ��� ���̺� �̸��� ���� �÷��� �ΰ�������
--�ϳ��� �÷����θ� ������ �ϰ��� �Ҷ� �����Ϸ��� ���� �÷��� ���
--emp, dept ���̺��� ���� �÷� : deptno
SELECT emp.ename, dept.dname, deptno
FROM emp JOIN dept USING(deptno);
--oracle�� ǥ�� �Ϸ���?
SELECT e.empno, e.ename, d.dname, e.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno;

--ANSI join2 : join with on
--���� �Ϸ����ϴ� ���̺��� �÷��� �̸��� ���� �ٸ���
SELECT emp.ename, dept.dname, dept.deptno
FROM emp JOIN dept ON (emp.deptno = dept.deptno);
--oracle�� ǥ���Ϸ���? --> ���� ������ �Ȱ���

--SELF Join : ���� ���̺��� ����
--emp���̺��� �����Ǵ� ����� ������ ����� �̿��Ͽ� 
--������ �̸��� ��ȸ�� ��;
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno);
--oracle�� ǥ���Ϸ���?
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

--equal ���� : = 
--non-equal ���� : !=, <, >, BETWEEN AND
SELECT
    *
FROM salgrade;

SELECT
    *
FROM emp;
--non-equal ������ ���(���� �÷��� �������� ���� ��)
--����� �޿� ������ ��� ���̺��� �̿��Ͽ� �ش����� �޿� ��� ���غ���
SELECT e.ename, sal , s.grade
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.losal AND s.hisal;
--ANSI �������� ǥ���Ϸ���?
SELECT e.ename, e.sal , s.grade
FROM emp e 
JOIN salgrade s
ON e.sal BETWEEN s.losal AND s.hisal;

--join 0��
SELECT e.empno, e.ename, deptno, d.dname
FROM emp e NATURAL JOIN dept d
ORDER BY deptno;

SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
ORDER BY deptno;

--1��
SELECT e.empno, e.ename, deptno, d.dname
FROM emp e NATURAL JOIN dept d
WHERE deptno IN (10,30);

SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND d.deptno IN (10,30)
ORDER BY deptno;

--2��
SELECT e.empno, e.ename, e.sal, deptno, d.dname
FROM emp e NATURAL JOIN dept d
WHERE e.sal > 2500
ORDER BY deptno;

SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.sal > 2500
ORDER BY deptno;

--3��
SELECT e.empno, e.ename, e.sal, deptno, d.dname
FROM emp e NATURAL JOIN dept d
WHERE e.sal > 2500 AND empno > 7600
ORDER BY deptno;

SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.sal > 2500 AND empno > 7600
ORDER BY deptno;

--4��
SELECT e.empno, e.ename, e.sal, deptno, d.dname
FROM emp e NATURAL JOIN dept d
WHERE e.sal > 2500 AND empno > 7600 AND d.dname = 'RESEARCH'
ORDER BY deptno;

SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno 
AND e.sal > 2500 AND empno > 7600 AND d.dname = 'RESEARCH'
ORDER BY deptno;

--prod : prod_lgu
--lprod : lprod_gu
SELECT
    *
FROM prod;

SELECT
    *
FROM cart;

--join 1��
SELECT l.lprod_gu, l.lprod_nm, p.prod_id, p.prod_name
FROM prod p natural join lprod l;

--2��
SELECT b.buyer_id, b.buyer_name, p.prod_id, p.prod_name
FROM prod p natural join buyer b;

--3��
SELECT m.mem_id, m.mem_name, p.prod_name, c.cart_qty
FROM prod p, member m, cart c
WHERE p.prod_id = c. cart_prod
AND c.cart_member = m.mem_id;


