





CREATE procedure  [dbo].[sp_PLAN_FEE_updation]
                                               
                                               
          @PLAN_FEE_ID  numeric,
          @PLAN_FEE_HD_ID  numeric,
          @PLAN_FEE_BR_ID  numeric,
          @PLAN_FEE_NAME  nvarchar(50) ,
          @PLAN_FEE_TOTAL_FEE  float,
          @PLAN_FEE_STATUS  char(2) ,
		  @PLAN_FEE_FORMULA float,
		  @PLAN_FEE_IS_FORMULA_APPLY bit,
		  @PLAN_FEE_IS_FEE_GENERATE bit,
		  @PLAN_FEE_NOTES nvarchar(MAX),
		  @PLAN_FEE_INSTALLMENT_ID numeric,
		  @PLAN_FEE_TEMPLATE numeric,
		  @PLAN_FEE_TEMPLATE_CHANGE bit,
		  @PLAN_FEE_YEARLY_PLAN_ID numeric
		  
   
   
     as begin 
   


      	if @PLAN_FEE_TEMPLATE_CHANGE = 1
		BEGIN

			update PLAN_FEE_DEF set PLAN_FEE_DEF_STATUS = 'Q' where PLAN_FEE_DEF_PLAN_ID = @PLAN_FEE_ID and PLAN_FEE_DEF_STATUS = 'T'

			 insert into PLAN_FEE_DEF 
			 select @PLAN_FEE_ID,fee_id,fee_amount,Fee_min,Fee_max,[Status],Operation, is_once_paid from

			 	  (select distinct fee_id,fee_amount,Fee_min,Fee_max,[Status],Operation, 
				  CASE WHEN pd.PLAN_FEE_IS_ONCE_PAID is null THEN 
				  CASE WHEN A.[Fee Type] like '%Once%' THEN 'F' ELSE (select 'N') END
				  ELSE pd.PLAN_FEE_IS_ONCE_PAID END as is_once_paid
				  from
				  (select @PLAN_FEE_ID pid, d.DIS_RUL_DEF_FEE_ID fee_id,f.[Fee Type],d.DIS_RUL_DEF_DISCOUNT fee_amount,0 Fee_min,0 Fee_max,'T' [Status],ISNULL(Operation,'T') Operation
				  from VFEE_INFO f
				   join DISCOUNT_RULES_DEF d on d.DIS_RUL_DEF_FEE_ID = f.ID
					where Status = 'T'	 and d.DIS_RUL_DEF_PID = @PLAN_FEE_TEMPLATE
					and [Institute ID] = @PLAN_FEE_HD_ID and [Branch ID] = @PLAN_FEE_BR_ID 
					)A		
					left join 
					(select * from PLAN_FEE_DEF	where PLAN_FEE_DEF_PLAN_ID = @PLAN_FEE_ID and PLAN_FEE_DEF_STATUS = 'Q')pd
					on pd.PLAN_FEE_DEF_FEE_NAME = A.fee_id)B

					delete from PLAN_FEE_DEF where PLAN_FEE_DEF_PLAN_ID = @PLAN_FEE_ID and PLAN_FEE_DEF_STATUS in( 'Q')

			update STUDENT_INFO set STDNT_DISCOUNT_RULE_ID = @PLAN_FEE_TEMPLATE where STDNT_CLASS_FEE_ID = @PLAN_FEE_ID
		END



    if @PLAN_FEE_STATUS = 'C' --means plan fee changed from Plan Fee Classwise Screen 
   BEGIN
	update PLAN_FEE 
		set 
	 
			  
			  PLAN_FEE_FORMULA = @PLAN_FEE_FORMULA,
			  PLAN_FEE_IS_FORMULA_APPLY = @PLAN_FEE_IS_FORMULA_APPLY,
			  PLAN_FEE_IS_FEE_GENERATE = @PLAN_FEE_IS_FEE_GENERATE,
			  PLAN_FEE_NOTES = @PLAN_FEE_NOTES,
			  PLAN_FEE_INSTALLMENT_ID = @PLAN_FEE_INSTALLMENT_ID,
			  PLAN_FEE_YEARLY_PLAN_ID = @PLAN_FEE_YEARLY_PLAN_ID
 
		 where 
			  PLAN_FEE_ID  = @PLAN_FEE_ID

   END
   ELSE
   BEGIN




		
   
		 update PLAN_FEE
 
		 set
			  PLAN_FEE_NAME =  @PLAN_FEE_NAME,
			  PLAN_FEE_TOTAL_FEE =  @PLAN_FEE_TOTAL_FEE,
			  PLAN_FEE_STATUS =  @PLAN_FEE_STATUS,
			  PLAN_FEE_FORMULA = @PLAN_FEE_FORMULA,
			  PLAN_FEE_IS_FORMULA_APPLY = @PLAN_FEE_IS_FORMULA_APPLY,
			  PLAN_FEE_IS_FEE_GENERATE = @PLAN_FEE_IS_FEE_GENERATE,
			  PLAN_FEE_NOTES = @PLAN_FEE_NOTES,
			  PLAN_FEE_INSTALLMENT_ID = @PLAN_FEE_INSTALLMENT_ID,
			  PLAN_FEE_YEARLY_PLAN_ID = @PLAN_FEE_YEARLY_PLAN_ID
 
		 where 
			  PLAN_FEE_ID =  @PLAN_FEE_ID
         
	END --Else @PLAN_FEE_STATUS = 'C'
 
end