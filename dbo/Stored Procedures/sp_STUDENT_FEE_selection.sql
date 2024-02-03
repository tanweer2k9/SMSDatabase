CREATE PROC [dbo].[sp_STUDENT_FEE_selection]

		@STATUS char(1),
		@STUDENT_ID numeric,
		@HD_ID numeric,
		@BR_ID numeric

As

	IF @STATUS = 'L'
	BEGIN
		select ID, Name as [Fee Name], 0 as Fee, Operation from VFEE_INFO where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID
	END
	ELSE IF @STATUS = 'A'
	BEGIN
		select f.FEE_ID as ID, f.FEE_NAME as [Fee Name], pd.PLAN_FEE_DEF_FEE as Fee, f.FEE_OPERATION as Operation from 
		PLAN_FEE p 
		join STUDENT_INFO s on s.STDNT_CLASS_FEE_ID = p.PLAN_FEE_ID
		join plan_fee_def pd on pd.PLAN_FEE_DEF_PLAN_ID = p.PLAN_FEE_ID
		join FEE_INFO f on f.FEE_ID = pd.PLAN_FEE_DEF_FEE_NAME
		where pd.PLAN_FEE_DEF_STATUS = 'T' and f.FEE_STATUS = 'T'
		and s.STDNT_ID = @STUDENT_ID
		



		select ID, Name as [Fee Name], 0 as Fee, Operation from VFEE_INFO where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID
		and ID not in (
		select FEE_ID from 
		PLAN_FEE p 
		join STUDENT_INFO s on s.STDNT_CLASS_FEE_ID = p.PLAN_FEE_ID
		join plan_fee_def pd on pd.PLAN_FEE_DEF_PLAN_ID = p.PLAN_FEE_ID
		join FEE_INFO f on f.FEE_ID = pd.PLAN_FEE_DEF_FEE_NAME
		where pd.PLAN_FEE_DEF_STATUS = 'T' and f.FEE_STATUS = 'T'
		and s.STDNT_ID = @STUDENT_ID)



	END