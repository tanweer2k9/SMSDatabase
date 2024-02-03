CREATE procedure  [dbo].[sp_STUDENT_ELECTIVE_SUBJECT_updation]
                                               
                                               
          @STD_ELE_SUB_ID  numeric,
          @STD_ELE_SUB_STDNT_ID  numeric,
          @STD_ELE_SUB_SUBJECT_ID  numeric
   
   
     as begin 
   
   
     update STUDENT_ELECTIVE_SUBJECT
 
     set
          STD_ELE_SUB_SUBJECT_ID =  @STD_ELE_SUB_SUBJECT_ID
 
     where 
          STD_ELE_SUB_ID =  @STD_ELE_SUB_ID and 
          STD_ELE_SUB_STDNT_ID =  @STD_ELE_SUB_STDNT_ID 
 
end