--CROSS JOIN --> 카티션 프로덕트(Cartesian product)
--dept 테이블과 emp 테이블을 조인을 하기 위해 FROM 절에 두개의 테이블 기술
--WHERE절에 두 테이블의 연결 조건을 누락
--조인하는 두 테이블의 연결조건이 누락되는 경우
--가능한 모든 조합에 대해 연결(조인)이 시도
--dept(4건), emp(14건)의 CROSS JOIN의 결과는 4*14 = 56건

--cross join 1번
SELECT *
FROM customer, product;

--SUBQUERY
--스미스가 속한 부서에 속하는 직원들의 리스트
SELECT *
FROM emp
WHERE deptno =
    (SELECT deptno
     FROM emp
     WHERE ename = 'SMITH');
--쿼리안에 다른 쿼리가 들어가 있는 경우
--서브쿼리가 사용된 위치에 따라 3가지로 분륜
--1. SELECT 절 : SCALAR SUBQUERY : 하나의 행, 하나의 컬럼만 리턴해야 에러가 발생하지 않음
--2. FROM 절 : INLINE - VIEW
--3. WHERER 절 : SUBQUERY QUERY

--서브쿼리 1번
SELECT COUNT(*)
FROM emp
WHERE sal >
     (SELECT AVG(sal)
      FROM emp);

--2번
SELECT *
FROM emp
WHERE sal >
     (SELECT AVG(sal)
      FROM emp);

--다중행 연산자
--IN : 서브쿼리의 여러행 중 일치하는 값이 존재할 때
--ANY -->활용도는 다소 떨어짐 : 서브쿼리의 여러행 중 한 행이라도 조건을 만족할 때 
--ALL -->활용도는 다소 떨어짐 : 서브쿼리의 여러행 중 모든 조건을 만족할 때

--3번
--서브쿼리의 결과가 여러 행일 때는 = 연산자를 사용할 수 없다
SELECT *
FROM emp
WHERE deptno IN
    (SELECT deptno
     FROM emp
     WHERE ename IN ('SMITH','WARD'));

--스미스와 워드 사원의 급여보다 급여가 작은 직원을 조회
--(스미스와 워드 급여 중 아무거나, 1250보다 작은 사원) 
SELECT *
FROM emp
WHERE sal < ANY
    (SELECT sal
     FROM emp
     WHERE ename IN ('SMITH','WARD'));

--급여가 두 사원급여 모두보다 높을 때
SELECT *
FROM emp
WHERE sal > ALL
    (SELECT sal
     FROM emp
     WHERE ename IN ('SMITH','WARD'));

--직원의 관리자 사번이 7902 이거나 null
--NULL비교는 = 연산자가 아니라 IS NULL로 비교 해야 하지만 IN 연산자는 = 로 계산한다
SELECT *
FROM emp
WHERE mgr = 7902 
OR mgr = null;

--NOT IN (7902, NULL) --> AND
SELECT *
FROM emp
WHERE empno <> 7902 
AND empno IS NOT NULL; 

--pairwise (순서쌍)
--순서쌍의 결과를 동시에 만족 시킬 때
SELECT * 
FROM emp
WHERE (mgr, deptno) IN 
                    (SELECT mgr, deptno
                     FROM emp
                     WHERE empno IN (7499, 7782));
--non-pairwise
--순서쌍을 동시에 만족시키지 않는 형태로 작성
SELECT * 
FROM emp
WHERE mgr IN 
            (SELECT mgr
             FROM emp
             WHERE empno IN (7499, 7782))
AND deptno IN 
            (SELECT deptno
             FROM emp
             WHERE empno IN (7499, 7782));
             
--스칼라 서브쿼리 : SELECT절에 기술, 1개의 ROW, 1개의 COL을 조회하는 쿼리
--스칼라 서브쿼리는 MAIN 쿼리의 컬럼을 사용하는게 가능하다

SELECT (SELECT SYSDATE
        FROM dual) , dept.*
FROM dept;
 
SELECT empno, ename, deptno,
        (SELECT dname 
         FROM dept 
         WHERE deptno = emp.deptno)      
FROM emp;

--INLINE VIEW : FROM절에 기술되는 서브쿼리
--MAIN 쿼리의 컬럼을 서브쿼리에서 사용하는지 유무에 따른 분류
--사용 할 경우 : correlated subquery(상호연관 쿼리), 서브쿼리만 단독으로 실행 불가
--             실행순서가 정해져 있다(main -> sub)  
--사용하지 않을 경우 : non-correlated subquery(비상호연관 서브쿼리), 서브쿼리만 단독으로 실행 가능
--                  실행순서가 정해져 있지 않다(main - > sub, sib -> main)

--모든 직원의 급여 평균보다 급여가 높은 사람을 조회
SELECT
    *
FROM emp
WHERE sal >  
        (SELECT AVG(sal)
         FROM emp);

--직원이 속한 부서의 급여 평균보다 급여가 높은 사람을 조회
SELECT
    *
FROM emp e
WHERE sal >  
        (SELECT AVG(sal)
         FROM emp m 
         WHERE m.deptno = e.deptno)
ORDER BY deptno;

--위의 문제를 조인을 이용
--1. 조인 테이블 선정(emp, 부서별 급여 평균(인라인뷰))
SELECT emp.ename, sal, emp.deptno, dept_sal.*
FROM emp, (SELECT deptno, ROUND(AVG(sal)) avg_sal 
           FROM  emp
           GROUP BY deptno) dept_sal
WHERE emp.deptno = dept_sal.deptno
AND emp.sal > dept_sal.avg_sal;

--데이터 추가
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');

--ROLLBACK; 
    --> 트랜잭션 취소
--COMMIT;
    --> 트랜잭션 확정

--4번
SELECT deptno, dname, loc 
FROM dept
WHERE deptno NOT IN (
                    SELECT deptno
                    FROM emp);
 
--5번
SELECT pid, pnm
FROM product
WHERE pid NOT IN (
                  SELECT cid
                  FROM cycle
                  WHERE cid = 1);
               