--PLSqL Start (4/04/22)

SET SERVEROUTPUT ON;
DECLARE
    v_test VARCHAR2(15) := 'Hello World';
    v_marks NUMBER(5);
    
BEGIN
    DBMS_OUTPUT.PUT_LINE(v_test);
    v_test := 'Hi';
    DBMS_OUTPUT.PUT_LINE(v_test);
    
    SELECT marks INTO v_marks FROM STUDENT_INFO where S_NAME='RAM'; --Marks is a column in student_info table
    DBMS_OUTPUT.PUT_LINE(v_marks);
END;
-- '/' denotes the completion of a block
/

-- Starting with a fresh block
DECLARE
    v_marks NUMBER(5);
    v_name VARCHAR2(10); 
    v_gender VARCHAR2(10);
BEGIN
    SELECT s_name,gender,marks INTO v_name,v_gender,v_marks FROM STUDENT_INFO WHERE s_no=4;
    DBMS_OUTPUT.PUT_LINE(v_name || ' is a ' || v_gender || ' and has got ' || v_marks || ' marks.');
END;
/


--ANCHOR DATATYPE -> It automatically selects the datatype of column from a table and assigns it to the variable
--                   It also helps in syncing both column datatype and dclared variable                     
DECLARE 
    v_name student_info.s_name %TYPE;  --Automatically selects datatye and size from s_name
BEGIN
    SELECT s_name INTO v_name FROM student_info WHERE s_no =7;
    DBMS_OUTPUT.PUT_LINE(v_name);
END; 
/


--CONSTANTS -> Syntax - const_name CONSTANT dataype(size) := value
--             It must be initialized in declaration bloc only.

DECLARE
    v_pi CONSTANT NUMBER(3,2) :=3.14;
    v_g CONSTANT NUMBER(2,1) NOT NULL DEFAULT 9.8;
BEGIN
    DBMS_OUTPUT.PUT_LINE(v_pi);
    DBMS_OUTPUT.PUT_LINE(v_g);
END;
/


-- Bind Variables / Host Variables -> Variable that we create in sql*plus and then referenced in PL/SQL
-- It can be declared any where in host environment
-- It doesn't need any plsql block to be declared

VARIABLE v_bind1 VARCHAR2(10);

--Initialize bind variable using EXEC/EXECUTE command

EXECUTE :v_bind1 := 'Hello World';
--Method 2 of Initializing

BEGIN
    DBMS_OUTPUT.PUT_LINE(:v_bind1);
    :v_bind1 := 'HI';
    DBMS_OUTPUT.PUT_LINE(:v_bind1);
END;

--Printing using print, need not to be used inside any block
PRINT :v_bind1;
/
--Printing using autoprint

SET AUTOPRINT ON;   
VARIABLE v_bind2 VARCHAR2(30);
EXEC :v_bind2 := 'hello';

/

--CONDITIONAL STATEMENTS

--SIMPLE CASE

SHOW USER;

SELECT s_name,age,
(CASE s_no
WHEN 1 THEN 'CAMERA'
WHEN 3 THEN 'MOBILE'
WHEN 5 THEN 'TV'     -- OVERRIDING CYCLE
WHEN 5 THEN 'CYCLE'
ELSE 'SORRY'         -- ELSE IS OPTIONAL IF NOT USED, NULL IS RETURNED
END) AS product FROM student_info;
/

SELECT
(CASE 1
WHEN 1 THEN 'CAMERA'
WHEN 3 THEN 'MOBILE'
WHEN 5 THEN 'TV'     -- OVERRIDING CYCLE
WHEN 5 THEN 'CYCLE'
ELSE 'SORRY'         -- ELSE IS OPTIONAL IF NOT USED, NULL IS RETURNED
END)AS Gadgets FROM dual;
/

-- SEARCH CASE -> NO SEARCH KEY IS USED AFTER "CASE" KEYWORD

--USING LOGICAL OPERATOR

SELECT s_name,age,
(CASE
WHEN age=22 AND s_name='ARJUN' THEN 'S_NO 4'
WHEN age=22 AND s_name='KAVITHA' THEN 'S_NO 3'
ELSE 'SORRY'
END) AS S_NO FROM student_info;
/


SELECT s_name,age,
(CASE
WHEN age=22 AND s_name IS NOT NULL THEN 'S_NO 4'
WHEN age BETWEEN 21 AND 23 THEN 'S_NO 3'
WHEN age IN(20,21,23,25) THEN 'PASS'
ELSE 'SORRY'
END) AS RANDOM FROM student_info WHERE AGE> 21 OR MARKS >85;
/

