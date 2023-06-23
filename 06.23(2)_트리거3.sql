

-- // 1. 예시 : tbl_buy2 는 구매 목록 테이블 , tbl_money 는 결제 테이블 , tbl_sale 은 고객매출 집계로 하여 
create table tbl_buy2           -- tbl_buy 구조만 복사. 시퀀스 생성은 안하고 임의로 값을 주고 테스트하겠습니다.
as
select * from tbl_buy where buy_seq=0;	-- 데이터 복사 안하려고 buy_seq = 0;

-- 확인용
SELECT * FROM tbl_buy2;

CREATE TABLE tbl_money(         -- 
   money_seq number(5) PRIMARY KEY,
   buy_seq number(5) ,
   customid varchar(20),
   money number(7)
);
CREATE SEQUENCE tblmoney_seq START WITH 5001;

-- //2. 아래와 같은 insert 할때
INSERT INTO tbl_buy2 
VALUES (2000, 'mina012','CJBAb12g',3,sysdate,0);

-- tbl_buy2 에 적용할 트리거
-- ★★★★★★★★★★★★★★★★★★★★★★★
-- INSERT ▶ :NEW
-- DELETE ▶ :OLD
-- UPDATE ▶ :NEW , :OLD
-- ★★★★★★★★★★★★★★★★★★★★★★★
CREATE  OR  REPLACE  TRIGGER  set_money_trig
AFTER  INSERT ON  tbl_buy2
FOR  EACH  ROW 
DECLARE 
    vprice number(7);
     vtotal number(7):=0;
    vcnt number(7):=0;
BEGIN 
	-- DELETE FROM TBL_BUY2 tb WHERE buy_seq = ; 했을때 :NEW.customid 출력되는지 확인해보기
   dbms_output.put_line('*' || :NEW.customid || ' ' || vtotal || ' ' || vcnt);
   SELECT price 
      INTO vprice 
      FROM tbl_product tp
      WHERE pcode=:NEW.pcode;   
     
    INSERT  INTO  tbl_money VALUES (tblmoney_seq.nextval, :NEW.buy_seq,:NEW.customid ,:NEW.quantity * vprice);
    
   SELECT  count(*) 
   	  INTO vcnt
      FROM tbl_sale
      WHERE customid=:NEW.customid;
     
   SELECT  sum(money)
      INTO  vtotal
      FROM  tbl_money
      WHERE  customid = :NEW.customid;
     
    IF vcnt=0 THEN  
        INSERT  INTO  tbl_sale VALUES  (:NEW.customid, vtotal);
    ELSE 
        UPDATE  tbl_sale SET  total=vtotal WHERE  customid = :NEW.customid;
    END  IF;
   
    EXCEPTION          -- EXCEPTION 추가하여 처리 -> 메시지 출력
      WHEN OTHERS THEN 
      dbms_output.put_line('//// fail  ////');
END;

-- //5. 데이터 행 입력
INSERT INTO ICLASS.tbl_buy2 (BUY_SEQ,CUSTOMID,PCODE,QUANTITY,BUY_DATE) VALUES (1001,'mina012','CJBAb12g',5,TIMESTAMP'2022-03-10 14:33:15.0');
INSERT INTO ICLASS.tbl_buy2 (BUY_SEQ,CUSTOMID,PCODE,QUANTITY,BUY_DATE) VALUES (1002,'mina012','APLE5kg',2,TIMESTAMP'2022-03-10 14:33:15.0');
INSERT INTO ICLASS.tbl_buy2 (BUY_SEQ,CUSTOMID,PCODE,QUANTITY,BUY_DATE) VALUES (1003,'mina012','JINRMn5',2,TIMESTAMP'2022-03-16 10:13:15.0');
INSERT INTO ICLASS.tbl_buy2 (BUY_SEQ,CUSTOMID,PCODE,QUANTITY,BUY_DATE) VALUES (1004,'twice','JINRMn5',3,TIMESTAMP'2021-12-25 19:32:15.0');
INSERT INTO ICLASS.tbl_buy2 (BUY_SEQ,CUSTOMID,PCODE,QUANTITY,BUY_DATE) VALUES (1005,'twice','MANGOTK4r',2,TIMESTAMP'2021-12-25 19:32:15.0');
INSERT INTO ICLASS.tbl_buy2 (BUY_SEQ,CUSTOMID,PCODE,QUANTITY,BUY_DATE) VALUES (1006,'hongGD','DOWON123a',1,TIMESTAMP'2021-10-21 11:13:25.0');
INSERT INTO ICLASS.tbl_buy2 (BUY_SEQ,CUSTOMID,PCODE,QUANTITY,BUY_DATE) VALUES (1007,'hongGD','APLE5kg',7,TIMESTAMP'2021-10-21 11:13:25.0');
INSERT INTO ICLASS.tbl_buy2 (BUY_SEQ,CUSTOMID,PCODE,QUANTITY,BUY_DATE) VALUES (1008,'twice','CJBAb12g',2,TIMESTAMP'2023-06-22 14:04:47.0');


SELECT * FROM TBL_SALE;
SELECT * FROM TBL_MONEY;
SELECT * FROM TBL_BUY2;

DELETE FROM TBL_BUY2 tb WHERE buy_seq = 1008;


-- //4. 집계 데이터 저장용 테이블 - 트리거2 에서 이미 만들었음
CREATE TABLE tbl_sale(
   customid varchar2(20) PRIMARY KEY,
   total number(7)
);
SELECT * FROM tbl_sale;
-----------------------------------------------------------------