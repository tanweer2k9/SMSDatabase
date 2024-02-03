CREATE PROCEDURE  [dbo].[sp_SHORT_LEAVE_deletion]
                                               
                                               
          @STATUS char(10),
          @SHORT_LEAVE_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from SHORT_LEAVE
 
 
     where 
          SHORT_LEAVE_ID =  @SHORT_LEAVE_ID 
 
end