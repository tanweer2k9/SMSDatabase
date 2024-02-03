CREATE PROCEDURE  [dbo].[sp_DEDUCTION_deletion]
                                               
                                               
          @STATUS char(10),
          @DEDUCTION_ID  numeric,
          @DEDUCTION_HD_ID  numeric,
          @DEDUCTION_BR_ID  numeric
   
   
     AS BEGIN 
   
   UPDATE DEDUCTION SET DEDUCTION_STATUS = 'D' 
     where 
          DEDUCTION_ID =  @DEDUCTION_ID and 
          DEDUCTION_HD_ID =  @DEDUCTION_HD_ID and 
          DEDUCTION_BR_ID =  @DEDUCTION_BR_ID 
 
end