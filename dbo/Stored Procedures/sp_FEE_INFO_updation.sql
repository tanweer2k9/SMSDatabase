

CREATE procedure  [dbo].[sp_FEE_INFO_updation]
                                               
                                               
          @DEFINITION_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(2) ,
		  @DEFINITION_FEE_TYPE nvarchar(50),
		  @DEFINITION_FEE_MONTHS nvarchar(50),
		  @DEFINITION_FEE_RANK int,
		  @DEFINITION_FEE_OPERATION nvarchar(10),
		  @FEE_DISCOUNT_PRIORITY int,
		  @FEE_IS_DISCOUNTABLE char(1)
   
   
     as begin 
   


   set @DEFINITION_NAME = REPLACE(@DEFINITION_NAME, ' ', ' ')


   declare @DEFINITION_HD_ID  numeric
   declare @DEFINITION_BR_ID  numeric

   declare @HD_ID nvarchar(50) = ''
   declare @BR_ID nvarchar(50) = ''


   declare @count int = 0
   declare @fee_old_name nvarchar(100) = ''

	select @fee_old_name = FEE_NAME, @DEFINITION_HD_ID = FEE_HD_ID , @DEFINITION_BR_ID= FEE_BR_ID from FEE_INFO where FEE_ID = @DEFINITION_ID

   if dbo.get_advance_accounting (@DEFINITION_BR_ID) = 1
	BEGIN 
		   set @HD_ID = CAST((@DEFINITION_HD_ID) as nvarchar(50))
		   set @BR_ID = CAST((@DEFINITION_BR_ID) as nvarchar(50))   
		   set @count = (select COUNT(*) from TBL_COA where CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_Name = @fee_old_name)
   END
   
     update FEE_INFO
 
     set
         
          FEE_NAME =  @DEFINITION_NAME,
          FEE_DESC =  @DEFINITION_DESC,
          FEE_STATUS =  @DEFINITION_STATUS,
          FEE_TYPE = @DEFINITION_FEE_TYPE,
          FEE_MONTHS =@DEFINITION_FEE_MONTHS,
          FEE_RANK = @DEFINITION_FEE_RANK,
		  FEE_OPERATION = @DEFINITION_FEE_OPERATION,
		  FEE_DISCOUNT_PRIORITY = @FEE_DISCOUNT_PRIORITY,
		  FEE_IS_DISCOUNTABLE = @FEE_IS_DISCOUNTABLE
 
 where 
 
	FEE_ID = @DEFINITION_ID


	update PLAN_FEE_DEF set PLAN_FEE_OPERATION = @DEFINITION_FEE_OPERATION where PLAN_FEE_DEF_FEE_NAME = @DEFINITION_ID

	   if dbo.get_advance_accounting (@DEFINITION_BR_ID) = 1
	BEGIN 
		if @count = 1
		BEGIN
			update TBL_COA set COA_Name = @DEFINITION_NAME 
			where CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_Name = @fee_old_name
		END
		else
		begin
			exec [sp_FEE_INFO_ACCOUNT_insertion]   @DEFINITION_HD_ID, @DEFINITION_BR_ID ,   @DEFINITION_NAME , 'Fees'
		end
 
 END
end