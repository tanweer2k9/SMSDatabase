CREATE procedure  [dbo].[sp_COA_selection]
                                               
                                               
     @STATUS char(10),
     @COA_ID  numeric,
     @COA_HD_ID  numeric,
     @COA_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     IF @STATUS = 'L'
     BEGIN
   
     SELECT * FROM COA where 
     COA_HD_ID =  @COA_HD_ID and 
     COA_BR_ID =  @COA_BR_ID AND
     COA_STATUS != 'D' 
     END  
     --select radio button from transaction category
     ELSE IF @STATUS = 'R'
     BEGIN
     SELECT COA_TYPE, COA_NAME FROM COA where 
     COA_HD_ID =  @COA_HD_ID and 
     COA_BR_ID =  @COA_BR_ID AND
     COA_ID = @COA_ID
     END
     ELSE 
     
     BEGIN
  SELECT * FROM COA
 
 
     WHERE
     COA_ID =  @COA_ID and 
     COA_HD_ID =  @COA_HD_ID and 
     COA_BR_ID =  @COA_BR_ID AND
     COA_STATUS != 'D' 
 
     END
 
     END