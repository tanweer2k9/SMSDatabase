CREATE procedure  [dbo].[sp_RIGHTS_PAGES_updation]
                                               
                                               
          @RIGHTS_PAGES_ID  numeric,
          @RIGHTS_PAGES_NAME  nvarchar(150) ,
          @RIGHTS_PAGES_TEXT  nvarchar(150) ,
          @RIGHTS_PAGES_PARENT_CODE  nvarchar(150) ,
          @RIGHTS_PAGES_CHILD_CODE  nvarchar(150),
		  @RIGHTS_PAGES_URL nvarchar(250)
          
          as begin
          
			   
     update RIGHTS_PAGES
 
     set          
          RIGHTS_PAGES_NAME =  @RIGHTS_PAGES_NAME,
          RIGHTS_PAGES_TEXT =  @RIGHTS_PAGES_TEXT,
          RIGHTS_PAGES_PARENT_CODE =  @RIGHTS_PAGES_PARENT_CODE,
          RIGHTS_PAGES_CHILD_CODE =  @RIGHTS_PAGES_CHILD_CODE,
		  RIGHTS_PAGES_URL = @RIGHTS_PAGES_URL
          
          where RIGHTS_PAGES_ID =  @RIGHTS_PAGES_ID
          
          
          
          end