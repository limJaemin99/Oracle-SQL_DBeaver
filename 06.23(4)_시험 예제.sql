
-- 테이블명 : bookmember
CREATE TABLE bookmember(
	mem_idx number(5,0) PRIMARY KEY,
	name varchar2(20) NOT NULL,
	email varchar2(20) NOT NULL UNIQUE,
	tel varchar2(20),
	password varchar2(10)
);

CREATE SEQUENCE memidx_seq START WITH 10001;

INSERT INTO BOOKMEMBER VALUES (memidx_seq.nextval,'이하니','honey@naver.com','010-9889-0567','1122');
INSERT INTO BOOKMEMBER VALUES (memidx_seq.nextval,'이세종','jong@daum.net','010-2354-6773','2345');
INSERT INTO BOOKMEMBER VALUES (memidx_seq.nextval,'최행운','lucky@korea.com','010-5467-8792','9876');
INSERT INTO BOOKMEMBER VALUES (memidx_seq.nextval,'나길동','nadong@kkk.net','010-3456-8765','3456');
INSERT INTO BOOKMEMBER VALUES (memidx_seq.nextval,'강감찬','haha@korea.net','010-3987-9087','1234');
--------------------------
SELECT * FROM BOOKMEMBER;
--------------------------

-- 테이블명 : books
CREATE TABLE books(
	bcode char(5) PRIMARY KEY,
	title varchar2(30) NOT NULL,
	writer varchar2(20) NOT NULL,
	publisher varchar2(20),
	pdate date
);

INSERT INTO BOOKS VALUES ('A1101','코스모스','칼세이건','사이언스북스','2006-12-01');
INSERT INTO BOOKS VALUES ('B1101','해커스토익','이해커','해커스랩','2018-07-10');
INSERT INTO BOOKS VALUES ('C1101','푸른사자 와니니','이현','창비','2015-06-20');
INSERT INTO BOOKS VALUES ('A1102','페스트','알베르트 까뮈','민음사','2011-03-01');
--------------------------
SELECT * FROM BOOKS;
--------------------------

-- 테이블명 : bookrent
CREATE TABLE bookrent(
	rent_no number(5,0) PRIMARY KEY,
	mem_idx number(5,0) NOT NULL,
	bcode char(5) NOT NULL,
	rent_date DATE NOT NULL,
	exp_date DATE NOT NULL,
	return_date DATE,
	delay_days NUMBER(3,0)
);

CREATE SEQUENCE rentno_seq START WITH 1;

DROP SEQUENCE rentno_seq;

INSERT INTO BOOKRENT VALUES (rentno_seq.nextval,10001,'B1101',to_date('2023-05-01 14:22','yyyy-mm-dd hh24:mi'),'2023-05-15',to_date('2023-05-14 11:30','yyyy-mm-dd hh24:mi'), -1);
INSERT INTO BOOKRENT VALUES (rentno_seq.nextval,10002,'C1101',to_date('2023-06-12 17:04','yyyy-mm-dd hh24:mi'),'2023-06-25',null,null);
INSERT INTO BOOKRENT VALUES (rentno_seq.nextval,10003,'B1101',to_date('2023-06-03 10:15','yyyy-mm-dd hh24:mi'),'2023-06-17',to_date('2023-06-17 11:33','yyyy-mm-dd hh24:mi'),0);
INSERT INTO BOOKRENT VALUES (rentno_seq.nextval,10004,'C1101',to_date('2023-04-03 13:34','yyyy-mm-dd hh24:mi'),'2023-04-17',to_date('2023-04-15 14:20','yyyy-mm-dd hh24:mi'),-2);
INSERT INTO BOOKRENT VALUES (rentno_seq.nextval,10001,'A1101',to_date('2023-06-16 11:11','yyyy-mm-dd hh24:mi'),'2023-06-30',null,null);
INSERT INTO BOOKRENT VALUES (rentno_seq.nextval,10003,'A1102',to_date('2023-06-17 11:41','yyyy-mm-dd hh24:mi'),'2023-07-01',null,null);
INSERT INTO BOOKRENT VALUES (rentno_seq.nextval,10002,'A1101',to_date('2023-05-15 13:42','yyyy-mm-dd hh24:mi'),'2023-05-29',to_date('2023-05-30 12:42','yyyy-mm-dd hh24:mi'),1);
-- 시,분,초가 있을 경우 to_date 말고 timestamp 가 더 효율적이다. (그러나, 정확한건 to_date가 맞음)
-- INSERT INTO BOOKRENT VALUES (rentno_seq.nextval,memidx2_seq.nextval,'A1101',timestamp '2023-05-15 13:42','2023-05-29',timestamp '2023-05-30 12:42',1);

