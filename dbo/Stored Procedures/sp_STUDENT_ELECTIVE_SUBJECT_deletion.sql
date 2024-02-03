CREATE PROCEDURE  [dbo].[sp_STUDENT_ELECTIVE_SUBJECT_deletion]
                                               
                                               
          @STATUS char(10),
          @STD_ELE_SUB_ID  numeric,
          @STD_ELE_SUB_STDNT_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from STUDENT_ELECTIVE_SUBJECT
 
 
     where            
          STD_ELE_SUB_STDNT_ID =  @STD_ELE_SUB_STDNT_ID 
 
end