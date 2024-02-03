CREATE procedure  [dbo].[sp_RIGHTS_updation]
          @RIGHTS_HD_ID  numeric,
          @RIGHTS_BR_ID numeric,
          @RIGHTS_RIGHT_PARENTS_CODE  nvarchar(50) ,
          @RIGHTS_RIGHT_CODE  nvarchar(50) , ------- user_id
          @RIGHTS_RIGHT_NAME  nvarchar(100) , ------- Display Name
          @RIGHTS_RIGHT_TEXT  nvarchar(50) , ------- Password
          @RIGHTS_ROLE  nvarchar(100) ,
          @RIGHTS_ADMIN_LEVEL  numeric,		-------- Allow Login
          @RIGHTS_LEVEL  numeric,			-------- Status
          @RIGHTS_RIGHT_APPLICABLE  bit,
          @RIGHTS_SUB_RIGHT_APPLICABLE1  bit,
          @RIGHTS_STATUS  bit,
          @RIGHTS_IS_DELETED  bit,
          @RIGHTS_IS_BUTTON  bit,
          @STATUS CHAR(1)
As Begin
		  --Declare @RIGHTS_HD_ID  numeric = 1
    --      Declare @RIGHTS_BR_ID numeric = 1
    --      Declare @RIGHTS_RIGHT_PARENTS_CODE  nvarchar(50) = 'VTEACHER_INFO'
    --      Declare @RIGHTS_RIGHT_CODE  nvarchar(50) = '200'
    --      Declare @RIGHTS_RIGHT_NAME  nvarchar(50) = 'RULS'
    --      Declare @RIGHTS_RIGHT_TEXT  nvarchar(50) = '123'
    --      Declare @RIGHTS_ROLE  nvarchar(50) 
    --      Declare @RIGHTS_ADMIN_LEVEL  numeric = 0
    --      Declare @RIGHTS_LEVEL  numeric = 0
    --      Declare @RIGHTS_RIGHT_APPLICABLE  bit
    --      Declare @RIGHTS_SUB_RIGHT_APPLICABLE1  bit
    --      Declare @RIGHTS_STATUS  bit
    --      Declare @RIGHTS_IS_DELETED  bit
    --      Declare @RIGHTS_IS_BUTTON  bit
    --      Declare @STATUS CHAR(1) = 'U'

Declare  @login_status char
Declare  @active_status char


if @STATUS = 'U'
Begin

	if @RIGHTS_ADMIN_LEVEL = 1 
	begin
		set @login_status = 'T'
	end
	else
	begin
		set @login_status = 'F'
	end



	if @RIGHTS_LEVEL = 1 
	begin
		set @active_status = 'T'
	end
	else
	begin
		set @active_status = 'F'
	end

	update USER_INFO
	set USER_ROLE = @RIGHTS_ROLE,
		USER_DISPLAY_NAME = @RIGHTS_RIGHT_NAME,
		USER_PASSWORD = @RIGHTS_RIGHT_TEXT,
		USER_STATUS = @login_status		
	where [USER_ID] = @RIGHTS_RIGHT_CODE
	and USER_HD_ID = @RIGHTS_HD_ID
	and USER_BR_ID = @RIGHTS_BR_ID
	
	Declare @chiled_ID numeric = ( select USER_CODE from USER_INFO where [USER_ID] =  @RIGHTS_RIGHT_CODE)   
	Declare @Query nvarchar(1000) = 'update  '+ @RIGHTS_RIGHT_PARENTS_CODE +'  set [Status] = '''+ @active_status +''' where ID = '+ convert(nvarchar(5), @chiled_ID)

	
	Exec(@Query)
	
	

End

Else
Begin
	update RIGHTS 
		SET RIGHTS_STATUS = @RIGHTS_STATUS
		WHERE 
			RIGHTS_ADMIN_LEVEL = @RIGHTS_ADMIN_LEVEL
		and RIGHTS_RIGHT_NAME = @RIGHTS_RIGHT_NAME
		and RIGHTS_HD_ID = @RIGHTS_HD_ID
        and RIGHTS_BR_ID = @RIGHTS_BR_ID

End
       
        
   select 'ok'     
        
End