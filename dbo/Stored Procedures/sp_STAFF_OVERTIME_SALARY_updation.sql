create procedure  [dbo].[sp_STAFF_OVERTIME_SALARY_updation]
                                               
                                               
          @OVRTM_ID  numeric,
          @OVRTM_STAFF_ID  numeric,
          @OVRTM_FROM_DATE  date,
          @OVRTM_END_DATE  date,
          @OVRTM_TOTAL_HOURS  float,
          @OVRTM_SHORT_HOURS  float,
          @OVRTM_NET_HOURS  float,
          @OVRTM_PER_HOUR_SALARY  float,
          @OVRTM_TOTAL_SALARY  float
   
   
     as begin 
   
   
     update STAFF_OVERTIME_SALARY
 
     set
          OVRTM_STAFF_ID =  @OVRTM_STAFF_ID,
          OVRTM_FROM_DATE =  @OVRTM_FROM_DATE,
          OVRTM_END_DATE =  @OVRTM_END_DATE,
          OVRTM_TOTAL_HOURS =  @OVRTM_TOTAL_HOURS,
          OVRTM_SHORT_HOURS =  @OVRTM_SHORT_HOURS,
          OVRTM_NET_HOURS =  @OVRTM_NET_HOURS,
          OVRTM_PER_HOUR_SALARY =  @OVRTM_PER_HOUR_SALARY,
          OVRTM_TOTAL_SALARY =  @OVRTM_TOTAL_SALARY
 
     where 
          OVRTM_ID =  @OVRTM_ID 
 
end