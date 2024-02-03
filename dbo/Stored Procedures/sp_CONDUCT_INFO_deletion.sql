CREATE PROCEDURE  [dbo].[sp_CONDUCT_INFO_deletion]
                                               
                                               
          @STATUS char(10),
          @CONDUCT_ID  numeric,
          @CONDUCT_HD_ID  numeric,
          @CONDUCT_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     update CONDUCT_INFO
 set CONDUCT_STATUS = 'D'
 
     where 
          CONDUCT_ID =  @CONDUCT_ID          
 
end