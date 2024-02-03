CREATE PROCEDURE  [dbo].[sp_DEGREE_INFO_deletion]
                                               
                                               
          @STATUS char(10),
		  @DEFINITION_ID  numeric
   
     AS
   
   
     --delete from DEGREE_INFO
   if @STATUS = 'D'
     BEGIN
     delete from DEGREE_INFO
      where      
         DGRE_ID = @DEFINITION_ID 
      END
         
      else
      BEGIN   
     
     update DEGREE_INFO
     Set
     
		DGRE_STATUS = 'D' 
   
     where 
     
         DGRE_ID = @DEFINITION_ID  
 
end