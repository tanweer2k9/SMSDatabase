CREATE procedure [dbo].[sp_SMS_INSERT]
	   
	   @FEE_COLLECT_HD_ID numeric,
	   @FEE_COLLECT_BR_ID numeric,
	   @FEE_COLLECT_ID numeric,
	   @FEE_COLLECT_USER_ID numeric,
	   @status char(1)
	   
	    AS BEGIN
	   
	   
	   declare @sms_screen_id int = 0
	   declare @sms_insert_status char = ''
	   declare @sms_insert_var_names nvarchar(200) = ''
	   declare @sms_insert_msg nvarchar(200) = ''
		declare @sms_parent_status char =''
		declare @sms_student_status char ='' 
		declare @sms_parent_name nvarchar(200) = ''
		declare @sms_student_name nvarchar(200) = ''
		declare @sms_parent_cell nvarchar(20) = ''
		declare @sms_student_cell nvarchar(20) = ''		
		declare @sms_total_fees numeric = 0
		declare @sms_invoice numeric = 0
		declare @sms_month nvarchar(50) = ''
		declare @sms_student_msg nvarchar(200) = ''
		declare @sms_parent_msg nvarchar(200) = ''
		declare @sms_staff_msg nvarchar(200) = ''
		declare @sms_staff_name nvarchar(200) = ''
		declare @sms_staff_cell nvarchar(20) = ''
		declare @sms_staff_status char ='' 
		declare @sms_total_salary numeric = 0
		declare @sms_msg nvarchar(200) = ''
		declare @count int  = 0
		declare @i int = 0
	
	if @status = 'F' -- for student fees
	BEGIN
		set @count = (select COUNT(*)from SMS_SCREEN where SMS_SCREEN_NAME = 'Fee Generation' and SMS_SCREEN_HD_ID = @FEE_COLLECT_HD_ID and SMS_SCREEN_BR_ID = @FEE_COLLECT_BR_ID)
			set @i = 1
			while @i <= @count
			begin
				select @sms_screen_id = SMS_TEMPLATE_SCREEN_ID, @sms_insert_status = SMS_SCREEN_INSERT,
				@sms_student_status	= SMS_SCREEN_STUDENT, @sms_parent_status = SMS_SCREEN_PARENTS,
				@sms_insert_msg = SMS_TEMPLATE_INSERT_MSG, @sms_insert_var_names = SMS_TEMPLATE_INSERT_VAR_ID FROM  
				
				(select ROW_NUMBER() over(order by (select 0)) as sr, * from dbo.SMS_TEMPLATE t
				join SMS_SCREEN s on s.SMS_SCREEN_ID = t.SMS_TEMPLATE_SCREEN_ID 
				where SMS_TEMPLATE_HD_ID = @FEE_COLLECT_HD_ID and SMS_TEMPLATE_BR_ID = @FEE_COLLECT_BR_ID and
				s.SMS_SCREEN_NAME = 'Fee Generation' and SMS_SCREEN_HD_ID = @FEE_COLLECT_HD_ID and SMS_SCREEN_BR_ID = @FEE_COLLECT_BR_ID and s.SMS_SCREEN_STATUS = 'T' ) a where a.sr = @i
				
				select @sms_student_name = STDNT_FIRST_NAME, @sms_student_cell = STDNT_CELL_NO, @sms_parent_name = PARNT_FIRST_NAME,
				@sms_parent_cell = PARNT_CELL_NO, @sms_invoice = @FEE_COLLECT_ID, @sms_total_fees = v.[Net Total] , @sms_month = v.[short Month Year]
				from VFEE_COLLECT v
				join STUDENT_INFO on STDNT_ID = v.[Student ID]
				join PARENT_INFO on STDNT_PARANT_ID = PARNT_ID
				where v.ID = @FEE_COLLECT_ID
				
				set @sms_insert_msg = @sms_insert_msg 
				set @sms_msg = REPLACE( REPLACE (REPLACE(@sms_insert_msg, '^Total Fee^', '^' + CONVERT(nvarchar(50), @sms_total_fees) + '^'), '^Invoice No^', '^' +CONVERT(nvarchar(50), @sms_invoice)+ '^'), '^Month^', '^' + @sms_month +'^' )
				
				
				
				if @sms_parent_status = 'T'
				begin										
					set @sms_parent_msg = REPLACE ( REPLACE(@sms_msg, '^Parent^', '^' + @sms_parent_name +'^'), '^Student^', '^'+@sms_student_name+ '^')
					--insert into SMS_QUEUE values(@FEE_COLLECT_HD_ID, @FEE_COLLECT_BR_ID, @sms_parent_cell, REPLACE(@sms_parent_msg,'^',''), @sms_screen_id, @FEE_COLLECT_USER_ID, GETDATE(), 'Q')										
					select @sms_parent_cell, REPLACE(@sms_parent_msg,'^',''), @sms_screen_id
				end
				
				if @sms_student_status = 'T'
				begin
					set @sms_student_msg = REPLACE ( @sms_msg, '^Student^', '^'+@sms_student_name+ '^')
					--insert into SMS_QUEUE values(@FEE_COLLECT_HD_ID, @FEE_COLLECT_BR_ID, @sms_student_cell, REPLACE(@sms_student_msg,'^','') , @sms_screen_id, @FEE_COLLECT_USER_ID, GETDATE(), 'Q')
					select @sms_student_cell, REPLACE(@sms_student_msg,'^',''), @sms_screen_id
				end
				
				set @i = @i + 1
			end
			
	END
		
		
	ELSE if @status = 'S' -- for staff salary
	BEGIN
		set @count = (select COUNT(*)from SMS_SCREEN where SMS_SCREEN_NAME = 'Pay Slip Generation' and SMS_SCREEN_HD_ID = @FEE_COLLECT_HD_ID and SMS_SCREEN_BR_ID = @FEE_COLLECT_BR_ID)
			set @i = 1
			while @i <= @count
			begin
				select @sms_screen_id = SMS_TEMPLATE_SCREEN_ID, @sms_insert_status = SMS_SCREEN_INSERT,
				@sms_staff_status	= SMS_SCREEN_STAFF,	@sms_insert_msg = SMS_TEMPLATE_INSERT_MSG, 
				@sms_insert_var_names = SMS_TEMPLATE_INSERT_VAR_ID FROM  				
				(select ROW_NUMBER() over(order by (select 0)) as sr, * from dbo.SMS_TEMPLATE t
				join SMS_SCREEN s on s.SMS_SCREEN_ID = t.SMS_TEMPLATE_SCREEN_ID 
				where SMS_TEMPLATE_HD_ID = @FEE_COLLECT_HD_ID and SMS_TEMPLATE_BR_ID = @FEE_COLLECT_BR_ID and
				s.SMS_SCREEN_NAME = 'Pay Slip Generation' and s.SMS_SCREEN_STATUS = 'T' and SMS_SCREEN_HD_ID = @FEE_COLLECT_HD_ID and SMS_SCREEN_BR_ID = @FEE_COLLECT_BR_ID) a where a.sr = @i
				
				select @sms_staff_name = TECH_FIRST_NAME, @sms_staff_cell = TECH_CELL_NO, 
				@sms_invoice = @FEE_COLLECT_ID, @sms_total_salary = v.[Net Total] , @sms_month = LEFT(DATENAME(MM,[Date]), 3) + ' ' + CONVERT(nvarchar(10), DATEPART(YYYY,[Date]))
				from VSTAFF_SALLERY v
				join TEACHER_INFO on TECH_ID = v.[Staff ID]				
				where v.ID = @FEE_COLLECT_ID
				
				set @sms_insert_msg = @sms_insert_msg 
				set @sms_msg = REPLACE( REPLACE (REPLACE(@sms_insert_msg, '^Salary^', '^' + CONVERT(nvarchar(50), @sms_total_salary) + '^'), '^Invoice No^', '^' +CONVERT(nvarchar(50), @sms_invoice)+ '^'), '^Month^', '^' + @sms_month +'^' )				
				
				if @sms_staff_status = 'T'
				begin
					set @sms_staff_msg = REPLACE ( @sms_msg, '^Staff^', '^'+@sms_staff_name+ '^')
					--insert into SMS_QUEUE values(@FEE_COLLECT_HD_ID, @FEE_COLLECT_BR_ID, @sms_staff_cell, REPLACE(@sms_staff_msg,'^',''), @sms_screen_id, @FEE_COLLECT_USER_ID, GETDATE(), 'Q')
					select @sms_staff_cell, REPLACE(@sms_staff_msg,'^',''),@sms_screen_id
				end
				
				
				set @i = @i + 1
			end
			
	END
END