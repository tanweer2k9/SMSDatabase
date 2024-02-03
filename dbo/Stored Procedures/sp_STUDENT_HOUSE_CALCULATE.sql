CREATE PROC [dbo].[sp_STUDENT_HOUSE_CALCULATE]

 @STATUS char(1),
 @CLASS_ID numeric,
 @HD_ID numeric,
 @BR_ID numeric 

--declare @STATUS char(1) = ''
--declare @CLASS_ID numeric = 6
--declare @HD_ID numeric = 1
--declare @BR_ID numeric = 1


AS

select h.HOUSES_NAME [House Name], count_house as [No. of students] from
(select count(*) as count_house, STDNT_HOUSE_ID from STUDENT_INFO  where STDNT_CLASS_PLANE_ID = @CLASS_ID and STDNT_STATUS = 'T' 
and STDNT_HD_ID = @HD_ID and STDNT_BR_ID = @BR_ID group by STDNT_HOUSE_ID)A
join HOUSES_INFO h on h.HOUSES_ID = A.STDNT_HOUSE_ID and h.HOUSES_BR_ID = @BR_ID