--IF THEN

DECLARE
v_no NUMBER(4) := 11;

BEGIN
    IF v_no <10 THEN
        DBMS_OUTPUT.PUT_LINE('INSIDE IF');
    ELSIF v_no >10 THEN
        DBMS_OUTPUT.PUT_LINE('OUTSIDE IF');
    END IF;    
END;    
/


--LOOPS 

--1) SIMPLE LOOP/INFINITE LOOP

DECLARE 
    v_counter NUMBER :=0;
    v_result NUMBER;
BEGIN 
    LOOP
        v_counter := v_counter + 1;
        v_result := 15 * v_counter;
        DBMS_OUTPUT.PUT_LINE(v_result);
        --EXIT CONDITION
--        IF v_counter = 10 THEN        -- SINGLE = IS CHECKING CONDITION
--            EXIT;
--        END IF;
--        -- OR
        EXIT WHEN v_counter = 10;
    END LOOP;
END;


--2) WHILE LOOP
--SYNTAX - WHILE contition LOOP
--    ...
--    ...
--    END LOOP

--3) FOR LOOP

BEGIN
    FOR v_counter IN 1 .. 10 LOOP       --v_counter NEED NOT TO BE DECLARED
        DBMS_OUTPUT.PUT_LINE(v_counter);
    END LOOP;
END;    
/

--REVERSED PRINTING

BEGIN
    FOR v_counter IN REVERSE 1 .. 10 LOOP       --v_counter NEED NOT TO BE DECLARED
        DBMS_OUTPUT.PUT_LINE(v_counter);
    END LOOP;
END;
/


--TRIGGERS -> TRIGGERS ARE NAMED PLSQL BLOCKS WHICH ARE STORED IN DATABASE. THEY ARE 
--            SPECIALISED STORED PROGRAMS WHICH EXECUTE IMPLICITELY WHEN A TRIGGERING EVENT OCCURS.

-- EVENTS SUCH AS DML STATEMENTS, DDL STATEMENTS, SYSTEM EVENT,USER EVENT

--TYPES OF TRIGGERS
--    ->DML TRIGGERS
--    ->DDL TRIGGERS
--    ->SYSTEM EVENT TRIGGERS
--    ->INSTEAD-OF TRIGGERS
--    ->COMPOUND TRIGGERS



--                           DML TRIGGERS

CREATE OR REPLACE TRIGGER bi_students            
BEFORE INSERT ON student_info
FOR EACH ROW
ENABLE

DECLARE
    v_user VARCHAR(20);
BEGIN
    SELECT user INTO v_user FROM DUAL;
    DBMS_OUTPUT.PUT_LINE('You Just Inserted A Line Mr. '||v_user);
END; 
/   

INSERT INTO student_info VALUES(11, 'ROH', 'MALE', 12, 12);
/



CREATE OR REPLACE TRIGGER bu_student          
BEFORE UPDATE ON STUDENT
FOR EACH ROW
ENABLE
BEGIN
    UPDATE student_info SET MARKS = 12 WHERE MARKS =20; 
END;
/
UPDATE student SET section= 'E' WHERE section='A';
/



CREATE OR REPLACE TRIGGER tr_students         
BEFORE UPDATE OR INSERT OR DELETE ON student_info
FOR EACH ROW
DECLARE
    v_user VARCHAR(20);
BEGIN
    SELECT user INTO v_user FROM dual;
    IF INSERTING THEN
        DBMS_OUTPUT.PUT_LINE('ONE ROW INSERTED BY '||v_user);
    ELSIF DELETING THEN
        DBMS_OUTPUT.PUT_LINE('ONE ROW DELETED BY '||v_user);
    ELSIF UPDATING THEN
        DBMS_OUTPUT.PUT_LINE('ONE ROW UPDATED BY '||v_user);
    END IF;
END;    
/
UPDATE student SET s_name= 'ATUL' WHERE s_name='ROH';
/


/
-- Creating a dublicate table   

CREATE TABLE student_info_backup AS SELECT * FROM student_info WHERE 1=2;

/

-- CREATING TRIGGER TO BACKUP DATA EVERYTIME A ROW IS INSERTED IN ANOTHER BACKUP TABLE






CREATE OR REPLACE TRIGGER sh_backup
BEFORE INSERT OR DELETE OR UPDATE ON student_info
FOR EACH ROW
ENABLE 
DECLARE
    v_date VARCHAR(20);
