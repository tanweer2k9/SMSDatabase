create procedure  [dbo].[sp_CONDUCT_INFO_selection]
                                               
                                               
     @STATUS char(10),
     @CONDUCT_ID  numeric,
     @CONDUCT_HD_ID  numeric,
     @CONDUCT_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN
   
       SELECT  [ID],[Name],[Description],[Status] FROM VCONDUCT_INFO
		where 
		 [Institute ID] = @CONDUCT_HD_ID and
		 [Branch ID] = @CONDUCT_BR_ID and
		 [Status] != 'D' 
     END  
     ELSE
     BEGIN
  SELECT * FROM CONDUCT_INFO
 
 
     WHERE
     CONDUCT_ID =  @CONDUCT_ID and 
     CONDUCT_HD_ID =  @CONDUCT_HD_ID and 
     CONDUCT_BR_ID =  @CONDUCT_BR_ID 
 
     END
 
     END