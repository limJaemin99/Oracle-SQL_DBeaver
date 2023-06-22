-- PL/SQL : Procedure(절차,순서) Language , 기존의 단순한 SQL이 확장된 언어(SQL로 만드는 프로그램)
			-- 변수,제어문(if,반복문)을 사용하여 프로그래밍언어와 같이 sql 실행의 흐름을 제어

/*
	[선언부(DECLARE), 실행부(BEGIN), 예외처리부 (EXCEPTION)로 구성됨]
	
	1) Anonymous PL/SQL Block(익명블록) 
	익명 블록은 주로 일회성으로 사용할 경우 많이 사용이 되고, 
	
	2)Stored PL/SQL Block 
	저장된 블록은 서버에 파싱해서 저장해 놓고 주기적으로 반복해서 사용할 경우 사용됨
	서브프로그램 또는 프로그램 단위라고도 하며, 
	스키마를 구성하는 오브젝트로서 파싱 된 후 오라클 서버 내부에 저장되거나 오라클 툴 안에 라이브러리 형태로 저장되어 있음
	
		★★★★★★★★★ 중요 ★★★★★★★★★
			Declare (선언부)		  
			Executable (실행부)	  
			Exception (예외 처리부)  
		★★★★★★★★★★★★★★★★★★★★★★
*/
-- tbl_custom 확인
SELECT * FROM TBL_CUSTOM tc ;

-- [응용 프로시저] ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DECLARE 	-- 변수 선언부
	-- vname varchar2(40);		-- [스칼라 변수]
	-- vage number(3,0);
	vname tbl_custom.name %TYPE;	-- [참조 변수]
	vage tbl_custom.age %TYPE;		-- %TYPE = 같은 타입으로 하겠다는 뜻
BEGIN 		-- 프로시저 시작(실행부)
	-- 프로시저 내부에는 주로 DML 명령문들을 작성 (함께 실행해야할 여러 SQL : 트랜잭션)
	SELECT name , age
		INTO vname , vage	-- 프로시저 구문 : 검색 결과를 프로시저 일반 변수 vname , vage 에 저장
	FROM "TBL_CUSTOM"
	WHERE CUSTOMER_ID = 'hongGD';		-- 1개 행만 결과 조회되는 조건
										-- 여러개 행 조회될때는 다른 cursor 필요
	
	-- DBMS_OUTPUT 은 콘솔에 출력하는 오라클 패키지의 하나이며 PUT_LINE 함수
	DBMS_OUTPUT.PUT_LINE('고객이름 : ' || vname);	-- ||는 문자열 연결 연산
	DBMS_OUTPUT.PUT_LINE('고객나이 : ' || vage);	-- ||는 문자열 연결 연산
	EXCEPTION
	WHEN no_data_found THEN		-- no_data_found : 예외 이름
		DBMS_OUTPUT.PUT_LINE('찾는 데이터가 없습니다.');
END;

-- 인자와 리턴을 주는 형식. [저장 프로시저] ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	-- 저장 프로시저는 DECLARE 를 사용하지 않는다.
CREATE OR REPLACE PROCEDURE search_custom(	-- 프로시저 이름 설정
	c_id IN tbl_custom.CUSTOMER_ID %TYPE 	-- 매개변수 IN
)
IS -- VIEW 만들때는 AS 였지만, 프로시저 만들때는 IS 이다 ★★★
	-- 참조 변수 선언
	vname tbl_custom.NAME %TYPE;	-- 지정된 테이블의 컬럼과 동일 형식의 변수
	vage tbl_custom.AGE %TYPE;
BEGIN
	SELECT name , age
		INTO vname , vage
	FROM TBL_CUSTOM tc 
	WHERE customer_id = c_id;		-- 1개 행만 결과 조회되는 조건
	
	dbms_output.put_line('고객이름 : ' || vname)
	dbms_output.put_line('고객나이 : ' || vage)
	EXCEPTION
	WHEN no_data_found THEN
		dbms_output.put_line('찾는 데이터가 없습니다.');
END;

DROP PROCEDURE SEARCH_CUSTOM; 

-- 만들어진 [저장 프로시저] 실행하기 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- 매개변수가 IN(입력값)이 있고, OUT(출력,리턴)이 없다.
BEGIN
	search_custom('twice');
END;

-- 문제 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SELECT * FROM TBL_BUY tb ;

-- 구매 수량이 최대값인 사용자의 이름 , 나이 를 출력하기
CREATE OR REPLACE PROCEDURE max_custom
IS 
	maxval number(5);
	cid tbl_custom.customer_id %TYPE;
	vname tbl_custom.NAME %TYPE;	
	vage tbl_custom.AGE %TYPE;
BEGIN
	SELECT MAX(quantity) 
		INTO maxval
	FROM TBL_BUY tb; 
	SELECT customid
		INTO cid
	FROM TBL_BUY tb 
	WHERE quantity = maxval;
	SELECT name , age
		INTO vname , vage
	FROM TBL_CUSTOM tc
	WHERE customer_id = cid;
	
	dbms_output.put_line('고객이름 : ' || vname)
	dbms_output.put_line('고객나이 : ' || vage)
	EXCEPTION
	WHEN no_data_found THEN
		dbms_output.put_line('찾는 데이터가 없습니다.');
END;

-- 만들어진 [저장 프로시저] 실행하기 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
BEGIN
	max_custom;
END;

-- 이클립스 JDBC에서 사용하기 위해 max_custom 프로시저 수정함 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CREATE OR REPLACE PROCEDURE max_custom(
	c_name OUT tbl_custom.NAME %TYPE,	-- 출력(리턴) 매개변수
	c_age OUT tbl_custom.AGE %TYPE
)
IS 
	maxval number(5);
	cid tbl_custom.customer_id %TYPE;
BEGIN
	SELECT MAX(quantity) 
		INTO maxval
	FROM TBL_BUY tb; 

	SELECT customid
		INTO cid
	FROM TBL_BUY tb 
	WHERE quantity = maxval;
	
	SELECT name , age
		INTO c_name , c_age
	FROM TBL_CUSTOM tc
	WHERE customer_id = cid;
	
	dbms_output.put_line('고객이름 : ' || c_name);
	dbms_output.put_line('고객나이 : ' || c_age);
	EXCEPTION
	WHEN no_data_found THEN
		dbms_output.put_line('찾는 데이터가 없습니다.');
END;

SELECT * FROM TBL_CUSTOM tc ;

-- 만들어진 프로시저 [max_custom()] 의 OUT(출력값)을 받을 변수 생성 및
								-- [응용 프로시저] 방법으로 출력하기
DECLARE 
	vname tbl_custom.name %TYPE;
	vage tbl_custom.age %TYPE;
BEGIN
	max_custom(vname,vage);		-- vname , vage 는 OUT 매개변수 값을 받을 실제 변수입니다.
	dbms_output.put_line('*고객이름 : ' || vname);
	dbms_output.put_line('*고객나이 : ' || vage);
END;