BEGIN 
    SELECT TO_CHAR(sysdate, 'DD/MM/YYYY HH24:MI:SS') INTO v_date FROM DUAL;
    
    IF INSERTING THEN
        INSERT INTO student_info_backup(s_no,s_name,gender,age,marks,date_time,operation) VALUES(:NEW.s_no,:NEW.s_name,:NEW.gender,:NEW.age,:NEW.marks,v_date,'INSERT');
    ELSIF DELETING THEN
        DELETE FROM student_info_backup WHERE s_no = :OLD.s_no;
    ELSIF UPDATING THEN
        UPDATE student_info_backup SET s_name = :NEW.s_name,gender = :NEW.gender,date_time = v_date, operation = 'UPDATE'  WHERE s_name = :OLD.s_name AND gender = :OLD.gender;   
    END IF;
END;    
/

INSERT INTO student_info VALUES (12,'AMAN','MALE',58,100);

UPDATE student_info SET s_name='PRIYA', gender='FEMALE' WHERE s_name='AMAN' AND gender='MALE';

DELETE FROM student_info WHERE s_no=12;
/







-- CREATING A DATABASE EVENT TRIGGERS

CREATE TABLE sys_evnt_audit(
    event_type VARCHAR2(20),
    logon_date DATE,
    logon_time VARCHAR(20),
    logoff_date DATE,
    logoff_time VARCHAR(20)
    );
/

CREATE OR REPLACE TRIGGER sys_lgon_audit
AFTER LOGON ON SCHEMA
BEGIN
    INSERT INTO sys_evnt_audit VALUES(ora_sysevent, sysdate, TO_CHAR(sysdate, 'HH24:MI:SS'), NULL, NULL);
    COMMIT;
END;    
/

SELECT * FROM sys_evnt_audit;
DISC;
CONNECT SYSTEM/5210;




--                                  INSTEAD-OF TRIGGERS

--USING INSTEAD-OF TRIGGERS WE CAN CONTROL THE DEFAULT BEHAVIOUR OF INSERT, UPDATE, DELETE & MERGE OPERATIONS ON VIEWS BUT NOT ON TABLES.

-- CREATING A VIEW 

CREATE VIEW student_view AS SELECT s_name, branch FROM student_info, student;

SELECT * FROM student_view;

-- CREATING TRIGGER

CREATE OR REPLACE TRIGGER tr_io_insert
INSTEAD OF INSERT ON student_view
FOR EACH ROW
BEGIN 
    INSERT INTO student (s_id,sem,section,branch) VALUES(5,8,'C',:NEW.branch);
    INSERT INTO student_info (s_no,gender,marks,s_name) VALUES (13,'FEMALE',53,:NEW.s_name);
END;
/

INSERT INTO student_view VALUES('AMRITA', 'IT');

SELECT * FROM student_view;

/




--                                          CURSORS

-- CURSOR IS A POINTER TO A MEMORY AREA CALLED CONTEXT AREA
-- CONTEXT AREA IS A MEMORY REGION INSIDE THE PROCESS GLOBAL AREA OR PGA ASSIGNED TO HOLD THE STATEMENT ABOUT PROCESSING OF A SELECT STATEMENT OR DML STATEMENT
-- TYPES OF CURSORS - IMPLICIT AND EXPLICIT CURSORS

--EXPLICIT CURSORS ARE USER DEFINED AND IS CREATED FOR THE STATEMENTS WHICH RETURN MORE THAN ONE ROW    



DECLARE
    v_name VARCHAR2(30);
    --DECLARE A CURSOR
    CURSOR cur_student_info IS
    SELECT s_name FROM student_info WHERE marks BETWEEN 85 AND 95;
BEGIN
    OPEN cur_student_info;
    LOOP
        FETCH cur_student_info INTO v_name;
        DBMS_OUTPUT.PUT_LINE(v_name);
        EXIT WHEN cur_student_info %NOTFOUND;     --%NOTFOUND IS A BOOLEAN CURSOR ATTRIBUTE WHICH RETURNS TRUE WHEN PREVIOUS FETCH STATEMENT RETURN NO VALUE
    END LOOP;
    CLOSE cur_student_info;
END;
/
                                    --PARAMETERIZED CURSOR

DECLARE
    v_name VARCHAR2(20);
    v_s_no NUMBER(10);
    CURSOR cur_student_info(stu_id VARCHAR2) IS         --DON'T MENTION SIZE OF DATATYPE WHILE PASSING AS PARAMETER
    SELECT s_name, s_no FROM student_info WHERE s_no < stu_id;
