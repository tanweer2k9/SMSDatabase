CREATE PROCEDURE  [dbo].[sp_DOC_CUSTODIAN_deletion]
                                               
                                               
          @STATUS char(10),
		  @DEFINITION_ID  numeric
   
     AS  
   
   
     --delete from DOC_CUSTODIAN
     if @STATUS = 'D'
     BEGIN
     delete from DOC_CUSTODIAN
      where      
         LANG_ID = @DEFINITION_ID 
      END
         
      else
      BEGIN   
     
     update DOC_CUSTODIAN
     Set
     
		LANG_STATUS = 'D' 
     where      
         LANG_ID = @DEFINITION_ID  
 
end