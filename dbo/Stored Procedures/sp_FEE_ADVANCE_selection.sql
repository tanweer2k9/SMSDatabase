
CREATE procedure  [dbo].[sp_FEE_ADVANCE_selection]
                                               
                                               
     @STATUS char(10),
     @ADV_FEE_ID  numeric,
     @ADV_FEE_STD_ID numeric,
	 @ADV_FEE_FROM_DATE date,
	 @ADV_FEE_TO_DATE date,
	 @HD_ID numeric,
	 @BR_ID numeric
	 
   
   
     AS BEGIN 
		
		
			select f.ID, s.[First Name] as [Student Name], s.[Class Plan], f.[From Date], f.[To Date], f.Amount, f.[Fee Date], f.Status, f.[Std ID] from VFEE_ADVANCE f
			join VSTUDENT_INFO s on s.ID = f.[Std ID]
			where f.[Status] = 'T' and [Branch ID] = @BR_ID
			
			select  * from VSTUDENT_ROLL_NUM  where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID 
			  and  [Status] != 'D' and [Active Status] in ('new','old') order by [Class ID]
			  
			  
		
				select * from(select *,0 PID from [dbo].[ADVANCE_FEE_FORECAST] (@ADV_FEE_STD_ID, @ADV_FEE_FROM_DATE, @ADV_FEE_TO_DATE) where [From Date] not in (select [From Date] from VFEE_ADVANCE_DEF where Adjust != 'D' and PID = @ADV_FEE_ID)
				union
				select * from VFEE_ADVANCE_DEF where Adjust != 'D' and PID = @ADV_FEE_ID)A
				where Amount != 0
				order by [From Date] 
		
		
			--if @STATUS = 'F' -- calculate Advance Fee
			--begin				
			--	select * from [dbo].[ADVANCE_FEE_FORECAST] (@ADV_FEE_STD_ID, @ADV_FEE_FROM_DATE, @ADV_FEE_TO_DATE) where [From Date] not in (select [From Date] from VFEE_ADVANCE_DEF where Adjust != 'D' and PID = @ADV_FEE_ID)
			--	union
			--	select * from VFEE_ADVANCE_DEF where Adjust != 'D' and PID = @ADV_FEE_ID
			--end			
			--else
			--begin
			--	select * from VFEE_ADVANCE_DEF where Adjust != 'D' and PID = @ADV_FEE_ID
			--end
 
     END