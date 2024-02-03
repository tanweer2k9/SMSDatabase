CREATE procedure  [dbo].[sp_WORKING_DAYS_updation]
        
          @WORKING_DAYS_HD_ID  numeric,
          @WORKING_DAYS_BR_ID  numeric,
          @WORKING_DAYS_NAME  nvarchar(50) ,
          @WORKING_DAYS_VALUE  bit,
          @WORKING_DAYS_STATUS  nchar(10),
          @WORKING_DAYS_DEPENDENCE CHAR(2) 
   
   
     as begin 
   
   
     update WORKING_DAYS
 
     set          
          WORKING_DAYS_VALUE =  @WORKING_DAYS_VALUE,
          WORKING_DAYS_STATUS =  @WORKING_DAYS_STATUS,
          WORKING_DAYS_DEPENDENCE = @WORKING_DAYS_DEPENDENCE
 
     where 
          WORKING_DAYS_NAME =  @WORKING_DAYS_NAME and
          WORKING_DAYS_HD_ID =  @WORKING_DAYS_HD_ID and 
          WORKING_DAYS_BR_ID =  @WORKING_DAYS_BR_ID 
 
end