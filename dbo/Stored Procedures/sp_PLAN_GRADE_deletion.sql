CREATE PROCEDURE  [dbo].[sp_PLAN_GRADE_deletion]
                                               
                                               
          @STATUS char(2),
          @P_GRADE_ID  numeric,
          @P_GRADE_HD_ID  numeric,
          @P_GRADE_BR_ID  numeric
         
   
     AS 
      if @STATUS ='U'
     BEGIN 
   
   
     update  PLAN_GRADE
     
     set P_GRADE_STATUS = 'D'
 
 
     where 
          
          P_GRADE_ID =  @P_GRADE_ID and 
          P_GRADE_HD_ID =  @P_GRADE_HD_ID and 
          P_GRADE_BR_ID =  @P_GRADE_BR_ID 
 
 update PLAN_GRADE_DEF
 
 set DEF_GRADE_STATUS = 'D'
 
 where DEF_P_ID = @P_GRADE_ID
 
end