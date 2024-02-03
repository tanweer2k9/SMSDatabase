CREATE PROCEDURE  [dbo].[sp_SUBJECT_INFO_deletion]
                                               
                                               
          @STATUS char(10),
		  @DEFINITION_ID  numeric
   
     AS
     --delete from SUBJECT_INFO
 
      if @STATUS = 'D'
     BEGIN
     delete from SUBJECT_INFO
      where      
         SUB_ID = @DEFINITION_ID 
      END
         
      else
      BEGIN   
     
     update SUBJECT_INFO
     Set
     
		SUB_STATUS = 'D' 
     where 
     
         SUB_ID = @DEFINITION_ID  
 
end