CREATE procedure  [dbo].[sp_SUPER_ADMIN_INFO_updation]
                                               
                                               
          @SUPER_ADMIN_ID  numeric,
          @SUPER_ADMIN_NAME  nvarchar(100) ,
          @SUPER_ADMIN_MOBILE_NO  nvarchar(15) ,
          @SUPER_ADMIN_STATUS  char(2) 
   
   
     as begin 
   
   
     update SUPER_ADMIN_INFO
 
     set
          SUPER_ADMIN_NAME =  @SUPER_ADMIN_NAME,
          SUPER_ADMIN_MOBILE_NO =  @SUPER_ADMIN_MOBILE_NO,
          SUPER_ADMIN_STATUS =  @SUPER_ADMIN_STATUS
 
     where 
          SUPER_ADMIN_ID =  @SUPER_ADMIN_ID 
 
end