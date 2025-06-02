--==USE THE LibrarySystemDB DATABASE===
USE LibrarySystemDB;
GO
-->1. GET /loans/overdue → List all overdue loans with member name, book title, due date 
SELECT 
    M.Name AS Member_Name,
    B.Title AS Book_Title,
    L.Due_Date
FROM 
    Loan  L
JOIN 
    Member M ON L.Member_ID = M.Member_ID
JOIN 
    Book B ON L.Book_ID = B.Book_ID
WHERE 
    L.Status = 'Overdue';


--> 2. GET /books/unavailable → List books not available 
SELECT 
    Book_ID,
    Title,
    ISBN,
    Genre,
    Shelf_Location,
    Availability_Status
FROM 
    Book
WHERE 
    Availability_Status = 0;


	UPDATE Book
SET Availability_Status = 0
WHERE Book_ID IN (3, 5);

--> 3. GET /members/top-borrowers → Members who borrowed >2 books 
SELECT 

     M.Name, COUNT(*) AS BorrowedBooks
FROM 
     Loan L
JOIN
      Member M ON L.Member_ID = M.Member_ID
GROUP BY
           M.Name
HAVING COUNT(*) > 1;

-->4. GET /books/:id/ratings → Show average rating per book 
-- Declare the variable

DECLARE @BookID INT = 1;
SELECT AVG(Rating) AS AverageRating
FROM Review
WHERE Book_ID = @BookID;

--> 5. GET /libraries/:id/genres → Count books by genre 
SELECT 
    Genre,
    COUNT(*) AS CountPerGenre
FROM 
    Book
WHERE 
    Library_ID = 2
GROUP BY 
    Genre;

--> 6. GET /members/inactive → List members with no loans 
SELECT 
    M.*
FROM 
    Member M
LEFT JOIN 
    Loan L ON M.Member_ID = L.Member_ID
WHERE 
     M.Member_ID IS NULL;

SELECT * FROM Member

SELECT * FROM Loan

--> 7. GET /payments/summary → Total fine paid per member

SELECT 
    M.Member_ID,
    M.Name,
    SUM(P.Amount) AS Total_Fine_Paid
FROM 
    Member M
JOIN 
    Loan L ON M.Member_ID = L.Member_ID
JOIN 
    Payment P ON L.Payment_ID = P.Payment_ID
GROUP BY 
    M.Member_ID, M.Name
ORDER BY 
    Total_Fine_Paid DESC;

--> 8. GET /reviews → Reviews with member and book info
SELECT 
   
    M.Name AS Member_Name,
    B.Title AS Book_Title,
    R.Comments,
    R.Rating
FROM 
    Review R
JOIN 
    Member M ON R.Member_ID = M.Member_ID
JOIN 
    Book B ON R.Book_ID = B.Book_ID

--> 9. GET /books/popular → List top 3 books by number of times they were loaned
SELECT TOP 3 
    B.Book_ID,
    B.Title,
    COUNT(L.Loan_ID) AS Times_Loaned
FROM 
    Book B
JOIN 
    Loan L ON B.Book_ID = L.Book_ID
GROUP BY 
    B.Book_ID, B.Title
ORDER BY 
    Times_Loaned DESC;

--> 10. GET /members/:id/history → Retrieve full loan history of a specific member including book title, loan & return dates
SELECT 
    L.Loan_ID,
    B.Title AS Book_Title,
    L.Loan_Date,
    L.Due_Date,
    L.Return_Date,
    L.Status
FROM 
    Loan L
JOIN 
    Book B ON L.Book_ID = B.Book_ID
WHERE 
     L.Member_ID = 1

ORDER BY 
    L.Loan_Date DESC;

--> 11. GET /books/:id/reviews → Show all reviews for a book with member name and comments
DECLARE @BookID INT = 1;
SELECT M.Name, R.Comments
FROM Review R
JOIN Member M ON r.Member_ID = M.Member_ID
WHERE R.Book_ID = @BookID;

--> 12. GET /libraries/:id/staff → List all staff working in a given library
   SELECT 
    Staff_ID,
    Full_Name,
    Position,
    Contract
FROM 
    Staff
WHERE 
    Library_ID = 1;

--> 13. GET /books/price-range?min=5&max=15 → Show books whose prices fall within a given range 
SELECT 
    Book_ID,
    Title,
    Price,
    Genre,
    Shelf_Location
FROM 
    Book
WHERE 
    Price BETWEEN 5 AND 15;

--> 14. GET /loans/active → List all currently active loans (not yet returned) with member and book info

SELECT 
    L.Loan_ID,
    M.Name AS Member_Name,
    B.Title AS Book_Title,
    L.Loan_Date,
    L.Due_Date,
    L.Status
FROM 
    Loan  L 
JOIN 
    Member M ON L.Member_ID = M.Member_ID
