--제약조건 확인 방법
--1. tool
--2. 제약조건 : USER_CONSTRAINTS
--3. 제약조건 컬럼 : USER_CON_COLUMNS
--4. 제약조건이 몇개의 컬럼에 관련되어 있는지 알 수 없기 때문에 테이블을 별도로 분리하여 설계

SELECT * 
FROM USER_CONSTRAINTS
WHERE table_name IN ('EMP', 'DEPT', 'EMP_TEST', 'DEPT_TEST');

--EMP, DEPT, PK, FK 제약이 존재하지 않음
--테이블 수정으로 제약조건 추가
--1. EMP : PK(empno)
--2.     : FK(deptno) - dept.deptno
--3.       (FK 제약을 생성하기 위해서는 참조하는 테이블 컬럼에 인덱스가 존재해야 한다)

--1. DEPT : PK(deptno)
SELECT * 
FROM USER_CONSTRAINTS
WHERE table_name IN ('EMP', 'DEPT', 'EMP_TEST', 'DEPT_TEST');
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);
ALTER TABLE emp ADD CONSTRAINT pk_emp_dept FOREIGN KEY (deptno)
                    REFERENCES dept(deptno);

--테이블 컬럼 주석 : dictionary 확인가능
--테이블 주석 : USER_TAB_COMMENTS
--컬럼 주석 : USER_COL_COMMENTS

--주석 생성
--테이블 주석 : COMMENT ON TABLE 테이블명 IS '주석';
--컬럼 주석 : COMMENT ON COLUMN 테이블.컬럼 IS '주석';
--emp : 직원
--dept : 부서

COMMENT ON TABLE emp IS '직원';
COMMENT ON TABLE dept IS '부서';

SELECT
    *
FROM USER_TAB_COMMENTS
WHERE TABLE_NAME IN ('EMP', 'DEPT');


SELECT
    *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME IN ('EMP', 'DEPT');

--DEPT	DEPTNO : 부서번호
--DEPT	DNAME : 부서명
--DEPT	LOC : 부서위치
--EMP	EMPNO : 직원번호
--EMP	ENAME : 직원이름
--EMP	JOB : 담당업무
--EMP	MGR : 매니저 직원번호
--EMP	HIREDATE : 입사일자
--EMP	SAL : 급여
--EMP	COMM : 성과급
--EMP	DEPTNO : 소속부서번호

COMMENT ON COLUMN dept.deptno IS '부서번호';
COMMENT ON COLUMN dept.dname IS '부서명';
COMMENT ON COLUMN dept.loc IS '부서위치';

COMMENT ON COLUMN emp.empno IS '직원번호';
COMMENT ON COLUMN emp.ename IS '직원이름';
COMMENT ON COLUMN emp.job IS '담당업부';
COMMENT ON COLUMN emp.mgr IS '매니저 직원번호';
COMMENT ON COLUMN emp.hiredate IS '입사일자';
COMMENT ON COLUMN emp.sal IS '급여';
COMMENT ON COLUMN emp.comm IS '성과급';
COMMENT ON COLUMN emp.deptno IS '소속부서번호';

SELECT *
FROM USER_TAB_COMMENTS t, USER_COL_COMMENTS c
WHERE t.table_name = c.table_name
AND t.table_name IN ('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY');

--view : query
--테이블처럼 DBMS에 미리 작성한 객체
--  ->작성하지 않고 QUERY에서 바로 작성한 VIEW : 인라인뷰 -> 이름이 없기 때문에 재활용불가
--view는 테이블이 아니다.

--사용목적
--1. 보안 목적(특정 컬럼을 제외하고 나머지 결과만 개발자에 제공)
--2.인라인뷰를 뷰로 생성해서 재활용 -> 쿼리길이 단축

--생성방법
--CREATE [OR REPLACE] VIEW 뷰 명칭[ (column1, column2..)] AS 
--SUBQUERY
--emp 테이블에서 8개의 컬럼 중 sal, comm 컬럼을 제외한 6개 컬럼을 제공하는 v_emp VIEW생성
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

--시스템 계정에서 sua 계정으로 view 생성권한 추가
GRANT CREATE VIEW TO SUA;

--기존 인라인뷰로 작성시 
SELECT
    *
FROM (SELECT empno, ename, job, mgr, hiredate, deptno
      FROM emp);
      
--view 객체 활용
SELECT
    *
