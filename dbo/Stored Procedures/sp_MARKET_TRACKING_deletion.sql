CREATE PROCEDURE  [dbo].[sp_MARKET_TRACKING_deletion]
                                               
                                               
          @STATUS char(10),
          @TRACK_ID  numeric,
          @TRACK_HD_ID  numeric,
          @TRACK_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     update MARKET_TRACKING set TRACK_STATUS = 'D'
 
 
     where 
          TRACK_ID =  @TRACK_ID 
end