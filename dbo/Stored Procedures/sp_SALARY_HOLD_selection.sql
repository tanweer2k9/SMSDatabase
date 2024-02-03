
CREATE PROC [dbo].[sp_SALARY_HOLD_selection]

@HD_ID numeric,
@BR_ID numeric,
@Date date


AS

SELECT t.ID,[Employee Code],Name,Designation,[Department Name],CONVERT(nvarchar(100),[Joining Date],103)[Joining Date], ISNULL(sp.[Hold],CAST(0 as bit)) [Hold] ,  h.[DAYS] Days, ISNULL(h.IS_PAID, CAST(0 as bit)) [Is Paid]
FROM VTEACHER_INFO t
left join (select val, CAST(1 as bit) Hold from dbo.split((select s.EMPLOYEE_IDS from SALARY_HOLD s where s.HD_ID = @HD_ID
and s.BR_ID in ( select * from [dbo].[get_centralized_br_id]('S', @BR_ID)) and DATEPART(MM,[DATE]) = DATEPART(MM,@date) and DATEPART(YYYY,[DATE]) = DATEPART(YYYY,@date) ) ,',')) sp on CAST(sp.val as numeric) = t.ID  
left join SALARY_HOLD_DAYS h on h.STAFF_ID = t.ID and  DATEPART(MM,h.[DATE]) = DATEPART(MM,@date) and DATEPART(YYYY,h.[DATE]) = DATEPART(YYYY,@date)
where
[Institute ID] =  @HD_ID 
    and  [Branch ID] in ( select * from [dbo].[get_centralized_br_id]('S', @BR_ID)) 
    and [Status] ='T' 
	  
	order by Ranking