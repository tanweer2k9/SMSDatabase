﻿
CREATE PROC [dbo].[sp_EXAM_STUDENT_ATTENDANCE]


@CLASS_ID numeric 
AS
--declare @CLASS_ID numeric = 3




select EXAM_STD_ATT_STD_ID [Std ID],EXAM_STD_ATT_TERM_ID [Term ID], DATENAME(MM,t.TERM_END_DATE) + ' ' + DATENAME(YYYY,t.TERM_END_DATE) as [Term Month Name],s.SUB_ID [Subject ID], s.SUB_NAME [Subject],s.SUB_DESC [Subject Description], EXAM_STD_ATT_TOTAL_DAYS as [Total Days], EXAM_STD_ATT_PRESENT_DAYS [Present Days]    
from EXAM_STD_ATTENDANCE_INFO att
join SUBJECT_INFO s on s.SUB_ID = att.EXAM_STD_ATT_SUB_ID
join TERM_INFO t on t.TERM_ID = att.EXAM_STD_ATT_TERM_ID
where EXAM_STD_ATT_CLASS_ID = @CLASS_ID order by [Term ID] desc
--group by EXAM_STD_ATT_CLASS_ID,EXAM_STD_ATT_STD_ID,EXAM_STD_ATT_TERM_ID