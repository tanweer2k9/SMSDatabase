CREATE procedure  [dbo].[sp_SUBJECT_TYPE_INFO_selection]
                                               
                                               
     @STATUS char(10),
     @SUBJECT_TYPE_ID  numeric,
     @SUBJECT_TYPE_HD_ID  numeric,
     @SUBJECT_TYPE_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   
     SELECT SUBJECT_TYPE_ID as ID, SUBJECT_TYPE_NAME as Name, SUBJECT_TYPE_DESC as Desciption, SUBJECT_TYPE_STATUS as [Status] FROM SUBJECT_TYPE_INFO where SUBJECT_TYPE_STATUS != 'D'
     END  
     ELSE
     BEGIN
  SELECT * FROM SUBJECT_TYPE_INFO
 
 
     WHERE
     SUBJECT_TYPE_ID =  @SUBJECT_TYPE_ID and 
     SUBJECT_TYPE_HD_ID =  @SUBJECT_TYPE_HD_ID and 
     SUBJECT_TYPE_BR_ID =  @SUBJECT_TYPE_BR_ID 
 
     END
 
     END