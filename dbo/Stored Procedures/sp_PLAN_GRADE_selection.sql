CREATE procedure  [dbo].[sp_PLAN_GRADE_selection]
                                               
                                               
     @STATUS char(2),
     @P_GRADE_ID  numeric,
     @P_GRADE_HD_ID  numeric,
     @P_GRADE_BR_ID  numeric
   
   
     AS BEGIN 
     SELECT * FROM V_PLAN_GRADES
     where [Institute id] = @P_GRADE_HD_ID and
     [Branch ID] = @P_GRADE_BR_ID and 
     [Plan Status] !='D'       
   
     if @STATUS = 'A'
     BEGIN

 
     
     Select ID,[Lower Limit],[Lower Operator],[Upper Limit],[Upper Operator],[Grade ID] as Grade, Description,Status,[Grade Points]  from V_PLAN_GRADE_DEF 
     where Status  ='A'
     END  
     ELSE if @STATUS = 'B'
     BEGIN
     
 --SELECT * FROM V_PLAN_GRADES
 
 
 --    WHERE
 --    ID =  @P_GRADE_ID and 
 --    [institute id] =  @P_GRADE_HD_ID and 
 --    [Branch ID]=  @P_GRADE_BR_ID and
 --    [Plan Status] != 'D'
     
       Select ID,[Lower Limit],[Lower Operator],[Upper Limit],[Upper Operator],[Grade ID] as Grade, Description,Status,[Grade Points]  from V_PLAN_GRADE_DEF 
     where 
     PID = @P_GRADE_ID and
     Status  !='D' 
 
 
 
 
 
     END
 
     END