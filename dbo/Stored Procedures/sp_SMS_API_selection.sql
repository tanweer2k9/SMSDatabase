CREATE procedure  [dbo].[sp_SMS_API_selection]
                                               
                                               
     @STATUS char(10),
     @SMS_API_ID  numeric,
     @SMS_API_BR_ID numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   
     	select SMS_API_ID as ID, SMS_API_NAME as Name, SMS_API_BRAND_NAME as [Brand Name], SMS_API_USERNAME as [User Name],
	SMS_API_PASSWORD as [Password], SMS_API_SIGNATURE as [Signature] from SMS_API where SMS_API_ID in (select BR_ADM_SMS_API_ID from BR_ADMIN where BR_ADM_ID = @SMS_API_BR_ID)
     END  
     ELSE
     BEGIN
  SELECT * FROM SMS_API
 
 
     WHERE
     SMS_API_ID =  @SMS_API_ID 
 
     END
 
     END