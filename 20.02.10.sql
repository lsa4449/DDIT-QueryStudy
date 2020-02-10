--1. PRIMARY KEY ���� ���� ������ ����Ŭ DBMS�� �ش� �÷����� UNIQUE INDEX�� �ڵ����� ����
--   (***��Ȯ���� UNIQUE ���࿡ ���� ����ũ �ε����� �ڵ����� �����ȴ�)
--INDEX : �ش� �÷����� �̸� ������ �س��� ��ü
--������ �Ǿ��ֱ� ������ ã���� �ϴ� ���� �����ϴ��� ������ �� �� �ִ�
--���࿡ �ε����� ���ٸ� ���ο� �����͸� �Է��� ��, �ߺ��Ǵ� ���� ã�� ���ؼ�
--�־��� ��� ���̺��� ��� �����͸� ã�ƾ� �Ѵ�
--������ �ε����� ������ �̹� ������ �Ǿ��ֱ� ������ �ش� ���� ���� ������ ������ �� �� �ִ�

--2. FOREIGN KEY �������ǵ� �����ϴ� ���̺� ���� �ִ����� Ȯ�� �ؾ��Ѵ�
--�׷��� �����ϴ� �÷��� �ε����� �־������ FOREIGN KEY ������ ������ ���� �ִ�
--FOREIGN KEY ������ �ɼ�
--            : ���� ���Ἲ, �����ϴ� ���̺��� �÷��� �����ϴ� ���� �Է� �� �� �ֵ��� ����
--              EX) emp ���̺� ���ο� �����͸� �Է½� deptno �÷����� dept ���̺� �����ϴ� �μ���ȣ�� �Է� ����
--FOREIGN KEY�� �����ʿ� ���� �����͸� ������ �� ������
--� ���̺��� �����ϰ� �ִ� �����͸� �ٷ� ������ �ȵ�
--EX) emp.deptno => dept.deptno �÷��� ���� �ϰ� ���� ��
--    �μ� ���̺��� �����͸� ���� �� ���� ����

insert into emp_test (empno, ename, deptno) VALUES(9999,'brown',99);
insert into dept_test VALUES(99,'ddit2','����');

--emp : 9999, 99 / dept : 98, 99
--98�� �μ��� �����ϴ� emp���̺��� �����ʹ� ����
--99�� �μ��� �����ϴ� emp���̺��� �����ʹ� 9999�� brown ����� ����

DELETE dept_test
WHERE deptno = 98;
--�����ϴ� ����� ��ȣ �÷��� ���� �� ������ �������� �ʴ� ����� ���� �� �ִ�.

--FOREIGN KEY �ɼ�
--1.ON DELETE CASCADE : �θ� ������ ���(dept) �����ϴ� �ڽ� �����͵� ���� �����Ѵ�(emp)
--2.ON DELETE SET NULL : �θ� ������ ���(dept) �����ϴ� �ڽ� �������� �÷��� NULL�� �����Ѵ�

--emp_test���̺��� drop �� �ɼ��� ������ ���� ���� �� ���� �׽�Ʈ
drop table emp_test;
create table emp_test (
            empno NUMBER(4),
            ename VARCHAR2(10),
            deptno NUMBER(2),
            CONSTRAINT pk_emp_test PRIMARY KEY (empno),
            CONSTRAINT fk_emp_test_dept_test FOREIGN KEY (deptno) 
                                             REFERENCES dept_test (deptno) ON DELETE CASCADE    
            
            );
INSERT INTO emp_test VALUES(9999,'brown',99);

--emp���̺��� deptno �÷��� dept ���̺��� deptno �÷��� ����(on delete cascade)
--�ɼǿ� ���� �θ����̺�(dept_test)������ �����ϰ� �ִ� �ڽ� �����͵� ���� �����ȴ�
DELETE dept_test 
WHERE deptno = 99;
--�ɼ��� �ο����� �ʾ��� ���� ���� delete ������ ���� �߻�
--�ɼǿ� ���� �����ϴ� �ڽ� ���̺��� �����Ͱ� ���������� ������ �Ǿ��µ� select Ȯ��
SELECT
    *
FROM emp_test;

--ON DELETE SET NULL �ɼ� �׽�Ʈ
--�θ� ���̺��� ������ ������ (dept_test) �ڽ� ���̺��� �����ϴ� �����͸� NULL�� ������Ʈ
drop table emp_test;
create table emp_test (
            empno NUMBER(4),
            ename VARCHAR2(10),
            deptno NUMBER(2),
            CONSTRAINT pk_emp_test PRIMARY KEY (empno),
            CONSTRAINT fk_emp_test_dept_test FOREIGN KEY (deptno) 
                                             REFERENCES dept_test (deptno) ON DELETE SET NULL   
            
            );
