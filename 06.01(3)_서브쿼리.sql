
-- 서브쿼리 연습
SELECT * FROM TBL_PRODUCT tp ;
SELECT * FROM TBL_BUY tb ;


-- 1. 다중 행 서브쿼리
SELECT PNAME
FROM TBL_PRODUCT tp
WHERE /*
	PCODE = ( 오류 : 등호(=) 연산은 서브쿼리 SELECT 결과가 1행이어야 함 (조회 컬럼도 1개)
			SELECT PCODE
			FROM TBL_BUY tb 
			WHERE CUSTOMID = 'twice'
			*/
	PCODE IN (
			SELECT PCODE
			FROM TBL_BUY tb 
			WHERE CUSTOMID = 'twice'
			)
;

-- 2. 단일 행 서브쿼리
SELECT PNAME
FROM TBL_PRODUCT tp
WHERE PCODE = (
			SELECT PCODE
			FROM TBL_BUY tb
			WHERE BUY_SEQ = 1	-- 기본키 컬럼의 조건식이므로 0 또는 1개 행
			)
;

-- 서브쿼리 문제점 : 외부 쿼리가 조건식을 모든 행에 대해 검사할때 마다 내부 쿼리가 실행되므로 테이블의 행 개수가 많으면 처리 속도에 문제가 생깁니다.
	-- ▶ 테이블의 조인 연산으로 대체할 수 있으면 서브쿼리는 지양.

-- CREATE TABLE 에 SELECT 결과를 넣기
	-- 여기에서 AS 는 별칭이 아니라 '~~로써' 로 사용됨
CREATE TABLE BUY_TEMP	-- TBL_BUY 의 SELECT 조회된 테이블 구조를 그대로 가져와 새로운 테이블 생성
AS
SELECT *	-- 만들어진 테이블의 SELECT 조회 결과 추가
FROM TBL_BUY tb
WHERE CUSTOMID = 'twice';

-- INSERT 할 때 VALUES() 대신 SELECT를 사용할 수도 있음
INSERT INTO BUY_TEMP bt
SELECT *
FROM TBL_BUY tb 
WHERE QUANTITY >=3;



-- 시퀀스 대신에 사용할 수 있는 MAX 함수의 서브쿼리 예시
INSERT INTO TBL_BUY tb VALUES (TBLBUY_SEQ.NEXTVAL,'hongGD','CJBAb12g',3,SYSDATE);
INSERT INTO TBL_BUY tb VALUES ((SELECT MAX(BUY_SEQ)+1 FROM TBL_BUY tb) ,'hongGD','CJBAb12g',3,SYSDATE);	-- 괄호 주의
SELECT MAX(BUY_SEQ) FROM TBL_BUY tb;

-- 참고 : 집계 함수
SELECT COUNT(*) FROM TBL_BUY tb ;
SELECT SUM(QUANTITY) FROM TBL_BUY tb ;
SELECT AVG(QUANTITY) FROM TBL_BUY tb ;
SELECT MAX(QUANTITY) FROM TBL_BUY tb ;
SELECT MIN(QUANTITY) FROM TBL_BUY tb ;