BEGIN
    OPEN cur_student_info(9);
    LOOP
        FETCH cur_student_info INTO v_name, v_s_no;
        EXIT WHEN cur_student_info %NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_name ||' '|| v_s_no);
    END LOOP;
    CLOSE cur_student_info;
END;
/

                                    --CURSOR PARAMETER WITH DEFAULT VALUE



DECLARE
    v_name VARCHAR2(20);
    CURSOR cur_student_info(stu_id VARCHAR2 := 10) IS         --DON'T MENTION SIZE OF DATATYPE WHILE PASSING AS PARAMETER
    SELECT s_name FROM student_info WHERE s_no > stu_id;
BEGIN
    OPEN cur_student_info;
    LOOP
        FETCH cur_student_info INTO v_name;
        EXIT WHEN cur_student_info %NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_name);
    END LOOP;
    CLOSE cur_student_info;
END;
/



                                    --CURSOR FOR LOOP
                                    
--IT REMOVES THE BURDEN OF OPENING, FETCHING AND CLOSING THE CURSOR

DECLARE
    CURSOR cur_student_info(v_gender VARCHAR2 :='MALE') IS 
    SELECT s_name, age FROM student_info WHERE v_gender =gender;
BEGIN
    FOR L_INDEX IN cur_student_info('FEMALE')     --L_INDEX IS A RECORD DATATYPE
    LOOP
        DBMS_OUTPUT.PUT_LINE(L_INDEX.s_name || ' ' || L_INDEX.age);
    END LOOP;
END;    
/ 



                                -- SPECIAL DATATYPES
                                
                                -- RECORD DATATYPE
                    
--IT IS A SPECIAL DATATYPE WHICH CAN CONTAIN DIFFERENT DATATYPE SIMULTANEOUSLY
-- THERE ARE 3 TYPES OF RECORDS

--1) TABLE CURSOR RECORD
--2) CURSOR BASED RECORD
--3) USER DEFINED RECORD

-- %ROWTYPE IS USED TO DEFINE RECORD DATATYPE VARIABLE

                                    --TABLE CURSOR

DECLARE 
    v_stud student_info%ROWTYPE;                -- THIS PROGRAM WILL NOT RUN COZ %ROWTYPE VARIABLE CAN STORE ONLY ONE ROW BUT WE HAVE LOTS OF ROWS
BEGIN                                         
        SELECT * INTO v_stud FROM student_info WHERE s_no > 6;
        DBMS_OUTPUT.PUT_LINE(v_stud.s_no);
END;
/



DECLARE 
    v_stud student_info%ROWTYPE;
BEGIN                                         -- THIS PROGRAM WILL NOT RUN COZ %ROWTYPE VARIABLE CAN STORE ONLY ONE ROW BUT WE HAVE LOTS OF ROWS
        SELECT s_name, age INTO v_stud.s_name, v_stud.age FROM student_info WHERE s_no > 6;   
        DBMS_OUTPUT.PUT_LINE(v_stud.s_name, v_stud.age);
END;
/




CREATE TABLE birds(
    name VARCHAR2(20),
    type VARCHAR(20)
    );
    
INSERT INTO birds VALUES('SPARROW', 'FLYING');

/

DECLARE
    v_bird birds%ROWTYPE;                       -- THIS PROGRAM WILL RUN COZ WE HAVE ONLY ONE ROW
BEGIN
    SELECT * INTO v_bird FROM birds;
    DBMS_OUTPUT.PUT_LINE(v_bird.name || ' ' || v_bird.type);
END;
/





                                    --CURSOR BASED RECORD

DECLARE
    CURSOR cur_student_info IS
    SELECT s_name, age FROM student_info WHERE gender='FEMALE' OR s_no > 8 ;
    
    var_stud cur_student_info %ROWTYPE;
BEGIN
    OPEN cur_student_info;
    LOOP
        FETCH cur_student_info INTO var_stud;
        EXIT WHEN cur_student_info %NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(var_stud.s_name || ' '|| var_stud.age);    
    END LOOP;
    CLOSE cur_student_info;
END;
/
-- OR USING CURSOR FOR LOOP

DECLARE
    CURSOR cur_student_info IS
    SELECT s_name, age FROM student_info WHERE gender='FEMALE' OR s_no > 8 ;
    
BEGIN
    FOR var_stud IN cur_student_info
    LOOP
        DBMS_OUTPUT.PUT_LINE(var_stud.s_name || ' '|| var_stud.age);
    END LOOP;
