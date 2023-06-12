/*
	< 06.07 오늘 수업할 내용 >
	1. 외래키 옵션
	2. 데이터베이스 테이블 데이터가 외부의 다른 형식 파일로 변경 가능합니다.
		데이터 가져오기와 내보내기
	3. 뷰 , 인덱스
	
	jdbc 후에 추가로 진도 나갈 내용 : 프로시저(함수) , 트리거 ▶ db 관리자 직종에서 사용
	
*/

----------------------------------------------------------------------------

/*
	[외래키 옵션]
	외래키로 참조관계가 설정이 되면 부모 테이블의 데이터가 삭제시 오류가 발생
	▶ 이걸 옵션으로 다른 동작을 하도록 할 수 있다.
*/

-- 외래키 옵션 테스트 테이블 생성 
	-- (서브쿼리 이용해서 SELECT 조회 결과를 복사해서 테이블 생성)
	-- 이때, PK 와 FK 는 복사가 되지 않으므로 직접 만들어줘야 한다.
CREATE TABLE TMP_STUDENT AS SELECT *  FROM TBL_STUDENT ts ;
CREATE TABLE TMP_SCORE AS SELECT * FROM TBL_SCORE ts ;

SELECT * FROM TMP_STUDENT;
SELECT * FROM TMP_SCORE;
-- 외래키 옵션 테스트를 위해서 기본키를 만듭니다. (기본키 여부 확인 필요) - ALTER TABLE 로 추가하기
	-- 외래키가 참조하는 부모 테이블의 컬럼은 PK 또는 UNIQUE 컬럼이어야 합니다.
ALTER TABLE TMP_STUDENT ADD CONSTRAINT STUDENT_PK PRIMARY KEY (STUNO);

ALTER TABLE TMP_SCORE ADD CONSTRAINT SCORE_PK PRIMARY KEY (STUNO,SUBJECT);

-- 외래키의 ON DELETE 옵션 3가지 테스트 하기

-- 1. 아무것도 설정 안하면 기본은 NO ACTION ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	-- 참조 관계를 설정할때 부모 테이블의 컬럼에 없는 데이터가 자식 테이블의 컬럼에 있을 경우 parent keys not found 오류가 발생하며 외래키 설정이 불가능하다.
ALTER TABLE TMP_SCORE ADD CONSTRAINT SCORE_FK FOREIGN KEY (STUNO) REFERENCES TMP_STUDENT(STUNO);
	
-- 참조하는 부모테이블의 행을 삭제하기 (조건식은 참조컬럼 사용)
DELETE FROM TMP_STUDENT ts WHERE STUNO = '2021017'; -- 오류 : 자식 테이블이 참조하고 있음.


-- 다른 옵션 테스트를 위해서 외래키 삭제하기
ALTER TABLE TMP_SCORE DROP CONSTRAINT SCORE_FK;


-- 2. CASCADE (계단식의) ▶ 부모 테이블을 참조하고 있는 자식 테이블의 '같은 값을 참조하고 있는'행을 삭제합니다 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ALTER TABLE TMP_SCORE ADD CONSTRAINT SCORE_FK FOREIGN KEY (STUNO) REFERENCES TMP_STUDENT(STUNO) ON DELETE CASCADE; -- ON DELETE 옵션 설정

-- 데이터 삭제 테스트 후 다시 살리기 위해 트랜잭션 모드는 Manual Commit 후 아래 코드 실행
DELETE FROM TMP_STUDENT ts WHERE STUNO = '2021017';
-- 위의 실행 결과로 STUDENT 와 SCORE 테이블 모두 2021017 행이 삭제됨
SELECT * FROM TMP_STUDENT ts ;
SELECT * FROM TMP_SCORE ts ;


-- 데이터 원상복구 (트랜잭션 모드를 통해)
ROLLBACK;


-- 3. SET NULL ▶ 외래키 컬럼이 기본키를 구성하는 컬럼. 즉, '식별관계'일때는 동작하지 못한다.━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
				-- ★ 비식별관계에서 외래키 컬럼이 NULL 허용이 된 경우에만 가능하다.
-- 참조관계를 '비식별관계'로 하기 위해 기본키 컬럼 추가 (기존 기본키 삭제하기)
ALTER TABLE TMP_SCORE ADD SCORE_NO NUMBER(5);
ALTER TABLE TMP_SCORE ADD CONSTRAINT SCORE_PK PRIMARY KEY (SCORE_NO);

-- ON DELETE 옵션 SET NULL 을 하려면 외래키 컬럼이 NULL 허용이 되어있는 상태여야 한다.
 -- 기존 외래키 삭제
ALTER TABLE TMP_SCORE DROP CONSTRAINT SCORE_FK;
 -- 외래키 옵션 변경
ALTER TABLE TMP_SCORE ADD CONSTRAINT SCORE_FK FOREIGN KEY (STUNO) REFERENCES TMP_STUDENT(STUNO) ON DELETE SET NULL; -- ON DELETE 옵션 설정

-- 데이터 삭제 테스트 후 다시 살리기 위해 트랜젝션 모드는 Manual Commit 후 아래 코드 실행
DELETE FROM TMP_STUDENT ts WHERE STUNO = '2021017';
-- 위의 실행 결과로 STUDENT 의 2021017 행이 삭제되었고, SCORE 의 기존 2021017 이 NULL 로 변환되었다.
SELECT * FROM TMP_STUDENT ts ;
SELECT * FROM TMP_SCORE ts ;

ROLLBACK;
COMMIT;
