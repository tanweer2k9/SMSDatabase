CREATE PROCEDURE  [dbo].[sp_COA_TRANS_deletion]
                                               
                                               
          @STATUS char(10),
          @COA_TRANS_ID  numeric,
          @COA_TRANS_HD_ID  numeric,
          @COA_TRANS_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     UPDATE COA_TRANS
 set COA_TRANS_STATUS = 'D'
 
     where 
          COA_TRANS_ID =  @COA_TRANS_ID and 
          COA_TRANS_HD_ID =  @COA_TRANS_HD_ID and 
          COA_TRANS_BR_ID =  @COA_TRANS_BR_ID 
 
end