create procedure  [dbo].[sp_BOOKS_CATEGORIES_insertion]
                                               
                                               
          @BOOK_CAT_HD_ID  numeric,
          @BOOK_CAT_BR_ID  numeric,
          @BOOK_CAT_NAME  nvarchar(100) ,
          @BOOK_CAT_DESCRIPTION  nvarchar(500) ,
          @BOOK_CAT_STATUS  char(1) 
   
   
     as  begin
   
   
     insert into BOOKS_CATEGORIES
     values
     (
        @BOOK_CAT_HD_ID,
        @BOOK_CAT_BR_ID,
        @BOOK_CAT_NAME,
        @BOOK_CAT_DESCRIPTION,
        @BOOK_CAT_STATUS
     
     
     )
     
end