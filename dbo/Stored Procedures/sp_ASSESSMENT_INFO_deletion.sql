CREATE PROCEDURE  [dbo].[sp_ASSESSMENT_INFO_deletion]
                                               
                                               
          @STATUS char(10),
		  @DEFINITION_ID  numeric
   
     AS  
   
   
     --delete from ASSESSMENT_INFO
     if @STATUS = 'D'
     BEGIN
     delete from ASSESSMENT_INFO
      where      
         ASSESSMENT_ID = @DEFINITION_ID 
      END
         
      else
      BEGIN   
     
     update ASSESSMENT_INFO
     Set
     
		ASSESSMENT_STATUS = 'D' 
     where      
         ASSESSMENT_ID = @DEFINITION_ID  
 
end