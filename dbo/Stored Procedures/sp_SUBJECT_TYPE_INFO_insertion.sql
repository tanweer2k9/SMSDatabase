create procedure  [dbo].[sp_SUBJECT_TYPE_INFO_insertion]
                                               
                                               
          @SUBJECT_TYPE_HD_ID  numeric,
          @SUBJECT_TYPE_BR_ID  numeric,
          @SUBJECT_TYPE_NAME  nvarchar(50) ,
          @SUBJECT_TYPE_DESC  nvarchar(500) ,
          @SUBJECT_TYPE_STATUS  char(2) 
   
   
     as  begin
   
   
     insert into SUBJECT_TYPE_INFO
     values
     (
        @SUBJECT_TYPE_HD_ID,
        @SUBJECT_TYPE_BR_ID,
        @SUBJECT_TYPE_NAME,
        @SUBJECT_TYPE_DESC,
        @SUBJECT_TYPE_STATUS
     
     
     )
     
end