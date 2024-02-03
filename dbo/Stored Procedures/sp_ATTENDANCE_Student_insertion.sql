CREATE procedure  [dbo].[sp_ATTENDANCE_Student_insertion]
                                               
                                               
          @ATTENDANCE_HD_ID  numeric,
          @ATTENDANCE_BR_ID  numeric,
          @ATTENDANCE_TYPE  nvarchar(50) ,
          @ATTENDANCE_TYPE_ID  numeric,
          @ATTENDANCE_DATE  date,          
          @ATTENDANCE_REMARKS  nvarchar(50) ,
          @ATTENDANCE_STATUS  nchar(10),
          @ATTENDANCE_CLASS_ID numeric,
		  @ATTENDANCE_TIME_IN nvarchar(50) ,
		  @ATTENDANCE_TIME_OUT nvarchar(50) ,
		  @ATTENDANCE_EXPECTED_TIME_IN nvarchar(50) ,
		  @ATTENDANCE_EXPECTED_TIME_OUT nvarchar(50) ,		  
		  @ATTENDANCE_USER nvarchar(50)
   
   
     as  begin
   
   if @ATTENDANCE_REMARKS = 'A' or @ATTENDANCE_REMARKS = 'LE'
   BEGIN
	set @ATTENDANCE_TIME_IN = '12:00:00 AM'
	set @ATTENDANCE_TIME_OUT = '12:00:00 AM'
   END

   
     insert into ATTENDANCE
     values
     (
        @ATTENDANCE_HD_ID,
        @ATTENDANCE_BR_ID,
        @ATTENDANCE_TYPE,
        @ATTENDANCE_TYPE_ID,
        @ATTENDANCE_DATE,       
        @ATTENDANCE_REMARKS,
        @ATTENDANCE_STATUS,
        @ATTENDANCE_CLASS_ID,
		@ATTENDANCE_TIME_IN,
		@ATTENDANCE_TIME_OUT,
		@ATTENDANCE_EXPECTED_TIME_IN,
		@ATTENDANCE_EXPECTED_TIME_OUT,
		GETDATE(),
		@ATTENDANCE_USER,
		'',
		''
     
     )
     
end