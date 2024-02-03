
CREATE FUNCTION [dbo].[get_GRADE_NAME](@CLASS_ID int,@value float )
returns nvarchar(50)

AS 
BEGIN

--declare @HD_ID numeric = 2
--declare @BR_ID numeric = 1
--declare @CLASS_ID int = 3
--declare @value float = 10

--select * from GRADE_INFO

--select * from PLAN_GRADE
--select * from PLAN_GRADE_DEF where DEF_GRADE_STATUS = 'T'
--select * from GRADE_MAPPING

declare @count int = 0
declare @i int = 1
declare @min_limit float = 0
declare @max_limit float = 0
declare @min_operator nvarchar(10)= ''
declare @max_operator nvarchar(10)= ''
declare @grade_id int = 0
declare @grade_name nvarchar(50) = 0
declare @marks int =0

 set @marks = (CAST(ROUND(@value,0) as int))
set @count = ( select COUNT(*) from PLAN_GRADE_DEF where DEF_GRADE_STATUS = 'T' and DEF_P_ID in 
( select P_GRADE_ID from PLAN_GRADE where P_GRADE_ID in (select GRADE_MAP_GRADE_PLAN_ID from GRADE_MAPPING 
where GRADE_MAP_CLASS_ID = @CLASS_ID and 
GRADE_MAP_STATUS = 'T')))

while @i <= @count
begin
	select @min_limit = [Min Limit], @max_limit = [Max Limit], @min_operator = [Min Operator], 
	@max_operator = [Max Operator], @grade_id = [Grade ID]  from (select ROW_NUMBER() over(order by (select 0)) as sr, 
	DEF_GRADE_MIN_LIMIT as [Min Limit], DEF_GRADE_MAX_LIMIT as [Max Limit], DEF_GRADE_MIN_OPERATOR as [Min Operator], 
	DEF_GRADE_MAX_OPERATOR as [Max Operator], DEF_GRADE_INFO_ID as [Grade ID] from 
	PLAN_GRADE_DEF where DEF_GRADE_STATUS = 'T' and DEF_P_ID in ( select P_GRADE_ID from PLAN_GRADE 
	where P_GRADE_ID in (select GRADE_MAP_GRADE_PLAN_ID from GRADE_MAPPING where GRADE_MAP_CLASS_ID = @CLASS_ID and GRADE_MAP_STATUS = 'T')))A where A.sr = @i
	set @min_limit = ISNULL(@min_limit, 0)
	set @max_limit = ISNULL(@max_limit, 1000)
	
	if @marks >= @min_limit and @marks <= @max_limit
	begin
		set @grade_name = (select GRADE_NAME from GRADE_INFO where GRADE_ID = @grade_id)
		break
	end	
	--else if @value >= @max_limit
	--begin
	--	set @grade_name = (select GRADE_NAME from GRADE_INFO where GRADE_ID = @grade_id)
	--	break
	--end	
set @i = @i +1
end

return @grade_name

END