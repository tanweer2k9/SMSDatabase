CREATE PROCEDURE  [dbo].[sp_DEPARTMENT_INFO_deletion]
                                               
                                               
          @STATUS char(10),
		  @DEFINITION_ID  numeric
   
     AS 
   
    -- delete from DEPARTMENT_INFO
 
   if @STATUS = 'D'
     BEGIN
     delete from DEPARTMENT_INFO
      where      
         DEP_ID = @DEFINITION_ID 
      END
         
      else
      BEGIN   
     
     update DEPARTMENT_INFO
     Set
     
		DEP_STATUS = 'D' 
    
     where 
     
         DEP_ID = @DEFINITION_ID  
 
end