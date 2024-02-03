
CREATE procedure  [dbo].[sp_DESIGNATION_INFO_updation]
                                               
                                               
          @DEFINITION_ID  numeric,
          @DEFINITION_HD_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(1) 
   
   
   
     as begin 
   
  declare @designation nvarchar(50) = (select DESIGNATION_NAME from DESIGNATION_INFO where DESIGNATION_ID = @DEFINITION_ID)

   if @designation != @DEFINITION_NAME
   BEGIN
		update ATTENDANCE_STAFF set ATTENDANCE_STAFF_TYPE = @DEFINITION_NAME where ATTENDANCE_STAFF_TYPE = @designation
		update TEACHER_INFO set TECH_DESIGNATION = @DEFINITION_NAME where TECH_DESIGNATION = @designation
   END

   
     update DESIGNATION_INFO
 
     set
         
          DESIGNATION_HD_ID =  @DEFINITION_HD_ID,
          DESIGNATION_NAME =  @DEFINITION_NAME,
          DESIGNATION_DESC =  @DEFINITION_DESC,
          DESIGNATION_STATUS =  @DEFINITION_STATUS
 
 where 
 
	DESIGNATION_ID = @DEFINITION_ID
 
 
end