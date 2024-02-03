create procedure  [dbo].[sp_STAFF_OVERTIME_SALARY_selection]
                                               
                                               
     @STATUS char(10),
     @OVRTM_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   
     SELECT * FROM STAFF_OVERTIME_SALARY
     END  
     ELSE
     BEGIN
  SELECT * FROM STAFF_OVERTIME_SALARY
 
 
     WHERE
     OVRTM_ID =  @OVRTM_ID 
 
     END
 
     END