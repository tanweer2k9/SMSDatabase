CREATE procedure  [dbo].[sp_MARKET_TRACKING_selection]
                                               
                                               
     @STATUS char(10),
     @TRACK_ID  numeric,
     @TRACK_HD_ID  numeric,
     @TRACK_BR_ID  numeric,
	 @TRACK_PK_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN
		
		
		declare @user_id numeric = 0
		declare @user_type nvarchar(50) = ''
		select @user_id = USER_code, @user_type = USER_TYPE from USER_INFO where [USER_ID] = @TRACK_PK_ID
		

		if (@user_type = 'A' and (select COUNT(*) from  TEACHER_INFO where TECH_USER_INFO_ID = @TRACK_PK_ID) = 0) or @user_type = 'SA' or @user_type = 'IT'   
		BEGIN
			SELECT * FROM VMARKET_TRACKING where [HD ID] = @TRACK_HD_ID and [BR ID] = @TRACK_BR_ID 
		END
		ELSE
		BEGIN
			select * from VMARKET_TRACKING where [HD ID] = @TRACK_HD_ID and [BR ID] = @TRACK_BR_ID  and 
			[Sales Representataive ID] = (select SALES_ID from SALES_REPRESENTATIVE_INFO where SALES_DESCRIPTION = CAST(@user_id as nvarchar(50)))
		END
		 SELECT * FROM VMARKET_TRACKING_DEF where PID = @TRACK_ID 
		 SELECT * FROM VMARKET_TRACKING_DEF 
		 select ID, Name from VNATIONALITY_INFO where [Institute ID] =  @TRACK_HD_ID and [Branch ID] = @TRACK_BR_ID and Status = 'T'
		 select ID, Name from VCITY_INFO where [Institute ID] =  @TRACK_HD_ID and [Branch ID] = @TRACK_BR_ID and Status = 'T'
		 select ID, Name from VAREA_INFO where [Institute ID] =  @TRACK_HD_ID and [Branch ID] = @TRACK_BR_ID and Status = 'T'
		 select ID, Name from VMARK_STATUS where [Institute ID] =  @TRACK_HD_ID and [Branch ID] = @TRACK_BR_ID and Status = 'T'
		 select ID, Name from VSALES_REPRESENTATIVE_INFO where [Institute ID] =  @TRACK_HD_ID and [Branch ID] = @TRACK_BR_ID and Status = 'T'
		 select ID, Name from VMARKETING_MODE_INFO where [Institute ID] =  @TRACK_HD_ID and [Branch ID] = @TRACK_BR_ID and Status = 'T'
		 select ID, Name from VDESIGNATION_INFO where [Institute ID] =  @TRACK_HD_ID and [Branch ID] = @TRACK_BR_ID and Status = 'T'

     END  
     ELSE IF @STATUS = 'A'
     BEGIN
			SELECT * FROM VMARKET_TRACKING where ID = @TRACK_ID 
			SELECT * FROM VMARKET_TRACKING_DEF where PID = @TRACK_ID
 
	END
 
     END