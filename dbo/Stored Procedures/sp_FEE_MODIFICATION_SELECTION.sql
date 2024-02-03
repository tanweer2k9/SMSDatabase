CREATE procedure [dbo].[sp_FEE_MODIFICATION_SELECTION]

@FEE_COLLECT_HD_ID NUMERIC,
@FEE_COLLECT_BR_ID NUMERIC,
@FEE_COLLECT_PLAN_ID NUMERIC,
@FEE_COLLECT_DEFF NVARCHAR(50),
@STATUS CHAR(1)

AS 

--declare @FEE_COLLECT_HD_ID NUMERIC = 1
--declare @FEE_COLLECT_BR_ID NUMERIC = 2,
--declare @FEE_COLLECT_PLAN_ID NUMERIC = =0
--declare @FEE_COLLECT_DEFF NVARCHAR(50) = 
--declare @STATUS CHAR(1)

IF @status = 'L'
	BEGIN
		
		SELECT distinct([Student ID]),[School ID],[Student Name],[Fee],[Operator]  FROM VFEE_MODIFICATION
		 where [Class ID] = null--(Select top(1) ID from VSCHOOL_PLANE  WHERE [Institute ID] = @FEE_COLLECT_HD_ID AND [Branch ID] = @FEE_COLLECT_BR_ID AND [Status] = 'T')
		   and [Fee Name] = null--(SELECT TOP(1) Name from VFEE_INFO  WHERE [Institute ID] = @FEE_COLLECT_HD_ID AND [Branch ID] = @FEE_COLLECT_BR_ID AND [Status] = 'T')
		order by [Student ID] 
			
		Select ID,Name from VSCHOOL_PLANE  WHERE [Institute ID] = @FEE_COLLECT_HD_ID AND [Branch ID] = @FEE_COLLECT_BR_ID AND [Status] = 'T' and [Session Id] in (select BR_ADM_SESSION from BR_ADMIN where BR_ADM_ID = @FEE_COLLECT_BR_ID)
		select ID,Name from VFEE_INFO  WHERE [Institute ID] = @FEE_COLLECT_HD_ID AND [Branch ID] = @FEE_COLLECT_BR_ID AND [Status] = 'T'

	
	END

ELSE IF @status = 'B'
	BEGIN
		
		
		SELECT distinct([Student ID]),[School ID],[Student Name],[Fee],[Operator]  FROM VFEE_MODIFICATION
		 where [Class ID] = @FEE_COLLECT_PLAN_ID  
		 and [Fee Name] = @FEE_COLLECT_DEFF
		 order by [Student ID] 
	
	END