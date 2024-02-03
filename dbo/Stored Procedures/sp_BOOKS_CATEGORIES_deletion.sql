CREATE PROCEDURE  [dbo].[sp_BOOKS_CATEGORIES_deletion]
                                               
                                               
          @STATUS char(10),
          @BOOK_CAT_ID  numeric,
          @BOOK_CAT_HD_ID  numeric,
          @BOOK_CAT_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     update BOOKS_CATEGORIES set BOOK_CAT_STATUS = 'D'
 
 
     where 
          BOOK_CAT_ID =  @BOOK_CAT_ID  
         
 
end