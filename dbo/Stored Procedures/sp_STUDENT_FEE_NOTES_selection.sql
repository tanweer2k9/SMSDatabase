CREATE procedure  [dbo].[sp_STUDENT_FEE_NOTES_selection]
                                               
                                               
     @STATUS char(10),
     @STD_FEE_NOTES_ID  numeric,
     @STD_FEE_NOTES_HD_ID  numeric,
     @STD_FEE_NOTES_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   
     SELECT STD_FEE_NOTES_ID as ID, STD_FEE_NOTES_CLASS_ID as [Class ID], STD_FEE_NOTES_DESCRIPTION as [Fee Notes] ,STD_FEE_NOTES_STATUS as [Status]
     FROM STUDENT_FEE_NOTES
     where
     STD_FEE_NOTES_HD_ID =  @STD_FEE_NOTES_HD_ID and 
     STD_FEE_NOTES_BR_ID =  @STD_FEE_NOTES_BR_ID  and
     STD_FEE_NOTES_STATUS != 'D'
     
     select CLASS_ID as [Class ID], CLASS_Name as [Class Name] 
     from SCHOOL_PLANE
   where CLASS_STATUS = 'T'
   and CLASS_HD_ID = @STD_FEE_NOTES_HD_ID and CLASS_BR_ID = @STD_FEE_NOTES_BR_ID
     END  
     
 
     END