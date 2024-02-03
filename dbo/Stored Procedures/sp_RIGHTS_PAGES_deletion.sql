CREATE PROCEDURE  [dbo].[sp_RIGHTS_PAGES_deletion]
                                               
                                               
          @RIGHTS_PAGES_ID numeric
   
   
     AS BEGIN 
   
   
   delete from RIGHTS_PACKAGES_CHILD where PACKAGES_DEF_RIGHTS_PAGES_ID = @RIGHTS_PAGES_ID
   delete from RIGHTS_PAGES where RIGHTS_PAGES_ID = @RIGHTS_PAGES_ID
 
 
end