FROM v_emp;

--emp 테이블에는 부서명이 없음 => dept 테이블과 조인을 빈번하게 진행
--조인된 결과를 view로 생성 해놓으면 코드를 간결하게 작성하는것이 가능
--부서명, 직원번호, 직원이름, 담당업무, 입사일자
CREATE OR REPLACE VIEW v_emp_dept AS
SELECT d.dname, e.empno, e.ename, e.job, e.hiredate
FROM emp e , dept d
WHERE e.deptno = d.deptno;

--인라인뷰로 작성시
SELECT *
FROM (SELECT d.dname, e.empno, e.ename, e.job, e.hiredate
      FROM emp e , dept d
      WHERE e.deptno = d.deptno);

--view 작성시
SELECT
    *
FROM v_emp_dept;

--SMITH 직원 삭제 후 v_emp_dept view 건수 변화 확인
DELETE emp 
WHERE ename = 'SMITH';

--view는 물리적인 데이터를 갖지 않고, 논리적인 데이터의 정의 집합(SQL)이기 때문에
--view에서 참조하는 테이블의 데이터가 변경이 되면 view의 조회 결과도 영향을 받는다.

--SEQUENCE : 시퀀스 -> 중복되지 않는 정수값을 리턴해주는 오라클 객체
--CREATE SEQUENCE 시퀀스_이름
--[OPTION....];
--명명규칙 : SEQ_테이블명
--emp 테이블에서 사용한 시퀀스 생성
CREATE SEQUENCE seq_emp;

--시퀀스 제공 함수
--NEXTVAL : 시퀀스에서 다음 값을 가져올 때 사용
--CURRVAL : NEXTVAL를 사용하고나서 현재 읽어 들인 값을 재확인
SELECT seq_emp.NEXTVAL, seq_emp.CURRVAL
FROM DUAL;

INSERT INTO emp_test VALUES (SEQ_EMP.NEXTVAL, 'james', 99, '017');

--시퀀스 주의점
--rollback을 하더라도 nextval를 통해 얻은 값이 원복되진 않는다.
--nextval를 통해 값을 받아오면 그 값을 다시 사용할 수 없다.

--index
SELECT ROWID, emp.*
FROM emp;

SELECT  *
FROM emp
WHERE ROWID ='AAAE5dAAFAAAACLAAA';

--인덱스가 없을 때 empno 값으로 조회 하는 경우
--emp 테이블에서 pk_emp제약조건을 삭제하여 empno 컬럼으로 인덱스가 존재하지 않는 환경을 조성
alter table emp drop CONSTRAINT pk_emp;

EXPLAIN PLAN FOR
SELECT
    *
FROM emp
WHERE empno = 7782;

SELECT
    *
FROM TABLE(dbms_xplan.display);

--emp테이블의 empno 컬럼으로 pk 제약을 생성하고 동일한 sql을 실행
--pk : unique + not null
--      (unique 인덱스를 생성해준다)
-->empno 컬럼으로 unique 인덱스가 생성됨

--인덱스로 sql을 실행하게 되면 인덱스가 없을때와 어떻게 다른지 차이점을 확인

alter table emp add constraint pk_emp primary key (empno);

select empno, rowid
from emp
order by empno;

select * from emp
where empno = 7782;

--select 조회 컬럼이 테이블 접근에 미치는 영향
select empno from emp where empno = 7782;

explain plan for
select empno
from emp
where empno = 7782;

SELECT
    *
FROM table(dbms_xplan.display);

--유니크와 논유니크 인덱스의 차이 확인
--1. pk_emp삭제
--2. empno컬럼으로 non-unique 인덱스 생성
--3. 실행계획 확인

ALTER TABLE emp DROP CONSTRAINT pk_emp;
create index idx_n_emp_01 on emp (empno);

explain plan for
SELECT
    *
FROM emp
where empno = 7782;

SELECT
    *
FROM table(dbms_xplan.display);

--emp 테이블에 job 컬럼을 기준으로 하는 새로운 non-unique 인덱스를 생성
create index idx_n_emp_02 on emp (job);

select job, rowid
from emp
order by job;

--선택 가능한 사항
--1. emp 테이블을 전체 읽기
--2. idx_n_emp_01(empno) 인덱스 활용
--3. idx_n_emp_02(job) 인덱스 활용

explain plan for
SELECT
    *
FROM emp 
WHERE job = 'MANAGER';
