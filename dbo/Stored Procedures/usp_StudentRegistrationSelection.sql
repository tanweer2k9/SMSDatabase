

CREATE PROC [dbo].[usp_StudentRegistrationSelection]

@BrId numeric

AS


--declare @BrId numeric


select sr.Id,sr.RegistrationNo,StudentName,sr.ClassId,FORMAT(DateOfRegistration, 'dd-MM-yyyy')DateOfRegistration,Gender,SessionId,ParentName,ParentMobileNo,Address, CITY_NAME City, CityId,CNIC,Occupation, Comments, sp.CLASS_Name ClassName, s.SESSION_DESC Session,ISNULL(m.Id,0) FeeId from StudentRegistration sr
join SCHOOL_PLANE sp on sp.CLASS_ID = sr.ClassId
join SESSION_INFO s on s.SESSION_ID = sr.SessionId
join CITY_INFO c on c.CITY_ID = sr.CityId
left join StdRegFeeGenerationMaster m on m.StudentRegistrationId = sr.Id

where sr.BrId = @BrId