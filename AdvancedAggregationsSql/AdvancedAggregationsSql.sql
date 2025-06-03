--Advanced Aggregations – Analytical Insight 


USE LibrarySystemDB;
GO



--1. HAVING for filtering aggregates 


SELECT 
    B.Genre,
    AVG(R.Rating) AS AverageRating
FROM Book B
JOIN Review R ON B.Book_ID = R.Book_ID
GROUP BY B.Genre
HAVING AVG(R.Rating) > 4.0
ORDER BY AverageRating DESC;



--2.  Subqueries for complex logic (e.g., max price per genre) 


SELECT 
    M.Member_ID,
    M.Name + ' ' AS MemberName
FROM Member M
JOIN Loan L ON M.Member_ID = L.Member_ID
LEFT JOIN Payment P ON L.Payment_ID = P.Payment_ID
WHERE P.Payment_ID IS NULL
GROUP BY M.Member_ID, M.Name;


--3.  Occupancy rate calculations 
SELECT 
    Lib.Library_ID,
    Lib.Name AS LibraryName,
    COUNT(DISTINCT CASE WHEN L.Status = 'Issued' OR L.Status = 'Overdue' THEN B.Book_ID END) * 100.0 / 
    COUNT(DISTINCT B.Book_ID) AS OccupancyRate
FROM Library Lib
JOIN Book B ON Lib.Library_ID = B.Library_ID
LEFT JOIN Loan L ON B.Book_ID = L.Book_ID
GROUP BY Lib.Library_ID, Lib.Name;




--4. Members with loans but no fine

SELECT 
    Genre,
    Title,
    Price
FROM Book B
WHERE Price = (
    SELECT MAX(Price)
    FROM Book B2
    WHERE B2.Genre = B.Genre
);



--5. Genres with high average ratings

SELECT 
    Genre,
    COUNT(*) AS BookCount,
    AVG(Price) AS AveragePrice
FROM Book
GROUP BY Genre
HAVING COUNT(*) >= 3 AND AVG(Price) > 20;
