SELECT * FROM cycle;

--�Ǹ��� : 200~250
--���� 2.5�� ��ǰ
--�Ϸ� : 500~750
--�Ѵ� : 15000~17500

SELECT
    *
FROM cycle;

--4��
SELECT c.cid, c.cnm, cy.pid, cy.day, cy.cnt
FROM customer c, cycle cy
WHERE c.cid = cy.cid
AND c.cnm IN ('brown','sally');

--5��
SELECT c.cid, c.cnm, cy.pid, p.pnm, cy.day, cy.cnt
FROM customer c, cycle cy, product p
WHERE c.cid = cy.cid
AND p.pid = cy.pid
AND c.cnm IN ('brown','sally');

--6��
SELECT c.cid, c.cnm, cy.pid, p.pnm, sum(cy.cnt)
FROM customer c JOIN cycle cy ON c.cid = cy.cid
JOIN product p ON p.pid = cy.pid
GROUP BY c.cid, c.cnm, cy.pid, p.pnm, cy.cnt;

--7��
SELECT p.pid, p.pnm, sum(cy.cnt) 
FROM product p JOIN cycle cy ON p.pid = cy.pid
GROUP BY p.pid, p.pnm;

--system ������ ���� hr ���� Ȱ��ȭ
--�ش� ����Ŭ ������ ��ϵ� �����(����) ��ȸ
SELECT * 
FROM dba_users; 

--HR������ ��й�ȣ�� JAVA�� �ʱ�ȭ
ALTER USER HR IDENTIFIED BY java;
ALTER USER HR ACCOUNT UNLOCK;

--�� ���̺��� ������ �� ���� ������ ���� ��Ű�� ���ϴ� �����͸� 
--�������� ������ ���̺��� �����͸��̶� ��ȸ �ǰԲ� �ϴ� ���� ���

--�������� : e.mgr = m.empno; --> KING�� mgr�� null�̱� ������ ���ο� ����
--emp ���̺��� �����ʹ� �� 14�� ������ �Ʒ��� ���� ���������� ����� 13���� �ȴ�.
--(1���� ���� ����)
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

--ANSI OUTER 
--1. ���ο� �����ϴ��� ��ȸ�� �� ���̺��� ����(�Ŵ��� ������ ��� ��������� �����Բ�)
SELECT e.empno, e.ename, e.mgr, m.ename 
FROM emp e 
LEFT OUTER JOIN emp m ON e.mgr = m.empno;

--right�� ����
SELECT e.empno, e.ename, e.mgr, m.ename 
FROM emp m 
RIGHT OUTER JOIN emp e ON e.mgr = m.empno;

--ORACLE OUTER JOIN
--�����Ͱ� ���� ���� ���̺� �÷� �ڿ� (+)��ȣ�� �ٿ��ش�.
--(+)��ȣ�� ����Ͽ� FULL OUTER ������ �������� �ʴ´�.
SELECT e.empno, e.ename, e.mgr, m.ename 
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+);
--���� sql�� �Ƚ�outer join���� ����
--�Ŵ����� �μ���ȣ�� 10���� ������ ��ȸ
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp m 
RIGHT OUTER JOIN emp e ON (e.mgr = m.empno AND m.deptno = 10);
--����Ŭ ����
--����Ŭ outer join�� ���� ���̺��� �ݴ��� ���̺��� ��� �÷���(+)�� �ٿ���
--�������� outer join���� �����Ѵ�
--�� �÷��̶� �����ϸ� inner join���� ����
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
AND m.deptno = 10;

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
AND m.deptno(+) = 10;

--��� �Ŵ����� right outer join 
SELECT e.empno, e.ename, e.mgr
FROM emp e
RIGHT OUTER JOIN emp m ON (e.mgr = m.empno);

--FULL OUTER : LEFT , RIGHT �ߺ� ����
--LEFT OUTER : 14��, RIGHT OUTER : 21��
SELECT e.empno, e.ename, e.mgr
FROM emp e
FULL OUTER JOIN emp m ON (e.mgr = m.empno);

--1��
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id
AND b.buy_date(+) = TO_DATE('05/01/25', 'yy/mm/dd');

--2��
SELECT NVL(b.buy_date, TO_DATE('05/01/25', 'yy/mm/dd')), b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id
AND b.buy_date(+) = TO_DATE('05/01/25', 'yy/mm/dd');

--3��
SELECT NVL(b.buy_date, TO_DATE('05/01/25', 'yy/mm/dd')), 
           b.buy_prod, p.prod_id, p.prod_name, 
       NVL(b.buy_qty, 0)
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id
AND b.buy_date(+) = TO_DATE('05/01/25', 'yy/mm/dd');

--4��
SELECT p.pid, p.pnm, cy.cid, cy.day, cy.cnt
FROM cycle cy RIGHT OUTER JOIN product p
ON cy.pid = p.pid 
AND cy.cid = 1 ;


