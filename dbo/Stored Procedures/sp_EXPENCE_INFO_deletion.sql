CREATE PROCEDURE  [dbo].[sp_EXPENCE_INFO_deletion]
                                               
                                               
          @STATUS char(10),
		  @DEFINITION_ID  numeric
   
     AS      
     --delete from EXPENCE_INFO
      if @STATUS = 'D'
     BEGIN
     delete from EXPENCE_INFO
      where      
         EXPENCE_ID = @DEFINITION_ID 
      END
         
      else
      BEGIN   
     
     update EXPENCE_INFO
     Set
     
		EXPENCE_STATUS = 'D' 
 
     where 
     
         EXPENCE_ID = @DEFINITION_ID  
 
end