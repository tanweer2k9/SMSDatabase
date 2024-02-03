





CREATE procedure  [dbo].[sp_PLAN_FEE_insertion]
                                               
                                               
          @PLAN_FEE_HD_ID  numeric,
          @PLAN_FEE_BR_ID  numeric,
          @PLAN_FEE_NAME  nvarchar(50) ,
          @PLAN_FEE_TOTAL_FEE  float,
          @PLAN_FEE_STATUS  char(2),
		  @PLAN_FEE_FORMULA float,
		  @PLAN_FEE_IS_FORMULA_APPLY bit,
		  @PLAN_FEE_IS_FEE_GENERATE bit,
		  @PLAN_FEE_NOTES nvarchar(MAX),
		  @PLAN_FEE_INSTALLMENT_ID numeric,
		  @PLAN_FEE_YEARLY_PLAN_ID numeric
   
   
   
     as  begin   
   
     insert into PLAN_FEE
     values
     (        
        @PLAN_FEE_HD_ID,
        @PLAN_FEE_BR_ID,
        @PLAN_FEE_NAME,
        @PLAN_FEE_TOTAL_FEE,
        @PLAN_FEE_STATUS,
		@PLAN_FEE_FORMULA,
		@PLAN_FEE_IS_FORMULA_APPLY,
		@PLAN_FEE_IS_FEE_GENERATE,
		@PLAN_FEE_NOTES , 
		@PLAN_FEE_INSTALLMENT_ID  ,
		@PLAN_FEE_YEARLY_PLAN_ID
     )
     
    select SCOPE_IDENTITY()
    
end