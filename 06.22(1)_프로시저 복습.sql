-- 자주 사용하는 테이블 따로 만들어놓기
CREATE TABLE p_buy
AS
SELECT * FROM TBL_BUY tb
ORDER BY customid;

SELECT * FROM p_buy;

-- 웹 애플리케이션(인터넷 환경) 개발 할 때,
	-- (JDBC에서)사용자가 원하는 기능(DAO) 요청 하나에 sql을 1개씩만 실행을 합니다.
-- 프로시저를 이용하면, 요청 한번에 대해 많은 SQL을 실행할 수 있습니다.

-- 데이터베이스 관점에서는 '무결성'(정확성)을 유지할 수 있는 방법.



-- 실행을 위해서 시퀀스 생성, money 컬럼 추가
create sequence pbuy_seq start with 1008;

ALTER TABLE P_BUY ADD money NUMBER;

-- 프로시저에서 트랜잭션을 관리하는 예시
CREATE OR REPLACE PROCEDURE proc_set_money(
	acustomid IN varchar2,	-- 회원ID	-- 입력 매개변수 IN
	apcode IN varchar2,		-- 상품 코드
	acnt IN NUMBER,			-- 수량
	isSuccess OUT varchar2	-- 출력 매개변수 OUT. 트랜잭션 처리 성공여부 저장
)
IS 
	vseq NUMBER;	-- 변수 선언
	vprice NUMBER;
BEGIN
	INSERT INTO P_BUY(buy_seq,customid,pcode,quantity,buy_date)
		VALUES (pbuy_seq.nextval, acustomid,apcode,acnt,sysdate);	-- 매개변수값으로 추가
		
	SELECT pbuy_seq.currval	-- 현재 시퀀스 값 조회
		INTO vseq
	FROM dual;
	
	SELECT price
		INTO vprice
	FROM TBL_PRODUCT tp
	WHERE pcode=apcode;	-- 상품 코드에 대한 가격 조회
	
	UPDATE P_BUY
	SET money = vprice * quantity
	WHERE buy_seq = vseq;	-- 위 INSERT 한 데이터로 가격 * 수량 수식 구해서 money 컬럼에 입력

	dbms_output.put_line('실행 성공');
	isSuccess := 'success';		-- ★ 프로시저에서 일반 변수 대입문 기호 [ := ] ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
	COMMIT;
	EXCEPTION	-- EXCEPTION 추가하여 처리 ▶ 메시지 출력, ROLLBACK
		WHEN OTHERS THEN 
		dbms_output.put_line('실행 실패');
		ROLLBACK;	-- 오류가 발생한 SQL 앞의 INSERT,UPDATE,DELETE 를 취소
		isSuccess := 'fail';
END;


-- [시퀀스값을 되돌릴 수 있는 방법은 없음]
-- fail 일 경우 시퀀스값은 그대로 지나가고, 그게 싫다면 다음 두가지 방법을 사용할 수 있음
-- 1. exception 발생시 시퀀스 삭제 및 vseq-1값으로 재생성
-- 2. 시퀀스 대신 max(buy_seq)+1 사용

-- 롤백 시나리오 만들기
ALTER TABLE P_BUY DROP (money);
-- money 에 10000 미만의 값이 들어가면 오류 발생 ▶ 롤백
ALTER TABLE P_BUY ADD money NUMBER(7) CHECK (money >= 10000);

SELECT * FROM P_BUY pb;

-- 실행 예시
DECLARE
	vresult varchar2(20);
BEGIN
-- 메시지는 'fail' 이고 p_buy 테이블 INSERT 도 입력값 없어야 함.
-- 10000원이 넘으므로 'success'	
	proc_set_money('AA','JINRMn5',10,vresult);
	dbms_output.put_line('결과 : '||vresult);
END;

DECLARE
    vresult varchar2(20);
BEGIN
    proc_set_money('twice', 'JINRMn5', 8, vresult);
    dbms_output.put_line('결과 : '||vresult);
END;
/*
트리거 내부에서 P_BUY 테이블의 데이터를 참조할 때,
정확한 컬럼 이름과 조건을 사용하고 있는지 확인하세요.
customID 컬럼의 대소문자 구분과 조건절에 사용된
:NEW.customID를 정확히 일치시켜야 합니다.
*/
SELECT * FROM P_BUY pb;
DROP TRIGGER sum_total;

SELECT * FROM USER_ERRORS WHERE TYPE = 'TRIGGER' AND NAME = 'SUM_TOTAL';
