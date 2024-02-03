CREATE procedure  [dbo].[sp_FEE_SETTING_selection]
                                               
                                               
     @STATUS char(10),
     @FEE_SETTING_ID  numeric,
     @FEE_SETTING_HD_ID  numeric,
     @FEE_SETTING_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   
     SELECT * FROM VFEE_SETTING
     END  
     ELSE IF  @STATUS = 'B'
     BEGIN
  
  SELECT * FROM VFEE_SETTING
 
 
     WHERE
     --ID =  @FEE_SETTING_ID and 
     [Institute ID] =  @FEE_SETTING_HD_ID and 
     [Branch ID] =  @FEE_SETTING_BR_ID
 
     END
 
 
     END