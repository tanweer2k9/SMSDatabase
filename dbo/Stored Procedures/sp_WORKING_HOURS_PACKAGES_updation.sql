CREATE procedure  [dbo].[sp_WORKING_HOURS_PACKAGES_updation]
                                               
                                               
          @HOURS_PACK_ID  numeric,
          @HOURS_PACK_HD_ID  numeric,
          @HOURS_PACK_BR_ID  numeric,
          @HOURS_PACK_NAME  nvarchar(100) ,
          @HOURS_PACK_STATUS  char(2) 
   
   
     as begin 
   
   
     update WORKING_HOURS_PACKAGES
 
     set
          HOURS_PACK_NAME =  @HOURS_PACK_NAME,
          HOURS_PACK_STATUS =  @HOURS_PACK_STATUS
 
     where 
          HOURS_PACK_ID =  @HOURS_PACK_ID

 
end