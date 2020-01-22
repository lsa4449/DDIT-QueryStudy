-- PROD ���̺��� ��� �÷��� �ڷ� ��ȸ
SELECT * FROM prod;

-- PROD ���̺��� PROD_ID, PROD_NAME �÷��� �ڷḸ ��ȸ
SELECT prod_id, prod_name FROM prod;

--1��
SELECT * FROM lprod;
--2��
SELECT buyer_id, buyer_name FROM buyer;
--3��
SELECT * FROM cart;
--4��
SELECT mem_id, mem_pass ,mem_name FROM member;


--users ���̺� ��ȸ
SELECT * FROM users;

--���̺� � �÷��� �ִ��� Ȯ���ϴ� ���
-- 1. SELECT *
-- 2. TOOL ��� (����� - TABLES)
-- 3. DESC ���̺�� (DESCRIBE)

DESC USERS;

--users ���̺��� userid, usernm, reg_dt �÷��� ��ȸ�ϴ� sql�� �ۼ�
--��¥ ���� (reg_dt �÷��� date������ ���� �� �ִ� Ÿ��)
--SQL ��¥ �÷� + (���ϱ� ����) 
--�������� ��Ģ ������ �ƴ� �� �� (5+5)
--String h = "hello"; String w = "world";
--String hw = h+w; -> �ڹٿ����� �� ���ڿ��� ����!
--SQL���� ���ǵ� ��¥ ���� : ��¥ + ���� = ��¥���� ������ ���ڷ� ����Ͽ� ���� ��¥�� ��
--ex (2019/01/28 + 5 \ 2019/02/02)
--reg_dt : ������� �÷� (reg_dt + 5 = �÷��� �ƴ� ǥ����)
--null : ���� �𸣴� ����
--null�� ���� ���� ����� �׻� null(�ڹٴ� ���x)

SELECT userid u_id, usernm, reg_dt, 
        reg_dt + 5 AS reg_dt_after_5day 
FROM users;

--1��
SELECT prod_id id, prod_name name 
FROM prod;
--2��
SELECT lprod_gu gu, lprod_nm nm 
FROM lprod;
--3��
SELECT buyer_id ���̾���̵�, buyer_name �̸� 
FROM buyer;

--���ڿ� ����
--�ڹ� ���� ���ڿ� ���� : + ("Hello" + "world")
--sql���� ���ڿ� ���� : || ('Hello' || 'world')
--sql���� ���ڿ� ���� : concat ('Hello' , 'world')
--userid, usernm �÷��� ����, ��Ī id_name

SELECT userid || usernm id_name
    ,concat(userid, usernm) 
FROM users;

--����, ���
--int a =5; String msg = "hello world";
--System.out.println(msg); ->������ �̿��� ���
--System.out.println("hello world"); ->����� �̿��� ���
--sql������ ������ ����(�÷��� ����� ����, pl/sql���� ����)
--sql���� ���ڿ� ����� �̱� �����̼����� ǥ��
-- "hello, world" ->'hello, world'
--���ڿ� ����� �÷����� ����
SELECT 'user id : '|| userid AS "user id"
FROM users;

SELECT 'SELECT * FROM '|| table_name ||';' QUERY  
FROM user_tables;

--CONCAT
SELECT CONCAT(CONCAT('SELECT * FROM' ,table_name),';') QUERY  
FROM user_tables;

--inaa = 5; �Ҵ�, ���� ������
--if ( a == 5 ) (a�� ���� 5���� ��)
--sql == -> equal
--sql������ ������ ������ ����(PL/SQL)

