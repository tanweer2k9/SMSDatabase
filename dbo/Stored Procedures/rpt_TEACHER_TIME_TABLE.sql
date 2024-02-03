CREATE procedure [dbo].[rpt_TEACHER_TIME_TABLE]

@HD_ID DECIMAL,
@BR_ID DECIMAL,
@TEACHER_NAME NVARCHAR(50)
--@status nvarchar(3)
as

--if @status='A'
begin

select ID,[Plan Name],Class,Shift,Section,Department,Teacher,Subject,Term,[Start Time],[End Time] from rpt_V_TEACHER_TIME_TABLE

WHERE [Institute ID] =@HD_ID AND 
Branch = @BR_ID AND
Teacher = @TEACHER_NAME AND 
Status = 'T'
end
--else if @status='B'
--begin
--select ID,[Plan Name],Class,Shift,Section,Department,Teacher,Subject,Term,[Start Time],[End Time] from rpt_V_TEACHER_TIME_TABLE

--WHERE [Institute ID] =@HD_ID AND 
--Branch = @BR_ID AND
--Status = 'T'

--end