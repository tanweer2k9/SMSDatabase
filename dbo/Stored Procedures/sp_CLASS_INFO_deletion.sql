CREATE PROCEDURE  [dbo].[sp_CLASS_INFO_deletion]
                                               
                                               
          @STATUS char(10),
		  @DEFINITION_ID  numeric
   
     AS  
   
   
     --delete from CLASS_INFO
     if @STATUS = 'D'
     BEGIN
     delete from CLASS_INFO
      where      
         CLASS_ID = @DEFINITION_ID 
      END
         
      else
      BEGIN   
     
     update CLASS_INFO
     Set
     
		CLASS_STATUS = 'D' 
     where      
         CLASS_ID = @DEFINITION_ID  
 
end