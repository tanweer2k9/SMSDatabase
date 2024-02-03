CREATE procedure  [dbo].[sp_ALLOWANCE_insertion]
                                               
                                               
          @ALLOWANCE_HD_ID  numeric,
          @ALLOWANCE_BR_ID  numeric,
          @ALLOWANCE_NAME  nvarchar(200) ,
          @ALLOWANCE_DESCRIPTION  nvarchar(50),
          @ALLOWANCE_DATE  date,
          @ALLOWANCE_STATUS  nvarchar(10) 
   
   
     as  begin
   
   
     insert into ALLOWANCE
     values
     (
        @ALLOWANCE_HD_ID,
        @ALLOWANCE_BR_ID,
        @ALLOWANCE_NAME,
        @ALLOWANCE_DESCRIPTION,
        @ALLOWANCE_DATE,
        @ALLOWANCE_STATUS
     
     
     )
     
end