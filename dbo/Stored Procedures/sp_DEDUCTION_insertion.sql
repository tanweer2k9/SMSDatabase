CREATE procedure  [dbo].[sp_DEDUCTION_insertion]
                                               
                                               
          @DEDUCTION_HD_ID  numeric,
          @DEDUCTION_BR_ID  numeric,
          @DEDUCTION_NAME  nvarchar(200) ,         
          @DEDUCTION_DESCRIPTION nvarchar(200),
          @DEDUCTION_DATE  datetime,
          @DEDUCTION_STATUS  nchar(10) 
   
   
     as  begin
   
   
   



     insert into DEDUCTION
     values
     (
        @DEDUCTION_HD_ID,
        @DEDUCTION_BR_ID,
        @DEDUCTION_NAME,
        @DEDUCTION_DESCRIPTION,
        @DEDUCTION_DATE,
        @DEDUCTION_STATUS
     
     
     )



	-- if dbo.get_advance_accounting (@DEDUCTION_BR_ID) = 1
	--BEGIN
	--	exec [sp_FEE_INFO_ACCOUNT_insertion]   @DEDUCTION_HD_ID, @DEDUCTION_BR_ID ,   @DEDUCTION_NAME , 'Salary'
	--END

     
end