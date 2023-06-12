-- 정수 또는 실수 수치 형식
-- 데이터 타입 number : 자바 정수와 실수 타입 형식 지정
-- number (정밀도 , 소수점이하 자리수)


-- 테스트 테이블
CREATE TABLE TBL_number(
	xcol NUMBER,		-- 정밀도 지정 안하면 최대 38자리(자바 BigDecimal) - 정수자리와 실수자리
	ycol NUMBER(5),		-- 정수로 최대 5자리(소수점 이하 없음. -소수점 이하 반올림)
	zcol NUMBER(7,2),	-- 전체 자리수 최대 7자리, 소수점 이하 2자리(고정)
	zcol2 NUMBER(2,5)	-- 소수점이하 최대 5자리(0이 3개 고정) , 0 아닌 유효숫자 최대 2자리
);


-- 0. 모든 컬럼값 정상 실행
-- INSERT INTO 테이블명 (컬럼명,컬럼명,...) VALUES (컬럼 순서에 대응되는 값1,값2,...);
	-- 모든 컬럼에 데이터 입력할 때에는 컬럼명 생략 가능합니다. ex) ↓ 아래 문장 ↓
INSERT INTO TBL_number(xcol,ycol,zcol,zcol2) VALUES (123456789,12345,12345.67,0.00012);
INSERT INTO TBL_number VALUES (123456789,12345,12345.67,0.00012);
	-- 0.00010 에서 앞에 0 3개는 유효한 값 , 마지막 0은 무효한 숫자
	-- 12300 에서 0 2개는 유효한 값 , 00123 에서 0 2개는 무효한 숫자

INSERT INTO TBL_NUMBER(zcol) VALUES (1234.567);		-- 예상 1234.57
INSERT INTO TBL_NUMBER(zcol2) VALUES (0.000127);		-- 자릿수가 길어지면 반올림 됨 0.00013


TRUNCATE TABLE TBL_NUMBER;