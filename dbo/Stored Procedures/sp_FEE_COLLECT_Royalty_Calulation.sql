CREATE PROC [dbo].[sp_FEE_COLLECT_Royalty_Calulation]

 @FEE_COLLECT_ID numeric,
 @BR_ID numeric

AS


--declare @FEE_COLLECT_ID numeric
--declare @BR_ID numeric


declare @BR_ID_TO int = 0

set @BR_ID_TO = (select BR_ADM_ROYALTY_TO_BRANCH from BR_ADMIN where BR_ADM_ID = @BR_ID)

if  @BR_ID_TO != 0
BEGIN

	declare @count int = 0
	declare @i int = 1
	declare @fee_id int = 0
	declare @fee float = 0
	declare @percent float = 0
	declare @std_id numeric = 0
	declare @prev_fee_id numeric = 0 
	declare @prev_royalty_due float = 0
	set @count = (select COUNT(*) from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @FEE_COLLECT_ID)
	set @std_id = (select F2.FEE_COLLECT_STD_ID from FEE_COLLECT F2 where F2.FEE_COLLECT_ID = @FEE_COLLECT_ID)
	set @prev_fee_id = (select FEE_COLLECT_ID from (select ROW_NUMBER() over( order by FEE_COLLECT_FEE_FROM_DATE DESC ) as sr, * from FEE_COLLECT F1 where F1.FEE_COLLECT_STD_ID = @std_id)A where sr = 2)

	while @i <= @count
	BEGIN
		select @fee_id = FeeID, @fee = FEE  from (select ROW_NUMBER() over(order by (select 0)) as sr,FEE_COLLECT_DEF_FEE_NAME FeeID, FEE_COLLECT_DEF_FEE FEE  from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @FEE_COLLECT_ID)A where sr = @i
		set @percent = ISNULL((select ROYALTY_PERCENTAGE from ROYALTY_FEE_SETTING where ROYALTY_FEE_ID =  @fee_id and ROYALTY_BR_ID =  @BR_ID),0)

		if @percent != 0
		BEGIN
			--set @prev_royalty_due = ISNULL((select FEE_COLLECT_DEF_ROYALTY - FEE_COLLECT_DEF_ROYALTY_PAID from FEE_COLLECT_DEF where FEE_COLLECT_DEF_FEE_NAME = @fee_id and FEE_COLLECT_DEF_PID = @prev_fee_id),0)
			
			update FEE_COLLECT_DEF set FEE_COLLECT_DEF_ROYALTY = ((FEE_COLLECT_DEF_FEE * (@percent/100)) + @prev_royalty_due),FEE_COLLECT_DEF_ROYALTY_PERCENT = @percent
			where FEE_COLLECT_DEF_FEE_NAME = @fee_id and FEE_COLLECT_DEF_PID = @FEE_COLLECT_ID
		END
			set @i = @i + 1
	END


	declare @royality_total float = 0

	set @royality_total = (select SUM(FEE_COLLECT_DEF_ROYALTY) from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @FEE_COLLECT_ID)

	update FEE_COLLECT set FEE_COLLECT_ROYALTY_FEE = @royality_total where FEE_COLLECT_ID = @FEE_COLLECT_ID



END