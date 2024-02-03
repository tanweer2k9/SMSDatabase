create procedure  [dbo].[sp_STAFF_TYPE_INFO_updation]
                                               
                                               
          @STAFF_TYPE_ID  numeric,
          @STAFF_TYPE_HD_ID  numeric,
          @STAFF_TYPE_BR_ID  numeric,
          @STAFF_TYPE_NAME  nvarchar(50) ,
          @STAFF_TYPE_DESC  nvarchar(500) ,
          @STAFF_TYPE_STATUS  char(2) 
   
   
     as begin 
   
   
     update STAFF_TYPE_INFO
 
     set
          STAFF_TYPE_NAME =  @STAFF_TYPE_NAME,
          STAFF_TYPE_DESC =  @STAFF_TYPE_DESC,
          STAFF_TYPE_STATUS =  @STAFF_TYPE_STATUS
 
     where 
          STAFF_TYPE_ID =  @STAFF_TYPE_ID and 
          STAFF_TYPE_HD_ID =  @STAFF_TYPE_HD_ID and 
          STAFF_TYPE_BR_ID =  @STAFF_TYPE_BR_ID 
 
end