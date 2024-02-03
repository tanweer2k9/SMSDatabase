
     CREATE procedure  [dbo].[sp_EmailHistory_insertion]
                                               
                                               
          @BrId  numeric,
          @ToEmail  nvarchar(100) ,
		  @StdId numeric,
          @StaffId  numeric,
          @FromDate  datetime,
          @ToDate  datetime,
          @EmailModule  nvarchar(100) ,
		  @Subject nvarchar(500),
          @Body  nvarchar(MAX) ,
          @BCC  nvarchar(200) ,
          @CC  nvarchar(200) ,
          @CreatedDate  datetime,
          @Status  nvarchar(50) ,
          @Error  nvarchar(1000) 
          
   
   
     as  begin
   
   
     insert into EmailHistory
     values
     (
        @BrId,
        @ToEmail,
        @StaffId,
		@StdId,
        @FromDate,
        @ToDate,
        @EmailModule,
		@Subject,
        @Body,
        @BCC,
        @CC,
        @CreatedDate,
        @Status,
        @Error
       
     
     
     )
     
end