CREATE procedure  [dbo].[sp_BOOKS_CATEGORIES_selection]
                                               
                                               
     @STATUS char(10),
     @BOOK_CAT_ID  numeric,
     @BOOK_CAT_HD_ID  numeric,
     @BOOK_CAT_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN
   
		  SELECT ID,Name,Description,Status FROM VBOOKS_CATEGORIES where  [HD ID] = @BOOK_CAT_HD_ID and [BR ID] = @BOOK_CAT_BR_ID and Status != 'D'
     END  
   
     END