END;
/



                                --USER DEFINED RECORD DATATYPE VARIABLE
                                
DECLARE
    TYPE stud_info IS RECORD(             --THIS WILL NOT RUN, THERE IS SOME ERROR
    v_name VARCHAR2(20),
    v_sem  STUDENT.sem %TYPE,
    v_operation STUDENT_INFO_BACKUP.operation %TYPE,
    v_date_time VARCHAR2(20)
    );
    var1  stud_info;
BEGIN
    SELECT TO_CHAR(sysdate, 'DD/MM/YYYY HH24:MI:SS') INTO var1.v_date_time FROM DUAL;
    
    SELECT s_name, sem, operation INTO var1.v_name, var1.v_sem, var1.v_operation 
    FROM student_info s1 JOIN student s2 ON s1.s_no = s2.s_id JOIN student_info_backup s3 
    ON s1.s_no = s3.s_no;
    
    DBMS_OUTPUT.PUT_LINE(var1.v_name || ' ' || var1.v_sem || ' ' || var1.v_operation || ' ' || var1.v_date_time);
END;
/


                                --PL/SQL FUNCTIONS (TYPE OF NAMED BLOCK)

CREATE OR REPLACE FUNCTION circle_area(radius NUMBER)
RETURN NUMBER IS 
    pi CONSTANT NUMBER(7,3) := 3.141;
    area NUMBER(7,3);

BEGIN
    --AREA OF CIRCLE
    area := pi * (radius*radius);
    RETURN area;
END;
/

DECLARE
    v_area NUMBER(7,3);
BEGIN
    v_area:= circle_area(25);
    DBMS_OUTPUT.PUT_LINE(v_area);
END;
/



                                    --PROCEDURES

-- SAME AS FUNCTIONS, USED TO PERFORM A SPECIFIC SUB TASK.
-- DIFFERENCE IS PROCEDURES RETURN NOTHING.


CREATE OR REPLACE PROCEDURE pr_sam IS
    v_name VARCHAR2(20) := 'SAM_NY';
    v_place VARCHAR(20) := 'BHILAI';

BEGIN 
    DBMS_OUTPUT.PUT_LINE('HI, I AM ' || v_name || ' FROM ' || v_place);
END pr_sam;
/


EXEC pr_sam;

/


CREATE OR REPLACE PROCEDURE pr_sam(stu_name VARCHAR2, stu_gender VARCHAR2) IS
    v_date VARCHAR2(30);

BEGIN
    SELECT TO_CHAR(sysdate, 'DD/MM/YYYY HH24:MI:SS') INTO v_date FROM DUAL;
    UPDATE student_info_backup SET date_time=v_date, operation='UPDATE' WHERE s_name=stu_name AND gender=stu_gender;
    DBMS_OUTPUT.PUT_LINE('UPDATED SUCCESSFULLY');
END pr_sam;
/

EXEC pr_sam('MANISHA', 'FEMALE');

/

                --PROGRAM TO FIND THE 3RD ELDEST PERSON WITH THEIR AGE FROM STUDENT_INFO

CREATE OR REPLACE PROCEDURE pr_third_high IS
    v_age student_info.age %TYPE;
    v_name student_info.s_name %TYPE;

BEGIN
   -- SELECT s_name, age INTO v_name,v_age FROM student_info WHERE age = (SELECT MIN(age) FROM student_info WHERE sal IN( SELECT DISTINCT TOP 3 age FROM student_info ORDER BY age DESC));
    DBMS_OUTPUT.PUT_LINE(v_name||' '||v_age);
END;
/

EXEC pr_third_high;


                        --CALLING NOTATIONS IN PLSQL
--1)POSITIONAL NOTATION
--2)NAMED NOTATION
--3)MIXED CALLING NOTATION


                        --POSITIONAL NOTATION - ALREADY DONE ABOVE
                        
                        --NAMED CALLING NOTATION
                        
CREATE OR REPLACE FUNCTION fn_sum(var1 NUMBER, var2 NUMBER DEFAULT 0, var3 NUMBER) 
RETURN NUMBER IS

BEGIN
    RETURN var1 +var2+var3;
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE(fn_sum(var3 => 12 ,var1 => 23));
END;
/




                                    --PL/SQL PACKAGE

-- IT IS NAMED BLOCK THAT IS PERMANENTLY STORED AND CAN BE USED LATER. IT CAN CONTAIN VARIOUS DATATYPES AND NAMED BLOCKS.

