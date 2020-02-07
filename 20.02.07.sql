--TRUNCATE �׽�Ʈ
--1. REDO �α׸� �������� �ʱ� ������ ������ ������ ������ �Ұ��ϴ�
--2. DML(SELECT, INSERT, UPDATE, DELETE)�� �ƴ϶� DDL�� �з�
--   DDL�� �з�(ROLLBACK�� �Ұ�)

--�׽�Ʈ �ó�����
--EMP���̺��� �����Ͽ� EMP_COPY��� �̸����� ���̺� ����
--EMP_COPY ���̺� ������� TRUNCATE TABLE EMP_COPY ����
--EMP_COPY ���̺� �����Ͱ� �����ϴ��� (���������� ������ �Ǿ�����) Ȯ��

--emp_copy ���̺� ����
--CREATE --> DDL (�ѹ� �Ұ�)
CREATE TABLE emp_copy As
SELECT
    *
FROM emp;

SELECT
    *
FROM EMP_COPY;

TRUNCATE TABLE emp_copy;
--TRUNCATE ��ɾ�� DDL �̱� ������ ROLLBACK�� �Ұ��ϴ�
--ROLLBACK �� SELECT�� �غ��� �����Ͱ� ���� ���� ���� ���� �� �� �ִ�

--��ȭ ����
--Ʈ����� : ���� �ܰ踦 �ϳ��� ������ ������ ���´�

--DDL : Data Defination Language - ������ ���Ǿ�
--��ü�� �����ϰų� ����, ������ ���
--ROLLBACK �Ұ�, �ڵ� COMMIT

--���̺� ����
--CREATE TABLE [��Ű����(���Ӱ���).]���̺��(
--              �÷��� �÷�Ÿ��[DEFAULT �⺻��],
--              �÷���2 �÷�Ÿ��2[DEFAULT �⺻��],....);

CREATE TABLE ranger(
        ranger_no NUMBER,
        ranger_nm VARCHAR2(50),
        reg_dt DATE DEFAULT SYSDATE
);
SELECT
    *
FROM ranger;

INSERT INTO ranger(ranger_no, ranger_nm) VALUES (1, 'brown');
 
--���̺� ����
--DROP TABLE ���̺��
--�ѹ� �Ұ�
DROP TABLE ranger;

--������ Ÿ��
--���ڿ�(varchar2 ���, char Ÿ�� ��� ����)
--char(10) : �������� ���ڿ�
--          �ش� �÷��� ���ڿ��� 5byte�� �����ϸ� ������ 5byte �������� ä������
--          'test' --> 'test     '
--         
--varchar(10) : �������� ���ڿ�, ������ 1~4000byte
--              �ԷµǴ� ���� �÷� ������� �۾Ƶ� ���� ������ �������� ä���� �ʴ´�

--����
--number(p, s) : p -> ��ü �ڸ���(38), s -> �Ҽ��� �ڸ���
--range_no NUMBER -> NUMBER(38,0)�� ����
--integer -> NUMBER(38,0)�� ����

--��¥
--date : ���ڿ� �ð� ������ ����
--      7byte
--��¥ : date
--      varchar2(8) -> '20200207'
--      �� �ΰ��� Ÿ���� �ϳ��� �����ʹ� 1byte�� ����� ���̰� ����
--      ������ ���� ���� ���� �Ǹ� ������ �� ���� �������, ����� Ÿ�Կ� ���� ����� �ʿ�
--LOB(Large object)
--CLOB(Character Large object)
--      -->varchar�� ���� �� ���� �������� ���ڿ�(4000byte �ʰ� ���ڿ�)
--      -->ex)�� �����Ϳ� ������ html �ڵ�
--BLOB(Byte Large object)
--      -->������ �����ͺ��̽��� ���̺��� ������ ��
--      -->�Ϲ������� �Խñ� ÷�������� table�� ���� �������� �ʰ�,
--          ���� ÷�������� ��ũ�� Ư�� ������ �����ϰ�, �ش� [���]�� ���ڿ��� ����
--      -->������ �ſ� �߿��� ��� : �� ���� ��� ���Ǽ� -> [����]�� ���̺� ����

