﻿CREATE procedure  [dbo].[sp_ATTENDANCE_STAFF_updation]
                                               
                                               
          @ATTENDANCE_STAFF_ID  numeric,
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
   
   
     as begin 
   
   

   if @ATTENDANCE_STAFF_STATUS = 'A'
		begin
			update ATTENDANCE_STAFF set ATTENDANCE_STAFF_REMARKS = @ATTENDANCE_STAFF_REMARKS
			where 
			ATTENDANCE_STAFF_DATE = @ATTENDANCE_STAFF_DATE and ATTENDANCE_STAFF_TYPE_ID = @ATTENDANCE_STAFF_TYPE_ID 
		end


	else
	begin
     update ATTENDANCE_STAFF
 
     set
          ATTENDANCE_STAFF_TYPE =  @ATTENDANCE_STAFF_TYPE,
          ATTENDANCE_STAFF_TYPE_ID =  @ATTENDANCE_STAFF_TYPE_ID,
          ATTENDANCE_STAFF_DATE =  @ATTENDANCE_STAFF_DATE,
          ATTENDANCE_STAFF_TIME_IN =  @ATTENDANCE_STAFF_TIME_IN,
          ATTENDANCE_STAFF_TIME_OUT =  @ATTENDANCE_STAFF_TIME_OUT,
          ATTENDANCE_STAFF_CURRENT_TIME_IN =  @ATTENDANCE_STAFF_CURRENT_TIME_IN,
          ATTENDANCE_STAFF_CURRENT_TIME_OUT =  @ATTENDANCE_STAFF_CURRENT_TIME_OUT,
          ATTENDANCE_STAFF_ENTER_DATE =  GETDATE(),
          ATTENDANCE_STAFF_REMARKS =  @ATTENDANCE_STAFF_REMARKS,
          ATTENDANCE_STAFF_STATUS = 'manual'
 
     where 
          ATTENDANCE_STAFF_ID =  @ATTENDANCE_STAFF_ID 

     end


		
 
end