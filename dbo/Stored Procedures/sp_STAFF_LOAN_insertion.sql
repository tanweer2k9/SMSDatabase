CREATE procedure  [dbo].[sp_STAFF_LOAN_insertion]
                                               
                                               
          @STAFF_LOAN_HD_ID  numeric,
          @STAFF_LOAN_BR_ID  numeric,
          @STAFF_LOAN_BASIC_SALARY  float,
          @STAFF_LOAN_AMOUNT_TYPE  nvarchar(100) ,
          @STAFF_LOAN_AMOUNT  float,
          @STAFF_LOAN_DEDUCTION_TYPE  nvarchar(100) ,
          @STAFF_LOAN_STAFF_ID  numeric,
          @STAFF_LOAN_DATE  datetime,
          @STAFF_LOAN_STATUS  char(2),
          @STAFF_LOAN_USER  nvarchar(100),
          @STAFF_LOAN_INSTALLS   numeric
   
   
     as  begin
   
   
     insert into STAFF_LOAN
     values
     (
        @STAFF_LOAN_HD_ID,
        @STAFF_LOAN_BR_ID,
        @STAFF_LOAN_BASIC_SALARY,
        @STAFF_LOAN_AMOUNT_TYPE,
        @STAFF_LOAN_AMOUNT,
        @STAFF_LOAN_DEDUCTION_TYPE,
        @STAFF_LOAN_STAFF_ID,
        @STAFF_LOAN_DATE,
        @STAFF_LOAN_STATUS,
        @STAFF_LOAN_USER,
        @STAFF_LOAN_INSTALLS
     
     
     )
     select MAX(STAFF_LOAN_ID) [ID] from STAFF_LOAN
     
end