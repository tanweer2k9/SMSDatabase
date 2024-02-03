

CREATE FUNCTION [dbo].[tf_GetExamTerms] (@CLASS_ID numeric,@HD_ID numeric, @BR_ID numeric,@SessionId numeric)
returns @tbl table (Id numeric, Name nvarchar(100), [Rank] int)

AS 
BEGIN
	




	insert into @tbl

		select ID,Name, [Rank] from
		(select distinct ID, t.Name as Name, [Rank] from 
		SCHOOL_PLANE_DEFINITION spd
		join VTERM_INFO t on t.ID = DEF_TERM and Status	='T'
		join EXAM_DEF ed on ed.EXAM_DEF_CLASS_ID = spd.DEF_ID
		join EXAM_ENTRY e on e.EXAM_ENTRY_PLAN_EXAM_ID = ed.EXAM_DEF_ID
		where 
		DEF_CLASS_ID =@CLASS_ID and [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and
			[Status] ='T' and [SessionId] = @SessionId )A
			


	return
END