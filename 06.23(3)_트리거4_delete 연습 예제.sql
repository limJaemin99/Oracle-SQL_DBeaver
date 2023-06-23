/*
	1. tbl_buy2 의 buy_seq 를 tbl_money 가 참조하도록 외래키를 설정합니다.
	2. 외래키의 on delete 옵션은 cascade로 합니다.
	3. tbl_money 테이블의 set_sale_trig 트리거를 정의합니다.
	   내용은 tbl_money 테이블에서 sum(money)를 구하여
	   tbl_sale 테이블을 update 합니다.
	4. delete from tbl_buy2 where buy_seq = 1004; 를 실행하여 확인합니다.
		▶ 만약 mutating 오류 생기면 2번 외래키를 삭제하고 다시 해보세요.
*/

SELECT * FROM TBL_BUY2;
SELECT * FROM TBL_MONEY;
SELECT * FROM TBL_SALE;

-- 1. tbl_buy2 의 buy_seq 를 tbl_money 가 참조하도록 외래키를 설정합니다.
ALTER TABLE tbl_buy2 ADD CONSTRAINT buyseq_pk primary KEY (buy_seq);
-- ALTER TABLE tbl_money ADD CONSTRAINT moneyseq_fk FOREIGN KEY (buy_seq) REFERENCES tbl_buy2;

-- 2. 외래키의 on delete 옵션은 cascade로 합니다.
ALTER TABLE tbl_money ADD CONSTRAINT moneyseq_fk FOREIGN KEY (buy_seq) REFERENCES tbl_buy2(buy_seq) ON DELETE CASCADE;


-- 3. tbl_money 테이블의 set_sale_trig 트리거를 정의합니다.
	-- ▶ 내용은 tbl_money 테이블에서 sum(money)를 구하여
		-- ▶ tbl_sale 테이블을 update 합니다.
CREATE OR REPLACE TRIGGER set_sale_trig
AFTER DELETE ON tbl_buy2
FOR EACH ROW 
DECLARE
	vmoney number(7);
BEGIN 
	DELETE FROM TBL_MONEY WHERE buy_seq = :OLD.buy_seq;	-- mutating 오류를 발생하지 않게 하기 위해(아래 4번 이후 설명 참조)
	SELECT sum(money)
		INTO vmoney
		FROM TBL_MONEY
		WHERE customid =:OLD.customid;	-- 삭제된 행의 customid 필드값이므로 :OLD
	
	UPDATE TBL_SALE SET total = vmoney WHERE customid =:OLD.customid;
	dbms_output.put_line('*' || :OLD.customid || ' ' || vmoney);

	EXCEPTION
		WHEN OTHERS THEN
			dbms_output.put_line('set_delete_trig 실패!');
END;


-- 4. delete from tbl_buy2 where buy_seq = 1004; 를 실행하여 확인합니다.
delete from tbl_buy2 where buy_seq = 1004; 

-- mutating(돌연변이) 오류 : cascade 때문에 tbl_buy2 테이블 삭제하면 tbl_money 테이블 삭제되면서 충돌
						-- 즉, 잘못 실행되고 있음(실행에 오류가 있음)(같은 테이블에 접근하는 충돌)
							-- ▶ 외래키 자체를 삭제하고
							-- ▶ DELETE FROM TBL_MONEY WHERE buy_seq = :OLD.buy_seq; 를 트리거에서 직접 실행한다.

SELECT * FROM TBL_BUY2;
SELECT * FROM TBL_MONEY;
SELECT * FROM TBL_SALE;

TRUNCATE TABLE TBL_BUY2;
TRUNCATE TABLE TBL_MONEY;
TRUNCATE TABLE TBL_SALE;


