CREATE PROCEDURE  [dbo].[sp_STUDENT_FEE_NOTES_deletion]
                                               
                                               
          @STATUS char(10),
          @STD_FEE_NOTES_ID  numeric,
          @STD_FEE_NOTES_HD_ID  numeric,
          @STD_FEE_NOTES_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     UPDATE STUDENT_FEE_NOTES
     SET STD_FEE_NOTES_STATUS = 'D'
 
 
     where 
          STD_FEE_NOTES_ID =  @STD_FEE_NOTES_ID and 
          STD_FEE_NOTES_HD_ID =  @STD_FEE_NOTES_HD_ID and 
          STD_FEE_NOTES_BR_ID =  @STD_FEE_NOTES_BR_ID 
 
end