CREATE FUNCTION [dbo].[ADVANCE_FEE_FORECAST] (@ADV_FEE_STD_ID numeric, @ADV_FEE_FROM_DATE date,  @ADV_FEE_TO_DATE date )
returns @t table (ID int identity(1,1), [From Date] date, [To Date] date, Amount float, [Adjust Date] date, Adjust char(2))

AS BEGIN

--declare @ADV_FEE_STD_ID numeric = 16
--declare @ADV_FEE_FROM_DATE date = '2014-02-01'
--declare @ADV_FEE_TO_DATE date = '2014-07-01'
--declare @t table (ID int identity(1,1), [From Date] date, [To Date] date, Amount float, [Adjust Date] date, Adjust char(2))

declare @fee_id_count int = 0
declare @i int = 1
declare @j int = 1
declare @br_id int = 0
declare @hd_id int = 0
declare @fee_id int = 0
declare @plan_fee_id int = 0
declare @total_fee float = 0
declare @def_fee float = 0
declare @fee_operation nvarchar(50) = ''
declare @fee_months nvarchar(200) =''
declare @count int = 1
Declare @month int	= 0
declare @fee_type nvarchar(50) = ''
declare @mounth_diff2 int = 0
declare @count_differ_month int = 1
declare @crrnt_month int = 0
declare @once_fee_count int = 0


declare @first_day_of_month date = ''
declare @last_day_of_month date = ''

set @crrnt_month = DATEPART(MM, @ADV_FEE_FROM_DATE)
set @mounth_diff2 = DATEDIFF(MM,@ADV_FEE_FROM_DATE, @ADV_FEE_TO_DATE) + 1


select @br_id = STDNT_BR_ID, @hd_id = STDNT_HD_ID, @plan_fee_id = STDNT_CLASS_FEE_ID from STUDENT_INFO where STDNT_ID = @ADV_FEE_STD_ID


set @fee_id_count = (select COUNT(*) from FEE_INFO where FEE_HD_ID = @hd_id and FEE_BR_ID = @br_id  and FEE_STATUS = 'T')


while @j <= @mounth_diff2
begin
	
	set @i = 1
	while @i <= @fee_id_count 
	begin
		
		select @fee_type = FEE_TYPE, @fee_months = FEE_MONTHS, @fee_operation = FEE_OPERATION, @fee_id = FEE_ID from (select ROW_NUMBER() over (order by (select 0)) as sr, * from FEE_INFO where FEE_HD_ID = @hd_id and FEE_BR_ID = @br_id  and FEE_STATUS = 'T')A where sr = @i
		
		set @def_fee = (select PLAN_FEE_DEF_FEE from PLAN_FEE_DEF where PLAN_FEE_DEF_PLAN_ID = @plan_fee_id and PLAN_FEE_DEF_FEE_NAME = @fee_id and PLAN_FEE_DEF_STATUS = 'T')
		set @def_fee = iSNULL(@def_fee,0)
		
		if @fee_type != 'Monthly'
				begin
						set @once_fee_count = 0
						if @fee_type = 'Once'
						begin							
							set @once_fee_count = (select COUNT(*) from FEE_COLLECT_DEF where FEE_COLLECT_DEF_FEE > 0 and FEE_COLLECT_DEF_FEE_NAME = @fee_id and FEE_COLLECT_DEF_PID in (select FEE_COLLECT_ID from FEE_COLLECT where FEE_COLLECT_STD_ID = @ADV_FEE_STD_ID))								
						end
							if @once_fee_count = 0
							begin
								set @count = 1
								while @count < (select LEN(@fee_months))
									begin
										set @month = ( select convert(int, (select SUBSTRING(@fee_months,@count,2)) ) )
										if @crrnt_month = @month
											begin				
												set @total_fee = @total_fee + @def_fee
											end
									set @count = @count + 3
									end
							end					
				end -- end != monthly loop
				
				else
				begin
					set @total_fee = @total_fee + @def_fee
				end
		
		set @i = @i + 1
	end -- @i loop end
	set @crrnt_month = @crrnt_month + 1
	set @j = @j + 1
	set @first_day_of_month = DATEADD(month, DATEDIFF(month, 0, DATEADD(MM, @j - 2, @ADV_FEE_FROM_DATE)),0)
	set @last_day_of_month = dateadd(month,1+datediff(month,0,DATEADD(MM, @j -2, @ADV_FEE_FROM_DATE)),-1)
	insert into @t values(@first_day_of_month, @last_day_of_month, @total_fee, @first_day_of_month, 'F')
	set @total_fee = 0
end --j loop end

--select * from @t

return
END