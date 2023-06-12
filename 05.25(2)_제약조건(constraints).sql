-- 제약 조건 (constraints)
	-- 테이블에 저장되는 데이터가 부적절한 값을 갖지 않도록 규칙을 적용
		-- 1) NOT NULL
		-- 2) UNIQUE
		-- 3) PRIMARY KEY	★데이터 행을 식별(구별) 목적★
			-- ▶ 1) 과 2) 를 모두 만족.

-- 3) PRIMARY KEY 설명
-- tbl_member 테이블 mno 값이 1 있습니다.
SELECT *
FROM TBL_MEMBER tm 
WHERE mno=1;
-- mno값이 1인게 또 입력 되는지?
INSERT INTO TBL_MEMBER tm VALUES (1,'김모모','momo@naver.com','2022-11-24');

-- 회원 가입 서비스를 예시로 하면, 회원 구별은 id 또는 email 또는 회원번호
	-- 이런 값들은 회원을 구별(식별)하는 컬럼입니다 ▶ NOT NULL 이면서 UNIQUE 해야합니다.
		-- ▶ 기본키 PK(PRIMARY KEY) 로 선정합니다★★★★★
-- 설명 끝




-- PK를 설정하고 관계를 갖도록 하는 테이블 예시 : 성적처리
	-- 테이블과 컬럼은 데이터의 중복을 최소화 하도록 설계
CREATE TABLE TBL_STUDENT (
	STUNO CHAR(7) PRIMARY KEY,	-- 제약조건 설정방법 1) 컬럼 레벨 4		-- 학번을 기본키로 설정
	NAME VARCHAR2(30) NOT NULL,	-- 학생이름
	AGE NUMBER(3) CHECK (AGE BETWEEN 10 AND 30),	-- 나이 : 입력값의 범위 설정
	ADDRESS NVARCHAR2(50)		-- 주소
);

-- '학번'에 해당하는 학생이 'SUBJECT'과목을 'TEACHER'선생님에게 강의를 듣고 시험을 'TERM'(언제) 'JUMSU'(점수) 받음.
CREATE TABLE TBL_SCORE(
	STUNO CHAR(7),		-- 외래키로 '학생' 테이블의 '학번' 값을 참조합니다.
	SUBJECT NVARCHAR2(20),	-- 과목명
	JUMSU NUMBER(3)	NOT NULL,	-- 점수
	TEACHER NVARCHAR2(20) NOT NULL,	-- 담당교사
	TERM CHAR(6) NOT NULL,			-- 수강학기	230101(예)
	-- 제약조건 설정방법 2) 테이블 레벨
	PRIMARY KEY(STUNO,SUBJECT),	-- 기본키를 복합컬럼으로 설정
	FOREIGN KEY(STUNO) REFERENCES TBL_STUDENT(STUNO)	-- 참조관계 설정(외래키)
	-- FOREIGN KEY(성적테이블컬럼) REFERENCES 참조테이블(참조테이블컬럼)
	-- 학생 테이블의 참조컬럼(stuno) 조건은 ? 기본키 또는 unique 컬럼이어야 합니다(unique 컬럼일때는 null 허용)
	/* ※ 참조컬럼 조건은	? 기본키 또는 UNIQUE 컬럼이어야 한다. (외래키 칼럼은 NULL이 가능) 
		참조관계를 만들때 사용한 성적 테이블의 STUNO는 값의 제약이 있습니다.
		TBL_STUDENT 테이블 STUNO 컬럼에 입력된 값으로 제한됩니다.
	*/
);

-- NOT NULL 제약조건 위반 오류
INSERT INTO TBL_STUDENT(STUNO, AGE, ADDRESS)
VALUES('2021001', 16, '서초구');

-- PK 제약조건 위반 오류 (PK 컬럼 STUNO 에 2021001 이 입력된 상태)
INSERT INTO TBL_STUDENT(STUNO, NAME, AGE, ADDRESS)
VALUES('2021001', '김모모', 18, '서초구');

-- PK(행을 식별하는 역할) 컬럼을 조건으로 SELECT 조회하면 조회되는 행의 개수는 항상 0 또는 1 입니다.
-- STUDENT
SELECT *
FROM TBL_STUDENT ts 
WHERE STUNO = '2021001';

