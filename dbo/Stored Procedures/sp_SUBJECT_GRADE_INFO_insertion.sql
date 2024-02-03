create procedure  [dbo].[sp_SUBJECT_GRADE_INFO_insertion]
                                               
                                               
          @SUB_GRADE_HD_ID  numeric,
          @SUB_GRADE_BR_ID  numeric,
          @SUB_GRADE_NAME  nvarchar(50) ,
          @SUB_GRADE_DESC  nvarchar(500) ,
          @SUB_GRADE_STATUS  char(2) 
   
   
     as  begin
   
   
     insert into SUBJECT_GRADE_INFO
     values
     (
        @SUB_GRADE_HD_ID,
        @SUB_GRADE_BR_ID,
        @SUB_GRADE_NAME,
        @SUB_GRADE_DESC,
        @SUB_GRADE_STATUS
     
     
     )
     
end