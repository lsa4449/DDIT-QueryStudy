--����� �������� (leaf ==> root node(���� node))
--��ü ��带 �湮�ϴ°� �ƴ϶� �ڽ��� �θ��常 �湮(����İ� �ٸ���)
--������ : ��������
--���� : �����μ�
SELECT *
from dept_h;

--3��
select deptcd, lpad(' ' , (level -1) * 4) ||deptnm, p_deptcd
from dept_h
start with deptnm = '��������'
connect by prior p_deptcd = deptcd;

--4��
create table h_sum as
select '0' s_id, null ps_id, null value from dual union all
select '01' s_id, '0' ps_id, null value from dual union all
select '012' s_id, '01' ps_id, null value from dual union all
select '0123' s_id, '012' ps_id, 10 value from dual union all
select '0124' s_id, '012' ps_id, 10 value from dual union all
select '015' s_id, '01' ps_id, null value from dual union all
select '0156' s_id, '015' ps_id, 20 value from dual union all

select '017' s_id, '01' ps_id, 50 value from dual union all
select '018' s_id, '01' ps_id, null value from dual union all
select '0189' s_id, '018' ps_id, 10 value from dual union all
select '11' s_id, '0' ps_id, 27 value from dual;

SELECT
    *
FROM H_SUM;

SELECT LPAD(' ', (LEVEL - 1) * 4) || s_id "S_ID", value
FROM h_sum
start with s_id = 0
connect by prior s_id = ps_id;

--5��
create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XXȸ��', null, 1);
insert into no_emp values('�����ý��ۺ�', 'XXȸ��', 2);
insert into no_emp values('����1��', '�����ý��ۺ�', 5);
insert into no_emp values('����2��', '�����ý��ۺ�', 10);
insert into no_emp values('������ȹ��', 'XXȸ��', 3);
insert into no_emp values('��ȹ��', '������ȹ��', 7);
insert into no_emp values('��ȹ��Ʈ', '��ȹ��', 4);
insert into no_emp values('�����κ�', 'XXȸ��', 1);
insert into no_emp values('��������', '�����κ�', 7);

commit;

SELECT * 
FROM no_emp;

SELECT LPAD(' ', (LEVEL -1) * 4 ) || org_cd "ORG_CD", no_emp
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;

--������ ������ �� ���� ���Ǳ�� ��ġ�� ���� ��� ��(pruning branch - ����ġ��)
--from ==> start with, connect by => where
--1. where : ���� ������ �ϰ� ���� ���� ����
--2. connect by : ���� ������ �ϴ� �������� ���� ����

--WHERE�� ��� �� : �� 9���� �� ��ȸ
--WHERE�� : (org_cd != '������ȹ��') => ������ȹ�θ� ������ 8���� �� ��ȸ
SELECT LPAD(' ', (LEVEL -1) * 4 ) || org_cd "ORG_CD", no_emp
FROM no_emp
WHERE org_cd != '������ȹ��'
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;

--CONNECT BY ���� ������ ��� => ������ȹ�ο� ���� ���鵵 ������ 6���� �� ��ȸ
SELECT LPAD(' ', (LEVEL -1) * 4 ) || org_cd "ORG_CD", no_emp
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd AND org_cd != '������ȹ��';

--CONNECT_BY_ROOT(�÷�): �ش� �÷��� �ֻ��� ���� ���� ��ȸ
--SYS_CONNECT__BY_PATH(�÷�, ������) : �ش� ���� �÷��� ���Ŀ� �÷� ���� ����, �����ڷ� �̾��ش�
--CONNECT_BY_ISLEAF : �ش� ���� LEAF �������(����� �ڽ��� ������) ���� ���� (1:LEAF, 0:NO LEAF)
SELECT LPAD(' ', (LEVEL -1) * 4 ) || org_cd "ORG_CD", no_emp,
       CONNECT_BY_ROOT(org_cd) root,
       LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'), '-') path,
       CONNECT_BY_ISLEAF leaf
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;

--6��
create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, 'ù��° ���Դϴ�');
insert into board_test values (2, null, '�ι�° ���Դϴ�');
insert into board_test values (3, 2, '����° ���� �ι�° ���� ����Դϴ�');
insert into board_test values (4, null, '�׹�° ���Դϴ�');
insert into board_test values (5, 4, '�ټ���° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (6, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (7, 6, '�ϰ���° ���� ������° ���� ����Դϴ�');
insert into board_test values (8, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (9, 1, '��ȩ��° ���� ù��° ���� ����Դϴ�');
insert into board_test values (10, 4, '����° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (11, 10, '���ѹ�° ���� ����° ���� ����Դϴ�');
commit;

SELECT
    *
FROM board_test;

SELECT seq, LPAD(' ', (LEVEL -1) * 4) || title "TITLE"
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq;

--7��, 8��
SELECT seq, LPAD(' ', (LEVEL -1) * 4) || title "TITLE"
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC;

--9��
--�� : DESC / ��� : ASC
SELECT gn, seq, LPAD(' ', (LEVEL -1) * 4) || title "TITLE"
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC, seq;

--�׷��ȣ ������ �÷��� �߰�
alter table board_test add(gn NUMBER);

update board_test 
set gn = 1
WHERE seq IN(1, 9);

--�÷� ���߰�
SELECT seq, LPAD(' ', (LEVEL -1) * 4) || title "TITLE",
        DECODE(parent_seq, NULL, seq, parent_seq) root
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY root DESC, seq;

SELECT
    *
FROM emp
WHERE sal = (SELECT MAX(sal)
             FROM emp);
             
SELECT ename, sal, deptno,
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC ) as sal_rank
FROM emp
GROUP BY ename, sal, deptno
ORDER BY deptno; 

SELECT ename, sal, deptno, count(sal) sal_rank
FROM emp
WHERE sal IN (select MAX(sal) from emp GROUP BY deptno)
GROUP BY deptno, sal, ename
ORDER BY deptno;

select sal_rank
from (select ename, sal, deptno, rownum
      from emp
      WHERE deptno = 10
      GROUP BY ename, sal, deptno, rownum
      ORDER BY deptno, rownum);