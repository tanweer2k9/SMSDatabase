CREATE procedure  [dbo].[sp_STUDENT_ELECTIVE_SUBJECT_insertion]
                                               
                                               
          @STD_ELE_SUB_STDNT_ID  numeric,
          @STD_ELE_SUB_SUBJECT_ID  numeric
   
   
     as  begin
   
   
     insert into STUDENT_ELECTIVE_SUBJECT
     values
     (
        @STD_ELE_SUB_STDNT_ID,
        @STD_ELE_SUB_SUBJECT_ID
     
     
     )
     
end