CREATE procedure  [dbo].[sp_DEDUCTION_updation]
                                               
                                               
          @DEDUCTION_ID  numeric,
          @DEDUCTION_HD_ID  numeric,
          @DEDUCTION_BR_ID  numeric,
          @DEDUCTION_NAME  nvarchar(200) ,
          @DEDUCTION_DESCRIPTION  float,         
          @DEDUCTION_DATE  datetime,
          @DEDUCTION_STATUS  nchar(10) 
   
   
     as begin 
   



    declare @HD_ID nvarchar(50) = ''
   declare @BR_ID nvarchar(50) = ''


   declare @count int = 0
   declare @fee_old_name nvarchar(100) = ''

	select @fee_old_name = DEDUCTION_NAME, @DEDUCTION_HD_ID = DEDUCTION_HD_ID , @DEDUCTION_BR_ID= DEDUCTION_BR_ID from DEDUCTION where DEDUCTION_ID = @DEDUCTION_ID

   if dbo.get_advance_accounting (@DEDUCTION_BR_ID) = 1
	BEGIN 
		   set @HD_ID = CAST((@DEDUCTION_HD_ID) as nvarchar(50))
		   set @BR_ID = CAST((@DEDUCTION_BR_ID) as nvarchar(50))   
		   set @count = (select COUNT(*) from TBL_COA where CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_Name = @fee_old_name)
   END
		


   
     update DEDUCTION
 
     set
          DEDUCTION_NAME =  @DEDUCTION_NAME,
          DEDUCTION_DESCRIPTION =  @DEDUCTION_DESCRIPTION,          
          DEDUCTION_DATE =  @DEDUCTION_DATE,
          DEDUCTION_STATUS =  @DEDUCTION_STATUS
 
     where 
          DEDUCTION_ID =  @DEDUCTION_ID  
          
 

 if dbo.get_advance_accounting (@DEDUCTION_BR_ID) = 1
	BEGIN 
		if @count = 1
		BEGIN
			update TBL_COA set COA_Name = @DEDUCTION_NAME 
			where CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_Name = @fee_old_name
		END
		else
		begin
			exec [sp_FEE_INFO_ACCOUNT_insertion]   @DEDUCTION_HD_ID, @DEDUCTION_BR_ID ,   @DEDUCTION_NAME , 'Salary'
		end
 
	END

end