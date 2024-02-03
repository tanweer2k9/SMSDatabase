

     create procedure  [dbo].[sp_INSTALLMENT_INFO_insertion]
                                               
                                               
          @INSTALLMENT_HD_ID  numeric,
          @INSTALLMENT_BR_ID  numeric,
          @INSTALLMENT_NAME  nvarchar(50) ,
          @INSTALLMENT_DESC  nvarchar(MAX) ,
          @INSTALLMENT_RANK  int,
          @INSTALLMENT_STATUS  char(2) 
   
   
     as  begin
   
   
     insert into INSTALLMENT_INFO
     values
     (
        @INSTALLMENT_HD_ID,
        @INSTALLMENT_BR_ID,
        @INSTALLMENT_NAME,
        @INSTALLMENT_DESC,
        @INSTALLMENT_RANK,
        @INSTALLMENT_STATUS
     
     
     )
     
end