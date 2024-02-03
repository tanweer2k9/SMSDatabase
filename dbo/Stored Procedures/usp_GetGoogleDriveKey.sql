
CREATE PROC [dbo].[usp_GetGoogleDriveKey]


@ClassId numeric,
@SubjectId numeric,
@BrId numeric



AS

select top(1) d.GoogleDriveKey  from SCHOOL_PLANE_DEFINITION spd
join TERM_INFO t on t.TERM_ID = spd.DEF_TERM
join StaffGoogleDriveKey d on d.StaffId = spd.DEF_TEACHER
where DEF_CLASS_ID = @ClassId and DEF_SUBJECT = @SubjectId 
and t.TERM_BR_ID in (2,13)
order by TERM_RANK