create procedure  [dbo].[sp_STAFF_ALLOWANCE_insertion]
                                               
                                               
          @STAFF_ALLOWANCE_HD_ID  numeric,
          @STAFF_ALLOWANCE_BR_ID  numeric,
          @STAFF_ALLOWANCE_ALLOW_ID  numeric,
          @STAFF_ALLOWANCE_VAL_TYPE  nvarchar(100) ,
          @STAFF_ALLOWANCE_TYPE  nvarchar(100) ,
          @STAFF_ALLOWANCE_MONTHS  nvarchar(100) ,
          @STAFF_ALLOWANCE_AMOUNT  float,
          @STAFF_ALLOWANCE_STAFF_ID  numeric,
          @STAFF_ALLOWANCE_DATE  datetime,
          @STAFF_ALLOWANCE_STATUS  char(2) 
   
   
     as  begin
   
   
     insert into STAFF_ALLOWANCE
     values
     (
        @STAFF_ALLOWANCE_HD_ID,
        @STAFF_ALLOWANCE_BR_ID,
        @STAFF_ALLOWANCE_ALLOW_ID,
        @STAFF_ALLOWANCE_VAL_TYPE,
        @STAFF_ALLOWANCE_TYPE,
        @STAFF_ALLOWANCE_MONTHS,
        @STAFF_ALLOWANCE_AMOUNT,
        @STAFF_ALLOWANCE_STAFF_ID,
        @STAFF_ALLOWANCE_DATE,
        @STAFF_ALLOWANCE_STATUS
     
     
     )
     
end