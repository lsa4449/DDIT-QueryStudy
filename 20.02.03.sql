SELECT * FROM cycle;

--판매점 : 200~250
--고객당 2.5개 제품
--하루 : 500~750
--한달 : 15000~17500

SELECT
    *
FROM cycle;

--4번
SELECT c.cid, c.cnm, cy.pid, cy.day, cy.cnt
FROM customer c, cycle cy
WHERE c.cid = cy.cid
AND c.cnm IN ('brown','sally');

--5번
SELECT c.cid, c.cnm, cy.pid, p.pnm, cy.day, cy.cnt
FROM customer c, cycle cy, product p
WHERE c.cid = cy.cid
AND p.pid = cy.pid
AND c.cnm IN ('brown','sally');

--6번
SELECT c.cid, c.cnm, cy.pid, p.pnm, sum(cy.cnt)
FROM customer c JOIN cycle cy ON c.cid = cy.cid
JOIN product p ON p.pid = cy.pid
GROUP BY c.cid, c.cnm, cy.pid, p.pnm, cy.cnt;

--7번
SELECT p.pid, p.pnm, sum(cy.cnt) 
FROM product p JOIN cycle cy ON p.pid = cy.pid
GROUP BY p.pid, p.pnm;

--system 계정을 통한 hr 계정 활성화
--해당 오라클 서버에 등록된 사용자(계정) 조회
SELECT * 
FROM dba_users; 

--HR계정의 비밀번호를 JAVA로 초기화
ALTER USER HR IDENTIFIED BY java;
ALTER USER HR ACCOUNT UNLOCK;

--두 테이블을 조인할 때 연결 조건을 만족 시키지 못하는 데이터를 
--기준으로 지정한 테이블의 데이터만이라도 조회 되게끔 하는 조인 방식

--연결조건 : e.mgr = m.empno; --> KING의 mgr이 null이기 때문에 조인에 실패
--emp 테이블의 데이터는 총 14건 이지만 아래와 같은 쿼리에서는 결과가 13건이 된다.
--(1건이 조인 실패)
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

--ANSI OUTER 
--1. 조인에 실패하더라도 조회가 될 테이블을 선정(매니저 정보가 없어도 사원정보는 나오게끔)
SELECT e.empno, e.ename, e.mgr, m.ename 
FROM emp e 
LEFT OUTER JOIN emp m ON e.mgr = m.empno;

--right로 변경
SELECT e.empno, e.ename, e.mgr, m.ename 
FROM emp m 
RIGHT OUTER JOIN emp e ON e.mgr = m.empno;

--ORACLE OUTER JOIN
--데이터가 없는 쪽의 테이블 컬럼 뒤에 (+)기호를 붙여준다.
--(+)기호를 사용하여 FULL OUTER 문법을 지원하지 않는다.
SELECT e.empno, e.ename, e.mgr, m.ename 
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+);
--위의 sql을 안시outer join으로 변경
--매니저의 부서번호가 10번인 직원만 조회
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp m 
RIGHT OUTER JOIN emp e ON (e.mgr = m.empno AND m.deptno = 10);
--오라클 조인
--오라클 outer join시 기준 테이블의 반대편 테이블의 모든 컬럼에(+)를 붙여야
--정상적인 outer join으로 동작한다
--한 컬럼이라도 누락하면 inner join으로 동작
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
AND m.deptno = 10;

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
AND m.deptno(+) = 10;

--사원 매니저간 right outer join 
SELECT e.empno, e.ename, e.mgr
FROM emp e
RIGHT OUTER JOIN emp m ON (e.mgr = m.empno);

--FULL OUTER : LEFT , RIGHT 중복 제거
--LEFT OUTER : 14건, RIGHT OUTER : 21건
SELECT e.empno, e.ename, e.mgr
FROM emp e
FULL OUTER JOIN emp m ON (e.mgr = m.empno);

--1번
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id
AND b.buy_date(+) = TO_DATE('05/01/25', 'yy/mm/dd');

--2번
SELECT NVL(b.buy_date, TO_DATE('05/01/25', 'yy/mm/dd')), b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id
AND b.buy_date(+) = TO_DATE('05/01/25', 'yy/mm/dd');

--3번
SELECT NVL(b.buy_date, TO_DATE('05/01/25', 'yy/mm/dd')), 
           b.buy_prod, p.prod_id, p.prod_name, 
       NVL(b.buy_qty, 0)
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id
AND b.buy_date(+) = TO_DATE('05/01/25', 'yy/mm/dd');

--4번
SELECT p.pid, p.pnm, cy.cid, cy.day, cy.cnt
FROM cycle cy RIGHT OUTER JOIN product p
ON cy.pid = p.pid 
AND cy.cid = 1 ;


