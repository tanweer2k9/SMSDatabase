CREATE PROCEDURE  [dbo].[sp_MARKETING_MODE_INFO_deletion]
                                               
                                               
          @STATUS char(10),
          @MODE_ID  numeric,
          @MODE_HD_ID  numeric,
          @MODE_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     update MARKETING_MODE_INFO set MODE_STATUS = 'D'
 
 
     where 
          MODE_ID =  @MODE_ID
 
end