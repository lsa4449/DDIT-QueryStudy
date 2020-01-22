-- PROD 테이블의 모든 컬럼의 자료 조회
SELECT * FROM prod;

-- PROD 테이블에서 PROD_ID, PROD_NAME 컬럼의 자료만 조회
SELECT prod_id, prod_name FROM prod;

--1번
SELECT * FROM lprod;
--2번
SELECT buyer_id, buyer_name FROM buyer;
--3번
SELECT * FROM cart;
--4번
SELECT mem_id, mem_pass ,mem_name FROM member;


--users 테이블 조회
SELECT * FROM users;

--테이블에 어떤 컬럼이 있는지 확인하는 방법
-- 1. SELECT *
-- 2. TOOL 기능 (사용자 - TABLES)
-- 3. DESC 테이브명 (DESCRIBE)

DESC USERS;

--users 테이블에서 userid, usernm, reg_dt 컬럼만 조회하는 sql문 작성
--날짜 연산 (reg_dt 컬럼은 date정보를 담을 수 있는 타입)
--SQL 날짜 컬럼 + (더하기 연산) 
--수학적인 사칙 연산이 아닌 것 들 (5+5)
--String h = "hello"; String w = "world";
--String hw = h+w; -> 자바에서는 두 문자열을 결합!
--SQL에서 정의된 날짜 연산 : 날짜 + 정수 = 날짜에서 정수를 일자로 취급하여 더한 날짜가 됨
--ex (2019/01/28 + 5 \ 2019/02/02)
--reg_dt : 등록일자 컬럼 (reg_dt + 5 = 컬럼이 아닌 표현식)
--null : 값을 모르는 상태
--null에 대한 연산 결과는 항상 null(자바는 상관x)

SELECT userid u_id, usernm, reg_dt, 
        reg_dt + 5 AS reg_dt_after_5day 
FROM users;

--1번
SELECT prod_id id, prod_name name 
FROM prod;
--2번
SELECT lprod_gu gu, lprod_nm nm 
FROM lprod;
--3번
SELECT buyer_id 바이어아이디, buyer_name 이름 
FROM buyer;

--문자열 결합
--자바 언어에서 문자열 결합 : + ("Hello" + "world")
--sql에서 문자열 결합 : || ('Hello' || 'world')
--sql에서 문자열 결합 : concat ('Hello' , 'world')
--userid, usernm 컬럼을 결합, 별칭 id_name

SELECT userid || usernm id_name
    ,concat(userid, usernm) 
FROM users;

--변수, 상수
--int a =5; String msg = "hello world";
--System.out.println(msg); ->변수를 이용한 출력
--System.out.println("hello world"); ->상수를 이용한 출력
--sql에서의 변수는 없음(컬럼이 비슷한 역할, pl/sql에는 존재)
--sql에서 문자열 상수는 싱글 쿼테이션으로 표현
-- "hello, world" ->'hello, world'
--문자열 상수와 컬럼간의 결합
SELECT 'user id : '|| userid AS "user id"
FROM users;

SELECT 'SELECT * FROM '|| table_name ||';' QUERY  
FROM user_tables;

--CONCAT
SELECT CONCAT(CONCAT('SELECT * FROM' ,table_name),';') QUERY  
FROM user_tables;

--inaa = 5; 할당, 대입 연산자
--if ( a == 5 ) (a의 값이 5인지 비교)
--sql == -> equal
--sql에서는 대입의 개념이 없다(PL/SQL)

