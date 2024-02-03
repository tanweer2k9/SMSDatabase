CREATE procedure  [dbo].[sp_SUBJECT_INFO_insertion]
                                               
                                               
          @DEFINITION_HD_ID  numeric,
          @DEFINITION_BR_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(1) ,
		  @SUB_CODE nvarchar(50),
		  @SUB_CREDIT_HOURS int
   
   
   
     as  begin
   
  
   
     insert into SUBJECT_INFO
     values
     (
       
        @DEFINITION_HD_ID,
        @DEFINITION_BR_ID,
        @DEFINITION_NAME,
        @DEFINITION_DESC,
        @DEFINITION_STATUS,
		@SUB_CODE,
		@SUB_CREDIT_HOURS
     
     )
     
end