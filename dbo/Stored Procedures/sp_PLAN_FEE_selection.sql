

CREATE procedure  [dbo].[sp_PLAN_FEE_selection]
                                               
     @STATUS char(2),
     @PLAN_FEE_ID  numeric,
     @PLAN_FEE_HD_ID  numeric,
     @PLAN_FEE_BR_ID  numeric
   
   
     AS BEGIN 
    
     IF @STATUS = 'L'    
     BEGIN
     
     
	    select s.STDNT_ID as [Student ID], s.STDNT_FIRST_NAME + ' ' + s.STDNT_LAST_NAME as [Student Name], s.STDNT_SCHOOL_ID as [School ID], p.CLASS_Name as [Class Name],s.STDNT_DISCOUNT_RULE_ID [Template ID],f.* from VPLAN_FEE f
    join STUDENT_INFO s on s.STDNT_CLASS_FEE_ID = f.ID
	Left join SCHOOL_PLANE p on p.CLASS_ID = s.STDNT_CLASS_PLANE_ID
	Left join FeeYearlyPlan y on y.Id = FeeYearlyPlanId
   where [Institute ID] = @PLAN_FEE_HD_ID   
    and  [Branch ID] = @PLAN_FEE_BR_ID
    and  s.STDNT_STATUS = 'T'
	order by CLASS_ORDER,CAST(s.STDNT_SCHOOL_ID as bigint) 

 --  select s.STDNT_ID as [Student ID], s.STDNT_SCHOOL_ID as [School ID],s.STDNT_FIRST_NAME + ' ' + s.STDNT_LAST_NAME as [Student Name],  p.CLASS_Name as [Class Name],s.STDNT_DISCOUNT_RULE_ID [Template ID], f.* from VPLAN_FEE f
 --   LEFT join STUDENT_INFO s on s.STDNT_CLASS_FEE_ID = f.ID
	--Left join SCHOOL_PLANE p on p.CLASS_ID = s.STDNT_CLASS_PLANE_ID
 --  where [Institute ID] = @PLAN_FEE_HD_ID   
 --   and  [Branch ID] = @PLAN_FEE_BR_ID
 --   and  [Status] != 'D' and s.STDNT_STATUS ='T'
     
     
	SELECT * FROM VPLAN_FEE_DEF

     WHERE     
      ID = null and [Status] != 'D'
     
     
     --select ID, Name,[Fee Type] from VFEE_INFO
     --where [Institute ID] = @PLAN_FEE_HD_ID
     --and [Branch ID] = @PLAN_FEE_BR_ID
     --and [Status] = 'T' 


	select ID,Name,[Fee Type], [Fee Months], Operation from VFEE_INFO
		
	where [Institute ID] = @PLAN_FEE_HD_ID            
    and  [Branch ID] = @PLAN_FEE_BR_ID
    and [Status] ='T'

	select ID,Name from VINSTALLMENT_INFO where Status = 'T' and [Institute ID] = @PLAN_FEE_HD_ID and [Branch ID] = @PLAN_FEE_BR_ID order by [Rank]

			select ID, Name from VDISCOUNT_RULES 
		where ID is null

		select * from VDISCOUNT_RULES_DEF
			where ID is null


			--For Just Load
		select  s.STDNT_ID ,s.STDNT_SCHOOL_ID + ', ' + s.STDNT_FIRST_NAME + ', ' +sp.CLASS_Name + ', ' + CAST(( select ISNULL(pd.PLAN_FEE_DEF_FEE,0) from PLAN_FEE_DEF pd join  FEE_INFO f on f.FEE_ID = pd.PLAN_FEE_DEF_FEE_NAME and f.FEE_NAME =				'Term Fee'   where PLAN_FEE_DEF_STATUS = 'T' and PLAN_FEE_DEF_PLAN_ID = s.STDNT_CLASS_FEE_ID )  as nvarchar(50) ) as FeeInfo
		 from STUDENT_INFO s 
		join SCHOOL_PLANE sp on sp.CLASS_ID = s.STDNT_CLASS_PLANE_ID		
		where s.STDNT_PARANT_ID = 0

		select Id,Name from FeeYearlyPlan where BrId = @PLAN_FEE_BR_ID and PlanStatus = 1

		select * from VFeeYearlyPlanDef where BrId = @PLAN_FEE_BR_ID and PlanStatus = 1 and IsDeleted = 0

		select 0 FromMonth, 0 ToMonth,0 InstallmentId,0 FeeFormula
 
	END
	 
    
    ELSE IF @STATUS = 'B'
    
     BEGIN
     
     
    select s.STDNT_ID as [Student ID], s.STDNT_FIRST_NAME + ' ' + s.STDNT_LAST_NAME as [Student Name], s.STDNT_SCHOOL_ID as [School ID], p.CLASS_Name as [Class Name],s.STDNT_DISCOUNT_RULE_ID [Template ID],f.* from VPLAN_FEE f
    join STUDENT_INFO s on s.STDNT_CLASS_FEE_ID = f.ID
	Left join SCHOOL_PLANE p on p.CLASS_ID = s.STDNT_CLASS_PLANE_ID
   where [Institute ID] = @PLAN_FEE_HD_ID   
    and  [Branch ID] = @PLAN_FEE_BR_ID
    and  s.STDNT_STATUS = 'T'
    order by CLASS_ORDER,CAST(s.STDNT_SCHOOL_ID as bigint)  
     
	SELECT PLAN_FEE_DEF_ID as ID,PLAN_FEE_DEF_FEE_NAME as [Fee Name], PLAN_FEE_DEF_FEE as Fee,PLAN_FEE_DEF_FEE_MIN as [Min Fee Variation %],PLAN_FEE_DEF_FEE_MAX as [Max Fee Variation %],PLAN_FEE_DEF_STATUS as [Status],fi.FEE_OPERATION AS [Operation], fi.FEE_TYPE as [Fee Type],  CASE WHEN PLAN_FEE_IS_ONCE_PAID = 'T' THEN CAST(1 AS bit) ELSE CAST(0 AS bit) END AS [Is Once Paid], fi.FEE_NAME [Fee Definition]
  FROM PLAN_FEE_DEF f
	join FEE_INFO fi on fi.FEE_ID = f.PLAN_FEE_DEF_FEE_NAME and fi.FEE_BR_ID = @PLAN_FEE_BR_ID
    WHERE     
     PLAN_FEE_DEF_PLAN_ID = @PLAN_FEE_ID
     and PLAN_FEE_DEF_STATUS !='D'
	 
    order by PLAN_FEE_DEF_FEE desc
	
	 
	select  ID,Name,[Fee Type], [Fee Months], Operation from VFEE_INFO
     where [Institute ID] = @PLAN_FEE_HD_ID
     and [Branch ID] = @PLAN_FEE_BR_ID
     and [Status] = 'T'
  
     	select ID,Name from VINSTALLMENT_INFO where Status = 'T' and [Institute ID] = @PLAN_FEE_HD_ID and [Branch ID] = @PLAN_FEE_BR_ID order by [Rank]

		select ID, Name from VDISCOUNT_RULES 
		where [Institute ID] = @PLAN_FEE_HD_ID 
		and [Branch ID] = @PLAN_FEE_BR_ID
		and [Status] ='T' and [Class ID]  = (select STDNT_CLASS_PLANE_ID from STUDENT_INFO where STDNT_CLASS_FEE_ID = @PLAN_FEE_ID and STDNT_STATUS = 'T')

		select * from VDISCOUNT_RULES_DEF where PID in 
		(	select ID from VDISCOUNT_RULES 
		where [Institute ID] = @PLAN_FEE_HD_ID 
		and [Branch ID] = @PLAN_FEE_BR_ID
		and [Status] ='T' and [Class ID]  = (select STDNT_CLASS_PLANE_ID from STUDENT_INFO where STDNT_CLASS_FEE_ID = @PLAN_FEE_ID and STDNT_STATUS = 'T')
)
		declare @one int = 1
		declare @parent_id numeric = (select top(@one) STDNT_PARANT_ID from STUDENT_INFO where STDNT_CLASS_FEE_ID = @PLAN_FEE_ID and STDNT_STATUS = 'T')

		select  s.STDNT_ID ,s.STDNT_SCHOOL_ID + ', ' + s.STDNT_FIRST_NAME + ', ' +sp.CLASS_Name + ', ' + ISNULL(CAST(( select ISNULL(pd.PLAN_FEE_DEF_FEE,0) from PLAN_FEE_DEF pd join  FEE_INFO f on f.FEE_ID = pd.PLAN_FEE_DEF_FEE_NAME and f.FEE_NAME in (' Fee')   where PLAN_FEE_DEF_STATUS = 'T' and PLAN_FEE_DEF_PLAN_ID = s.STDNT_CLASS_FEE_ID )  as nvarchar(50) ),'') as FeeInfo
		 from STUDENT_INFO s 
		join SCHOOL_PLANE sp on sp.CLASS_ID = s.STDNT_CLASS_PLANE_ID		
		where s.STDNT_PARANT_ID = @parent_id  and s.STDNT_CLASS_FEE_ID != @PLAN_FEE_ID and s.STDNT_STATUS = 'T'


		select Id,Name from FeeYearlyPlan where BrId = @PLAN_FEE_BR_ID and PlanStatus = 1

		select * from VFeeYearlyPlanDef where BrId = @PLAN_FEE_BR_ID and PlanStatus = 1 and IsDeleted = 0

		select top(1) FromMonth,ToMonth,InstallmentId,FeeFormula from FEE_COLLECT f
		join STUDENT_INFO s on s.STDNT_CLASS_FEE_ID = @PLAN_FEE_ID and f.FEE_COLLECT_STD_ID = s.STDNT_ID
		join PLAN_FEE pf on pf.PLAN_FEE_ID = s.STDNT_CLASS_FEE_ID
		join FeeYearlyPlanDef yd on yd.PId = pf.PLAN_FEE_YEARLY_PLAN_ID and FromMonth = DATEPART(MM,DATEADD(MM,1,FEE_COLLECT_FEE_TO_DATE)) and IsDeleted = 0 


		order by FEE_COLLECT_FEE_FROM_DATE desc


     END
     
     
 
 
 ELSE if @STATUS = 'A'
     BEGIN
   
   select f.*,s.STDNT_ID as [Student ID], s.STDNT_FIRST_NAME + ' ' + s.STDNT_LAST_NAME as [Student Name], s.STDNT_SCHOOL_ID as [School ID], p.CLASS_Name as [Class Name] from VPLAN_FEE f
    LEFT join STUDENT_INFO s on s.STDNT_CLASS_FEE_ID = f.ID
	Left join SCHOOL_PLANE p on p.CLASS_ID = s.STDNT_CLASS_PLANE_ID
     where [Institute ID] = @PLAN_FEE_HD_ID   
    and  [Branch ID] = @PLAN_FEE_BR_ID
   
     select * from PLAN_FEE_DEF
     
     
     END  
 
 
     END