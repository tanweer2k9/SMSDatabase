CREATE procedure  [dbo].[sp_SUBJECT_INFO_updation]
                                               
                                               
          @DEFINITION_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(2) ,
		  @SUB_CODE nvarchar(50),
		  @SUB_CREDIT_HOURS int
   
   
   
     as begin 
   
   
     update SUBJECT_INFO
 
     set
         
          SUB_NAME =  @DEFINITION_NAME,
          SUB_DESC =  @DEFINITION_DESC,
          SUB_STATUS =  @DEFINITION_STATUS,
		  SUB_CODE = @SUB_CODE,
		  SUB_CREDIT_HOURS = @SUB_CREDIT_HOURS
 
 where 
 
	SUB_ID = @DEFINITION_ID
 
 
end