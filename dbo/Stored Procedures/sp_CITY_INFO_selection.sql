CREATE procedure  [dbo].[sp_CITY_INFO_selection]
                                               
                                               
     @STATUS char(10),
     @CITY_ID  numeric,
     @CITY_HD_ID  numeric,
     @CITY_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN
   
		SELECT  [ID],[Name],[Description],[Status] FROM VCITY_INFO
		where 
		 [Institute ID] = @CITY_HD_ID and
		 [Branch ID] = @CITY_BR_ID and
		 [Status] != 'D' 
     END  
     ELSE
     BEGIN
  SELECT * FROM CITY_INFO
 
 
     WHERE
     CITY_ID =  @CITY_ID and 
     CITY_HD_ID =  @CITY_HD_ID and 
     CITY_BR_ID =  @CITY_BR_ID 
 
     END
 
     END