﻿CREATE procedure [dbo].[sp_FEE_MODIFICATION_DELETION]

@FEE_COLLECT_HD_ID NUMERIC,
@FEE_COLLECT_BR_ID NUMERIC,
@FEE_COLLECT_PLAN_ID NUMERIC,
@FEE_COLLECT_DEFF NVARCHAR(50)

AS BEGIN
	--DELETE FROM VFEE_MODIFICATION
	--WHERE		[Class ID] = @FEE_COLLECT_PLAN_ID
	--		AND [Fee Name] = @FEE_COLLECT_DEFF
	--		AND [Institute ID] = @FEE_COLLECT_HD_ID
	--		AND [Branch ID] = @FEE_COLLECT_BR_ID

	delete from PLAN_FEE_DEF
	 where PLAN_FEE_DEF_FEE_NAME = @FEE_COLLECT_DEFF and 
	 PLAN_FEE_DEF_PLAN_ID in ( select STDNT_CLASS_FEE_ID from STUDENT_INFO where 
												STDNT_CLASS_PLANE_ID = @FEE_COLLECT_PLAN_ID and 
												STDNT_HD_ID = @FEE_COLLECT_HD_ID and 
												STDNT_BR_ID = @FEE_COLLECT_BR_ID
												 )
	select 'ok'
	
END