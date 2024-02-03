create PROCEDURE  [dbo].[sp_TRANSPORT_INFO_deletion]
                                               
                                               
          @STATUS char(10),
		  @DEFINITION_ID  numeric
   
     AS  
   
   
     --delete from TRANSPORT_INFO
     if @STATUS = 'D'
     BEGIN
     delete from TRANSPORT_INFO
      where      
         TRANSPORT_ID = @DEFINITION_ID 
      END
         
      else
      BEGIN   
     
     update TRANSPORT_INFO
     Set
     
		TRANSPORT_STATUS = 'D' 
     where      
         TRANSPORT_ID = @DEFINITION_ID  
 
end