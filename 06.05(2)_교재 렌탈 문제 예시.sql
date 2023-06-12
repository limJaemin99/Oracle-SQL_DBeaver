

-- ★ 만약 ALTER TABLE 을 사용하지 않고 FK 를 생성하려면 테이블 생성 순서가 중요하다 ★
	-- ★ 즉, ALTER TABLE 을 사용하면 테이블 생성 순서와 관계가 없으므로 오류를 예방할 수 있다 ★


/* Create Tables */

CREATE TABLE Car
(
   car_no varchar2(7) NOT NULL,
   car_type varchar2(3) NOT NULL,
   car_last_check_date date,
   car_expire_date date,
   PRIMARY KEY (car_no)
);


CREATE TABLE contract
(
   contract_no number(7,0) NOT NULL,
   customer_no number(7,0) NOT NULL,
   car_no varchar2(7) NOT NULL,
   start_office_num number(3,0) NOT NULL,
   contract_startKm number(7,0) NOT NULL,
   end_office_num number(3,0) NOT NULL,
   contract_endKm number(7,0) NOT NULL,
   PRIMARY KEY (contract_no)
   -- 테이블 생성시 FORIGN KEY 생성하려면 테이블 고객, 차량, 사무소 테이블이 먼저 만들어져있어야 한다.
   -- FOREIGN KEY (CUSTOMER_NO) REFERENCES CUSTOMER(CUSTOMER_NO) -- 테이블 레벨 설정
);


CREATE TABLE Customer2
(
   customer_no number(7,0) NOT NULL,
   customer_id varchar2(100) NOT NULL UNIQUE,
   customer_type char(1) NOT NULL,
   contact varchar2(20) NOT NULL,
   address varchar2(50),
   PRIMARY KEY (customer_no)
);


CREATE TABLE office
(
   office_num number(3,0) NOT NULL,
   address varchar2(100) NOT NULL,
   phone varchar2(20) NOT NULL,
   PRIMARY KEY (office_num)
);



/* Create Foreign Keys */

-- 외래키를 테이블 레벨로 설정한 것. 보통은 컬럼 레벨로 설정하지 않는다.
ALTER TABLE contract
   ADD					-- 'CONTRACT 제약조건이름' 생략. 제약조건이름은 오라클이 만들어줍니다.
   FOREIGN KEY (car_no)
   REFERENCES Car (car_no)
;


ALTER TABLE contract
   ADD FOREIGN KEY (customer_no)
   REFERENCES customer2 (customer_no)
;


ALTER TABLE contract
   ADD FOREIGN KEY (start_office_num)
   REFERENCES office (office_num)
;


ALTER TABLE contract
   ADD FOREIGN KEY (end_office_num)
   REFERENCES office (office_num)
;