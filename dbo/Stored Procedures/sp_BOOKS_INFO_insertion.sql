create procedure  [dbo].[sp_BOOKS_INFO_insertion]
                                               
                                               
          @BOOKS_INFO_HD_ID  numeric,
          @BOOKS_INFO_BR_ID  numeric,
          @BOOKS_INFO_BOOK_NO  nvarchar(50) ,
          @BOOKS_INFO_TITLE  nvarchar(100) ,
          @BOOKS_INFO_ISBN  nvarchar(50) ,
          @BOOKS_INFO_AUTHOR  nvarchar(100) ,
          @BOOKS_INFO_YEAR_PUBLISHED  int,
          @BOOKS_INFO_CATEGORY  numeric,
          @BOOKS_INFO_RACK_NO  nvarchar(50) ,
          @BOOKS_INFO_SHELF_NO  nvarchar(50) ,
          @BOOKS_INFO_DATE_ARRIVED  date,
          @BOOKS_INFO_PRICE  int,
          @BOOKS_INFO_QTY  int,
          @BOOKS_INFO_BOOK_STATUS  nvarchar(50) ,
          @BOOKS_INFO_STATUS  char(1) 
   
   
     as  begin
   
   
     insert into BOOKS_INFO
     values
     (
        @BOOKS_INFO_HD_ID,
        @BOOKS_INFO_BR_ID,
        @BOOKS_INFO_BOOK_NO,
        @BOOKS_INFO_TITLE,
        @BOOKS_INFO_ISBN,
        @BOOKS_INFO_AUTHOR,
        @BOOKS_INFO_YEAR_PUBLISHED,
        @BOOKS_INFO_CATEGORY,
        @BOOKS_INFO_RACK_NO,
        @BOOKS_INFO_SHELF_NO,
        @BOOKS_INFO_DATE_ARRIVED,
        @BOOKS_INFO_PRICE,
        @BOOKS_INFO_QTY,
        @BOOKS_INFO_BOOK_STATUS,
        @BOOKS_INFO_STATUS
     
     
     )
     
end