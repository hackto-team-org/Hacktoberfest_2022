SET SERVEROUTPUT ON;

INSERT INTO student VALUES(1, 6, 'C', 'CSE', 'GREAT STUDENT');
INSERT INTO student VALUES(2, 8, 'A', 'ETC', 'POOR STUDENT');
INSERT INTO student VALUES(3, 5, 'C', 'EEE', 'POOR STUDENT');
INSERT INTO student VALUES(4, 3, 'D', 'EEE','');

SELECT DISTINCT DESCP as Description FROM STUDENT ;

--Concatenation Operator ||

SELECT SEM || '&' || SECTION AS CLASS FROM STUDENT;

--SYSTEM DATE

SELECT SYSDATE FROM STUDENT ;

SELECT S_ID, SECTION, BRANCH FROM STUDENT WHERE SEM NOT BETWEEN 5 AND 8 ;
SELECT S_ID, SECTION, BRANCH FROM STUDENT WHERE SEM NOT IN (5, 8) ;
SELECT S_ID, SECTION, BRANCH FROM STUDENT WHERE DESCP LIKE 'GREAT%' ;

--SINGLE ROW FUNCTIONS

SELECT LOWER(DESCP) FROM STUDENT;
SELECT INITCAP(DESCP) FROM STUDENT;
SELECT CONCAT(SECTION,DESCP)AS SEC_DESP FROM STUDENT;
SELECT LENGTH(DESCP) FROM STUDENT;
SELECT SUBSTR(DESCP, 4, 8   ) FROM STUDENT;
SELECT INSTR(DESCP,'R') FROM STUDENT;
SELECT TRIM(TRAILING 'T' FROM DESCP) FROM STUDENT;
SELECT LPAD(DESCP,18,'@') FROM STUDENT;
--SIMILARLY RPAD

SELECT ROUND(95.40) FROM DUAL;
SELECT TRUNC(65.34343, 3) FROM DUAL;
SELECT MOD(61,2) FROM DUAL;
SELECT NVL(DESCP, 0) FROM STUDENT;  --NULL VALUE LOGIC, SEARCH HOW NVL2...
SELECT MONTHS_BETWEEN('02-FEB-2022','01-FEB-2020') FROM DUAL;
SELECT NULLIF(100,100) FROM DUAL;
SELECT NULLIF(100,200) FROM DUAL;

--CHECK FOR TO_CHAR, TO_NUM,ETC

--MULTI ROW FUNCTIONS

SELECT COUNT(*) FROM STUDENT;

SELECT DISTINCT COUNT(BRANCH) FROM STUDENT;

-- COUNT, MAX, MIN, SUM, AVG


DESC STUDENT;



-- DATE - 3/04/22

CREATE TABLE STUDENT_INFO(
    S_NO NUMBER(10) PRIMARY KEY NOT NULL,
    S_NAME VARCHAR2(15) NOT NULL,
    GENDER VARCHAR2(10) NOT NULL,
    AGE NUMBER(5) NULL,
    MARKS NUMBER(10) NOT NULL
    );

DESC STUDENT_INFO;

--CLAUSES

--ORDER BY

SELECT * FROM STUDENT_INFO ORDER BY age desc;

--GROUP BY

SELECT AGE, MIN(MARKS) FROM STUDENT_INFO GROUP BY AGE; 

SELECT AGE, COUNT(AGE) FROM STUDENT_INFO WHERE AGE>=21 group by AGE;

select age, max(marks) from STUDENT_INFO having max(marks)>85 group by age;

select age, max(marks) from student_info where age>19 group by age having max(marks)>85 order by age asc;

--NESTED QUERY

select S_no,s_name,gender from student_info where MARKS>(select marks from student_info where s_name='RAVI');

select s_no,s_name from student_info where age=(select age from student_info where s_name='ARJUN');

select s_name, age from student_info where age=(SELECT age from student_info where s_name='RAM') and MARKS>(select marks from student_info where s_name='ANJUNA');

select s_name from student_info where s_no in(select s_id from student);

select s_name from student_info, student where student_info.S_NO = student.S_ID  ;

--JOINS

select * from student_info, student where student_info.S_NO=student.S_ID;
--or
select * from student_info s1 inner join student s2 on s1.S_NO=s2.S_ID;  --alias is used

select * from student_info s1 left join student s2 on s1.S_NO=s2.S_ID;  --left join also called left outer join

select * from student_info s1 right join student s2 on s1.S_NO=s2.S_ID;

select * from student_info s1 left join student s2 on s1.S_NO=s2.S_ID where marks>85;

select * from student_info natural join student where student_info.s_no = student.s_id;

--self join

select s1.s_name, s2.s_name from student_info s1, student_info s2 where s1.marks = s2.marks;

-- SQL commands

Create table demo(
    name varchar2(10),
    class number(10),
    sec varchar(10)
    );

Drop table demo;

DESC DEMO;

ALTER TABLE DEMO ADD(LOCATION VARCHAR2(20)); -- ADD NEW COLUMN

ALTER TABLE DEMO MODIFY(LOCATION VARCHAR2(40));--MODIFY EXISTING COLUMN

ALTER TABLE DEMO RENAME COLUMN LOCATION TO PLACE;

ALTER TABLE DEMO DROP COLUMN PLACE;

UPDATE DEMO SET PLACE='BHILAI' WHERE NAME='AMAN';

SELECT * FROM DEMO;

DELETE FROM DEMO WHERE NAME='MANISH';

SELECT * FROM USER_USERS;

SELECT * FROM DBA_USERS;

SELECT * FROM ALL_USERS;