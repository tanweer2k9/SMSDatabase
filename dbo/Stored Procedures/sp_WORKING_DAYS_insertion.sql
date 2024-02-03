CREATE procedure  [dbo].[sp_WORKING_DAYS_insertion]
          @WORKING_DAYS_HD_ID  numeric,
          @WORKING_DAYS_BR_ID  numeric,
          @WORKING_DAYS_NAME  nvarchar(50) ,
          @WORKING_DAYS_VALUE  bit,
          @WORKING_DAYS_STATUS  nchar(10),
          @WORKING_DAYS_DEPENDENCE CHAR(2)   
     as  begin   
     
     set @WORKING_DAYS_BR_ID  = (select max(BR_ADM_ID) from BR_ADMIN where BR_ADM_HD_ID = @WORKING_DAYS_HD_ID and BR_ADM_STATUS = 'T')
     set @WORKING_DAYS_BR_ID =  ( select isnull (@WORKING_DAYS_BR_ID ,0) )
     
     insert into WORKING_DAYS 
     values
     (
        @WORKING_DAYS_HD_ID,
        @WORKING_DAYS_BR_ID,
        @WORKING_DAYS_NAME,
        @WORKING_DAYS_VALUE,
        @WORKING_DAYS_STATUS,
        @WORKING_DAYS_DEPENDENCE     
     )
     
end