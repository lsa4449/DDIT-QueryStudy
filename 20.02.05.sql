--�Ŵ����� �����ϴ� ������ ��ȸ(KING�� ������ 13���� �����Ͱ� ��ȸ)
SELECT ename, mgr
FROM emp
WHERE mgr is not null;

--EXISTS ���ǿ� �����ϴ� ���� ���� �ϴ��� Ȯ���ϴ� ������
--�ٸ� �����ڿ� �ٸ��� WHERE���� �÷��� ������� �ʴ´�
-- .WHRER empno = 7369
-- .WHERE EXISTS (SELECT 'X'
--                FROM......);

--���� �÷� EXISTS�� ��ȸ
--�������� 8��
SELECT ename, mgr
FROM emp e
WHERE EXISTS (SELECT 'X'
              FROM emp m
              WHERE e.mgr = m.empno);

--9��
SELECT pid, pnm
FROM product p
WHERE EXISTS (SELECT 'X'
              FROM cycle c
              WHERE c.pid = p.pid
              AND c.cid = 1);
              
--10��
SELECT pid, pnm
FROM product p
WHERE NOT EXISTS (SELECT 'X'
                  FROM cycle c
                  WHERE c.pid = p.pid
                  AND c.cid = 1);
  
--���տ���
--������ : UNION -> �ߺ�����(���հ���) / UNION ALL -> �ߺ��� �������� ����(�ӵ� ���)
--������ : INTERSECT(���հ���)
--������ : MINUS(���հ���)
--���տ����� �������
--�� ������ �÷��� ����. Ÿ���� ��ġ �ؾ� �Ѵ�

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)

UNION

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

--UNION ALL : UNION�� �ٸ��� �ߺ� ���
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

--INTERSECT(������) : ��, �Ʒ� ���տ��� ���� ���� �ุ ��ȸ
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

--MINUS(������) : ��, �Ʒ� ���տ��� �Ʒ� ������ �����͸� ������ ������ ����
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

--������ ��� ������ ������ ���� ���տ�����
-- A UNION B = B UNION A --> ���� ����
-- A UNION ALL B = B UNION ALL A --> ���� ����(����)
-- A INTERSECT B = B INTERSECT A --> ���� ����
-- A MINUS B = B MINUS A --> ���� �ٸ�

--���տ����� ��� �÷� �̸��� ù ��° ������ �÷����� ������
SELECT 'X', 'B'
FROM dual

UNION

SELECT 'Y', 'A'
FROM dual;

--����(ORDER BY)�� ���տ��� ���� ������ ���� ������ ���
SELECT deptno, dname, loc 
FROM dept
WHERE deptno IN (10, 20)
--ORDER bY ���� ��������! --> �ζ��� ��� ���θ� ����
UNION

SELECT *
FROM dept
WHERE deptno IN (30, 40)
ORDER BY deptno;