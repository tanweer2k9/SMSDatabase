CREATE procedure  [dbo].[sp_WORKING_HOURS_PACKAGES_insertion]
                                               
                                               
          @HOURS_PACK_HD_ID  numeric,
          @HOURS_PACK_BR_ID  numeric,
          @HOURS_PACK_NAME  nvarchar(100) ,
          @HOURS_PACK_STATUS  char(2) 
   
   
     as  begin
   
   
     insert into WORKING_HOURS_PACKAGES
     values
     (
        @HOURS_PACK_HD_ID,
        @HOURS_PACK_BR_ID,
        @HOURS_PACK_NAME,
        @HOURS_PACK_STATUS
     
     
     )

	 select SCOPE_IDENTITY()
     
end