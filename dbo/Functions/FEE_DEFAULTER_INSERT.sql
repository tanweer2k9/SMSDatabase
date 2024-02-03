CREATE FUNCTION [dbo].[FEE_DEFAULTER_INSERT] (@invoice_id int,@fee_def_id int,@fee_amount float,@status char(1))
returns @t_defaulter table (hd_id int, br_id int,std_id int, std_name nvarchar(100), class_plan nvarchar(100), month_name nvarchar(100), month_int int, fees float)

as begin

--declare @invoice_id int = 4336
--declare @fee_def_id int = 0
--declare @fee_amount int = 0
--declare @status char(1) = 'I'


--declare @t_defaulter table (hd_id int, br_id int,std_id int, std_name nvarchar(100), class_plan nvarchar(100), month_name nvarchar(100), month_int int, fees int)


declare @std_id int = 0 
declare @std_name nvarchar(100) = ''
declare @class_plan_id int = ''
declare @class_plan nvarchar(100) = ''
declare @hd_id int = 0
declare @br_id int = 0
declare @month_name nvarchar(100) = ''
declare @month_int int = 0
declare @arrears float = 0
declare @arrears_received float = 0
declare @current_fee float = 0
declare @current_fee_received float = 0
declare @from_date date = ''
declare @to_date date = ''

--declare @invoice_id_prev int = 0
declare @def_ids_count int = 0
declare @def_fee_name nvarchar(100) = ''
declare @def_fee float = ''
declare @def_fee_received float = ''
declare @j int = 0


select @arrears = FEE_COLLECT_ARREARS, @arrears_received = FEE_COLLECT_ARREARS_RECEIVED, @from_date = FEE_COLLECT_FEE_FROM_DATE, 
	@to_date = FEE_COLLECT_FEE_TO_DATE, @std_id = FEE_COLLECT_STD_ID,@current_fee = FEE_COLLECT_FEE, 
	@current_fee_received = FEE_COLLECT_FEE_PAID from FEE_COLLECT where FEE_COLLECT_ID = @invoice_id
	
	select @std_name = STDNT_FIRST_NAME, @class_plan_id = STDNT_CLASS_PLANE_ID, @hd_id = STDNT_HD_ID, @br_id = STDNT_BR_ID from STUDENT_INFO where STDNT_ID = @std_id
	
	select @class_plan = CLASS_Name from SCHOOL_PLANE where CLASS_ID = @class_plan_id
	
	select @month_name = month_name, @month_int = month_int from dbo.[get_month_name_and_int](@from_date, @to_date)


		
if @status = 'I' -- Invoice

begin
				declare @discount float = 0
				set @discount = (select SUM(FEE_COLLECT_DEF_FEE) from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @invoice_id and FEE_COLLECT_DEF_OPERATION = '-')
				if @discount > 0
					begin
						insert into @t_defaulter values (@hd_id, @br_id,@std_id, @std_name,  @class_plan,@month_name + '*Discount' , @month_int, -@discount)
					end
			set @def_ids_count = (select COUNT(*) from FEE_COLLECT_DEF where FEE_COLLECT_DEF_FEE > 0 and FEE_COLLECT_DEF_PID = @invoice_id and FEE_COLLECT_DEF_OPERATION = '+')
			set @j = 1
			set @def_fee_name = ''
			insert into @t_defaulter values (@hd_id, @br_id,@std_id, @std_name,  @class_plan,@month_name, @month_int, -1)
			while @j <= @def_ids_count
			begin
				select @def_fee_name = (select FEE_NAME from FEE_INFO where FEE_ID = FEE_COLLECT_DEF_FEE_NAME), @def_fee = FEE_COLLECT_DEF_FEE,
				@def_fee_received = FEE_COLLECT_DEF_FEE_PAID from (select ROW_NUMBER() over (order by (select 0)) as sr1, 
				FEE_COLLECT_DEF_FEE_NAME, FEE_COLLECT_DEF_FEE, FEE_COLLECT_DEF_FEE_PAID from FEE_COLLECT_DEF where FEE_COLLECT_DEF_FEE > 0 and 
				FEE_COLLECT_DEF_PID = @invoice_id and FEE_COLLECT_DEF_OPERATION = '+')A where sr1 = @j
				if  @def_fee - @def_fee_received > 0
				insert into @t_defaulter values (@hd_id, @br_id,@std_id, @std_name,  @class_plan,@month_name + '*' + @def_fee_name  , @month_int, @def_fee - @def_fee_received)
				set @j = @j + 1
			end
			
			
			
end

else if @status = 'D'-- Fee definition
begin
	insert into @t_defaulter values (@hd_id, @br_id,@std_id, @std_name,  @class_plan,@month_name, @month_int, -1)
	set  @def_fee_name = (select FEE_NAME from FEE_INFO where FEE_ID = @fee_def_id)
	insert into @t_defaulter values (@hd_id, @br_id,@std_id, @std_name, @class_plan,@month_name + '*' + @def_fee_name  , @month_int, @fee_amount)
end
--select * from @t_defaulter

return
end