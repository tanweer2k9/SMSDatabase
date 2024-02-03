CREATE PROCEDURE  [dbo].[sp_RELIGION_INFO_deletion]
                                               
                                               
          @STATUS char(10),
		  @DEFINITION_ID  numeric
   
     AS  
   
   
     --delete from RELIGION_INFO
     if @STATUS = 'D'
     BEGIN
     delete from RELIGION_INFO
      where      
         RELIGION_ID = @DEFINITION_ID 
      END
         
      else
      BEGIN   
     
     update RELIGION_INFO
     Set
     
		RELIGION_STATUS = 'D' 
     where      
         RELIGION_ID = @DEFINITION_ID  
 
end