
-- 문자열 함수 : 자바와 비슷한 내용으로 분석
-- 함수 , 수식 결과값 확인할 때 오라클 dual 테이블 사용
SELECT CONCAT('java','hello') FROM DUAL;	-- 문자열 연결
SELECT 'java' || 'hello!' FROM DUAL;	-- 자바에서는 OR 기호였지만, 오라클에서는 문자열 연결 연산자로 사용

-- 실제로는 테이블의 컬럼으로 함수 실행합니다.

-- 1. 문자 대소문자 변환 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT INITCAP('hello') FROM DUAL;	-- INITCAP(initail capital) : 첫번째 대문자
SELECT UPPER('hello') FROM DUAL;	-- UPPER : 대문자로 변환
SELECT LOWER('OraCle') FROM DUAL;	-- LOWER : 소문자로 변환
SELECT LENGTH('oracle') FROM DUAL;	-- LENGTH : 길이

-- 2. 부분 추출(문자열,위치,길이) ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- ※ 오라클에서 위치 인덱스는 1부터 시작한다.
SELECT SUBSTR('java program',3,5) FROM DUAL;	-- 3번째 문자부터 5개
SELECT SUBSTR('java program',-5,3) FROM DUAL;	-- 위치값이 음수이면 뒤에서부터

-- 3. 문자열 바꾸기 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SELECT REPLACE('java program','pro','프로') FROM DUAL;
SELECT REPLACE('java progprorampro','pro','프로') FROM DUAL;	-- 바꿀 내용이 여러번 있어도 전부 바꿔준다.

SELECT INSTR('java program','og') FROM DUAL;	-- INSTR : 찾는 문자가 몇번째에 있는지 반환

SELECT TRIM(' java program     ') FROM DUAL;	-- 공백(불필요한 앞뒤 공백)제거 / 단, tab 은 제거 못함
SELECT LENGTH(' java program  ') FROM DUAL;			-- 공백 포함 15자리인데
SELECT LENGTH(TRIM(' java program  ')) FROM DUAL;	--  TRIM 으로 공백 지우고 12자리가 나옴


-- 4. 숫자 함수 (정수 또는 실수 NUMBER 를 대상으로 하는 함수) ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SELECT ABS(-123) FROM DUAL;	-- ABS(n) : 절대값

SELECT TRUNC(3.177567,2) FROM DUAL; -- TRUNC(숫자 , 소수점자리수) : 해당 자리수 뒤를 버림	

SELECT ROUND(3.177567,2) FROM DUAL;	-- ROUND(숫자, 소수점자리수) : 해당 자리수로반올림 

SELECT CEIL(3.177567) FROM DUAL;	-- CEIL(숫자) : 실수를 정수로 [올림]으로 변환

SELECT FLOOR(3.177567) FROM DUAL;	-- FLOOR(숫자) : 실수를 정수로 [내림]으로 변환

-- 5. 날짜 함수 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SELECT SYSDATE , SYSTIMESTAMP FROM DUAL;	-- SYSDATE/SYSTIMESTAMP : 서버의 날짜(초단위) 와 시간(MS)
												-- SYSDATE 를 주로 사용함
SELECT ADD_MONTHS(SYSDATE,3) FROM DUAL;		-- ADD_MONTHS(기준 날짜, 개월 수) : 기준 날짜로부터 n개월 후

SELECT TO_CHAR(SYSDATE,'YYYY') FROM DUAL;	-- TO_CHAR(기준 날짜, '년or월or일 중 택1') : 오늘 날짜에서 '년/월/일' 출력
SELECT TO_CHAR(SYSDATE,'MONTH') FROM DUAL;	
SELECT TO_CHAR(SYSDATE,'DAY') FROM DUAL;	
SELECT TO_CHAR(ADD_MONTHS(SYSDATE,3),'YYYY/MM/DD') FROM DUAL;	-- 문자열 패턴 기호 - 또는 / 또는 구분기호 없음 가능
SELECT TO_CHAR(ADD_MONTHS(SYSDATE,3),'YYYY-MM-DD') FROM DUAL;	-- 문자열 패턴 기호 - 또는 / 또는 구분기호 없음 가능
SELECT TO_CHAR(ADD_MONTHS(SYSDATE,3),'YYYYMMDD') FROM DUAL;		-- 문자열 패턴 기호 - 또는 / 또는 구분기호 없음 가능

-- ※ 년도 , 일수의 차이는 뺄셈 연산으로 가능하지만 개월수의 차이를 구할때는 MONTHS_BETWEEN 함수 사용해야함
SELECT MONTHS_BETWEEN(TO_DATE('2022/06/05') , TO_DATE('2022/09/23') ) FROM DUAL;	-- 지정된 2개 날짜 사이의 간격(월). 결과는 소수점

SELECT TRUNC(SYSDATE) - TO_DATE('20171110','YYYYMMDD') FROM DUAL;	-- 2개의 날짜 형식 값 간격(일)
																	-- 2개의 날짜의 간격(일). TRUNC(SYSDATE)는 일(day)까지로 변환

