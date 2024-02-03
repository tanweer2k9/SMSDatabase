CREATE PROCEDURE  [dbo].[sp_STAFF_TYPE_INFO_deletion]
                                               
                                               
          @STATUS char(10),
          @STAFF_TYPE_ID  numeric,
          @STAFF_TYPE_HD_ID  numeric,
          @STAFF_TYPE_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from STAFF_TYPE_INFO
 
 
     where 
          STAFF_TYPE_ID =  @STAFF_TYPE_ID  

 
end