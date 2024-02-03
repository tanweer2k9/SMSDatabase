create procedure  [dbo].[sp_EXAM_STD_INFO_insertion]
                                               
                                               
          @EXAM_STD_INFO_STD_ID  nchar(10) ,
          @EXAM_STD_INFO_HEIGHT  numeric,
          @EXAM_STD_INFO_WEIGHT  numeric,
          @EXAM_STD_INFO_DAYS_ATTENDED  int,
          @EXAM_STD_INFO_DAYS_ABSENT  int
   
   
     as  begin

   
     insert into EXAM_STD_INFO
     values
     (
        @EXAM_STD_INFO_STD_ID,
        @EXAM_STD_INFO_HEIGHT,
        @EXAM_STD_INFO_WEIGHT,
        @EXAM_STD_INFO_DAYS_ATTENDED,
        @EXAM_STD_INFO_DAYS_ABSENT,
		0,'','',0
     
     
     )
     
end