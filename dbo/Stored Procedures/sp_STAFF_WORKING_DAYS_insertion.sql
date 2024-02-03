CREATE procedure  [dbo].[sp_STAFF_WORKING_DAYS_insertion]
                                               
                                               
          @STAFF_WORKING_DAYS_HD_ID  numeric,
          @STAFF_WORKING_DAYS_BR_ID  numeric,
          @STAFF_WORKING_DAYS_NAME  nvarchar(200),
          @STAFF_WORKING_DAYS_DAY_STATUS  char(2) ,
          @STAFF_WORKING_DAYS_TIME_IN  nvarchar(100) ,
          @STAFF_WORKING_DAYS_TIME_OUT  nvarchar(100) ,
          @STAFF_WORKING_DAYS_USER  nvarchar(100) ,
          @STAFF_WORKING_DAYS_STAFF_ID  numeric,
          @STAFF_WORKING_DAYS_DATE  datetime,
          @STAFF_WORKING_DAYS_STATUS  char(2) ,
		  @STAFF_WORKING_DAYS_PACKAGE_ID numeric
   
   
     as  begin
   
   
     insert into STAFF_WORKING_DAYS
     values
     (
        @STAFF_WORKING_DAYS_HD_ID,
        @STAFF_WORKING_DAYS_BR_ID,
        @STAFF_WORKING_DAYS_NAME,
        @STAFF_WORKING_DAYS_DAY_STATUS,
        @STAFF_WORKING_DAYS_TIME_IN,
        @STAFF_WORKING_DAYS_TIME_OUT,
        @STAFF_WORKING_DAYS_USER,
        @STAFF_WORKING_DAYS_STAFF_ID,
        @STAFF_WORKING_DAYS_DATE,
		@STAFF_WORKING_DAYS_PACKAGE_ID,
        @STAFF_WORKING_DAYS_STATUS
		
     
     
     )
     
end