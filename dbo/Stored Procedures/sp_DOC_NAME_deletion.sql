CREATE PROCEDURE  [dbo].[sp_DOC_NAME_deletion]
                                               
                                               
          @STATUS char(10),
		  @DEFINITION_ID  numeric
   
     AS  
   
   
     --delete from DOC_NAME
     if @STATUS = 'D'
     BEGIN
     delete from DOC_NAME
      where      
         LANG_ID = @DEFINITION_ID 
      END
         
      else
      BEGIN   
     
     update DOC_NAME
     Set
     
		LANG_STATUS = 'D' 
     where      
         LANG_ID = @DEFINITION_ID  
 
end