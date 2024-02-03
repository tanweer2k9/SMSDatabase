CREATE procedure  [dbo].[sp_AREA_INFO_selection]
                                               
                                               
     @STATUS char(10),
     @AREA_ID  numeric,
     @AREA_HD_ID  numeric,
     @AREA_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN
   
		SELECT  [ID],[Name],[Description],[Status] FROM VAREA_INFO
		where 
		 [Institute ID] = @AREA_HD_ID and
		 [Branch ID] = @AREA_BR_ID and
		 [Status] != 'D' 
     END  
     ELSE
     BEGIN
  SELECT * FROM AREA_INFO
 
 
     WHERE
     AREA_ID =  @AREA_ID

 
     END
 
     END