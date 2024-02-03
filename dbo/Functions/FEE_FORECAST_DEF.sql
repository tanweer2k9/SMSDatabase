CREATE FUNCTION [dbo].[FEE_FORECAST_DEF] (@fee_name nvarchar(100),  @hd_id  int, @br_id int, @start_date date, @end_date date, @status char(1))
returns @tbl table (fee_name nvarchar(100), fee float, total_students int)

AS BEGIN


	--declare @fee_name nvarchar(100) = 'Discount'
	--declare @hd_id int = 0
	--declare @br_id int = 0
	--declare @start_date date = '2013-10-01'
	--declare @end_date date = '2013-10-30'
	--declare @status char(1) = 'F'
	--declare @tbl table (fee_name nvarchar(100), fee float, total_stds int)




declare @hd_id_txt nvarchar(50) = '%'
declare @br_id_txt nvarchar(50) = '%'

if @hd_id != 0
begin	
	set @hd_id_txt = CAST((@hd_id)as nvarchar(50))
end

if @br_id != 0
begin	
	set @br_id_txt = CAST((@br_id)as nvarchar(50))
end

declare @fee_forecast float = 0
declare @fee_generated_current float = 0
declare @fee_generated_current_received float = 0
declare @fee_generated_arrears float = 0
declare @fee_generated_arrears_received float = 0

declare @total_students int = 0
declare @fee_operation nvarchar(50) = ''

set @status = 'F'

