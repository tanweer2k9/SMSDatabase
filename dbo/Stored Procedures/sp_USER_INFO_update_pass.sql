CREATE procedure  [dbo].[sp_USER_INFO_update_pass]                                           
          @USER_ID  numeric,                   
          @USER_PASSWORD  nvarchar(50)
        
   
     as begin 
   

	


     update USER_INFO 
     set
         USER_PASSWORD = @USER_PASSWORD
 
     where 
          [USER_ID] =  @USER_ID
        
       select 'ok'
        
end