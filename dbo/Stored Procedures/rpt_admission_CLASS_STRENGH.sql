
CREATE PROC [dbo].[rpt_admission_CLASS_STRENGH]

@HD_ID numeric,
@BR_ID numeric


AS
--declare @HD_ID numeric = 1
--declare @BR_ID numeric = 1

--0 for female
Select sp.CLASS_Name, A.[Total Strength], B.Male,C.Female from
(select s1.STDNT_CLASS_PLANE_ID [Class ID], COUNT(s1.STDNT_ID) [Total Strength] from STUDENT_INFO s1 where s1.STDNT_HD_ID = @HD_ID and s1.STDNT_BR_ID = @BR_ID and s1.STDNT_STATUS = 'T' group by STDNT_CLASS_PLANE_ID)A

LEFT join (select s2.STDNT_CLASS_PLANE_ID [Class ID], COUNT(s2.STDNT_ID) [Male] from STUDENT_INFO s2 where s2.STDNT_HD_ID = @HD_ID and s2.STDNT_BR_ID = @BR_ID and s2.STDNT_STATUS = 'T' and s2.STDNT_GENDER = 1  group by STDNT_CLASS_PLANE_ID)B On A.[Class ID] = B.[Class ID]

LEFT join (select s3.STDNT_CLASS_PLANE_ID [Class ID], COUNT(s3.STDNT_ID) [Female] from STUDENT_INFO s3 where s3.STDNT_HD_ID = @HD_ID and s3.STDNT_BR_ID = @BR_ID and s3.STDNT_STATUS = 'T' and s3.STDNT_GENDER = 0  group by STDNT_CLASS_PLANE_ID)C On A.[Class ID] = C.[Class ID]

RIGHT join SCHOOL_PLANE sp on sp.CLASS_ID = A.[Class ID]
join BR_ADMIN br on br.BR_ADM_ID = sp.CLASS_BR_ID and sp.CLASS_SESSION_ID = br.BR_ADM_SESSION

where sp.CLASS_HD_ID = @HD_ID and sp.CLASS_BR_ID = @BR_ID and sp.CLASS_STATUS = 'T'
 order by sp.CLASS_ORDER