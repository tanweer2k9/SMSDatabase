CREATE PROCEDURE  [dbo].[sp_LOG_HISTORY_deletion]
                                               
                                               
          @STATUS char(10),
          @LOG_ID  numeric
   
   
     AS BEGIN 
   
		if(@STATUS = 'D')
		
	 begin
     delete from LOG_HISTORY
     where         
          LOG_ID =  @LOG_ID 
	end
	
end