CREATE PROCEDURE  [dbo].[sp_SUPER_ADMIN_INFO_deletion]
                                               
                                               
          @STATUS char(10),
          @SUPER_ADMIN_ID  numeric
   
   
     AS BEGIN 
   
   
     update SUPER_ADMIN_INFO
     set SUPER_ADMIN_STATUS = 'D'
 
 
     where 
          SUPER_ADMIN_ID =  @SUPER_ADMIN_ID 
 
end