

     CREATE procedure  [dbo].[sp_INSTALLMENT_INFO_updation]
                                               
                                               
          @INSTALLMENT_ID  numeric,
          @INSTALLMENT_HD_ID  numeric,
          @INSTALLMENT_BR_ID  numeric,
          @INSTALLMENT_NAME  nvarchar(50) ,
          @INSTALLMENT_DESC  nvarchar(max) ,
          @INSTALLMENT_RANK  int,
          @INSTALLMENT_STATUS  char(2) 
   
   
     as begin 
   
   
     update INSTALLMENT_INFO
 
     set
          INSTALLMENT_NAME =  @INSTALLMENT_NAME,
          INSTALLMENT_DESC =  @INSTALLMENT_DESC,
          INSTALLMENT_RANK =  @INSTALLMENT_RANK,
          INSTALLMENT_STATUS =  @INSTALLMENT_STATUS
 
     where 
          INSTALLMENT_ID =  @INSTALLMENT_ID 
 
end