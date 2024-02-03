CREATE PROCEDURE  [dbo].[sp_DATE_INFO_deletion]
                     
          @STATUS char(10),
          @DATE_ID  numeric
         
   
     AS 
   
	if @STATUS = 'D'
   BEGIN 
     delete from DATE_INFO
 
     where 
          
          DATE_ID =  @DATE_ID        
 
end