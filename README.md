This repository is a school project for practising database design. Use SQL as main database. 

## Dependence

Install Oracle.
PS: Suggest Use Visual Studio Code as and IDE for this project.

## Import Schema to Oracle

User please import the schema sql file.

## Project Description

Dallas Area Road Transport or DART would like one relational database to store the information about their bus transportation system to be able to carry out their work in an organized way.

The DART has some major modules such as Bus, Person (Employee and Passenger) and Ticket Sales. A Person can be an Employee or an A-class Passenger. A person can be both an employee and an A-Class passenger. Details of a person such as Person ID, Name (First, Middle, Last), Address, Gender, Date of Birth (Must be 16 years or older), and Phone number (one person can have more than one phone number) are recorded. The Person ID should have the format “PXXX” where X is a number from 0 to 9. The number of children travelling with an A-Class passenger is stored. A maximum of 5 children can travel with an A-Class Passenger. Employee is further classified as Bus Drivers, Staff (Ticket sellers) or Ticket checkers. The start date of the employee is recorded. One bus driver can drive multiple buses and multiple drivers can drive one bus but on different dates. (At a given time in a day, only one driver drives a particular bus).

Payment information such as ID, method (cash or card), amount and other information are recorded. Ticket details such as Ticket ID, Bus ID, seat number and price are stored. The staff sells daily tickets to a person and the staff details, ticket details, person details and payment details are stored together.

An A-Star passenger is someone who has some extra privileges than an A-Class passenger. An A-Star Passenger can be an Employee or an A-Class passenger or both. Different passes are issued by DART. An A-Class passenger can buy only one pass in a month but an A-Star Passenger can buy multiple passes in a month. Each A-Star Passenger is issued a travel card. The travel card details such as card ID, date of issue and other information are stored. A-Star passengers can have guests who travel for free with them four times a month. A Guest log is maintained which stores information such as passenger ID, guest ID, guest SSN, guest name, guest address, and guest contact information. Guest IDs are temporary IDs that a person gets when they travel as a guest of an A-Star passenger. Each guest ID is not unique and cannot be used to identify a guest in the library.

Sometimes promotional discounts are offered on the passes and details such promotion ID and promotion description are recorded. The Promotional IDs are not unique and cannot be used to identify a promotion in the system.

Bus details such as Bus Number, License plate number, number of seats and other information are stored. Each route has many bus stops. One bus stop is part of only one route. The route and bus stop details are stored.

Each bus is parked in a terminal and the information of the terminal such as Terminal ID, Location, Date and Time are stored. The time table information such as day and start time, end time and intervals (15 min, 20 min, 30 min) are recorded. Values for ‘day’ can be {M,T,W,Th,F,Sat,Sun}. A unique ID in the form of “DTXX” is given to each unique record in the timetable. For example, Day-{M,W}, StartTime10:00, EndTime – 20:00, Interval - 15m can have ID DT01 and so on. The information of which bus goes by which route and at what time is all stored together. The status of the bus (On Time, Delayed, or Cancelled) is recorded.
