CREATE PROCEDURE  [dbo].[sp_LANG_INFO_deletion]
                                               
                                               
          @STATUS char(10),
		  @DEFINITION_ID  numeric
   
     AS  
   
   
     --delete from LANG_INFO
     if @STATUS = 'D'
     BEGIN
     delete from LANG_INFO
      where      
         LANG_ID = @DEFINITION_ID 
      END
         
      else
      BEGIN   
     
     update LANG_INFO
     Set
     
		LANG_STATUS = 'D' 
     where      
         LANG_ID = @DEFINITION_ID  
 
end