SELECT *
FROM TBL_STUDENT ts 
WHERE STUNO = '2021';	--없으므로 0개

SELECT *
FROM TBL_STUDENT ts 
WHERE STUNO = '2021019';

-- PK가 여러개 컬럼으로 구성(복합 컬럼) 될 때에는 컬럼들을 and조건으로 하면 행을 식별할 수 있는 select
-- SCORE
SELECT *
FROM TBL_SCORE ts 
WHERE STUNO = '2021019' AND SUBJECT = '영어';

SELECT *
FROM TBL_SCORE ts 
WHERE STUNO = '2021001' AND SUBJECT = '영어';

-- 아래는 PK 2개중 1개씩 했으므로 0/1개가 나오지 않음
SELECT *
FROM TBL_SCORE ts 
WHERE STUNO = '2021001';

SELECT *
FROM TBL_SCORE ts 
WHERE SUBJECT = '영어';


-- 학생 테이블에 데이터 입력
INSERT INTO TBL_STUDENT(STUNO, NAME, AGE, ADDRESS)
VALUES('2021001', '김모모', 16, '서초구');
INSERT INTO TBL_STUDENT(STUNO, NAME, AGE, ADDRESS)
VALUES('2019019', '이OO', 22, '경기도');
INSERT INTO TBL_STUDENT(STUNO, NAME, AGE, ADDRESS)
VALUES('2019017', '강OO', 29, '강원도');

-- 성적 테이블에 데이터 입력
INSERT INTO tbl_score(stuno,subject,jumsu,teacher,term)
VALUES ('2021001','국어',89,'이나연','2022_1');
INSERT INTO tbl_score(stuno,subject,jumsu,teacher,term)
VALUES ('2021001','영어',78,'김길동','2022_1');
INSERT INTO tbl_score(stuno,subject,jumsu,teacher,term)
VALUES ('2021001','과학',67,'박세리','2021_2');
INSERT INTO tbl_score(stuno,subject,jumsu,teacher,term)
VALUES ('2019019','국어',92,'이나연','2019_2');
INSERT INTO tbl_score(stuno,subject,jumsu,teacher,term)
VALUES ('2019019','영어',85,'박지성','2019_2');
INSERT INTO tbl_score(stuno,subject,jumsu,teacher,term)
VALUES ('2019019','과학',88,'박세리','2020_1');
INSERT INTO tbl_score(stuno,subject,jumsu,teacher,term)
VALUES ('2019017','국어',22,'이나연','2019_2');
INSERT INTO tbl_score(stuno,subject,jumsu,teacher,term)
VALUES ('2019017','영어',54,'박지성','2019_2');
INSERT INTO tbl_score(stuno,subject,jumsu,teacher,term)
VALUES ('2019017','과학',37,'박세리','2020_1');


-- 참조관계일때는 자식 테이블 삭제 후 부모테이블 삭제해야한다.
DROP TABLE TBL_SCORE;
DROP TABLE TBL_STUDENT;

-- 테이블에 있는 내용 확인용
SELECT * FROM TBL_SCORE ts;
SELECT * FROM TBL_STUDENT ts;

-- TRUNCATE 는 참조관계일때 자식 행 모두 제거 후 부모 테이블 제거 가능
TRUNCATE TABLE TBL_SCORE;
TRUNCATE TABLE TBL_STUDENT;

-- 혼자 해본거
SELECT a.STUNO, a.NAME ,b.SUBJECT ,b.JUMSU ,b.TEACHER ,b.TERM 
FROM TBL_STUDENT a, TBL_SCORE b
WHERE a.STUNO = b.STUNO
ORDER BY a.STUNO;

SELECT STUNO , count(*)
FROM tbl_score
GROUP BY STUNO;
-- TBL_SCORE 테이블에 stuno 컬럼은 기본키의 구성컬럼이면서 외래키입니다
	-- ▶ 식별관계 라고 함

-- ex) 성적 테이블에 '과목명'을 학생 1명이 동일한 과목이 있다면(예시 : 2학년 국어, 3학년 국어)
--		기본키를 위한 새로운 컬럼을 만들기(성적코드 또는 성적 고유번호 등을 만들 수 있다)
--		stuno 는 기본키가 아니고 외래키로만 설정되었을때 (▶ 비식별관계)
