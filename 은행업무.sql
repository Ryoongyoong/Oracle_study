CREATE TABLE MEMBERS
(   
    MID          CHAR(6)      PRIMARY KEY,
    NAME          VARCHAR2(30)      NOT NULL
);

    INSERT INTO MEMBERS VALUES('M00001', '홍길동');
    INSERT INTO MEMBERS VALUES('M00002', '전우치');
    INSERT INTO MEMBERS VALUES('M00003', '신데렐라');
    INSERT INTO MEMBERS VALUES('M00004', '백설공주');
    
    SELECT * FROM MEMBERS;
    --COMMIT;


CREATE TABLE COUNTS
(
    C_NUMBER        VARCHAR2(10)        PRIMARY KEY,
    MID             CHAR(6)             NOT NULL,
    C_KID           VARCHAR(20)         NOT NULL
);

    INSERT INTO COUNTS VALUES('1234', 'M00001', '일반');
    INSERT INTO COUNTS VALUES('2345', 'M00001', '적금');
    INSERT INTO COUNTS VALUES('0987', 'M00002', '일반');
    INSERT INTO COUNTS VALUES('9876', 'M00002', '적금');
    INSERT INTO COUNTS VALUES('3333', 'M00003', '일반');

    SELECT * FROM COUNTS;
    -- COMMIT;



-- 입금
CREATE TABLE DEPOSIT
(
    D_IDX               INT               PRIMARY KEY,
    C_NUMBER          VARCHAR2(50)      NOT NULL,
    D_AMOUNT            NUMBER(20,2)      NOT NULL
);

-- 출금
CREATE TABLE WITHDRAW
(
    W_IDX               INT               PRIMARY KEY,
    C_NUMBER            VARCHAR2(50)      NOT NULL,
    W_AMOUNT            NUMBER(20,2)      NOT NULL
);

-- 입출금 테이블
CREATE TABLE INOUT
(
    IDX         INT                 PRIMARY KEY,
    C_NUMBER    VARCHAR2(10)        NOT NULL,
    AMOUNT      NUMBER(10, 2)       NOT NULL,
    GBN         CHAR(1)             NOT NULL -- I:입금, O:출금
);

SELECT * FROM INOUT;
SELECT * FROM DEPOSIT;

SELECT * FROM INOUT;


INSERT INTO INOUT
SELECT INOUT_SEQ.NEXTVAL, C_NUMBER, D_AMOUNT, 'I'
FROM DEPOSIT
;

INSERT INTO inout
SELECT INOUT_SEQ.NEXTVAL, C_NUMBER, D_AMOUNT, 'O'
FROM DEPOSIT;

-- COMMIT;
-- ROLLBACK;

SELECT INOUT_SEQ.NEXTVAL FROM DUAL;





-- 업무
-- 1. 홍길동이 10000원 1234 통장에 입금했습니다. -- 입금업무
SELECT * FROM DEPOSIT;

-- 2. 홍길동이 5000원 1234 통장에 입금했습니다. 
SELECT * FROM DEPOSIT;

-- 3. 전우치가 7000원 0987 통장에 입금했습니다.
SELECT * FROM DEPOSIT;

-- 4. 통장별로 돈이 얼마 있나 확인.
SELECT * FROM COUNTS
;

SELECT * 
FROM DEPOSIT;

SELECT * FROM WITHDRAW;


SELECT A.C_NUMBER, A.AMOUNT - B.AMOUNT AS REMAIN
FROM 
(
SELECT T1.C_NUMBER, SUM(NVL(T2.D_AMOUNT, 0)) AS AMOUNT
FROM COUNTS T1, DEPOSIT T2
WHERE T1.C_NUMBER = T2.C_NUMBER(+)
GROUP BY T1.C_NUMBER
) A, 
(
SELECT T1.C_NUMBER, SUM(NVL(T2.W_AMOUNT, 0)) AS AMOUNT
FROM COUNTS T1, WITHDRAW T2
WHERE T1.C_NUMBER = T2.C_NUMBER(+)
GROUP BY T1.C_NUMBER
) B
WHERE A.C_NUMBER = B.C_NUMBER;

--SET SERVEROUTPUT ON;


-- 각 통장별 잔고
SELECT * FROM COUNTS;
SELECT * FROM INOUT;

SELECT T1.C_NUMBER, 
    SUM(
        DECODE(T2.GBN, 'O', NVL(T2.AMOUNT, 0) * -1, NVL(T2.AMOUNT, 0))
    )
FROM COUNTS T1, INOUT T2
WHERE T1.C_NUMBER = T2.C_NUMBER(+)
GROUP BY T1.C_NUMBER;