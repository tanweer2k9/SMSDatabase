CREATE procedure  [dbo].[sp_OVETIME_ADVANCE_selection]
                                               
                                               
     @STATUS char(10),
     @OVRTM_ADV_ID  numeric,
     @OVRTM_ADV_HD_ID  numeric,
     @OVRTM_ADV_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
		 BEGIN  		
			SELECT * FROM VOVERTIME_ADVANCE where [Institute ID] = @OVRTM_ADV_HD_ID and [Branch ID] = @OVRTM_ADV_BR_ID and Status != 'D'		
			select ID,[Employee Code],[First Name], [Last Name],[Department Name], Designation, [Basic Salary], City from VTEACHER_INFO
		 END  
     
 
     END