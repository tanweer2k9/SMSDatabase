CREATE procedure  [dbo].[sp_STAFF_DEDUCTION_updation]
                                               
                                               
         @STAFF_DEDUCTION_ID  numeric,
          @STAFF_DEDUCTION_HD_ID  numeric,
          @STAFF_DEDUCTION_BR_ID  numeric,
          @STAFF_DEDUCTION_DED_ID  numeric ,
          @STAFF_DEDUCTION_VAL_TYPE  nvarchar(100) ,
          @STAFF_DEDUCTION_TYPE  nvarchar(100) ,
          @STAFF_DEDUCTION_MONTHS  nvarchar(100) ,
          @STAFF_DEDUCTION_PRCNT_BS  float,
          @STAFF_DEDUCTION_PRCNT_SS  float,
          @STAFF_DEDUCTION_STAFF_ID  numeric,
          @STAFF_DEDUCTION_REFUNDABLE  char(2) ,
          @STAFF_DEDUCTION_DATE  datetime,
          @STAFF_DEDUCTION_STATUS  char(2) 
   
   
     as begin 
   
   
     update STAFF_DEDUCTION
 
     set
          STAFF_DEDUCTION_DED_ID =  @STAFF_DEDUCTION_DED_ID,
          STAFF_DEDUCTION_VAL_TYPE =  @STAFF_DEDUCTION_VAL_TYPE,
          STAFF_DEDUCTION_TYPE =  @STAFF_DEDUCTION_TYPE,
          STAFF_DEDUCTION_MONTHS =  @STAFF_DEDUCTION_MONTHS,
          STAFF_DEDUCTION_PRCNT_BS =  @STAFF_DEDUCTION_PRCNT_BS,
          STAFF_DEDUCTION_PRCNT_SS =  @STAFF_DEDUCTION_PRCNT_SS,
          STAFF_DEDUCTION_STAFF_ID =  @STAFF_DEDUCTION_STAFF_ID,
          STAFF_DEDUCTION_REFUNDABLE =  @STAFF_DEDUCTION_REFUNDABLE,
          STAFF_DEDUCTION_DATE =  @STAFF_DEDUCTION_DATE,
          STAFF_DEDUCTION_STATUS =  @STAFF_DEDUCTION_STATUS
 
     where 
          STAFF_DEDUCTION_ID =  @STAFF_DEDUCTION_ID and 
          STAFF_DEDUCTION_HD_ID =  @STAFF_DEDUCTION_HD_ID 
          --and STAFF_DEDUCTION_BR_ID =  @STAFF_DEDUCTION_BR_ID 
 
end