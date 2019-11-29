/* create views */

--1. Top A-Star Passenger- This view returns the First Name, Last Name and Date of membership enrollment of those passengers who have travelled more than 60 times in the past year.
-- table 1: TICKET sold last year
/*
CREATE TABLE T1 AS(
    SELECT TICKET_ID
    FROM TICKET, TIME_TABLE
    WHERE TICKET.DATE_ID=TIME_TABLE.DATE_ID AND TICKET_ID IN (SELECT TICKET_ID FROM BUS_TRANSACTION) AND DATE_T>(TO_DATE('11-24-2019','mm-dd-yyyy')-INTERVAL '1' YEAR)
);

-- table 2: A_class_passenger SSN
CREATE TABLE T2 AS(
        SELECT E_SSN as "A_STAR_SSN", ISSUE_DATE
        FROM A_STAR_PASSENGER, EMPLOYEE
        WHERE A_STAR_ID=STAR_ID
        UNION
        SELECT A_SSN as "A_STAR_SSN", ISSUE_DATE
        FROM A_STAR_PASSENGER, A_CLASS_PASSENGER
        WHERE A_STAR_ID=STAR_ID 
);

-- tabele 3: passenger SSN, who travels more than 60 times in the past year
CREATE TABLE T3 AS( 
    SELECT BUYER_ID 
    FROM (
        SELECT BUYER_ID, COUNT(TICKET_ID) as "TRAVEL_TIMES"
        FROM (SELECT BUYER_ID, TICKET_ID FROM BUS_TRANSACTION WHERE TICKET_ID IN (SELECT * FROM T1))
        GROUP BY BUYER_ID
    )
    WHERE TRAVEL_TIMES > 60
);

-- table 4: SSN and issue_date of A_Star_Passenger that travels more than 60 times last year
CREATE TABLE T4 AS(
    SELECT *
    FROM T2
    INNER JOIN T3 ON A_STAR_SSN = BUYER_ID 
);

-- table 5: Information about A_star_passengers that travelled more than 60 times past year
SELECT SSN, FIRSTNAME, LASTNAME, ISSUE_DATE AS MEMBERSHIP_DATE 
FROM PERSON, T4
WHERE SSN = A_STAR_SSN;

DROP TABLE T4;
DROP TABLE T3;
DROP TABLE T2;
DROP TABLE T1;
*/

CREATE VIEW TOP_A_STAR_PASSENGER AS(
    SELECT SSN, FIRSTNAME, LASTNAME, ISSUE_DATE AS MEMBERSHIP_DATE 
    FROM PERSON, (SELECT * FROM (   SELECT E_SSN as "A_STAR_SSN", ISSUE_DATE
                                    FROM A_STAR_PASSENGER, EMPLOYEE
                                    WHERE A_STAR_ID=STAR_ID
                                    UNION
                                    SELECT A_SSN as "A_STAR_SSN", ISSUE_DATE
                                    FROM A_STAR_PASSENGER, A_CLASS_PASSENGER
                                    WHERE A_STAR_ID=STAR_ID 
                                ) 
    INNER JOIN (    SELECT BUYER_ID 
                    FROM (
                            SELECT BUYER_ID, COUNT(TICKET_ID) as "TRAVEL_TIMES"
                            FROM (SELECT BUYER_ID, TICKET_ID FROM BUS_TRANSACTION WHERE TICKET_ID IN (SELECT * FROM (
                            SELECT TICKET_ID
                            FROM TICKET, TIME_TABLE
                            WHERE TICKET.DATE_ID=TIME_TABLE.DATE_ID 
                            AND TICKET_ID IN (SELECT TICKET_ID FROM BUS_TRANSACTION) 
                            AND DATE_T<(TO_DATE('11-24-2019','mm-dd-yyyy')-INTERVAL '1' YEAR)
                          )))
                        GROUP BY BUYER_ID
                    )
                    WHERE TRAVEL_TIMES > 60) 
                    ON A_STAR_SSN = BUYER_ID 
                )
    WHERE SSN = A_STAR_SSN
);




