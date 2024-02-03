CREATE PROCEDURE [dbo].[sp_STUDENT_PROMOTION_SELECTION]	
@FEE_COLLECT_HD_ID NUMERIC,
@FEE_COLLECT_BR_ID NUMERIC,
@FEE_COLLECT_PLAN_ID NUMERIC,
@FEE_COLLECT_DEFF NVARCHAR(50),
@STATUS CHAR(1),
@ACTIVE_STATUS CHAR(3),
@SESSION date,
@SESSION_ID numeric
AS	
IF @status = 'L'
	BEGIN		
		
		 
		 if @SESSION_ID = -1	
	set @SESSION_ID = (select BR_ADM_SESSION from BR_ADMIN where BR_ADM_ID = @FEE_COLLECT_BR_ID)

select ID, Name from VCLASS_PLAN where [HD ID] = @FEE_COLLECT_HD_ID and [BR ID] = @FEE_COLLECT_BR_ID and [SESSION ID] = @SESSION_ID and [Status] = 'T'
order by [Class Order]

		if @FEE_COLLECT_PLAN_ID = 0
		BEGIN
			declare @one int = 1

			set @FEE_COLLECT_PLAN_ID = (select top(@one)ID from VCLASS_PLAN where [HD ID] = @FEE_COLLECT_HD_ID and [BR ID] = @FEE_COLLECT_BR_ID and [SESSION ID] = @SESSION_ID and [Status] = 'T')
		END
		 --exec sp_CLASS_PLAN_selection @FEE_COLLECT_HD_ID,@FEE_COLLECT_BR_ID,-1,@FEE_COLLECT_PLAN_ID

		 SELECT [Student ID],[School ID],[Student Name],[Gardian],[Status] from VSTUDENT_PROMOTION
		 where [Class ID] = @FEE_COLLECT_PLAN_ID
		
		 AND [Status] = 'T'
		 order by CAST([School ID] as int)

		--Select ID,Name from VSCHOOL_PLANE  WHERE [Institute ID] = @FEE_COLLECT_HD_ID AND [Branch ID] = @FEE_COLLECT_BR_ID AND [Status] = 'T'
		
		select  BR_ADM_ID ID, m.MAIN_INFO_INSTITUTION_SHORT_NAME + ' - ' + b.BR_ADM_NAME from BR_ADMIN b
		join MAIN_HD_INFO m on m.MAIN_INFO_ID = b.BR_ADM_HD_ID where BR_ADM_STATUS = 'T' and BR_ADM_ID in (select COMBINE_BRANCHES_ID from COMBINE_BRANCHES where FROM_BRANCH_ID = @FEE_COLLECT_BR_ID)

	END

	
--ELSE IF @status = 'B'
--	BEGIN
		
--		select ID, Name from VCLASS_PLAN  where ID = 0

--		SELECT distinct([Student ID]),[School ID], [Roll No],[Student Name],[Gardian],[Status],[Fee ID] from VSTUDENT_PROMOTION
--		 where [Class ID] = @FEE_COLLECT_PLAN_ID
--		 AND [Active Status] in ('mov','new','old')
--		 --AND (  datepart(YYYY, [Session] ) =  datepart(YYYY,@SESSION)  )	
--		 AND [Status] = 'T'	 
--		 order by [Student ID] 	asc	 
--	END