CREATE procedure  [dbo].[sp_WORKING_HOURS_PACKAGES_DEF_insertion]
                                               
                                               
          @WORK_PACK_DEF_PID  numeric,
          @WORK_PACK_DEF_DAY_NAME  nvarchar(50) ,
          @WORK_PACK_DEF_DAY_STATUS  char(1) ,
          @WORK_PACK_DEF_TIME_IN  nvarchar(50) ,
          @WORK_PACK_DEF_TIME_OUT  nvarchar(50) 
   
   
     as  begin
   
   
     insert into WORKING_HOURS_PACKAGES_DEF
     values
     (
        @WORK_PACK_DEF_PID,
        @WORK_PACK_DEF_DAY_NAME,
        @WORK_PACK_DEF_DAY_STATUS,
        @WORK_PACK_DEF_TIME_IN,
        @WORK_PACK_DEF_TIME_OUT
     
     
     )


	 update STAFF_WORKING_DAYS set STAFF_WORKING_DAYS_TIME_IN = @WORK_PACK_DEF_TIME_IN, STAFF_WORKING_DAYS_TIME_OUT = @WORK_PACK_DEF_TIME_OUT, STAFF_WORKING_DAYS_STATUS =@WORK_PACK_DEF_DAY_STATUS  where STAFF_WORKING_DAYS_PACKAGE_ID = @WORK_PACK_DEF_PID and STAFF_WORKING_DAYS_NAME = @WORK_PACK_DEF_DAY_NAME
     
end