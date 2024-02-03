
 CREATE PROC [dbo].[usp_FeePlanInsertion]

  @STDNT_DISCOUNT_RULE_ID numeric,
  @STDNT_HD_ID numeric,
  @STDNT_BR_ID numeric,
  @STDNT_FIRST_NAME nvarchar(50)
 AS
 
  Declare @fee_max numeric   
 --This will always be zero because Now Fees will be insert in Fee Plan
	 set @STDNT_DISCOUNT_RULE_ID = 0

	 if @STDNT_DISCOUNT_RULE_ID > 0
		 BEGIN
			insert into PLAN_FEE select @STDNT_HD_ID, @STDNT_BR_ID, @STDNT_FIRST_NAME, 0,'T',1.2,1,1,'',1,NULL
			set @fee_max = (select SCOPE_IDENTITY())
		
			insert into PLAN_FEE_DEF 
			select @fee_max, d.DIS_RUL_DEF_FEE_ID,d.DIS_RUL_DEF_DISCOUNT,0,0,'T',ISNULL(Operation,'T'), CASE WHEN [Fee Type] like '%Once%' THEN 'F' ELSE 'N' END 
			 from VFEE_INFO f
			 join DISCOUNT_RULES_DEF d on d.DIS_RUL_DEF_FEE_ID = f.ID		 
			 where Status = 'T'	 and d.DIS_RUL_DEF_PID = @STDNT_DISCOUNT_RULE_ID
			and [Institute ID] = @STDNT_HD_ID and [Branch ID] = @STDNT_BR_ID
		END
	ELSE
		BEGIN
			insert into PLAN_FEE select @STDNT_HD_ID, @STDNT_BR_ID, @STDNT_FIRST_NAME, 0,'T',1.2,1,1,'',1,NULL
			set @fee_max = (select SCOPE_IDENTITY())
			insert into PLAN_FEE_DEF select @fee_max, ID,0,0,0,'T',ISNULL(Operation,'T'),CASE WHEN [Fee Type] like '%Once%' THEN 'F' ELSE 'N' END from VFEE_INFO	where Status = 'T'	and [Branch ID] = @STDNT_BR_ID 
			
		END

		select @fee_max