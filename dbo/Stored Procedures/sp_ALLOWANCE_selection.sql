CREATE procedure  [dbo].[sp_ALLOWANCE_selection]
                                               
                                               
     @STATUS char(10),
     @ALLOWANCE_ID  numeric,
     @ALLOWANCE_HD_ID  numeric,
     @ALLOWANCE_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN
  SELECT ALLOWANCE_ID as ID, ALLOWANCE_NAME as Name, ALLOWANCE_DESCRIPTION as [Description], ALLOWANCE_STATUS as [Status] FROM ALLOWANCE
  
     WHERE     
     ALLOWANCE_HD_ID =  @ALLOWANCE_HD_ID and 
     ALLOWANCE_BR_ID =  @ALLOWANCE_BR_ID AND
     ALLOWANCE_STATUS != 'D'
 
     END
 
     END