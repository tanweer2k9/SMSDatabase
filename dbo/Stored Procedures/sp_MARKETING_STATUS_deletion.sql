CREATE PROCEDURE  [dbo].[sp_MARKETING_STATUS_deletion]
                                               
                                               
          @STATUS char(10),
          @MARK_STATUS_ID  numeric,
          @MARK_STATUS_HD_ID  numeric,
          @MARK_STATUS_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     update MARKETING_STATUS set MARK_STATUS = 'D'
 
 
     where 
          MARK_STATUS_ID =  @MARK_STATUS_ID
          
 
end