create procedure  [dbo].[sp_TEST_INFO_updation]
                                               
                                               
          @TEST_ID  numeric,
          @TEST_HD_ID  numeric,
          @TEST_BR_ID  numeric,
          @TEST_NAME  nvarchar(50) ,
          @TEST_DESC  nvarchar(500) ,
          @TEST_STATUS  char(2) 
   
   
     as begin 
   
   
     update TEST_INFO
 
     set
          TEST_NAME =  @TEST_NAME,
          TEST_DESC =  @TEST_DESC,
          TEST_STATUS =  @TEST_STATUS
 
     where 
          TEST_ID =  @TEST_ID and 
          TEST_HD_ID =  @TEST_HD_ID and 
          TEST_BR_ID =  @TEST_BR_ID 
 
end