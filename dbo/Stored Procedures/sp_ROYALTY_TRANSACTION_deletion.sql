CREATE PROCEDURE  [dbo].[sp_ROYALTY_TRANSACTION_deletion]
                                               
                                               
          @STATUS char(10),
          @ROYALTY_TRAN_ID  numeric,
          @ROYALTY_TRAN_HD_ID  numeric,
          @ROYALTY_TRAN_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from ROYALTY_TRANSACTION
 
 
     where 
          ROYALTY_TRAN_ID =  @ROYALTY_TRAN_ID and 

          ROYALTY_TRAN_BR_ID =  @ROYALTY_TRAN_BR_ID 
 
end