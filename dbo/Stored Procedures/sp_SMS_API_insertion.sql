CREATE procedure  [dbo].[sp_SMS_API_insertion]                                               
          
                                               
          @SMS_API_NAME  nvarchar(200) ,
          @SMS_API_BRAND_NAME  nvarchar(100) ,
          @SMS_API_USERNAME  nvarchar(100) ,
          @SMS_API_PASSWORD  nvarchar(100),
          @SMS_API_SIGNATURE nvarchar(200)
   
   
     as  begin

     insert into SMS_API
     values
     (        
        @SMS_API_NAME,
        @SMS_API_BRAND_NAME,
        @SMS_API_USERNAME,
        @SMS_API_PASSWORD,
        @SMS_API_SIGNATURE
     )
     
end

select SCOPE_IDENTITY()