CREATE PROC [dbo].[sp_ATTENDANCE_SET_TIME_updation]


 @ID numeric,
 @STAFF_ID numeric,
 @DATE date,
 @RECORD_STATUS char(1),
 @REMARKS nvarchar(10),
 @TIME_IN nvarchar(50),
 @TIME_OUT nvarchar(50),
 @CURRENT_TIME_IN nvarchar(50),
 @CURRENT_TIME_OUT nvarchar(50),
 @USER_NAME nvarchar(50),
 @BR_ID numeric,
 @HD_ID numeric



AS


--declare @ID numeric
--declare @STAFF_ID numeric
--declare @DATE date
--declare @RECORD_STATUS char(1)
--declare @REMARKS nvarchar(10)
--declare @TIME_IN nvarchar(50)
--declare @TIME_OUT nvarchar(50)
--declare @CURRENT_TIME_IN nvarchar(50)
--declare @CURRENT_TIME_OUT nvarchar(50)
--declare @USER_NAME nvarchar(50)

declare @late_minutes int = 0
declare @early_minutes int = 0
declare @half_day_minutes int = 0

declare @short_leave_id numeric = 0
declare @count int = 0


declare @DB_CURRENT_TIME_IN nvarchar(50)
declare @DB_CURRENT_TIME_OUT nvarchar(50)
declare @ATTENDANCE_STAFF_ID numeric
declare @is_first_record bit = 0
	select @late_minutes = BR_ADM_PAYROLL_LATE_MINUTES, @early_minutes = BR_ADM_EARLY_MINUTES_ALLOWED,@half_day_minutes = BR_ADM_HALF_DAY_MINUTES from BR_ADMIN where BR_ADM_HD_ID=@hd_id and BR_ADM_ID = @br_id


if @RECORD_STATUS = 'U'
BEGIN
	

	select @DB_CURRENT_TIME_IN = ATTENDANCE_STAFF_CURRENT_TIME_IN, @DB_CURRENT_TIME_OUT = ATTENDANCE_STAFF_CURRENT_TIME_OUT from ATTENDANCE_STAFF where ATTENDANCE_STAFF_ID = @ID
		select @count = COUNT(*) from ATTENDANCE_STAFF where ATTENDANCE_STAFF_DATE = @DATE and ATTENDANCE_STAFF_TYPE_ID = @STAFF_ID --ATTENDANCE_STAFF_ID = @ID

		if @count > 1
		BEGIN
			select top(1) @ATTENDANCE_STAFF_ID = ATTENDANCE_STAFF_ID from ATTENDANCE_STAFF where ATTENDANCE_STAFF_DATE = @DATE and ATTENDANCE_STAFF_TYPE_ID = @STAFF_ID order by CAST(ATTENDANCE_STAFF_TIME_IN as time)
			if @ATTENDANCE_STAFF_ID = @ID
				BEGIN
					set @is_first_record = 1
				END			
		END

		if @count = 1 OR @is_first_record = 1
		BEGIN		
			--In Case of LATE ARRIVAL
			select top(1) @short_leave_id = SHORT_LEAVE_ID from SHORT_LEAVE where SHORT_LEAVE_DATE = @date and SHORT_LEAVE_STAFF_ID = @staff_id and  CAST(SHORT_LEAVE_FROM_TIME  as time)= CAST(@DB_CURRENT_TIME_IN as time) 
			exec dbo.sp_SHORT_LEAVE_deletion 'D',@short_leave_id

			if DATEDIFF(MI,CAST(@current_time_in as datetime), CAST(@TIME_IN  as datetime)) >= @half_day_minutes +  @late_minutes
			BEGIN
				exec dbo.sp_SHORT_LEAVE_insertion @staff_id,@HD_ID,@BR_ID,@date,@current_time_in,@TIME_IN,'Half Day Due to Late Arrival','T',0,0
			END

			--In Case of EARLY DEPARTURE
			select top(1) @short_leave_id = SHORT_LEAVE_ID from SHORT_LEAVE where SHORT_LEAVE_DATE = @date and SHORT_LEAVE_STAFF_ID = @staff_id and  CAST(SHORT_LEAVE_TO_TIME  as time)= CAST(@DB_CURRENT_TIME_OUT as time)  
			exec dbo.sp_SHORT_LEAVE_deletion 'D',@short_leave_id

			if @TIME_OUT != '12:00:00 AM'
			BEGIN
				if DATEDIFF(MI,CAST(@TIME_OUT as datetime), CAST( @current_time_out as datetime)) >= @half_day_minutes +  @early_minutes
					BEGIN		
						exec dbo.sp_SHORT_LEAVE_insertion @staff_id,@HD_ID,@BR_ID,@date,@TIME_OUT,@current_time_out,'Half Day Due to Early Departure','T',0,0
					END
			END
		END
		ELSE
		BEGIN

			--In Case of More than 1 entry of EARLY DEPARTURE for Time In
			select top(1) @short_leave_id = SHORT_LEAVE_ID from SHORT_LEAVE where SHORT_LEAVE_DATE = @date and SHORT_LEAVE_STAFF_ID = @staff_id and  CAST(SHORT_LEAVE_TO_TIME  as time)= CAST(@DB_CURRENT_TIME_OUT as time) 
			exec dbo.sp_SHORT_LEAVE_deletion 'D',@short_leave_id

			if DATEDIFF(MI,CAST(@TIME_IN as datetime), CAST( @current_time_out as datetime)) >= @half_day_minutes +  @early_minutes
			BEGIN
				exec dbo.sp_SHORT_LEAVE_insertion @staff_id,@HD_ID,@BR_ID,@date,@TIME_IN,@current_time_out,'Half Day Due to Early Departure','T',0,0
			END


			--In Case of More than 1 entry of EARLY DEPARTURE for Time Out
			

			if @TIME_OUT != '12:00:00 AM'
			BEGIN
				select top(1) @short_leave_id = SHORT_LEAVE_ID from SHORT_LEAVE where SHORT_LEAVE_DATE = @date and SHORT_LEAVE_STAFF_ID = @staff_id and  CAST(SHORT_LEAVE_TO_TIME  as time)= CAST(@DB_CURRENT_TIME_OUT as time)
			exec dbo.sp_SHORT_LEAVE_deletion 'D',@short_leave_id

				if DATEDIFF(MI,CAST(@TIME_OUT as datetime), CAST( @current_time_out as datetime)) >= @half_day_minutes +  @early_minutes
					BEGIN		
						exec dbo.sp_SHORT_LEAVE_insertion @staff_id,@HD_ID,@BR_ID,@date,@TIME_OUT,@current_time_out,'Half Day Due to Early Departure','T',0,0
					END
			END
		END




	update ATTENDANCE_STAFF set ATTENDANCE_STAFF_REMARKS = @REMARKS, ATTENDANCE_STAFF_TIME_IN =@TIME_IN, ATTENDANCE_STAFF_TIME_OUT = @TIME_OUT, ATTENDANCE_STAFF_CURRENT_TIME_IN = @CURRENT_TIME_IN, ATTENDANCE_STAFF_CURRENT_TIME_OUT = @CURRENT_TIME_OUT,ATTENDANCE_STAFF_ENTER_DATE = GETDATE(), ATTENDANCE_STAFF_MACHINE_NO = @USER_NAME,ATTENDANCE_STAFF_STATUS = 'manual' where ATTENDANCE_STAFF_ID = @ID
