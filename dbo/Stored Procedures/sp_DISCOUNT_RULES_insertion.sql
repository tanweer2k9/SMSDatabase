CREATE procedure  [dbo].[sp_DISCOUNT_RULES_insertion]
                                               
                                               
          @DIS_RUL_HD_ID  numeric,
          @DIS_RUL_BR_ID  numeric,
          @DIS_RUL_NAME  nvarchar(200) ,
          @DIS_RUL_STATUS  char(2) ,
          @DIS_RUL_DATETIME  datetime,
          @DIS_RUL_USER  nvarchar(50),
		  @DIS_RUL_CLASS_ID numeric
   
   
     as  begin
   
   
     insert into DISCOUNT_RULES
     values
     (
        @DIS_RUL_HD_ID,
        @DIS_RUL_BR_ID,
        @DIS_RUL_NAME,
        @DIS_RUL_STATUS,
        @DIS_RUL_DATETIME,
        @DIS_RUL_USER,
		@DIS_RUL_CLASS_ID
     
     
     )
     

	 select SCOPE_IDENTITY()
end