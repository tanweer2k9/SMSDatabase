CREATE PROCEDURE [dbo].[sp_CHARTS] 
@STATUS nvarchar(50),
@HD_ID numeric,
@BR_ID numeric,
@PK_ID numeric,
@START_DATE date,
@END_DATE date,
@CLASS_ID numeric,
@DEPARTMENT_ID numeric,
@DESIGNATION nvarchar(50) = ''



AS
	


BEGIN

--declare @STATUS nvarchar(50) = 'Fees Guage',
--@HD_ID numeric = 0,
--@BR_ID numeric = 0,
--@PK_ID numeric = 1081,
--@START_DATE date = '2013-11-18',
--@END_DATE date = '2013-12-18',
--@CLASS_ID numeric = 0


declare @dept_like nvarchar(50) = '%'
declare @desg_like nvarchar(50) = '%'
declare @class_id_nvar nvarchar(50) = '%'

if @CLASS_ID !=0 
	set @class_id_nvar = CAST(@CLASS_ID as nvarchar(50))

if @DESIGNATION != 'All'
	set @desg_like = @DESIGNATION

if @DEPARTMENT_ID != 0
	set @dept_like = CAST(@DEPARTMENT_ID as nvarchar(50))

	if  @STATUS = 'Dashboard'
	BEGIN
		select * from DASHBOARD_SETTING where DASHBOARD_LOGIN_ID = @PK_ID
	END
	else if @STATUS = 'Active Student'
	BEGIN
		select Count(*) from (select distinct ID from VSTUDENT_INFO with (nolock) where Status = 'T' and 
		[Institute ID] in (select * from get_all_hd_id(@HD_ID)) and [Branch ID] in (select * from get_all_br_id(@BR_ID)))A
		
		select Width, Height from VCHART_SETTING where Name = 'Active Student' and [Login ID] = @PK_ID and [Status] = 'T'
	END
	
	else if @STATUS = 'All Student'
	BEGIN
		
		select 'Active' as Name, Count(*) as [Count] from (select distinct ID from VSTUDENT_INFO with (nolock) where Status = 'T' and 
		[Institute ID] in (select * from get_all_hd_id(@HD_ID)) and [Branch ID] in (select * from get_all_br_id(@BR_ID)))A
		union all
		select 'Inactive' as Name, Count(*) as [Count] from (select distinct ID from VSTUDENT_INFO with (nolock) where Status = 'F' and 
		[Institute ID] in (select * from get_all_hd_id(@HD_ID)) and [Branch ID] in (select * from get_all_br_id(@BR_ID)))B
		
		select Width, Height from VCHART_SETTING where Name = 'All Student' and [Login ID] = @PK_ID and [Status] = 'T'
		
	END
	else if @STATUS ='All Staff'
	BEGIN
		select 'Active' as Name, Count(*) as [Count] from (select distinct ID from VTEACHER_INFO where Status = 'T' and 
		[Institute ID] in (select * from get_all_hd_id(@HD_ID)) and [Branch ID] in (select * from get_all_br_id(@BR_ID)))A
		union all
		select 'Inactive' as Name, Count(*) as [Count] from (select distinct ID from VTEACHER_INFO where Status = 'F' and 
		[Institute ID] in (select * from get_all_hd_id(@HD_ID)) and [Branch ID] in (select * from get_all_br_id(@BR_ID)))B
		
		select Width, Height from VCHART_SETTING where Name = 'All Staff' and [Login ID] = @PK_ID and [Status] = 'T'
	END
	else if @STATUS ='Staff Attendace Status'
	BEGIN
		declare @IN int = 0
		declare @OUT int = 0
		declare @present int = 0
		declare @absent int = 0
		declare @leave int = 0
		declare @late int = 0
		 
		 set @IN = (select COUNT(*) from ATTENDANCE_STAFF a join TEACHER_INFO t on a.ATTENDANCE_STAFF_TYPE_ID = t.TECH_ID where t.TECH_DEPARTMENT like @dept_like 
		 and t.TECH_DESIGNATION like @desg_like and a.ATTENDANCE_STAFF_HD_ID in (select * from get_all_hd_id(@HD_ID)) and a.ATTENDANCE_STAFF_BR_ID 
		 in (select * from get_all_br_id(@BR_ID))  and   ATTENDANCE_STAFF_DATE between @START_DATE and @END_DATE and ATTENDANCE_STAFF_TIME_OUT = '12:00:00 AM' 
		 and ATTENDANCE_STAFF_TIME_IN != '12:00:00 AM')

		 set @OUT = (select COUNT(*) from ATTENDANCE_STAFF a join TEACHER_INFO t on a.ATTENDANCE_STAFF_TYPE_ID = t.TECH_ID where t.TECH_DEPARTMENT like @dept_like 
		 and t.TECH_DESIGNATION like @desg_like and a.ATTENDANCE_STAFF_HD_ID in (select * from get_all_hd_id(@HD_ID)) and a.ATTENDANCE_STAFF_BR_ID 
		 in (select * from get_all_br_id(@BR_ID))  and   ATTENDANCE_STAFF_DATE between @START_DATE and @END_DATE) - @IN

		 set @present = (select COUNT(*) from ATTENDANCE_STAFF a join TEACHER_INFO t on a.ATTENDANCE_STAFF_TYPE_ID = t.TECH_ID where t.TECH_DEPARTMENT 
		 like @dept_like and t.TECH_DESIGNATION like @desg_like and a.ATTENDANCE_STAFF_HD_ID in (select * from get_all_hd_id(@HD_ID)) and a.ATTENDANCE_STAFF_BR_ID
		  in (select * from get_all_br_id(@BR_ID))  and   ATTENDANCE_STAFF_DATE between @START_DATE and @END_DATE and ATTENDANCE_STAFF_REMARKS = 'P')

		 set @absent = (select COUNT(*) from ATTENDANCE_STAFF a join TEACHER_INFO t on a.ATTENDANCE_STAFF_TYPE_ID = t.TECH_ID where t.TECH_DEPARTMENT 
		 like @dept_like and t.TECH_DESIGNATION like @desg_like and a.ATTENDANCE_STAFF_HD_ID in (select * from get_all_hd_id(@HD_ID)) and a.ATTENDANCE_STAFF_BR_ID 
		 in (select * from get_all_br_id(@BR_ID))  and   ATTENDANCE_STAFF_DATE between @START_DATE and @END_DATE and ATTENDANCE_STAFF_REMARKS = 'A')

		 set @leave = (select COUNT(*) from ATTENDANCE_STAFF a join TEACHER_INFO t on a.ATTENDANCE_STAFF_TYPE_ID = t.TECH_ID where t.TECH_DEPARTMENT 
		 like @dept_like and t.TECH_DESIGNATION like @desg_like and a.ATTENDANCE_STAFF_HD_ID in (select * from get_all_hd_id(@HD_ID)) and a.ATTENDANCE_STAFF_BR_ID 
		 in (select * from get_all_br_id(@BR_ID))  and   ATTENDANCE_STAFF_DATE between @START_DATE and @END_DATE and ATTENDANCE_STAFF_REMARKS = 'LE')

		 set @late = (select COUNT(*) from ATTENDANCE_STAFF a join TEACHER_INFO t on a.ATTENDANCE_STAFF_TYPE_ID = t.TECH_ID where t.TECH_DEPARTMENT 
		 like @dept_like and t.TECH_DESIGNATION like @desg_like and a.ATTENDANCE_STAFF_HD_ID in (select * from get_all_hd_id(@HD_ID)) and a.ATTENDANCE_STAFF_BR_ID
		  in (select * from get_all_br_id(@BR_ID))  and   ATTENDANCE_STAFF_DATE between @START_DATE and @END_DATE and ATTENDANCE_STAFF_REMARKS = 'LA')

		select @IN [IN], @OUT [OUT], @present [P], @absent [A], @leave [LE], @late [LA]
	END
		
	
	else if @STATUS = 'Fees Guage'
	BEGIN
		declare @fees_total numeric = 0
		declare @fees_receivable numeric = 0
		declare @fees_received numeric = 0
		
		
		
		select ID, Name from VSCHOOL_PLANE with (nolock) where [Institute ID] in (select * from get_all_hd_id(@HD_ID)) and 
		[Branch ID] in (select * from get_all_hd_id(@BR_ID)) and Status = 'T'
		
		
		select @fees_total = SUM( FEE_COLLECT_FEE + FEE_COLLECT_ARREARS) from FEE_COLLECT with (nolock)
		where FEE_COLLECT_HD_ID in (select * from get_all_hd_id(@HD_ID)) and FEE_COLLECT_BR_ID in (select * from get_all_br_id(@BR_ID)) and		
		DATEPART(MM, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(MM, @START_DATE) and DATEPART(YYYY, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(YYYY, @START_DATE)
		and FEE_COLLECT_PLAN_ID like @class_id_nvar
		
		
		select @fees_received = SUM( FEE_COLLECT_FEE_PAID + FEE_COLLECT_ARREARS_RECEIVED)  from FEE_COLLECT  with (nolock)
		where FEE_COLLECT_HD_ID in (select * from get_all_hd_id(@HD_ID)) and FEE_COLLECT_BR_ID in (select * from get_all_br_id(@BR_ID)) and DATEPART(MM, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(MM, @START_DATE) and DATEPART(YYYY, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(YYYY, @START_DATE) and FEE_COLLECT_PLAN_ID like @class_id_nvar

		--select @fees_total = SUM([Total Fee]) from (select FEE_COLLECT_FEE + FEE_COLLECT_ARREARS as [Total Fee] from FEE_COLLECT 
		--where FEE_COLLECT_HD_ID in (select * from get_all_hd_id(@HD_ID)) and FEE_COLLECT_BR_ID in (select * from get_all_br_id(@BR_ID)) and
		--FEE_COLLECT_FEE_STATUS not in ('Fully Transfered', 'Partially Transfered') and FEE_COLLECT_DATE_FEE_GENERATED between @START_DATE and @END_DATE and FEE_COLLECT_PLAN_ID like @class_id_nvar
		--union all 
		--select FEE_COLLECT_FEE_PAID + FEE_COLLECT_ARREARS_RECEIVED as [Total Fee] from FEE_COLLECT 
		--where FEE_COLLECT_HD_ID in (select * from get_all_hd_id(@HD_ID)) and FEE_COLLECT_BR_ID in (select * from get_all_br_id(@BR_ID)) and
		--FEE_COLLECT_FEE_STATUS  = 'Partially Transfered' and FEE_COLLECT_DATE_FEE_GENERATED between @START_DATE and @END_DATE and FEE_COLLECT_PLAN_ID like @class_id_nvar)A
		
		--select @fees_received = SUM([Received Fee]) from (select FEE_COLLECT_FEE_PAID + FEE_COLLECT_ARREARS_RECEIVED as [Received Fee] from FEE_COLLECT 
		--where FEE_COLLECT_HD_ID in (select * from get_all_hd_id(@HD_ID)) and FEE_COLLECT_BR_ID in (select * from get_all_br_id(@BR_ID)) and
		--FEE_COLLECT_FEE_STATUS not in ('Fully Transfered', 'Partially Transfered') and FEE_COLLECT_DATE_FEE_RECEIVED between @START_DATE and @END_DATE and FEE_COLLECT_PLAN_ID like @class_id_nvar
		--union all 
		--select FEE_COLLECT_FEE_PAID + FEE_COLLECT_ARREARS_RECEIVED as [Received Fee] from FEE_COLLECT 
		--where FEE_COLLECT_HD_ID in (select * from get_all_hd_id(@HD_ID)) and FEE_COLLECT_BR_ID in (select * from get_all_br_id(@BR_ID)) and
		--FEE_COLLECT_FEE_STATUS  = 'Partially Transfered' and FEE_COLLECT_DATE_FEE_RECEIVED between @START_DATE and @END_DATE and FEE_COLLECT_PLAN_ID like @class_id_nvar)A
		
		set @fees_total = ISNULL(@fees_total,0)
		set @fees_receivable = ISNULL(@fees_receivable,0)
		set @fees_received = ISNULL(@fees_received,0)
		
		set @fees_receivable = @fees_total - @fees_received
		
		select @fees_total, @fees_receivable, @fees_received
		
		select Width, Height from VCHART_SETTING where Name = 'Fees Guage' and [Login ID] = @PK_ID and [Status] = 'T'
		
	END
	ELSE if @STATUS = 'Staff and Salary'
		BEGIN

		declare @active_staff int = 0
		declare @inactive_staff int = 0
		declare @payable_staff int = 0
		declare @paid_staff int = 0

		set @active_staff = (select COUNT(*) from TEACHER_INFO where TECH_DEPARTMENT like @dept_like and TECH_DESIGNATION like @desg_like and TECH_STATUS = 'T' 
		and TECH_HD_ID in (select * from get_all_hd_id(@HD_ID)) and TECH_BR_ID in (select * from get_centralized_br_id('S',@BR_ID)))

		set @inactive_staff = (select COUNT(*) from TEACHER_INFO where TECH_DEPARTMENT like @dept_like and TECH_DESIGNATION like @desg_like and TECH_STATUS = 'F'
		and TECH_HD_ID in (select * from get_all_hd_id(@HD_ID)) and TECH_BR_ID in (select * from get_centralized_br_id('S',@BR_ID)))

		set @payable_staff = (select COUNT(*) from STAFF_SALLERY s join TEACHER_INFO t on t.TECH_ID = s.STAFF_SALLERY_STAFF_ID 
		where STAFF_SALLERY_RECEIVED_DATE between @START_DATE and @END_DATE and TECH_DEPARTMENT like @dept_like and TECH_DESIGNATION like @desg_like
		and TECH_HD_ID in (select * from get_all_hd_id(@HD_ID)) and TECH_BR_ID in (select * from get_centralized_br_id('S',@BR_ID)) and
		STAFF_SALLERY_NET_STATUS = 'Partially Paid' or STAFF_SALLERY_NET_STATUS = 'Payable'  )


		
		set @paid_staff = (select COUNT(*) from STAFF_SALLERY s join TEACHER_INFO t on t.TECH_ID = s.STAFF_SALLERY_STAFF_ID 
		where STAFF_SALLERY_RECEIVED_DATE between @START_DATE and @END_DATE and TECH_DEPARTMENT like @dept_like and TECH_DESIGNATION like @desg_like
		and TECH_HD_ID in (select * from get_all_hd_id(@HD_ID)) and TECH_BR_ID in (select * from get_centralized_br_id('S',@BR_ID)) and
		STAFF_SALLERY_NET_STATUS = 'Fully Paid' )

		 select @active_staff Active, @inactive_staff Inactive, @payable_staff Payable, @paid_staff Paid


		 END
	ELSE iF @STATUS = 'Student and Fees'
	
		BEGIN

		declare @active_student int = 0
		declare @inactive_student int = 0
		declare @receivable_student int = 0
		declare @received_student int = 0

		set @active_student = (select COUNT(*) from STUDENT_INFO where STDNT_CLASS_PLANE_ID like @class_id_nvar and STDNT_STATUS = 'T'
		and STDNT_HD_ID in (select * from get_all_hd_id(@HD_ID)) and STDNT_BR_ID in (select * from get_all_br_id(@BR_ID)))

		set @inactive_student = (select COUNT(*) from STUDENT_INFO where STDNT_CLASS_PLANE_ID like @class_id_nvar and STDNT_STATUS = 'F'
		and STDNT_HD_ID in (select * from get_all_hd_id(@HD_ID)) and STDNT_BR_ID in (select * from get_all_br_id(@BR_ID)))

		set @receivable_student = (select COUNT(*) from FEE_COLLECT f with (nolock) join STUDENT_INFO s on s.STDNT_ID = f.FEE_COLLECT_STD_ID
		where DATEPART(MM, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(MM, @START_DATE) and DATEPART(YYYY, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(YYYY, @START_DATE) and f.FEE_COLLECT_PLAN_ID like @class_id_nvar
		and STDNT_HD_ID in (select * from get_all_hd_id(@HD_ID)) and STDNT_BR_ID in (select * from get_all_br_id(@BR_ID)) and
		FEE_COLLECT_FEE_STATUS in('Partially Received' , 'Receivable','Partially Received'  ))


		set @received_student = (select COUNT(*) from FEE_COLLECT f with (nolock) join STUDENT_INFO s on s.STDNT_ID = f.FEE_COLLECT_STD_ID
		where DATEPART(MM, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(MM, @START_DATE)  and DATEPART(YYYY, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(YYYY, @START_DATE) and f.FEE_COLLECT_PLAN_ID like @class_id_nvar
		and STDNT_HD_ID in (select * from get_all_hd_id(@HD_ID)) and STDNT_BR_ID in (select * from get_all_br_id(@BR_ID)) and
		FEE_COLLECT_FEE_STATUS in ('Fully Received','Fully Received'))
		
		

		 select @active_student Active, @inactive_student Inactive, @receivable_student Receivable, @received_student Received


		 END

	else if @STATUS = 'Salary Guage'
	BEGIN

		

		declare @salary_total numeric = 0
		declare @salary_payable numeric = 0
		declare @salary_paid numeric = 0
		
		select @salary_total = SUM(STAFF_SALLERY_NET_TOLTAL) from STAFF_SALLERY s join TEACHER_INFO t on t.TECH_ID = s.STAFF_SALLERY_STAFF_ID
		where t.TECH_DEPARTMENT like @dept_like and t.TECH_DESIGNATION like @desg_like and  STAFF_SALLERY_HD_ID in (select * from get_all_hd_id(@HD_ID)) 
		and STAFF_SALLERY_BR_ID in (select * from get_centralized_br_id('S',@BR_ID)) and STAFF_SALLERY_DATE between @START_DATE and @END_DATE
		 
		
		select @salary_paid = SUM(STAFF_SALLERY_NET_RECEIVED) from STAFF_SALLERY s join TEACHER_INFO t on t.TECH_ID = s.STAFF_SALLERY_STAFF_ID
		where t.TECH_DEPARTMENT like @dept_like and t.TECH_DESIGNATION like @desg_like and STAFF_SALLERY_HD_ID in (select * from get_all_hd_id(@HD_ID)) 
		and STAFF_SALLERY_BR_ID in (select * from get_centralized_br_id('S',@BR_ID)) and STAFF_SALLERY_RECEIVED_DATE between @START_DATE and @END_DATE
		
		set @salary_total = ISNULL(@salary_total,0)
		set @salary_payable = ISNULL(@salary_payable,0)
		set @salary_paid = ISNULL(@salary_paid,0)
		
		set @salary_payable = @salary_total - @salary_paid
		
		 
			select @salary_total, @salary_payable, @salary_paid
			select Width, Height from VCHART_SETTING where Name = 'Salary Guage' and [Login ID] = @PK_ID and [Status] = 'T'
		
		 

		END

		else if @STATUS = 'Staff Current Status'
		BEGIN
			
			declare @table_In table (Code nvarchar(50), Name nvarchar(200), Status nvarchar(5), [Last Punch] time)

			select [Code], Name, [Status],CAST(a.[Time] as time) [Last Punch] from
			(select  t.TECH_EMPLOYEE_CODE [Code], (t.TECH_FIRST_NAME + ' ' + t.TECH_LAST_NAME) as Name, CONVERT(VARCHAR(15),a.ATTENDANCE_STAFF_DATE,106) [Date], a.ATTENDANCE_STAFF_DATE date_order, a.ATTENDANCE_STAFF_TIME_IN [Time], 'IN' [Status] from ATTENDANCE_STAFF 
			a join TEACHER_INFO t on t.TECH_ID = a.ATTENDANCE_STAFF_TYPE_ID
			where t.TECH_DEPARTMENT like @dept_like and t.TECH_DESIGNATION like @desg_like and  t.TECH_HD_ID in (select * from get_all_hd_id(@HD_ID)) 
			and t.TECH_BR_ID in (select * from get_centralized_br_id('S',@BR_ID)) and a.ATTENDANCE_STAFF_DATE between @START_DATE and @END_DATE and ATTENDANCE_STAFF_REMARKS in ('P', 'LA')
			union all
			select t.TECH_EMPLOYEE_CODE [Code], (t.TECH_FIRST_NAME + ' ' + t.TECH_LAST_NAME) as Name, CONVERT(VARCHAR(15),a.ATTENDANCE_STAFF_DATE,106) [Date], a.ATTENDANCE_STAFF_DATE date_order, a.ATTENDANCE_STAFF_TIME_OUT [Time], 'Out' [Status] from ATTENDANCE_STAFF 
			a join TEACHER_INFO t on t.TECH_ID = a.ATTENDANCE_STAFF_TYPE_ID
			where a.ATTENDANCE_STAFF_TIME_OUT != '12:00:00 AM' and   t.TECH_DEPARTMENT like @dept_like and t.TECH_DESIGNATION like @desg_like and  t.TECH_HD_ID in (select * from get_all_hd_id(@HD_ID)) 
			and t.TECH_BR_ID in (select * from get_centralized_br_id('S',@BR_ID)) and a.ATTENDANCE_STAFF_DATE between @START_DATE and @END_DATE and  ATTENDANCE_STAFF_REMARKS in ('P', 'LA')
			)A order by a.date_order DESC, CAST(a.[Time] as time) DESC


			insert into @table_In
			Select * from
			(select [Code], MAX(Name) Name, MAX([Status])[Status], MAX(CAST(a.[Time] as time)) [Last Punch] from
			(select  t.TECH_EMPLOYEE_CODE [Code], (t.TECH_FIRST_NAME + ' ' + t.TECH_LAST_NAME) as Name, CONVERT(VARCHAR(15),a.ATTENDANCE_STAFF_DATE,106) [Date], a.ATTENDANCE_STAFF_DATE date_order, a.ATTENDANCE_STAFF_TIME_IN [Time], 'IN' [Status] from ATTENDANCE_STAFF 
			a join TEACHER_INFO t on t.TECH_ID = a.ATTENDANCE_STAFF_TYPE_ID
			where t.TECH_DEPARTMENT like @dept_like and t.TECH_DESIGNATION like @desg_like and  t.TECH_HD_ID in (select * from get_all_hd_id(@HD_ID)) 
			and t.TECH_BR_ID in (select * from get_centralized_br_id('S',@BR_ID)) and a.ATTENDANCE_STAFF_DATE between @START_DATE and @END_DATE and a.ATTENDANCE_STAFF_TIME_OUT = '12:00:00 AM' and a.ATTENDANCE_STAFF_TIME_IN != '12:00:00 AM' and ATTENDANCE_STAFF_REMARKS in ('P', 'LA')
			)A group by Code)B order by [Last Punch] DESC

			select * from @table_In


			Select * from
			(select [Code], MAX(Name) Name, MAX([Status])[Status], MAX(CAST(a.[Time] as time)) [Last Punch] from
			(select t.TECH_EMPLOYEE_CODE [Code], (t.TECH_FIRST_NAME + ' ' + t.TECH_LAST_NAME) as Name, CONVERT(VARCHAR(15),a.ATTENDANCE_STAFF_DATE,106) [Date], a.ATTENDANCE_STAFF_DATE date_order, a.ATTENDANCE_STAFF_TIME_OUT [Time], 'Out' [Status] from ATTENDANCE_STAFF 
			a join TEACHER_INFO t on t.TECH_ID = a.ATTENDANCE_STAFF_TYPE_ID
			where t.TECH_DEPARTMENT like @dept_like and t.TECH_DESIGNATION like @desg_like and  t.TECH_HD_ID in (select * from get_all_hd_id(@HD_ID)) 
			and t.TECH_BR_ID in (select * from get_centralized_br_id('S',@BR_ID)) and a.ATTENDANCE_STAFF_DATE between @START_DATE and @END_DATE and  a.ATTENDANCE_STAFF_ID not in (select b.ATTENDANCE_STAFF_ID from ATTENDANCE_STAFF b where b.ATTENDANCE_STAFF_TIME_OUT = '12:00:00 AM' and b.ATTENDANCE_STAFF_TIME_IN != '12:00:00 AM' ) and ATTENDANCE_STAFF_REMARKS in ('P', 'LA')
			)A group by Code)B where B.Code not in (select ti.Code from @table_In ti) order by [Last Punch] DESC
			--)B where cnt != 1

			--In mixing In and Out
			--select [Code], Name, [Status],[Time] [Last Punch] from
			--(select  t.TECH_EMPLOYEE_CODE [Code], (t.TECH_FIRST_NAME + ' ' + t.TECH_LAST_NAME) as Name, CONVERT(VARCHAR(15),a.ATTENDANCE_STAFF_DATE,106) [Date], a.ATTENDANCE_STAFF_DATE date_order, a.ATTENDANCE_STAFF_TIME_IN [Time], 'IN' [Status] from ATTENDANCE_STAFF 
			--a join TEACHER_INFO t on t.TECH_ID = a.ATTENDANCE_STAFF_TYPE_ID
			--where t.TECH_DEPARTMENT like @dept_like and t.TECH_DESIGNATION like @desg_like and  t.TECH_HD_ID in (select * from get_all_hd_id(@HD_ID)) 
			--and t.TECH_BR_ID in (select * from get_centralized_br_id('S',@BR_ID)) and a.ATTENDANCE_STAFF_DATE between @START_DATE and @END_DATE and a.ATTENDANCE_STAFF_TIME_OUT = '12:00:00 AM' and a.ATTENDANCE_STAFF_TIME_IN != '12:00:00 AM' and ATTENDANCE_STAFF_REMARKS in ('P', 'LA')
			--union all
			--select t.TECH_EMPLOYEE_CODE [Code], (t.TECH_FIRST_NAME + ' ' + t.TECH_LAST_NAME) as Name, CONVERT(VARCHAR(15),a.ATTENDANCE_STAFF_DATE,106) [Date], a.ATTENDANCE_STAFF_DATE date_order, a.ATTENDANCE_STAFF_TIME_OUT [Time], 'Out' [Status] from ATTENDANCE_STAFF 
			--a join TEACHER_INFO t on t.TECH_ID = a.ATTENDANCE_STAFF_TYPE_ID
			--where t.TECH_DEPARTMENT like @dept_like and t.TECH_DESIGNATION like @desg_like and  t.TECH_HD_ID in (select * from get_all_hd_id(@HD_ID)) 
			--and t.TECH_BR_ID in (select * from get_centralized_br_id('S',@BR_ID)) and a.ATTENDANCE_STAFF_DATE between @START_DATE and @END_DATE and  a.ATTENDANCE_STAFF_ID not in (select b.ATTENDANCE_STAFF_ID from ATTENDANCE_STAFF b where b.ATTENDANCE_STAFF_TIME_OUT = '12:00:00 AM' and b.ATTENDANCE_STAFF_TIME_IN != '12:00:00 AM' ) and ATTENDANCE_STAFF_REMARKS in ('P', 'LA')
			--)A order by a.date_order DESC, CAST(a.[Time] as time) DESC

			--select [Code], Name, [Status],[Time] [Last Punch] from
			--(select  t.TECH_EMPLOYEE_CODE [Code], (t.TECH_FIRST_NAME + ' ' + t.TECH_LAST_NAME) as Name, CONVERT(VARCHAR(15),a.ATTENDANCE_STAFF_DATE,106) [Date], a.ATTENDANCE_STAFF_DATE date_order, a.ATTENDANCE_STAFF_TIME_IN [Time], 'IN' [Status] from ATTENDANCE_STAFF 
			--a join TEACHER_INFO t on t.TECH_ID = a.ATTENDANCE_STAFF_TYPE_ID
			--where t.TECH_DEPARTMENT like @dept_like and t.TECH_DESIGNATION like @desg_like and  t.TECH_HD_ID in (select * from get_all_hd_id(@HD_ID)) 
			--and t.TECH_BR_ID in (select * from get_centralized_br_id('S',@BR_ID)) and a.ATTENDANCE_STAFF_DATE between @START_DATE and @END_DATE and a.ATTENDANCE_STAFF_TIME_OUT = '12:00:00 AM' and a.ATTENDANCE_STAFF_TIME_IN != '12:00:00 AM' and ATTENDANCE_STAFF_REMARKS in ('P', 'LA')
			--)A order by a.date_order DESC, CAST(a.[Time] as time) DESC


			--select [Code], Name, [Status],[Time] [Last Punch] from
			--(select t.TECH_EMPLOYEE_CODE [Code], (t.TECH_FIRST_NAME + ' ' + t.TECH_LAST_NAME) as Name, CONVERT(VARCHAR(15),a.ATTENDANCE_STAFF_DATE,106) [Date], a.ATTENDANCE_STAFF_DATE date_order, a.ATTENDANCE_STAFF_TIME_OUT [Time], 'Out' [Status] from ATTENDANCE_STAFF 
			--a join TEACHER_INFO t on t.TECH_ID = a.ATTENDANCE_STAFF_TYPE_ID
			--where t.TECH_DEPARTMENT like @dept_like and t.TECH_DESIGNATION like @desg_like and  t.TECH_HD_ID in (select * from get_all_hd_id(@HD_ID)) 
			--and t.TECH_BR_ID in (select * from get_centralized_br_id('S',@BR_ID)) and a.ATTENDANCE_STAFF_DATE between @START_DATE and @END_DATE and  a.ATTENDANCE_STAFF_ID not in (select b.ATTENDANCE_STAFF_ID from ATTENDANCE_STAFF b where b.ATTENDANCE_STAFF_TIME_OUT = '12:00:00 AM' and b.ATTENDANCE_STAFF_TIME_IN != '12:00:00 AM' ) and ATTENDANCE_STAFF_REMARKS in ('P', 'LA')
			--)A order by a.date_order DESC, CAST(a.[Time] as time) DESC
			----)B where cnt != 1

		END

END