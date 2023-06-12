/*
	참고 : 집계(통계) 함수 - 개수 , 합계 , 평균 , 최대 , 최소
	SELECT COUNT(*) FROM TBL_BUY tb ;		-- 행의 개수. 컬럼을 지정하지 않고 *
	SELECT SUM(QUANTITY) FROM TBL_BUY tb ;
	SELECT AVG(QUANTITY) FROM TBL_BUY tb ;
	SELECT MAX(QUANTITY) FROM TBL_BUY tb ;
	SELECT MIN(QUANTITY) FROM TBL_BUY tb ;
	SELECT MAX(BUY_SEQ) FROM TBL_BUY tb ;
	
	※ 주의 : 집계 함수로 SELECT 할 때에는 다른 컬럼은 조회 불가 ★★★★★
*/



SELECT * FROM TBL_SCORE ts ;

-- 1. 테이블 행의 전체 개수
SELECT COUNT(*) AS "행 전체 개수" FROM TBL_SCORE ts ;	-- 한글을 넣을때는 ""(큰따옴표) 안에 작성

-- 2. '국어' 과목의 전체 개수
SELECT COUNT(*) AS "국어 과목 행 개수" FROM TBL_SCORE ts
WHERE SUBJECT = '국어';	
	-- 오류 : 집계 함수로 SELECT 할 때 다른 컬럼은 조회 불가 ▶ GROUP BY 사용시 가능
	SELECT COUNT(*) AS "국어 과목 행 개수" FROM TBL_SCORE ts
	WHERE SUBJECT = '국어';	

-- 3. '국어' 과목의 점수 합계
SELECT SUM(JUMSU) AS "국어 과목의 점수 합계" FROM TBL_SCORE ts
WHERE SUBJECT = '국어';

-- 4. '국어' 과목의 점수 평균. 소수점 이하 반올림
SELECT ROUND(AVG(JUMSU) , 0) AS "국어 과목의 점수 평균" FROM TBL_SCORE ts
-- SELECT ROUND(AVG(JUMSU)) AS "국어 과목의 점수 평균" FROM TBL_SCORE ts   ▶ 반올림하고자 하는 소수점 자리수가 0일때는 생략 가능
WHERE SUBJECT = '국어';

-- 5. 수강 점수 개수, 합계, 평균
SELECT JUMSU AS "수강 점수",
		COUNT(*) AS "수강 점수 개수",
		SUM(JUMSU) AS "수강 점수 합계",
		ROUND(AVG(JUMSU)) AS "수강 점수 평균"
		FROM TBL_SCORE ts
GROUP BY JUMSU
ORDER BY JUMSU;

-- 6. '학번' 2021019 의 수강 점수 개수, 합계, 평균
SELECT STUNO AS "학번",
		COUNT(*) AS "수강 점수 개수",
		SUM(JUMSU) AS "수강 점수 합계",
		ROUND(AVG(JUMSU)) AS "수강 점수 평균"
		FROM TBL_SCORE ts
WHERE STUNO = '2021019'
GROUP BY STUNO;

/*
	집계 함수는 그룹 함수라고도 한다.
	그룹화 - 행을 지정된 컬럼값을 동일한 것으로 한다.
			(집계함수는 그룹화하여 더 많이 사용한다)
			
	※ 그룹화의 기본 형식 - [] 는 생략 가능
	SELECT 그룹화 컬럼, 그룹 함수
	FROM 테이블 이름
	[WHERE] 그룹화 하기 이전의 조건식
	GROUP BY 그룹화에 사용할 컬럼명
	[HAVING] 그룹화 후에 사용하는 조건식
	[ORDER BY] 정렬 컬럼
*/

SELECT COUNT(*)
FROM TBL_SCORE ts
GROUP BY STUNO ;

SELECT STUNO, COUNT(*)
FROM TBL_SCORE ts
GROUP BY STUNO ;

/* 오류 : SUBJECT 는 그룹화에 사용한 컬럼이 아니다.
SELECT STUNO, SUBJECT, COUNT(*)
FROM TBL_SCORE ts
GROUP BY STUNO ;
*/

