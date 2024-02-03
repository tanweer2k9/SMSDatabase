CREATE PROCEDURE  [dbo].[sp_SUBJECT_TYPE_INFO_deletion]
                                               
                                               
          @STATUS char(10),
          @SUBJECT_TYPE_ID  numeric,
          @SUBJECT_TYPE_HD_ID  numeric,
          @SUBJECT_TYPE_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     update SUBJECT_TYPE_INFO set SUBJECT_TYPE_STATUS = 'D'
 
 
     where 
          SUBJECT_TYPE_ID =  @SUBJECT_TYPE_ID and 
          SUBJECT_TYPE_HD_ID =  @SUBJECT_TYPE_HD_ID and 
          SUBJECT_TYPE_BR_ID =  @SUBJECT_TYPE_BR_ID 
 
end