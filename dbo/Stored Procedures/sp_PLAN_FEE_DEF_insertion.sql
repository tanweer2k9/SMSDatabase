CREATE procedure  [dbo].[sp_PLAN_FEE_DEF_insertion]
                                               
                                               
          @PLAN_FEE_DEF_PLAN_ID  numeric,
          @PLAN_FEE_DEF_FEE_NAME  nvarchar(50) ,
          @PLAN_FEE_DEF_FEE  float,
          @PLAN_FEE_DEF_FEE_MIN  float,
          @PLAN_FEE_DEF_FEE_MAX  float,
          @PLAN_FEE_DEF_STATUS  nchar(2) ,
          @PLAN_FEE_DEF_OPERATION CHAR(1),
		  @PLAN_FEE_IS_ONCE_PAID char(1),
          @status char(1)
   
   
     as  begin
	--declare @fee_id numeric
	--      if @status = 'I'
 --   begin	
	--	set @PLAN_FEE_DEF_PLAN_ID = (select  ISNULL( MAX( PLAN_FEE_ID ),0) from PLAN_FEE)
	--end
	
	--set @fee_id = (select FEE_ID from FEE_INFO where FEE_NAME = @PLAN_FEE_DEF_FEE_NAME 
	--and FEE_HD_ID = (select PLAN_FEE_HD_ID from PLAN_FEE where PLAN_FEE_ID = @PLAN_FEE_DEF_PLAN_ID) 
	--and FEE_BR_ID = (select PLAN_FEE_BR_ID from PLAN_FEE where PLAN_FEE_ID = @PLAN_FEE_DEF_PLAN_ID) )

  --   insert into PLAN_FEE_DEF
  --   values
  --   (
  --      @id,        
  --      @fee_id,
  --      @PLAN_FEE_DEF_FEE,
  --      @PLAN_FEE_DEF_FEE_MIN,
  --      @PLAN_FEE_DEF_FEE_MAX,
  --      @PLAN_FEE_DEF_STATUS,
		--@PLAN_FEE_DEF_OPERATION
     
  --   )
  --   end
     
  --   ELSE
  --   begin
     


	-- declare @fee_plan_is_once_paid char(1) = 'N'


	--if (select [Fee Type] from VFEE_INFO where ID = @PLAN_FEE_DEF_FEE_NAME and [Fee Type] != 'T') = 'Once'
	--begin
	--	if (select COUNT(*) from FEE_COLLECT f where f.FEE_COLLECT_FEE_ID = @PLAN_FEE_DEF_PLAN_ID) > 0
	--	BEGIN
	--		set @fee_plan_is_once_paid  = 'T'
	--	END
	--	ELSE
	--	BEGIN
	--		set @fee_plan_is_once_paid  = 'F'
	--	END
	--end




	declare @HD_ID int = 0
	declare @BR_ID int = 0


	select @HD_ID = PLAN_FEE_HD_ID, @BR_ID = PLAN_FEE_BR_ID from PLAN_FEE where PLAN_FEE_ID = @PLAN_FEE_DEF_PLAN_ID

	declare @fee_type nvarchar(50) = ''
	set @fee_type = (select FEE_TYPE from FEE_INFO where FEE_ID = @PLAN_FEE_DEF_FEE_NAME)

	if @fee_type not like '%Once%'
	BEGIN
		set @PLAN_FEE_IS_ONCE_PAID = 'N'
	END


	declare @count int = 0

	set @count = (select COUNT(*) from PLAN_FEE_DEF where PLAN_FEE_DEF_PLAN_ID = @PLAN_FEE_DEF_PLAN_ID and PLAN_FEE_DEF_FEE_NAME = @PLAN_FEE_DEF_FEE_NAME and PLAN_FEE_DEF_STATUS = 'T')
	
		 
	
	if @count = 0


	begin
		     insert into PLAN_FEE_DEF
     values
     (
        
        @PLAN_FEE_DEF_PLAN_ID,
        @PLAN_FEE_DEF_FEE_NAME,
        @PLAN_FEE_DEF_FEE,
        @PLAN_FEE_DEF_FEE_MIN,
        @PLAN_FEE_DEF_FEE_MAX,
        @PLAN_FEE_DEF_STATUS,
		@PLAN_FEE_DEF_OPERATION ,
		@PLAN_FEE_IS_ONCE_PAID 
     
     )
	end
	else
	begin
			update PLAN_FEE_DEF set PLAN_FEE_DEF_FEE = @PLAN_FEE_DEF_FEE, PLAN_FEE_OPERATION = @PLAN_FEE_DEF_OPERATION, PLAN_FEE_DEF_STATUS = @PLAN_FEE_DEF_STATUS , PLAN_FEE_IS_ONCE_PAID = @PLAN_FEE_IS_ONCE_PAID 	
			 
			where PLAN_FEE_DEF_PLAN_ID = @PLAN_FEE_DEF_PLAN_ID and PLAN_FEE_DEF_FEE_NAME = @PLAN_FEE_DEF_FEE_NAME
	end


     


END