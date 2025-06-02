--Functions – Reusable Logic

USE LibrarySystemDB;
GO

--1. GetBookAverageRating(BookID) Returns average rating of a book

CREATE FUNCTION GetBookAverageRating (@BookID INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @AverageRating FLOAT;

    SELECT @AverageRating = AVG(CAST(Rating AS FLOAT))
    FROM Review
    WHERE Book_ID = @BookID;

    RETURN @AverageRating;
END;

SELECT dbo.GetBookAverageRating(1) AS AverageRating;

--2. GetNextAvailableBook(Genre, Title, LibraryID) --> Fetches the next available book 
CREATE FUNCTION GetNextAvailableBook0 (
    @Genre NVARCHAR(100),
    @Title NVARCHAR(200),
    @LibraryID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP 1 Book_ID, Title, Genre, Library_ID, Price, Availability_Status
    FROM Book
    WHERE Genre = @Genre
      AND Title = @Title
      AND Library_ID = @LibraryID
     AND Availability_Status = 1

    ORDER BY Price ASC
);

SELECT * 
FROM dbo.GetNextAvailableBook0('Fantasy', 'Harry Potter', 2);

--3. CalculateLibraryOccupancyRate(LibraryID)--> Returns % of books currently issued 

CREATE FUNCTION CalculateLibraryOccupancyRate (
    @LibraryID INT
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @TotalBooks INT
    DECLARE @IssuedBooks INT
    DECLARE @Rate DECIMAL(5,2)

	SELECT @TotalBooks = COUNT(*)
    FROM Book
    WHERE Library_ID = @LibraryID;

    SELECT @IssuedBooks = COUNT(DISTINCT l.Book_ID)
    FROM Loan l
    JOIN Book b ON l.Book_ID = b.Book_ID
    WHERE b.Library_ID = @LibraryID
      AND l.Status = 'Issued';

    IF @TotalBooks = 0
        SET @Rate = 0;
    ELSE
        SET @Rate = (CAST(@IssuedBooks AS DECIMAL(5,2)) / @TotalBooks) * 100;

    RETURN @Rate;
END;

SELECT dbo.CalculateLibraryOccupancyRate(1) AS OccupancyRate;

--4. fn_GetMemberLoanCount-->  Return the total number of loans made by a given member

CREATE FUNCTION fn_GetMemberLoanCount (
    @MemberID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @LoanCount INT;

    SELECT @LoanCount = COUNT(*)
    FROM Loan
    WHERE Member_ID = @MemberID;

    RETURN @LoanCount;
END;

SELECT dbo.fn_GetMemberLoanCount(1) AS TotalLoans;

--5. fn_GetLateReturnDays--> Return the number of late days for a loan (0 if not late)

CREATE FUNCTION fn_GetLateReturnDays (
    @LoanID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @LateDays INT;

    SELECT @LateDays = 
        CASE 
            WHEN Return_Date IS NOT NULL AND Return_Date > Due_Date THEN DATEDIFF(DAY, Due_Date, Return_Date)
            ELSE 0
        END
    FROM Loan
    WHERE Loan_ID = @LoanID;

    RETURN @LateDays;
END;

SELECT dbo.fn_GetLateReturnDays(3) AS LateDays;

--6.fn_ListAvailableBooksByLibrary--> Returns a table of available books from a specific library.
CREATE FUNCTION fn_ListAvailableBooksByLibrary (
    @LibraryID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        B.Book_ID,
        B.Title,
        B.Genre,
        B.Price
    FROM 
        Book B
    WHERE 
        B.Library_ID = @LibraryID
        AND NOT EXISTS (
            SELECT 1
            FROM Loan L
            WHERE L.Book_ID = B.Book_ID
              AND L.Return_Date IS NULL
        )
);


SELECT * FROM dbo.fn_ListAvailableBooksByLibrary(2);

--7. fn_GetTopRatedBooks--> Returns books with average rating ≥ 4.5

CREATE FUNCTION fn_GetTopRatedBooks()
RETURNS TABLE
AS
RETURN
(
    SELECT 
        B.Book_ID,
        B.Title,
        AVG(R.Rating) AS AverageRating
    FROM 
        Book B
    JOIN 
        Review R ON B.Book_ID = R.Book_ID
    GROUP BY 
        B.Book_ID, B.Title
    HAVING 
        AVG(R.Rating) >= 4.5
);

SELECT * FROM fn_GetTopRatedBooks();

--8. fn_FormatMemberName-->  Returns  the  full  name  formatted  as  "LastName, FirstName"
CREATE FUNCTION fn_FormatMemberName (
    @MemberID INT
)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @FullName NVARCHAR(200);

    SELECT @FullName = Name + ', ' 
    FROM Member
    WHERE Member_ID = @MemberID;

    RETURN @FullName;
END;

SELECT dbo.fn_FormatMemberName(1) AS FormattedName;


