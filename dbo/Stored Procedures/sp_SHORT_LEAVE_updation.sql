create procedure  [dbo].[sp_SHORT_LEAVE_updation]
                                               
                                               
          @SHORT_LEAVE_ID  numeric,
          @SHORT_LEAVE_STAFF_ID  numeric,
          @SHORT_LEAVE_DATE  date,
          @SHORT_LEAVE_FROM_TIME  nvarchar(100) ,
          @SHORT_LEAVE_TO_TIME  nvarchar(100) ,
          @SHORT_LEAVE_REASON  nvarchar(100) ,
          @SHORT_LEAVE_STATUS  char(2) 
   
   
     as begin 
   
   
     update SHORT_LEAVE
 
     set
          SHORT_LEAVE_STAFF_ID =  @SHORT_LEAVE_STAFF_ID,
          SHORT_LEAVE_DATE =  @SHORT_LEAVE_DATE,
          SHORT_LEAVE_FROM_TIME =  @SHORT_LEAVE_FROM_TIME,
          SHORT_LEAVE_TO_TIME =  @SHORT_LEAVE_TO_TIME,
          SHORT_LEAVE_REASON =  @SHORT_LEAVE_REASON,
          SHORT_LEAVE_STATUS =  @SHORT_LEAVE_STATUS
 
     where 
          SHORT_LEAVE_ID =  @SHORT_LEAVE_ID 
 
end