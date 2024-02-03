create procedure  [dbo].[sp_AUTO_SCHEDULE_insertion]
                                               
                                               
          @SCHEDULE_HD_ID  numeric,
          @SCHEDULE_BR_ID  numeric,
          @SCHEDULE_TYPE  nvarchar(50) ,
          @SCHEDULE_TIME  nvarchar(20) ,
          @SCHEDULE_DAY  nvarchar(20) ,
          @SCHEDULE_DATE  nvarchar(50) ,
          @SCHEDULE_STUDENT  bit,
          @SCHEDULE_PARENT  bit,
          @SCHEDULE_STATUS  bit,
          @SCHEDULE_NOTIFICATION_TYPE  nvarchar(50) 
		  
   
     as  begin

	 declare @total numeric
	

	-- if there is value in database already, update... otherwise insert.
   select @total=COUNT(*) from AUTO_SCHEDULE where SCHEDULE_NOTIFICATION_TYPE=@SCHEDULE_NOTIFICATION_TYPE
   and SCHEDULE_HD_ID=@SCHEDULE_HD_ID
		
   

   if @total=0
   begin
   insert into AUTO_SCHEDULE
     values
     (
        @SCHEDULE_HD_ID,
        @SCHEDULE_BR_ID,
        @SCHEDULE_TYPE,
        @SCHEDULE_TIME,
        @SCHEDULE_DAY,
        @SCHEDULE_DATE,
        @SCHEDULE_STUDENT,
        @SCHEDULE_PARENT,
        @SCHEDULE_STATUS,
        @SCHEDULE_NOTIFICATION_TYPE
     
     )
   end

   else
   begin
   update AUTO_SCHEDULE
 
     set
		 
          SCHEDULE_HD_ID =  @SCHEDULE_HD_ID ,
          SCHEDULE_BR_ID =  @SCHEDULE_BR_ID ,
          SCHEDULE_TYPE =  @SCHEDULE_TYPE,
          SCHEDULE_TIME =  @SCHEDULE_TIME,
          SCHEDULE_DAY =  @SCHEDULE_DAY,
          SCHEDULE_DATE =  @SCHEDULE_DATE,
          SCHEDULE_STUDENT =  @SCHEDULE_STUDENT,
          SCHEDULE_PARENT =  @SCHEDULE_PARENT,
          SCHEDULE_STATUS =  @SCHEDULE_STATUS,
          SCHEDULE_NOTIFICATION_TYPE =  @SCHEDULE_NOTIFICATION_TYPE
 
     where 
	      SCHEDULE_NOTIFICATION_TYPE=@SCHEDULE_NOTIFICATION_TYPE
		  and SCHEDULE_HD_ID=@SCHEDULE_HD_ID and SCHEDULE_BR_ID=@SCHEDULE_BR_ID
          
   end

     
     
end