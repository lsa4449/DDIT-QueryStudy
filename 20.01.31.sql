--JOIN 두 테이블을 연결하는 작업
--JOIN 문법
--1. ANSI 문법 
--2. ORACLE 문법

--Natural Joio
--두 테이블간 컬럼명이 같을 때 해당 컬럼으로 연결
--emp, dept 테이블에는 deptno라는 컬림이 존재
SELECT
    *
FROM emp NATURAL JOIN dept;

--Natural Join에 사용된 조인 컬럼(deptno)는 한정자(ex : 테이블명, 테이블 별칭)을 사용하지 않고
--컬럼명만 기술한다. (dept.deptno --> deptno)
SELECT emp.ename, emp.empno, dept.dname, deptno
FROM emp NATURAL JOIN dept;

--테이블에 대한 별칭도 사용 가능
SELECT e.ename, e.empno, d.dname, deptno
FROM emp e NATURAL JOIN dept d;

--ORACLE Join
--FROM 절에 조인할 테이블 목록을 ,로 구분하여 나열한다
--조인할 테이블의 연결 조건을 WHERE 절에 기술한다
--emp, dept 테이블에 존재하는 deptno 컬럼이 같을 때 조인
SELECT emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--오라클 조인의 테이블 별칭
SELECT e.empno, e.ename, d.dname, e.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno;

--ANSI join: join with USING
--조인 하려는 두개의 테이블에 이름이 같은 컬럼이 두개이지만
--하나의 컬럼으로만 조인을 하고자 할때 조인하려는 기준 컬럼을 기술
--emp, dept 테이블의 공통 컬럼 : deptno
SELECT emp.ename, dept.dname, deptno
FROM emp JOIN dept USING(deptno);
--oracle로 표현 하려면?
SELECT e.empno, e.ename, d.dname, e.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno;

--ANSI join2 : join with on
--조인 하려고하는 테이블의 컬럼의 이름이 서로 다를때
SELECT emp.ename, dept.dname, dept.deptno
FROM emp JOIN dept ON (emp.deptno = dept.deptno);
--oracle로 표현하려면? --> 위의 쿼리랑 똑같다

--SELF Join : 같은 테이블간의 조인
--emp테이블에서 관리되는 사원의 관리자 사번을 이용하여 
--관리자 이름을 조회할 때;
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno);
--oracle로 표현하려면?
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

--equal 조인 : = 
--non-equal 조인 : !=, <, >, BETWEEN AND
SELECT
    *
FROM salgrade;

SELECT
    *
FROM emp;
--non-equal 조인일 경우(같은 컬럼이 존재하지 않을 때)
--사원의 급여 정보와 등급 테이블을 이용하여 해당사원의 급여 등급 구해보기
SELECT e.ename, sal , s.grade
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.losal AND s.hisal;
--ANSI 문법으로 표현하려면?
SELECT e.ename, e.sal , s.grade
FROM emp e 
JOIN salgrade s
ON e.sal BETWEEN s.losal AND s.hisal;

--join 0번
SELECT e.empno, e.ename, deptno, d.dname
FROM emp e NATURAL JOIN dept d
ORDER BY deptno;

SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
ORDER BY deptno;

--1번
SELECT e.empno, e.ename, deptno, d.dname
FROM emp e NATURAL JOIN dept d
WHERE deptno IN (10,30);

SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND d.deptno IN (10,30)
ORDER BY deptno;

--2번
SELECT e.empno, e.ename, e.sal, deptno, d.dname
FROM emp e NATURAL JOIN dept d
WHERE e.sal > 2500
ORDER BY deptno;

SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.sal > 2500
ORDER BY deptno;

--3번
SELECT e.empno, e.ename, e.sal, deptno, d.dname
FROM emp e NATURAL JOIN dept d
WHERE e.sal > 2500 AND empno > 7600
ORDER BY deptno;

SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.sal > 2500 AND empno > 7600
ORDER BY deptno;

--4번
SELECT e.empno, e.ename, e.sal, deptno, d.dname
FROM emp e NATURAL JOIN dept d
WHERE e.sal > 2500 AND empno > 7600 AND d.dname = 'RESEARCH'
ORDER BY deptno;

SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno 
AND e.sal > 2500 AND empno > 7600 AND d.dname = 'RESEARCH'
ORDER BY deptno;

--prod : prod_lgu
--lprod : lprod_gu
SELECT
    *
FROM prod;

SELECT
    *
FROM cart;

--join 1번
SELECT l.lprod_gu, l.lprod_nm, p.prod_id, p.prod_name
FROM prod p natural join lprod l;

--2번
SELECT b.buyer_id, b.buyer_name, p.prod_id, p.prod_name
FROM prod p natural join buyer b;

--3번
SELECT m.mem_id, m.mem_name, p.prod_name, c.cart_qty
FROM prod p, member m, cart c
WHERE p.prod_id = c. cart_prod
AND c.cart_member = m.mem_id;


