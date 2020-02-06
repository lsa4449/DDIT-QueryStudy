--empno �÷��� not null���� ������ �ִ�. -insert�� �ݵ�� ���� �����ؾ� ���������� �Էµȴ�
--empno �÷��� ������ ������ �÷��� nullable�̴� (null���� ����� �� �ִ�)
INSERT INTO emp(empno, ename, job) 
VALUES(9999, 'brown', NULL);

INSERT INTO emp(ename, job)
VALUES ('sally', 'SALESMAN');

--���ڿ� : '���ڿ�' 
--���� : 10 
--��¥ : to_date('200206','yymmdd')

--emp ���̺��� hiredate �÷��� dateŸ��
--emp ���̺��� 8���� �÷��� ���� �Է�

desc emp;

INSERT INTO emp 
VALUES(9998, 'sally', 'SALESMAN', NULL, SYSDATE, 1000, NULL, 99);
rollback;

SELECT
    *
FROM emp;

--�������� �����͸� �ѹ��� INSERT
-- INSERT INTO ���̺�� (�÷���1, �÷���2...)
-- SELECT ...
-- FROM

INSERT INTO emp
SELECT 9998, 'sally', 'SALESMAN', NULL, SYSDATE, 1000, NULL, 99
FROM dual
    UNION ALL
SELECT 9999, 'brown', 'CLERK', NULL, SYSDATE -1, 1100, NULL, 99
FROM dual;

--UPDATA����
--UPDATE ���̺�� SET �÷���1 = ������ �÷� ��1, ...
--WHERE �� ���� ����
--������Ʈ ���� �ۼ��� WHERE ���� �������� ������ �ش� ���̺��� ��� ���� ������� ������Ʈ�� �Ͼ��
--UPDATE, DELETE ���� WHERE ���� ������ �ǵ��Ѱ� �´��� �ٽ��ѹ� Ȯ��
--WHERE���� �ִٰ� �ϴ��� �ش� �������� �ش� ���̺��� SELECT �ϴ� ������ �ۼ��Ͽ�
--�����ϸ� UPDATE��� ���� ��ȸ�� �� �����Ƿ� Ȯ���ϰ� �����ϴ°͵� ��� �߻������� ����!

--99�� �μ���ȣ�� ���� �μ� ������ DEPT ���̺� �ִ� ��Ȳ
INSERT INTO dept VALUES (99,'ddit','daejeon');

--99�� �μ���ȣ�� ���� �μ��� dname �÷��� ���� '���it', loc �÷��� ���� '���κ���'���� ������Ʈ
UPDATE dept SET dname = '���it', loc = '���κ���'
WHERE detpno = 99;
 
--10 --> ��������
--���̽��� ���尡 ���� �μ��� �Ҽӵ� ���� ����
SELECT
    *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN('SMITH','WARD'));
--update�ÿ��� �������� ����� ����
INSERT INTO emp(empno, ename) VALUES (9999,'brown');
--9999�� ��� �μ���ȣ�� ���� ������ ���̽� ����� �����ϰ� ������Ʈ
UPDATE emp SET deptno = 
                        (SELECT deptno
                         FROM emp
                         WHERE ename ='SMITH'),
                job = 
                        (SELECT job
                         FROM emp
                         WHERE ename = 'SMITH')         
WHERE empno = 9999;
rollback;

SELECT
    *
FROM emp;

SELECT
    *
FROM dept;

--delete : Ư�� ���� ����
--DELETE [FROM] ���̺�� WHERE �� ���� ����;
DELETE dept 
WHERE deptno = 99;

--���������� ���ؼ� Ư�� ���� �����ϴ� ������ ���� DELETE
--�Ŵ����� 7698 ����� ������ ����
DELETE emp
WHERE empno IN (SELECT empno
                FROM emp
                WHERE mgr = 7698);