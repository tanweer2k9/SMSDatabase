

CREATE PROC [dbo].[rpt_FAMILY_CODES]

@BR_ID numeric

AS

select ROW_NUMBER() over (order by (select 0)) as Sr#,* from
(
select  CASE WHEN p.PARNT_FAMILY_CODE = '' THEN 5000000 ELSE  CONVERT(numeric(18,0),PARNT_FAMILY_CODE) END as FamCode,p.PARNT_FAMILY_CODE [Family Code], (p.PARNT_FIRST_NAME + ' ' + ISNULL(p.PARNT_LAST_NAME,'')) as [Father Name], s.STDNT_SCHOOL_ID [Roll No], (s.STDNT_FIRST_NAME + ' '+ s.STDNT_LAST_NAME) as [Student Name], sp.CLASS_Name Class, b.BR_ADM_NAME Branch,m.MAIN_INFO_INSTITUTION_FULL_NAME School  from 
STUDENT_INFO s
join PARENT_INFO p on p.PARNT_ID = s.STDNT_PARANT_ID
join SCHOOL_PLANE sp on sp.CLASS_ID = s.STDNT_CLASS_PLANE_ID
join BR_ADMIN b on b.BR_ADM_ID = s.STDNT_BR_ID
join MAIN_HD_INFO m on m.MAIN_INFO_ID = b.BR_ADM_HD_ID

where s.STDNT_STATUS = 'T' and b.BR_ADM_ID = @BR_ID--in (select COMBINE_BRANCHES_ID from COMBINE_BRANCHES where FROM_BRANCH_ID = @BR_ID)
)A order by FamCode