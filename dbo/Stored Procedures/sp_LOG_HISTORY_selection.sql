create procedure  [dbo].[sp_LOG_HISTORY_selection]
                                               
                                               
     @STATUS char(10),
     @LOG_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   
     SELECT * FROM LOG_HISTORY
     END  
     
     ELSE  if @STATUS = 'B'
     BEGIN		
     SELECT * FROM LOG_HISTORY 
     WHERE         
     LOG_ID =  @LOG_ID 
 
     END
 
     END