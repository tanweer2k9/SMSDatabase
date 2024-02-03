create procedure  [dbo].[sp_BOOKS_ISSUE_insertion]
                                               
                                               
          @BOOKS_ISSUE_HD_ID  numeric,
          @BOOKS_ISSUE_BR_ID  numeric,
          @BOOKS_ISSUE_BOOK_INFO_ID  numeric,
          @BOOKS_ISSUE_BORROWER_TYPE  nvarchar(50) ,
          @BOOKS_ISSUE_BORROWER_ID  numeric,
          @BOOKS_ISSUE_DATE_BORROWED  date,
          @BOOKS_ISSUE_DUE_DATE  date,
          @BOOKS_ISSUE_DATE_RETURNED  date,
          @BOOKS_ISSUE_FINE_PER_DAY  int,
          @BOOKS_ISSUE_NOTES  nvarchar(200) ,
          @BOOKS_ISSUE_STATUS  nvarchar(50) 
   
   
     as  begin
   
   
     insert into BOOKS_ISSUE
     values
     (
        @BOOKS_ISSUE_HD_ID,
        @BOOKS_ISSUE_BR_ID,
        @BOOKS_ISSUE_BOOK_INFO_ID,
        @BOOKS_ISSUE_BORROWER_TYPE,
        @BOOKS_ISSUE_BORROWER_ID,
        @BOOKS_ISSUE_DATE_BORROWED,
        @BOOKS_ISSUE_DUE_DATE,
        @BOOKS_ISSUE_DATE_RETURNED,
        @BOOKS_ISSUE_FINE_PER_DAY,
        @BOOKS_ISSUE_NOTES,
        @BOOKS_ISSUE_STATUS
     
     
     )
     
end