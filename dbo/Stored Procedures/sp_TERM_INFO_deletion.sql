create PROCEDURE  [dbo].[sp_TERM_INFO_deletion]
                                               
                                               
          @STATUS char(10),
		  @DEFINITION_ID  numeric
   
     AS  
   
   
     --delete from TERM_INFO
     if @STATUS = 'D'
     BEGIN
     delete from TERM_INFO
      where      
         TERM_ID = @DEFINITION_ID 
      END
         
      else
      BEGIN   
     
     update TERM_INFO
     Set
     
		TERM_STATUS = 'D' 
     where      
         TERM_ID = @DEFINITION_ID  
 
end