# Library Management System – DB Project Part 2

✅ SELECT Queries

1. GET /loans/overdue → List all overdue loans with member name, book title, due date

      ![](SelectQueriesImage/Q1.png) 

 2. GET /books/unavailable → List books not available
	
     ![](SelectQueriesImage/Q2.png) 


3. GET /members/top-borrowers → Members who borrowed >2 books 


    ![](SelectQueriesImage/Q3.png) 

4. GET /books/:id/ratings → Show average rating per book -- Declare the variable

    
    ![](SelectQueriesImage/Q4.png) 


5. GET /libraries/:id/genres → Count books by genre

     
    ![](SelectQueriesImage/Q5.png)

 6. GET /members/inactive → List members with no loans

      ![](SelectQueriesImage/Q6.png)
 


 7. GET /payments/summary → Total fine paid per member

       ![](SelectQueriesImage/Q7.png)

 8. GET /reviews → Reviews with member and book info

      ![](SelectQueriesImage/Q8.png)

9. GET /books/popular → List top 3 books by number of times they were loaned

      ![](SelectQueriesImage/Q9.png)

10. GET /members/:id/history → Retrieve full loan history of a specific member including book title, loan & return dates

     ![](SelectQueriesImage/Q10.png)

11. GET /books/:id/reviews → Show all reviews for a book with member name and comments

       ![](SelectQueriesImage/Q11.png)
 
  12. GET /libraries/:id/staff → List all staff working in a given library

         ![](SelectQueriesImage/Q12.png)

 13. GET /books/price-range?min=5&max=15 → Show books whose prices fall within a given range

       ![](SelectQueriesImage/Q13.png)

14. GET /loans/active → List all currently active loans (not yet returned) with member and book info
       
      ![](SelectQueriesImage/Q14.png)

 15. GET /members/with-fines → List members who have paid any fine

        ![](SelectQueriesImage/Q15.png)

 16. GET /books/never-reviewed →  List books that have never been reviewed

       ![](SelectQueriesImage/Q16.png)

17. GET /members/:id/loan-history →Show a member’s loan history with book titles and loan status

       ![](SelectQueriesImage/Q17.png)

 18. GET /members/inactive →List all members who have never borrowed any book.
 
        ![](SelectQueriesImage/Q18.png)
  
 
  19. GET /books/never-loaned → List books that were never loaned
  
        ![](SelectQueriesImage/Q19.png)

20. GET /payments →List all payments with member name and book title

      ![](SelectQueriesImage/Q20.png)
 
 21. GET /loans/overdue→ List all overdue loans with member and book details

       ![](SelectQueriesImage/Q21.png)

 22. GET /books/:id/loan-count → Show how many times a book has been loaned
  
       ![](SelectQueriesImage/Q22.png)

23. GET /members/:id/fines → Get total fines paid by a member across all loans
 
       ![](SelectQueriesImage/Q23.png)

 24. GET /libraries/:id/book-stats → Show count of available and unavailable books in a library
 
        ![](SelectQueriesImage/Q24.png)

 25. GET /reviews/top-rated → Return books with more than 5 reviews and average rating > 4.5.
  
        ![](SelectQueriesImage/Q25.png)
  
✅  Indexing Strategy – Performance Optimization

Apply indexes to speed up commonly-used queries: 

1. Library Table 

• Non-clustered on Name → Search by name 

   ![](IndexesSqlImage/Q1.png)

• Non-clustered on Location → Filter by location 

   ![](IndexesSqlImage/Q2.png)



2. Book Table 

• Clustered on LibraryID, ISBN → Lookup by book in specific library

   ![](IndexesSqlImage/Q3.png)


• Non-clustered on Genre → Filter by genre 

   ![](IndexesSqlImage/Q4.png)



3. Loan Table 

• Non-clustered on MemberID → Loan history

  ![](IndexesSqlImage/Q5.png)

• Non-clustered on Status → Filter by status 

   ![](IndexesSqlImage/Q6.png)


