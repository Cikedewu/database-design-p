Create Table PERSON
(
    SSN                     VARCHAR2(9)          NOT NULL,
    FirstName               VARCHAR2(15)         NOT NULL,
    MidName                 CHAR,
    LastName                VARCHAR2(15)         NOT NULL,
    Gender                  CHAR,
    DOB                     DATE,
    Address                 VARCHAR2(60),

    PRIMARY KEY (Ssn)
);


Create Table A_STAR_PASSENGER
(
    
    A_Star_ID               VARCHAR2(10)          NOT NULL,
    T_Card_ID               VARCHAR2(8)           NOT NULL,
    Issue_Date              DATE                  NOT NULL,

    PRIMARY KEY(A_Star_ID)
);


Create Table A_CLASS_PASSENGER
( 
    A_SSN                   VARCHAR2(9)             NOT NULL,
    Star_ID                 VARCHAR2(10),

    PRIMARY KEY(A_SSN),
    FOREIGN KEY (A_SSN) REFERENCES PERSON(SSN),
    FOREIGN KEY (Star_ID) REFERENCES A_STAR_PASSENGER(A_Star_ID)
);


Create Table EMPLOYEE
(
    E_SSN                   VARCHAR2(9)             NOT NULL,
    Start_Date              DATE                    NOT NULL,
    Job_Type                VARCHAR2(20)            NOT NULL,
    Star_ID                 VARCHAR(10),
    PRIMARY KEY(E_SSN),
    FOREIGN KEY (E_SSN) REFERENCES PERSON(SSN),
    FOREIGN KEY (Star_ID) REFERENCES A_STAR_PASSENGER(A_Star_ID)
);



Create Table TK_CHECKER
(
    Checker_SSN             VARCHAR(9)             NOT NULL,

    PRIMARY KEY(Checker_SSN),
    FOREIGN KEY(Checker_SSN) REFERENCES EMPLOYEE(E_SSN)
);


Create Table TK_SELLER
(  
    Seller_SSN              VARCHAR2(9)             NOT NULL,

    PRIMARY KEY(Seller_SSN),
    FOREIGN KEY(Seller_SSN) REFERENCES EMPLOYEE(E_SSN)
);


Create Table PASS
( 
    Pass_ID                 VARCHAR2(6)            NOT NULL,
    Seller_SSN              VARCHAR2(9)            NOT NULL,
    Holder_SSN              VARCHAR2(9)            NOT NULL,

    PRIMARY KEY(Pass_ID),
    FOREIGN KEY (Seller_SSN) REFERENCES TK_SELLER(SELLER_SSN),
    FOREIGN KEY (Holder_SSN) REFERENCES PERSON(SSN)
);


Create Table PROMOTION
(
    Promotion_ID            VARCHAR(6)          NOT NULL,
    Pass_ID                 VARCHAR(6)          NOT NULL,
    Rate                    DECIMAL(10, 2)      NOT NULL,

    PRIMARY KEY(Promotion_ID),
    FOREIGN KEY (Pass_ID) REFERENCES PASS(Pass_ID)
);


Create Table BUS
( 
    Bus_ID                  VARCHAR(6)          NOT NULL,
    Total_Seats             INT                 NOT NULL,
    Lice_Plate              VARCHAR(6)          NOT NULL,

    PRIMARY KEY(Bus_ID),
    UNIQUE(Lice_Plate)              
);


Create Table TIME_TABLE
(
    Date_ID                 VARCHAR(4)           NOT NULL,
    Date_T                    DATE               NOT NULL,
    Start_T                 TIMESTAMP            NOT NULL,
    End_T                   TIMESTAMP            NOT NULL,
    Interval_B                INT                NOT NULL,

    PRIMARY KEY(Date_ID)
);


Create Table TICKET
(
    Ticket_ID               VARCHAR(10)          NOT NULL,
    Price                   DECIMAL(10, 2)      NOT NULL,
    Bus_ID                  VARCHAR(6)          NOT NULL,
    Seat_Number             VARCHAR(4)          NOT NULL,
    Date_ID                 VARCHAR(4)          NOT NULL,

    PRIMARY KEY (Ticket_ID),
    FOREIGN KEY (Bus_ID) REFERENCES BUS(Bus_ID),
    FOREIGN KEY (DATE_ID) REFERENCES TIME_TABLE(DATE_ID)
);


