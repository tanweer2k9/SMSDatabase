CREATE PROCEDURE  [dbo].[sp_USER_INFO_deletion]
                                               
                                               
          @STATUS char(10),
          @USER_ID  numeric
        
   
     AS BEGIN 
   
	if @STATUS = 'D'
	begin
     delete from USER_INFO
     where 
          
          USER_ID =  @USER_ID
	end
end