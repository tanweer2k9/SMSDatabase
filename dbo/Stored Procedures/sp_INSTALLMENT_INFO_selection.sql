
 
     CREATE procedure  [dbo].[sp_INSTALLMENT_INFO_selection]
                                               
                                               
     @STATUS char(10),
     @INSTALLMENT_ID  numeric,
     @INSTALLMENT_HD_ID  numeric,
     @INSTALLMENT_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   
     SELECT ID,Name,Description,Rank,Status FROM VINSTALLMENT_INFO where [Institute ID] = @INSTALLMENT_HD_ID and [Branch ID] = @INSTALLMENT_BR_ID and status != 'D' order by Rank
     END  
     ELSE
     BEGIN
  SELECT * FROM INSTALLMENT_INFO
 
 
     WHERE
     INSTALLMENT_ID =  @INSTALLMENT_ID and 
     INSTALLMENT_HD_ID =  @INSTALLMENT_HD_ID and 
     INSTALLMENT_BR_ID =  @INSTALLMENT_BR_ID 
 
     END
 
     END