JOIN 
    Book B ON L.Book_ID = B.Book_ID
WHERE 
    L.Return_Date IS NULL;

--> 15. GET /members/with-fines → List members who have paid any fine

SELECT DISTINCT 
    M.*
FROM 
    Loan L
JOIN 
    Member M ON L.Member_ID = M.Member_ID
JOIN 
    Payment P ON L.Payment_ID = P.Payment_ID
WHERE 
    P.Amount > 0;

--> 16. GET /books/never-reviewed →  List books that have never been reviewed

SELECT 
    B.Book_ID,
    B.Title,
    B.ISBN,
    B.Genre,
    B.Price
FROM 
    Book B
LEFT JOIN 
    Review R ON B.Book_ID = R.Book_ID
WHERE 
    R.Review_ID IS NULL;

--> 17. GET /members/:id/loan-history →Show a member’s loan history with book titles and loan status
SELECT 
  
  B.Title AS Book_Title,
    L.Loan_Date,
    L.Due_Date,
    L.Return_Date,
    L.Status
FROM 
    Loan L
INNER JOIN 
    Book B ON L.Book_ID = B.Book_ID
WHERE 
    L.Member_ID = 1
ORDER BY 
    L.Loan_Date DESC;

--> 18. GET /members/inactive →List all members who have never borrowed any book.

SELECT 
    M.*
FROM 
    Member M
LEFT JOIN 
    Loan L ON M.Member_ID = L.Member_ID
WHERE
    M.Member_ID  IS  NULL;


SELECT * FROM Member

SELECT * FROM Loan 

--> 19. GET /books/never-loaned → List books that were never loaned
SELECT 
    B.*
FROM 
    Book B
LEFT JOIN 
    Loan L ON B.Book_ID = L.Book_ID
WHERE 
    L.Loan_ID IS NULL;

--> 20. GET /payments →List all payments with member name and book title

SELECT
     M.Name,
     B.Title,
     P.Amount
FROM 
     Payment P
JOIN  
     Loan L ON P.Payment_ID = L.Payment_ID
JOIN 
     Member M ON L.Member_ID = M.Member_ID
JOIN
      Book B ON L.Book_ID = B.Book_ID;

--> 21. GET /loans/overdue→ List all overdue loans with member and book details.
SELECT
    L.Loan_ID,
    M.Member_ID,
    M.Name AS MemberName,
    M.Email,
   M.Phone,
    B.Book_ID,
    B.Title AS BookTitle,
    B.Genre,
    B.Price,
    L.Loan_Date,
    L.Due_Date,
    L.Status
FROM
     Loan L
JOIN 
      Member M ON l.Member_ID = M.Member_ID
JOIN 
     Book B ON L.Book_ID = B.Book_ID
WHERE
         L.Status = 'Overdue';

--> 22. GET /books/:id/loan-count → Show how many times a book has been loaned

SELECT 
    B.Book_ID,
    B.Title,
    COUNT(L.Loan_ID) AS Loan_Count
FROM 
    Book B
LEFT JOIN 
    Loan L ON B.Book_ID = L.Book_ID
WHERE 
    B.Book_ID = 1
GROUP BY 
    B.Book_ID, B.Title;

--> 23. GET /members/:id/fines → Get total fines paid by a member across all loans

SELECT 
    M.Member_ID,
    M.Name,
    SUM(P.Amount) AS Total_Fines_Paid
FROM 
    Member M
JOIN 
    Loan L ON M.Member_ID = L.Member_ID
JOIN 
    Payment P ON L.Payment_ID = P.Payment_ID
WHERE 
    M.Member_ID = 1
GROUP BY 
    M.Member_ID, M.Name;

--> 24. GET /libraries/:id/book-stats → Show count of available and unavailable books in a library
SELECT 
    B.Library_ID,
    L.Name AS Library_Name,
    SUM(CASE WHEN B.Availability_Status = 1 THEN 1 ELSE 0 END) AS Available_Books,
    SUM(CASE WHEN B.Availability_Status = 0 THEN 1 ELSE 0 END) AS Unavailable_Books
FROM 
    Book B
JOIN 
    Library L ON B.Library_ID = L.Library_ID
WHERE 
    B.Library_ID = 1 
GROUP BY 
    B.Library_ID, L.Name;

--> 25. GET /reviews/top-rated → Return books with more than 5 reviews and average rating > 4.5.
SELECT 
    B.Book_ID,
    B.Title,
    COUNT(R.Review_ID) AS Review_Count,
    AVG(R.Rating) AS Average_Rating
FROM 
    Review R
JOIN 
    Book B ON B.Book_ID = R.Book_ID
GROUP BY 
    B.Book_ID, B.Title
HAVING 
    COUNT(R.Review_ID) >= 1
    AND AVG(R.Rating) >= 2;


	
