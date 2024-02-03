

CREATE PROC [dbo].[rpt_STUDENT_FEE_CARD]

 
 @HD_ID numeric,
 @BR_ID numeric ,
 @CLASS_ID numeric ,
 @STUDENT_ID numeric 


AS



--declare @HD_ID numeric = 1
--declare @BR_ID numeric = 1
--declare @CLASS_ID numeric = 0
--declare @STUDENT_ID numeric = 0



declare @class nvarchar(50) = '%'
declare @student nvarchar(50) = '%'

if @CLASS_ID != 0
	set @class = CAST(@CLASS_ID as nvarchar(50))

if @STUDENT_ID != 0
	set @student = CAST(@STUDENT_ID as nvarchar(50))


select * from
(select distinct  s.STDNT_ID,STDNT_SCHOOL_ID [School ID], STDNT_FIRST_NAME + ' ' + STDNT_LAST_NAME as [Student Name], p.PARNT_FIRST_NAME [Parent Name],p.PARNT_FAMILY_CODE [Family Code],
s.STDNT_REGISTRATION_ID [Registration ID],FORMAT( s.STDNT_REG_DATE, 'MMMM dd,yyyy', 'en-US' ) [Registration Date], 

--CASE WHEN ISNULL(pd1.PLAN_FEE_DEF_FEE,0) = 0 THEN 'NIL' ELSE CAST(pd1.PLAN_FEE_DEF_FEE as nvarchar(10))  END [Admission Fee],CASE WHEN ISNULL(pd.PLAN_FEE_DEF_FEE,0) = 0 THEN 'NIL' ELSE CAST(pd.PLAN_FEE_DEF_FEE as nvarchar(10))  END [Security Fee],CASE WHEN ISNULL(pd2.PLAN_FEE_DEF_FEE,0) = 0 THEN 'NIL' ELSE CAST(pd2.PLAN_FEE_DEF_FEE as nvarchar(10))  END [Registration Fee], CASE WHEN ISNULL(pd3.PLAN_FEE_DEF_FEE,0) = 0 THEN 'NIL' ELSE CAST(pd3.PLAN_FEE_DEF_FEE as nvarchar(10))  END  [Term Fee],

(select CASE WHEN ISNULL(PLAN_FEE_DEF_FEE,0) = 0 THEN 'NIL' ELSE CAST(PLAN_FEE_DEF_FEE as nvarchar(10))  END from PLAN_FEE_DEF where PLAN_FEE_DEF_STATUS = 'T' AND PLAN_FEE_DEF_PLAN_ID = s.STDNT_CLASS_FEE_ID and PLAN_FEE_DEF_FEE_NAME = (ISNULL((select top(1) FEE_ID from FEE_INFO  where FEE_HD_ID = @HD_ID and FEE_BR_ID = @BR_ID and FEE_NAME = 'Admission Fee' and FEE_STATUS = 'T'),0))) [Admission Fee],

ISNULL((select CASE WHEN ISNULL(PLAN_FEE_DEF_FEE,0) = 0 THEN 'NIL' ELSE CAST(PLAN_FEE_DEF_FEE as nvarchar(10))  END from PLAN_FEE_DEF where PLAN_FEE_DEF_STATUS = 'T' AND PLAN_FEE_DEF_PLAN_ID = s.STDNT_CLASS_FEE_ID and PLAN_FEE_DEF_FEE_NAME = (ISNULL((select top(1) FEE_ID from FEE_INFO where FEE_HD_ID = @HD_ID and FEE_BR_ID = @BR_ID  and FEE_NAME = 'Security Fee' and FEE_STATUS = 'T'),0))),0) [Security Fee],

ISNULL((select CASE WHEN ISNULL(PLAN_FEE_DEF_FEE,0) = 0 THEN 'NIL' ELSE CAST(PLAN_FEE_DEF_FEE as nvarchar(10))  END from PLAN_FEE_DEF where PLAN_FEE_DEF_STATUS = 'T' AND PLAN_FEE_DEF_PLAN_ID = s.STDNT_CLASS_FEE_ID and PLAN_FEE_DEF_FEE_NAME = (ISNULL((select top(1) FEE_ID from FEE_INFO where FEE_HD_ID = @HD_ID and FEE_BR_ID = @BR_ID and FEE_NAME = 'Registration Fee' and FEE_STATUS = 'T'),0))),0) [Registration Fee],

ISNULL((select CASE WHEN ISNULL(PLAN_FEE_DEF_FEE,0) = 0 THEN 'NIL' ELSE CAST(PLAN_FEE_DEF_FEE as nvarchar(10))  END from PLAN_FEE_DEF where PLAN_FEE_DEF_STATUS = 'T' AND PLAN_FEE_DEF_PLAN_ID = s.STDNT_CLASS_FEE_ID and PLAN_FEE_DEF_FEE_NAME = (ISNULL((select top(1) FEE_ID from FEE_INFO where  FEE_BR_ID = @BR_ID  and FEE_NAME = IIF(@BR_ID <=2,'Fee','Tuition Fee' ) and FEE_STATUS = 'T'),0))),0) [Term Fee],

FORMAT( s.STDNT_DOB, 'MMMM dd,yyyy', 'en-US' ) [Date of Birth], REPLACE(p.PARNT_TEMP_ADDR + ', ' + a.AREA_NAME + ', ' + c.CITY_NAME,',,',',')  [Address], p.PARNT_CELL_NO [Phone], p.PARNT_CELL_NO2 [Phone2], SP.CLASS_ID [Class ID],sp.CLASS_ORDER ClassOrder,
CASE WHEN ISNULL(CLASS_IS_SUPPLEMENTARY_BILLS,0) = 1 THEN 
(select STUFF((
    SELECT distinct ', ' + si.SUB_NAME 
    from STUDENT_INFO s

join tblStudentSubjectsParent ssp on ssp.StudentId = s.STDNT_ID AND ssp.ClassId = s.STDNT_CLASS_PLANE_ID
join tblStudentSubjectsChild ssc on ssc.PId = ssp.Id

join SUBJECT_INFO si on si.SUB_ID = ssc.SubjectId 

    WHERE s1.STDNT_ID = s.STDNT_ID
    FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)')
  ,1,2,'') AS NameValues from STUDENT_INFO s1

join tblStudentSubjectsParent ssp on ssp.StudentId = s1.STDNT_ID AND ssp.ClassId = s1.STDNT_CLASS_PLANE_ID
join tblStudentSubjectsChild ssc1 on ssc1.PId = ssp.Id

join SUBJECT_INFO si on si.SUB_ID = ssc1.SubjectId 
where s1.STDNT_ID = s.STDNT_ID
group by s1.STDNT_ID)  ELSE '' END Subjects

from STUDENT_INFO s
join SCHOOL_PLANE sp on sp.CLASS_ID = s.STDNT_CLASS_PLANE_ID
join PARENT_INFO p on p.PARNT_ID = s.STDNT_PARANT_ID

join AREA_INFO a on a.AREA_ID = PARNT_AREA
join CITY_INFO c on c.CITY_ID = p.PARNT_CITY

--left join PLAN_FEE_DEF pd on pd.PLAN_FEE_DEF_PLAN_ID = s.STDNT_CLASS_FEE_ID  and pd.PLAN_FEE_DEF_STATUS = 'T' 
--left join FEE_INFO f on f.FEE_ID = pd.PLAN_FEE_DEF_FEE_NAME and s.STDNT_BR_ID = f.FEE_BR_ID and f.FEE_NAME = 'Security Fee'

--left join PLAN_FEE_DEF pd1 on pd1.PLAN_FEE_DEF_PLAN_ID = s.STDNT_CLASS_FEE_ID  and pd1.PLAN_FEE_DEF_STATUS = 'T' 
--left join FEE_INFO f1 on f1.FEE_ID = pd1.PLAN_FEE_DEF_FEE_NAME and s.STDNT_BR_ID = f1.FEE_BR_ID and f1.FEE_NAME = 'Admission Fee'

--left join PLAN_FEE_DEF pd2 on pd2.PLAN_FEE_DEF_PLAN_ID = s.STDNT_CLASS_FEE_ID  and pd2.PLAN_FEE_DEF_STATUS = 'T' 
--left join FEE_INFO f2 on f2.FEE_ID = pd2.PLAN_FEE_DEF_FEE_NAME and s.STDNT_BR_ID = f2.FEE_BR_ID and f2.FEE_NAME = 'Registration Fee'

--left join PLAN_FEE_DEF pd3 on pd3.PLAN_FEE_DEF_PLAN_ID = s.STDNT_CLASS_FEE_ID  and pd3.PLAN_FEE_DEF_STATUS = 'T' 
--left join FEE_INFO f3 on f3.FEE_ID = pd3.PLAN_FEE_DEF_FEE_NAME and s.STDNT_BR_ID = f3.FEE_BR_ID and f3.FEE_NAME = 'Term Fee'

where s.STDNT_ID like @student and s.STDNT_CLASS_PLANE_ID like @class 

and s.STDNT_HD_ID = @HD_ID and s.STDNT_BR_ID = @BR_ID and s.STDNT_STATUS = 'T')A

order by ClassOrder, CAST([School ID] as int)