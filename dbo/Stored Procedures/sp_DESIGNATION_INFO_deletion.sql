CREATE PROCEDURE  [dbo].[sp_DESIGNATION_INFO_deletion]
                                               
                                               
          @STATUS char(10),
		  @DEFINITION_ID  numeric
   
     AS
   
   
     --delete from DESIGNATION_INFO
     
      if @STATUS = 'D'
     BEGIN
     delete from DESIGNATION_INFO
      where      
         DESIGNATION_ID = @DEFINITION_ID 
      END
         
      else
      BEGIN   
     
     update DESIGNATION_INFO
     Set
     
		DESIGNATION_STATUS = 'D' 
 
     where 
     
         DESIGNATION_ID = @DEFINITION_ID  
 
end