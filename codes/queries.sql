/*1 For each employee class, list the employees belonging to that class */
SELECT *
FROM EMPLOYEE
WHERE JOB_TYPE = 'Checker';

SELECT *
FROM EMPLOYEE
WHERE JOB_TYPE = 'Seller';

SELECT *
FROM EMPLOYEE
WHERE JOB_TYPE = 'Driver';

/*2 Find the names of employees who are also an A-Class Passenger. */
SELECT FIRSTNAME, MIDNAME, LASTNAME
FROM PERSON, EMPLOYEE, A_CLASS_PASSENGER
WHERE SSN = E_SSN AND SSN = A_SSN;

/*3 Find the average number of bookings made by the top five A-Star Passengers.*/
CREATE VIEW ASTAR_PASSENGER_BOOKING AS(
    SELECT A_STAR_SSN, COUNT(*) AS COUNTS
    FROM A_STAR_SSN, BUS_TRANSACTION
    WHERE A_STAR_SSN = BUYER_ID
    GROUP BY A_STAR_SSN
);

SELECT AVG(COUNTS)FROM 
(
    SELECT *
    FROM ASTAR_PASSENGER_BOOKING
    WHERE ROWNUM <= 5
    ORDER BY COUNTS DESC
);


/*4 Find the Bus ID and Route names of the bus that is booked the most. */
/* step1 find the most popular bus id*/

CREATE VIEW BUS_BOOK_COUNTS AS (
SELECT BUS_ID, COUNT(TICKET_ID) AS COUNTS
FROM TICKET_SOLD
GROUP BY BUS_ID
);

/*step 2, find the most popular bus and its bus trips */
SELECT BUS_ID, ROUTE_ID
FROM BUS_TRIP 
WHERE BUS_ID  IN (SELECT BUS_ID
                FROM BUS_BOOK_COUNTS
                WHERE COUNTS = (SELECT MAX(COUNTS) FROM BUS_BOOK_COUNTS))


/*5 Find Bus ID that is cancelled more than 3 times in the past month */
SELECT BUS_ID
FROM
    (SELECT BT.BUS_ID, COUNT(BT.STATUS) AS COUNTS
    FROM BUS_TRIP BT, TIME_TABLE TT
    WHERE BT.STATUS = 'C' AND BT.DATE_ID = TT.DATE_ID AND TT.DATE_T > (TO_DATE('11/24/2019', 'MM-DD-YYYY') - INTERVAL '30' DAY)
    GROUP BY BT.BUS_ID)
WHERE COUNTS >= 3

/*6 Find the total number bookings for each bus in the system */
SELECT BUS_ID, COUNT(TICKET_ID) AS COUNTS
FROM TICKET_SOLD
GROUP BY BUS_ID


/*7 Find the driver details who has driven every day of the past week.  */  
  
CREATE VIEW BUS_DRIVER_DATE AS(
    SELECT UNIQUE(DRIVER_ID), DATE_T
    FROM BUS_TRIP, TIME_TABLE
    WHERE BUS_TRIP.DATE_ID = TIME_TABLE.DATE_ID AND DATE_T > (TO_DATE('11/24/2019', 'MM-DD-YYYY') - INTERVAL '7' DAY)
);
    

SELECT DRIVER_ID
FROM (
SELECT DRIVER_ID, COUNT(DATE_T) AS COUNTS
FROM BUS_DRIVER_DATE
GROUP BY DRIVER_ID )
WHERE COUNTS >= 7
  
  
/*8 Find the count of passengers who booked the most popular bus */

SELECT COUNT(UNIQUE(BUYER_ID)) AS COUNTS
FROM TICKET TK, BUS_TRANSACTION BTR
WHERE TK.TICKET_ID = BTR.TICKET_ID AND TK.BUS_ID IN (SELECT BUS_ID FROM POPULAR_BUS) 


/*9 List all the booking details issued after the most current employee was hired. */


SELECT BTR.BUYER_ID, BTR.TICKET_ID, BTR.SELLER_ID, BTR.METHOD_T, BTR.AMOUNT, TK.BUS_ID, TT.DATE_T
FROM BUS_TRANSACTION BTR, TICKET TK, TIME_TABLE TT
WHERE TT.DATE_T > (SELECT MAX(START_DATE)
FROM EMPLOYEE) AND BTR.TICKET_ID = TK.TICKET_ID AND TK.DATE_ID = TT.DATE_ID
    
/*10 List all the employees that have enrolled as A-Star Passengers within a month of being employed */
SELECT E.E_SSN, P.FIRSTNAME, P.LASTNAME
FROM EMPLOYEE E, A_STAR_PASSENGER ASP, PERSON P
WHERE E.STAR_ID = ASP.A_STAR_ID AND E.E_SSN = P.SSN AND ASP.ISSUE_DATE - E.START_DATE <= 30 

/*11 Find the route with the highest number of bus stops*/

CREATE VIEW ROUTE_STOPS_NUM AS(
    SELECT ROUTE_ID, COUNT(*) AS COUNTS
    FROM BUS_STOP
    GROUP BY ROUTE_ID
);


SELECT ROUTE_ID, COUNTS
FROM ROUTE_STOPS_NUM R1
WHERE COUNTS IN (SELECT MAX(COUNTS)FROM ROUTE_STOPS_NUM);
    
/*12 Find the name of passengers who have been A-Star Passengers for over 5 years.*/
SELECT P.FIRSTNAME, P.MIDNAME, P.LASTNAME
FROM A_CLASS_PASSENGER ACP, A_STAR_PASSENGER ASP, PERSON P
WHERE ACP.STAR_ID = ASP.A_STAR_ID AND ACP.A_SSN = P.SSN AND ASP.ISSUE_DATE  < (TO_DATE('11/24/2019', 'MM-DD-YYYY') - INTERVAL '5' YEAR)
  
/*13. Find the bookings made by the potential A-Star Passengers in the last year. */
SELECT  UNIQUE(BTRC.BUYER_ID), BTRC.TICKET_ID, TK.BUS_ID, TK.SEAT_NUMBER
FROM BUS_TRANSACTION BTRC, POTENTIAL_A_STAR PAS, TICKET TK, TIME_TABLE TT
WHERE BTRC.BUYER_ID = PAS.SSN AND BTRC.TICKET_ID = TK.TICKET_ID AND TK.DATE_T = TT.DATE_ID AND TT.DATE_T > (TO_DATE('11/24/2019', 'MM-DD-YYYY') - INTERVAL '1' YEAR)     