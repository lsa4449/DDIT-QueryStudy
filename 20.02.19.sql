SELECT ename, sal, aa.deptno, bb.sal_rank

FROM 
(SELECT rownum rn, ename, sal, deptno
FROM
(SELECT *
FROM emp
ORDER BY deptno, sal DESC))aa,

(SELECT rownum rn, deptno, cnt, sal_rank
FROM
(SELECT deptno, cnt, sal_rank
FROM
(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno)b,
(SELECT LEVEL sal_rank
FROM dual
CONNECT BY level <= 14)a
WHERE b.cnt >= a.sal_rank
ORDER BY b.deptno, a.sal_rank))bb
WHERE aa.rn = bb.rn;

--위의 쿼리를 분석함수를 사용해서 표현
SELECT ename, sal, deptno, 
        ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank
FROM emp;

--쿼리 실행 결과 11건
--페이징 처리(페이지당 10건의 게시글)
--1페이지 : 1~10
--2페이지 : 11~20
--바인드변수 : :page, :pageSize
SELECT *
FROM(
    SELECT ROWNUM rn, a.*
    FROM
        (SELECT seq, LPAD(' ', (LEVEL -1) * 4) || title "TITLE",
                DECODE(parent_seq, NULL, seq, parent_seq) root
        FROM board_test
        START WITH parent_seq IS NULL
        CONNECT BY PRIOR seq = parent_seq
        ORDER SIBLINGS BY root DESC, seq) a)
WHERE rn BETWEEN (:page -1) * :pageSize +1 AND :page * :pageSize;

--분석함수 문법
--분석함수명([인자]) OVER ([PARTITON BY 컬럼] [ORDER BY 컬럼] [WINDOWING])
--PARTITOIN BY 컬럼: 해당 컬럼이 같은 ROW끼리 하나의 그룹으로 묶는다
--ORDER BY 컬럼: PARTITON BY에 의해 묶은 그룹 내에서 ORDER BY 컬럼으로 정렬
--ROW_NUMNER() OVER (PARTITION BY deptno ORDER BY sla DESC) rank

--순위 관련 분석 함수
--RANK() : 같은 값을 가질 때 중복순위를 인정, 후순위는 중복값만큼 떨어진 값부터 시작
--          2등이 2명이면 3등은 없고 4등부터 후순위가 생성된다
--DENSE_RANK() : 같은 값을 가질때 중복 순위를 인정, 후순위는 중복순위 다음부터 시작
--               2등이 2명이더라도 후순위는 3등부터 시작
--ROW_NUMBER() : ROWNUM과 유사, 중복된 값을 허용하지 않는다

--부서별, 급여 순위를 3개의 랭킹 관련 함수를 적용
SELECT ename, sal, deptno,
        RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) SAL_rank,
        DENSE_RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) DENSE_RANK,
        ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal DESC) SAL_ROW_NUMBER
FROM emp;

--WINDOW함수 1번
SELECT empno, ename, sal, deptno,
        RANK() OVER(ORDER BY sal DESC ) SAL_rank,
        DENSE_RANK() OVER(ORDER BY sal DESC) DENSE_RANK,
        ROW_NUMBER() OVER(ORDER BY sal DESC) SAL_ROW_NUMBER
FROM emp;

--2번
SELECT e.empno, e.ename, e.deptno, cnt
FROM emp e,
    (SELECT deptno, count(*) cnt
     FROM emp
     GROUP BY deptno) a
WHERE e.deptno = a.deptno
ORDER BY deptno;

--통계관련 분석함수(GROUP 함수에서 제공하는 함수 종류와 동일)
--SUM(컬럼)
--COUNT(*), COUNT(컬럼)
--MIN(컬럼)
--MAX(컬럼)
--AVG(컬럼)

--2번 분석함수를 사용하여 작성
--부서별 직원 수 
SELECT empno, ename, deptno, COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

--ana2,3,4
SELECT empno, ename, deptno, 
        ROUND(AVG(sal) OVER (PARTITION BY deptno),2) avg_sal,
        MAX(sal) OVER (PARTITION BY deptno) max_sal,
        MIN(sal) OVER (PARTITION BY deptno) min_sal
FROM emp;

--급여를 내림차순 정렬하고 급여가 같을 때는 입사일자가 빠른 사람이 높은 우선순위가 되도록
--현재행의 다음행(LEAD)의 sal컬럼을 구하는 쿼리를 작성
SELECT empno, ename, hiredate, sal, 
        LEAD(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
FROM emp; 

--ana5
SELECT empno, ename, hiredate, sal, 
        LAG(sal) OVER (ORDER BY sal DESC, hiredate) lag_sal
FROM emp; 

--ana6
SELECT empno, ename, hiredate, job, sal, 
        LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) lag_sal
FROM emp; 

--no_ana3 =>분석함수 없이 쿼리
SELECT a.empno, a.ename, a.sal, SUM(b.sal) C_SUM
FROM 
    (SELECT a.*, rownum rn
     FROM 
        (SELECT *
         FROM emp
         ORDER BY sal, empno)a)a,
    (SELECT a.*, rownum rn
     FROM 
        (SELECT *
         FROM emp
         ORDER BY sal, empno)a)b
WHERE a.rn >= b.rn
GROUP BY a.empno, a.ename, a.sal, a.rn
ORDER BY a.rn, a.empno;

--분석함수를 이용하여 쿼리 작성
SELECT empno, ename, sal, 
        SUM(sal) OVER (ORDER BY sal, empno 
                       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) comm_sal
FROM emp;

--현재 행을 기준으로 이전 한행부터 이후 한행까지 총 3개 행의 sal 합계 구하기
SELECT empno, ename, sal, 
        SUM(sal) OVER (ORDER BY sal, empno 
                        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) c_sum
FROM emp;

--ana 7번
--ORDER BY기술 후 WINDOWING 절을 기술하지 않을 경우 WINDOWING이 기본값으로 적용된다
--ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
SELECT empno, ename, deptno, sal, 
        SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno) c_sum
FROM emp;

--RANGE : 논리적인 행의 단위, 같은 값을 가지는 컬럼까지 자신의 행으로 취급
--ROWS : 물리적인 행의 단위
SELECT empno, ename, deptno, sal, 
        SUM(sal) OVER (PARTITION BY deptno ORDER BY sal ROWS UNBOUNDED PRECEDING) row_,
        SUM(sal) OVER (PARTITION BY deptno ORDER BY sal RANGE UNBOUNDED PRECEDING) range_,
        SUM(sal) OVER (PARTITION BY deptno ORDER BY sal) default_       
FROM emp;