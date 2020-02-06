--empno 컬럼은 not null제약 조건이 있다. -insert시 반드시 값이 존재해야 정상적으로 입력된다
--empno 컬럼을 제외한 나머지 컬럼은 nullable이다 (null값이 저장될 수 있다)
INSERT INTO emp(empno, ename, job) 
VALUES(9999, 'brown', NULL);

INSERT INTO emp(ename, job)
VALUES ('sally', 'SALESMAN');

--문자열 : '문자열' 
--숫자 : 10 
--날짜 : to_date('200206','yymmdd')

--emp 테이블이 hiredate 컬럼은 date타입
--emp 테이블의 8개의 컬럼에 값을 입력

desc emp;

INSERT INTO emp 
VALUES(9998, 'sally', 'SALESMAN', NULL, SYSDATE, 1000, NULL, 99);
rollback;

SELECT
    *
FROM emp;

--여러건의 데이터를 한번에 INSERT
-- INSERT INTO 테이블명 (컬럼명1, 컬럼명2...)
-- SELECT ...
-- FROM

INSERT INTO emp
SELECT 9998, 'sally', 'SALESMAN', NULL, SYSDATE, 1000, NULL, 99
FROM dual
    UNION ALL
SELECT 9999, 'brown', 'CLERK', NULL, SYSDATE -1, 1100, NULL, 99
FROM dual;

--UPDATA쿼리
--UPDATE 테이블명 SET 컬럼명1 = 갱신할 컬럼 값1, ...
--WHERE 행 제한 조건
--업데이트 쿼리 작성시 WHERE 절이 존재하지 않으면 해당 테이블의 모든 행을 대상으로 업데이트가 일어난다
--UPDATE, DELETE 절에 WHERE 절이 없으면 의도한게 맞는지 다시한번 확인
--WHERE절이 있다고 하더라도 해당 조건으로 해당 테이블을 SELECT 하는 쿼리를 작성하여
--실행하면 UPDATE대상 행을 조회할 수 있으므로 확인하고 실행하는것도 사고 발생방지에 도움!

--99번 부서번호를 갖는 부서 정보가 DEPT 테이블에 있는 상황
INSERT INTO dept VALUES (99,'ddit','daejeon');

--99번 부서번호를 갖는 부서의 dname 컬럼의 값을 '대덕it', loc 컬럼의 값을 '영민빌딩'으로 업데이트
UPDATE dept SET dname = '대덕it', loc = '영민빌딩'
WHERE detpno = 99;
 
--10 --> 서브쿼리
--스미스와 워드가 속한 부서에 소속된 직원 정보
SELECT
    *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN('SMITH','WARD'));
--update시에도 서브쿼리 사용이 가능
INSERT INTO emp(empno, ename) VALUES (9999,'brown');
--9999번 사원 부서번호랑 직업 정보를 스미스 사원과 동일하게 업데이트
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

--delete : 특정 행을 삭제
--DELETE [FROM] 테이블명 WHERE 행 제한 조건;
DELETE dept 
WHERE deptno = 99;

--서브쿼리를 통해서 특정 행을 제한하는 조건을 갖는 DELETE
--매니저가 7698 사번인 직원을 삭제
DELETE emp
WHERE empno IN (SELECT empno
                FROM emp
                WHERE mgr = 7698);