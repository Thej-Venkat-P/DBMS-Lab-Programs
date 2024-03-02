/* 
CONSIDER THE SCHEMA FOR THE COMPANY DATABASE:
EMPLOYEE (SSN, Name, Address, Sex, Salary, SuperSSN, DNo) 
DEPARTMENT (DNo, DName, MgrSSN, MgrStartDate) 
DLOCATION (DNo,DLoc) PROJECT (PNo, PName, PLocation, DNo) 
WORKS_ON (SSN, PNo, Hours) 
 
Write SQL queries to 
a. Make a list of all project numbers for projects that involve an employee whose last name is „Scott‟, either as a worker or as a manager of the department that controls the project. 
b. Show the resulting salaries if every employee working on the „IoT‟ project is given a 10 percent raise. 
c. Find the sum of the salaries of all employees of the „Accounts‟ department, as well  as the maximum salary, the minimum salary, and the average salary in this department 
d. Retrieve  the  name  of  each  employee  who  works  on  all  the  projects  controlled  by department  number  5  (use  NOT  EXISTS  operator). 
e. For  each  department  that  has  more than  five  employees,  retrieve  the  department  number  and  the  number  of  its  employees who are making more than Rs.6,00,000
*/

-- STEP 1: CREATE DATABASE
CREATE DATABASE COMPANYDB;
USE COMPANYDB;

-- STEP 2: CREATE TABLES
CREATE TABLE DEPARTMENT (
    DNO VARCHAR(20) PRIMARY KEY,
    DNAME VARCHAR(20),
    MGR_SSN VARCHAR(20),
    MGR_START_DATE DATE
); 
CREATE TABLE EMPLOYEE (
    SSN VARCHAR(20) PRIMARY KEY,
    NAME VARCHAR(20),
    ADDRESS VARCHAR(20),
    SEX CHAR(1),
    SALARY INTEGER,
    SUPERSSN VARCHAR(20),
    DNO VARCHAR(20),
    FOREIGN KEY (DNO) REFERENCES DEPARTMENT(DNO) ON DELETE CASCADE
);
CREATE TABLE DLOCATION (
    DLOC VARCHAR(20),
    DNO VARCHAR(20),
    FOREIGN KEY (DNO) REFERENCES DEPARTMENT(DNO) ON DELETE CASCADE,
    PRIMARY KEY (DNO, DLOC)
); 
CREATE TABLE PROJECT (
    PNO INTEGER PRIMARY KEY,
    PNAME VARCHAR(20),
    PLOCATION VARCHAR(20),
    DNO VARCHAR(20),
    FOREIGN KEY (DNO) REFERENCES DEPARTMENT(DNO) ON DELETE SET NULL
); 
CREATE TABLE WORKS_ON (
    HOURS INTEGER,
    SSN VARCHAR(20),
    PNO INTEGER,
    FOREIGN KEY (SSN) REFERENCES EMPLOYEE(SSN) ON DELETE CASCADE,
    FOREIGN KEY (PNO) REFERENCES PROJECT(PNO) ON DELETE CASCADE,
    PRIMARY KEY (SSN, PNO)
); 

-- STEP 3: INSERT DATA INTO TABLES
INSERT INTO DEPARTMENT VALUES 
    ('1','ACCOUNTS','ABC09', '2016-01-03'),
    ('2','IT','ABC11', '2017-02-04'),
    ('3','HR','ABC01', '2016-04-05'),
    ('4','HELPDESK', 'ABC10', '2017-06-03'),
    ('5','SALES','ABC06', '2017-01-08')
;
INSERT INTO EMPLOYEE (SSN, NAME, ADDRESS, SEX, SALARY, SUPERSSN, DNO) 
VALUES 
    ('ABC01','BEN SCOTT','BANGALORE','M', 450000, NULL, '3'), 
    ('ABC02','HARRY SMITH','BANGALORE','M', 500000, 'ABC03', '5'),
    ('ABC03','LEAN BAKER','BANGALORE','M', 700000, 'ABC04', '5'),
    ('ABC04','MARTIN SCOTT','MYSORE','M', 500000, 'ABC06', '5'),
    ('ABC05','RAVAN HEGDE','MANGALORE','M', 650000, 'ABC06', '5'),
    ('ABC06','GIRISH HOSUR','MYSORE','M', 450000, 'ABC07', '5'),
    ('ABC07','NEELA SHARMA','BANGALORE','F', 800000, NULL, '5'),
    ('ABC08','ADYA KOLAR','MANGALORE','F', 350000, 'ABC09', '1'),
    ('ABC09','PRASANNA KUMAR','MANGALORE','M', 300000, NULL, '1'),
    ('ABC10','VEENA KUMARI','MYSORE','M', 600000, NULL, '4'),
    ('ABC11','DEEPAK RAJ','BANGALORE','M', 500000, NULL, '2')
