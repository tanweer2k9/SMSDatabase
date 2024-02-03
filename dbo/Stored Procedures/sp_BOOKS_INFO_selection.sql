CREATE procedure  [dbo].[sp_BOOKS_INFO_selection]
                                               
                                               
     @STATUS char(10),
     @BOOKS_INFO_ID  numeric,
     @BOOKS_INFO_HD_ID  numeric,
     @BOOKS_INFO_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN
   
		SELECT * FROM VBOOKS_INFO where [HD ID] = @BOOKS_INFO_HD_ID and [BR ID] = @BOOKS_INFO_BR_ID and status != 'D'
		select ID,Name from VBOOKS_CATEGORIES where [HD ID] = @BOOKS_INFO_HD_ID and [BR ID] = @BOOKS_INFO_BR_ID and status = 'T'
     END  
     
 
     END