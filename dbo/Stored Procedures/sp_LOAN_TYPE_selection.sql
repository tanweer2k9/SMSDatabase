CREATE procedure  [dbo].[sp_LOAN_TYPE_selection]
                                               
                                               
     @STATUS char(10),
     @LOAN_TYPE_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   
     SELECT * FROM LOAN_TYPE
     END  
     ELSE
     BEGIN
  SELECT * FROM LOAN_TYPE
 
 
     WHERE
     LOAN_TYPE_ID =  @LOAN_TYPE_ID 
 
     END
 
     END