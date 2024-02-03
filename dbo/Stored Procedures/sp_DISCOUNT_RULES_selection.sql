
CREATE procedure  [dbo].[sp_DISCOUNT_RULES_selection]
                                               
                                               
     @STATUS char(10),
     @DIS_RUL_ID  numeric,
     @DIS_RUL_HD_ID  numeric,
     @DIS_RUL_BR_ID  numeric
   
   
     AS BEGIN 
   
   if @STATUS = 'L'
     BEGIN  
     
	 
	 SELECT ROW_NUMBER() over (order by (select 0)) as ID, ID as [Fee ID],0 Fee FROM VFEE_INFO 
	 where Status = 'T' and [Institute ID] = @DIS_RUL_HD_ID and [Branch ID] = @DIS_RUL_BR_ID

	 SELECT * FROM VDISCOUNT_RULES
	where
		 [Institute ID] = @DIS_RUL_HD_ID  and
		[Branch ID] = @DIS_RUL_BR_ID and 
		Status != 'D'



     END  
     ELSE
     BEGIN
			SELECT ID, [Fee ID],Fee FROM VDISCOUNT_RULES_DEF
			WHERE
			PID =  @DIS_RUL_ID
 
		SELECT * FROM VDISCOUNT_RULES
			where
			[Institute ID] = @DIS_RUL_HD_ID  and
			[Branch ID] = @DIS_RUL_BR_ID and 
			Status != 'D'

     END
 

 	 select ID, Name from VFEE_INFO
	 where 
		[Institute ID] = @DIS_RUL_HD_ID  and
		[Branch ID] = @DIS_RUL_BR_ID and 
		Status = 'T'

	select ID, Name from VSCHOOL_PLANE
	where 
	[Institute ID] = @DIS_RUL_HD_ID and
	[Branch ID] = @DIS_RUL_BR_ID
	and
		Status	= 'T' and [Session Id] = (select BR_ADM_SESSION from BR_ADMIN where BR_ADM_ID = @DIS_RUL_BR_ID)
		order by [Order]


     END