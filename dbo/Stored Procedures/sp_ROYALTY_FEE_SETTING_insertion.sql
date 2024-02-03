CREATE procedure  [dbo].[sp_ROYALTY_FEE_SETTING_insertion]
                                               
                                               
          @ROYALTY_BR_ID  numeric,
          @ROYALTY_FEE_ID  int,
          @ROYALTY_PERCENTAGE  numeric(18,2)
   
   
     as  begin
   
   
     insert into ROYALTY_FEE_SETTING
     values
     (
        @ROYALTY_BR_ID,
        @ROYALTY_FEE_ID,
        @ROYALTY_PERCENTAGE
     
     
     )
     
end