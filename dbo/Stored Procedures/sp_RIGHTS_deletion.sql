CREATE  procedure  [dbo].[sp_RIGHTS_deletion]
                                               
	 @STATUS char(10),
     @RIGHTS_HD_ID  numeric,
     @RIGHTS_BR_ID numeric, 
     @RIGHTS_IS_DELETED  bit,
     @RIGHTS_ROLE nvarchar(100),
     @RIGHTS_ADMIN_LEVEL numeric,
     @RIGHTS_STATUS bit
     
     AS 
   
   
   if @STATUS = 'D'
   begin
   delete from RIGHTS where RIGHTS_ROLE = @RIGHTS_ROLE
   end
 
 
 else if @STATUS = 'R'
	delete from RIGHTS where RIGHTS_ROLE = @RIGHTS_ROLE and RIGHTS_RIGHT_PARENTS_CODE = '-1'
   
   else
   
   update RIGHTS set 
   RIGHTS_IS_DELETED  = 1
     
     where
   
         RIGHTS_HD_ID = @RIGHTS_HD_ID
      AND RIGHTS_BR_ID = @RIGHTS_BR_ID
      and  RIGHTS_ROLE = @RIGHTS_ROLE 
      and  RIGHTS_ADMIN_LEVEL = @RIGHTS_ADMIN_LEVEL
     
     
      --  SELECT RIGHTS_RIGHT_PARENTS_CODE , RIGHTS_RIGHT_CODE ,RIGHTS_RIGHT_TEXT ,RIGHTS_LEVEL ,RIGHTS_RIGHT_NAME , RIGHTS_IS_BUTTON ,RIGHTS_STATUS FROM RIGHTS
      --where  RIGHTS_ROLE = 'C'