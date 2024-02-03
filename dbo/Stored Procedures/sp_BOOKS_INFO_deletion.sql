CREATE PROCEDURE  [dbo].[sp_BOOKS_INFO_deletion]
                                               
                                               
          @STATUS char(10),
          @BOOKS_INFO_ID  numeric,
          @BOOKS_INFO_HD_ID  numeric,
          @BOOKS_INFO_BR_ID  numeric
   
   
     AS BEGIN 
   
   
    if (select COUNT(*) from BOOKS_ISSUE where BOOKS_ISSUE_BOOK_INFO_ID = @BOOKS_INFO_ID) = 0
	BEGIN
		update BOOKS_INFO set BOOKS_INFO_STATUS = 'D'  where BOOKS_INFO_ID =  @BOOKS_INFO_ID
		select 'ok'
	 END 
	 ELSE
	 BEGIN
		select 'This book is in use.'
	 END
 
end