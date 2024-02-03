

CREATE procedure  [dbo].[sp_ATTENDANCE_STAFF_updation_from_file]
                                               
                                               
         
          @ATTENDANCE_STAFF_TYPE_ID  numeric,
          @ATTENDANCE_STAFF_DATE  date,
          @ATTENDANCE_STAFF_TIME  nvarchar(50)
         
   
   
     as begin 
   
   
   declare @attendance_id numeric = 0
   set @attendance_id =(select top(1) ATTENDANCE_STAFF_ID from(select (select t.TECH_EMPLOYEE_CODE from TEACHER_INFO t where t.TECH_ID = ATTENDANCE_STAFF_TYPE_ID) emp_code,* from ATTENDANCE_STAFF where ATTENDANCE_STAFF_DATE = '2016-10-03')A where emp_code = @ATTENDANCE_STAFF_TYPE_ID and (ATTENDANCE_STAFF_TIME_IN = '12:00:00 AM' OR ATTENDANCE_STAFF_TIME_OUT = '12:00:00 AM'))
   
   if (select COUNT(*) from ATTENDANCE_STAFF where ATTENDANCE_STAFF_ID = @attendance_id and ATTENDANCE_STAFF_TIME_IN = '12:00:00 AM' ) = 1
   BEGIN
	update ATTENDANCE_STAFF set ATTENDANCE_STAFF_TIME_IN = @ATTENDANCE_STAFF_TIME where ATTENDANCE_STAFF_ID = @attendance_id 
   END
   ELSE
   BEGIN
	update ATTENDANCE_STAFF set ATTENDANCE_STAFF_TIME_OUT = @ATTENDANCE_STAFF_TIME where ATTENDANCE_STAFF_ID = @attendance_id 
   END
   
   

		
 
end