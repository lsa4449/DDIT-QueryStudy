--CROSS JOIN --> īƼ�� ���δ�Ʈ(Cartesian product)
--dept ���̺�� emp ���̺��� ������ �ϱ� ���� FROM ���� �ΰ��� ���̺� ���
--WHERE���� �� ���̺��� ���� ������ ����
--�����ϴ� �� ���̺��� ���������� �����Ǵ� ���
--������ ��� ���տ� ���� ����(����)�� �õ�
--dept(4��), emp(14��)�� CROSS JOIN�� ����� 4*14 = 56��

--cross join 1��
SELECT *
FROM customer, product;

--SUBQUERY
--���̽��� ���� �μ��� ���ϴ� �������� ����Ʈ
SELECT *
FROM emp
WHERE deptno =
    (SELECT deptno
     FROM emp
     WHERE ename = 'SMITH');
--�����ȿ� �ٸ� ������ �� �ִ� ���
--���������� ���� ��ġ�� ���� 3������ �з�
--1. SELECT �� : SCALAR SUBQUERY : �ϳ��� ��, �ϳ��� �÷��� �����ؾ� ������ �߻����� ����
--2. FROM �� : INLINE - VIEW
--3. WHERER �� : SUBQUERY QUERY

--�������� 1��
SELECT COUNT(*)
FROM emp
WHERE sal >
     (SELECT AVG(sal)
      FROM emp);

--2��
SELECT *
FROM emp
WHERE sal >
     (SELECT AVG(sal)
      FROM emp);

--������ ������
--IN : ���������� ������ �� ��ġ�ϴ� ���� ������ ��
--ANY -->Ȱ�뵵�� �ټ� ������ : ���������� ������ �� �� ���̶� ������ ������ �� 
--ALL -->Ȱ�뵵�� �ټ� ������ : ���������� ������ �� ��� ������ ������ ��

--3��
--���������� ����� ���� ���� ���� = �����ڸ� ����� �� ����
SELECT *
FROM emp
WHERE deptno IN
    (SELECT deptno
     FROM emp
     WHERE ename IN ('SMITH','WARD'));

--���̽��� ���� ����� �޿����� �޿��� ���� ������ ��ȸ
--(���̽��� ���� �޿� �� �ƹ��ų�, 1250���� ���� ���) 
SELECT *
FROM emp
WHERE sal < ANY
    (SELECT sal
     FROM emp
     WHERE ename IN ('SMITH','WARD'));

--�޿��� �� ����޿� ��κ��� ���� ��
SELECT *
FROM emp
WHERE sal > ALL
    (SELECT sal
     FROM emp
     WHERE ename IN ('SMITH','WARD'));

--������ ������ ����� 7902 �̰ų� null
--NULL�񱳴� = �����ڰ� �ƴ϶� IS NULL�� �� �ؾ� ������ IN �����ڴ� = �� ����Ѵ�
SELECT *
FROM emp
WHERE mgr = 7902 
OR mgr = null;

--NOT IN (7902, NULL) --> AND
SELECT *
FROM emp
WHERE empno <> 7902 
AND empno IS NOT NULL; 

--pairwise (������)
--�������� ����� ���ÿ� ���� ��ų ��
SELECT * 
FROM emp
WHERE (mgr, deptno) IN 
                    (SELECT mgr, deptno
                     FROM emp
                     WHERE empno IN (7499, 7782));
--non-pairwise
--�������� ���ÿ� ������Ű�� �ʴ� ���·� �ۼ�
SELECT * 
FROM emp
WHERE mgr IN 
            (SELECT mgr
             FROM emp
             WHERE empno IN (7499, 7782))
AND deptno IN 
            (SELECT deptno
             FROM emp
             WHERE empno IN (7499, 7782));
             
--��Į�� �������� : SELECT���� ���, 1���� ROW, 1���� COL�� ��ȸ�ϴ� ����
--��Į�� ���������� MAIN ������ �÷��� ����ϴ°� �����ϴ�

SELECT (SELECT SYSDATE
        FROM dual) , dept.*
FROM dept;
 
SELECT empno, ename, deptno,
        (SELECT dname 
         FROM dept 
         WHERE deptno = emp.deptno)      
FROM emp;

--INLINE VIEW : FROM���� ����Ǵ� ��������
--MAIN ������ �÷��� ������������ ����ϴ��� ������ ���� �з�
--��� �� ��� : correlated subquery(��ȣ���� ����), ���������� �ܵ����� ���� �Ұ�
--             ��������� ������ �ִ�(main -> sub)  
--������� ���� ��� : non-correlated subquery(���ȣ���� ��������), ���������� �ܵ����� ���� ����
--                  ��������� ������ ���� �ʴ�(main - > sub, sib -> main)

--��� ������ �޿� ��պ��� �޿��� ���� ����� ��ȸ
SELECT
    *
FROM emp
WHERE sal >  
        (SELECT AVG(sal)
         FROM emp);

--������ ���� �μ��� �޿� ��պ��� �޿��� ���� ����� ��ȸ
SELECT
    *
FROM emp e
WHERE sal >  
        (SELECT AVG(sal)
         FROM emp m 
         WHERE m.deptno = e.deptno)
ORDER BY deptno;

--���� ������ ������ �̿�
--1. ���� ���̺� ����(emp, �μ��� �޿� ���(�ζ��κ�))
SELECT emp.ename, sal, emp.deptno, dept_sal.*
FROM emp, (SELECT deptno, ROUND(AVG(sal)) avg_sal 
           FROM  emp
           GROUP BY deptno) dept_sal
WHERE emp.deptno = dept_sal.deptno
AND emp.sal > dept_sal.avg_sal;

--������ �߰�
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');

--ROLLBACK; 
    --> Ʈ����� ���
--COMMIT;
    --> Ʈ����� Ȯ��

--4��
SELECT deptno, dname, loc 
FROM dept
WHERE deptno NOT IN (
                    SELECT deptno
                    FROM emp);
 
--5��
SELECT pid, pnm
FROM product
WHERE pid NOT IN (
                  SELECT cid
                  FROM cycle
                  WHERE cid = 1);
               