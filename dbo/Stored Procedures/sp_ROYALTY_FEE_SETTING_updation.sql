CREATE procedure  [dbo].[sp_ROYALTY_FEE_SETTING_updation]
                                               
                                               
          @ROYALTY_ID  numeric,
          @ROYALTY_BR_ID  numeric,
          @ROYALTY_FEE_ID  int,
          @ROYALTY_PERCENTAGE  numeric(18,2)
   
   
     as begin 
   
   
     update ROYALTY_FEE_SETTING
 
     set
          ROYALTY_FEE_ID =  @ROYALTY_FEE_ID,
          ROYALTY_PERCENTAGE =  @ROYALTY_PERCENTAGE
 
     where 
          ROYALTY_ID =  @ROYALTY_ID and 
          ROYALTY_BR_ID =  @ROYALTY_BR_ID 
 
end