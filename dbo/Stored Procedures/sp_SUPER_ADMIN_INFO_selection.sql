CREATE procedure  [dbo].[sp_SUPER_ADMIN_INFO_selection]
                                               
                                               
     @STATUS char(10),
     @SUPER_ADMIN_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN
   
     SELECT SUPER_ADMIN_ID as ID, SUPER_ADMIN_NAME as Name, SUPER_ADMIN_MOBILE_NO as [Mobile No], SUPER_ADMIN_STATUS as [Status] FROM SUPER_ADMIN_INFO
     where SUPER_ADMIN_STATUS != 'D'
     END  
     ELSE
     BEGIN
  SELECT * FROM SUPER_ADMIN_INFO
 
 
     WHERE
     SUPER_ADMIN_ID =  @SUPER_ADMIN_ID 
 
     END
 
     END