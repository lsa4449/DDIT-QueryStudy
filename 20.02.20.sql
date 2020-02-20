--1. leaf ���(��)�� � ���������� Ȯ��
--2. LEVEL ==> ����Ž���� �׷��� ���� ���� �ʿ��� ��
--3. leaf ������ ����Ž��, ROWNUM
SELECT LPAD(' ', (LEVEL -1) * 4) ||org_cd, total
FROM
    (SELECT org_cd, parent_org_cd, SUM(total) total
     FROM
        (SELECT org_cd, parent_org_cd, no_emp, 
                SUM(no_emp) OVER (PARTITION BY gno ORDER BY rn
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) total
         FROM
            (SELECT org_cd, parent_org_cd, lv, ROWNUM rn, lv+ROWNUM gno         
                    ,no_emp / COUNT(*) OVER (PARTITION BY org_cd) no_emp
             FROM
                (SELECT no_emp.*, LEVEL lv, CONNECT_BY_ISLEAF leaf
                 FROM no_emp
                 START WITH parent_org_cd IS NULL
                 CONNECT BY PRIOR org_cd = parent_org_cd)
            START WITH leaf = 1
            CONNECT BY PRIOR parent_org_cd = org_cd))
    GROUP BY org_cd, parent_org_cd)
START WITH parent_org_cd IS NULL
CONNECT BY PRIOR org_cd = parent_org_cd;

DROP TABLE gis_dt;
--ctas
CREATE TABLE gis_dt AS
SELECT SYSDATE + ROUND(DBMS_RANDOM.value(-30, 30)) dt,
       '����� ����� ������ Ű��� ���� ���� ������ �Դϴ� ����� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴ�' v1
FROM dual
CONNECT BY LEVEL <= 1000000;

CREATE INDEX idx_n_gis_dt_01 ON gis_dt (dt, v1);

--gis_dt�� dt�÷����� 2020�� 2���� �ش��ϴ� ��¥�� �ߺ����� �ʰ� ���Ѵ� : �ִ� 29���� ��
--2020/02/03 ==> 2020/02/03
SELECT DISTINCT dt
FROM gis_dt
WHERE dt 
BETWEEN TO_DATE('2020/02/01', 'yyyy/mm/dd') 
AND TO_DATE('2020/03/01', 'yyyy/mm/dd');

SELECT DISTINCT dt
FROM gis_dt
WHERE dt 
BETWEEN TO_DATE('2020/02/01', 'yyyy/mm/dd') 
AND ADD_MONTHS(TRUNC(TO_DATE('2020/02/01', 'yyyy/mm/dd')), 1);

SELECT TO_CHAR(dt,'yyyy/mm/dd') dt, COUNT(*) cnt
FROM gis_dt
WHERE dt
BETWEEN TO_DATE('2020/02/01', 'yyyy/mm/dd') 
AND TO_DATE('2020/02/29', 'yyyy/mm/dd')
GROUP BY TO_CHAR(dt,'yyyy/mm/dd')
ORDER BY dt;

SELECT *
FROM
    (SELECT TO_DATE('20200201','YYYYMMDD') + (LEVEL -1) dt
     FROM dual
     CONNECT BY LEVEL <= 29) a
WHERE EXISTS (SELECT 'X'
              FROM gis_dt
              WHERE gis_dt.dt 
              BETWEEN dt 
              AND TO_DATE(TO_CHAR(dt,'yyyymmdd') || '235959','yyyymmddhh24miss'));

-- PL/SQL ��� ����
-- DECLARE : ����, ��� ����(��������)
-- BEGIN : ���� ���(�����Ұ�)
-- EXCEPTION : ����ó�� (��������)

-- PL/SQL ������
-- �ߺ��Ǵ� ������ ���� Ư����
-- ���� �����ڰ� �Ϲ����� ���α׷��� ���� �ٸ���
-- JAVA =
-- PL/SQL := 

-- PL/SQL ��������
-- JAVA : Ÿ�� ������(String str;)
-- PL/SQL : ������ Ÿ��(deptno NUMBER(2);)
-- PL/SQL �ڵ� ������ ���� ����� java�� �����ϰ� �����ݷ��� ����Ѵ�
-- java : String str;
-- pl/sql : deptno NUMBER(2) ;

