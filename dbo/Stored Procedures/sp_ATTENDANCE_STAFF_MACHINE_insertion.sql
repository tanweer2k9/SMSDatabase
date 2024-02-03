

CREATE PROC [dbo].[sp_ATTENDANCE_STAFF_MACHINE_insertion]

@STATUS nvarchar(50),
@IS_ABSENT bit,
@PC_NAME nvarchar(50),
@MACHINE_NO nvarchar(50),
@dt_attendance dbo.[type_STAFF_ATTENDANCE] readonly,
@HD_ID int,
@BR_ID int


AS

declare @MAIN_SWITCH_STATUS char(1) = ''

select @MAIN_SWITCH_STATUS = MAIN_SWITCH_STATUS from MAIN_SWITCH

if @MAIN_SWITCH_STATUS = 'F'
BEGIN
	select 'Updation is in progress'
END

ELSE
BEGIN
-- Firstly used when in attendance software was manually inserted by clicking the button. 
if @STATUS = 'manual'
BEGIN
	insert into ATTENDANCE_STAFF

	select TECH_HD_ID, TECH_BR_ID,TECH_DESIGNATION,UserID,Date, [Time In],[Time Out],STAFF_WORKING_DAYS_TIME_IN, 
	STAFF_WORKING_DAYS_TIME_OUT, [Entered Date], CASE WHEN Remarks = 'P' and 
	CAST(([Time In]) as datetime) > DATEADD(MI,(select top(1) BR_ADM_PAYROLL_LATE_MINUTES from BR_ADMIN where BR_ADM_HD_ID = (select TECH_HD_ID from TEACHER_INFO where TECH_ID = UserID) and
	BR_ADM_ID = (select TECH_BR_ID from TEACHER_INFO where TECH_ID = UserID)), CAST((STAFF_WORKING_DAYS_TIME_IN ) as datetime))
	THEN 'LA' ELSE 'P' END,'auto' Status,@PC_NAME,@MACHINE_NO
	 from
	(
	select t.TECH_HD_ID, t.TECH_BR_ID,t.TECH_DESIGNATION,t.TECH_ID as UserID,E.Date, REPLACE(CONVERT(varchar, I, 9),'.0000000',' ') as [Time In],REPLACE(CONVERT(varchar, O, 9),'.0000000',' ') as [Time Out],
	w.STAFF_WORKING_DAYS_TIME_IN, w.STAFF_WORKING_DAYS_TIME_OUT, GETDATE() as [Entered Date], Remarks,'T' Status
	 from
	(select *,'P' Remarks from
	(select USERID, CONVERT(date,CHECKTIME) as [Date], cast(CHECKTIME as time) [time], CHECKTYPE from (select * from 
	(select *, ROW_NUMBER() OVER(PARTITION BY CONVERT(date, CHECKTIME), USERID,CHECKTYPE ORDER BY (CHECKTIME)) AS RowID from @dt_attendance where CHECKTYPE = 'I')A
	where RowID = 1
	union 
	select * from 
	(select *, ROW_NUMBER() OVER(PARTITION BY CONVERT(date, CHECKTIME), USERID,CHECKTYPE ORDER BY (CHECKTIME)DESC) AS RowID from @dt_attendance where CHECKTYPE = 'O')B
	where RowID = 1) C)D

	pivot
	(MAX([time]) for [CHECKTYPE] in([I],[O]))
			 as final_tbl

	union 

	select *, '12:00:00 AM' as I,'12:00:00 AM' as O, 'A' Remarks  from 
	(select distinct USERID from @dt_attendance)G
	cross join (select distinct Date from(select CONVERT(date,CHECKTIME) as [Date] from @dt_attendance)I )H 

	where CAST((USERID) as nvarchar(50)) + '-' + CAST((date) as nvarchar(50))  not in (
	select CAST((USERID) as nvarchar(50)) + '-' + CAST((date) as nvarchar(50)) from (select CONVERT(date,CHECKTIME) as [Date],* from @dt_attendance)F group by date,USERID
	))E
		 
	join STAFF_MACHINE_ALLOCATION m on m.STAFF_MACHINE_ID = E.USERID
	join TEACHER_INFO t on t.TECH_ID = m.STAFF_ID
	join STAFF_WORKING_DAYS w on w.STAFF_WORKING_DAYS_STAFF_ID = m.STAFF_ID and w.STAFF_WORKING_DAYS_NAME = DATENAME(WEEKDAY, E.Date)
	where t.TECH_STATUS = 'T' and Date >= t.TECH_JOINING_DATE and CAST((t.TECH_ID) as nvarchar(50)) + '-' + CAST((E.date) as nvarchar(50)) not in 
	(select CAST((ATTENDANCE_STAFF_TYPE_ID) as nvarchar(50)) + '-' + CAST((ATTENDANCE_STAFF_DATE) as nvarchar(50)) from ATTENDANCE_STAFF where ATTENDANCE_STAFF_DATE 
	in ((select distinct Date from(select CONVERT(date,CHECKTIME) as [Date] from @dt_attendance)I )))
	)Q  order by Date,USERID 
