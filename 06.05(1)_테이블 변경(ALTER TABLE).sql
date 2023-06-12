/*
 	ALTER TABLE [변경내용키워드] 변경할 내용 :
 	-1) 컬럼 이름 변경 : RENAME COLUMN
	-2) 새로운 컬럼 추가 : ADD
	-3) 컬럼 데이터 형식 변경 : MODIFY
	-4) 기존 컬럼 삭제 : DROP
	-5) 테이블 이름 변경 : RENAME TO
	-6) 제약 조건 추가 : ADD CONSTRAINT
	-7) 기존 제약 조건 삭제 : DROP CONSTRAINT 제약조건이름
*/

-- 예제 테이블
CREATE TABLE TBL_TEST# (
	TID VARCHAR2(3) NOT NULL,
	TNAME VARCHAR2(10) NOT NULL,
	ETC VARCHAR2(10),
	TNO NUMBER(3)
);


-- NOT NULL 제약 조건 테스트
INSERT INTO TBL_TEST#(TID,TNAME) VALUES ('tes','테스트');.

INSERT INTO	TBL_TEST#(TID) VALUES ('te1');	-- TNAME 컬럼은 NOT NULL 제약조건

SELECT * FROM TEST#;

-- 1) 컬럼 이름 변경 : RENAME COLUMN
	-- ETC 를 T_ETC 로 변경하기
ALTER TABLE TBL_TEST# RENAME COLUMN ETC TO T_ETC;

-- 2) 새로운 컬럼 추가 : ADD
	-- TEL 컬럼 추가하기
	-- 실행 후 : 컬럼 추가하기전에 INSERT 한 기존 행에도 기본값이 저장된다.
ALTER TABLE TBL_TEST# ADD (TEL VARCHAR2(20) DEFAULT '000-0000-0000');

-- 3) 컬럼 데이터 형식 변경 : MODIFY
/*
	컬럼 레벨 또는 테이블 레벨에서 제약조건 설정은 CONSTRAINT 키워드를 생략할 수 있습니다.
	제약조건 이름을 생략하면 오라클이 임의로 이름을 만듭니다.
	오라클이 만들어 준 이름의 제약조건은 이미 있는 제약조건을 동일하게 쓰면 오류가 생깁니다.
	▶ ALTER TABLE ~ MODIFY 로 제약조건 설정은 컬럼 레벨. 주의해서 사용하기.
*/

-- 컬럼 레벨. 제약조건 이름 정의하기
CREATE TABLE TBL_TEST2#(
	TID VARCHAR2(3) CONSTRAINT TID_PK PRIMARY KEY,
	TNAME VARCHAR2(10) CONSTRAINT TNAME_NOTNULL NOT NULL,
	ETC VARCHAR2(10),
	TNO NUMBER(3)
);

DROP TABLE TBL_TEST2#;

CREATE TABLE TBL_TEST3#(
	TEST VARCHAR2(20) NOT NULL,
	TID VARCHAR2(3) CONSTRAINT TID_FK REFERENCES TBL_TEST2#(TID)	-- FOREIGN KEY 안씁니다.
);




	-- TID 의 길이를 20으로 변경하기
ALTER TABLE TBL_TEST# MODIFY TID VARCHAR2(20) NOT NULL; -- 컬럼레벨 제약조건 설정
-- ↑컬럼 레벨 제약조건 설정. 'CONSTRAINT 제약조건이름 NOT NULL' 에서 생략된 형태입니다↑

-- 없던 제약조건 추가는 실행 가능
ALTER TABLE TBL_TEST# MODIFY TNAME VARCHAR2(25) UNIQUE;
ALTER TABLE TBL_TEST# MODIFY TNO VARCHAR2(25) CHECK (TNO > 100);	-- CHECK : 값의 범위를 설정하는  '제약조건'

-- 4) 기존 컬럼 삭제 : DROP
ALTER TABLE TEST# DROP (TEL); 
-- ※ 컬럼 삭제시 오류가 발생하는 경우 : 다른 테이블 외래키의 부모(참조) 컬럼일때 ★★★★★

-- 5) 테이블 이름 변경 : RENAME TO
ALTER TABLE TBL_TEST# RENAME TO TEST#;

-- 제약조건은 '추가' 와 '제거' 만 있다. (기존에 존재하던것을 변경할 수는 없다)
	-- ※ '제약조건이름'은 개발자가 생략할 경우 오라클이 자동으로 만들어 준다.
SELECT * FROM USER_CONSTRAINTS;	-- 메타 데이터 / 데이터 또는 DB 객체들을 관리하는 데이터 (데이터 사전)
SELECT CONSTRAINT_NAME, SEARCH_CONDITION FROM USER_CONSTRAINTS;		-- 현재 스키마의 모든 테이블의 제약조건을 조회합니다.

-- 6) 제약 조건 추가 : ADD CONSTRAINT 제약조건이름 [제약조건키워드]
ALTER TABLE "TEST#"
ADD 				-- 테이블 레벨로 제약조건 설정			|※ 테이블 레벨 : 데이터베이스 테이블에 적용되는 특정 기능, 속성 또는 제약 조건을 나타낸다.
CONSTRAINT TEST_PK  -- 'CONSTRAINT 제약조건이름' 생략 가능	|			   테이블 레벨 요소는 테이블 자체에 적용되는 것으로, 해당 테이블의 구조와 동작을 정의하거나 제한하는 역할을 한다.
PRIMARY KEY (TID);	-- 기본키 추가

-- 7) 기존 제약 조건 삭제 : DROP CONSTRAINT 제약조건이름 [제약조건키워드]
ALTER TABLE "TEST#" DROP CONSTRAINT TEST_PK;	-- 설정된 기본키 삭제

INSERT INTO "TEST#" (TID,TNAME) VALUES ('tes','테스트2');	-- TID의 기본키를 삭제한 뒤 중복된 값으로 추가
ALTER TABLE "TEST#" ADD CONSTRAINT TEST_PK PRIMARY KEY (TID);	-- 오류 : 중복된 값이 이미 있으므로 기본키 설정을 할 수 없다.

-- PK 없는 처음 상태에서 테스트하기
-- 이미 있는 NOT NULL 제약조건도 잘 실행된다.(제약조건 이름이 다르기 때문)
ALTER TABLE "TEST#" ADD CONSTRAINT TEST_ID CHECK (TID IS NOT NULL); -- ※ NOT NULL 제약조건 추가는 CHECK 키워드로 해야한다. ★★★★★
								-- TEST_ID 는 개발자가 정하는 제약조건 이름 (개발자가 정의하지 않으면 오라클이 자동으로 만들어줌 ex)SYS-C007011)

ALTER TABLE "TEST#" ADD CONSTRAINT T_ETC CHECK (T_ETC IS NOT NULL);	-- 오류 : 이미 NULL 값이 입력되어 있는 데 NOT NULL 로 변경하려 하기 때문에 오류
