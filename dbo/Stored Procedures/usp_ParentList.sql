CREATE PROC [dbo].[usp_ParentList]

@BR_ID numeric


AS

select p.*, a.AREA_NAME Area, c.CITY_NAME City, ISNULL(sc.StudentCount,0) StudentCount, (p.PARNT_FIRST_NAME + '; ' + p.PARNT_FAMILY_CODE) Display from PARENT_INFO p
join AREA_INFO a on a.AREA_ID = p.PARNT_AREA
join CITY_INFO c on c.CITY_ID = p.PARNT_CITY
left join (
select s.STDNT_PARANT_ID, COUNT(*) StudentCount from STUDENT_INFO s where s.STDNT_STATUS = 'T' and   s.STDNT_BR_ID in (select COMBINE_BRANCHES_ID from COMBINE_BRANCHES where FROM_BRANCH_ID = 1) group by s.STDNT_PARANT_ID  
)sc on sc.STDNT_PARANT_ID = p.PARNT_ID

where p.PARNT_BR_ID in (select COMBINE_BRANCHES_ID from COMBINE_BRANCHES where FROM_BRANCH_ID = @BR_ID) and p.PARNT_STATUS = 'T'