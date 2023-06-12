--식료품을 판매하는 매장의 판매 관리를 위한 시스템을 구축합니다. 이 쇼핑몰에서 고객 은 필요한 상품을 구매할 수 있습니다.
--고객은 회원가입 후 상품을 구매할 수 있습니다.
	-- 회원 은 고유ID , 이름, 이메일, 나이 , 가입날짜로 관리하며  (PK)
			-- customer_id(20) , name(40) , email(40) , age number(3) , reg_date 날짜
	-- 상품 은 상품코드, 카테고리, 상품명, 가격이 필요합니다. (PK)
			-- pcode(20) , category char(2) , pname(40) , price number(9)
	-- 구매 는 상품을 구매한 회원의 고유ID, 상품코드 , 구매수량, 구매날짜를 저장하여 관리합니다. (PK,FK)
			-- PK : 구매 테이블에는 고유 ID또는 상품코드로 기본키를 만들 수 있을까요?
					-- 없습니다. 별도로 BUY_SEQ NUMBER(8) 컬럼 사용
			-- FK : 1개의 테이블에서 외래키는 여러개가 존재할 수 있다.
			

--회원 예시 데이터
--'mina012', '김미나', 'kimm@gmail.com', 20, '2022-03-10 14:23:25'
--'hongGD', '홍길동', 'gil@korea.com', 32, '2021-10-21 11:12:23'
--'twice', '박모모', 'momo@daum.net', 29, '2021-12-25 19:23:45'
--'wonder', '이나나', 'lee@naver.com', 40, 현재날짜와 시간


--상품 예시 데이터

--'DOWON123a', 'B2', '동원참치선물세트', 54000
--'CJBAb12g', 'B1', '햇반 12개입', 14500
--'JINRMn5', 'B1', '진라면 5개입', 6350
--'APLE5kg', 'A1', '청송사과 5kg', 66000
--'MANGOTK4r', 'A2', '애플망고 1kg', 32000


--구매

--'mina012' , 'CJBAb12g' , 5 , '2022-03-10 14:33:15'
--'mina012' , 'APLE5kg' , 2 , '2022-03-10 14:33:15'
--'mina012' , 'JINRMn5' , 2 , '2022-03-16 10:13:15'
--'twice' , 'JINRMn5' , 3 , '2021-12-25 19:32:15'
--'twice' , 'MANGOTK4r' , 2 , '2021-12-25 19:32:15'
--'hongGD' , 'DOWON123a' , 1 , '2021-10-21 11:13:25'
--'hongGD' , 'APLE5kg' , 1 , '2021-10-21 11:13:25'



-- 고객 테이블
CREATE TABLE TBL_CUSTOM(
	CUSTOMER_ID VARCHAR2(20) PRIMARY KEY ,
	NAME VARCHAR2(40) NOT NULL ,
	EMAIL VARCHAR2(40) ,
	AGE number(3) DEFAULT 0 ,	-- DEFAULT 는 기본값 지정
	REG_DATE DATE
);

-- 상품 테이블
CREATE TABLE TBL_PRODUCT(
	PCODE VARCHAR2(20) PRIMARY KEY ,
	CATEGORY char(2) NOT NULL ,
	PNAME VARCHAR2(40) NOT NULL ,
	PRICE number(9) NOT NULL
);

-- 구매 테이블
CREATE TABLE TBL_BUY(
	--구매한 회원의 고유ID, 상품코드 , 구매수량, 구매날짜
	--BUY_SEQ NUMBER(8) 컬럼 사용 >> 기본키로 사용
	BUY_SEQ NUMBER(8) PRIMARY KEY,	-- 기본키를 위한 새로운 컬럼(구매 번호)
	CUSTOMID VARCHAR2(20) NOT NULL ,	--참조테이블 컬럼명과 다르게 해도 상관 없다.
	PCODE VARCHAR2(20) NOT NULL ,
	QUANTITY NUMBER(5) DEFAULT 1 , -- DEFAULT 로 기본값 1로 지정 (수량)
	BUY_DATE DATE ,
	FOREIGN KEY (CUSTOMID) REFERENCES TBL_CUSTOM (CUSTOMER_ID) ,
	FOREIGN KEY (PCODE) REFERENCES TBL_PRODUCT (PCODE)
);