--�������� : �����Ͱ� ���Ἲ�� ��Ű���� ���� ����
--1.UNIQUE : �ش� �÷��� ���� �ٸ� ���� �����Ϳ� �ߺ����� �ʵ��� ����
--          ex)����� ���� ����� ���� ���� ����
--2.NOT NULL :(CHECK ���� ����) : �ش� �÷��� ���� �ݵ�� �����ؾ� �ϴ� ����
--          ex)��� �÷��� NULL�� ����� ������ ���� ����
--              ȸ�����Խ� �ʼ� �Է»���(github - �̸���, �̸�)
--3.PRIMARY KEY : UNIQUE + NOT NULL
--          ex)����� ���� ����� ���� ���� ����, ����� ���� ����� ���� ���� ����
--              PRIMARY KEY ���� ������ ������ ��� �ش� �÷����� UNIQUE INDEX�� �����ȴ�
--4.FOREIGN KEY (�������Ἲ) : �ش� �÷��� �����ϴ� �ٸ� ���̺��� ���� �����ϴ� ���� �־�� �Ѵ�
--          ex)emp ���̺��� deptno �÷��� dept ���̺��� deptno �÷��� ����(����)
--             emp ���̺��� deptno �÷����� dept ���̺� �������� �ʴ� �μ���ȣ�� �Է� �� �� ����
--             ���� dept ���̺��� �μ���ȣ�� 10~40���� ���� �� ���
--              ->emp ���̺� ���ο� ���� �߰� �ϸ鼭 �μ���ȣ ���� 99������ ����� ��� : �� �߰� ����
--5.CHECK (���� üũ) : NOT NULL ���� ���ǵ� CHECK ���࿡ ����
--                     emp ���̺� job �÷��� ��� �� �� �ִ� ���� 'SALESMAN', 'PRESIDENT', 'CLERK'
--�������� ���� ��� 
--1.���̺��� �����ϸ鼭 �÷��� ���
--2.���̺��� �����ϸ鼭 �÷� ��� ���Ŀ� ������ ���� ������ ���
--3.���̺� ������ ������ �߰������� ���������� �߰�

--CREATE TABLE ���̺�� (
--  �÷�1 �÷� Ÿ��[��������]...,
--  [2.TABLE_CONSTRAINT] );

--ALTER TABLE emp....

--PRIMARY KEY ���� ������ �÷� ������ ����
--��, �� ����� ���̺��� key �÷��� ���� �÷��� �Ұ�, ���� �÷��� ���� ����
CREATE TABLE dept_test (
             deptno NUMBER(2) PRIMARY KEY,
             dname VARCHAR2(14),
             loc VARCHAR2(13)
             );
INSERT INTO dept_test (deptno) VALUES (99); --���������� ����;             
INSERT INTO dept_test (deptno) VALUES (99); --���� ���� �����Ϳ� ����;

--�������(���� dept ���̺��� deptno�÷����� ���������� ���� ������ ���� ��� ����)
INSERT INTO dept(deptno) VALUES (99);             
INSERT INTO dept(deptno) VALUES (99); 

--�������� Ȯ�� ���
--1.���� ���� Ȯ��
--  -->Ȯ���ϰ��� �ϴ� ���̺��� ����
--2.DICTIONARY�� ���� Ȯ��(user_tables)
--3.�𵨸�(EXERD)�� ���� Ȯ��
SELECT
    *
FROM USER_CONSTRAINTS
WHERE table_name = 'DEPT_TEST';

SELECT
    *
FROM USER_CONS_COLUMNS
WHERE CONSTRAINT_NAME='SYS_C007085';
--�������� ���� ������� ���� ��� ����Ŭ���� �������� �̸��� ���Ƿ� �ο�
--�������� �������� ������ ��� ��Ģ �����ϰ� �����ϴ°� ����, � ������ ����
--PRIMARY KEY �������� : PK_���̺��
--FOREIGN KEY �������� : FK_������̺��_�������̺��

DROP TABLE DEPT_TEST;
--�÷� ������ ���������� �����ϸ鼭 �������� �̸��� �ο��Ѵ�
--CONSTRAINT �������Ǹ� ��������Ÿ��(PRIMARY KEY)
CREATE TABLE dept_test (
             deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY,
             dname VARCHAR2(14),
             loc VARCHAR2(13)
             );
INSERT INTO dept_test(deptno) VALUES (99);
INSERT INTO dept_test(deptno) VALUES (99);

--1.���̺� ������ �÷� ��� ���� ������ �������� ���
CREATE TABLE dept_test (
             deptno NUMBER(2),
             dname VARCHAR2(14),
             loc VARCHAR2(13),
             CONSTRAINT PK_dept_test PRIMARY KEY(deptno)
             );
--NOT NULL �������� �����ϱ�
--1.�÷��� ����ϱ�
--  -->��, �÷��� ����ϸ鼭 �������� �̸��� �ο��ϴ°� �Ұ�
CREATE TABLE dept_test (
             deptno NUMBER(2),
             dname VARCHAR2(14) NOT NULL,
             loc VARCHAR2(13),
             
             CONSTRAINT PK_dept_test PRIMARY KEY(deptno)
             );
--NOT NULL �������� Ȯ��
INSERT INTO dept_test(deptno, danme) VALUES(99,null);

--2.���̺� ������ �÷� ��� ���Ŀ� ���� �����߰�
CREATE TABLE dept_test (
             deptno NUMBER(2),
             dname VARCHAR2(14),
             loc VARCHAR2(13),
             
             CONSTRAINT NN_dept_test_dname CHECK (deptno IS NOT NULL)
             );