Create Table TERMINAL
( 
    Terminal_ID              CHAR(4)                 NOT NULL,
    Location_T              VARCHAR(20)              NOT NULL,

    PRIMARY KEY(Terminal_ID)
);


Create Table PARK_AT
(  
    Bus_ID              VARCHAR(6)              NOT NULL,
    Date_P               DATE                   NOT NULL,
    Terminal_ID          CHAR(4)                NOT NULL,

    PRIMARY KEY(Bus_ID, Date_P),
    FOREIGN KEY (Bus_ID) REFERENCES BUS(Bus_ID),
    FOREIGN KEY (Terminal_ID) REFERENCES TERMINAL(Terminal_ID)
);


Create Table PHONE_NUMBER
(  
    User_SSN                VARCHAR2(9)             NOT NULL,
    Phone_No                VARCHAR2(15)            NOT NULL,
    
    PRIMARY KEY (Phone_No),
    FOREIGN KEY (User_SSN) REFERENCES PERSON(SSN)
);


Create Table CHILDREN
(
    D_SSN                   VARCHAR2(9)             NOT NULL,
    Child_Name              VARCHAR2(12)            NOT NULL,

    PRIMARY KEY(D_SSN, Child_Name),
    FOREIGN KEY(D_SSN) REFERENCES PERSON(SSN)
);


Create Table GUEST_INFO
(   
    Name_G                  VARCHAR(12)         NOT NULL,
    Address                 VARCHAR(60)         NOT NULL,
    Phone_No                VARCHAR2(15),
    G_SSN                   VARCHAR2(9)         NOT NULL,

    PRIMARY KEY (G_SSN)
);


Create Table GUEST_DEPD
(
    Guest_ID                VARCHAR2(6)             NOT NULL,
    A_Star_ID               VARCHAR2(10)            NOT NULL,
    Guest_SSN               VARCHAR2(9)             NOT NULL,

    PRIMARY KEY (Guest_ID, A_Star_ID),
    FOREIGN KEY(Guest_SSN) REFERENCES GUEST_INFO(G_SSN),
    FOREIGN KEY(A_STAR_ID) REFERENCES A_STAR_PASSENGER(A_Star_ID)
);


Create Table BUS_TRANSACTION
(
    Buyer_ID                VARCHAR2(9)          NOT NULL,
    Ticket_ID               VARCHAR2(10)         NOT NULL,
    Seller_ID               VARCHAR2(9)          NOT NULL,
    Method_T                 INT                 NOT NULL,
    Amount                  DECIMAL(10, 2)       NOT NULL,

    PRIMARY KEY (Ticket_ID),
    FOREIGN KEY(Buyer_ID)  REFERENCES  PERSON(SSN),
    FOREIGN KEY(Seller_ID) REFERENCES TK_SELLER(SELLER_SSN),
    FOREIGN KEY(Ticket_ID) REFERENCES TICKET(Ticket_ID)
);


Create Table BUS_ROUTE
(
    ROUTE           INT         NOT NULL,
    
    PRIMARY KEY(ROUTE)
);


Create Table BUS_STOP
(
    
    Stop_Name               VARCHAR2(60)         NOT NULL,
    Route_ID                INT                  NOT NULL,

    PRIMARY KEY(Stop_Name),
    FOREIGN KEY(Route_ID) REFERENCES BUS_ROUTE(ROUTE)
);


Create Table BUS_TRIP
(
    Bus_ID                  VARCHAR2(6)             NOT NULL,
    Driver_ID               VARCHAR2(9)             NOT NULL,
    Route_ID                INT                     NOT NULL,
    Date_ID                 VARCHAR2(4)             NOT NULL,
    Status                  CHAR                    NOT NULL,

    PRIMARY KEY (Bus_ID, Driver_ID, Route_ID, Date_ID),
    FOREIGN KEY(Bus_ID) REFERENCES BUS(Bus_ID),
    FOREIGN KEY(Driver_ID) REFERENCES EMPLOYEE(E_SSN),
    FOREIGN KEY(Route_ID) REFERENCES BUS_ROUTE(Route),
    FOREIGN KEY(Date_ID) REFERENCES TIME_TABLE(Date_ID)
);
