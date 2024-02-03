CREATE PROC [dbo].[sp_FEE_DEFAULTER_DEFINATION]
as 

begin


--with last_fee_record_child as
--(select *,ROW_NUMBER() over (partition by FEE_COLLECT_STD_ID order by CAST(FEE_COLLECT_DATE_FEE_GENERATED as DATE) DESC) grp 
--from FEE_COLLECT where FEE_COLLECT_FEE_STATUS != 'Fully Received')
--select * from FEE_COLLECT_DEF where FEE_COLLECT_DEF_FEE + FEE_COLLECT_DEF_ARREARS > 0 and FEE_COLLECT_DEF_PID in 
--(select FEE_COLLECT_ID from last_fee_record_child where grp = 1 and FEE_COLLECT_ARREARS > 0)


declare @t_last_record table (id int identity(1,1), invoice_id int)
declare @t_defaulter table (sr int identity(1,1), hd_id int, br_id int,std_id int, std_name nvarchar(100), class_plan nvarchar(100), month_name nvarchar(100), month_int int, fees float)
declare @t_invoice table(id int identity(1,1),invoice_id int, is_continue char(1))
declare @t_arrers table (id int identity(1,1),invoice_id int, fee_def int ,fee_amount float)

declare @count int = 0
declare @i int = 1
declare @j int = 1
declare @k int = 1
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
declare @invoice_id int = 0
declare @invoice_id_prev int = 0
declare @def_ids_count int = 0
declare @def_fee_name nvarchar(100) = ''
declare @def_fee float = ''
declare @def_fee_received float = ''
declare @discount float = 0

declare @invoice_count int = 0
declare @status char(1) = ''


declare @month_names varchar(max) = ''
declare @query nvarchar(MAX) = ''

;with last_fee_record_parent as

(select *,ROW_NUMBER() over (partition by FEE_COLLECT_STD_ID order by CAST(FEE_COLLECT_DATE_FEE_GENERATED as DATE) DESC) grp 
from FEE_COLLECT )
insert into @t_last_record select FEE_COLLECT_ID from last_fee_record_parent where grp = 1 and FEE_COLLECT_FEE_STATUS != 'Fully Received'


set @count = (select COUNT(*) from @t_last_record)
while @i <= @count 
begin
	set @invoice_id = (select invoice_id from @t_last_record where id = @i)
	
	select @arrears = FEE_COLLECT_ARREARS, @current_fee = FEE_COLLECT_FEE, @current_fee_received = FEE_COLLECT_FEE_PAID ,@std_id = FEE_COLLECT_STD_ID from FEE_COLLECT where FEE_COLLECT_ID = @invoice_id	
	
	if @arrears = 0 and @current_fee - @current_fee_received != 0
		begin
		insert into @t_defaulter select * from dbo.FEE_DEFAULTER_INSERT (@invoice_id,0,0,'I')		
	end
		
	else
	begin
		set @invoice_id = 0
		set @current_fee = 0
		set @current_fee_received = 0
		set @invoice_count = (select COUNT(*) from FEE_COLLECT where FEE_COLLECT_STD_ID = @std_id)
		select @invoice_id = FEE_COLLECT_ID, @current_fee = FEE_COLLECT_FEE, @current_fee_received = FEE_COLLECT_FEE_PAID from
		(select ROW_NUMBER() over (order by(select FEE_COLLECT_ID) DESC) sr, FEE_COLLECT_ID, FEE_COLLECT_FEE,FEE_COLLECT_FEE_PAID from FEE_COLLECT where FEE_COLLECT_STD_ID = @std_id)A where sr = 1

		
		set @invoice_count = 0
		delete from @t_arrers
		declare @def_fee_id float = 0
		declare @def_fee_amount float = 0
		set @invoice_id = 0
		insert into @t_arrers select * from dbo.FEE_DEFAULTER_CHILD (@std_id)
		set @invoice_count = (select COUNT(*) from @t_arrers)
		set @k = 1
		while @k <=  @invoice_count
		begin
			 select @invoice_id = invoice_id, @def_fee = fee_def, @def_fee_amount = fee_amount from
			  (select ROW_NUMBER() over (order by (select 0)) sr, invoice_id, fee_def, fee_amount from @t_arrers)A where sr = @k
			if @std_id = 103
				declare @variable int = 5
			insert into @t_defaulter select * from dbo.FEE_DEFAULTER_INSERT (@invoice_id,@def_fee,@def_fee_amount,'D')
			set @k = @k + 1
		end
				
	end
	
	set @i = @i + 1
	
end


delete from @t_defaulter where sr in ( select sr from (select *, ROW_NUMBER() over (partition by std_id, month_name, fees order by (select 0)) as pr from @t_defaulter)A where pr > 1)


insert into @t_defaulter select hd_id,br_id,std_id,std_name,class_plan,
'Total ' + (select top(1) val from [dbo].[split](max(month_name),'*')) as month_name, max(month_int), SUM(fees) as fees from @t_defaulter where fees != -1 group by month_int, std_id,hd_id,br_id,month_name,std_id,std_name,class_plan
select a.hd_id, a.br_id,a.std_id,a.std_name,a.class_plan,a.month_name,a.month_int,a.fees from @t_defaulter a


--select month_name, month_int, MAX(fees) from @t_defaulter group by month_name, month_int order by month_int

--select @month_names = STUFF((SELECT '','' + QUOTENAME(convert(varchar(50), month_name, 120))  from @t_defaulter group by month_name, month_int order by month_int
--					FOR XML PATH(''), TYPE).value('.', 'VARCHAR(1000)') ,1,1,'')



--set @query = ';with pivot_tbl as
--(select * from @t_defaulter  
--pivot 
--(max ([fees]) for month_name in (' + @month_names + '))as final_tbl)
--select * from pivot_tbl'

--execute @query


end