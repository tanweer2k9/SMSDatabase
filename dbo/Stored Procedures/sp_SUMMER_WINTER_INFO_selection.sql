CREATE procedure  [dbo].[sp_SUMMER_WINTER_INFO_selection]
                                               
                                               
     @STATUS char(10),
     @SUM_WIN_SESSION_ID  numeric,
     @SUM_WIN_HD_ID  numeric,
     @SUM_WIN_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   
		SELECT * FROM VSUMMER_WINTER_INFO where [Institute ID] = @SUM_WIN_HD_ID and [Branch ID] = @SUM_WIN_BR_ID and [Session ID] = @SUM_WIN_SESSION_ID
     END  
     
	 ELSE IF @STATUS = 'C'
	 BEGIN
		select COUNT(*) from VSUMMER_WINTER_INFO where [Session ID] in ( select BR_ADM_SESSION from BR_ADMIN where BR_ADM_ID = @SUM_WIN_BR_ID)
	 END


     END