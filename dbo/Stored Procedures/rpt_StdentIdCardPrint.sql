


CREATE PROC [dbo].[rpt_StdentIdCardPrint]
@ClassId numeric,
@Ids nvarchar(MAX),
@Type nvarchar(50),
@BrId numeric

AS

--declare @ClassId numeric = 30162
--declare @StudetnId nvarchar(MAX) = ''

declare @Session_End_Date date = ''

select @Session_End_Date = s.SESSION_END_DATE from BR_ADMIN b join SESSION_INFO s on s.SESSION_ID = BR_ADM_SESSION where BR_ADM_ID =@BrId


if @Type = 'Student'
BEGIN
insert into IdCard
select NULL, STDNT_ID,STDNT_CLASS_PLANE_ID, NEWID(), GETDATE(), 1, @Session_End_Date  from STUDENT_INFO where  STDNT_STATUS = 'T' 
--and STDNT_CLASS_PLANE_ID = @ClassId 
and (CAST(STDNT_ID as nvarchar(MAX)) = '' OR CAST(STDNT_ID as nvarchar(15)) in (select val  from dbo.split(@Ids,','))) 
--and STDNT_BR_ID = @BrId
AND CAST(STDNT_ID as nvarchar(50)) +'-' + CAST(STDNT_CLASS_PLANE_ID as nvarchar(50))  not in (select CAST(ISNULL(studentId,0)as nvarchar(50)) + '-'  + CAST(ISNULL(ClassId,0) as nvarchar(50))  from IdCard )
 
select s.STDNT_ID Id,ISNULL(s.STDNT_SHORT_NAME,'') Name,sp.CLASS_Name ClassORDesigatnion, s.STDNT_SCHOOL_ID StdNoOrEmpCode, FORMAT(s.STDNT_CLASSES_START_DATE, 'dd/MM/yyyy') JoiningDate, FORMAT(i.ExpiryDate, 'dd/MM/yyyy') ExpiryDate, b.BR_ADM_PHONE PhoneNo, b.BR_ADM_ADDRESS Address, l.LEVEL_LEVEL Level, i.RandomString , s.STDNT_IMG Image From IdCard i

join STUDENT_INFO s on s.STDNT_ID = i.StudentId and s.STDNT_CLASS_PLANE_ID = i.ClassId
join SCHOOL_PLANE sp on sp.CLASS_ID = s.STDNT_CLASS_PLANE_ID
join CLASS_INFO c on c.CLASS_ID = sp.CLASS_CLASS
join BR_ADMIN b on b.BR_ADM_ID = s.STDNT_BR_ID
join LEVELS l on l.LEVEL_ID = sp.CLASS_LEVEL_ID
where s.STDNT_STATUS = 'T' 
--and s.STDNT_CLASS_PLANE_ID = @ClassId and i.ClassId = @ClassId 
and (CAST(s.STDNT_ID as nvarchar(MAX)) = '' OR CAST(s.STDNT_ID as nvarchar(15)) in (select val  from dbo.split(@Ids,','))) 
--and STDNT_BR_ID = @BrId

--and l.LEVEL_LEVEL = 2
and ExpiryDate = @Session_End_Date order by CLASS_ORDER, CAST(s.STDNT_SCHOOL_ID as int)
END
ELSE
BEGIN
	insert into IdCard
	select TECH_ID,NULL,NULL,NEWID(),GETDATE(), 1, @Session_End_Date  from TEACHER_INFO where TECH_ID in (select CAST(val as numeric) from dbo.split(@Ids, ','))
and TECH_ID not in (select ISNULL(StaffId,0) from IdCard where ExpiryDate = @Session_End_Date)


select t.TECH_ID Id,ISNULL(t.TECH_ID_CARD_NAME,'') Name, t.TECH_ID_DESIGNATION ClassORDesigatnion, t.TECH_EMPLOYEE_CODE StdNoOrEmpCode, FORMAT(t.TECH_JOINING_DATE, 'dd/MM/yyyy') JoiningDate, FORMAT(i.ExpiryDate, 'dd/MM/yyyy') ExpiryDate, b.BR_ADM_PHONE PhoneNo, b.BR_ADM_ADDRESS Address, 0 Level, i.RandomString , t.TECH_IMG Image From IdCard i

join TEACHER_INFO t on t.TECH_ID= i.StaffId
join BR_ADMIN b on b.BR_ADM_ID = t.TECH_BR_ID
where t.TECH_STATUS = 'T' and  (CAST(t.TECH_ID as nvarchar(MAX)) = '' OR CAST(t.TECH_ID as nvarchar(15)) in (select val  from dbo.split(@Ids,',')))  and ExpiryDate = @Session_End_Date

END