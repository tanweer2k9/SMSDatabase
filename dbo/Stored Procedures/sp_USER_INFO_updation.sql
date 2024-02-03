CREATE procedure  [dbo].[sp_USER_INFO_updation]                                           
          @USER_ID  numeric,          
          @USER_NAME  nvarchar(50) ,
          @USER_DISPLAY_NAME  nvarchar(50) ,
          @USER_TYPE  nvarchar(20) ,
          @USER_PASSWORD  nvarchar(50) ,
          @USER_STATUS  char(2) 
   
     as begin 
   
       declare @count int    
       set @count = 0    
       set @count = ( select count(USER_ID) from USER_INFO  where   
       [USER_NAME] =  @USER_NAME and
       [USER_ID] != @USER_ID
   
   )  
   
     if @count = 0
   
     begin
   
     update USER_INFO 
     set
         
          USER_DISPLAY_NAME =  @USER_DISPLAY_NAME,
          USER_TYPE =  @USER_TYPE,
          USER_STATUS =  @USER_STATUS
 
     where 
          [USER_ID] =  @USER_ID
        
 
      select 'ok'
     
      end
     
      else
     
      begin
     
      select 'This Name is Already Exit. Please Choose Some Other Name!'
     
end
     
end