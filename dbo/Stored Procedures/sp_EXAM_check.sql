
CREATE PROCEDURE [dbo].[sp_EXAM_check]	
		
		@EXAM_TABLE type_EXAM_PLAN READONLY
	as	
	
	begin	
	--SELECT 0
		select Subject from (select max(Subject) as Subject, SUM([%age In Final]) as Final from (select MAX(term) as term, max(Subject) as Subject, SUM([%age In Final]) as [%age In Final] from @EXAM_TABLE where [Marks Type] != 'Grade' group by PID)A group by Subject)B where Final != 100
	end