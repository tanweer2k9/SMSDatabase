CREATE PROC [dbo].[sp_FEE_DEFAULTER]
	
	@START_DATE date,
	@END_DATE date,
	@LOGIN_ID numeric,
	@CLASS_ID numeric

AS
BEGIN

--declare @START_DATE date = '2013-04-11'
--declare @END_DATE date = '2013-11-09'
--declare @LOGIN_ID numeric = 2
--declare @CLASS_ID int = 0



create table #t_defaulter (sr int identity(1,1), hd_id int, br_id int,std_id int, std_name nvarchar(100), class_plan nvarchar(100), month_name nvarchar(100), month_int int, fees int)
create table #t_defaulter_columns (month_name nvarchar(100), month_int int, fees int)


declare @where_clause varchar(max) = ''

declare @hd_id varchar(100) = '%'
declare @br_id varchar(100) = '%'
declare @user_type varchar(100)= ''
declare @user_id varchar(100) = '%'
declare @std_id varchar(100) = '%'
declare @parent_id varchar(100) = '%'

declare @class_plan varchar(200) = ''

if @CLASS_ID = 0	
begin
	set @where_clause = 'and class_plan like ''%'''
	set @class_plan = '%'
end
else
begin
	set @class_plan = (select CLASS_Name from SCHOOL_PLANE where CLASS_ID = @CLASS_ID)
	set @where_clause = 'and class_plan = ' + @class_plan
end
select @user_type = USER_TYPE, @user_id = CAST((USER_CODE)as varchar(50)), @hd_id = CAST((USER_HD_ID)as varchar(50)), @br_id = CAST((USER_BR_ID) as varchar(50)) from USER_INFO where USER_ID = @LOGIN_ID


if @user_type = 'SA'
begin
	set @where_clause = @where_clause + 'and hd_id = ' + @hd_id	
	set @br_id = '%'
	set @std_id = '%'
	set @parent_id = '%'
end
		

if @user_type = 'A' or @user_type = 'Student' or @user_type = 'Parent'
	set @where_clause = @where_clause + 'and hd_id = ' + @hd_id + ' and br_id = ' + @br_id	

if @user_type = 'Student'
begin
	set @where_clause = @where_clause + ' and std_id = ' + @user_id
	set @std_id = @user_id
end

if @user_type = 'Parent'
begin
	set @where_clause = @where_clause + ' and [Parent ID] = ' +  @user_id
	set @parent_id = @user_id
end

declare @month_names varchar(max) = ''
declare @month_names_sum varchar(max) = ''
declare @month_names_individual_sum varchar(max) = ''
declare @query nvarchar(MAX) = ''


declare @month_int int = 0
CREATE table #t_months_int (months_int int)


set @START_DATE = DATEADD(dd, -DAY(@START_DATE) + 1, @START_DATE)
set @END_DATE = DATEADD(dd, -DAY(DATEADD(mm, 1, @END_DATE)), DATEADD(mm, 1, @END_DATE))
 

while @START_DATE <= @END_DATE
begin
	set @month_int = CAST(CAST(DATEPART(YYYY, @START_DATE)as nvarchar(100)) + CAST(DATEPART(MM, @START_DATE) as nvarchar(100)) as int)
	insert into #t_months_int select @month_int
	set @START_DATE = DATEADD(MM,1,@START_DATE)
end






insert into #t_defaulter execute sp_FEE_DEFAULTER_DEFINATION

insert into #t_defaulter_columns 
select * from
(
select month_name, month_int, MAX(fees) as fees from 
(select t.*,s.STDNT_PARANT_ID as [Parent ID] from #t_defaulter t join STUDENT_INFO s on s.STDNT_ID = t.[std_id])A
where month_int in (select months_int from #t_months_int) and class_plan like @class_plan and hd_id like @hd_id 
and br_id like @br_id and std_id like @std_id and [Parent ID] like @parent_id
group by month_name, month_int
)B order by month_int

--select * from #t_defaulter_columns

select month_name, month_int, fees from #t_defaulter_columns
select @month_names = STUFF((SELECT ',' + QUOTENAME(convert(varchar(100), month_name, 120))  from #t_defaulter_columns 
					FOR XML PATH(''), TYPE).value('.', 'VARCHAR(MAX)') ,1,1,'')

select @month_names_sum = STUFF((SELECT '+' + 'ISNULL(' + QUOTENAME(convert(varchar(100), month_name, 120)) + ', 0)' from #t_defaulter_columns where month_name like 'Total%' 
				FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'')
				
select @month_names_individual_sum = STUFF((SELECT ',SUM(' + QUOTENAME(convert(varchar(100), month_name, 120)) + ') as ['+ month_name + ']' from #t_defaulter_columns 
FOR XML PATH(''), TYPE).value('.', 'VARCHAR(MAX)') ,1,1,'')


--select @month_names
--select @month_names_sum
--select @month_names_individual_sum

--select * from #t_defaulter where month_int in (select months_int from @t_months_int) and fees != -1



set @query = ';with tbl as
(select t.*,s.STDNT_PARANT_ID as [Parent ID] from #t_defaulter t join STUDENT_INFO s on s.STDNT_ID = t.[std_id])

,final_tbl as
(select * from tbl where month_int in (select months_int from #t_months_int) and fees != -1 ' + @where_clause + ')
,pivot_tbl as
(select * from final_tbl
pivot 
(max ([fees]) for month_name in (' + @month_names + ' ))as f_pivot_tbl)
, group_by_tbl as
(select ROW_NUMBER() over (order by (select 0)) as Sr#, a.hd_id as [Institute ID], a.br_id as [Branch ID],a.std_id as [Student ID],a.std_name as Name,a.class_plan [Class Plan], a.[Parent ID],' + @month_names_individual_sum +' from pivot_tbl a group by a.std_id,a.hd_id, a.br_id,a.std_name,a.class_plan, a.[Parent ID])
, add_total_column as
( select *,' + @month_names_sum + 'as [Total Dues] from group_by_tbl )
select atc.*,B.NCA from add_total_column atc  
join STUDENT_INFO s on s.STDNT_ID = atc.[Student ID] 
join 
(select FEE_COLLECT_STD_ID ID, ISNULL(SUM(FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT),0) as NCA  from FEE_COLLECT group by FEE_COLLECT_STD_ID)B
on B.ID = atc.[Student ID]
where s.STDNT_STATUS = ''T'''



--select t.*,s.STDNT_PARANT_ID from add_total_column t join STUDENT_INFO s on s.STDNT_ID = t.[Student ID]
--, join_tbl as
--(select t.*,s.STDNT_PARANT_ID as [Parent ID] from add_total_column t join STUDENT_INFO s on s.STDNT_ID = t.[Student ID] )
--, where_tbl as 
--(select * from add_total_column)
--select * from where_tbl


execute (@query)
drop table #t_defaulter
drop table #t_months_int
drop table #t_defaulter_columns

END