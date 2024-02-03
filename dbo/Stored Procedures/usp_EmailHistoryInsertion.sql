CREATE PROC usp_EmailHistoryInsertion
                                               
                                               
          @BrId  numeric,
          @ToEmail  nvarchar(100) ,
          @Name  nvarchar(100) ,
          @FromDate  datetime,
          @ToDate  datetime,
          @EmailModule  nvarchar(100) ,
          @Body  nvarchar(MAX) ,
          @BCC  nvarchar(200) ,
          @CC  nvarchar(200) ,
          @CreatedDate  datetime,
          @Status  nvarchar(50) ,
          @Error  nvarchar(1000) 
   
   
     as  
   
   
     insert into EmailHistory
     values
     (
        @BrId,
        @ToEmail,
        @Name,
        @FromDate,
        @ToDate,
        @EmailModule,
        @Body,
        @BCC,
        @CC,
        @CreatedDate,
        @Status,
        @Error
     
     
     )