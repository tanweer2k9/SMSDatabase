CREATE PROC [dbo].[sp_CHARTS_STUDENTS]
	@STATUS char(2),
	@LOGIN_ID numeric,
	@STUDENT_ID numeric,
	@START_DATE date,
	@END_DATE date
	


AS

--declare @STATUS char(2) = 'F'
--declare @LOGIN_ID numeric = 1068
--declare @STUDENT_ID numeric = 0
--declare @START_DATE date = '01-01-0001'
--declare @END_DATE date = '01-01-0001'




declare @user_type nvarchar(50)= ''
declare @user_id int = 0
select @user_id = USER_CODE, @user_type = USER_TYPE from USER_INFO where USER_ID = @LOGIN_ID

if @END_DATE = '01-01-0001'
begin
	set @END_DATE = GETDATE()
end


if @user_type = 'Parent' 
begin
	if @STUDENT_ID = 0
	begin
		set @STUDENT_ID = (select top(1) STDNT_ID from STUDENT_INFO where STDNT_PARANT_ID = @user_id)
	end
end
else if @user_type = 'Student'
begin
	set @STUDENT_ID = @user_id
end


if @STATUS = 'A'
begin
	if @user_type = 'Parent' or @user_type = 'Student'
	begin
	declare @present int = 0
	declare @absent int = 0
	declare @leave int = 0
	declare @late int = 0
	declare @total_days int = 0
	declare @study_days int = 0
	
		;with atendnce_student as
		(
			select s.STDNT_ID as ID, a.ATTENDANCE_DATE as [Date], a.ATTENDANCE_REMARKS as Remarks	
			from ATTENDANCE a 
			join STUDENT_INFO s on s.STDNT_ID = a.ATTENDANCE_TYPE_ID
			where a.ATTENDANCE_TYPE_ID = @STUDENT_ID and  a.ATTENDANCE_DATE between @START_DATE and @END_DATE 
		)
		, pivot_table as
		(
		select * from atendnce_student
		pivot 
		(MAX(Remarks) for [Remarks] in ([P], [A], [LE], [LA])) as final_tbl
		)

		, tbl_grp_by as
		(
		select DATEDIFF(DD, @START_DATE, @END_DATE) + 1 as [Total Days], COUNT(ID) as [Study Days],COUNT(P) as Present, COUNT(A) as Absent, COUNT(LE) as Leave, COUNT(LA) as Late
		 from pivot_table group by ID
		)
		select @present = Present, @absent = Absent, @leave = Leave, @late = Late, @total_days = [Total Days], @study_days = [Study Days] from tbl_grp_by
		
			select 'P' as Name, @present as [Count]
			union all
			select 'A' as Name, @absent as [Count]
			union all
			select 'LE' as Name, @leave as [Count]
			union all
			select 'LA' as Name, @late as [Count]
			
			select @total_days as [Total Days], @study_days as [Study Days]
			if @user_type = 'Parent'
			begin
				select STDNT_ID as ID, STDNT_FIRST_NAME as Name from STUDENT_INFO where STDNT_PARANT_ID = @user_id and STDNT_STATUS != 'D'
			end
		
	end
end


else if @STATUS = 'F'
begin
	declare @fee_received float
	declare @fee_total float
	declare @discount float

	select @fee_total = ISNULL(SUM(FEE_COLLECT_DEF_FEE),0), @fee_received =  ISNULL(SUM(FEE_COLLECT_DEF_ARREARS_RECEIVED + FEE_COLLECT_DEF_FEE_PAID),0) from FEE_COLLECT_DEF 
	where FEE_COLLECT_DEF_OPERATION = '+' and FEE_COLLECT_DEF_PID in (select FEE_COLLECT_ID from FEE_COLLECT where FEE_COLLECT_STD_ID = @STUDENT_ID)

	select @discount = ISNULL(SUM(FEE_COLLECT_DEF_FEE),0) from FEE_COLLECT_DEF 
	where FEE_COLLECT_DEF_OPERATION = '-' and FEE_COLLECT_DEF_PID in (select FEE_COLLECT_ID from FEE_COLLECT where FEE_COLLECT_STD_ID = @STUDENT_ID)

	--select 'Fee Received' as Name, @fee_received as [Count]
	--union all
	--select 'Fee Receivable' as Name, @fee_total - @fee_received - @discount as [Count]
	--union all
	--select 'Discount' as Name, @discount as [Count]
	select 'RD' as Name, @fee_received as [Count]
	union all
	select 'RL' as Name, @fee_total - @fee_received - @discount as [Count]
	union all
	select 'DIS' as Name, @discount as [Count]
	
	if @user_type = 'Parent'
			begin
				select STDNT_ID as ID, STDNT_FIRST_NAME as Name from STUDENT_INFO where STDNT_PARANT_ID = @user_id and STDNT_STATUS != 'D'
			end
end

else if @STATUS = 'C'
begin
	select term_name, [Class Name],Subject,Teacher, [Start Time], [End Time] from 
	(
	select p.CLASS_ID as [Class ID], p.CLASS_Name as [Class Name], pd.DEF_TERM as [Term ID],s.SUB_NAME as Subject, tr.TERM_NAME as term_name,
	pd.DEF_TEACHER as [Teacher ID],t.TECH_FIRST_NAME as Teacher, pd.DEF_START_TIME as [Start Time], pd.DEF_END_TIME as [End Time]

	from SCHOOL_PLANE p
	join SCHOOL_PLANE_DEFINITION pd on pd.DEF_CLASS_ID = p.CLASS_ID
	join SUBJECT_INFO s on s.SUB_ID = pd.DEF_SUBJECT
	join TEACHER_INFO t on t.TECH_ID = pd.DEF_TEACHER
	join TERM_INFO tr on tr.TERM_ID = pd.DEF_TERM
	where p.CLASS_ID = (select STDNT_CLASS_PLANE_ID from STUDENT_INFO where STDNT_ID = @STUDENT_ID and STDNT_STATUS != 'D')
	)A group by term_name, [Class ID],[Class Name],Subject,[Teacher ID],Teacher, [Start Time], [End Time]
	order by [Start Time]
end
else if @STATUS = 'S'
begin
	select * from SMS_SENT_HISTORY
end