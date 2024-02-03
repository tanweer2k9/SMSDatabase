CREATE PROCEDURE  [dbo].[sp_SHIFT_INFO_deletion]
                                               
                                               
          @STATUS char(10),
		  @DEFINITION_ID  numeric
   
     AS
     --delete from SHIFT_INFO
      if @STATUS = 'D'
     BEGIN
     delete from SHIFT_INFO
      where      
         SHFT_ID = @DEFINITION_ID 
      END
         
      else
      BEGIN   
     
     update SHIFT_INFO
     Set
     
		SHFT_STATUS = 'D' 
 
     where 
     
        SHFT_ID = @DEFINITION_ID  
 
end