-- PL/SQL ����� ���� ǥ���ϴ� ���ڿ� : /
-- SQL�� ���� ���ڿ� : ;

--Hello World ���
SET SERVEROUTPUT ON;
DECLARE 
    msg VARCHAR2(50);
BEGIN 
    msg := 'Hello World';
    DBMS_OUTPUT.PUT_LINE(msg); --> �⺻���� �ܿ��
END;
/
-- �μ� ���̺��� 10�� �μ��� �μ���ȣ�� �μ��̸��� PL/SQL ������ �����ϰ�
-- ������ ���
DECLARE 
    v_deptno NUMBER(2);
    v_dname VARCHAR2(14);
BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept;
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE(v_deptno || ':' || v_dname);
END;
/

--PL/SQL ���� Ÿ��
--�μ� ���̺��� �μ���ȣ, �μ����� ��ȸ�Ͽ� ������ ��� ����
--�μ���ȣ, �μ����� Ÿ���� �μ� ���̺� ���ǰ� �Ǿ�����
--NUMBER, VARCHAR2 Ÿ���� ���� ����ϴ°� �ƴ϶� �ش� ���̺��� �÷��� Ÿ���� 
--�����ϵ��� ���� Ÿ���� ������ �� �ִ� -> ����Ÿ��
--v_deptno NUMBER(2) ==> dept.deptno%TYPE

DECLARE 
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE(v_deptno || ':' || v_dname);
END;
/

--���ν��� ��� ����
--�͸� ���(�̸��� ���� ���)
--      -> ������ �Ұ���(�ζ��� ��� ��� ����)
--���ν��� (�̸��� �ִ� ���)
--      -> ���� ����, �̸��� �ִ�, ���ν����� ������ �� �Լ�ó�� ���ڸ� ���� �� �ִ�
--�Լ�(�̸��� �ִ� ���)
--      -> ���� ����, �̸��� �ִ�, ���ϰ��� �ִ�
--���ν��� ����
--CREATE OR REPLACE PROCEDURE ���ν����̸� IS (IN param, OUT param, IN OUT param)
--����� (DECLARE ���� ����)
--BEGIN
--EXCEPTION(�ɼ�)
--END;
--/

--�μ� ���̺��� 10�� �μ��� �μ���ȣ�� �μ��̸��� PL/SQL ������ �����ϰ�
--DBMS_OUTPUT.PUT_LINE �Լ��� �̿��Ͽ� ȭ�鿡 ����ϴ� printdept ���ν����� ����
CREATE OR REPLACE PROCEDURE printdept IS 
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
    BEGIN
        SELECT deptno, dname INTO v_deptno, v_dname
        FROM dept
        WHERE deptno = 10;
        
    DBMS_OUTPUT.PUT_LINE(v_deptno || ':' || v_dname);
END;
/

--���ν��� ���� ���
--exec ���ν�����(����..)
EXEC printdept;

--printdept_p ���ڷ� �μ���ȣ�� �޾Ƽ�
--�ش� �μ���ȣ�� �ش��ϴ� �μ��̸��� ���������� �ֿܼ� ����ϴ� ���ν���

CREATE OR REPLACE PROCEDURE printdept_p (p_deptno IN dept.deptno%TYPE) IS
    v_dname dept.dname%TYPE;
    v_loc dept.loc%TYPE;
BEGIN
    SELECT dname, loc INTO v_dname, v_loc
    FROM dept
    WHERE deptno = p_deptno;
  
    DBMS_OUTPUT.PUT_LINE(v_dname || ', ' || v_loc);
END;
/
EXEC printdept_p;

--�ǽ� 1��
CREATE OR REPLACE PROCEDURE printemp IS
    e_empno emp.empno%TYPE;
    e_ename emp.ename%TYPE;
    d_dname dept.dname%TYPE;
BEGIN
    SELECT e.empno, e.ename, d.dname INTO e_empno, e_ename, d_dname
    FROM emp e, dept d 
    WHERE e.deptno = d.deptno;
  
    DBMS_OUTPUT.PUT_LINE(e_empno || ', ' || e_ename || ':' || d_dname);
END;
/

EXEC printemp;

