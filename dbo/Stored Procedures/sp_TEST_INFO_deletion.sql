CREATE PROCEDURE  [dbo].[sp_TEST_INFO_deletion]
                                               
                                               
          @STATUS char(10),
          @TEST_ID  numeric,
          @TEST_HD_ID  numeric,
          @TEST_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     update TEST_INFO set TEST_STATUS = 'D'
 
 
     where 
          TEST_ID =  @TEST_ID and 
          TEST_HD_ID =  @TEST_HD_ID and 
          TEST_BR_ID =  @TEST_BR_ID 
 
end