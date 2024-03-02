/*
Consider the schema for College Database:
STUDENT (USN, SName, Address, Phone, Gender)
SEMSEC (SSID, Sem, Sec)
CLASS (USN, SSID)
SUBJECT (Subcode, Title, Sem, Credits)
IAMARKS (USN, Subcode, SSID, Test1, Test2, Test3, FinalIA)

Write SQL queries to:
a. List all the student details studying in fourth semester 'C' section.
b. Compute the total number of male and female students in each semester and in each section.
c. Create a view of Test1 marks of student USN '1BI15CS101' in all subjects.
d. Calculate the FinalIA (average of best two test marks) and update the corresponding table for all students.
e. Categorize students based on the following criterion:
    If FinalIA = 17 to 20 then CAT = 'Outstanding'
    If FinalIA = 12 to 16 then CAT = 'Average'
    If FinalIA < 12 then CAT = 'Weak'
    Give these details only for 8th semester A, B, and C section students.
*/

-- STEP 1: CREATE DATABASE
CREATE DATABASE COLLEGEDB;
USE COLLEGEDB;

-- STEP 2: CREATE TABLES
CREATE TABLE STUDENT(
    USN VARCHAR(10) PRIMARY KEY,
    SNAME VARCHAR(25),
    ADDRESS VARCHAR(25),
    PHONE INTEGER,
    GENDER CHAR(1)
);
CREATE TABLE SEMSEC(
    SSID VARCHAR(5) PRIMARY KEY,
    SEM INTEGER,
    SEC CHAR(1)
); 
CREATE TABLE CLASS(
    USN VARCHAR(10) PRIMARY KEY,
    SSID VARCHAR(5),
    FOREIGN KEY(USN) REFERENCES STUDENT(USN),
    FOREIGN KEY(SSID) REFERENCES SEMSEC(SSID)
); 
CREATE TABLE SUBJECT(
    SUBCODE VARCHAR(8) PRIMARY KEY,
    TITLE VARCHAR(20),
    SEM INTEGER,
    CREDITS INTEGER
);
CREATE TABLE IAMARKS(
    USN VARCHAR(10),
    SUBCODE VARCHAR(8),
    SSID VARCHAR(5),
    TEST1 INTEGER,
    TEST2 INTEGER,
    TEST3 INTEGER,
    FINALIA INTEGER,
    PRIMARY KEY(SUBCODE, USN, SSID),
    FOREIGN KEY(USN) REFERENCES STUDENT(USN),
    FOREIGN KEY(SUBCODE) REFERENCES SUBJECT(SUBCODE),
    FOREIGN KEY(SSID) REFERENCES SEMSEC(SSID)
);

-- STEP 3: INSERT VALUES INTO TABLES
INSERT INTO STUDENT VALUES 
    ('1DT13CS020','ANAND','BELAGAVI', 1233423,'M'),
    ('1DT13CS062','BABIITHA','BENGALURU',43123,'F'),
    ('1DT15CS101','CHETHAN','BENGALURU', 534234,'M'),
    ('1DT13CS066','DIVYA','MANGALURU',534432,'F'),
    ('1DT14CS010','EESHA','BENGALURU', 345456,'F'),
    ('1DT14CS032','GANESH','BENGALURU',574532,'M'),
    ('1DT14CS025','HARISH','BENGALURU', 235464,'M'),
    ('1DT15CS011','ISHA','TUMKUR', 764343,'F'),
    ('1DT15CS029','JOEY','DAVANGERE', 235653,'M'),
    ('1DT15CS045','KAVYA','BELLARY', 865434,'F'),
    ('1DT15CS091','MALINI','MANGALURU',235464,'F'),
    ('1DT16CS045','NEEL','KALBURGI', 856453,'M'),
    ('1DT16CS088','PARTHA','SHIMOGA', 234546,'M'),
    ('1DT16CS122','REEMA','CHIKAMAGALUR', 853333,'F')
