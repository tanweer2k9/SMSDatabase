CREATE procedure  [dbo].[sp_STUDENT_FEE_NOTES_insertion]
                                               
                                               
          @STD_FEE_NOTES_HD_ID  numeric,
          @STD_FEE_NOTES_BR_ID  numeric,
          @STD_FEE_NOTES_CLASS_ID  numeric,
          @STD_FEE_NOTES_DESCRIPTION  nvarchar(4000) ,
          @STD_FEE_NOTES_STATUS  char(2) 
   
   
     as  begin
   
   
     insert into STUDENT_FEE_NOTES
     values
     (
        @STD_FEE_NOTES_HD_ID,
        @STD_FEE_NOTES_BR_ID,
        @STD_FEE_NOTES_CLASS_ID,
        @STD_FEE_NOTES_DESCRIPTION,
        @STD_FEE_NOTES_STATUS
     
     
     )
     
end