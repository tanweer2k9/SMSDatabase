create procedure  [dbo].[sp_TEST_INFO_insertion]
                                               
                                               
          @TEST_HD_ID  numeric,
          @TEST_BR_ID  numeric,
          @TEST_NAME  nvarchar(50) ,
          @TEST_DESC  nvarchar(500) ,
          @TEST_STATUS  char(2) 
   
   
     as  begin
   
   
     insert into TEST_INFO
     values
     (
        @TEST_HD_ID,
        @TEST_BR_ID,
        @TEST_NAME,
        @TEST_DESC,
        @TEST_STATUS
     
     
     )
     
end