;
INSERT INTO SEMSEC VALUES 
    ('CSE8A', 8,'A'),
    ('CSE8B', 8,'B'),
    ('CSE8C', 8,'C'),
    ('CSE7A', 7,'A'),
    ('CSE7B', 7,'B'),
    ('CSE7C', 7,'C'),
    ('CSE6A', 6,'A'),
    ('CSE6B', 6,'B'),
    ('CSE6C', 6,'C'),
    ('CSE5A', 5,'A'),
    ('CSE5B', 5,'B'),
    ('CSE5C', 5,'C'),
    ('CSE4A', 4,'A'),
    ('CSE4B', 4,'B'),
    ('CSE4C', 4,'C'),
    ('CSE3A', 3,'A'),
    ('CSE3B', 3,'B'),
    ('CSE3C', 3,'C'),
    ('CSE2A', 2,'A'),
    ('CSE2B', 2,'B'),
    ('CSE2C', 2,'C'),
    ('CSE1A', 1,'A'),
    ('CSE1B', 1,'B'),
    ('CSE1C', 1,'C')
;
INSERT INTO CLASS VALUES 
    ('1DT13CS020','CSE8A'),
    ('1DT13CS062','CSE8A'),
    ('1DT13CS066','CSE8B'),
    ('1DT15CS101','CSE8C'),
    ('1DT14CS010','CSE7A'),
    ('1DT14CS025','CSE7A'),
    ('1DT14CS032','CSE7A'),
    ('1DT15CS011','CSE4A'),
    ('1DT15CS029','CSE4A'),
    ('1DT15CS045','CSE4B'),
    ('1DT15CS091','CSE4C'),
    ('1DT16CS045','CSE3A'),
    ('1DT16CS088','CSE3B'),
    ('1DT16CS122','CSE3C')
;
INSERT INTO SUBJECT VALUES 
    ('10CS81','ACA', 8, 4),
    ('10CS82','SSM', 8, 4),
    ('10CS83','NM', 8, 4),
    ('10CS84','CC', 8, 4),
    ('10CS85','PW', 8, 4),
    ('10CS71','OOAD', 7, 4),
    ('10CS72','ECS', 7, 4),
    ('10CS73','PTW', 7, 4),
    ('10CS74','DWDM', 7, 4),
    ('10CS75','JAVA', 7, 4),
    ('10CS76','SAN', 7, 4),
    ('15CS51','ME', 5, 4),
    ('15CS52','CN', 5, 4),
    ('15CS53','DBMS', 5, 4),
    ('15CS54','ATC', 5, 4),
    ('15CS55','JAVA', 5, 3),
    ('15CS56','AI', 5, 3),
    ('15CS41','M4', 4, 4),
    ('15CS42','SE', 4, 4),
    ('15CS43','DAA', 4, 4),
    ('15CS44','MPMC', 4, 4),
    ('15CS45','OOC', 4, 3),
    ('15CS46','DC', 4, 3),
    ('15CS31','M3', 3, 4),
    ('15CS32','ADE', 3, 4),
    ('15CS33','DSA', 3, 4),
    ('15CS34','CO', 3, 4),
    ('15CS35','USP', 3, 3),
    ('15CS36','DMS', 3, 3)
;
INSERT INTO IAMARKS (USN, SUBCODE, SSID, TEST1, TEST2, TEST3) VALUES 
    ('1DT15CS101','10CS81','CSE8C', 15, 16, 18),
    ('1DT15CS101','10CS82','CSE8C', 12, 19, 14),
    ('1DT15CS101','10CS83','CSE8C', 19, 15, 20),
    ('1DT15CS101','10CS84','CSE8C', 20, 16, 19),
    ('1DT15CS101','10CS85','CSE8C', 15, 15, 12)
;

-- STEP 4: DISPLAY TABLES
SELECT * FROM STUDENT;
SELECT * FROM SEMSEC;
SELECT * FROM CLASS;
SELECT * FROM SUBJECT;
SELECT * FROM IAMARKS;