--2. Popular Bus- This view returns the details of the bus that the passenger has booked the most in the past 2 years

-- table 1: tickets sold in the past 2 years
/*
CREATE TABLE T1 AS(
    SELECT TICKET_ID, BUS_ID
    FROM TICKET, TIME_TABLE
    WHERE TICKET.DATE_ID=TIME_TABLE.DATE_ID AND TICKET_ID IN (SELECT TICKET_ID FROM BUS_TRANSACTION) AND DATE_T>(TO_DATE('11-24-2019','mm-dd-yyyy')-INTERVAL '2' YEAR)
);

-- table 2: booked times of the buses in the past 2 years
CREATE TABLE T2 AS(
    SELECT BUS_ID, COUNT(TICKET_ID) AS "BOOKED_TIMES"
    FROM T1
    GROUP BY BUS_ID
);

-- table 3: most-popular bus information
CREATE TABLE T3 AS(
    SELECT BUS_ID, BOOKED_TIMES
    FROM T2
    WHERE BOOKED_TIMES=(SELECT MAX(BOOKED_TIMES) FROM T2)
);

SELECT BUS.BUS_ID AS "BUS_ID", TOTAL_SEATS, LICE_PLATE, BOOKED_TIMES AS "BOOKINGS_LAST_TWO_YEARS" 
FROM BUS, T3
WHERE BUS.BUS_ID=T3.BUS_ID;

DROP TABLE T3;
DROP TABLE T2;
DROP TABLE T1;
*/

CREATE VIEW POPULAR_BUS AS(
    SELECT BUS.BUS_ID AS "BUS_ID", TOTAL_SEATS, LICE_PLATE, BOOKED_TIMES AS "BOOKINGS_LAST_TWO_YEARS" 
    FROM BUS, (SELECT BUS_ID, BOOKED_TIMES
               FROM (SELECT BUS_ID, COUNT(TICKET_ID) AS "BOOKED_TIMES"
                     FROM T1
                     GROUP BY BUS_ID
                    ) T2
               WHERE BOOKED_TIMES=(SELECT MAX(BOOKED_TIMES) FROM T2)) T3
    WHERE BUS.BUS_ID=T3.BUS_ID
);


--3. Top Delayed/Cancelled Bus- This view returns the details of the bus that has been delayed or cancelled the most in the last month.

-- table 1: BUS trips Delayed/Cancelled in the last month
/*
CREATE TABLE T1 AS(
    SELECT BUS_ID, DRIVER_ID, ROUTE_ID, BUS_TRIP.DATE_ID AS DATE_ID, STATUS
    FROM BUS_TRIP, TIME_TABLE
    WHERE BUS_TRIP.DATE_ID=TIME_TABLE.DATE_ID AND DATE_T>(TO_DATE('11-24-2019','mm-dd-yyyy')-INTERVAL '1' MONTH)
);

-- table 2: Delayed/Cancelled times of buses in the last month
CREATE TABLE T2 AS(
    SELECT BUS_ID, COUNT(STATUS) AS "D_C_TIMES"
    FROM (SELECT * FROM T1 WHERE STATUS!='O')
    GROUP BY BUS_ID
);

-- table 3: Top Delayed/Cancelled bus information
CREATE TABLE T3 AS(
    SELECT BUS_ID, D_C_TIMES
    FROM T2
    WHERE D_C_TIMES=(SELECT MAX(D_C_TIMES) FROM T2)
);

DROP TABLE T3;
DROP TABLE T2;
DROP TABLE T1;
*/

