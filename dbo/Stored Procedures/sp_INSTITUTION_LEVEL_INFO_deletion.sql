CREATE PROCEDURE  [dbo].[sp_INSTITUTION_LEVEL_INFO_deletion]
                                               
                                               
          @INST_LEVEL_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from INSTITUTION_LEVEL_INFO
 
 
     where 
          INST_LEVEL_ID =  @INST_LEVEL_ID 
 
end