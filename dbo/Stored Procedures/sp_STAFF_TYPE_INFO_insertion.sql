create procedure  [dbo].[sp_STAFF_TYPE_INFO_insertion]
                                               
                                               
          @STAFF_TYPE_HD_ID  numeric,
          @STAFF_TYPE_BR_ID  numeric,
          @STAFF_TYPE_NAME  nvarchar(50) ,
          @STAFF_TYPE_DESC  nvarchar(500) ,
          @STAFF_TYPE_STATUS  char(2) 
   
   
     as  begin
   
   
     insert into STAFF_TYPE_INFO
     values
     (
        @STAFF_TYPE_HD_ID,
        @STAFF_TYPE_BR_ID,
        @STAFF_TYPE_NAME,
        @STAFF_TYPE_DESC,
        @STAFF_TYPE_STATUS
     
     
     )
     
end