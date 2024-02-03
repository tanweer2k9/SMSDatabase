create procedure  [dbo].[sp_STAFF_LATE_TIME_DEDUCTION_insertion]
                                               
                                               
          @DEDUCTION_STAFF_ID  numeric,
          @DEDUCTION_FROM_TIME  nvarchar(50) ,
          @DEDUCTION_TO_TIME  nvarchar(50) ,
          @DEDUCTION_PERCENT_SALARY  float
   
   
     as  begin
   
      
     insert into STAFF_LATE_TIME_DEDUCTION
     values
     (        
        @DEDUCTION_STAFF_ID,
        @DEDUCTION_FROM_TIME,
        @DEDUCTION_TO_TIME,
        @DEDUCTION_PERCENT_SALARY
     
     
     )
     
end