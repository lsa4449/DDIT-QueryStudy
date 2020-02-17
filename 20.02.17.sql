--�޷�
--:dt => 202002
SELECT DECODE(d, 1, iw+1, iw) i,
       MIN(DECODE(d, 1, dt)) sun,
       MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tue,
       MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) tur,
       MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
       
FROM
(SELECT TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt,'yyyymm'), 'd') -1) + (LEVEL -1) dt,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt,'yyyymm'), 'd') -1) + (LEVEL -1),'D') d,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt,'yyyymm'), 'd') -1) + (LEVEL -1),'iw') iw  
 FROM dual
 CONNECT BY LEVEL <= LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7 - TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D')) 
        - TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D')-1))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);


--1. �ش� ���� 1���ڰ� ���� ���� �Ͽ��� ���ϱ�
--2. �ش� ���� ������ ���ڰ� ���� ���� ����� ���ϱ�
--3. 2-1�� �Ͽ� �� �ϼ� ���ϱ�
--������ ���ڷ� ǥ�� ����
--������ 7��(1~7��)
SELECT 
    TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt,'yyyymm'), 'd') -1) st,
    LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7 - TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D')) ed,
    LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7 - TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D')) 
        - (TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D'))) daycnt
FROM dual;

--���� : �������� 1��, ��������¥ : �ش���� ����������
SELECT TO_DATE('202002','yyyymm') + (LEVEL-1)
FROM dual
CONNECT BY LEVEL <= 29;
       
--���� : �������� => �ش޿��� 1���ڰ� ���� ���� �Ͽ���
--      ��������¥ => �ش���� ���������ڰ� ���� ���� �����
SELECT TO_DATE('20200126','yyyymmdd') + (LEVEL -1)
FROM dual
CONNECT BY LEVEL <= 35;

SELECT DECODE(d, 1, iw+1, iw) i,
       MIN(DECODE(d, 1, dt)) sun,
       MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tue,
       MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) tur,
       MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
FROM 
(SELECT TO_DATE(:dt, 'yyyymm') + (level-1) dt,
        TO_CHAR(TO_DATE(:dt, 'yyyymm')  + (LEVEL-1), 'D') d,
        TO_CHAR(TO_DATE(:dt, 'yyyymm')  + (LEVEL-1), 'iw') iw
 FROM dual
 CONNECT BY LEVEL <=  TO_CHAR(last_day(to_date(:dt,'yyyymm')), 'DD'))
 GROUP BY DECODE(d, 1, iw+1, iw)
 ORDER BY DECODE(d, 1, iw+1, iw);
 
create table sales as 
select to_date('2019-01-03', 'yyyy-MM-dd') dt, 500 sales from dual union all
select to_date('2019-01-15', 'yyyy-MM-dd') dt, 700 sales from dual union all
select to_date('2019-02-17', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-02-28', 'yyyy-MM-dd') dt, 1000 sales from dual union all
select to_date('2019-04-05', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-04-20', 'yyyy-MM-dd') dt, 900 sales from dual union all
select to_date('2019-05-11', 'yyyy-MM-dd') dt, 150 sales from dual union all
select to_date('2019-05-30', 'yyyy-MM-dd') dt, 100 sales from dual union all
select to_date('2019-06-22', 'yyyy-MM-dd') dt, 1400 sales from dual union all
select to_date('2019-06-27', 'yyyy-MM-dd') dt, 1300 sales from dual;

SELECT
    *
FROM sales;

SELECT 
       MIN(DECODE(d, 1, sales)) jan,
       MIN(DECODE(d, 2, sales)) feb,
       MIN(DECODE(d, 3, sales, 0)) mar,
       MIN(DECODE(d, 4, sales)) apr,
       MIN(DECODE(d, 5, sales)) may,
       MIN(DECODE(d, 6, sales)) jun
FROM(SELECT TO_CHAR(dt, 'mm') d, SUM(sales) sales    
     FROM sales
     group by TO_CHAR(dt, 'mm'));

--1. dt(����) ==> ��, �������� SUM(sales) => ���� �� ��ŭ ���� �׷��� �ȴ�
SELECT SUM(jan) jan, SUM(feb) feb, NVL(SUM(mar),0) mar, 
       SUM(apr) apr, SUM(may) may, SUM(jun) jun
FROM
(SELECT DECODE(TO_CHAR(dt, 'mm'), '01', SUM(sales)) jan ,
        DECODE(TO_CHAR(dt, 'mm'), '02', SUM(sales)) feb ,
        DECODE(TO_CHAR(dt, 'mm'), '03', SUM(sales)) mar ,
        DECODE(TO_CHAR(dt, 'mm'), '04', SUM(sales)) apr ,
        DECODE(TO_CHAR(dt, 'mm'), '05', SUM(sales)) may ,
        DECODE(TO_CHAR(dt, 'mm'), '06', SUM(sales)) jun 
       
 FROM sales
 GROUP BY TO_CHAR(dt, 'mm'));
 
 create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);

insert into dept_h values ('dept0', 'XXȸ��', '');
insert into dept_h values ('dept0_00', '�����κ�', 'dept0');
insert into dept_h values ('dept0_01', '������ȹ��', 'dept0');
insert into dept_h values ('dept0_02', '�����ý��ۺ�', 'dept0');
insert into dept_h values ('dept0_00_0', '��������', 'dept0_00');
insert into dept_h values ('dept0_01_0', '��ȹ��', 'dept0_01');
insert into dept_h values ('dept0_02_0', '����1��', 'dept0_02');
insert into dept_h values ('dept0_02_1', '����2��', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '��ȹ��Ʈ', 'dept0_01_0');
commit;

--����Ŭ ������ ���� ����
--SELECT ...
--FROM...
--WHERE
--START WITH ���� : � ���� ���������� ������
--CONNECT BY ��� ���� �����ϴ� ����
--            PRIOR : �̹� ���� ��
--            "   " : ������ ���� ��

--����� : �������� �ڽ� ���� �����ϴ� ���(�� => �Ʒ�)
--xxȸ��(�ֻ��� ����) ���� �����Ͽ� ���� �μ��� �������� ���� ����
SELECT * 
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;
--��� ���� ���� ���� (xxȸ�� - 3���� ��(�����κ�, ������ȹ��, �����ý��ۺ�)
--PRIOR XXȸ��.deptcd = �����κ�.p_deptcd
--PRIOR �����κ�.deptcd = ��������.p_deptcd
--PRIOR ��������.deptcd = .p_deptcd

--PRIOR XXȸ��.deptcd = ������ȹ��.p_deptcd
--PRIOR ������ȹ��.deptcd = ��ȹ��.p_deptcd
--PRIOR ��ȹ��.deptcd = ��ȹ��Ʈ.p_deptcd

--PRIOR XXȸ��.deptcd = �����ý��ۺ�.p_deptcd
--PRIOR �����ý��ۺ�.deptcd = ����1��.p_deptcd
--PRIOR ����1��p.deptcd..
--PRIOR �����ý��ۺ�.deptcd = ����2��.p_deptcd
--PRIOR ����2��p.deptcd..

SELECT dept_h.*, level, LPAD(' ', (LEVEL - 1) * 4, ' ') || deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--�������� �ǽ�2
SELECT deptcd, LPAD(' ', (LEVEL - 1) * 4, ' ') || deptnm "DEPTNM", p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;