CREATE VIEW TOP_D_C_BUS AS(
    SELECT BUS.BUS_ID AS BUS_ID, TOTAL_SEATS, LICE_PLATE, D_C_TIMES 
    FROM BUS, (SELECT BUS_ID, D_C_TIMES
               FROM (SELECT BUS_ID, COUNT(STATUS) AS "D_C_TIMES"
                     FROM (SELECT * FROM (  SELECT BUS_ID, DRIVER_ID, ROUTE_ID, BUS_TRIP.DATE_ID AS DATE_ID, STATUS
                                            FROM BUS_TRIP, TIME_TABLE
                                            WHERE BUS_TRIP.DATE_ID=TIME_TABLE.DATE_ID AND DATE_T>(TO_DATE('11-24-2019','mm-dd-yyyy')-INTERVAL '1' MONTH)                    
                                         ) 
                     WHERE STATUS!='O')
                     GROUP BY BUS_ID) T2                                                   
               WHERE D_C_TIMES=(SELECT MAX(D_C_TIMES) FROM T2)
              ) T3
    WHERE BUS.BUS_ID=T3.BUS_ID
);


--4. Potential A-Star Passenger- This view returns the name, phone number and ID of the A-Class Passengers who travelled more than 40 time in the past 2 months.
-- Extract SSN of A_STAR_PASSENGER
CREATE VIEW A_STAR_SSN AS(
        SELECT E_SSN as "A_STAR_SSN", A_STAR_ID
        FROM A_STAR_PASSENGER, EMPLOYEE
        WHERE A_STAR_ID=STAR_ID
        UNION
        SELECT A_SSN as "A_STAR_SSN", A_STAR_ID
        FROM A_STAR_PASSENGER, A_CLASS_PASSENGER
        WHERE A_STAR_ID=STAR_ID 
);

-- table 1: tickets sold in the past 2 months
/*
CREATE TABLE T1 AS(
    SELECT TICKET_ID
    FROM TICKET, TIME_TABLE
    WHERE TICKET.DATE_ID=TIME_TABLE.DATE_ID AND DATE_T>(TO_DATE('11-24-2019','mm-dd-yyyy')-INTERVAL '2' MONTH)    
);

-- table 2: A_Class passenger booking information in the past 2 months
CREATE TABLE T2 AS(
    SELECT A_SSN, BOOKING_LAST_TWO_MONTH
    FROM(
        SELECT A_SSN,STAR_ID, COUNT(TICKET_ID) AS "BOOKING_LAST_TWO_MONTH"
        FROM (SELECT A_SSN, STAR_ID, T1.TICKET_ID FROM A_CLASS_PASSENGER, T1, BUS_TRANSACTION WHERE A_SSN=BUYER_ID AND T1.TICKET_ID=BUS_TRANSACTION.TICKET_ID)
        GROUP BY A_SSN, STAR_ID
        )
    WHERE STAR_ID IS NULL
);

-- table 3: Potential A-Star Passenger information
SELECT SSN, CONCAT(CONCAT(FIRSTNAME, ' '), LASTNAME) AS "NAME", PHONE_NO
FROM PERSON, T2, PHONE_NUMBER
WHERE A_SSN=SSN AND USER_SSN=A_SSN AND BOOKING_LAST_TWO_MONTH<40
ORDER BY SSN

DROP TABLE T2;
DROP TABLE T1;
*/

CREATE VIEW POTENTIAL_A_STAR AS(
    SELECT SSN, CONCAT(CONCAT(FIRSTNAME, ' '), LASTNAME) AS "NAME", PHONE_NO
    FROM PERSON, (SELECT A_SSN, BOOKING_LAST_TWO_MONTH
                  FROM(
                        SELECT A_SSN,STAR_ID, COUNT(TICKET_ID) AS "BOOKING_LAST_TWO_MONTH"
                        FROM (SELECT A_SSN, STAR_ID, BUS_TRANSACTION.TICKET_ID 
                              FROM A_CLASS_PASSENGER, (SELECT TICKET_ID
                                                       FROM TICKET, TIME_TABLE
                                                       WHERE TICKET.DATE_ID=TIME_TABLE.DATE_ID AND DATE_T>(TO_DATE('11-24-2019','mm-dd-yyyy')-INTERVAL '2' MONTH)  
                                                       )T1, BUS_TRANSACTION 
                              WHERE A_SSN=BUYER_ID AND T1.TICKET_ID=BUS_TRANSACTION.TICKET_ID)
                        GROUP BY A_SSN, STAR_ID
                       )
                  WHERE STAR_ID IS NULL
                  ), PHONE_NUMBER
    WHERE A_SSN=SSN AND USER_SSN=A_SSN AND BOOKING_LAST_TWO_MONTH<40
); 

