CREATE PROCEDURE  [dbo].[sp_EXAM_APPROVAL_SETTINGS_deletion]
                                               
                                               
          @STATUS char(10),
          @APPROVAL_ID  numeric,
          @APPROVAL_HD_ID  numeric,
          @APPROVAL_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from EXAM_APPROVAL_SETTINGS
 
 
     where 
          APPROVAL_ID =  @APPROVAL_ID and 
          APPROVAL_HD_ID =  @APPROVAL_HD_ID and 
          APPROVAL_BR_ID =  @APPROVAL_BR_ID 
 
end