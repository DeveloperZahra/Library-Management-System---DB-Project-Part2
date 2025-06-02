 --Views – Frontend Integration Support

USE LibrarySystemDB;
GO
--1. ViewPopularBooks Books with average rating > 4.5 + total loans

CREATE VIEW ViewPopularBooks AS
SELECT 
    B.Book_ID,
    B.Title,
    AVG(R.Rating) AS AverageRating,
    COUNT(DISTINCT L.Loan_ID) AS TotalLoans
FROM 
    Book B
LEFT JOIN Review R ON B.Book_ID = R.Book_ID
LEFT JOIN Loan L ON B.Book_ID = L.Book_ID
GROUP BY 
    B.Book_ID, B.Title
HAVING 
    AVG(R.Rating) > 4.5;

SELECT * FROM ViewPopularBooks;


--2.ViewMemberLoanSummary Member loan count + total fines paid
CREATE VIEW ViewMemberLoanSummary AS
SELECT 
    m.Member_ID,
    m.Name AS MemberName,
    COUNT(l.Loan_ID) AS LoanCount,
    SUM(p.Amount) AS TotalFinesPaid
FROM 
    Member m
LEFT JOIN Loan l ON m.Member_ID = l.Member_ID
LEFT JOIN Payment p ON l.Payment_ID = p.Payment_ID
GROUP BY 
    m.Member_ID, m.Name;

SELECT * FROM ViewMemberLoanSummary;

--3.  ViewAvailableBooks Available books grouped by genre, ordered by price

	CREATE OR ALTER VIEW ViewAvailableBooks AS
SELECT TOP 100 PERCENT
    Genre,
    Title,
    Price
FROM Book
WHERE Availability_Status = 1
ORDER BY Genre, Price; 

SELECT * FROM ViewAvailableBooks;

--4. ViewLoanStatusSummary Loan stats (issued, returned, overdue) per library 

CREATE VIEW ViewLoanStatusSummary AS
SELECT 
    l.Library_ID,
    lib.Name AS LibraryName,
  
    SUM(CASE WHEN ln.Status = 'Issued' THEN 1 ELSE 0 END) AS IssuedCount,
   
    SUM(CASE WHEN ln.Status = 'Returned' THEN 1 ELSE 0 END) AS ReturnedCount,
   
    SUM(CASE WHEN ln.Status = 'Overdue' THEN 1 ELSE 0 END) AS OverdueCount
FROM 
    Loan ln
JOIN 
    Book l ON ln.Book_ID = l.Book_ID
JOIN 
    Library lib ON l.Library_ID = lib.Library_ID
GROUP BY 
    l.Library_ID, lib.Name;


SELECT * FROM ViewLoanStatusSummary;



--5. ViewPaymentOverview Payment info with member, book, and status
CREATE VIEW ViewPaymentOverview AS
SELECT 
    p.Payment_ID,
    p.Date AS PaymentDate,
    p.Amount,
    pm.Method_Name AS PaymentMethod,
    m.Member_ID,
    m.Name AS MemberName,
    b.Book_ID,
    b.Title AS BookTitle,
    l.Status AS LoanStatus
FROM 
    Payment p
JOIN 
    Payment_Method pm ON p.Method_ID = pm.Method_ID
JOIN 
    Loan l ON p.Payment_ID = l.Payment_ID
JOIN 
    Member m ON l.Member_ID = m.Member_ID
JOIN 
    Book b ON l.Book_ID = b.Book_ID;

SELECT * FROM ViewPaymentOverview;