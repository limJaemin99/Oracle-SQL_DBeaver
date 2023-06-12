
-- DML : 데이터 수정 , 삭제는 조건식으로 실행하도록 하는것이 기본입니다.
		-- 전체 행에 대해 수정 또는 삭제하는 것은 위험한 작업입니다.

-- UPDATE 테이블명 SET 컬럼명=변경될 값, 컬럼명=변경될 값, ... WHERE 조건식
-- 


SELECT * FROM TBL_MEMBER tm ;

UPDATE TBL_MEMBER
SET JOIN_DATE = SYSDATE
WHERE MNO = 9;	-- 예상 : 1개 행을 반영


UPDATE TBL_MEMBER
SET EMAIL = 'guest@koreait.kr'
WHERE EMAIL IS NULL;		-- 예상 : 2개 행을 반영
							-- NULL은 IS를 써줘야함 (등호 x)

UPDATE TBL_MEMBER
SET EMAIL = 'guest@koreait.kr' , MNO = 10	-- 2개의 컬럼을 값 수정
WHERE MNO = 9;	-- 예상 : 1개 행을 반영

DELETE FROM TBL_MEMBER tm
WHERE MNO = 3;


-- DML 명령중에 데이터 변경과 관련된 INSERT , UPDATE , DELETE 는 ROLLBACK 을 할 수 있습니다.
-- ROLLBACK은 실행된 데이터 입력, 수정, 삭제를 취소하는 명령 (트랜잭션 모드 autocommit을 OFF 일때만 가능)
-- COMMIT은 데이터 입력, 수정, 삭제를 최종 승인 (트랜잭션 모드 autocommit을 OFF 일때만 가능)


COMMIT;

-- 트랜잭션의 commit 을 테스트하는 순서

-- 1. 새로운 데이터 입력
INSERT INTO TBL_MEMBER VALUES (2,'박나연','parkny@gmail.com','2022-10-24');
INSERT INTO TBL_MEMBER VALUES (3,'최슬기','slgichoi@naver.com','2021-09-24');

-- 2. 디비버에서 조회하기
SELECT * FROM TBL_MEMBER tm;

-- 3. SQL Plus 는 다른 사용자 입니다. 다른 사용자가 조회하면 새로운 입력이 보이나요?
-- 이유는 데이터 입력한 디비버 사용자가 commit 을 안했습니다.

-- 4. 3번 상태에서 rollback
ROLLBACK;

-- 5. 다시 디비버에서 조회하기
SELECT * FROM TBL_MEMBER tm;

-- 6. 다시 입력 ▶ 디비버 조회 ▶ SQL Plue 조회 ▶ commit
INSERT INTO TBL_MEMBER VALUES (22,'박나연','parkny@gmail.com','2022-10-24');
INSERT INTO TBL_MEMBER VALUES (33,'최슬기','slgichoi@naver.com','2021-09-24');

SELECT * FROM TBL_MEMBER tm ;

COMMIT;

-- TRUNCATE TABLE 테이블명 : 모든 데이터 삭제는 ROLLBACK을 할 수 없다. (DDL)
-- DELETE FROM 테이블명 : 모든 데이터 삭제는 ROLLBACK을 할 수 있다. (DML)


/*
	INSERT		//a
	DELETE		//b
	COMMIT;		(1) 라인 a,b 물리저장공간에 반영
	UPDATE		//c
	DELEDE;		//d
	ROLLBACK;	(2) 라인 c,d만 취소합니다. (1)번의 commit 완료 이후부터
	INSERT;		//e
	INSERT;		//f
	ROLLBACK	(3) 라인 e,f만 취소합니다. (2)번의 ROLLBACK 이후부터
	INSERT		//g
	UPDATE;		//h
	COMMIT;		(4) 라인 g,h만 취소합니다. (3)번의 ROLLBACK 이후부터
	
	중간에 savepoint 를 실행하면 ROLLBACK 위치를 설정할 수 있습니다.
	
*/


