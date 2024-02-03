CREATE PROCEDURE  [dbo].[sp_SESSION_INFO_deletion]
                                               
                                               
          @STATUS char(10),
          @SESSION_ID  numeric,
          @SESSION_HD_ID  numeric,
          @SESSION_BR_ID  numeric
   
   
     AS BEGIN 
   
   
   update SESSION_INFO set SESSION_STATUS = 'D'

     --delete from SESSION_INFO
 
 
     where 
        SESSION_ID =  @SESSION_ID 
          
 
end