SELECT ename, sal, aa.deptno, bb.sal_rank

FROM 
(SELECT rownum rn, ename, sal, deptno
FROM
(SELECT *
FROM emp
ORDER BY deptno, sal DESC))aa,

(SELECT rownum rn, deptno, cnt, sal_rank
FROM
(SELECT deptno, cnt, sal_rank
FROM
(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno)b,
(SELECT LEVEL sal_rank
FROM dual
CONNECT BY level <= 14)a
WHERE b.cnt >= a.sal_rank
ORDER BY b.deptno, a.sal_rank))bb
WHERE aa.rn = bb.rn;

--���� ������ �м��Լ��� ����ؼ� ǥ��
SELECT ename, sal, deptno, 
        ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank
FROM emp;

--���� ���� ��� 11��
--����¡ ó��(�������� 10���� �Խñ�)
--1������ : 1~10
--2������ : 11~20
--���ε庯�� : :page, :pageSize
SELECT *
FROM(
    SELECT ROWNUM rn, a.*
    FROM
        (SELECT seq, LPAD(' ', (LEVEL -1) * 4) || title "TITLE",
                DECODE(parent_seq, NULL, seq, parent_seq) root
        FROM board_test
        START WITH parent_seq IS NULL
        CONNECT BY PRIOR seq = parent_seq
        ORDER SIBLINGS BY root DESC, seq) a)
WHERE rn BETWEEN (:page -1) * :pageSize +1 AND :page * :pageSize;

--�м��Լ� ����
--�м��Լ���([����]) OVER ([PARTITON BY �÷�] [ORDER BY �÷�] [WINDOWING])
--PARTITOIN BY �÷�: �ش� �÷��� ���� ROW���� �ϳ��� �׷����� ���´�
--ORDER BY �÷�: PARTITON BY�� ���� ���� �׷� ������ ORDER BY �÷����� ����
--ROW_NUMNER() OVER (PARTITION BY deptno ORDER BY sla DESC) rank

--���� ���� �м� �Լ�
--RANK() : ���� ���� ���� �� �ߺ������� ����, �ļ����� �ߺ�����ŭ ������ ������ ����
--          2���� 2���̸� 3���� ���� 4����� �ļ����� �����ȴ�
--DENSE_RANK() : ���� ���� ������ �ߺ� ������ ����, �ļ����� �ߺ����� �������� ����
--               2���� 2���̴��� �ļ����� 3����� ����
--ROW_NUMBER() : ROWNUM�� ����, �ߺ��� ���� ������� �ʴ´�

--�μ���, �޿� ������ 3���� ��ŷ ���� �Լ��� ����
SELECT ename, sal, deptno,
        RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) SAL_rank,
        DENSE_RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) DENSE_RANK,
        ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal DESC) SAL_ROW_NUMBER
FROM emp;

--WINDOW�Լ� 1��
SELECT empno, ename, sal, deptno,
        RANK() OVER(ORDER BY sal DESC ) SAL_rank,
        DENSE_RANK() OVER(ORDER BY sal DESC) DENSE_RANK,
        ROW_NUMBER() OVER(ORDER BY sal DESC) SAL_ROW_NUMBER
FROM emp;

--2��
SELECT e.empno, e.ename, e.deptno, cnt
FROM emp e,
    (SELECT deptno, count(*) cnt
     FROM emp
     GROUP BY deptno) a
WHERE e.deptno = a.deptno
ORDER BY deptno;

--������ �м��Լ�(GROUP �Լ����� �����ϴ� �Լ� ������ ����)
--SUM(�÷�)
--COUNT(*), COUNT(�÷�)
--MIN(�÷�)
--MAX(�÷�)
--AVG(�÷�)

--2�� �м��Լ��� ����Ͽ� �ۼ�
--�μ��� ���� �� 
SELECT empno, ename, deptno, COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

--ana2,3,4
SELECT empno, ename, deptno, 
        ROUND(AVG(sal) OVER (PARTITION BY deptno),2) avg_sal,
        MAX(sal) OVER (PARTITION BY deptno) max_sal,
        MIN(sal) OVER (PARTITION BY deptno) min_sal
FROM emp;

--�޿��� �������� �����ϰ� �޿��� ���� ���� �Ի����ڰ� ���� ����� ���� �켱������ �ǵ���
--�������� ������(LEAD)�� sal�÷��� ���ϴ� ������ �ۼ�
SELECT empno, ename, hiredate, sal, 
        LEAD(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
FROM emp; 

--ana5
SELECT empno, ename, hiredate, sal, 
        LAG(sal) OVER (ORDER BY sal DESC, hiredate) lag_sal
FROM emp; 

--ana6
SELECT empno, ename, hiredate, job, sal, 
        LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) lag_sal
FROM emp; 

--no_ana3 =>�м��Լ� ���� ����
SELECT a.empno, a.ename, a.sal, SUM(b.sal) C_SUM
FROM 
    (SELECT a.*, rownum rn
     FROM 
        (SELECT *
         FROM emp
         ORDER BY sal, empno)a)a,
    (SELECT a.*, rownum rn
     FROM 
        (SELECT *
         FROM emp
         ORDER BY sal, empno)a)b
WHERE a.rn >= b.rn
GROUP BY a.empno, a.ename, a.sal, a.rn
ORDER BY a.rn, a.empno;

--�м��Լ��� �̿��Ͽ� ���� �ۼ�
SELECT empno, ename, sal, 
        SUM(sal) OVER (ORDER BY sal, empno 
                       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) comm_sal
FROM emp;

--���� ���� �������� ���� ������� ���� ������� �� 3�� ���� sal �հ� ���ϱ�
SELECT empno, ename, sal, 
        SUM(sal) OVER (ORDER BY sal, empno 
                        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) c_sum
FROM emp;

--ana 7��
--ORDER BY��� �� WINDOWING ���� ������� ���� ��� WINDOWING�� �⺻������ ����ȴ�
--ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
SELECT empno, ename, deptno, sal, 
        SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno) c_sum
FROM emp;

--RANGE : ������ ���� ����, ���� ���� ������ �÷����� �ڽ��� ������ ���
--ROWS : �������� ���� ����
SELECT empno, ename, deptno, sal, 
        SUM(sal) OVER (PARTITION BY deptno ORDER BY sal ROWS UNBOUNDED PRECEDING) row_,
        SUM(sal) OVER (PARTITION BY deptno ORDER BY sal RANGE UNBOUNDED PRECEDING) range_,
        SUM(sal) OVER (PARTITION BY deptno ORDER BY sal) default_       
FROM emp;