-- 테이블 삭제
DROP TABLE TBL_CUSTOM;
DROP TABLE TBL_PRODUCT;
DROP TABLE TBL_BUY;



-- 테이블 내용 입력
-- 오류 : 타입이 DATE 일때 시:분:초 가 포함된 문자열은 자동 변환이 안된다.
	-- TO_DATE( , ) : 함수로 문자열에서 날짜형식 변환. 문자열의 패턴이 필요
INSERT INTO TBL_CUSTOM VALUES ('mina012', '김미나', 'kimm@gmail.com', 20, TO_DATE('2022-03-10 14:23:25','YYYY-MM-DD HH24:MI:SS'));
INSERT INTO TBL_CUSTOM VALUES ('hongGD', '홍길동', 'gil@korea.com', 32, TO_DATE('2021-10-21 11:12:23','YYYY-MM-DD HH24:MI:SS'));
INSERT INTO TBL_CUSTOM VALUES ('twice', '박모모', 'momo@daum.net', 29, TO_DATE('2021-12-25 19:23:45','YYYY-MM-DD HH24:MI:SS'));
-- 현재 날짜와 시간은 SYSDATE 로 설정 ★★★★★
INSERT INTO TBL_CUSTOM VALUES ('wonder', '이나나', 'lee@naver.com', 40, SYSDATE);

DELETE FROM TBL_CUSTOM;


-- 참고로 CODE 는 상품명, 회사명, 강사명 등 중복될 수 있는 데이터를 식별하기 위해 부여하는 임의의 '체계있는 값'입니다.
INSERT INTO TBL_PRODUCT VALUES ('DOWON123a', 'B2', '동원참치선물세트', 54000);
INSERT INTO TBL_PRODUCT VALUES ('CJBAb12g', 'B1', '햇반 12개입', 14500);
INSERT INTO TBL_PRODUCT VALUES ('JINRMn5', 'B1', '진라면 5개입', 6350);
INSERT INTO TBL_PRODUCT VALUES ('APLE5kg', 'A1', '청송사과 5kg', 66000);
INSERT INTO TBL_PRODUCT VALUES ('MANGOTK4r', 'A2', '애플망고 1kg', 32000);

DELETE FROM TBL_PRODUCT;


INSERT INTO TBL_BUY VALUES (1, 'mina012' , 'CJBAb12g' , 5 , TO_DATE('2022-03-10 14:33:15','YYYY-MM-DD HH24:MI:SS'));
INSERT INTO TBL_BUY VALUES (2, 'mina012' , 'APLE5kg' , 2 , TO_DATE('2022-03-10 14:33:15','YYYY-MM-DD HH24:MI:SS'));
INSERT INTO TBL_BUY VALUES (3, 'mina012' , 'JINRMn5' , 2 , TO_DATE('2022-03-16 10:13:15','YYYY-MM-DD HH24:MI:SS'));
INSERT INTO TBL_BUY VALUES (4, 'twice' , 'JINRMn5' , 3 , TO_DATE('2021-12-25 19:32:15','YYYY-MM-DD HH24:MI:SS'));
INSERT INTO TBL_BUY VALUES (5, 'twice' , 'MANGOTK4r' , 2 , TO_DATE('2021-12-25 19:32:15','YYYY-MM-DD HH24:MI:SS'));
INSERT INTO TBL_BUY VALUES (6, 'hongGD' , 'DOWON123a' , 1 , TO_DATE('2021-10-21 11:13:25','YYYY-MM-DD HH24:MI:SS'));
INSERT INTO TBL_BUY VALUES (7, 'hongGD' , 'APLE5kg' , 1 , TO_DATE('2021-10-21 11:13:25','YYYY-MM-DD HH24:MI:SS'));

DELETE FROM TBL_BUY;



--출력 혼자 해본거
SELECT A.CUSTOMER_ID , A.NAME ,B.PCODE ,B.PNAME ,B.PRICE , C.CUSTOMID , C.PCODE ,C.BUY_DATE
FROM TBL_CUSTOM A , TBL_PRODUCT B , TBL_BUY C
WHERE A.CUSTOMER_ID = C.CUSTOMID AND B.PCODE = C.PCODE
ORDER BY NAME;

SELECT CUSTOMER_ID , COUNT(*)
FROM TBL_CUSTOM
GROUP BY CUSTOMER_ID;

