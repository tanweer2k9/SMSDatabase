

CREATE PROC [dbo].[sp_ADMISSION_REPORTS_selection]

@STATUS char(1),
@HD_ID numeric,
@BR_ID numeric,
@SessionId numeric,
@IsMondatory int = -1
-- -1 means all 

AS
--declare @STATUS char(1)='A',@HD_ID numeric =1,@BR_ID numeric=1,@SessionId numeric=50,@IsMondatory bit=0

declare @session_start_date date = ''
declare @session_end_date date = ''


select @session_start_date = SESSION_START_DATE, @session_end_date = SESSION_END_DATE from SESSION_INFO where SESSION_ID = @SessionId


if @STATUS = 'C'--Class
BEGIN
	select ID,Name, [Class Teacher] from VSCHOOL_PLANE where [Status] = 'T' and [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and [Session Id] = @SessionId order by [Order]
	select ID,Name,[Class ID],StartDate,EndDate from
	(select distinct t.TERM_ID ID, t.TERM_NAME Name, DEF_CLASS_ID [Class ID],TERM_RANK,t.TERM_START_DATE StartDate, t.TERM_END_DATE EndDate from SCHOOL_PLANE_DEFINITION spd 
	join SCHOOL_PLANE sp on sp.CLASS_ID = spd.DEF_CLASS_ID
	join TERM_INFO t on t.TERM_ID = spd.DEF_TERM
	where sp.CLASS_SESSION_ID  = @SessionId)A order by TERM_RANK
END



else if @STATUS = 'A' --THis is used in Subject Monthly Attendance, Subject List and Subjec List with Signature
BEGIN
	

	select ID,Name from VSCHOOL_PLANE where [Status] = 'T' and [Institute ID] = @HD_ID and [Branch ID] = @BR_ID 
	--and (@IsMondatory = -1 OR [Is Mandatory] = 0) 
	and [Session Id] = @SessionId and [Level] > 1 order by [Order]
	
		select A.ID, A.Name + ' (' + CAST(CountSubject  as nvarchar(20)) +')' Name,[Class ID], [Term ID] from 
	(select SUB_ID ID, SUB_NAME Name, pd.DEF_CLASS_ID [Class ID], pd.DEF_TERM [Term ID],(select COUNT(distinct StudentId) from tblStudentSubjectsParent p join tblStudentSubjectsChild c on p.Id = c.PId join STUDENT_INFO s on s.STDNT_ID = StudentId  where p.ClassId = pd.DEF_CLASS_ID and c.SubjectId = sb.SUB_ID and s.STDNT_STATUS = 'T' and c.TermId = pd.DEF_TERM) CountSubject from SUBJECT_INFO sb
	join SCHOOL_PLANE_DEFINITION pd on pd.DEF_SUBJECT = sb.SUB_ID 	
	join VSCHOOL_PLANE sp on sp.ID = pd.DEF_CLASS_ID and sp.[Session Id] = @SessionId and (@IsMondatory = -1 OR [Is Mandatory] = 0) and [Level] > 1 
	where SUB_HD_ID = @HD_ID and SUB_BR_ID = @BR_ID and SUB_STATUS = 'T'  
	--and (@IsMondatory = -1 OR pd.DEF_TERM = (select TERM_ID from TERM_INFO where TERM_STATUS = 'T' and TERM_BR_ID = @BR_ID and CAST(GETDATE() as date) between TERM_START_DATE and TERM_END_DATE and TERM_SESSION_START_DATE = @session_start_date and TERM_SESSION_END_DATE = @session_end_date and pd.DEF_TERM = TERM_ID)) 
	
	and DEF_STATUS = 'T')A where CountSubject > 0


	select ID,Name,[Class ID],StartDate,EndDate,TermRank from
	(select distinct t.TERM_ID ID, t.TERM_NAME Name, DEF_CLASS_ID [Class ID],TERM_RANK,t.TERM_START_DATE StartDate, t.TERM_END_DATE EndDate,t.TERM_RANK TermRank from SCHOOL_PLANE_DEFINITION spd 
	join SCHOOL_PLANE sp on sp.CLASS_ID = spd.DEF_CLASS_ID
	join TERM_INFO t on t.TERM_ID = spd.DEF_TERM
	where sp.CLASS_SESSION_ID  = @SessionId)A order by TERM_RANK
	

END


ELSE IF @STATUS = 'P'
BEGIN
	select ID,Name from VSCHOOL_PLANE where [Status] = 'T' and [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and [Session Id] = @SessionId order by [Order]
	select * from VPARENT_STUDENT_INFO where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID
END