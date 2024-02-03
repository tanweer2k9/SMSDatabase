CREATE procedure  [dbo].[usp_FeeYearlyPlanSelection]
                                               
		@STATUS char(10),
     @Id  numeric,
     @HdId  numeric,
     @BrId  numeric
   
   
   
     AS BEGIN 
   
   
		SELECT Id ID, Name, PlanStatus Status, CreateDate, CreatedBy, UpdatedDate, UpdateBy FROM FeeYearlyPlan WHERE HdId =  @HdId and BrId =  @BrId 
		select INSTALLMENT_ID Id, INSTALLMENT_NAME Name From INSTALLMENT_INFO where INSTALLMENT_HD_ID = @HdId and INSTALLMENT_BR_ID =@BrId and INSTALLMENT_STATUS = 'T' order by INSTALLMENT_RANK

     if @STATUS = 'L'
     BEGIN	    
		SELECT Id, PId, InstallmentId, FromMonth, ToMonth, FeeFormula, IsDeleted FROM FeeYearlyPlanDef WHERE Id = 0 and IsDeleted = 0
     END  
     
	 if @STATUS = 'A'
     BEGIN
		SELECT Id, PId, InstallmentId, FromMonth, ToMonth, FeeFormula, IsDeleted FROM FeeYearlyPlanDef WHERE PId = @Id and IsDeleted = 0
 
     END
 
     END