--4. Stored Procedures – Backend Automation

USE LibrarySystemDB;
GO


--1. sp_MarkBookUnavailable(BookID) Updates availability after issuing 
CREATE OR ALTER PROCEDURE sp_MarkBookUnavailable
    @BookID INT
AS
BEGIN
    UPDATE Book
    SET Availability_Status = 0
    WHERE Book_ID = @BookID;
END;
GO

SELECT Book_ID, Title, Availability_Status FROM Book WHERE Book_ID = 1;

EXEC sp_MarkBookUnavailable @BookID = 1;


SELECT Book_ID, Title, Availability_Status FROM Book WHERE Book_ID = 1;



--2. sp_UpdateLoanStatus() Checks dates and updates loan statuses

CREATE PROCEDURE sp_UpdateLoanStatus
AS
BEGIN
    
    UPDATE Loan
    SET Status = 'Returned'
    WHERE Return_Date IS NOT NULL AND Return_Date <= Due_Date;

  
    UPDATE Loan
    SET Status = 'Overdue'
    WHERE Return_Date IS NOT NULL AND Return_Date > Due_Date;


    UPDATE Loan
    SET Status = 'Overdue'
    WHERE Return_Date IS NULL AND Due_Date < GETDATE();

    UPDATE Loan
    SET Status = 'Issued'
    WHERE Return_Date IS NULL AND Due_Date >= GETDATE();
END;

SELECT Loan_ID, Book_ID, Due_Date, Return_Date, Status FROM Loan;

EXEC sp_UpdateLoanStatus;

SELECT Loan_ID, Book_ID, Due_Date, Return_Date, Status FROM Loan;

--3. sp_RankMembersByFines() Ranks members by total fines paid 

CREATE OR ALTER PROCEDURE sp_RankMembersByFines
AS
BEGIN
    SELECT 
        m.Member_ID,
        m.Name,
        SUM(p.Amount) AS TotalFines
    FROM Member m
    JOIN Loan l ON m.Member_ID = l.Member_ID
    JOIN Payment p ON l.Payment_ID = p.Payment_ID
    GROUP BY m.Member_ID, m.Name
    ORDER BY TotalFines DESC;
END;
GO


EXEC sp_RankMembersByFines;