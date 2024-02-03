CREATE PROC [dbo].[sp_STUDENT_FEE_updation]

@FEE_PLAN_ID numeric,
@FEE_ID numeric,
@FEE float,
@operation nvarchar(10)


AS

	declare @fee_plan_is_once_paid char(1) = 'N'


	if (select [Fee Type] from VFEE_INFO where ID = @FEE_ID and [Fee Type] != 'T') = 'Once'
	begin
		set @fee_plan_is_once_paid  = 'F'
	end

	declare @count int = 0

	set @count = (select COUNT(*) from PLAN_FEE_DEF where PLAN_FEE_DEF_PLAN_ID = @FEE_PLAN_ID and PLAN_FEE_DEF_FEE_NAME = @FEE_ID and PLAN_FEE_DEF_STATUS = 'T')
	if @count = 0
	begin
		insert into PLAN_FEE_DEF values (@FEE_PLAN_ID, @FEE_ID, @FEE,0,0, 'T',@operation, @fee_plan_is_once_paid)
	end
	else
	begin
			update PLAN_FEE_DEF set PLAN_FEE_DEF_FEE = @FEE, PLAN_FEE_OPERATION = @operation 	
			 
			where PLAN_FEE_DEF_PLAN_ID = @FEE_PLAN_ID and PLAN_FEE_DEF_FEE_NAME = @FEE_ID and PLAN_FEE_DEF_STATUS = 'T'
	end
	--declare @count int = 0

	--set @count = (select count(*) from PLAN_FEE_DEF where 
	--PLAN_FEE_DEF_FEE_NAME = @FEE_ID and PLAN_FEE_DEF_STATUS = 'T'
	--and PLAN_FEE_DEF_PLAN_ID = @FEE_PLAN_ID)


	--if @count = 0
	--	begin

	--		insert into PLAN_FEE_DEF values (@FEE_PLAN_ID, @FEE_ID, @FEE,0,0, 'T',@operation)
	--	end	
	--else
	--	begin

	--		update PLAN_FEE_DEF set PLAN_FEE_DEF_FEE = @FEE 	
	--		where 
	--		PLAN_FEE_DEF_FEE_NAME = @FEE and PLAN_FEE_DEF_STATUS = 'T'
	--		and PLAN_FEE_DEF_PLAN_ID  = @FEE_PLAN_ID	
	--	end