--------------------------
SELECT * FROM BOOKRENT;
--------------------------

ALTER TABLE BOOKRENT ADD CONSTRAINT memidx_fk FOREIGN KEY (mem_idx) REFERENCES bookmember;
ALTER TABLE BOOKRENT ADD CONSTRAINT bcode_fk FOREIGN KEY (bcode) REFERENCES books;

/*
	★아래 요구사항을 참고하세요★
	- 회원은 1회 1권의 책을 대여합니다. 동일한 코드의 책을 2번 이상 대여할 수 없습니다.
	- 반납기한날짜는 대여날짜+14 일로 자동 저장됩니다.
	- 반납 날짜가 null 이면 아직 반납을 하지 않은 상태 입니다.
	- 반납을 하면 연체일을 계산하여 저장합니다.
 */

-- 시험에 나옴 ▶ 일수 계산하는 문제(select에서) ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★

-- 연체일수 정수 OR 소수점
UPDATE BOOKRENT SET delay_days = trunc(return_date) - exp_date;	-- 정수(trunc로 버려서 일 단위 계산)
UPDATE BOOKRENT SET delay_days = return_date - exp_date;	-- 정수(반올림됨)

SELECT return_date - exp_date FROM BOOKRENT;				-- 소수점

SELECT * FROM BOOKRENT;

--★★★
/*
	★★★ rownum
	★ union all
	★★★ minus
	★★★ join
	★ 서브쿼리
*/



UPDATE BOOKRENT SET return_date = SYSDATE WHERE mem_idx = 10002;

SELECT * FROM BOOKRENT;

UPDATE BOOKRENT SET delay_days = trunc(return_date) - exp_date;

-----------------------------★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
SELECT rownum, customid, buy_count	-- 아래 서브쿼리 () 조회결과에 대한 rownum 을 조건식으로 사용하기.
FROM (
	SELECT customid, count(*) buy_count
	FROM TBL_BUY tb 
	GROUP BY CUSTOMID
	ORDER BY buy_count desc
);
--WHERE rownum = 1;
-- rownum에 사용할 수 있는 연산은 >= , <= , > , < , BETWEEN , rownum = 1 (1이외의 다른 값은 동작 오류) ★★★★★★★★★★★★★★★★★★★

-- 오라클은 조회된 행에 순서대로 번호를 부여하여 rownum 컬럼에 저장한다.
SELECT rownum, buy_seq, customid, quantity FROM TBL_BUY tb 	-- rownum 은 ORDER BY 하기전의 rownum
ORDER BY QUANTITY DESC;



UPDATE bookrent SET RETURN_date= to_timestamp('2023-06-26 12:30') WHERE rent_no = 2;

-- 1. '해커스토익' 책이 대여된 횟수를 구하시오
SELECT bcode, title , total
FROM books JOIN (SELECT bcode, count(*) AS total
					FROM BOOKRENT
					GROUP BY bcode)
using(bcode)
WHERE bcode = 'B1101';

-- 2. '나길동' 회원이 대여한 책의 이름을 출력
--(1) '나길동' 회원의 
SELECT mem_idx, name
FROM BOOKMEMBER
WHERE name = '나길동';

SELECT name, mem_idx, bcode
FROM BOOKRENT JOIN (SELECT mem_idx, name
					FROM BOOKMEMBER
					WHERE name = '나길동')
USING (mem_idx);

