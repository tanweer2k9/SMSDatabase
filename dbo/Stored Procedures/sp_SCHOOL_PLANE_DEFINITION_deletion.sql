CREATE PROCEDURE  [dbo].[sp_SCHOOL_PLANE_DEFINITION_deletion]
                                               

          @DEF_ID  numeric
   
   
     AS BEGIN 
   

   declare @count int = 0

   set @count = (select COUNT(*) from EXAM_DEF where EXAM_DEF_CLASS_ID = @DEF_ID and EXAM_DEF_STATUS != 'D')

   if @count = 0
   begin
		   update EXAM_DEF
			   set 
					EXAM_DEF_STATUS = 'D'
			   where
					EXAM_DEF_CLASS_ID = @DEF_ID
   
			update SCHOOL_PLANE_DEFINITION
 
			 set          
				  DEF_STATUS =  'D'
 
			 where 
				  DEF_ID =  @DEF_ID 

			select 'ok'
	end
	else
		select 'use'

end