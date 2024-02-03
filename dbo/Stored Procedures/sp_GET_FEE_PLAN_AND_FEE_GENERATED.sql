

CREATE PROC [dbo].[sp_GET_FEE_PLAN_AND_FEE_GENERATED] 

@HD_ID numeric, 
@BR_ID numeric,
@FROM_DATE DATE






AS


--select * from FEE_COLLECT where FEE_COLLECT_BR_ID =@BR_ID and FEE_COLLECT_HD_ID = @HD_ID and DATEPART(MM, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(MM, @FROM_DATE) AND DATEPART(YYYY, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(YYYY, @FROM_DATE)


select ID,Name,[Fee Type], [Fee Months], Operation from VFEE_INFO
		
	where [Institute ID] = @HD_ID            
    and  [Branch ID] = @BR_ID
    and [Status] ='T'


select ID, [Institute ID], [Branch ID], Name, [Total Fee], Status, [Fee Formula], [Is Formula Apply], [Is Fee Generate], [Fee Notes], [Installment ID] from VPLAN_FEE where [Branch ID] =@BR_ID and ID in (select STDNT_CLASS_FEE_ID from STUDENT_INFO where STDNT_STATUS = 'T')


	SELECT PLAN_FEE_DEF_ID as ID,PLAN_FEE_DEF_PLAN_ID,PLAN_FEE_DEF_FEE_NAME as [Fee Name],PLAN_FEE_DEF_FEE as Fee,PLAN_FEE_DEF_FEE_MIN as [Min Fee Variation %],PLAN_FEE_DEF_FEE_MAX as [Max Fee Variation %],PLAN_FEE_DEF_STATUS as [Status],fi.FEE_OPERATION AS [Operation], fi.FEE_TYPE as [Fee Type],  CASE WHEN PLAN_FEE_IS_ONCE_PAID = 'T' THEN CAST(1 AS bit) ELSE CAST(0 AS bit) END AS [Is Once Paid], fi.FEE_NAME [Fee Definition]
  FROM PLAN_FEE_DEF f
	join FEE_INFO fi on fi.FEE_ID = f.PLAN_FEE_DEF_FEE_NAME and fi.FEE_BR_ID = @BR_ID 
	where f.PLAN_FEE_DEF_STATUS = 'T' and f.PLAN_FEE_DEF_PLAN_ID in  (select STDNT_CLASS_FEE_ID from STUDENT_INFO where STDNT_STATUS = 'T' and STDNT_BR_ID = @BR_ID)



select s.STDNT_ID ID, s.STDNT_SCHOOL_ID [School ID], (s.STDNT_FIRST_NAME + s.STDNT_LAST_NAME) AS Name,sp.CLASS_Name Class, 0 [Fee Plan Amount], ISNULL(f.FEE_COLLECT_FEE, 0) [Fee Generated Amount],0 [Fee Difference],f.FEE_COLLECT_ARREARS [Arrears], f.FEE_COLLECT_NET_TOATAL [Total Fee], s.STDNT_CLASS_FEE_ID [Fee ID] from STUDENT_INFO s
join SCHOOL_PLANE sp on sp.CLASS_ID = s.STDNT_CLASS_PLANE_ID
left join FEE_COLLECT f on f.FEE_COLLECT_STD_ID = s.STDNT_ID and DATEPART(MM, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(MM, @FROM_DATE) AND DATEPART(YYYY, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(YYYY, @FROM_DATE) and FEE_COLLECT_BR_ID =@BR_ID and FEE_COLLECT_HD_ID = @HD_ID 

where s.STDNT_BR_ID = @BR_ID and s.STDNT_STATUS = 'T'
order by CLASS_ORDER