END

ELSE IF @STATUS = 'auto'
BEGIN
	
	

	declare @date date = ''
	declare @holiday_count int = 0

	set @date = (select top(1) CONVERT(date, CHECKTIME) from @dt_attendance)
	declare @attendance_count int = 0
	set @attendance_count = (select COUNT(*) from ATTENDANCE_STAFF where ATTENDANCE_STAFF_HD_ID = @HD_ID and ATTENDANCE_STAFF_BR_ID = @BR_ID)

	--enter absent of today
	declare @total_staff int = 0
	set @total_staff = ( select COUNT(*) from TEACHER_INFO A join STAFF_WORKING_DAYS w on A.TECH_ID = w.STAFF_WORKING_DAYS_STAFF_ID and DATENAME(DW,'2015-03-22') = w.STAFF_WORKING_DAYS_NAME and w.STAFF_WORKING_DAYS_DAY_STATUS = 'T'
						where TECH_STATUS = 'T')

	set @holiday_count = (select COUNT(*) from ANNUAL_HOLIDAYS where ANN_HOLI_DATE = @date and ANN_HOLI_STATUS = 'T')
	if @holiday_count = 0 and (@attendance_count < @total_staff)
	BEGIN
		select A.*,@date, '12:00:00 AM', '12:00:00 AM', w.STAFF_WORKING_DAYS_TIME_IN, w.STAFF_WORKING_DAYS_TIME_OUT,GETDATE(),'A','auto',@PC_NAME,@MACHINE_NO from
		  (select TECH_HD_ID,TECH_BR_ID,TECH_DESIGNATION, TECH_ID  
		  from TEACHER_INFO where TECH_HD_ID = @HD_ID and TECH_BR_ID = @BR_ID and TECH_STATUS = 'T')A
		   cross join
		    (select @date as abest_date  from @dt_attendance)B
		   join STAFF_WORKING_DAYS w on A.TECH_ID = w.STAFF_WORKING_DAYS_STAFF_ID and DATENAME(DW,@date) = w.STAFF_WORKING_DAYS_NAME and w.STAFF_WORKING_DAYS_DAY_STATUS = 'T'
	END
	


	declare @hd_id_absent int = 0
	declare @br_id_absent int = 0


	declare @count int = 0
	declare @i int = 1
	declare @staff_id numeric = 0
	declare @staff_emp_code_std_school_id nvarchar(50) = 0
	declare @datetime datetime = 0
	--declare @hd_id int = 0
	--declare @br_id int = 0
	declare @staff_type nvarchar(50) =  ''
	declare @short_leave_id numeric = 0
	declare @time nvarchar(50) = ''
	declare @time_nvarchar nvarchar(11) = ''
	declare @current_time_in nvarchar(50) = NULL
	declare @current_time_out nvarchar(50) = NULL
	declare @late_minutes int = 0
	declare @early_minutes int = 0
	declare @half_day_minutes int = 0
	declare @day nvarchar(50) = ''
	declare @remarks nvarchar(50) = ''
	declare @seconds int = 0
	declare @staff_attendance_id int = 0
	declare @staff_date_attendance_count int = 0,
	@std_1_staff_0 int = -1,
	@type nvarchar(50) = ''
	

	-- Student Attendance
	declare @std_id int = 0
	declare @class_id int = 0
	declare @student_attendance_id int = 0

	set @current_time_in  = NULL
	 set @current_time_out  = NULL

	set @count = (select COUNT(*) from @dt_attendance where CHECKTYPE != 'Absent')
	while @i <= @count
	BEGIN
	set @staff_id = 0
	set @std_id = 0
	set @short_leave_id = 0

	set @type = ''
		
		select @staff_emp_code_std_school_id = USERID, @datetime = CHECKTIME from (select ROW_NUMBER() over (order by (select 0)) as sr, * from @dt_attendance where CHECKTYPE != 'Absent' )A where sr = @i	
		
		--Staff		
		select top(1) @staff_id = TECH_ID, @staff_type = TECH_DESIGNATION from TEACHER_INFO where TECH_EMPLOYEE_CODE = @staff_emp_code_std_school_id and TECH_HD_ID = @HD_ID and TECH_BR_ID = @BR_ID
		set @staff_id = ISNULL(@staff_id,0)

		--Student
		select top(1) @std_id = STDNT_ID, @class_id = STDNT_CLASS_PLANE_ID from STUDENT_INFO where STDNT_SCHOOL_ID = @staff_emp_code_std_school_id and STDNT_HD_ID = @HD_ID and STDNT_BR_ID = @BR_ID
		set @std_id = ISNULL(@std_id,0)
		
		if @staff_id != 0 and @std_id = 0
		BEGIN
			set @std_1_staff_0 = 0
		END
		ELSE IF @staff_id = 0 and @std_id != 0
		BEGIN
			set @std_1_staff_0 = 1
		END

		if @staff_id = 0 and @std_id = 0
		BEGIN
			set @type = 'Missing'
		END
		ELSE IF @staff_id = 1 and @std_id = 1
		BEGIN
			set @type = 'Duplicate'
		END
		
		if @type != ''
		BEGIN
			insert into ATTEND_STAFF_NOT_EMP_CODE select @staff_emp_code_std_school_id, @datetime, @type
		END		
		ELSE
		BEGIN
			if @std_1_staff_0 != -1
			BEGIN
				select @hd_id_absent = @hd_id, @br_id_absent = @br_id

				
				if @std_1_staff_0 = 0
				BEGIN--Staff
					select @late_minutes = BR_ADM_PAYROLL_LATE_MINUTES, @early_minutes = BR_ADM_EARLY_MINUTES_ALLOWED,@half_day_minutes = BR_ADM_HALF_DAY_MINUTES from BR_ADMIN where BR_ADM_HD_ID=@hd_id and BR_ADM_ID = @br_id
				END				
				ELSE
				BEGIN--Student
					select @late_minutes = BR_ADM_STUDENT_LATE_MINUTES from BR_ADMIN where BR_ADM_HD_ID=@hd_id and BR_ADM_ID = @br_id
				END
			
				select @date = CONVERT(date,@datetime), @time = CONVERT(time,@datetime), @day = DATENAME(dw,@datetime)		
			
				set @time_nvarchar = RIGHT('00000000000'+ CAST(REPLACE( CONVERT(varchar, CONVERT(time,@time), 9)  ,'.0000000',' ') AS VARCHAR(11)),11)

				if @std_1_staff_0 = 0
				BEGIN--Staff
					if (select COUNT(*) from EXTRA_HOLIDAYS where STAFF_ID = @staff_id and DATE = @date) = 0
					BEGIN
						select @current_time_in = STAFF_WORKING_DAYS_TIME_IN, @current_time_out = STAFF_WORKING_DAYS_TIME_OUT from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @staff_id and STAFF_WORKING_DAYS_NAME = @day
					END 
					ELSE
					BEGIN
						select @current_time_in = TIME_IN, @current_time_out = TIME_OUT from EXTRA_HOLIDAYS where STAFF_ID = @staff_id and DATE = @date
					END
					
				END				
				ELSE
				BEGIN--Student				
					select @current_time_in = WORKING_HOURS_TIME_IN, @current_time_out = WORKING_HOURS_TIME_IN from WORKING_HOURS where WORKING_HOURS_HD_ID = @HD_ID and WORKING_HOURS_BR_ID = @BR_ID
				END
			
				set @seconds = DATEDIFF(SECOND,CONVERT(datetime,(CONVERT(time,@current_time_in))),CONVERT(datetime,(CONVERT(time,@time))))		
		

				if (@late_minutes * 60) < @seconds
				BEGIN
					select @remarks = 'LA'
				END
				else 
				BEGIn
					select @remarks = 'P'
				END

				set @staff_date_attendance_count = (select COUNT(ATTENDANCE_STAFF_ID) from ATTENDANCE_STAFF where ATTENDANCE_STAFF_DATE = @date 
				and ATTENDANCE_STAFF_REMARKS in ('P', 'LA') and ATTENDANCE_STAFF_TYPE_ID = @staff_id  )

				if @staff_date_attendance_count > 0
				BEGIN
					set @remarks = 'P'
				END
				--Staff
				if @std_1_staff_0 = 0
				BEGIN--Staff
					set @staff_attendance_id = (select top(1) ATTENDANCE_STAFF_ID from ATTENDANCE_STAFF where ATTENDANCE_STAFF_TIME_OUT = '12:00:00 AM' 
					and ATTENDANCE_STAFF_DATE = @date and ATTENDANCE_STAFF_REMARKS in ('P', 'LA') and ATTENDANCE_STAFF_TYPE_ID = @staff_id order by ATTENDANCE_STAFF_ID DESC)
					set @staff_attendance_id = ISNULL(@staff_attendance_id,0)
				END
				ELSE--Student
				BEGIN
					set @student_attendance_id = (select ATTENDANCE_ID from ATTENDANCE where ATTENDANCE_DATE = @date 
					and ATTENDANCE_REMARKS in ('P', 'LA') and ATTENDANCE_TYPE_ID = @std_id )
					set @student_attendance_id = ISNULL(@student_attendance_id,0)
				END

				declare @is_duplicate bit = 0
				--checking if the time is withing 2 min then no attendance insertion
				if @staff_attendance_id = 0
				BEGIN
					declare @check_time_for_duplication time = ''
					set @check_time_for_duplication = (select top(1) CAST(ATTENDANCE_STAFF_TIME_OUT as time) from ATTENDANCE_STAFF where ATTENDANCE_STAFF_DATE = @date and ATTENDANCE_STAFF_REMARKS in ('P', 'LA') and ATTENDANCE_STAFF_TYPE_ID = @staff_id order by ATTENDANCE_STAFF_ID DESC)
					

				END
				ELSE
				BEGIN
					set @check_time_for_duplication = (select CAST(ATTENDANCE_STAFF_TIME_IN as time) from ATTENDANCE_STAFF where ATTENDANCE_STAFF_ID = @staff_attendance_id)
				END

				if @check_time_for_duplication is not null
					BEGIN
						if  CAST(@time as time) < DATEADD(MI,5,@check_time_for_duplication) 
						BEGIN
							set @is_duplicate = 1
						END
					END


				--Staff
				if @std_1_staff_0 = 0
				BEGIN
					if @is_duplicate = 0
					BEGIN
						if @staff_attendance_id = 0
							BEGIN

							set @staff_attendance_id = (select ATTENDANCE_STAFF_ID from ATTENDANCE_STAFF where 
							ATTENDANCE_STAFF_DATE = @date and ATTENDANCE_STAFF_REMARKS ='A' and ATTENDANCE_STAFF_TYPE_ID = @staff_id )
							set @staff_attendance_id = ISNULL(@student_attendance_id,0)
							if @staff_attendance_id = 0
							BEGIN
								insert into ATTENDANCE_STAFF select @hd_id, @br_id, @staff_type, @staff_id, @date, @time_nvarchar, '12:00:00 AM', @current_time_in, @current_time_out,GETDATE(),@remarks,'auto' Status,@PC_NAME,@MACHINE_NO	

								if @staff_date_attendance_count = 0
								BEGIN
									if DATEDIFF(MI,CAST(@current_time_in as datetime), CAST(@time_nvarchar  as datetime)) >= @half_day_minutes +  @late_minutes
									BEGIN
										exec dbo.sp_SHORT_LEAVE_insertion @staff_id,@HD_ID,@BR_ID,@date,@current_time_in,@time_nvarchar,'Half Day Due to Late Arrival','T',0,0
									END
								END
								ELSE
								BEGIN
										
										select top(1) @short_leave_id = SHORT_LEAVE_ID from SHORT_LEAVE where SHORT_LEAVE_DATE = @date and SHORT_LEAVE_STAFF_ID = @staff_id and CAST(SHORT_LEAVE_TO_TIME as time) = CAST(@current_time_out as time)
										exec dbo.sp_SHORT_LEAVE_deletion 'D',@short_leave_id
									if DATEDIFF(MI,CAST(@time_nvarchar as datetime), CAST( @current_time_out as datetime)) >= @half_day_minutes +  @early_minutes
									BEGIN
										
										
										exec dbo.sp_SHORT_LEAVE_insertion @staff_id,@HD_ID,@BR_ID,@date,@time_nvarchar,@current_time_out,'Half Day Due to Early Departure','T',0,0
									END
								END

							END
							ELSE
							BEGIN
								update ATTENDANCE_STAFF set ATTENDANCE_STAFF_TIME_IN = @time_nvarchar, ATTENDANCE_STAFF_REMARKS = @remarks,
								ATTENDANCE_STAFF_ENTER_DATE = GETDATE() where ATTENDANCE_STAFF_ID = @student_attendance_id
							END
							
						END
						ELSE
							BEGIN
							update ATTENDANCE_STAFF set ATTENDANCE_STAFF_TIME_OUT = @time_nvarchar,
							ATTENDANCE_STAFF_ENTER_DATE = GETDATE()
							 where ATTENDANCE_STAFF_ID = @staff_attendance_id

							 select top(1) @short_leave_id = SHORT_LEAVE_ID from SHORT_LEAVE where SHORT_LEAVE_DATE = @date and SHORT_LEAVE_STAFF_ID = @staff_id and CAST(SHORT_LEAVE_TO_TIME  as time)= CAST(@current_time_out as time) 
							 exec dbo.sp_SHORT_LEAVE_deletion 'D',@short_leave_id

									if DATEDIFF(MI,CAST(@time_nvarchar as datetime), CAST( @current_time_out as datetime)) >= @half_day_minutes +  @early_minutes
									BEGIN										
										
										exec dbo.sp_SHORT_LEAVE_insertion @staff_id,@HD_ID,@BR_ID,@date,@time_nvarchar,@current_time_out,'Half Day Due to Early Departure','T',0,0
									END
						END
					END
				END
				ELSE
				BEGIN --student
					if @student_attendance_id = 0
						BEGIN 
							insert into ATTENDANCE select @hd_id, @br_id, 'Student', @std_id, @date,@remarks,'auto,',@class_id, @time_nvarchar, '12:00:00 AM', @current_time_in, @current_time_out,GETDATE(),'',@PC_NAME,@MACHINE_NO
						END
					ELSE
						BEGIN
							update ATTENDANCE set ATTENDANCE_TIME_OUT = @time_nvarchar,
							ATTENDANCE_ENTERED_DATE = ATTENDANCE_ENTERED_DATE 
							 where ATTENDANCE_ID = @staff_attendance_id
						END
				END
			END
		END
		--12:00:00 AM

		set @i = @i + 1
	END

	if @IS_ABSENT = 1
	BEGIN
		  insert into ATTENDANCE_STAFF
		  select A.*,B.abest_date, '12:00:00 AM', '12:00:00 AM', w.STAFF_WORKING_DAYS_TIME_IN, w.STAFF_WORKING_DAYS_TIME_OUT,GETDATE(),'A','auto',@PC_NAME,@MACHINE_NO from
		  (select TECH_HD_ID,TECH_BR_ID,TECH_DESIGNATION, TECH_ID  
		  from TEACHER_INFO where TECH_HD_ID = @hd_id_absent and TECH_BR_ID = @br_id_absent
		   and TECH_ID not in (select ATTENDANCE_STAFF_TYPE_ID from ATTENDANCE_STAFF where ATTENDANCE_STAFF_DATE in 
		   (select CONVERT(DATE,CHECKTIME) from @dt_attendance where CHECKTYPE = 'Absent')
		   ))A
		   cross join
		   (select CONVERT(DATE,CHECKTIME) as abest_date from @dt_attendance where CHECKTYPE = 'Absent')B
		   join STAFF_WORKING_DAYS w on A.TECH_ID = w.STAFF_WORKING_DAYS_STAFF_ID and DATENAME(DW,B.abest_date) = w.STAFF_WORKING_DAYS_NAME and w.STAFF_WORKING_DAYS_DAY_STATUS = 'T'
		   



	END
	
	
	select 'ok'
END
END