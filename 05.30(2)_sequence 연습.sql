-- 오라클은 시퀀스라는 객체를 사용하여 자동증가되는 값을 만듭니다.
	-- 예시) 05.30_지난주 복습 문제.sql 중
-- INSERT INTO TBL_BUY VALUES (1, ~~~);
-- INSERT INTO TBL_BUY VALUES (2, ~~~);
-- INSERT INTO TBL_BUY VALUES (3, ~~~);
-- INSERT INTO TBL_BUY VALUES (4, ~~~);
-- INSERT INTO TBL_BUY VALUES (5, ~~~);
-- INSERT INTO TBL_BUY VALUES (6, ~~~);
-- INSERT INTO TBL_BUY VALUES (7, ~~~);

-- sequence : 행을 식별할 목적으로 일련번호 컬럼을 만들었을때, 값은 시퀀스로 부여하기
-- MYSQL DBMS 에서는 auto increment (자동 증가) 속성을 설정할 수 있습니다.

-- 오라클에서 dual 이름의 임시(더미) 테이블 1개 행, 1개 컬럼으로 특정 수식이나 함수 값 결과 테스트 목적.
-- ex)
SELECT 199+1
FROM dual;

-- 시퀀스 생성하기 (시퀀스 이름은 식별자로 개발자 정하기)
CREATE SEQUENCE test_seq;

-- 시퀀스 삭제하기
DROP SEQUENCE test_seq;

-- 시퀀스 함수 : nextval(다음 시퀀스 값), currval(현재 시퀀스 값)	>> val 은 value 를 뜻함
SELECT test_seq.nextval
FROM dual;				-- test_seq 이름의 시퀀스가 갖는 다음 값 조회

SELECT test_seq.currval
FROM DUAL;				-- 단, 처음 1번은 먼저 nextval을 꼭 실행해야 currval 값을 조회합니다.

-- 1) TBL_BUY 에 사용될 시퀀스를 새로 만듭시다.
CREATE SEQUENCE TBLBUY_SEQ
	START WITH 1001;		-- START WITH 로 시작값 지정

-- 2) TBL_BUY 의 데이터 모두 제거하기
	TRUNCATE TABLE TBL_BUY;
	
-- 3) 7개의 INSERT 를 시퀀스로 하기	
	INSERT INTO TBL_BUY VALUES (TBLBUY_SEQ.NEXTVAL, 'mina012' , 'CJBAb12g' , 5 , TO_DATE('2022-03-10 14:33:15','YYYY-MM-DD HH24:MI:SS'));
	INSERT INTO TBL_BUY VALUES (TBLBUY_SEQ.NEXTVAL, 'mina012' , 'APLE5kg' , 2 , TO_DATE('2022-03-10 14:33:15','YYYY-MM-DD HH24:MI:SS'));
	INSERT INTO TBL_BUY VALUES (TBLBUY_SEQ.NEXTVAL, 'mina012' , 'JINRMn5' , 2 , TO_DATE('2022-03-16 10:13:15','YYYY-MM-DD HH24:MI:SS'));
	INSERT INTO TBL_BUY VALUES (TBLBUY_SEQ.NEXTVAL, 'twice' , 'JINRMn5' , 3 , TO_DATE('2021-12-25 19:32:15','YYYY-MM-DD HH24:MI:SS'));
	INSERT INTO TBL_BUY VALUES (TBLBUY_SEQ.NEXTVAL, 'twice' , 'MANGOTK4r' , 2 , TO_DATE('2021-12-25 19:32:15','YYYY-MM-DD HH24:MI:SS'));
	INSERT INTO TBL_BUY VALUES (TBLBUY_SEQ.NEXTVAL, 'hongGD' , 'DOWON123a' , 1 , TO_DATE('2021-10-21 11:13:25','YYYY-MM-DD HH24:MI:SS'));
	INSERT INTO TBL_BUY VALUES (TBLBUY_SEQ.NEXTVAL, 'hongGD' , 'APLE5kg' , 1 , TO_DATE('2021-10-21 11:13:25','YYYY-MM-DD HH24:MI:SS'));
	
SELECT *
FROM TBL_BUY;