INSERT INTO emp_test VALUES(9999,'brown',99);

SELECT
    *
FROM dept_test;

--dept_test ���̺��� 99�� �μ��� �����ϰ� �Ǹ� (�θ� ���̺��� �����ϸ�)
--99�� �μ��� �����ϴ� emp_test ���̺��� 9999��(brown) �������� deptno �÷���
--FK �ɼǿ� ���� NULL�� �����Ѵ�
delete dept_test
where deptno = 99;
--�θ� ���̺��� ������ ���� �� �ڽ� ���̺��� �����Ͱ� NULL�� ���� �Ǿ����� Ȯ��
SELECT
    *
FROM emp_test;

--CHECK ���� ���� : �÷��� ���� ���� ������ ������ �� ���
--EX)�޿� �÷��� ���ڷ� ����, �޿��� ������ �� �� ������?
--   �Ϲ����� ��� �޿� ���� > 0 
--   CHECK ������ ����� ��� �޿� ���� 0���� ū ���� �˻� ����
--   emp ���̺��� job �÷��� ���� ���� ���� 4������ ���� ����
--   'SALESMAN', 'PRESIDENT', 'ANALIST', 'MANAGER;
--���̺� ������ �÷� ����ΰ� �Բ� CHECK ���� ����;
--emp_test ���̺��� sal �÷��� 0���� ũ�ٴ� check ���� ���� ����

drop table emp_test;
create table emp_test (
            empno NUMBER(4),
            ename VARCHAR2(10),
            deptno NUMBER(2),
            sal NUMBER CHECK (sal > 0),
            
            CONSTRAINT pk_emp_test PRIMARY KEY (empno),
            CONSTRAINT fk_emp_sal FOREIGN KEY (deptno) REFERENCES dept_test(deptno)
            );
INSERT INTO emp_test VALUES (9999,'brown',99,1000);
INSERT INTO emp_test VALUES (9999,'sally',99,-1000); --sal üũ���ǿ� ���� 0���� ū ���� �Է� ����

--create table ���̺�� as
--select ����� ���ο� ���̺�� ����

--emp���̺��� �̿��ؼ� �μ���ȣ�� 10�� ����鸸 ��ȸ�Ͽ� �ش� �����ͷ� emp_test2 ���̺� ����
--CTAS ����
CREATE TABLE emp_test2 AS
SELECT * 
FROM emp
WHERE deptno = 10;

SELECT
    *
FROM emp_test2;

--table ����
--�÷� �߰�, �÷� ������ ����, Ÿ�� ����, �⺻�� ����, �÷��� rename, �÷��� ����
--�������� �߰�/����
--table ���� 1. �÷� �߰� ( hp varchar2(20) )
drop table emp_test;
CREATE TABLE emp_test (
        empno NUMBER(4),
        ename VARCHAR2(10),
        deptno NUMBER(2),
        
        CONSTRAINT pk_emp_test PRIMARY KEY(empno),
        CONSTRAINT fk_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test(deptno)
        );
        
ALTER TABLE emp_test ADD (hp varchar2(20));
desc emp_test;

--table ���� 2. �÷� ������ ����, Ÿ�Ժ���
--ex)varchar2(20) ==> varchar2(5) 
--   ������ �����Ͱ� ������ ��� ���������� ������ �ȵ� Ȯ���� �ſ� ����
--�Ϲݴ����� �����Ͱ� �������� �ʴ� ����, �� ���̺��� ������ ���Ŀ� �÷��� ������, Ÿ���� �߸��� ���
--�÷� ������, Ÿ���� ������
--�����Ͱ� �Էµ� ���ķδ� Ȱ�뵵�� �ſ� ������(������ �ø��� �͸� ����) 
ALTER TABLE emp_test MODIFY (hp varchar2(30));
--�÷� Ÿ�� ����
ALTER TABLE emp_test MODIFY (hp number);

--table ���� 3. �÷� �⺻�� ����        
ALTER TABLE emp_test MODIFY (hp varchar2(20) DEFAULT '010');
--hp �÷����� ���� ���� �ʾ����� default ������ ���� '010' ���ڿ��� �⺻������ ����ȴ�
INSERT INTO emp_test (empno, ename, deptno) VALUES (9999,'brown',99);
SELECT
    *
FROM emp_test;
        