SELECT STUNO, SUBJECT, COUNT(*)
FROM TBL_SCORE ts
GROUP BY STUNO, SUBJECT ;	-- STUNO로 1차 그룹화하고, SUBJECT 가 같은 값들로 2차 그룹화

-- '학번'별로 수강 점수의 개수가 많은 순서부터 조회되도록 정렬해보세요.
SELECT
	STUNO AS "학번",
	COUNT(*) AS "점수의 개수"
FROM TBL_SCORE ts
GROUP BY STUNO
ORDER BY "점수의 개수" DESC;

-- '과목'별로 수강 점수의 개수가 많은 순서부터 조회되도록 정렬해보세요.
	-- 점수의 개수가 같다면 과목을 오름차순으로 정렬
SELECT
	SUBJECT AS "과목",			-- 조회한 컬럼만 2차 정렬 조건으로 할 수 있음
	COUNT(*) AS "수강 점수의 개수"
FROM TBL_SCORE ts
GROUP BY SUBJECT
ORDER BY "수강 점수의 개수" DESC , SUBJECT ;


-- ★ HAVING ★
-- '학번'별로 수강 점수의 개수가 2 이상인 것을 조회되도록 정렬해보세요.
SELECT
	STUNO AS "학번",
	COUNT(*) AS "점수의 개수"
FROM TBL_SCORE ts
GROUP BY STUNO
-- HAVING "점수의 개수" >=2	▶ 별칭을 조건으로 사용할 수 없다.
HAVING COUNT(*)  >=2
-- HAVING COUNT(*) >=2 AND STUNO != '20191001'	▶ AND 를 사용해 조건을 여러개 만들 수 있다.
ORDER BY "점수의 개수" DESC;


-- GROUP BY 하기전에 사용할 수 있는 조건식
SELECT 
	STUNO AS "학번",
	COUNT(*) AS "점수의 개수"
FROM TBL_SCORE ts
WHERE STUNO != '2021001'
GROUP BY STUNO
HAVING COUNT(*) >=2;



-- 문제 1) 학생별로 그룹화하여 학번, 개수, 평균을 조회합니다.
	-- 단, 평균이 80점 이상인 학생만 조회
---------- 테이블 확인용 -----------
SELECT * FROM TBL_STUDENT ts;
SELECT * FROM TBL_SCORE ts;
---------------------------------
SELECT STUNO, COUNT(*), AVG(JUMSU)
FROM TBL_SCORE ts
GROUP BY STUNO
HAVING AVG(JUMSU) >=80 ;

-- 문제 2) 1)번의 결과를 학생테이블과 JOIN하여 이름과 나이도 추가로 조회합니다.
SELECT TS.STUNO, GROUP_SCORE.STUCNT, GROUP_SCORE.STUAVG, NAME, AGE
FROM TBL_STUDENT ts
	JOIN (
		SELECT STUNO, COUNT(*) AS STUCNT, ROUND(AVG(JUMSU),1) AS STUAVG
		FROM TBL_SCORE ts
		GROUP BY STUNO
		HAVING AVG(JUMSU) >=80) GROUP_SCORE
	ON	TS.STUNO = GROUP_SCORE.STUNO;


-- 오라클은 서브쿼리로 사용될 조회 결과를 미리 저장시켜놓을 수 있다.
-- ▶ WITH 별칭 AS (서브쿼리)

WITH GROUP_SCORE
AS (
	SELECT STUNO, COUNT(*) AS STUCNT, ROUND(AVG(JUMSU),1) AS STUAVG
	FROM TBL_SCORE ts
	GROUP BY STUNO
	HAVING AVG(JUMSU) >=80
	)
SELECT TS.STUNO, GROUP_SCORE.STUCNT, GROUP_SCORE.STUAVG, NAME, AGE
FROM TBL_STUDENT ts JOIN GROUP_SCORE ON TS.STUNO = GROUP_SCORE.STUNO;

