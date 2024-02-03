 
     CREATE PROCEDURE  sp_LEAVES_RECORD_deletion
                                               
                                               
          @STATUS char(10),
          @LEAVES_RECORD_ID  numeric,
          @LEAVES_RECORD_HD_ID  numeric,
          @LEAVES_RECORD_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from LEAVES_RECORD
 
 
     where 
          LEAVES_RECORD_ID =  @LEAVES_RECORD_ID 
end