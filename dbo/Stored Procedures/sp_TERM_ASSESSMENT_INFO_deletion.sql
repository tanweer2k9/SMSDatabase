CREATE PROCEDURE  [dbo].[sp_TERM_ASSESSMENT_INFO_deletion]
                                               
                                               
          @STATUS char(10),
		  @DEFINITION_ID  numeric
   
     AS  
   
   
     --delete from TERM_ASSESS_INFO
     if @STATUS = 'D'
     BEGIN
     delete from TERM_ASSESSMENT_INFO
      where      
         TERM_ASSESS_ID = @DEFINITION_ID 
      END
         
      else
      BEGIN   
     
     update TERM_ASSESSMENT_INFO
     Set
     
		TERM_ASSESS_STATUS = 'D' 
     where      
         TERM_ASSESS_ID = @DEFINITION_ID  
 
end