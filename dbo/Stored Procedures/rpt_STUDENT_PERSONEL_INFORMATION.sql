
CREATE PROC [dbo].[rpt_STUDENT_PERSONEL_INFORMATION]

@HD_ID numeric,
@BR_ID numeric,
@CLASS_ID numeric


AS

--declare @HD_ID numeric = 1
--declare @BR_ID numeric = 1
--declare @CLASS_ID numeric = 1

 select STDNT_SCHOOL_ID [Std #], p.PARNT_FAMILY_CODE [Family Code], sp.CLASS_Name Class,b.BR_ADM_NAME [Branch Name], (s.STDNT_FIRST_NAME + ' ' + s.STDNT_LAST_NAME) as Name,CASE WHEN s.STDNT_GENDER = 0 THEN 'Femlae' ELSE 'Male' END Gender, s.STDNT_DOB [Date of Birth], s.STDNT_REG_DATE [Date of Admission], p.PARNT_PERM_ADDR [Permanent Address], a.AREA_NAME [Area], c.CITY_NAME [City], ISNULL(p.PARNT_CELL_NO,'') [Home Phone], ISNULL(p.PARNT_CELL_NO2,'') [F/M Cell#] ,s.STDNT_CELL_NO [Telephone 1], s.STDNT_EMERGENCY_CNTCT_NO [Telephone 2], (ISNULL(p.PARNT_FIRST_NAME,'') + ' ' +ISNULL(p.PARNT_LAST_NAME,'')) [Father Name], p.PARNT_CELL_NO [Father Telephone 1], p.PARNT_CELL_NO2 [Father Telephone 2]
 from STUDENT_INFO s
 join PARENT_INFO p on p.PARNT_ID = s.STDNT_PARANT_ID
 join SCHOOL_PLANE sp on sp.CLASS_ID = s.STDNT_CLASS_PLANE_ID
 join BR_ADMIN b on b.BR_ADM_ID = s.STDNT_BR_ID
 LEFT join AREA_INFO a on a.AREA_ID = p.PARNT_AREA
 LEFT join CITY_INFO c on c.CITY_ID = p.PARNT_CITY
  where STDNT_HD_ID = @HD_ID and STDNT_BR_ID = @BR_ID and STDNT_CLASS_PLANE_ID = @CLASS_ID and STDNT_STATUS = 'T' order by  CLASS_ORDER,CAST(STDNT_SCHOOL_ID as int)