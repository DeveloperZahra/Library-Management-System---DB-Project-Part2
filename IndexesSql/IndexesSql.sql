--Index creation scripts to optimize query performance

USE LibrarySystemDB;
GO

--1.Library Table 
--• Non-clustered on Name → Search by name 
--• Non-clustered on Location → Filter by location

CREATE NONCLUSTERED INDEX IX_Library_Name
ON Library(Name);

SELECT * 
FROM Library 
WHERE Name = 'Central Library';

CREATE NONCLUSTERED INDEX IX_Library_Location
ON Library(Location);

SELECT DISTINCT Location FROM Library;
SELECT * FROM Library WHERE Location = 'Central';

--2.Book Table 
--• Clustered on LibraryID, ISBN → Lookup by book in specific library 
--• Non-clustered on Genre → Filter by genre

CREATE NONCLUSTERED INDEX IX_Book_LibraryID_ISBN ON Book(Library_ID, ISBN);

SELECT * FROM Book
WHERE Library_ID = 2 AND ISBN = '9780006';


CREATE NONCLUSTERED INDEX IX_Book_Genre ON Book(Genre);
SELECT * FROM Book
WHERE Genre = 'Reference';


--3.Loan Table 
--• Non-clustered on MemberID → Loan history 

CREATE NONCLUSTERED INDEX IX_Loan_MemberID
ON Loan(Member_ID);

SELECT * FROM Loan WHERE Member_ID = 4;

--• Non-clustered on Status → Filter by status 

CREATE NONCLUSTERED INDEX IX_Loan_Status
ON Loan(Status);

SELECT * FROM Loan WHERE Status = 'Overdue';


--• Composite index on BookID, LoanDate, ReturnDate → Optimize overdue checks

CREATE NONCLUSTERED INDEX IX_Loan_Book_LoanDate_ReturnDate
ON Loan(Book_ID, Loan_Date, Return_Date);

SELECT * FROM Loan
WHERE Return_Date IS NULL AND Due_Date < GETDATE();
