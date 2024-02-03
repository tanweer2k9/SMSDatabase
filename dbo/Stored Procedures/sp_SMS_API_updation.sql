CREATE procedure  [dbo].[sp_SMS_API_updation]
                                               
                                               
          @SMS_API_ID  numeric,
          @SMS_API_NAME  nvarchar(200) ,
          @SMS_API_BRAND_NAME  nvarchar(100) ,
          @SMS_API_USERNAME  nvarchar(100) ,
          @SMS_API_PASSWORD  nvarchar(100),
          @SMS_API_SIGNATURE nvarchar(200) 
   
   
     as begin 
   
   
     update SMS_API
 
     set
          SMS_API_NAME =  @SMS_API_NAME,
          SMS_API_BRAND_NAME =  @SMS_API_BRAND_NAME,
          SMS_API_USERNAME =  @SMS_API_USERNAME,
          SMS_API_PASSWORD =  @SMS_API_PASSWORD,
          SMS_API_SIGNATURE = @SMS_API_SIGNATURE
 
     where 
          SMS_API_ID =  @SMS_API_ID 
 
end