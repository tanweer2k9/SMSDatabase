CREATE procedure  [dbo].[sp_WORKING_DAYS_selection]
                                               
                                               
     @STATUS char(10),
     @WORKING_DAYS_ID  numeric,
     @WORKING_DAYS_HD_ID  numeric,
     @WORKING_DAYS_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN
   
     SELECT WORKING_DAYS_ID AS ID, WORKING_DAYS_NAME AS NAME, WORKING_DAYS_VALUE AS VALUE,WORKING_DAYS_DEPENDENCE AS [Dependence]
      FROM WORKING_DAYS
     
     
 
     WHERE      
     WORKING_DAYS_HD_ID =  @WORKING_DAYS_HD_ID and 
     WORKING_DAYS_BR_ID =  @WORKING_DAYS_BR_ID AND
     WORKING_DAYS_STATUS != 'D'
 
     END
 
     END