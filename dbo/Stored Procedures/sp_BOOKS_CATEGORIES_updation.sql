create procedure  [dbo].[sp_BOOKS_CATEGORIES_updation]
                                               
                                               
          @BOOK_CAT_ID  numeric,
          @BOOK_CAT_HD_ID  numeric,
          @BOOK_CAT_BR_ID  numeric,
          @BOOK_CAT_NAME  nvarchar(100) ,
          @BOOK_CAT_DESCRIPTION  nvarchar(500) ,
          @BOOK_CAT_STATUS  char(1) 
   
   
     as begin 
   
   
     update BOOKS_CATEGORIES
 
     set
          BOOK_CAT_NAME =  @BOOK_CAT_NAME,
          BOOK_CAT_DESCRIPTION =  @BOOK_CAT_DESCRIPTION,
          BOOK_CAT_STATUS =  @BOOK_CAT_STATUS
 
     where 
          BOOK_CAT_ID =  @BOOK_CAT_ID 
 
end