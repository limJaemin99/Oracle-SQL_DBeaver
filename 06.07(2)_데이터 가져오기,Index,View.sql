/*
	2. 데이터베이스 테이블 데이터가 외부의 다른 형식 파일로 변경 가능합니다.
	- 데이터 가져오기 : Import		ex) csv 파일 데이터를 테이블로 변환
	- 데이터 내보내기 : Export		ex) 테이블 데이터를 csv 파일로 변환
	※ Import 와 Export 는 SQL 명령이 있으나, 디비버 메뉴로 설명하겠습니다.
		[Tables] 항목을 클릭 - [데이터 가져오기] - 
*/

-- 현재 ANIMAL_ID 가 중복된 값은 있고 NULL 값은 없음
SELECT COUNT(*) FROM AAC_INTAKES ai ;
SELECT COUNT(ANIMAL_ID) FROM AAC_INTAKES ai ;
SELECT COUNT(DISTINCT ANIMAL_ID) FROM AAC_INTAKES ai ; 

SELECT * FROM AAC_INTAKES ai WHERE ANIMAL_ID = 'A738040'; -- 실행시간을 알아봅시다.

-- INDEX 만들어주기
	-- ex) 책 앞의 목차, 책 뒤의 주요 키워드가 있는 페이지 번호가 있다.
CREATE INDEX ANIMAL_IDX ON AAC_INTAKES(ANIMAL_ID);

-- 테이블의 Index는 특정 컬럼값을 key, 컬럼값의 행이 저장된 주소는 value 로 구성
-- Index 가 없다면, 처음부터 한 행씩 순차적으로 검색해야 하므로 실행 시간이 오래걸린다.
-- 검색 기능(=)을 향상시키기 위한 목적으로 만들어진다. 컬럼값이 UNIQUE 에 가까울수록 성능이 좋아진다.
-- PK 에 해당하는 컬럼은 자동으로 Index로 만들어진다.
	-- Index 도 복합컬럼으로 만들어질 수 있다.
		-- Index 설정 전 실행시간 : 10ms
		SELECT * FROM AAC_INTAKES ai WHERE ANIMAL_TYPE = 'Cat' AND COLOR = 'Brown';
		-- Index 설정
		CREATE INDEX ANIMAL_IDX2 ON AAC_INTAKES(ANIMAL_TYPE , COLOR);
		-- Index 설정 후 실행시간 : 3ms
		SELECT * FROM AAC_INTAKES ai WHERE ANIMAL_TYPE = 'Cat' AND COLOR = 'Brown';
		
-- 만들어진 Index 지우기
DROP INDEX ANIMAL_IDX2;


-- VIEW (뷰) 를 생성해보기
	-- ※ 주의 : ICLASS 의 권한 확인
	SELECT * FROM ROLE_SYS_PRIVS;	-- 오라클이 DB 관리를 위해 필요한 테이블
	
SELECT * from TMP_SCORE; 
SELECT * from TMP_STUDENT; 

-- CREATE VIEW 권한이 없을 경우 SQL PLUS 에서
	-- SQL> GRANT CREATE VIEW TO ICLASS; 로 권한 부여를 해줘야함 ▶ 이후 디비버에서 재연결을 해줘야 함
CREATE VIEW V_TEST
AS
SELECT tsc.STUNO , SUBJECT , NAME , JUMSU , TEACHER	-- '모든 컬럼'(*)을 지정하면 오류
FROM TMP_SCORE tsc		 -- 물리적 테이블 1
JOIN TMP_STUDENT ts		 -- 물리적 테이블 2
ON tsc.STUNO = ts.STUNO; -- 조인

SELECT COUNT(*) FROM V_TEST vt ;
SELECT STUNO , JUMSU FROM V_TEST vt ;

-- VIEW 를 대상으로 INSERT , UPDATE , DELETE 를 할 수 있는지?	★★★★★
	-- 한개의 물리적 테이블로만 뷰를 생성했을때만 가능

-- 지금까지 우리는 오라클의 DB 객체 테이블, 시퀀스, 인덱스, 뷰를 사용했습니다.
	-- 나중에 프로시저, 트리거 등등을 공부할 예정입니다.

