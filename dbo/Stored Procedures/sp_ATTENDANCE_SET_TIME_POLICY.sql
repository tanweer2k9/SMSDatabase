CREATE PROC [dbo].[sp_ATTENDANCE_SET_TIME_POLICY]

 @HD_ID numeric,
 @BR_ID numeric,
 @STATUS char(1),
 @DEPARTMENT_ID numeric


AS

--declare @HD_ID numeric
--declare @BR_ID numeric
--declare @STATUS char(1)
--declare @DEPARTMENT_ID numeric


--declare @department nvarchar(50) = '%'

--if @DEPARTMENT_ID = 0
--	set @DEPARTMENT_ID = 



if @STATUS = 'L'
BEGIN

	select ID,Name from VDEPARTMENT_INFO where [Institute ID]	= @HD_ID and [Branch ID] = @BR_ID and Status = 'T'
	
	select ID,Name from VWORKING_HOURS_PACKAGES where [Institute ID]	= @HD_ID and [Branch ID] = @BR_ID and Status = 'T'

	select t.TECH_ID [Staff ID], t.TECH_EMPLOYEE_CODE [Staff Code], t.TECH_FIRST_NAME [Staff Name],d.DEP_NAME Department, t.TECH_DESIGNATION Designation,w.STAFF_WORKING_DAYS_PACKAGE_ID Package from TEACHER_INFO t
	join DEPARTMENT_INFO d on  CAST(d.DEP_ID as nvarchar(50)) = t.TECH_DEPARTMENT
	--join DESIGNATION_INFO ds on  CAST(ds.DESIGNATION_ID as nvarchar(50)) = t.TECH_DESIGNATION
	left join STAFF_WORKING_DAYS w on w.STAFF_WORKING_DAYS_STAFF_ID= t.TECH_ID and w.STAFF_WORKING_DAYS_NAME = 'Monday'
	where d.DEP_ID = @DEPARTMENT_ID and t.TECH_STATUS = 'T' and d.DEP_STATUS = 'T' and
	TECH_LEAVES_TYPE not in ('No Deduction', 'Not Generate Salary') 
END