;
ALTER TABLE EMPLOYEE
ADD FOREIGN KEY (SUPERSSN) REFERENCES EMPLOYEE (SSN) ON DELETE SET NULL;
ALTER TABLE DEPARTMENT 
ADD FOREIGN KEY (MGR_SSN) REFERENCES EMPLOYEE(SSN) ON DELETE SET NULL;
INSERT INTO DLOCATION VALUES 
    ('BENGALURU', '1'),
    ('BENGALURU', '2'),
    ('BENGALURU', '3'),
    ('MYSORE', '4'),
    ('MYSORE', '5')
;
INSERT INTO PROJECT VALUES 
    (1000,'IOT','BENGALURU','5'), 
    (1001,'CLOUD','BENGALURU','5'), 
    (1002,'BIGDATA','BENGALURU','5'), 
    (1003,'SENSORS','BENGALURU','3'), 
    (1004,'BANK MANAGEMENT','BENGALURU','1'), 
    (1005,'SALARY MANAGEMENT','BANGALORE','1'), 
    (1006,'OPENSTACK','BENGALURU','4'), 
    (1007,'SMART CITY','BENGALURU','2')
;
INSERT INTO WORKS_ON VALUES 
    (4, 'ABC02', 1000), 
    (6, 'ABC02', 1001), 
    (8, 'ABC02', 1002), 
    (10,'ABC03', 1000), 
    (3, 'ABC05', 1000), 
    (4, 'ABC06', 1001), 
    (5, 'ABC07', 1002), 
    (6, 'ABC04', 1002), 
    (7, 'ABC01', 1003), 
    (5, 'ABC08', 1004), 
    (6, 'ABC09', 1005), 
    (4, 'ABC10', 1006), 
    (10,'ABC11', 1007)
;

-- STEP 4: DISPLAY TABLES
SELECT * FROM DEPARTMENT;
SELECT * FROM EMPLOYEE;
SELECT * FROM DLOCATION;
SELECT * FROM PROJECT;
SELECT * FROM WORKS_ON;

-- STEP 5: SQL QUERIES

-- a. Make a list of all project numbers for projects that involve an employee whose last name is „Scott‟, either as a worker or as a manager of the department that controls the project.
SELECT DISTINCT P.PNO 
FROM PROJECT P, DEPARTMENT D, EMPLOYEE E 
WHERE E.DNO=D.DNO AND D.MGR_SSN=E.SSN AND E.NAME LIKE '%SCOTT' 
UNION 
SELECT DISTINCT P1.PNO 
FROM PROJECT P1, WORKS_ON W, EMPLOYEE E1 
WHERE P1.PNO=W.PNO AND E1.SSN=W.SSN AND E1.NAME LIKE '%SCOTT';

-- b. Show the resulting salaries if every employee working on the „IoT‟ project is given a 10 percent raise.
SELECT E.NAME, 1.1*E.SALARY AS INCR_SAL 
FROM EMPLOYEE E, WORKS_ON W, PROJECT P 
WHERE E.SSN=W.SSN AND W.PNO=P.PNO AND P.PNAME='IOT';

-- c. Find the sum of the salaries of all employees of the „Accounts‟ department, as well  as the maximum salary, the minimum salary, and the average salary in this department
SELECT SUM(E.SALARY), MAX(E.SALARY), MIN(E.SALARY), AVG(E.SALARY) 
FROM EMPLOYEE E, DEPARTMENT D 
WHERE E.DNO=D.DNO AND D.DNAME='ACCOUNTS'; 

-- d. Retrieve  the  name  of  each  employee  who  works  on  all  the  projects  controlled  by department  number  5  (use  NOT  EXISTS  operator).
SELECT E.NAME 
FROM EMPLOYEE E 
WHERE NOT EXISTS(
    SELECT PNO 
    FROM PROJECT 
    WHERE DNO='5' 
    AND PNO NOT IN (
        SELECT PNO 
        FROM WORKS_ON 
        WHERE E.SSN=SSN
    )
); 

-- e. For  each  department  that  has  more than five  employees,  retrieve  the  department  number  and  the  number  of  its  employees who are making more than Rs.6,00,000
SELECT D.DNO, COUNT(*) 
FROM DEPARTMENT D, EMPLOYEE E 
WHERE D.DNO=E.DNO 
    AND E.SALARY > 600000 
    AND D.DNO IN (
        SELECT E1.DNO 
        FROM EMPLOYEE E1  
        GROUP BY E1.DNO 
        HAVING COUNT(*) > 5
    ) 
GROUP BY D.DNO;

-- STEP 6: DROP DATABASE
DROP DATABASE IF EXISTS COMPANYDB;