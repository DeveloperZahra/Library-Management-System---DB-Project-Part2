
-- STEP 1: Create the database
CREATE DATABASE LibrarySystemDB;


-- STEP 2: Use the database
USE LibrarySystemDB;


-- STEP 3: Create all tables in default schema (dbo)

CREATE TABLE Library (
    Library_ID INT IDENTITY,
    Name NVARCHAR(100) NOT NULL,
    Location NVARCHAR(150),
    Contact_Number VARCHAR(20),
    Established_Year INT CHECK (Established_Year >= 1900),
    CONSTRAINT PK_Library_ID PRIMARY KEY (Library_ID)
);



CREATE TABLE Member (
    Member_ID INT IDENTITY,
    Name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    Membership_Start_Date DATE NOT NULL,
    CONSTRAINT PK_Member_ID PRIMARY KEY (Member_ID)
);

CREATE TABLE Book (
    Book_ID INT IDENTITY,
    ISBN VARCHAR(20) NOT NULL UNIQUE,
    Title NVARCHAR(100) NOT NULL,
    Genre VARCHAR(50) CHECK (Genre IN ('Fiction', 'Non-fiction', 'Reference', 'Children')),
    Price DECIMAL(6,2) CHECK (Price > 0),
    Shelf_Location NVARCHAR(50),
    Availability_Status BIT DEFAULT 1,
    Library_ID INT,
    CONSTRAINT PK_Book_ID PRIMARY KEY (Book_ID),
    CONSTRAINT FK_Book_Library_ID FOREIGN KEY (Library_ID)
        REFERENCES Library(Library_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Staff (
    Staff_ID INT IDENTITY,
    Full_Name NVARCHAR(100),
    Position NVARCHAR(50),
    Contract NVARCHAR(50),
    Library_ID INT,
    CONSTRAINT PK_Staff_ID PRIMARY KEY (Staff_ID),
    CONSTRAINT FK_Staff_Library_ID FOREIGN KEY (Library_ID)
        REFERENCES Library(Library_ID)
);

CREATE TABLE Payment_Method (
    Method_ID INT IDENTITY,
    Method_Name VARCHAR(20) CHECK (Method_Name IN ('cash', 'credit')),
    CONSTRAINT PK_Method_ID PRIMARY KEY (Method_ID)
);

CREATE TABLE Payment (
    Payment_ID INT IDENTITY,
    Date DATE NOT NULL,
    Amount DECIMAL(6,2) CHECK (Amount > 0),
    Method_ID INT,
    CONSTRAINT PK_Payment_ID PRIMARY KEY (Payment_ID),
    CONSTRAINT FK_Payment_Method_ID FOREIGN KEY (Method_ID)
        REFERENCES Payment_Method(Method_ID)
);

CREATE TABLE Loan (
    Loan_ID INT IDENTITY,
    Book_ID INT,
    Member_ID INT,
    Payment_ID INT,
    Loan_Date DATE NOT NULL,
    Due_Date DATE NOT NULL,
    Return_Date DATE,
    Status VARCHAR(20) CHECK (Status IN ('Issued', 'Returned', 'Overdue')) DEFAULT 'Issued',
    CONSTRAINT PK_Loan_ID PRIMARY KEY (Loan_ID),
    CONSTRAINT FK_Loan_Book_ID FOREIGN KEY (Book_ID)
        REFERENCES Book(Book_ID),
    CONSTRAINT FK_Loan_Member_ID FOREIGN KEY (Member_ID)
        REFERENCES Member(Member_ID),
    CONSTRAINT FK_Loan_Payment_ID FOREIGN KEY (Payment_ID)
        REFERENCES Payment(Payment_ID)
);

CREATE TABLE Review (
    Review_ID INT IDENTITY,
    Member_ID INT,
    Book_ID INT,
    Review_Date DATE NOT NULL,
    Comments NVARCHAR(255) DEFAULT 'No comments',
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    CONSTRAINT PK_Review_ID PRIMARY KEY (Review_ID),
    CONSTRAINT FK_Review_Member_ID FOREIGN KEY (Member_ID)
        REFERENCES Member(Member_ID),
    CONSTRAINT FK_Review_Book_ID FOREIGN KEY (Book_ID)
        REFERENCES Book(Book_ID)
);

CREATE TABLE Transaction_Efficiency (
    Loan_ID INT,
    Week INT,
    Success_Rate FLOAT,
    Processing_Time INT,
    CONSTRAINT PK_Transaction_Efficiency PRIMARY KEY (Loan_ID, Week),
    CONSTRAINT FK_TE_Loan_ID FOREIGN KEY (Loan_ID)
        REFERENCES Loan(Loan_ID)
); 

----------------------------------insert all data in the tabls----------------------

INSERT INTO Library (Name, Location, Contact_Number, Established_Year) VALUES 
('Central Library', 'City Center', '123456789', 1995),
('North Branch', 'North Ave', '987654321', 2005),
('East Reading Hall', 'East Blvd', '112233445', 2010);

SELECT * FROM Library
--------------------------------------------
INSERT INTO Book (ISBN, Title, Genre, Price, Shelf_Location, Library_ID) VALUES 
('9780001', 'Intro to AI', 'Non-fiction', 25.00, 'A1', 1),
('9780002', 'Python Basics', 'Non-fiction', 30.00, 'A2', 1),
('9780003', 'C# Guide', 'Reference', 28.50, 'A3', 1),
('9780004', 'Data Science', 'Non-fiction', 35.00, 'B1', 2),
('9780005', 'Algorithms', 'Reference', 40.00, 'B2', 2),
('9780006', 'Children''s World', 'Children', 15.00, 'C1', 2),
('9780007', 'Harry Potter', 'Fiction', 20.00, 'C2', 2),
('9780008', 'Narnia', 'Fiction', 22.00, 'D1', 3),
('9780009', 'Chemistry 101', 'Reference', 26.00, 'D2', 3),
('9780010', 'Story Time', 'Children', 18.00, 'E1', 3);

SELECT * FROM Book
-------------------------------
INSERT INTO Member (Name, Email, Phone, Membership_Start_Date) VALUES 
('Ahmed', 'ahmed@example.com', '111111111', '2022-01-01'),
('Sara', 'sara@example.com', '222222222', '2022-02-01'),
('Khalid', 'khalid@example.com', '333333333', '2022-03-01'),
('Fatma', 'fatma@example.com', '444444444', '2022-04-01'),
('Yousef', 'yousef@example.com', '555555555', '2022-05-01'),
('Noor', 'noor@example.com', '666666666', '2022-06-01');

SELECT * FROM Member
------------------------------
INSERT INTO Staff (Full_Name, Position, Contract, Library_ID) VALUES 
('Ali Hassan', 'Manager', 'Full-time', 1),
('Laila Said', 'Assistant', 'Part-time', 1),
('Salem Nasser', 'IT', 'Full-time', 2),
('Mona Talib', 'Receptionist', 'Part-time', 3);


SELECT * FROM Staff
---------------------------------

INSERT INTO Payment_Method (Method_Name) VALUES ('cash'), ('credit');

SELECT * FROM Payment_Method
------------------------------------------------------
INSERT INTO Payment (Date, Amount, Method_ID) VALUES 
('2024-01-01', 25.00, 1),
('2024-01-10', 30.00, 2),
('2024-02-15', 20.00, 1),
('2024-03-01', 40.00, 2);

SELECT * FROM Payment
-------------------------------------------------

INSERT INTO Loan (Book_ID, Member_ID, Payment_ID, Loan_Date, Due_Date, Return_Date, Status) VALUES 
(1, 1, 3, '2024-01-01', '2024-01-15', '2024-01-10', 'Returned'),
(2, 2, 4, '2024-01-04', '2024-01-18', '2024-01-18', 'Returned'),
(3, 3, 5, '2024-01-07', '2024-01-21', '2024-01-27', 'Overdue'),
(4, 4, 6, '2024-01-10', '2024-01-24', NULL, 'Issued'),
(5, 5, 7, '2024-01-13', '2024-01-27', NULL, 'Issued'),
(6, 6, 8, '2024-01-16', '2024-01-30', NULL, 'Issued'),
(7, 1, 9, '2024-01-19', '2024-02-02', '2024-01-29', 'Returned'),
(8, 2, 10, '2024-01-22', '2024-02-05', '2024-02-10', 'Overdue');

SELECT * FROM Loan

-----------------------------------------------------------------------------------------
INSERT INTO Review (Member_ID, Book_ID, Review_Date, Comments, Rating) VALUES 
(1, 1, '2024-01-15', 'Excellent', 5),
(2, 2, '2024-01-18', 'Very good', 4),
(3, 3, '2024-01-20', 'Good', 3),
(4, 4, '2024-01-22', 'Nice', 4),
(5, 5, '2024-01-25', 'Interesting', 5),
(6, 6, '2024-01-28', 'Loved it', 5);


SELECT * FROM Review 
-----------------------------------------------------

INSERT INTO Transaction_Efficiency (Loan_ID, Week, Success_Rate, Processing_Time) VALUES 
(5, 1, 95.5, 2),
(6, 2, 96.0, 1),
(7, 1, 90.0, 3),
(8, 2, 91.5, 2),
(9, 1, 88.0, 4),
(10, 2, 87.0, 5),
(11, 1, 85.0, 2),
(12, 2, 84.5, 2);
 

SELECT * FROM Transaction_Efficiency 