-- STEP 5: QUERIES

-- a. List all the student details studying in fourth semester 'C' section.
SELECT S.*, SS.SEM, SS.SEC 
FROM STUDENT S, SEMSEC SS, CLASS C 
WHERE S.USN = C.USN 
AND SS.SSID = C.SSID 
AND SS.SEM = 4 
AND SS.SEC = 'C'; 

-- b. Compute the total number of male and female students in each semester and in each section.
SELECT SS.SEM, SS.SEC, S.GENDER, COUNT(S.GENDER) AS COUNT 
FROM STUDENT S, SEMSEC SS, CLASS C 
WHERE S.USN = C.USN AND SS.SSID = C.SSID 
GROUP BY SS.SEM, SS.SEC, S.GENDER 
ORDER BY SEM;

-- c. Create a view of Test1 marks of student USN '1BI15CS101' in all subjects.
CREATE VIEW TEST1_VIEW AS
SELECT S.USN, S.SNAME, I.SUBCODE, I.TEST1
FROM STUDENT S, IAMARKS I
WHERE S.USN = I.USN
AND S.USN = '1DT15CS101';
SELECT * FROM TEST1_VIEW;

-- d. Calculate the FinalIA (average of best two test marks) and update the corresponding table for all students.
DELIMITER //
CREATE PROCEDURE AVG_MARKS()
BEGIN
	DECLARE C_A INTEGER;
	DECLARE C_B INTEGER;
	DECLARE C_C INTEGER;
	DECLARE C_SUM INTEGER;
	DECLARE C_AVG INTEGER;
	DECLARE C_USN VARCHAR(10);
	DECLARE C_SUBCODE VARCHAR(8);
	DECLARE C_SSID VARCHAR(5);
	DECLARE done INT DEFAULT FALSE;
	DECLARE C_IAMARKS CURSOR FOR
		SELECT TEST1, TEST2, TEST3, USN, SUBCODE, SSID
		FROM IAMARKS;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	OPEN C_IAMARKS;
		read_loop: LOOP
			FETCH C_IAMARKS INTO C_A, C_B, C_C, C_USN, C_SUBCODE, C_SSID;
			IF done THEN
				LEAVE read_loop;
			END IF;
			IF (C_A <= C_B AND C_A <= C_C) THEN
				SET C_SUM = C_C+C_B;
			ELSEIF (C_B <= C_A AND C_B <= C_C) THEN
				SET C_SUM = C_A+C_C;
			ELSE 
				SET C_SUM = C_A + C_B;
			END IF;
			SET C_AVG = C_SUM/2;
			UPDATE IAMARKS SET FINALIA = C_AVG
			WHERE USN = C_USN AND SUBCODE = C_SUBCODE AND SSID = C_SSID;
		END LOOP;
	CLOSE C_IAMARKS;
    SELECT * FROM IAMARKS;
END //
DELIMITER ;
CALL AVG_MARKS();

-- e. Categorize students based on the following criterion:
--     If FinalIA = 17 to 20 then CAT = 'Outstanding'
--     If FinalIA = 12 to 16 then CAT = 'Average'
--     If FinalIA < 12 then CAT = 'Weak'
--     Give these details only for 8th semester A, B, and C section students.
SELECT S.USN, S.SNAME, S.ADDRESS, S.PHONE, S.GENDER, IA.SUBCODE, 
    (CASE 
        WHEN IA.FINALIA BETWEEN 17 AND 20 THEN 'OUTSTANDING' 
        WHEN IA.FINALIA BETWEEN 12 AND 16 THEN 'AVERAGE' 
        ELSE 'WEAK' 
    END) AS CAT 
FROM STUDENT S, SEMSEC SS, IAMARKS IA, SUBJECT SUB 
WHERE S.USN = IA.USN 
    AND SS.SSID = IA.SSID 
    AND SUB.SUBCODE = IA.SUBCODE 
    AND SUB.SEM = 8;

DROP DATABASE COLLEGEDB;
