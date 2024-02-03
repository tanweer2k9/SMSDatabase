create procedure  [dbo].[sp_MARKETING_MODE_INFO_selection]
                                               
                                               
     @STATUS char(10),
     @MODE_ID  numeric,
     @MODE_HD_ID  numeric,
     @MODE_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   SELECT  [ID],[Name],[Description],[Status] FROM  VMARKETING_MODE_INFO
     where 
     [Institute ID] = @MODE_HD_ID and
     [Branch ID] = @MODE_BR_ID and
     [Status] != 'D' 
    
     END  
     ELSE
     BEGIN
  SELECT * FROM MARKETING_MODE_INFO
 
 
     WHERE
     MODE_ID =  @MODE_ID and 
     MODE_HD_ID =  @MODE_HD_ID and 
     MODE_BR_ID =  @MODE_BR_ID 
 
     END
 
     END