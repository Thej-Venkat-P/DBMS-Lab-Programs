/*
 Consider the following schema for Order Database: 
 SALESMAN (Salesman_id, Name, City, Commission) 
 CUSTOMER (Customer_id, Cust_Name, City, Grade, Salesman_id) 
 ORDERS (Ord_No, Purchase_Amt, Ord_Date, Customer_id, Salesman_id)
 
 Write SQL queries to:
 1. Count the customers with grades above Bangalore’s average.
 2. Find the name and numbers of all salesmen who had more than one customer.
 3. List all salesmen and indicate those who have and don’t have customers in their cities (Use UNION operation.)
 4. Create a view that finds the salesman who has the customer with the highest order of a day.
 5. Demonstrate the DELETE operation by removing salesman with id 1000. All his orders must also be deleted.
 */

-- Step 1: Create Database
CREATE DATABASE ORDERDB;
USE ORDERDB;

-- STEP 2: Create Tables
CREATE TABLE SALESMAN (
    SALESMAN_ID INT PRIMARY KEY,
    NAME VARCHAR(20),
    CITY VARCHAR(20),
    COMMISSION VARCHAR(20)
);
CREATE TABLE CUSTOMER (
    CUSTOMER_ID INT PRIMARY KEY,
    CUST_NAME VARCHAR(20),
    CITY VARCHAR(20),
    GRADE INT,
    SALESMAN_ID INT,
    FOREIGN KEY (SALESMAN_ID) REFERENCES SALESMAN(SALESMAN_ID) ON DELETE
    SET NULL
);
CREATE TABLE ORDERS (
    ORD_NO INT PRIMARY KEY,
    PURCHASE_AMT INT,
    ORD_DATE DATE,
    CUSTOMER_ID INT,
    SALESMAN_ID INT,
    FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID) ON DELETE CASCADE,
    FOREIGN KEY (SALESMAN_ID) REFERENCES SALESMAN(SALESMAN_ID) ON DELETE CASCADE
);

-- STEP 3: Insert Data
INSERT INTO SALESMAN VALUES 
    (1000, 'JOHN', 'BANGALORE', '25 %'),
    (2000, 'RAVI', 'BANGALORE', '20 %'),
    (3000, 'KUMAR', 'MYSORE', '15 %'),
    (4000, 'SMITH', 'DELHI', '30 %'),
    (5000, 'HARSHA', 'HYDRABAD', '15%');
INSERT INTO CUSTOMER VALUES 
    (10, 'PREETHI', 'BANGALORE', 100, 1000),
    (11, 'VIVEK', 'MANGALORE', 300, 1000),
    (12, 'BHASKAR', 'CHENNAI', 400, 2000),
    (13, 'CHETHAN', 'BANGALORE', 200, 2000),
    (14, 'MAMATHA', 'BANGALORE', 400, 3000);
INSERT INTO ORDERS VALUES 
    (50, 5000, '2017-05-04', 10, 1000),
    (55, 1000, '2017-05-04', 10, 1000),
    (56, 300, '2017-05-04', 10, 2000),
    (51, 450, '2017-01-20', 10, 2000),
    (52, 1000, '2017-02-24', 13, 2000),
    (53, 3500, '2017-04-13', 14, 3000),
    (54, 550, '2017-03-09', 12, 2000),
    (57, 450, '2017-03-09', 12, 2000),
    (58, 350, '2017-03-09', 12, 2000),
    (60, 150, '2017-03-09', 12, 1000),
    (61, 200, '2017-03-09', 12, 3000);

-- STEP 4: DISPLAY TABLES
SELECT * FROM SALESMAN;
SELECT * FROM CUSTOMER;
SELECT * FROM ORDERS;

-- STEP 5: EXECUTE QUERIES

-- 1. Count the customers with grades above Bangalore’s average.
SELECT GRADE, COUNT(*) 
FROM CUSTOMER 
GROUP BY GRADE
HAVING GRADE > (SELECT AVG(GRADE) FROM CUSTOMER WHERE CITY = 'BANGALORE')
;

-- 2. Find the name and numbers of all salesmen who had more than one customer.
SELECT SALESMAN_ID, NAME
FROM SALESMAN
WHERE (SELECT COUNT(*) FROM CUSTOMER WHERE SALESMAN_ID = SALESMAN.SALESMAN_ID) > 1
;

-- 3. List all salesmen and indicate those who have and don’t have customers in their cities (Use UNION operation.)
SELECT SALESMAN.SALESMAN_ID, NAME, CUST_NAME
FROM SALESMAN, CUSTOMER
WHERE SALESMAN.CITY = CUSTOMER.CITY
UNION
SELECT SALESMAN_ID, NAME, 'NO CUSTOMER'
FROM SALESMAN
WHERE NOT CITY = ANY (SELECT CITY FROM CUSTOMER)
ORDER BY NAME DESC
;

-- 4. Create a view that finds the salesman who has the customer with the highest order of a day.
CREATE VIEW ELITESALESMAN AS  
SELECT B.ORD_DATE, A.SALESMAN_ID, A.NAME  
FROM SALESMAN A, ORDERS B  
WHERE A.SALESMAN_ID = B.SALESMAN_ID 
AND B.PURCHASE_AMT = (
    SELECT MAX(PURCHASE_AMT) 
    FROM ORDERS C 
    WHERE C.ORD_DATE = B.ORD_DATE
);
SELECT * FROM ELITESALESMAN;

-- 5. Demonstrate the DELETE operation by removing salesman with id 1000. All his orders must also be deleted.
DELETE FROM SALESMAN WHERE SALESMAN_ID=1000;
SELECT * from SALESMAN; 

DROP DATABASE ORDERDB;
