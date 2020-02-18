--상향식 계층쿼리 (leaf ==> root node(상위 node))
--전체 노드를 방문하는게 아니라 자신의 부모노드만 방문(하향식과 다른점)
--시작점 : 디자인팀
--연결 : 상위부서
SELECT *
from dept_h;

--3번
select deptcd, lpad(' ' , (level -1) * 4) ||deptnm, p_deptcd
from dept_h
start with deptnm = '디자인팀'
connect by prior p_deptcd = deptcd;

--4번
create table h_sum as
select '0' s_id, null ps_id, null value from dual union all
select '01' s_id, '0' ps_id, null value from dual union all
select '012' s_id, '01' ps_id, null value from dual union all
select '0123' s_id, '012' ps_id, 10 value from dual union all
select '0124' s_id, '012' ps_id, 10 value from dual union all
select '015' s_id, '01' ps_id, null value from dual union all
select '0156' s_id, '015' ps_id, 20 value from dual union all

select '017' s_id, '01' ps_id, 50 value from dual union all
select '018' s_id, '01' ps_id, null value from dual union all
select '0189' s_id, '018' ps_id, 10 value from dual union all
select '11' s_id, '0' ps_id, 27 value from dual;

SELECT
    *
FROM H_SUM;

SELECT LPAD(' ', (LEVEL - 1) * 4) || s_id "S_ID", value
FROM h_sum
start with s_id = 0
connect by prior s_id = ps_id;

--5번
create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XX회사', null, 1);
insert into no_emp values('정보시스템부', 'XX회사', 2);
insert into no_emp values('개발1팀', '정보시스템부', 5);
insert into no_emp values('개발2팀', '정보시스템부', 10);
insert into no_emp values('정보기획부', 'XX회사', 3);
insert into no_emp values('기획팀', '정보기획부', 7);
insert into no_emp values('기획파트', '기획팀', 4);
insert into no_emp values('디자인부', 'XX회사', 1);
insert into no_emp values('디자인팀', '디자인부', 7);

commit;

SELECT * 
FROM no_emp;

SELECT LPAD(' ', (LEVEL -1) * 4 ) || org_cd "ORG_CD", no_emp
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;

--계층형 쿼리의 행 제한 조건기술 위치에 따른 결과 비교(pruning branch - 가지치기)
--from ==> start with, connect by => where
--1. where : 계층 연결을 하고 나서 행을 제한
--2. connect by : 계층 연결을 하는 과정에서 행을 제한

--WHERE절 기술 전 : 총 9개의 행 조회
--WHERE절 : (org_cd != '정보기획부') => 정보기획부를 제외한 8개의 행 조회
SELECT LPAD(' ', (LEVEL -1) * 4 ) || org_cd "ORG_CD", no_emp
FROM no_emp
WHERE org_cd != '정보기획부'
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;

--CONNECT BY 절에 조건을 기술 => 정보기획부와 밑의 노드들도 제외한 6개의 행 조회
SELECT LPAD(' ', (LEVEL -1) * 4 ) || org_cd "ORG_CD", no_emp
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd AND org_cd != '정보기획부';

--CONNECT_BY_ROOT(컬럼): 해당 컬럼의 최상위 행의 값을 조회
--SYS_CONNECT__BY_PATH(컬럼, 구분자) : 해당 행의 컬럼이 거쳐온 컬럼 값을 추전, 구분자로 이어준다
--CONNECT_BY_ISLEAF : 해당 행이 LEAF 노드인지(연결된 자식이 없는지) 값을 리턴 (1:LEAF, 0:NO LEAF)
SELECT LPAD(' ', (LEVEL -1) * 4 ) || org_cd "ORG_CD", no_emp,
       CONNECT_BY_ROOT(org_cd) root,
       LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'), '-') path,
       CONNECT_BY_ISLEAF leaf
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;

--6번
create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, '첫번째 글입니다');
insert into board_test values (2, null, '두번째 글입니다');
insert into board_test values (3, 2, '세번째 글은 두번째 글의 답글입니다');
insert into board_test values (4, null, '네번째 글입니다');
insert into board_test values (5, 4, '다섯번째 글은 네번째 글의 답글입니다');
insert into board_test values (6, 5, '여섯번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (7, 6, '일곱번째 글은 여섯번째 글의 답글입니다');
insert into board_test values (8, 5, '여덜번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (9, 1, '아홉번째 글은 첫번째 글의 답글입니다');
insert into board_test values (10, 4, '열번째 글은 네번째 글의 답글입니다');
insert into board_test values (11, 10, '열한번째 글은 열번째 글의 답글입니다');
commit;

SELECT
    *
FROM board_test;

SELECT seq, LPAD(' ', (LEVEL -1) * 4) || title "TITLE"
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq;

--7번, 8번
SELECT seq, LPAD(' ', (LEVEL -1) * 4) || title "TITLE"
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC;

--9번
--글 : DESC / 댓글 : ASC
SELECT gn, seq, LPAD(' ', (LEVEL -1) * 4) || title "TITLE"
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC, seq;

--그룹번호 저장할 컬럼을 추가
alter table board_test add(gn NUMBER);

update board_test 
set gn = 1
WHERE seq IN(1, 9);

--컬럼 미추가
SELECT seq, LPAD(' ', (LEVEL -1) * 4) || title "TITLE",
        DECODE(parent_seq, NULL, seq, parent_seq) root
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY root DESC, seq;

SELECT
    *
FROM emp
WHERE sal = (SELECT MAX(sal)
             FROM emp);
             
SELECT ename, sal, deptno,
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC ) as sal_rank
FROM emp
GROUP BY ename, sal, deptno
ORDER BY deptno; 

SELECT ename, sal, deptno, count(sal) sal_rank
FROM emp
WHERE sal IN (select MAX(sal) from emp GROUP BY deptno)
GROUP BY deptno, sal, ename
ORDER BY deptno;

select sal_rank
from (select ename, sal, deptno, rownum
      from emp
      WHERE deptno = 10
      GROUP BY ename, sal, deptno, rownum
      ORDER BY deptno, rownum);