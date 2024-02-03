CREATE procedure  [dbo].[sp_COA_updation]
                                               
                                               
          @COA_ID  numeric,
          @COA_HD_ID  numeric,
          @COA_BR_ID  numeric,
          @COA_NAME  nvarchar(200) ,
          @COA_TYPE  char(1) ,          
          @COA_STATUS  char(2) 
   
   
     as begin 
   
   
     update COA
 
     set
          COA_NAME =  @COA_NAME,
          COA_TYPE =  @COA_TYPE,          
          COA_STATUS =  @COA_STATUS
 
     where 
          COA_ID =  @COA_ID and 
          COA_HD_ID =  @COA_HD_ID and 
          COA_BR_ID =  @COA_BR_ID 
 
end