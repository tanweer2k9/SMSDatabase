CREATE procedure  [dbo].[sp_SUPER_ADMIN_INFO_insertion]
                                               
                                               
          @SUPER_ADMIN_NAME  nvarchar(100) ,
          @SUPER_ADMIN_MOBILE_NO  nvarchar(15) ,
          @SUPER_ADMIN_STATUS  char(2) 
   
   
     as  begin
   
      
   
     insert into SUPER_ADMIN_INFO
     values
     (       
        @SUPER_ADMIN_NAME,
        @SUPER_ADMIN_MOBILE_NO,
        @SUPER_ADMIN_STATUS
     )
     
end