• Composite index on BookID, LoanDate, ReturnDate → Optimize overdue checks 
 
   ![](IndexesSqlImage/Q7.png)


✅  Views – Frontend Integration Support 

1. ViewPopularBooks --> Books with average rating > 4.5 + total loans 

   ![](ViewsSqlImage/Q1.png)

2. ViewMemberLoanSummary --> Member loan count + total fines paid

   ![](ViewsSqlImage/Q2.png)

3. ViewAvailableBooks --> Available books grouped by genre, ordered by price

   ![](ViewsSqlImage/Q3.png)

4. ViewLoanStatusSummary --> Loan stats (issued, returned, overdue) per library
      
      ![](ViewsSqlImage/Q4.png)

 
5. ViewPaymentOverview--> Payment info with member, book, and status. 

     ![](ViewsSqlImage/Q5.png)

✅ Functions – Reusable Logic

1. GetBookAverageRating(BookID) Returns average rating of a book

    ![](FunctionSqlImage/Q1.png)

 2. GetNextAvailableBook(Genre, Title, LibraryID) --> Fetches the next available book 

  ![](FunctionSqlImage/Q2.png)

    
3. CalculateLibraryOccupancyRate(LibraryID)--> Returns % of books currently issued 
      
      ![](FunctionSqlImage/Q3.png)
    
4. fn_GetMemberLoanCount-->  Return the total number of loans made by a given member

     ![](FunctionSqlImage/Q4.png)


5. fn_GetLateReturnDays--> Return the number of late days for a loan (0 if not late)

    ![](FunctionSqlImage/Q5.png)

 
6. fn_ListAvailableBooksByLibrary--> Returns a table of available books from a specific library.

   ![](FunctionSqlImage/Q6.png)


 7. fn_GetTopRatedBooks--> Returns books with average rating ≥ 4.5

     ![](FunctionSqlImage/Q7.png)
 

 8. fn_FormatMemberName-->  Returns  the  full  name  formatted  as  "LastName, FirstName"

    ![](FunctionSqlImage/Q8.png)
 
✅ Stored Procedures – Backend Automation

1. sp_MarkBookUnavailable(BookID)--> Updates availability after issuing 

    ![](StoredProceduresImage/Q1.png)


2. sp_UpdateLoanStatus()--> Checks dates and updates loan statuses
      
        
    ![](StoredProceduresImage/Q2.png)



3. sp_RankMembersByFines()--> Ranks members by total fines paid 

    
    ![](StoredProceduresImage/Q3.png)

✅ Triggers – Real-Time Business Logic

1. trg_UpdateBookAvailability After new loan → set book to unavailable 

     
    ![](TriggersImage/Q1.png)


2. trg_CalculateLibraryRevenue After new payment → update library revenue

     ![](TriggersImage/Q2.png) 

3. trg_LoanDateValidation Prevents invalid return dates on insert

      ![](TriggersImage/Q3.png)

✅ Aggregation Functions – Dashboard Reports


1. Total fines per member 


      ![](AggregationsImage/Q1.png) 


2.  Most active libraries (by loan count) 

   ![](AggregationsImage/Q2.png) 




3.  Avg book price per genre 


      ![](AggregationsImage/Q3.png) 




4. Top 3 most reviewed books 


   ![](AggregationsImage/Q4.png) 



5. Library revenue report 


  ![](AggregationsImage/Q5.png)  



6.  Member activity summary (loan + fines)

       ![](AggregationsImage/Q6.png) 
 

✅ Advanced Aggregations – Analytical Insight




1. HAVING for filtering aggregates 


  ![](AdvancedAggregationsImage/Q1.png)    




2.  Subqueries for complex logic (e.g., max price per genre) 

      
  ![](AdvancedAggregationsImage/Q2.png)   



3.  Occupancy rate calculations 

   
  ![](AdvancedAggregationsImage/Q3.png)  



4. Members with loans but no fine

   

  ![](AdvancedAggregationsImage/Q4.png)  


5. Genres with high average ratings

    
  ![](AdvancedAggregationsImage/Q5.png) 