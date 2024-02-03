

     CREATE PROCEDURE  [dbo].[sp_INSTALLMENT_INFO_deletion]
                                               
                                               
          @STATUS char(10),
          @INSTALLMENT_ID  numeric,
          @INSTALLMENT_HD_ID  numeric,
          @INSTALLMENT_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     update   INSTALLMENT_INFO set INSTALLMENT_STATUS = 'D'
 
 
     where 
          INSTALLMENT_ID =  @INSTALLMENT_ID 
 
end