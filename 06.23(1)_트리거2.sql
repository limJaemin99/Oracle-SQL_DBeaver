-- 트리거에서 오류가 발생하는 대표적인 경우 : 트리거 대상 테이블과 동일한 테이블에 대한 DML 실행
-- 트리거가 동작하는 동안에는 디비버 UI 테이블 데이터 수정/삭제시 오류가 발생한다.
			-- ALTER TRIGGER sale_info disable;

-- ★★★★★★★★★★★★★★★★★★★★★★★
-- INSERT ▶ :NEW
-- DELETE ▶ :OLD
-- UPDATE ▶ :NEW , :OLD
-- ★★★★★★★★★★★★★★★★★★★★★★★

ALTER TRIGGER ICLASS.SALE_INFO_TRIG ENABLE;
ALTER TRIGGER ICLASS.SALE_INFO_TRIG DISABLE;

-- 아래 데이터 입력(INSERT)에 동작하는 트리거
INSERT INTO P_BUY VALUES (2000, 'mina012', 'CJBAb12g', 13, sysdate, null);

SELECT * FROM tbl_sale;
SELECT * FROM P_BUY;

-- 집계 테이블 : 고객별 총 구매금액 저장
-- 내가 작성한거 뭔가 오류가 있음 ▶ 아래 선생님이 작성한걸로 실행 ▶ 오류 수정 완료OR REPLACE TRIGGER sale_info_trig
AFTER INSERT ON p_buy
FOR EACH ROW
DECLARE 
	vtotal NUMBER(7) := 0;	-- 일반 변수 초기화
	vcnt NUMBER(7) := 0;
	vprice number(7);
BEGIN
	SELECT count(*)	
		INTO vcnt	-- 0 또는 1 (customid 가 PK 이기 때문에)
		FROM tbl_sale 
		WHERE customid = :NEW.customid;
	dbms_output.put_line('*' || :NEW.customid || ' ' || vtotal || ' ' || vcnt);
	UPDATE P_BUY SET money = vprice * :NEW.quantity
		WHERE buy_seq = :NEW.buy_seq;
	
	SELECT sum(money)
		INTO vtotal	-- 지정된 고객에 대한 money 총합계
		FROM P_BUY	-- 트리거 걸려있는 테이블 대상으로 DML은 오류★
		WHERE customid = :NEW.customid;
	
	SELECT price
		INTO vprice
		from tbl_product
		WHERE pcode = :NEW.pcode;
		
	IF vcnt = 0 THEN
		 INSERT  INTO  tbl_sale VALUES  (:NEW.customid, vtotal);
	ELSE
		UPDATE tbl_sale SET total = vtotal WHERE customid = :NEW.customid;
	END IF;
	EXCEPTION	 -- EXCEPTION 추가하여 처리 -> 메시지 출력, ROLLBACK
		WHEN no_data_found THEN
			dbms_output.put_line('no_data_found');
		WHEN OTHERS THEN
			dbms_output.put_line('실행 실패 -------------------');
END;*/


CREATE TABLE tbl_sale(
	customid varchar2(20) PRIMARY KEY,
	total NUMBER(7)
);

DROP TABLE TBL_SALE ;


-- 선생님이 작성한거
CREATE  OR  REPLACE  TRIGGER  sale_info_trig
AFTER  INSERT  ON  p_buy
FOR  EACH  ROW 
DECLARE 
    vtotal number(7):=0;      -- 일반 변수 초기화 
    vcnt number(7):=0;
    vprice number(7);
BEGIN 
    SELECT  count(*)       -- 0 또는 1
       INTO  vcnt
       FROM   tbl_sale WHERE  customid=:NEW.customid;
   dbms_output.put_line('*' || :NEW.customid || ' ' || vtotal || ' ' || vcnt);
    SELECT  sum(money)
       INTO  vtotal      -- 지정된 고객에 대한 money 총합계
       FROM  p_buy
       WHERE  customid = :NEW.customid;
    SELECT price 
       INTO vprice
       from tbl_product 
       WHERE pcode = :NEW.pcode;
    UPDATE p_buy SET money = vprice * :NEW.QUANTITY 
      WHERE BUY_SEQ = :NEW.buy_seq;
    IF vcnt=0 THEN  
        INSERT  INTO  tbl_sale VALUES  (:NEW.customid, vtotal);
    ELSE 
        UPDATE  tbl_sale 
           SET  total=vtotal 
             WHERE  customid = :NEW.customid;
    END  IF;
    EXCEPTION          -- EXCEPTION 추가하여 처리 -> 메시지 출력, rollback 
       WHEN no_data_found THEN      -- 여러 종류 예외처리하는 예시
          dbms_output.put_line('no_data_found');
      WHEN OTHERS THEN 
      dbms_output.put_line('실행 실패----------------------------------');
END;

