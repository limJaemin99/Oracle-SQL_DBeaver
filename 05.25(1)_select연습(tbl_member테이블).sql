-- 예제 테이블
CREATE TABLE tbl_member (
	mno NUMBER(5),			-- 회원번호 : 정수 최대 5자리까지
	name varchar2(50),		-- 이름 : 최대 50바이트, 한글 16문자
	email varchar2(100),	-- 이메일 : 최대 100바이트
	join_date DATE			-- 가입날짜, 날짜형식 : 날짜 패턴 문자열을 자동으로 날짜형식 DATE 타입으로 변환
							-- 출력형식 : yyyy-mm-dd HH:MM:SS.ms
);


-- 예제 데이터
INSERT INTO TBL_MEMBER VALUES (1,'김모모','momo@naver.com','2022-11-24');
INSERT INTO TBL_MEMBER VALUES (2,'박나연','parkny@gmail.com','2022-10-24');
INSERT INTO TBL_MEMBER VALUES (3,'최슬기','slgichoi@naver.com','2021-09-24');
INSERT INTO TBL_MEMBER VALUES (4,'박사나','san@gmail.com','2022-10-05');
INSERT INTO TBL_MEMBER VALUES (5,'이나연','nayeon@gmail.com','2020-10-05');
INSERT INTO TBL_MEMBER VALUES (6,'강나현','nahyeon@gmail.com','2021-05-05');
INSERT INTO TBL_MEMBER VALUES (7,'나쯔위','na1234@gmail.com','2021-05-05');
INSERT INTO TBL_MEMBER(MNO,NAME,JOIN_DATE) VALUES (8,'강감찬','2020-05-05');
INSERT INTO TBL_MEMBER(MNO,NAME,JOIN_DATE) VALUES (9,'이순신','2020-05-05');


-- DML : 2. SELECT 는 데이터 조회 (모든 행, 특정 조건의 행, 모든 열, 지정된 열)
	-- SELECT 조회할 열 from 테이블 이름 [where] 특정 행을 조회할 조건 [order by] 정렬할 컬럼
		-- 모든 열을 지정하는 기호 * (와일드카드 문자)
-- ★ Ctrl Shift F 누르면 자동정렬 가능
-- 1) 모든 행 , 모든 열 조회
SELECT *
FROM TBL_MEMBER tm;

-- 2) 지정된 열의 모든 행
SELECT name
FROM TBL_MEMBER tm;

SELECT name, email
FROM TBL_MEMBER tm;

-- 3) 조건에 맞는 행의 모든 컬럼 조회
SELECT *
FROM TBL_MEMBER tm
WHERE name = '박사나';

SELECT *
FROM TBL_MEMBER tm 
WHERE mno > 3;

-- 4) 조건에 맞는 행의 지정된 컬럼 조회
SELECT email
FROM TBL_MEMBER tm
WHERE name='박사나';

-- 5) order by 로 정렬 컬럼 지정
SELECT *
FROM TBL_MEMBER tm 
ORDER BY name;		-- 오름차순

SELECT *
FROM TBL_MEMBER tm 
ORDER BY name DESC;	-- 내림차순

-- 6) 문자열의 부분 일치 검색
SELECT *
FROM TBL_MEMBER tm 
WHERE NAME LIKE '박%';	-- %문자는 상관없음. 시작은 '박';
-- 성은 상관 없음. '나연' 검색
SELECT *
FROM TBL_MEMBER tm
WHERE name LIKE '%나연';
-- '나' 문자가 있는 이름 검색(위치는 상관없음)
SELECT *
FROM TBL_MEMBER tm 
WHERE name LIKE '%나%';

-- 7) 여러가지 값으로 조회 : 이름이 김모모 또는 박나연
SELECT *
FROM TBL_MEMBER tm 
WHERE name='김모모' OR name='박나연';

SELECT *
FROM TBL_MEMBER tm 
WHERE name IN ('김모모','박나연');	-- OR 연산에 해당

SELECT *
FROM TBL_MEMBER tm 
WHERE name NOT IN ('김모모','박나연');

SELECT *
FROM TBL_MEMBER tm 
WHERE name='김모모' AND NAME='박나연';	-- AND (2가지 값 동시 만족)

-- 8) 이메일 email 컬럼의 null값 조회 (★is 는 null값 조회할때만 사용★)
SELECT *
FROM TBL_MEMBER tm 
WHERE EMAIL IS NULL;

SELECT *
FROM TBL_MEMBER tm 
WHERE EMAIL IS NOT NULL;

-- 9) mno 컬럼은 수치(정수) 형식
-- mno 값이 5인 것 조회
SELECT *
FROM TBL_MEMBER tm 
WHERE MNO = 5;

-- mno 값이 4미만 조회
SELECT *
FROM TBL_MEMBER tm 
WHERE MNO<4
ORDER BY mno;
-- mno 값이 1,2,5,7 인것 조회 : IN 연산(OR 연산)
SELECT *
FROM TBL_MEMBER tm 
WHERE MNO IN (1,2,5,7)
ORDER BY mno;

-- mno 값이 3 ~ 6 인것 조회 (AND연산)
SELECT *
FROM TBL_MEMBER tm 
WHERE mno>=3 AND MNO<=6
ORDER BY mno;

-- mno 값이 3 ~ 6 인것 조회 (between 연산)
SELECT *
FROM TBL_MEMBER tm 
WHERE mno BETWEEN 3 AND 6;


-- SELECT 앞으로 중요한 것 join 연산
	-- 테이블 2개 이상을 조건식을 통해 하나로 합하는 연산


