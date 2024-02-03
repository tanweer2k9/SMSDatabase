CREATE PROCEDURE  [dbo].[sp_PARENT_INFO_deletion]
                                               
                                               
          @STATUS char(10),
          @PARNT_ID  numeric,
          @PARNT_HD_ID  numeric,
          @PARNT_BR_ID  numeric
   
   
     AS BEGIN 
   
    if @STATUS = 'D'
      
     BEGIN
     delete from PARENT_INFO
      where      
         PARNT_ID = @PARNT_ID         
      
      delete from USER_INFO
      where USER_CODE = @PARNT_ID
      
      END
         
     
      else
      BEGIN        
     update PARENT_INFO
     Set     
		PARNT_STATUS = 'D'  
     where      
        PARNT_ID = @PARNT_ID  
        
         update USER_INFO
     Set     
		USER_STATUS = 'D'  
     where      
        USER_CODE = @PARNT_ID           
		 --and PARNT_HD_ID =  @PARNT_HD_ID and 
   --       PARNT_BR_ID =  @PARNT_BR_ID 
 
 
	end

end