--table ���� 4. �÷� ����
--�����Ϸ��� �ϴ� �÷��� fk����, pk������ �־ ��� ����
ALTER TABLE emp_test RENAME COLUMN hp TO hp_n;

--table ���� 5. �÷� ����
ALTER TABLE emp_test DROP(hp_n);
ALTER TABLE emp_test DROP COLUMN hp_n;

--1. emp_test ���̺��� drop �� empno, ename, deptno, hp 4���� �÷����� ���̺� ����
--2. empno, ename, deptno 3���� �÷����� (9999, 'brown', 99)�����ͷ� insert
--3. emp_test ���̺��� hp �÷��� �⺻���� '010'���� ����
--4. 2�� ������ �Է��� �������� hp �÷� ���� ��� �ٲ���� Ȯ��
--default ������ ���߿� �ϰ� �Ǹ� ���� �ٲ��� �ʴ´� (null������ �� ����)

--table ���� 6. �������� �߰�/����
--ALTER TABLE ���̺�� ADD CONSTRAINT �������Ǹ� �������� Ÿ��(PRIMARY KEY, FOREIGN KEY) (�ش��÷�);
ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno);
ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;

--1. emp_test ���̺� ���� ��
--2. �������� ���� ���̺��� ����
--3. primary key, foreign key ������ alter table ������ ���� ����
DROP TABLE emp_test;
CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2)
    );

ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno);
ALTER TABLE emp_test ADD CONSTRAINT fk_emp_test_dept_test FOREIGN KEY(deptno) 
                                    REFERENCES dept_test(deptno);

--primary key �׽�Ʈ
INSERT INTO emp_test VALUES(9999, 'brown', 99);
INSERT INTO emp_test VALUES(9999, 'sally', 99); --�ߺ��� �÷����� ���� ����

--foreign key �׽�Ʈ
INSERT INTO emp_test VALUES(9998, 'sally', 98); --dept_test ���̺� �������� �ʴ� �μ���ȣ �̹Ƿ� ���� ����

--�������� ���� : primary key, foreign key 
ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;
ALTER TABLE emp_test DROP CONSTRAINT fk_emp_test_dept_test;

--���������� �����Ƿ� empno�� �ߺ��� ���� �� �� �ְ�, dept_test���̺� �������� �ʴ�
--deptno ���� �� �� �ִ�
INSERT INTO emp_test VALUES (9999, 'brown', 99);
INSERT INTO emp_test VALUES (9999, 'sally', 99);
--�������� �ʴ� 98�� �μ��� ������ �Է�
INSERT INTO emp_test VALUES (9998, 'brown', 98);

--primary key, foreign key, not null, check, unique
--�������� Ȱ��ȭ / ��Ȱ��ȭ
--ALTER TABLE ���̺�� ENABLE | DISABLE CONSTRAINT �������Ǹ�

--1. emp_test ���̺� ����
--2. emp_test ���̺� ����
--3. alter table primary key(empno), foreign key(dept_test.deptno)���� ���� ����
--4. �ΰ��� ���������� ��Ȱ��ȭ
--5. ��Ȱ��ȭ�� �Ǿ����� insert�� ���� Ȯ��
--6. ���������� ������ �����Ͱ� �� ���¿��� �������� Ȱ��ȭ
DROP TABLE emp_test;
CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2)
    );
ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY(empno);
ALTER TABLE emp_test ADD CONSTRAINT fk_emp_test_dept_test FOREIGN KEY(empno)
                                    REFERENCES dept_test(deptno);

--emp_test���̺��� empno �÷��� ���� 9999�� ����� �θ� �����ϱ� ������
--primary key ���������� Ȱ��ȭ �� �� ����
--empno�÷��� ���� �ߺ����� �ʵ��� �����ϰ� �������� Ȱ��ȭ �� �� �ִ�
ALTER TABLE emp_test ENABLE CONSTRAINT pk_emp_test;
ALTER TABLE emp_test ENABLE CONSTRAINT fk_emp_test_dept_test;

INSERT INTO emp_test VALUES (9999,'brown',99);
INSERT INTO emp_test VALUES (9999,'sally',98); 

--empno �ߺ� ������ ����
delete emp_test
where ename = 'brown';

SELECT
    *
FROM dept_test;
--dept_test ���̺� �������� �ʴ� �μ���ȣ��98�� emp_test���� �����
--1. dept_test ���̺� 98�� �μ��� ����ϰų�
--2. sally�� �μ���ȣ�� 99������ �����ϰų�

UPDATE emp_test SET deptno = 99
WHERE ename = 'sally';