CREATE PROCEDURE  [dbo].[sp_HOUSES_INFO_deletion]
                                               
                                               
          @STATUS char(10),
          @HOUSES_ID  numeric,
          @HOUSES_HD_ID  numeric,
          @HOUSES_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     update HOUSES_INFO
 
	set HOUSES_STATUS = 'D'
     where 
          HOUSES_ID =  @HOUSES_ID
          
 
end