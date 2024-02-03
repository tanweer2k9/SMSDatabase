CREATE procedure  [dbo].[sp_ATTENDANCE_STAFF_insertion]
                                               
                                               
          @ATTENDANCE_STAFF_HD_ID  numeric,
          @ATTENDANCE_STAFF_BR_ID  numeric,
          @ATTENDANCE_STAFF_TYPE  nvarchar(50) ,
          @ATTENDANCE_STAFF_TYPE_ID  numeric,
          @ATTENDANCE_STAFF_DATE  date,
          @ATTENDANCE_STAFF_TIME_IN  nvarchar(50) ,
          @ATTENDANCE_STAFF_TIME_OUT  nvarchar(50) ,
          @ATTENDANCE_STAFF_CURRENT_TIME_IN  nvarchar(50) ,
          @ATTENDANCE_STAFF_CURRENT_TIME_OUT  nvarchar(50) ,
          @ATTENDANCE_STAFF_ENTER_DATE  date,
          @ATTENDANCE_STAFF_REMARKS  nvarchar(50) ,
          @ATTENDANCE_STAFF_STATUS  nvarchar(10)
		

   
   
     as  begin
   

		select @ATTENDANCE_STAFF_HD_ID = TECH_HD_ID, @ATTENDANCE_STAFF_BR_ID = TECH_BR_ID from TEACHER_INFO where TECH_ID = @ATTENDANCE_STAFF_TYPE_ID

   
     insert into ATTENDANCE_STAFF
     values
     (
        @ATTENDANCE_STAFF_HD_ID,
        @ATTENDANCE_STAFF_BR_ID,
        @ATTENDANCE_STAFF_TYPE,
        @ATTENDANCE_STAFF_TYPE_ID,
        @ATTENDANCE_STAFF_DATE,
        @ATTENDANCE_STAFF_TIME_IN,
        @ATTENDANCE_STAFF_TIME_OUT,
        @ATTENDANCE_STAFF_CURRENT_TIME_IN,
        @ATTENDANCE_STAFF_CURRENT_TIME_OUT,
        @ATTENDANCE_STAFF_ENTER_DATE,
        @ATTENDANCE_STAFF_REMARKS,
        'manual',
		'',
		''
     )
     
end