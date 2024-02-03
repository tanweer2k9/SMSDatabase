
CREATE procedure  [dbo].[sp_MAIN_HD_INFO_insertion]
          @MAIN_INFO_DATE_FORMAT  int ,
          @MAIN_INFO_INSTITUTION_LEVEL  int,
          @MAIN_INFO_INSTITUTION_FULL_NAME  nvarchar(100) ,
          @MAIN_INFO_INSTITUTION_SHORT_NAME  nvarchar(100) ,
          @MAIN_INFO_INSTITUTION_LOGO  nvarchar(max) ,
          @MAIN_INFO_BRANCHES  int,
          @MAIN_INFO_HEAD_OFFICE  nvarchar(4000) ,
          @MAIN_INFO_SUB_OFFICE  nvarchar(4000) ,
          @MAIN_INFO_EMAIL  nvarchar(100) ,
          @MAIN_INFO_MOBILE  nvarchar(50) ,
          @MAIN_INFO_LAND_LINE  nvarchar(100) ,
          @MAIN_INFO_FAX  nvarchar(50) ,
          @MAIN_INFO_SESSION_END_DATE  nvarchar(50) ,
          @MAIN_INFO_SESSION_START_DATE  nvarchar(50) ,
          @MAIN_INFO_SCHOOL_WEBSITE  nvarchar(100) ,
          @MAIN_INFO_STATUS  char(2) ,
          @MAIN_INFO_CITY  nvarchar(50) ,
          @MAIN_INFO_COUNTRY  int,        
           
           
          @USER_NAME nvarchar(50),
          @USER_PASSWORD nvarchar(50),
          @USER_STATUS char(2),
		  @MAIN_INFO_POINTOUT_URL  nvarchar(200),
		  @MAIN_INFO_LOGO_REPORTS nvarchar(1000),
		  @MAIN_INFO_FORE_COLOR nvarchar(50),
		  @MAIN_INFO_BACK_COLOR nvarchar(50)
          
     as  begin   
     Declare @hd_id numeric =0
	 DECLARE @TEMP nvarchar(5)
     
     --set @hd_id = ( select  isnull( max(MAIN_INFO_ID),0 ) + 1 from  MAIN_HD_INFO )


	

   
     insert into MAIN_HD_INFO
     values
     (
        @MAIN_INFO_DATE_FORMAT,
        @MAIN_INFO_INSTITUTION_LEVEL,
        @MAIN_INFO_INSTITUTION_FULL_NAME,
        @MAIN_INFO_INSTITUTION_SHORT_NAME,
        @MAIN_INFO_INSTITUTION_LOGO,
        @MAIN_INFO_BRANCHES,
        @MAIN_INFO_HEAD_OFFICE,
        @MAIN_INFO_SUB_OFFICE,
        @MAIN_INFO_EMAIL,
        @MAIN_INFO_MOBILE,
        @MAIN_INFO_LAND_LINE,
        @MAIN_INFO_FAX,
        @MAIN_INFO_SESSION_START_DATE,
	    @MAIN_INFO_SESSION_END_DATE,        
        @MAIN_INFO_SCHOOL_WEBSITE,
        @MAIN_INFO_STATUS,
        @MAIN_INFO_CITY,
        @MAIN_INFO_COUNTRY,
        NULL ,
		@MAIN_INFO_POINTOUT_URL,
		'',		
		  @MAIN_INFO_FORE_COLOR ,
		  @MAIN_INFO_BACK_COLOR
     )
     set @hd_id = SCOPE_IDENTITY()

	 set @MAIN_INFO_INSTITUTION_LOGO = ( ( SELECT PATH_HD_IMG FROM PATH_INFO WHERE PATH_STATUS = 'T' ) + CAST((@hd_id) as nvarchar(50)) + '.png' )	
	 SET @TEMP =  (SELECT(LEN(@hd_id))) 
	 IF @TEMP = 1
	BEGIN
		SET @TEMP = '0' + CAST((@hd_id) as nvarchar(50))
	END
	else
	BEGIN
		SET @TEMP = CAST((@hd_id) as nvarchar(50))
	END



	set @MAIN_INFO_LOGO_REPORTS = ( ( SELECT PATH_HD_IMG FROM PATH_INFO WHERE PATH_STATUS = 'T' ) + 'report' +CAST((@hd_id) as nvarchar(50)) + '.png' )

	update MAIN_HD_INFO set MAIN_INFO_INSTITUTION_LOGO = @MAIN_INFO_INSTITUTION_LOGO,MAIN_INFO_LOGO_REPORTS = @MAIN_INFO_LOGO_REPORTS where MAIN_INFO_ID = @hd_id

	  insert into USER_INFO
     values
     (
      @hd_id,
      0,
      @hd_id,
      @TEMP + @USER_NAME,
      @MAIN_INFO_INSTITUTION_FULL_NAME,
      'SA',
      @USER_PASSWORD,
      @USER_STATUS,
      NULL    
     )
     
	  select 'ok' [Insert], @hd_id  as 'ID',@MAIN_INFO_INSTITUTION_LOGO as [Path],@TEMP + @USER_NAME as [Login Name],@USER_PASSWORD as [Password]
    
     
end