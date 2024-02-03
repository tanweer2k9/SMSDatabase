CREATE PROCEDURE  [dbo].[sp_DOC_INFO_deletion]
                                               
                                               
          @STATUS char(10),
          @DOC_INFO_ID  numeric
         
   
   
     AS BEGIN 
   
    update DOC_INFO 
	set 
	
	DOC_INFO_STATUS = 'D'
 
	where
          DOC_INFO_ID =  @DOC_INFO_ID
        
end