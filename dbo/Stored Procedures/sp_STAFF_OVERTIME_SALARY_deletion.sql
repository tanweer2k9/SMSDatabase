CREATE PROCEDURE  [dbo].[sp_STAFF_OVERTIME_SALARY_deletion]
                                               
                                               
          @STATUS char(10),
          @OVRTM_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from STAFF_OVERTIME_SALARY
 
 
     where 
          OVRTM_ID =  @OVRTM_ID 
 
end