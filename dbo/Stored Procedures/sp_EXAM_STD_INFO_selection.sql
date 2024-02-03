create procedure  [dbo].[sp_EXAM_STD_INFO_selection]
                                               
                                               
     @STATUS char(10),
     @EXAM_STD_INFO_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   
     SELECT * FROM EXAM_STD_INFO
     END  
     
 
     END