create procedure  [dbo].[sp_FEE_ADVANCE_DEF_selection]
                                               
                                               
     @STATUS char(10),
     @ADV_FEE_DEF_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   
     SELECT * FROM FEE_ADVANCE_DEF
     END  
     ELSE
     BEGIN
  SELECT * FROM FEE_ADVANCE_DEF
 
 
     WHERE
     ADV_FEE_DEF_ID =  @ADV_FEE_DEF_ID 
 
     END
 
     END