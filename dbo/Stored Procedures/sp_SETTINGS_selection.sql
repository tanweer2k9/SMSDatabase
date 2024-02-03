create procedure  [dbo].[sp_SETTINGS_selection]
                                               
                                               
     @STATUS char(10),
     @ID  numeric,
     @HD_ID  numeric,
     @BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   
     SELECT * FROM SETTINGS
     END  
     ELSE
     BEGIN
  SELECT * FROM SETTINGS
 
 
     WHERE
     ID =  @ID and 
     HD_ID =  @HD_ID and 
     BR_ID =  @BR_ID 
 
     END
 
     END