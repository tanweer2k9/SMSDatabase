CREATE procedure  [dbo].[sp_STUDY_CRITERIA_INFO_updation]
                                               
                                               
          @STUDY_CRITERIA_ID  numeric,
          @STUDY_CRITERIA_NAME  nvarchar(50) ,
          @STUDY_CRITERIA_LENGTH  int,
          @STUDY_CRITERIA_FORMAT  nvarchar(50) ,
          @STUDY_CRITERIA_STATUS  bit
        
   
     as begin 
   
   
     update STUDY_CRITERIA_INFO
 
     set
          STUDY_CRITERIA_NAME =  @STUDY_CRITERIA_NAME,
          STUDY_CRITERIA_LENGTH =  @STUDY_CRITERIA_LENGTH,
          STUDY_CRITERIA_FORMAT =  @STUDY_CRITERIA_FORMAT,
          STUDY_CRITERIA_STATUS =  @STUDY_CRITERIA_STATUS
        
     where 
          STUDY_CRITERIA_ID =  @STUDY_CRITERIA_ID 
 
end