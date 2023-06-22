-- ★ 트리거 ★

-- 트리거(trigger)는 데이터베이스 시스템에서 
-- 데이터의 `입력, 갱신, 삭제() 등의 이벤트`가 발생할때마다 '자동적으로 수행되는' [사용자 정의 프로시저]이다.
-- 특정 테이블에 속해있는 객체
/*

	CREATE OR REPLACE TRIGGER 트리거이름
	BEFORE | AFTER                  -- 동작 시점
	INSERT | UPDATE | DELETE ON 테이블명        -- 테이블과 해당 C,R,D 지정
	[FOR EACH ROW]      -- 행 트리거. 테이블 행 단위 변화에 대해 동작하기.
	[WHEN(조건)]      -- 특정컬럼에 대한 값 조건
	DECLARE    -- 변수선언
	...
	BEGIN
	...
	[EXCEPTION]  -- 예외사항
	END; 

 */

-- 트리거의 장점 : 원하는 작업을 자동으로 실행해줌.
	-- 데이터베이스 테이블 관리를 위한 목적.

-- 트리거 만들기
CREATE OR REPLACE TRIGGER cancle_buy
AFTER DELETE ON p_buy	-- p_buy 테이블 대상으로 DELETE 실행한 후에 동작한다.
FOR EACH ROW	-- 적용하는 행이 여러개일때, 각 행에 대해 실행함
				-- :OLD UPDATE 또는 DELETE 하기 전 값, :NEW 는 INSERT 한 값
BEGIN
	-- 구매 취소(p_buy 테이블에서 삭제)한 데이터 tri_temp 임시 테이블에 insert : 여러행에 대한 작업(행 트리거)
	INSERT INTO tri_temp
	values(:OLD.buy_seq, :OLD.customid,:OLD.pcode , :OLD.quantity, :OLD.buy_date, :OLD.money);
END;

-- 임시 테이블 tri_temp 만들기
CREATE TABLE tri_temp
as
SELECT * FROM P_BUY
WHERE buy_seq = 0;	-- WHERE buy_seq = 0 ▶ 컬럼만 복사할때(데이터는 가져오지 않을때) 사용
-- 확인
SELECT * FROM tri_temp;
SELECT * FROM P_BUY;

-- 트리거 동작시키기
DELETE FROM P_BUY WHERE customid = 'AAA';



-- 테이블 관리를 위한 트리거 : 예시로 UPDATE 와 DELETE 명령을 할 수 없는 시간을 정함.
CREATE OR REPLACE TRIGGER secure_custom
BEFORE UPDATE OR DELETE ON tbl_custom	-- 트리거 동작하는 테이블,SQL과 시점
BEGIN
	IF TO_CHAR(SYSDATE , 'hh24:mi') BETWEEN '12:00' AND '16:00' THEN
		raise_application_error(-20000,'지금 오후 12시 ~ 16시는 작업할 수 없습니다.');
		-- ORA-20000: 지금 오후 12시 ~ 16시는 작업할 수 없습니다. ▶ 오류 메세지 이렇게 나옴.
	END IF;
END;
-- 트리거 동작 테스트
DELETE FROM TBL_CUSTOM WHERE customer_id = 'momo';

-- momo 추가용
INSERT INTO TBL_CUSTOM (customer_id,name) VALUES ('momo','모모');
SELECT * FROM TBL_CUSTOM tc ;



-- 내일 수업할 내용 혼자 해보기
	-- 아이디, 물품코드, 수량 INSERT 하면 총 가격까지 추가해서 출력하게 트리거 만들기
/*
	한 아이디당 총 구매금액

customID varchar(20);
total number(7);

ex) 	AAA 1500
	AAA 2500
	AAA 3000 ▶ AAA 7000
*/
SELECT * FROM p_buy;

-- 결과가 아래와 같이 나오도록 하는 트리거 생성
SELECT customid, SUM(money) AS total 
FROM P_BUY
GROUP BY customid
HAVING sum(money) IS NOT NULL;

-- 
CREATE TABLE sum_total(
	customID varchar(20),
	total number(7)
);

SELECT * FROM SUM_TOTAL;


CREATE OR REPLACE TRIGGER sum_total
AFTER INSERT ON P_BUY
FOR EACH ROW
BEGIN
    -- customID별 money 값의 총합
    UPDATE sum_total
    SET total = (SELECT SUM(money) FROM P_BUY GROUP BY customid)
    WHERE customID = :NEW.customID;

    -- customID가 sum_total 테이블에 없을 경우
    IF (SQL%ROWCOUNT = 0) THEN
        INSERT INTO sum_total
        VALUES (:NEW.customID, (SELECT SUM(money) FROM P_BUY GROUP BY customid));
    END IF;
END;

CREATE OR REPLACE TRIGGER sum_total
AFTER INSERT ON P_BUY
FOR EACH ROW
DECLARE
    v_total NUMBER;
    v_count NUMBER;
BEGIN
    -- customID에 대한 합계를 조회
    SELECT SUM(money)
    	INTO v_total
    FROM P_BUY
    WHERE customid = :NEW.customid;

    -- customID가 sum_total 테이블에 이미 존재하는지 확인
    SELECT COUNT(*)
    	INTO v_count
    FROM sum_total
    WHERE customid = :NEW.customid;

    -- customID가 sum_total 테이블에 이미 존재하면 업데이트, 없으면 추가
    IF v_count > 0 THEN
        UPDATE sum_total SET total = v_total
        WHERE customID = :NEW.customID;
    ELSE
        INSERT INTO sum_total (customID, total) VALUES (:NEW.customID, v_total);
    END IF;
END;

