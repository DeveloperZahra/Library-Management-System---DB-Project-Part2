--Aggregation Functions – Dashboard Reports


USE LibrarySystemDB;
GO
---------------------------------------------

--1. Total fines per member 

SELECT 
    M.Member_ID,
    M.Name + ' '  AS MemberName,
    SUM(P.Amount) AS TotalFines
FROM Member M
JOIN Loan L ON M.Member_ID = L.Member_ID
JOIN Payment P ON L.Payment_ID = P.Payment_ID
GROUP BY M.Member_ID, M.Name;



--2.  Most active libraries (by loan count) 


SELECT 
    Lib.Library_ID,
    Lib.Name AS LibraryName,
    COUNT(L.Loan_ID) AS LoanCount
FROM Library Lib
JOIN Book B ON Lib.Library_ID = B.Library_ID
JOIN Loan L ON B.Book_ID = L.Book_ID
GROUP BY Lib.Library_ID, Lib.Name
ORDER BY LoanCount DESC;



--3.  Avg book price per genre 


SELECT 
    Genre,
    AVG(Price) AS AveragePrice
FROM Book
GROUP BY Genre
ORDER BY AveragePrice DESC;



--4. Top 3 most reviewed books 


SELECT TOP 3 
    B.Book_ID,
    B.Title,
    COUNT(R.Review_ID) AS ReviewCount
FROM Book B
JOIN Review R ON B.Book_ID = R.Book_ID
GROUP BY B.Book_ID, B.Title
ORDER BY ReviewCount DESC;



--5. Library revenue report 


SELECT 
    L.Library_ID,
    L.Name AS LibraryName,
    SUM(P.Amount) AS TotalRevenue
FROM Library L
JOIN Book B ON L.Library_ID = B.Library_ID
JOIN Loan LN ON B.Book_ID = LN.Book_ID
JOIN Payment P ON LN.Payment_ID = P.Payment_ID
GROUP BY L.Library_ID, L.Name;



--6.  Member activity summary (loan + fines)

SELECT 
    M.Member_ID,
    M.Name + ' ' AS MemberName,
    COUNT(L.Loan_ID) AS TotalLoans,
    ISNULL(SUM(P.Amount), 0) AS TotalFines
FROM Member M
LEFT JOIN Loan L ON M.Member_ID = L.Member_ID
LEFT JOIN Payment P ON L.Payment_ID = P.Payment_ID
GROUP BY M.Member_ID, M.Name
ORDER BY TotalLoans DESC;

