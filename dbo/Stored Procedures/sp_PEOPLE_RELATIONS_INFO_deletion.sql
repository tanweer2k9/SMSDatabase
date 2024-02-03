create PROCEDURE  [dbo].[sp_PEOPLE_RELATIONS_INFO_deletion]
                                               
                                               
          @STATUS char(10),
		  @DEFINITION_ID  numeric
   
     AS  
   
   
     --delete from PEOPLE_RELATIONS_INFO
     if @STATUS = 'D'
     BEGIN
     delete from PEOPLE_RELATIONS_INFO
      where      
         PEOPLE_RELATIONS_ID = @DEFINITION_ID 
      END
         
      else
      BEGIN   
     
     update PEOPLE_RELATIONS_INFO
     Set
     
		PEOPLE_RELATIONS_STATUS = 'D' 
     where      
         PEOPLE_RELATIONS_ID = @DEFINITION_ID  
 
end