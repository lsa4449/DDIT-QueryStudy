--매니저가 존재하는 직원을 조회(KING을 제외한 13명의 데이터가 조회)
SELECT ename, mgr
FROM emp
WHERE mgr is not null;

--EXISTS 조건에 만족하는 행이 존재 하는지 확인하는 연산자
--다른 연산자와 다르게 WHERE절에 컬럼을 기술하지 않는다
-- .WHRER empno = 7369
-- .WHERE EXISTS (SELECT 'X'
--                FROM......);

--위의 컬럼 EXISTS로 조회
--서브쿼리 8번
SELECT ename, mgr
FROM emp e
WHERE EXISTS (SELECT 'X'
              FROM emp m
              WHERE e.mgr = m.empno);

--9번
SELECT pid, pnm
FROM product p
WHERE EXISTS (SELECT 'X'
              FROM cycle c
              WHERE c.pid = p.pid
              AND c.cid = 1);
              
--10번
SELECT pid, pnm
FROM product p
WHERE NOT EXISTS (SELECT 'X'
                  FROM cycle c
                  WHERE c.pid = p.pid
                  AND c.cid = 1);
  
--집합연산
--합집합 : UNION -> 중복제거(집합개념) / UNION ALL -> 중복을 제거하지 않음(속도 향상)
--교집합 : INTERSECT(집합개념)
--차집합 : MINUS(집합개념)
--집합연산의 공통사항
--두 집합의 컬럼의 개수. 타입이 일치 해야 한다

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)

UNION

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

--UNION ALL : UNION과 다르게 중복 허용
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

--INTERSECT(교집합) : 위, 아래 집합에서 값이 같은 행만 조회
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

--MINUS(차집합) : 위, 아래 집합에서 아래 집합의 데이터를 제거한 나머지 집합
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

--집합의 기술 순서가 영향이 가는 집합연산자
-- A UNION B = B UNION A --> 값이 같음
-- A UNION ALL B = B UNION ALL A --> 값이 같음(집합)
-- A INTERSECT B = B INTERSECT A --> 값이 같음
-- A MINUS B = B MINUS A --> 값이 다름

--집합연산의 결과 컬럼 이름은 첫 번째 집합의 컬럼명을 따른다
SELECT 'X', 'B'
FROM dual

UNION

SELECT 'Y', 'A'
FROM dual;

--정렬(ORDER BY)는 집합연산 가장 마지막 집합 다음에 기술
SELECT deptno, dname, loc 
FROM dept
WHERE deptno IN (10, 20)
--ORDER bY 절은 마지막에! --> 인라인 뷰로 감싸면 가능
UNION

SELECT *
FROM dept
WHERE deptno IN (30, 40)
ORDER BY deptno;