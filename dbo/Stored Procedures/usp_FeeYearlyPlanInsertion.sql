     CREATE procedure  usp_FeeYearlyPlanInsertion
                                               
                                               
          @HdId  numeric,
          @BrId  numeric,
          @Name  nvarchar(100) ,
          @PlanStatus  bit,
          @CreateDate  datetime,
          @CreatedBy  numeric,
          @UpdatedDate  datetime,
          @UpdateBy  numeric,
		  @Id numeric
   
   
     as  
   
   
   if @Id = 0
   BEGIN
     insert into FeeYearlyPlan
     values
     (
        @HdId,
        @BrId,
        @Name,
        @PlanStatus,
        @CreateDate,
        @CreatedBy,
        NULL,
        NULL
     
     
     )
	  select SCOPE_IDENTITY()
   END

   ELSE
   BEGIN
		 update FeeYearlyPlan
 
		set
          Name =  @Name,
          PlanStatus =  @PlanStatus,         
          UpdatedDate =  @UpdatedDate,
          UpdateBy =  @UpdateBy
 
		 where 
          Id =  @Id 

	select @Id

   END