--SELECT * FROM POTENTIAL_A_STAR ORDER BY SSN

--5. Top Employee- This view returns the details of the employee who has made the most number of bookings in the past month.
/*
-- table 1: ticket sold in the past month
CREATE TABLE T1 AS(
    SELECT TICKET_ID
    FROM TICKET, TIME_TABLE
    WHERE TICKET.DATE_ID=TIME_TABLE.DATE_ID AND DATE_T>(TO_DATE('11-24-2019','mm-dd-yyyy')-INTERVAL '1' MONTH)    
);

-- table 2: Employee booking number last month
CREATE TABLE T2 AS(
    SELECT BUYER_ID AS "E_SSN", COUNT(TICKET_ID) AS "BOOKING_LAST_MONTH"
    FROM (SELECT * FROM BUS_TRANSACTION INNER JOIN EMPLOYEE ON BUYER_ID=E_SSN WHERE TICKET_ID IN (SELECT * FROM T1))
    GROUP BY BUYER_ID
);

-- table 3: Top-Employee booking number
CREATE TABLE T3 AS (
    SELECT * FROM T2 WHERE BOOKING_LAST_MONTH=(SELECT MAX(BOOKING_LAST_MONTH) FROM T2)
);

SELECT E_SSN, CONCAT(CONCAT(FIRSTNAME, ' '), LASTNAME) AS "NAME", START_DATE, JOB_TYPE, STAR_ID
FROM EMPLOYEE, PERSON 
WHERE (E_SSN IN (SELECT E_SSN FROM T3)) AND E_SSN=SSN

DROP TABLE T3;
DROP TABLE T2;
DROP TABLE T1;
*/

CREATE VIEW TOP_EMPLOYEE AS(
    SELECT E_SSN, CONCAT(CONCAT(FIRSTNAME, ' '), LASTNAME) AS "NAME", START_DATE, JOB_TYPE, STAR_ID
    FROM EMPLOYEE, PERSON 
    WHERE (E_SSN IN (SELECT E_SSN FROM 
        (SELECT * FROM 
            (SELECT BUYER_ID AS "E_SSN", COUNT(TICKET_ID) AS "BOOKING_LAST_MONTH"
             FROM (SELECT * FROM BUS_TRANSACTION INNER JOIN EMPLOYEE ON BUYER_ID=E_SSN WHERE TICKET_ID IN (SELECT * FROM 
                (SELECT TICKET_ID
                 FROM TICKET, TIME_TABLE
                 WHERE TICKET.DATE_ID=TIME_TABLE.DATE_ID AND DATE_T>(TO_DATE('11-24-2019','mm-dd-yyyy')-INTERVAL '1' MONTH)             
                )))
             GROUP BY BUYER_ID) T2 
        WHERE BOOKING_LAST_MONTH=(SELECT MAX(BOOKING_LAST_MONTH) FROM T2)
        )
    )) AND E_SSN=SSN  
);

-- OTHER USEFUL VIEWS
CREATE VIEW TICKET_SOLD AS(
    SELECT * 
    FROM TICKET
    WHERE TICKET_ID IN (SELECT TICKET_ID FROM BUS_TRANSACTION)
);

--SELECT * FROM TICKET_SOLD;

















