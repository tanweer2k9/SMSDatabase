CREATE PROCEDURE  [dbo].[sp_SECTION_INFO_deletion]
                                               
                                               
          @STATUS char(10),
		  @DEFINITION_ID  numeric
   
     AS
     --delete from SECTION_INFO
      if @STATUS = 'D'
     BEGIN
     delete from SECTION_INFO
      where      
         SECT_ID = @DEFINITION_ID 
      END
         
      else
      BEGIN   
     
     update SECTION_INFO
     Set
     
		SECT_STATUS = 'D' 
 
     where 
     
        SECT_ID = @DEFINITION_ID  
 
end