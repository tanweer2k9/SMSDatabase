CREATE procedure  [dbo].[sp_DEDUCTION_selection]
                                               
                                               
     @STATUS char(10),
     @DEDUCTION_ID  numeric,
     @DEDUCTION_HD_ID  numeric,
     @DEDUCTION_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN
  SELECT DEDUCTION_ID as ID, DEDUCTION_NAME as Name, DEDUCTION_DESCRIPTION as [Description], DEDUCTION_STATUS as [Status] FROM DEDUCTION
  
     WHERE     
     DEDUCTION_HD_ID =  @DEDUCTION_HD_ID and 
     DEDUCTION_BR_ID =  @DEDUCTION_BR_ID AND
     DEDUCTION_STATUS != 'D'
 
     END
 
     END