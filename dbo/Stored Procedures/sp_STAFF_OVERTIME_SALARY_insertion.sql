CREATE procedure  [dbo].[sp_STAFF_OVERTIME_SALARY_insertion]
                                               
                                               
          @OVRTM_STAFF_ID  numeric,
          @OVRTM_FROM_DATE  date,
          @OVRTM_END_DATE  date,
          @OVRTM_TOTAL_HOURS  float,
          @OVRTM_SHORT_HOURS  float,
          @OVRTM_NET_HOURS  float,
          @OVRTM_PER_HOUR_SALARY  float,
          @OVRTM_TOTAL_SALARY  float,
		  @OVRTM_PAID float,
		  @OVRTM_PAID_DATE datetime
   
   
     as  begin
   
   
     insert into STAFF_OVERTIME_SALARY
     values
     (
        @OVRTM_STAFF_ID,
        @OVRTM_FROM_DATE,
        @OVRTM_END_DATE,
        @OVRTM_TOTAL_HOURS,
        @OVRTM_SHORT_HOURS,
        @OVRTM_NET_HOURS,
        @OVRTM_PER_HOUR_SALARY,
		@OVRTM_TOTAL_SALARY,
		0,
		0,
        0,
		@OVRTM_PAID,
		@OVRTM_PAID_DATE
     
     )
     
end