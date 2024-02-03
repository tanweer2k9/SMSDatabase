

CREATE PROC [dbo].[rpt_Subject_Allocation]

@HD_ID numeric,
@BR_ID numeric,
@STATUS char(1),
@CLASS_ID numeric,
@TERM_ID numeric

AS

--declare @HD_ID numeric = 1,
--@BR_ID numeric =1,
--@STATUS char(1) = 'A',
--@CLASS_ID numeric = 8
--set @TERM_ID = 43

declare @tbl table ([Roll NO] nvarchar(50), [Student Name] nvarchar(500), [Sch ID] int, [Subject] nvarchar(100), [Subject ID] numeric, [Std ID] numeric)

--select ROW_NUMBER() over (order by (select 0) ) as sr#,[Roll No],[Student Name], Class,[Subject] from
--(

insert into @tbl
select s.STDNT_SCHOOL_ID [Roll No],(s.STDNT_FIRST_NAME + ' ' + s.STDNT_LAST_NAME) [Student Name], 
CASE WHEN s.STDNT_SCHOOL_ID = '' THEN 50000 ELSE  CONVERT(numeric(18,0),STDNT_SCHOOL_ID) END as [Sch ID], REPLACE(sb.SUB_NAME,'&','and**') [Subject], sb.SUB_ID, s.STDNT_ID [Std ID] from tblStudentSubjectsParent p
join tblStudentSubjectsChild c on c.PId = p.Id
join SCHOOL_PLANE sp on sp.CLASS_ID = p.ClassId
join STUDENT_INFO s on s.STDNT_ID = p.StudentId
join SUBJECT_INFO sb on sb.SUB_ID = c.SubjectId


where ((s.STDNT_STATUS = 'T') 

--OR (s.stdnt_Status ='F' and s.STDNT_DATE_OF_LEAVING >= '2018-07-30')
) and p.ClassId = @CLASS_ID and sp.CLASS_STATUS = 'T' and ( @TERM_ID = 0 OR c.TermId = @TERM_ID)  and  SUB_ID in (select DEF_SUBJECT from SCHOOL_PLANE_DEFINITION where DEF_STATUS = 'T' and ( @TERM_ID = 0 OR DEF_TERM = @TERM_ID) and DEF_CLASS_ID = @CLASS_ID)


 Select [Roll NO],[Student Name],[Sch ID], [Std ID],REPLACE([Subject],'and**','&') as [Subject],[Subject IDs] from
 (SELECT [Roll NO],[Student Name],[Sch ID], [Std ID],[Subject] = 
    STUFF((SELECT ', ' + [Subject]
           FROM @tbl b 
           WHERE b.[Roll NO] = a.[Roll NO] 
          FOR XML PATH('')),1,2,''),

		  [Subject IDs] =
		  STUFF((SELECT ', ' + CAST([Subject ID] as nvarchar(10))
           FROM @tbl c 
           WHERE c.[Roll NO] = a.[Roll NO] 
          FOR XML PATH('')),1,2,'')
FROM @tbl a
GROUP BY [Roll NO],[Student Name],[Sch ID],[Std ID])B order by [Sch ID]


select * from 
(select distinct SUB_ID ID, SUB_NAME [Subject], SUB_DESC [Subject Description],DEF_IS_COMPULSORY from SCHOOL_PLANE_DEFINITION spd
join SUBJECT_INFO s on s.SUB_ID = spd.DEF_SUBJECT
where DEF_STATUS = 'T' and  DEF_CLASS_ID = @CLASS_ID and (@STATUS = 'A' OR DEF_TERM =@TERM_ID) and SUB_ID in (select [Subject ID] from @tbl) )A order by DEF_IS_COMPULSORY DESC


if @status = 'B'
BEGIN
	declare @is_subject_attendance bit = 0
	select @is_subject_attendance = CLASS_IS_SUBJECT_ATTENDANCE from SCHOOL_PLANE where CLASS_ID = @CLASS_ID
	
	if @is_subject_attendance = 1
	BEGIN
		select EXAM_STD_ATT_STD_ID [Std ID], EXAM_STD_ATT_SUB_ID [Subject Id],s.SUB_NAME [Subject],s.SUB_DESC [Subject Description],EXAM_STD_ATT_PRESENT_DAYS as [Present Days], EXAM_STD_ATT_TOTAL_DAYS as [Total Days] from EXAM_STD_ATTENDANCE_INFO a 
		join SUBJECT_INFO s on s.SUB_ID = a.EXAM_STD_ATT_SUB_ID
		
		where EXAM_STD_ATT_TERM_ID = @TERM_ID and EXAM_STD_ATT_CLASS_ID = @CLASS_ID


		exec dbo.rpt_GPA_CALCULATION @CLASS_ID,@TERM_ID
--group by EXAM_STD_ATT_CLASS_ID,EXAM_STD_ATT_STD_ID
	END
	ELSE
	BEGIN
		select EXAM_STD_ATT_STD_ID [Std ID], EXAM_STD_ATT_PRESENT_DAYS as [Present Days], EXAM_STD_ATT_TOTAL_DAYS as [Total Days] from EXAM_STD_ATTENDANCE_INFO where EXAM_STD_ATT_TERM_ID = @TERM_ID and EXAM_STD_ATT_SUB_ID = 0 and EXAM_STD_ATT_CLASS_ID = @CLASS_ID
--group by EXAM_STD_ATT_CLASS_ID,EXAM_STD_ATT_STD_ID
	END

END