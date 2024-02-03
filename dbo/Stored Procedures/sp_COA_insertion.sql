CREATE procedure  [dbo].[sp_COA_insertion]
                                               
                                               
          @COA_HD_ID  numeric,
          @COA_BR_ID  numeric,
          @COA_NAME  nvarchar(200) ,
          @COA_TYPE  char ,
          @COA_PARENT_ID  numeric,
          @COA_STATUS  char(2) 
   
   
     as  begin
   
   
     insert into COA
     values
     (
        @COA_HD_ID,
        @COA_BR_ID,
        @COA_NAME,
        @COA_TYPE,
        @COA_PARENT_ID,
        @COA_STATUS
     
     
     )
     
end