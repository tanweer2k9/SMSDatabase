CREATE procedure  [dbo].[sp_EXAM_ASSESS_CATEGORY_INFO_insertion]
                                               
                                               
          @EXAM_CAT_HD_ID  numeric,
          @EXAM_CAT_BR_ID  numeric,
          @EXAM_CAT_MAIN_CAT_ID  numeric,
          @EXAM_CAT_CLASS_ID  numeric,
          @EXAM_CAT_NAME  nvarchar(100) ,
          @EXAM_CAT_DESC  nvarchar(500) ,
          @EXAM_CAT_STATUS  char(2) ,
		  @EXAM_CAT_ORDER int
   
   
     as  begin
   
   
     insert into EXAM_ASSESS_CATEGORY_INFO
     values
     (
        @EXAM_CAT_HD_ID,
        @EXAM_CAT_BR_ID,
        @EXAM_CAT_MAIN_CAT_ID,
        @EXAM_CAT_CLASS_ID,
        @EXAM_CAT_NAME,
        @EXAM_CAT_DESC,
        @EXAM_CAT_STATUS,
		@EXAM_CAT_ORDER
     
     
     )
     
end