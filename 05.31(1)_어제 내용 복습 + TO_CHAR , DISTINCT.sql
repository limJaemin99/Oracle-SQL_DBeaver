

--  SELECT 복습 문제

-- 1) 회원 나이 25세 이상인 아이디와 이름을 조회하세요.
SELECT CUSTOMER_ID , NAME
FROM TBL_CUSTOM
WHERE AGE >= 25;

-- 2) 회원 이메일 gmail.com 계정 모든 컬럼을 조회하세요.
SELECT *
FROM TBL_CUSTOM
WHERE EMAIL LIKE '%gmail.com';

-- 3) 회원 가입 날짜가 '2022-3-10' 또는 '2021-12-25' 모든 컬럼을 조회하세요.
	-- 문자열을 날짜 DATE 형식으로 변환하는 것은 TO_DATE 함수
	-- DATE 형식을 지정된 패턴의 문자열로 변환하는 것은 TO_CHAR 함수
SELECT *
FROM TBL_CUSTOM
WHERE TO_CHAR(REG_DATE,'YYYY-MM-DD') = '2022-03-10' OR TO_CHAR(REG_DATE,'YYYY-MM-DD') = '2021-12-25';

-- 4) 상품 가격이 10000원 미만 상품명, 가격 컬럼을 조회하세요.
SELECT PNAME,PRICE
FROM TBL_PRODUCT
WHERE PRICE <10000;

-- 5) 상품 카테고리 'B1' 을 조회하세요.
SELECT *
FROM TBL_PRODUCT
WHERE CATEGORY = 'B1';

-- 6) 상품명에 '사과' 가 들어가는 상품을 조회하세요.
SELECT *
FROM TBL_PRODUCT
WHERE PNAME LIKE '%사과%';

-- 7) 진라면 상품코드 'JINRMn5' 를 구입한 회원 id를 조회하세요.
SELECT CUSTOMID
FROM TBL_BUY
WHERE PCODE = 'JINRMn5';

-- 8) 회원 twice 가 구입한 상품코드를 조회하세요.
SELECT PCODE
FROM TBL_BUY
WHERE CUSTOMID = 'twice';


-- 조인 형식 1) WHERE 의 조건식으로만
SELECT PNAME , PRICE ,
					TB.QUANTITY * PRICE -- 조회 컬럼을 이용한 수식 사용
FROM TBL_PRODUCT tp , TBL_BUY tb
WHERE TP.PCODE = TB.PCODE 	-- 별칭은 필수. 어느 테이블의 PCODE 인지 지정
	AND TB.CUSTOMID = 'twice';	-- 별칭은 선택. CUSTOMID 테이블은 하나밖에 없음

-- 조인 형식 2) FROM 의 조건식으로만
SELECT *
FROM TBL_PRODUCT tp JOIN TBL_BUY tb ON TP.PCODE = TB.PCODE;	-- 내부 조인 , 동등(equal)조인
-- 위의 조인에 조건 추가하기 (AND 나 WHERE 추가)
SELECT *
FROM TBL_PRODUCT tp JOIN TBL_BUY tb ON TP.PCODE = TB.PCODE AND TB.CUSTOMID = 'twice';
-- WHERE 도 가능하다
--FROM TBL_PRODUCT tp JOIN TBL_BUY tb ON TP.PCODE = TB.PCODE WHERE TB.CUSTOMID = 'twice';


-- 9) 진라면 상품 코드 'JINRMn5' 이 판매된 날짜를 조회하세요.
SELECT BUY_DATE
FROM TBL_BUY
WHERE PCODE = 'JINRMn5';

-- 10) 우리 매장에서 상품을 구매한 회원ID를 조회하세요.
SELECT
	DISTINCT		-- DISTINCT : 조회된 컬럼의 중복된 값을 제거
		CUSTOMID
FROM TBL_BUY;

-- ※ 참고 : JOIN 이 필요한 예시는
-- 7) 진라면 상품코드 'JINRMn5' 를 구입한 회원의 이름과 이메일을 구입날짜 기준으로 정렬하여 조회하세요.
SELECT tc.NAME , tc.EMAIL
FROM TBL_CUSTOM tc JOIN TBL_BUY tb ON tb.PCODE = 'JINRMn5'
ORDER BY tb.BUY_DATE;

-- 참고 : 조인 조건식이 없다면?
SELECT *
FROM TBL_BUY tb , TBL_PRODUCT tp;	-- '크로스 조인' 이라고 함 (가능한 조합을 모두 출력)

SELECT *
FROM TBL_CUSTOM tc , TBL_PRODUCT tp;	-- 공통된 컬럼이 없지만 조합이 됨

SELECT *
FROM TBL_BUY tb JOIN TBL_PRODUCT tp;	-- 조건(ON)이 없어서 조인 불가능 (ON이 반드시 있어야 함)

-- 외부 조인
-- 외부 조인 테스트를 위해 새로운 상품 입력하기
INSERT INTO TBL_PRODUCT tp VALUES ('3MCRY','B1','오뚜기 3분카레',2300);

SELECT * FROM TBL_BUY tb;
SELECT * FROM TBL_CUSTOM tc;
SELECT * FROM TBL_PRODUCT tp;

-- 내부 동등조인을 했을 때,
-- 조인 결과행에 없는 회원ID가 있나요?	>>> 구매하지 않은 고객 (여기에서는 wonder 고객이 구매하지 않았다)
-- 조인 또는 없는 pcode 있나요?		>>> 판매되지 않은 상품
SELECT *
FROM TBL_PRODUCT tp JOIN TBL_BUY tb ON tp.PCODE = tb.PCODE;
-----------------------------------------------------------------
SELECT *
FROM TBL_PRODUCT tp		
LEFT					-- 외부 조인을 위해 LEFT OUTER 키워드 추가 : 상품에는 있고, 구매에는 없는 pcode 포함
	OUTER
	JOIN TBL_BUY tb
ON tp.PCODE = tb.PCODE;	-- '동등하다'를 검사하는것 / tb.pcode 가 NULL인 것도 포함

-- 참고 : 오라클에서 외부조인 표기 다른 방법이 있습니다. (위랑 같은 내용임)
SELECT *
FROM TBL_PRODUCT tp , TBL_BUY tb
WHERE TP.PCODE = TB.PCODE(+);	-- 상품 테이블 쪽으로 구매 결합(+)
-----------------------------------------------------------------
SELECT *
FROM TBL_CUSTOM tc
LEFT					-- 외부 조인을 위해 LEFT OUTER 키워드 추가 : 고객에는 있고, 구매에는 없는 회원ID 포함
	OUTER
	JOIN TBL_BUY tb
ON tc.CUSTOMER_ID = tb.CUSTOMID;	-- '동등하다'를 검사하는것 / tb.customid 가 NULL인 것도 포함

-- 10-1) 우리 매장에서 상품을 구매한 회원ID를 조회하세요.
SELECT DISTINCT tc.CUSTOMER_ID
FROM TBL_CUSTOM tc 
LEFT JOIN TBL_BUY tb ON tc.CUSTOMER_ID  = tb.CUSTOMID
WHERE
	tb.PCODE IS NOT NULL;	-- 조건식 검사. 외부 조인에서는 WHERE 사용합니다.
	
-- 10-2)또는 우리매장에 한번도 상품을 구매하지 않은 회원ID 조회
SELECT *
FROM TBL_CUSTOM tc LEFT JOIN TBL_BUY tb ON tc.CUSTOMER_ID = tb.customid;





