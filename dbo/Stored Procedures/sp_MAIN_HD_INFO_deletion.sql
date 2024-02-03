CREATE PROCEDURE  [dbo].[sp_MAIN_HD_INFO_deletion]
          @STATUS char(10),
          @MAIN_INFO_ID  numeric
     AS BEGIN 
   
   if @STATUS = 'D'
	begin
		delete from MAIN_HD_INFO
		where 
          MAIN_INFO_ID =  @MAIN_INFO_ID 
	end
     
 Else if @STATUS = 'U'
	begin
		update MAIN_HD_INFO
		set MAIN_INFO_STATUS = 'D'
		where 
          MAIN_INFO_ID =  @MAIN_INFO_ID 
	end
   
 
     
 
end