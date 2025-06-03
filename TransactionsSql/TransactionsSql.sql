--Transactions – Ensuring Consistency  


USE LibrarySystemDB;
GO

--1.  Borrowing a book (loan insert + update availability)

BEGIN TRANSACTION;

BEGIN TRY
    INSERT INTO Loan (Book_ID, Member_ID, Loan_Date, Due_Date, Status)
    VALUES (1, 5, GETDATE(), DATEADD(DAY, 14, GETDATE()), 'Issued');

    UPDATE Book
    SET IsAvailable = 0
    WHERE Book_ID = 1;

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Error occurred while borrowing a book.';
END CATCH;

SELECT * FROM Loan;


--2.  Returning a book (update status, return date, availability)

BEGIN TRANSACTION;

BEGIN TRY
    UPDATE Loan
    SET Return_Date = GETDATE(),
        Status = CASE 
                   WHEN Due_Date < GETDATE() THEN 'Overdue' 
                   ELSE 'Returned' 
                 END
    WHERE Loan_ID = 10;

    UPDATE Book
    SET IsAvailable = 1
    WHERE Book_ID = (SELECT Book_ID FROM Loan WHERE Loan_ID = 10);

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Error occurred while returning a book.';
END CATCH;

SELECT * FROM Loan;
SELECT * FROM Book;



--3.  Registering a payment (with validation) 

BEGIN TRANSACTION;

BEGIN TRY
    IF EXISTS (SELECT 1 FROM Payment_Method WHERE Method_ID = 2)
    BEGIN
        INSERT INTO Payment (Date, Amount, Method_ID)
        VALUES (GETDATE(), 25.00, 2);
        
        COMMIT;
    END
    ELSE
    BEGIN
        RAISERROR('Invalid payment method.', 16, 1);
    END
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Error occurred while registering payment.';
END CATCH;

SELECT * FROM Payment;


--4. Batch loan insert with rollback on failure

BEGIN TRANSACTION;

BEGIN TRY
    INSERT INTO Loan (Book_ID, Member_ID, Loan_Date, Due_Date, Status)
    VALUES 
    (1, 2, GETDATE(), DATEADD(DAY, 14, GETDATE()), 'Issued'),
    (3, 4, GETDATE(), DATEADD(DAY, 14, GETDATE()), 'Issued'),
    (5, 6, GETDATE(), DATEADD(DAY, 14, GETDATE()), 'Issued');

    UPDATE Book
    SET IsAvailable = 0
    WHERE Book_ID IN (1, 3, 5);

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Batch insert failed. All changes rolled back.';
END CATCH;

SELECT * FROM Loan;
