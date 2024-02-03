CREATE procedure  [dbo].[sp_HOUSES_INFO_selection]
                                               
                                               
     @STATUS char(10),
     @HOUSES_ID  numeric,
     @HOUSES_HD_ID  numeric,
     @HOUSES_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN
   
     SELECT  [ID],[Name],[Description],[Status] FROM VHOUSES_INFO
		where 
		 [Institute ID] = @HOUSES_HD_ID and
		 [Branch ID] = @HOUSES_BR_ID and
		 [Status] != 'D' 
     END  
     ELSE
     BEGIN
		  SELECT * FROM HOUSES_INFO
 
 
			 WHERE
			 HOUSES_ID =  @HOUSES_ID and 
			 HOUSES_HD_ID =  @HOUSES_HD_ID and 
			 HOUSES_BR_ID =  @HOUSES_BR_ID 
 
     END
 
     END