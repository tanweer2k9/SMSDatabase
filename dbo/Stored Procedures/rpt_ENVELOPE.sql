CREATE PROC [dbo].[rpt_ENVELOPE]

 @HD_ID numeric,
 @BR_ID numeric ,
@STATUS char(1),
@CLASS_ID numeric,
@PARENT_ID numeric

AS

--declare @HD_ID numeric = 1
--declare @BR_ID numeric = 1,
--@STATUS char(1) = 'A',
--@CLASS_ID numeric = 8,
--@PARENT_ID numeric = 0


declare @parent_nvarchar nvarchar(50) = '%'
declare @class_nvarchar nvarchar(50) = '%'

if @PARENT_ID != 0
BEGIN
	set @parent_nvarchar = CAST(@PARENT_ID as nvarchar(50))
END

if @CLASS_ID != 0
BEGIN
	set @class_nvarchar = CAST(@CLASS_ID as nvarchar(50))
END


select  (ISNULL(p.PARNT_FIRST_NAME,'') + ' ' + ISNULL(p.PARNT_LAST_NAME,'')) [Parent Name],p.PARNT_PERM_ADDR as [Permanent Address],a.AREA_NAME [Area], 
c.CITY_NAME [City], p.PARNT_CELL_NO [Parent Cell], (B.STDNT_FIRST_NAME + ' ' + B.STDNT_LAST_NAME) as [Student Name], B.STDNT_SCHOOL_ID [School ID],
sp.CLASS_Name [Class],p.PARNT_FAMILY_CODE [Family Code]  from PARENT_INFO p
join AREA_INFO a on a.AREA_ID = p.PARNT_AREA
join CITY_INFO c on c.CITY_ID = p.PARNT_CITY
join
(Select * from(select ROW_NUMBER() over(partition by STDNT_PARANT_ID order by(select 0)) as sr,*  from STUDENT_INFO where STDNT_STATUS = 'T')A where sr = 1)B
on B.STDNT_PARANT_ID = p.PARNT_ID
join SCHOOL_PLANE sp on sp.CLASS_ID = B.STDNT_CLASS_PLANE_ID

where p.PARNT_HD_ID = @HD_ID and p.PARNT_BR_ID = @BR_ID and p.PARNT_ID like @parent_nvarchar and B.STDNT_CLASS_PLANE_ID like @class_nvarchar