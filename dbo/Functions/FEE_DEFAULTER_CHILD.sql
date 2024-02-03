CREATE function [dbo].[FEE_DEFAULTER_CHILD] (@std_id int)
returns @t_arrers table (invoice_id int, fee_def int ,fee_amount float)

AS
BEGIN

--declare @std_id int = 589
--declare @t_arrers table (invoice_id int, fee_def int ,fee_amount int)

declare @t table (fee_name int, arrears_received float)
declare @t_defaulter table ( hd_id int, br_id int,std_id int, std_name nvarchar(100), class_plan nvarchar(100), month_name nvarchar(100), month_int int, fees float)

declare @i int =1
declare @j int =1
declare @invoice_id int = 0
declare @invoice_count int = (select COUNT(*) from FEE_COLLECT where FEE_COLLECT_STD_ID = @std_id)
declare @def_count int = 0

declare @current_fee float = 0
declare @current_fee_received float = 0
declare @def_current_fee float = 0
declare @def_current_fee_received float = 0
declare @def_fee_name int = 0
declare @tbl_def_amount float = 0
declare @remaining_amount float = 0
declare @remaining_after_discount float = 0
declare @discount float = 0
--if @invoice_count > 1

insert into @t select * from (
select FEE_COLLECT_DEF_FEE_NAME, SUM(FEE_COLLECT_DEF_ARREARS_RECEIVED) as arrers_received from FEE_COLLECT_DEF where
FEE_COLLECT_DEF_PID in ( select FEE_COLLECT_ID from FEE_COLLECT where FEE_COLLECT_STD_ID = @std_id) and FEE_COLLECT_DEF_OPERATION = '+'
group by FEE_COLLECT_DEF_FEE_NAME)A where arrers_received > 0

insert into @t select fee_id, SUM(arrers_received) from (select FEE_COLLECT_DEF_FEE_NAME as fee_id, arrers_received from (
select -1 as FEE_COLLECT_DEF_FEE_NAME, SUM(FEE_COLLECT_DEF_FEE) as arrers_received from FEE_COLLECT_DEF where
FEE_COLLECT_DEF_PID in ( select FEE_COLLECT_ID from FEE_COLLECT where FEE_COLLECT_STD_ID = @std_id) and FEE_COLLECT_DEF_OPERATION = '-'
group by FEE_COLLECT_DEF_FEE_NAME)A where arrers_received > 0)B group by fee_id
--select * from @t
--  -1 def fee name for discount
while @i <= @invoice_count

begin
	select @invoice_id = FEE_COLLECT_ID, @current_fee = FEE_COLLECT_FEE, @current_fee_received = FEE_COLLECT_FEE_PAID  
	from (select ROW_NUMBER() over (order by (select 0)) sr, FEE_COLLECT_ID, FEE_COLLECT_FEE, FEE_COLLECT_FEE_PAID from FEE_COLLECT where FEE_COLLECT_STD_ID = @std_id)A where sr = @i 
	
	--if @current_fee - @current_fee_received > 0
	--begin
		
		select @def_count = COUNT(*) from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @invoice_id and FEE_COLLECT_DEF_FEE > 0 and FEE_COLLECT_DEF_OPERATION = '+'
		set @j = 1
		
		while @j <= @def_count
		begin
			set @tbl_def_amount = 0
			select @def_fee_name = FEE_COLLECT_DEF_FEE_NAME, @def_current_fee = FEE_COLLECT_DEF_FEE, @def_current_fee_received = FEE_COLLECT_DEF_FEE_PAID 
			from ( select ROW_NUMBER() over (order by (select 0)) sr, FEE_COLLECT_DEF_FEE_NAME, FEE_COLLECT_DEF_FEE, FEE_COLLECT_DEF_FEE_PAID from FEE_COLLECT_DEF 
			where FEE_COLLECT_DEF_PID = @invoice_id and FEE_COLLECT_DEF_FEE > 0 and FEE_COLLECT_DEF_OPERATION = '+')A where sr = @j
			
			set @remaining_amount = @def_current_fee - @def_current_fee_received
			if   @remaining_amount > 0
			begin
			--select * from @t
				select @tbl_def_amount = arrears_received from @t where fee_name = @def_fee_name
				if @tbl_def_amount >= @remaining_amount
					begin					
						update @t set arrears_received = arrears_received - @remaining_amount where fee_name = @def_fee_name
						--select * from @t
					end
				else	
				begin
					set @discount = (select arrears_received from @t where fee_name = -1)
					set @discount = ISNULL(@discount,0)
					
					set @remaining_after_discount = @remaining_amount - @tbl_def_amount - @discount
					
					if @remaining_after_discount < 0
					begin					
						--update @t set arrears_received = arrears_received - @remaining_amount - @tbl_def_amount where fee_name = -1 --update discount
						update @t set arrears_received = arrears_received - @remaining_amount - @tbl_def_amount where fee_name = -1 --update discount

	
						--select 0 -- if discount in minus it means no need to insert
					end
					else
					begin			
					if @remaining_after_discount != 0
						begin
							insert into @t_arrers values (@invoice_id, @def_fee_name, @remaining_after_discount)
						end	
												
						update @t set arrears_received = 0 where fee_name = -1 --update discount
					end	
					
					
					--set @tbl_def_amount = (select arrears_received from @t where fee_name = -1) - @remaining_after_discount
					
					--if @tbl_def_amount >= 0
					--begin
					--	update @t set arrears_received = @tbl_def_amount where fee_name = @def_fee_name
					--end
					--else
					--	update @t set arrears_received = 0 where fee_name = @def_fee_name
						
						
					
								
					set @tbl_def_amount = (select arrears_received from @t where fee_name = @def_fee_name) - @remaining_amount
					
					if @tbl_def_amount >= 0
					begin
						update @t set arrears_received = @tbl_def_amount where fee_name = @def_fee_name
					end
					else
						update @t set arrears_received = 0 where fee_name = @def_fee_name
					--set @remaining_amount = @remaining_amount - @tbl_def_amount
					--insert into @t_defaulter execute sp_DEFAULTER_INSERT @invoice_id,@def_fee_name,@remaining_amount,'D'
				end
			end			
			set @j = @j + 1
		end
	--end
	
	set @i = @i + 1
end

--select * from @t_arrers

RETURN
END