if @status = 'F'
begin

		declare @crrnt_month int
		declare @mounth_diff2 int
		
		Declare @def_info_id numeric
		Declare @fee_type nvarchar(10)
		Declare @fee_months nvarchar(50)
		Declare @count int = 1
		Declare @month int	
		declare @count_differ_month int = 1
		declare @def_fee float = 0
		declare @hd_count int = 1
		declare @br_count int = 1
		declare @i int = 0
		declare @j int = 0
		declare @br_id_zero char(1) = 'F'
		declare @hd_id_zero char(1) = 'F'
		
		set @mounth_diff2 = DATEDIFF(MM, @start_date, @end_date) + 1
		set @crrnt_month = DATEPART(MM, @end_date)
		
		if @hd_id = 0
		begin	
			set @hd_count = (select COUNT(*) from MAIN_HD_INFO where MAIN_INFO_STATUS = 'T')
			set @hd_id_zero  = 'T'
		end
		
		if @br_id = 0
		begin	
			set @br_count = (select COUNT(*) from BR_ADMIN where BR_ADM_STATUS = 'T')
			set @br_id_zero  = 'T'
		end
	
		set @i = 1
		while @i <= @hd_count
		begin
			if  @hd_id_zero = 'T'
			begin
				select @hd_id = MAIN_INFO_ID from (select ROW_NUMBER() over (order by MAIN_INFO_ID) as sr_hd, MAIN_INFO_ID from MAIN_HD_INFO)A where sr_hd = @i
			end
			set @j = 1
			while @j <= @br_count
			begin
				if @br_id_zero = 'T'
				begin
					select @br_id = BR_ADM_ID from (select ROW_NUMBER() over (order by(select BR_ADM_ID)) as sr_br, BR_ADM_ID from BR_ADMIN)B where sr_br = @j
				end
				
				declare @count_fee_generaetd int = 0
				set @count_fee_generaetd = (select count(*) from FEE_COLLECT_DEF where FEE_COLLECT_DEF_FEE_NAME in (select FEE_ID from FEE_INFO where FEE_NAME = @fee_name 
				and FEE_HD_ID = @hd_id and FEE_BR_ID = @br_id) and FEE_COLLECT_DEF_PID in 
				(select FEE_COLLECT_ID from FEE_COLLECT where DATEPART(MM, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(MM, @start_date) and 
				DATEPART(YYYY, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(YYYY, @start_date) and FEE_COLLECT_HD_ID = @hd_id and 
				FEE_COLLECT_BR_ID = @br_id))
				
				if @count_fee_generaetd != 0
				begin
					select @fee_generated_current += SUM(FEE_COLLECT_DEF_FEE), @fee_generated_current_received += SUM(FEE_COLLECT_DEF_FEE_PAID),
					@fee_generated_arrears += SUM(FEE_COLLECT_DEF_ARREARS),@fee_generated_arrears_received += SUM(FEE_COLLECT_DEF_ARREARS_RECEIVED),
					@total_students += COUNT(*) from FEE_COLLECT_DEF where FEE_COLLECT_DEF_FEE_NAME in (select FEE_ID from FEE_INFO where FEE_NAME = @fee_name 
					and FEE_HD_ID = @hd_id and FEE_BR_ID = @br_id) and FEE_COLLECT_DEF_PID in 
					(select FEE_COLLECT_ID from FEE_COLLECT where DATEPART(MM, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(MM, @start_date) and 
					DATEPART(YYYY, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(YYYY, @start_date) and FEE_COLLECT_HD_ID = @hd_id and 
					FEE_COLLECT_BR_ID = @br_id)
				end
				
				else
				begin				
					select @def_info_id = FEE_ID, @fee_type = FEE_TYPE, @fee_months = FEE_MONTHS from FEE_INFO where FEE_NAME = @fee_name and FEE_HD_ID = @hd_id and FEE_BR_ID = @br_id		
					select @def_fee = SUM(PLAN_FEE_DEF_FEE) from (select * from PLAN_FEE_DEF where PLAN_FEE_DEF_FEE_NAME = @def_info_id and PLAN_FEE_DEF_PLAN_ID in 
					(select PLAN_FEE_ID from PLAN_FEE where PLAN_FEE_HD_ID = @hd_id and PLAN_FEE_BR_ID = @br_id 
					and PLAN_FEE_ID in (select STDNT_CLASS_FEE_ID from STUDENT_INFO where STDNT_HD_ID = @hd_id and STDNT_BR_ID = @br_id and 
					STDNT_STATUS = 'T')) and PLAN_FEE_DEF_STATUS = 'T')A
					set @total_students += (select COUNT(*) from STUDENT_INFO where STDNT_STATUS = 'T' and STDNT_HD_ID = @hd_id and 
											STDNT_BR_ID = @br_id )
					
					set @def_info_id = ISNULL(@def_info_id,0)
					if @fee_type != 'Monthly' and @def_info_id != 0
						begin
								while @count < (select LEN(@fee_months))
									begin
									
									set @month = ( select convert(int, (select SUBSTRING(@fee_months,@count,2)) ) )
									set @count_differ_month = 1
											while @count_differ_month <= @mounth_diff2
												begin
													if @crrnt_month - @mounth_diff2 + @count_differ_month = @month
														begin	
															set @fee_forecast = @fee_forecast + @def_fee
														end --current month
													set @count_differ_month = @count_differ_month + 1										
												end -- while loop count differ month
									set @count = @count + 3
									end --while loop count fee months length
						end -- end != monthly if statement					
						else
						begin
							set @fee_forecast = @fee_forecast + @def_fee * @mounth_diff2						
						end						
							set @fee_forecast = (select isnull(@fee_forecast,0))				
				end --count fee generate else of count fee generated
				set @j=@j +1
			end -- while loop br id
			set @i = @i + 1
		end -- while loop hd id
end -- if status
				

--select @fee_forecast

else if @status = 'G'
begin

	select @fee_generated_current = SUM(FEE_COLLECT_DEF_FEE), @fee_generated_current_received = SUM(FEE_COLLECT_DEF_FEE_PAID),
	@fee_generated_arrears = SUM(FEE_COLLECT_DEF_ARREARS),@fee_generated_arrears_received = SUM(FEE_COLLECT_DEF_ARREARS_RECEIVED)
	from FEE_COLLECT_DEF where FEE_COLLECT_DEF_FEE_NAME in (select FEE_ID from FEE_INFO where FEE_NAME = @fee_name 
	and FEE_HD_ID like @hd_id_txt and FEE_BR_ID like @br_id_txt) and FEE_COLLECT_DEF_PID in 
	(select FEE_COLLECT_ID from FEE_COLLECT where DATEPART(MM, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(MM, @start_date) and 
	DATEPART(YYYY, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(YYYY, @start_date) and FEE_COLLECT_HD_ID like @hd_id_txt and 
	FEE_COLLECT_BR_ID like @br_id_txt)
end				

set @fee_operation = (select top(1) FEE_COLLECT_DEF_OPERATION from FEE_COLLECT_DEF where FEE_COLLECT_DEF_FEE_NAME in (select FEE_ID from FEE_INFO where FEE_NAME = @fee_name and FEE_BR_ID like @br_id_txt and FEE_HD_ID like @hd_id_txt))

if @fee_operation = '-' and @fee_forecast != 0
begin
	set @fee_forecast = -@fee_forecast
end

if @fee_operation = '-' and @fee_generated_current != 0
begin
	set @fee_generated_current = -@fee_generated_current
end


if @fee_operation = '-' and @fee_generated_current_received != 0
begin
	set @fee_generated_current_received = -@fee_generated_current_received
end

if @fee_operation = '-' and @fee_generated_arrears != 0
begin
	set @fee_generated_arrears = -@fee_generated_arrears
end

if @fee_operation = '-' and @fee_generated_arrears_received != 0
begin
	set @fee_generated_arrears_received = -@fee_generated_arrears_received
end

insert into @tbl values(@fee_name + '*Forecast', @fee_forecast, @total_students)
insert into @tbl values(@fee_name + '*Generate*' + 'Current', @fee_generated_current, @total_students)
insert into @tbl values(@fee_name + '*Generate*' + 'Current Received', @fee_generated_current_received, @total_students)
insert into @tbl values(@fee_name + '*Generate*' + 'Arrears', @fee_generated_arrears, @total_students)
insert into @tbl values(@fee_name + '*Generate*' + 'Arrears Received', @fee_generated_arrears_received, @total_students)

--select * from @tbl

return				
END