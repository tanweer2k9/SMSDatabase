



CREATE PROC [dbo].[usp_GetParentTeacherMeeting]

@UserType nvarchar(50) ,
@StudentId numeric ,
@ClassId numeric ,
@UserCode numeric,
@BrId numeric,
@PTMType nvarchar(50)

AS



--declare @UserType nvarchar(50) = 'Parent',
--@StudentId numeric = 0,
--@ClassId numeric = 0,
--@UserCode numeric = 0


	if @UserType = 'Parent'
	BEGIN
		 select Id, Title, Description, MeetingDateTime ,FORMAT(MeetingDateTime, 'dd-MM-yyyy hh:mm tt') MeetingDateTimeString, IIF(StudentId is NULL,  sp.CLASS_NAME, st.STDNT_FIRST_NAME) StudentOrClass, st.STDNT_IMG StudentImage from MobileAppParentTeacherMeeting p
		 Left join SCHOOL_PLANE sp on sp.CLASS_ID = p.ClassId
		 left join STUDENT_INFO st on st.STDNT_ID = p.StudentId
		  where (ClassId = @ClassId OR StudentId = @StudentId) and ((@PTMType = 'Requested' AND  RequestStatus is null and IsParentRequest = 1) OR (@PTMType = 'Scheduled' AND	(RequestStatus = 'Approved' OR ISNULL(p.ClassId,0) != -1)   )) order by MeetingDateTime desc
	END
	else if @UserType = 'Teacher'
	BEGIN
		 select Id,Title, Description, MeetingDateTime ,FORMAT(MeetingDateTime, 'dd-MM-yyyy hh:mm tt') MeetingDateTimeString, IIF(StudentId is NULL,  sp.CLASS_NAME, st.STDNT_FIRST_NAME) StudentOrClass, st.STDNT_IMG StudentImage from MobileAppParentTeacherMeeting p
		 Left join SCHOOL_PLANE sp on sp.CLASS_ID = p.ClassId
		 left join STUDENT_INFO st on st.STDNT_ID = p.StudentId 
		 where (sp.CLASS_TEACHER = @UserCode   OR st.STDNT_CLASS_PLANE_ID = @ClassId ) and ((p.IsParentRequest = 1 and RequestStatus = 'Approved') OR (p.IsParentRequest = 0))  order by MeetingDateTime desc
	END
	else if @UserType = 'A'
	BEGIN
		 select Id,Title, Description, MeetingDateTime ,FORMAT(MeetingDateTime, 'dd-MM-yyyy hh:mm tt') MeetingDateTimeString, IIF(StudentId is NULL,  sp.CLASS_NAME, st.STDNT_FIRST_NAME) StudentOrClass, st.STDNT_IMG StudentImage from MobileAppParentTeacherMeeting p
		 Left join SCHOOL_PLANE sp on sp.CLASS_ID = p.ClassId
		 left join STUDENT_INFO st on st.STDNT_ID = p.StudentId
		 where  p.BrId = @BrId  and  (((( IsParentRequest = 1 AND RequestStatus = 'Approved') OR ( IsParentRequest = 0)) AND @PTMType = 'Scheduled') OR ( @PTMType = 'Requested' AND IsParentRequest = 1 AND RequestStatus is null)) order by MeetingDateTime desc
	END