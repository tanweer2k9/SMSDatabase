
CREATE PROC [dbo].[rpt_CLASS_Basic_Info]



@HD_ID numeric,
@BR_ID numeric,
@CLASS_ID nvarchar(200)

As


select sp.CLASS_ID [Class ID], sp.CLASS_Name [Class Name], s.SESSION_DESC [Session], A.[Total Strength] from SCHOOL_PLANE sp
join SESSION_INFO s on s.SESSION_ID = sp.CLASS_SESSION_ID
join
(select s1.STDNT_CLASS_PLANE_ID [Class ID], COUNT(s1.STDNT_ID) [Total Strength] from STUDENT_INFO s1 where s1.STDNT_HD_ID = @HD_ID and s1.STDNT_BR_ID = @BR_ID and s1.STDNT_STATUS = 'T' group by STDNT_CLASS_PLANE_ID)A on A.[Class ID] = sp.CLASS_ID
where sp.CLASS_HD_ID = @HD_ID and sp.CLASS_BR_ID = @BR_ID and CLASS_STATUS = 'T' and  (@CLASS_ID = '0' OR sp.CLASS_ID in  (select CAST(val as numeric) from dbo.split(@CLASS_ID,';') )) 
Order By sp.CLASS_ORDER

 --and (select COUNT(*) from rpt_V_ALL_STUDENTS_INFORMATION where [Branch ID] in (select * from dbo.get_all_br_id (@BR_ID)) and [Institute ID] in (select * from dbo.get_all_hd_id (@HD_ID))  and [Class ID] = sp.CLASS_ID ) > 0