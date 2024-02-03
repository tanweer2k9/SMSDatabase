CREATE PROCEDURE  [dbo].[sp_YEAR_INFO_deletion]
                                               
                                               
          @STATUS char(10),
		  @DEFINITION_ID  numeric
   
     AS  
   
   
     --delete from YEAR_INFO
     if @STATUS = 'D'
     BEGIN
     delete from YEAR_INFO
      where      
         YEAR_ID = @DEFINITION_ID 
      END
         
      else
      BEGIN   
     
     update YEAR_INFO
     Set
     
		YEAR_STATUS = 'D' 
     where      
         YEAR_ID = @DEFINITION_ID  
 
end