--UNIQUE ���� : �ش� �÷��� �ߺ��Ǵ� ���� ������ ���� ����, �� NULL ����
--PRIMARY KEY = UNIQUE + NOY NULL
--1.���̺� ������ �÷� ���� UNIQUE ���� ����
--dname �÷��� UNIQUE ��������
CREATE TABLE dept_test (
             deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY,
             dname VARCHAR2(14)UNIQUE,
             loc VARCHAR2(13)
             );
--dept_test ���̺��� dname �÷��� ������ UNIQUE ���������� Ȯ��
INSERT INTO dept_test VALUES(98,'DDIT','DAEJEON');
INSERT INTO dept_test VALUES(98,'DDIT','DAEJEON');
--2.���̺� ������ �÷��� �������� ���, �������� �̸� �ο�
CREATE TABLE dept_test (
             deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY,
             dname VARCHAR2(14)CONSTRAINT UK_dept_test_dname UNIQUE,
             loc VARCHAR2(13)
             );
--dept_test ���̺��� dname �÷��� ������ UNIQUE ���������� Ȯ��
INSERT INTO dept_test VALUES(98,'DDIT','DAEJEON');
INSERT INTO dept_test VALUES(99,'DDIT','DAEJEON');

--3.���̺� ������ �÷� ������� �������� ���� -���� �÷�(deptno - dname) (UNIQUE)
CREATE TABLE dept_test (
        deptno NUMBER(2),
        dname VARCHAR2(14),
        loc VARCHAR2(13),
        
        CONSTRAINT UK_dept_test__deptno_dname UNIQUE (deptno, dname)
);
--���� �÷��� ���� unique ���� Ȯ�� (deptno, dname)
INSERT INTO dept_test VALUES (99, 'ddit','daejeon');
INSERT INTO dept_test VALUES (98, 'ddit','daejeon');
INSERT INTO dept_test VALUES (98, 'ddit','����');

--FOREIGN KEY ��������
--�����ϴ� ���̺��� �÷��� �����ϴ� ���� ��� ���̺��� �÷��� �Է��� �� �ֵ��� ����
--EX) emp ���̺� deptno �÷��� ���� �Է��� ��, dept ���̺��� deptno �÷��� �����ϴ�
--    �μ���ȣ�� �Է��� �� �ֵ��� ����
--    �������� �ʴ� �μ���ȣ�� emp ���̺��� ������� ���ϰԲ� ����
--1.dept_test ���̺����
--2.emp_test ���̺� ����
--    .emp_test ���̺� ������ deptno �÷����� dept.deptno �÷��� �����ϵ��� FK����

DROP TABLE dept_test;
CREATE TABLE dept_test(
             deptno NUMBER(2),
             dname VARCHAR2(14),
             loc VARCHAR2(13),
             
             CONSTRAINT pk_dept_test PRIMARY KEY (deptno)
            );
             
DROP TABLE emp_test;           
CREATE TABLE emp_test(
            empno NUMBER(4),
            ename VARCHAR2(10),
            deptno NUMBER(2) REFERENCES dept_test (deptno) ,
            
            CONSTRAINT pk_emp_test PRIMARY KEY (empno)
            );
--������ �Է� ����
--emp_test ���̺� �����͸� �Է��ϴ°� �����Ѱ�?
--���ݻ�Ȳ : (dept_test, emp_test ���̺��� ��� ���� -> �����Ͱ� �������� ���� ��)
INSERT INTO emp_test VALUES (9999, 'brown',null); --FK�� ������ �÷��� NULL�� ���
INSERT INTO emp_test VALUES (9998, 'sally',10); --10�� �μ��� dept_test ���̺� �������� �ʾƼ� ����

--dept_test���̺� �����͸� �غ�
INSERT INTO dept_test VALUES (99, 'ddit','daejeon'); 
INSERT INTO emp_test VALUES (9998, 'sally', 99);  --99�� �μ��� �����ϹǷ� ����                                        
INSERT INTO emp_test VALUES (9998, 'sally', 10);  --10�� �μ��� �������� �����Ƿ� ����

--���̺� ������ �÷� ��� ���� FOREIGN KEY �������� ����
DROP TABLE dept_test;
DROP TABLE emp_test;

CREATE TABLE dept_test(
             deptno NUMBER(2),
             dname VARCHAR2(14),
             loc VARCHAR2(13),
             
             CONSTRAINT pk_dept_test PRIMARY KEY (deptno)
            );
INSERT INTO dept_test VALUES (99, 'ddit','daejeon');             

CREATE TABLE emp_test(
            empno NUMBER(4),
            ename VARCHAR2(14),
            deptno NUMBER(2),
            CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test(deptno)
            );
INSERT INTO emp_test VALUES(9999,'brown',10); --dept_test ���̺� 10�� �μ��� �������� �ʾ� ����            
INSERT INTO emp_test VALUES(9999,'brown',99); --dept_test ���̺� 99�� �μ��� �����ϹǷ� ����

