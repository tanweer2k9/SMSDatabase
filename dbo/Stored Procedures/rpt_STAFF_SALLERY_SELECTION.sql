

CREATE PROCEDURE [dbo].[rpt_STAFF_SALLERY_SELECTION]

	 @status char(10),
     @STAFF_SALLERY_STAFF_ID  numeric,
     @STAFF_SALLERY_HD_ID  numeric,
     @STAFF_SALLERY_BR_ID  numeric,
	 @STAFF_SALLERY_DATE date

AS
	

	if @status = 'M'
		Begin				
		select *, dbo.fu_REMAINING_LEAVES_LIMIT([Staff ID],@STAFF_SALLERY_DATE,@STAFF_SALLERY_BR_ID,'C') as [Remaining Limit]
,  CONVERT(VARCHAR(20), (CONVERT(varchar, DATENAME(MM, @STAFF_SALLERY_DATE), 100)) + ' ' + CONVERT(varchar, (datepart(yyyy,@STAFF_SALLERY_DATE)))) as [Month Year]   from VSTAFF_SALLERY  
		where 		
		[Institute ID] = @STAFF_SALLERY_HD_ID 
		    and [Branch ID] in (select * from [dbo].[get_centralized_br_id]('S', @STAFF_SALLERY_BR_ID))
		    and datepart(YY,@STAFF_SALLERY_DATE) = datepart(YY,[Month Date])
		    and datepart(MM,@STAFF_SALLERY_DATE) = datepart(MM,[Month Date])
			and ID not in (select STAFF_SALLERY_DEFF_PID from STAFF_SALLERY_DEFF where STAFF_SALLERY_DEFF_AMOUNT_TYPE = 'D' and STAFF_SALLERY_DEFF_AMOUNT > 0 and STAFF_SALLERY_DEFF_NAME in (select DEDUCTION_ID  from DEDUCTION where DEDUCTION_NAME = 'July Salary' and DEDUCTION_BR_ID = @STAFF_SALLERY_BR_ID and DEDUCTION_STATUS = 'T'))
			and [Leaves Type] != 'Not Generate Salary'
			order by [Department Rank]
		    
		--EXEC sp_STAFF_SALLERY_DEFF_SELECTION where [Status] = 'T'

		End
		
	Else if @status = 'B'
		Begin				
		select *,dbo.fu_REMAINING_LEAVES_LIMIT([Staff ID],@STAFF_SALLERY_DATE,@STAFF_SALLERY_BR_ID,'C') as [Remaining Limit]
,  CONVERT(VARCHAR(20), (CONVERT(varchar, DATENAME(MM, @STAFF_SALLERY_DATE), 100)) + ' ' + CONVERT(varchar, (datepart(yyyy,@STAFF_SALLERY_DATE)))) as [Month Year]  from VSTAFF_SALLERY
		where [Staff ID]  = @STAFF_SALLERY_STAFF_ID and [Institute ID] = @STAFF_SALLERY_HD_ID and
		    [Branch ID] in (select * from [dbo].[get_centralized_br_id]('S', @STAFF_SALLERY_BR_ID))  and datepart(YY,@STAFF_SALLERY_DATE) = datepart(YY,[Month Date])
		    and datepart(MM,@STAFF_SALLERY_DATE) = datepart(MM,[Month Date])
			and ID not in (select STAFF_SALLERY_DEFF_PID from STAFF_SALLERY_DEFF where STAFF_SALLERY_DEFF_AMOUNT_TYPE = 'D' and STAFF_SALLERY_DEFF_AMOUNT > 0 and STAFF_SALLERY_DEFF_NAME in (select DEDUCTION_ID  from DEDUCTION where DEDUCTION_NAME = 'July Salary' and DEDUCTION_BR_ID = @STAFF_SALLERY_BR_ID and DEDUCTION_STATUS = 'T'))
			and [Leaves Type] != 'Not Generate Salary'
		   order by [Department Rank]
		--EXEC sp_STAFF_SALLERY_DEFF_SELECTION where PID = @STAFF_SALLERY_ID and [Status] = 'T'

		End