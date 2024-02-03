    CREATE procedure  usp_FeeYearlyPlanDef_insertion
                                               
                                               
          @PId  numeric,
          @InstallmentId  numeric,
          @FromMonth  int,
          @ToMonth  int,
          @FeeFormula  float
		  
   
   
     as  
   
   
     insert into FeeYearlyPlanDef
     values
     (
        @PId,
        @InstallmentId,
        @FromMonth,
        @ToMonth,
        @FeeFormula,
		CAST(0 as bit)
     
     
     )