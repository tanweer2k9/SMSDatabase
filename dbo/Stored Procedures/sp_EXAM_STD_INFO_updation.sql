create procedure  [dbo].[sp_EXAM_STD_INFO_updation]
                                               
                                               
          @EXAM_STD_INFO_ID  numeric,
          @EXAM_STD_INFO_STD_ID  nchar(10) ,
          @EXAM_STD_INFO_HEIGHT  numeric,
          @EXAM_STD_INFO_WEIGHT  numeric,
          @EXAM_STD_INFO_DAYS_ATTENDED  int,
          @EXAM_STD_INFO_DAYS_ABSENT  int
   
   
     as begin 
   
   
     update EXAM_STD_INFO
 
     set
          EXAM_STD_INFO_STD_ID =  @EXAM_STD_INFO_STD_ID,
          EXAM_STD_INFO_HEIGHT =  @EXAM_STD_INFO_HEIGHT,
          EXAM_STD_INFO_WEIGHT =  @EXAM_STD_INFO_WEIGHT,
          EXAM_STD_INFO_DAYS_ATTENDED =  @EXAM_STD_INFO_DAYS_ATTENDED,
          EXAM_STD_INFO_DAYS_ABSENT =  @EXAM_STD_INFO_DAYS_ABSENT
 
     where 
          EXAM_STD_INFO_ID =  @EXAM_STD_INFO_ID 
 
end