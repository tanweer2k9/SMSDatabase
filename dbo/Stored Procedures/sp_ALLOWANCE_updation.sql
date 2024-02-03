--     *****************************************************************************************************************************************************************
 
     CREATE procedure  [dbo].[sp_ALLOWANCE_updation]
                                               
                                               
          @ALLOWANCE_ID  numeric,
          @ALLOWANCE_HD_ID  numeric,
          @ALLOWANCE_BR_ID  numeric,
          @ALLOWANCE_NAME  nvarchar(200) ,
          @ALLOWANCE_DESCRIPTION  nvarchar(50),
          @ALLOWANCE_DATE  date,
          @ALLOWANCE_STATUS  nvarchar(10) 
   
   
     as begin 
   
   
     update ALLOWANCE
 
     set
          ALLOWANCE_NAME =  @ALLOWANCE_NAME,
          ALLOWANCE_DESCRIPTION =  @ALLOWANCE_DESCRIPTION,
          ALLOWANCE_DATE =  @ALLOWANCE_DATE,
          ALLOWANCE_STATUS =  @ALLOWANCE_STATUS
 
     where 
          ALLOWANCE_ID =  @ALLOWANCE_ID and 
          ALLOWANCE_HD_ID =  @ALLOWANCE_HD_ID and 
          ALLOWANCE_BR_ID =  @ALLOWANCE_BR_ID 
 
end