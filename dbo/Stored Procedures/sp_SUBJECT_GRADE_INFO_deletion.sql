CREATE PROCEDURE  [dbo].[sp_SUBJECT_GRADE_INFO_deletion]
                                               
                                               
          @STATUS char(10),
          @SUB_GRADE_ID  numeric,
          @SUB_GRADE_HD_ID  numeric,
          @SUB_GRADE_BR_ID  numeric
   
   
     AS BEGIN 
   
   update SUBJECT_GRADE_INFO set SUB_GRADE_STATUS = 'D'
 
 
     where 
          SUB_GRADE_ID =  @SUB_GRADE_ID and 
          SUB_GRADE_HD_ID =  @SUB_GRADE_HD_ID and 
          SUB_GRADE_BR_ID =  @SUB_GRADE_BR_ID 
 
end