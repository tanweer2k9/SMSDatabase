CREATE PROCEDURE  [dbo].[sp_NATIONALITY_INFO_deletion]
                                               
                                               
          @STATUS char(10),
		  @DEFINITION_ID  numeric
   
     AS  
   
   
     --delete from NATIONALITY_INFO
     if @STATUS = 'D'
     BEGIN
     delete from NATIONALITY_INFO
      where      
         NATIONALITY_ID = @DEFINITION_ID 
      END
         
      else
      BEGIN   
     
     update NATIONALITY_INFO
     Set
     
		NATIONALITY_STATUS = 'D' 
     where      
         NATIONALITY_ID = @DEFINITION_ID  
 
end