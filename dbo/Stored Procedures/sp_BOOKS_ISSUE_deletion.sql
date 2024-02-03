CREATE PROCEDURE  [dbo].[sp_BOOKS_ISSUE_deletion]
                                               
                                               
          @STATUS char(10),
          @BOOKS_ISSUE_ID  numeric,
          @BOOKS_ISSUE_HD_ID  numeric,
          @BOOKS_ISSUE_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from BOOKS_ISSUE
 
 
     where 
          BOOKS_ISSUE_ID =  @BOOKS_ISSUE_ID 
 
end