CREATE procedure  usp_FeeMonthlyPlanSelection
                                               
		@STATUS char(10),
     @Id  numeric,
     @HdId  numeric,
     @BrId  numeric
   
   
   
     AS BEGIN 
   
   
		SELECT * FROM FeeMonthlyPlan WHERE HdId =  @HdId and BrId =  @BrId and PlanStatus = 1
		select * From INSTALLMENT_INFO where INSTALLMENT_HD_ID = @HdId and INSTALLMENT_BR_ID =@BrId and INSTALLMENT_STATUS = 'T'

     if @STATUS = 'L'
     BEGIN	    
		SELECT * FROM FeeMonthlyPlanDef WHERE Id = 0
     END  
     
	 if @STATUS = 'A'
     BEGIN
		SELECT * FROM FeeMonthlyPlanDef WHERE Id = @Id
 
     END
 
     END