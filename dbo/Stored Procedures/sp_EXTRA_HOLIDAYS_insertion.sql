
 
     CREATE procedure  [dbo].[sp_EXTRA_HOLIDAYS_insertion]
                                               
                                               
          @STAFF_ID  numeric,
          @PID  numeric,
          @DATE  date,
          @TIME_IN  nvarchar(50) ,
          @TIME_OUT  nvarchar(50) ,
          @IS_SALARY_GENERATED  bit
   
   
     as  begin
   
   
     insert into EXTRA_HOLIDAYS
     values
     (
        @STAFF_ID,
        @PID,
        @DATE,
        @TIME_IN,
        @TIME_OUT,
        @IS_SALARY_GENERATED
     
     
     )

	 END