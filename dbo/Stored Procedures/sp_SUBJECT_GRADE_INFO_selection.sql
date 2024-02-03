CREATE procedure  [dbo].[sp_SUBJECT_GRADE_INFO_selection]
                                               
                                               
     @STATUS char(10),
     @SUB_GRADE_ID  numeric,
     @SUB_GRADE_HD_ID  numeric,
     @SUB_GRADE_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   
     SELECT ID, Name, Description, Status FROM VSUBJECT_GRADE_INFO where [Status] != 'D'
     END  
     ELSE
     BEGIN
  SELECT * FROM SUBJECT_GRADE_INFO
 
 
     WHERE
     SUB_GRADE_ID =  @SUB_GRADE_ID and 
     SUB_GRADE_HD_ID =  @SUB_GRADE_HD_ID and 
     SUB_GRADE_BR_ID =  @SUB_GRADE_BR_ID 
 
     END
 
     END