--PKG SPECIFICATION OR HEADER

CREATE OR REPLACE PACKAGE pkg_student IS
    
    FUNCTION prnt_strng RETURN VARCHAR2;
    PROCEDURE stud_insert(v_id NUMBER, v_sem NUMBER, v_sec VARCHAR2, v_branch VARCHAR2, v_descp VARCHAR2);
END pkg_student;
/


--PKG BODY 


CREATE OR REPLACE PACKAGE BODY pkg_student IS
    
    --FUNCTION IMPLEMENTATION
    FUNCTION prnt_strng RETURN VARCHAR2 IS
        BEGIN
            RETURN 'HELLO WORLD';
        END prnt_strng;
    
    --PROCEDURE DEFINITION
    PROCEDURE stud_insert(v_id NUMBER, v_sem NUMBER, v_sec VARCHAR2, v_branch VARCHAR2, v_descp VARCHAR2) IS
        BEGIN
            INSERT INTO student VALUES(v_id, v_sem, v_sec, v_branch, v_descp);
        END stud_insert;

END pkg_student;
/
     
     
--CALLING PACKAGE ELEMENTS

BEGIN
    DBMS_OUTPUT.PUT_LINE(pkg_student.prnt_strng);
    
    pkg_student.stud_insert(6,3,'A','MECH','GOOD STUDENT');
END;
/



                                    --EXCEPTION HANDLING
                                    
--USER-DEFINED EXCEPTION HANDLING

DECLARE
    var_divident  NUMBER:= 24;
    var_divisor   NUMBER:= 0;
    var_result    NUMBER;
    ex_divzero    EXCEPTION;

BEGIN
    IF var_divisor = 0 THEN
        RAISE ex_divzero;
    END IF;
    
    var_result := var_divident/var_divisor;
    DBMS_OUTPUT.PUT_LINE(var_result);
    
    EXCEPTION WHEN ex_divzero THEN
        DBMS_OUTPUT.PUT_LINE('ERROR, YOUR DIVISOR IS ZERO');
END;
/



-- TAKING INPUT FROM USER USING 'ACCEPT' COMMAND

ACCEPT var_age NUMBER PROMPT 'WHAT IS YOUR AGE?';

DECLARE
    age NUMBER := &var_age;
BEGIN
    IF age<18 THEN
        --RAISE_APPLICATION_ERROR
        RAISE_APPLICATION_ERROR(-20010, 'YOU SHOULD BE 18 OR ABOVE FOR DRIVING');    --ERROR NO COULD BE ANYTHING BETWEEN -20000 TO -20999
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('WHICH CAR YOU WANNA DRIVE?');
    
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);             --SQLERRM IS A UTILITY FUNCTION WHICH
                                                   --TRACES ERROR MSG FOR LAST OCCCRED ERROR        
END;
/




                                --PRAGMA EXCEPTION HANDLER

--USING PRAGMA EXCEPTION_INIT WE CAN ASSOCIATE AN EXCEPTION NAME WITH AN ORACLE ERROR NUMBER


ACCEPT stu_id NUMBER PROMPT 'WHAT IS YOUR STUDENT ID?';
ACCEPT stu_sem NUMBER PROMPT 'WHICH SEMESTER YOU ARE IN?';
ACCEPT stu_sec VARCHAR2 PROMPT 'WHICH SECTION YOU STUDY IN?';
ACCEPT stu_bran VARCHAR2 PROMPT 'WHAT IS YOUR BRANCH?';

DECLARE
    excep  EXCEPTION;      --IT WILL NOT ACT AS USER DEFINED FUNC BUT ACT AS NAME TO ERROR NO.
    stu_id NUMBER := &stu_id;
    stu_sem NUMBER := &stu_sem;
    stu_sec VARCHAR2(20) := '&stu_sec';
    stu_bran VARCHAR2(20) := '&stu_bran';
    stu_id_check student.s_id%TYPE;
    
    PRAGMA EXCEPTION_INIT(excep, -20010);

BEGIN
    SELECT s_id INTO stu_id_check FROM student WHERE stu_id IN(s_id);
    
    IF stu_id_check IS NOT NULL THEN
        RAISE_APPLICATION_ERROR(-20010,'SORRY YOUR S_ID IS ALREADY PRESENT IN TABLE');
    END IF;
    
    INSERT INTO student(s_id, sem, section, branch) VALUES(stu_id, stu_sem, stu_sec, stu_bran);
    
    EXCEPTION WHEN excep THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

