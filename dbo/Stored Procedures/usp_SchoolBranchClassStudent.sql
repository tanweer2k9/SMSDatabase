


CREATE PROC [dbo].[usp_SchoolBranchClassStudent]

@BrId numeric,
@ClassId numeric,
@SessionId numeric,
@Type nvarchar(50)

AS



declare @one int = 1

select MAIN_INFO_ID ID, MAIN_INFO_INSTITUTION_FULL_NAME Name from MAIN_HD_INFO where MAIN_INFO_STATUS = 'T'


select BR_ADM_ID ID, BR_ADM_NAME Name, BR_ADM_HD_ID HdId From BR_ADMIN where BR_ADM_STATUS = 'T' 

if @BrId = 0
BEGIN
	select top(@one) @BrId =  BR_ADM_ID From BR_ADMIN where BR_ADM_STATUS = 'T' 
END

--ID Card will be print of Current Session
set @SessionId = (select BR_ADM_SESSION from BR_ADMIN where BR_ADM_ID = @BrId)


select CLASS_ID ID, CLASS_Name Name from SCHOOL_PLANE where CLASS_BR_ID = @BrId and CLASS_SESSION_ID = @SessionId and CLASS_STATUS = 'T' order by CLASS_ORDER

if @ClassId = 0
BEGIN
	select top(@one) @ClassId = CLASS_ID from SCHOOL_PLANE where CLASS_BR_ID = @BrId and CLASS_SESSION_ID = @SessionId and CLASS_STATUS = 'T' order by CLASS_ORDER
END

if @Type = 'Student'
BEGIN

select ID, [Student School ID] StudentNo,[First Name] + ' ' + [Last Name] Name, [Parent Name],[Class Plan], [Fatehr Cell #] FatherCell, [Family Code] from VSTUDENT_INFO where  SessionId = @SessionId and Status = 'T'

END
else if @Type = 'Staff'
BEGIN
	select ID,[Employee Code],[First Name],[Department Name],Designation,[ID Designation],[Contact #],[Email Address] from VTEACHER_INFO where [Branch ID] = @BrId and Status = 'T'
END