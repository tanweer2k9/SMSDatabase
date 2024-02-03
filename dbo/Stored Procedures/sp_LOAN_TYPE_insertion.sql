CREATE procedure  [dbo].[sp_LOAN_TYPE_insertion]
                                               
                                               
          @LOAN_TYPE_BASIC_INSTALLEMENT_NO  numeric,
          @LOAN_TYPE_MONTH  nvarchar(20) ,
          @LOAN_TYPE_YEAR  nvarchar(20) ,
          @LOAN_TYPE_AMOUNT  float,
          @LOAN_TYPE_LOAN_ID  numeric,
          @LOAN_TYPE_INSTALLEMENT_STATUS  char(2) ,
          @LOAN_TYPE_STATUS  char(2) 
   
   
     as  begin
   
   
     insert into LOAN_TYPE
     values
     (
        @LOAN_TYPE_BASIC_INSTALLEMENT_NO,
        @LOAN_TYPE_MONTH,
        @LOAN_TYPE_YEAR,
        @LOAN_TYPE_AMOUNT,
        @LOAN_TYPE_LOAN_ID,
        @LOAN_TYPE_INSTALLEMENT_STATUS,
        @LOAN_TYPE_STATUS
     
     
     )
     
end