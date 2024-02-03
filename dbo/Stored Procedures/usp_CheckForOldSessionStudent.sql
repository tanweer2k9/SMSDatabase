CREATE PROC [dbo].[usp_CheckForOldSessionStudent]

@StudentId numeric,
@StudentStatus nvarchar(10)
AS


declare @BrId numeric = 0, @CurrentSessionStudent nvarchar(50), @CurrentSessionBranch nvarchar(50), @CurrentStatus nvarchar(50)


select @BrId = s.STDNT_BR_ID, @CurrentSessionStudent = si.SESSION_DESC, @CurrentStatus = s.STDNT_STATUS from STUDENT_INFO s
join SCHOOL_PLANE sp on sp.CLASS_ID = s.STDNT_CLASS_PLANE_ID
join SESSION_INFO si on si.SESSION_ID = sp.CLASS_SESSION_ID 
where s.STDNT_ID = @StudentId

select @CurrentSessionBranch = si.SESSION_DESC from BR_ADMIN br
join SESSION_INFO si on si.SESSION_ID = br.BR_ADM_SESSION
where BR_ADM_ID = @BrId

--if @StudentStatus = 'T' and @CurrentStatus = 'F'
--BEGIN
	if @CurrentSessionStudent != @CurrentSessionBranch
	BEGIN
		exec usp_SessionChangeSingleStudent @CurrentSessionStudent,@CurrentSessionBranch,@BrId, @StudentId
	END
--END