END
ELSE IF @RECORD_STATUS = 'I'
BEGIN

		if @REMARKS != 'A'
		BEGIN
			
			insert into ATTENDANCE_STAFF
			select TECH_HD_ID, TECH_BR_ID,TECH_DESIGNATION,@STAFF_ID,@DATE,@TIME_IN,@TIME_OUT,@CURRENT_TIME_IN, @CURRENT_TIME_OUT,GETDATE(),@REMARKS,'manual',NULL, @USER_NAME from TEACHER_INFO where TECH_ID = @STAFF_ID

			--In Case of LATE ARRIVAL
			select top(1) @short_leave_id = SHORT_LEAVE_ID from SHORT_LEAVE where SHORT_LEAVE_DATE = @date and SHORT_LEAVE_STAFF_ID = @staff_id and  CAST(SHORT_LEAVE_FROM_TIME  as time)= CAST(@DB_CURRENT_TIME_IN as time) 
			exec dbo.sp_SHORT_LEAVE_deletion 'D',@short_leave_id

			if DATEDIFF(MI,CAST(@current_time_in as datetime), CAST(@TIME_IN  as datetime)) >= @half_day_minutes +  @late_minutes
			BEGIN
				exec dbo.sp_SHORT_LEAVE_insertion @staff_id,@HD_ID,@BR_ID,@date,@current_time_in,@TIME_IN,'Half Day Due to Late Arrival','T',0,0
			END

			--In Case of EARLY DEPARTURE
			select top(1) @short_leave_id = SHORT_LEAVE_ID from SHORT_LEAVE where SHORT_LEAVE_DATE = @date and SHORT_LEAVE_STAFF_ID = @staff_id and  CAST(SHORT_LEAVE_TO_TIME  as time)= CAST(@DB_CURRENT_TIME_OUT as time)  
			exec dbo.sp_SHORT_LEAVE_deletion 'D',@short_leave_id

			if @TIME_OUT != '12:00:00 AM'
			BEGIN
				if DATEDIFF(MI,CAST(@TIME_OUT as datetime), CAST( @current_time_out as datetime)) >= @half_day_minutes +  @early_minutes
					BEGIN		
						exec dbo.sp_SHORT_LEAVE_insertion @staff_id,@HD_ID,@BR_ID,@date,@TIME_OUT,@current_time_out,'Half Day Due to Early Departure','T',0,0
					END
			END
		END
	
END