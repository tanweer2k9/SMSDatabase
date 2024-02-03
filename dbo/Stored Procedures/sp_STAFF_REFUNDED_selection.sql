CREATE procedure  [dbo].[sp_STAFF_REFUNDED_selection]
                                               
                                               
     @STATUS char(10),
     @STAFF_REFUNDED_STAFF_ID  numeric,
     @STAFF_REFUNDED_HD_ID  numeric,
     @STAFF_REFUNDED_BR_ID  numeric
   
   
     AS BEGIN 
   
   
	if @STATUS = 'L'
	 BEGIN
	 	 
	 	 select * from VTEACHER_INFO
	 where 
    [Institute ID] = @STAFF_REFUNDED_HD_ID
    and  [Branch ID] in (select * from [dbo].[get_centralized_br_id]('S', @STAFF_REFUNDED_BR_ID))
    and [Status] != 'D' order by Ranking
	 

	 select ROW_NUMBER() over (order by (select 0)) as ID, d.DEDUCTION_NAME as Name, (SUM(STAFF_SALLERY_DEFF_AMOUNT) + SUM(STAFF_SALLERY_DEFF_SCHOOL_CONTRIBUTION) ) as Amount, 'Not Refunded' as [Refund Status]
	 
	 from STAFF_SALLERY p
	 join STAFF_SALLERY_DEFF c
	 on c.STAFF_SALLERY_DEFF_PID = p.STAFF_SALLERY_ID
	 join DEDUCTION d
	 on c.STAFF_SALLERY_DEFF_NAME = d.DEDUCTION_ID
	 where p.STAFF_SALLERY_STAFF_ID = @STAFF_REFUNDED_STAFF_ID and
	 p.STAFF_SALLERY_BR_ID in (select * from [dbo].[get_centralized_br_id]('S', @STAFF_REFUNDED_BR_ID)) and
	 p.STAFF_SALLERY_HD_ID = @STAFF_REFUNDED_HD_ID and
	 c.STAFF_SALLERY_DEFF_REFUND_STATUS = 'Not Refunded' and
	 c.STAFF_SALLERY_DEFF_AMOUNT_TYPE = 'D'
	 
	 group by d.DEDUCTION_NAME 	 
	 
    union all
    
  --   select ROW_NUMBER() over (order by (select 0)) as ID, d.DEDUCTION_NAME as Name, (SUM(STAFF_SALLERY_DEFF_AMOUNT) + SUM(STAFF_SALLERY_DEFF_SCHOOL_CONTRIBUTION) ) as Amount, 'Partially Refunded' as [Refund Status]
	 
	 --from STAFF_SALLERY p
	 --join STAFF_SALLERY_DEFF c
	 --on c.STAFF_SALLERY_DEFF_PID = p.STAFF_SALLERY_ID
	 --join DEDUCTION d
	 --on c.STAFF_SALLERY_DEFF_NAME = d.DEDUCTION_ID
	 --where p.STAFF_SALLERY_STAFF_ID = @STAFF_REFUNDED_STAFF_ID and
	 --p.STAFF_SALLERY_BR_ID = @STAFF_REFUNDED_BR_ID and
	 --p.STAFF_SALLERY_HD_ID = @STAFF_REFUNDED_HD_ID and
	 --c.STAFF_SALLERY_DEFF_REFUND_STATUS = 'Partially Refunded'and
	 --c.STAFF_SALLERY_DEFF_AMOUNT_TYPE = 'D'
	 
	 --group by d.DEDUCTION_NAME 	 
   

  --  union all
    
     select ROW_NUMBER() over (order by (select 0)) as ID, d.DEDUCTION_NAME as Name, (SUM(STAFF_SALLERY_DEFF_AMOUNT) + SUM(STAFF_SALLERY_DEFF_SCHOOL_CONTRIBUTION) ) as Amount, 'Refunded' as [Refund Status]
	 
	 from STAFF_SALLERY p
	 join STAFF_SALLERY_DEFF c
	 on c.STAFF_SALLERY_DEFF_PID = p.STAFF_SALLERY_ID
	 join DEDUCTION d
	 on c.STAFF_SALLERY_DEFF_NAME = d.DEDUCTION_ID
	 where p.STAFF_SALLERY_STAFF_ID = @STAFF_REFUNDED_STAFF_ID and
	 p.STAFF_SALLERY_BR_ID in (select * from [dbo].[get_centralized_br_id]('S', @STAFF_REFUNDED_BR_ID)) and
	 p.STAFF_SALLERY_HD_ID = @STAFF_REFUNDED_HD_ID and
	 c.STAFF_SALLERY_DEFF_REFUND_STATUS = 'Refunded'and
	 c.STAFF_SALLERY_DEFF_AMOUNT_TYPE = 'D'
	 
	 group by d.DEDUCTION_NAME 	 

	 
     END
 
     END