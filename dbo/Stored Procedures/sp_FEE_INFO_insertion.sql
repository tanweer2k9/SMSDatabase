
CREATE procedure  [dbo].[sp_FEE_INFO_insertion]
                                               
                                               
          @DEFINITION_HD_ID  numeric,
          @DEFINITION_BR_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(1) ,
          @DEFINITION_FEE_TYPE nvarchar(50),
		  @DEFINITION_FEE_MONTHS nvarchar(50),
		  @DEFINITION_FEE_RANK int,
		  @DEFINITION_FEE_OPERATION nvarchar(10),
		  @FEE_DISCOUNT_PRIORITY int,
		  @FEE_IS_DISCOUNTABLE char(1)
   
     as  begin
	
	 set @DEFINITION_NAME = REPLACE(@DEFINITION_NAME, ' ', ' ')
       declare @count int 
   
       set @count = 0 
   
       set @count = ( select count(FEE_ID) from FEE_INFO  
		where   
		  FEE_HD_ID = @DEFINITION_HD_ID and
		  FEE_BR_ID = @DEFINITION_BR_ID and
          FEE_NAME =  @DEFINITION_NAME    
   )  
   
     if @count = 0
   
     begin
   
     insert into FEE_INFO
     values
     (
        @DEFINITION_HD_ID,
        @DEFINITION_BR_ID,
        @DEFINITION_NAME,
        @DEFINITION_DESC,
        @DEFINITION_STATUS,
		@DEFINITION_FEE_TYPE,
		@DEFINITION_FEE_MONTHS,
		@DEFINITION_FEE_RANK,
		@DEFINITION_FEE_OPERATION,
		@FEE_DISCOUNT_PRIORITY,
		@FEE_IS_DISCOUNTABLE
	)

	if dbo.get_advance_accounting (@DEFINITION_BR_ID) = 1
	BEGIN
		exec [sp_FEE_INFO_ACCOUNT_insertion]   @DEFINITION_HD_ID, @DEFINITION_BR_ID ,   @DEFINITION_NAME , 'Fees'
	END



	
	
	  select 'ok'
     
      end
     
      else
     
      begin
     
      select 'This Name is Already Exit. Please Choose Some Other Name!'
     
end
     
end