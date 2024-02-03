
CREATE procedure  [dbo].[sp_MAIN_HD_INFO_updation]
          @MAIN_INFO_ID  numeric,
          @MAIN_INFO_DATE_FORMAT  int,
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
          @USER_PASSWORD nvarchar(50),
          
		  @USER_STATUS char(2),
		  @MAIN_INFO_POINTOUT_URL nvarchar(200),
		  @MAIN_INFO_LOGO_REPORTS nvarchar(1000),
		  @MAIN_INFO_FORE_COLOR nvarchar(50),
		  @MAIN_INFO_BACK_COLOR nvarchar(50)
   
     as begin 
   
   
   
    
 if(@MAIN_INFO_INSTITUTION_LOGO = ( SELECT PATH_HD_IMG FROM PATH_INFO WHERE PATH_STATUS = 'T' ))
    begin    
		set @MAIN_INFO_INSTITUTION_LOGO = ( Select MAIN_INFO_INSTITUTION_LOGO from MAIN_HD_INFO where MAIN_INFO_ID = @MAIN_INFO_ID)
    end    
    
 else
    
    begin
		set @MAIN_INFO_INSTITUTION_LOGO = ( ( SELECT PATH_HD_IMG FROM PATH_INFO WHERE PATH_STATUS = 'T' ) + ( CONVERT(nvarchar, @MAIN_INFO_ID) ) + '.png' )
    end
   
   
   set @MAIN_INFO_LOGO_REPORTS = ( ( SELECT PATH_HD_IMG FROM PATH_INFO WHERE PATH_STATUS = 'T' ) + 'report' +( CONVERT(nvarchar, @MAIN_INFO_ID) ) + '.png' )
   
     update MAIN_HD_INFO
 
     set
          MAIN_INFO_DATE_FORMAT =  @MAIN_INFO_DATE_FORMAT,
          MAIN_INFO_INSTITUTION_LEVEL =  @MAIN_INFO_INSTITUTION_LEVEL,
          MAIN_INFO_INSTITUTION_FULL_NAME =  @MAIN_INFO_INSTITUTION_FULL_NAME,
          MAIN_INFO_INSTITUTION_SHORT_NAME =  @MAIN_INFO_INSTITUTION_SHORT_NAME,
          MAIN_INFO_INSTITUTION_LOGO =  @MAIN_INFO_INSTITUTION_LOGO,
          MAIN_INFO_BRANCHES =  @MAIN_INFO_BRANCHES,
          MAIN_INFO_HEAD_OFFICE =  @MAIN_INFO_HEAD_OFFICE,
          MAIN_INFO_SUB_OFFICE =  @MAIN_INFO_SUB_OFFICE,
          MAIN_INFO_EMAIL =  @MAIN_INFO_EMAIL,
          MAIN_INFO_MOBILE =  @MAIN_INFO_MOBILE,
          MAIN_INFO_LAND_LINE =  @MAIN_INFO_LAND_LINE,
          MAIN_INFO_FAX =  @MAIN_INFO_FAX,
          MAIN_INFO_SESSION_END_DATE =  @MAIN_INFO_SESSION_END_DATE,
          MAIN_INFO_SESSION_START_DATE =  @MAIN_INFO_SESSION_START_DATE,
          MAIN_INFO_SCHOOL_WEBSITE =  @MAIN_INFO_SCHOOL_WEBSITE,
          MAIN_INFO_STATUS =  @MAIN_INFO_STATUS,
          MAIN_INFO_CITY =  @MAIN_INFO_CITY,
          MAIN_INFO_COUNTRY =  @MAIN_INFO_COUNTRY,
		  MAIN_INFO_POINTOUT_URL = @MAIN_INFO_POINTOUT_URL,
		  MAIN_INFO_LOGO_REPORTS = @MAIN_INFO_LOGO_REPORTS,
		  MAIN_INFO_FORE_COLOR = @MAIN_INFO_FORE_COLOR,
		  MAIN_INFO_BACK_COLOR = @MAIN_INFO_BACK_COLOR
 
     where 
          MAIN_INFO_ID =  @MAIN_INFO_ID 
          
          
          
     update USER_INFO 
     set         
          USER_DISPLAY_NAME =  @MAIN_INFO_INSTITUTION_FULL_NAME,         
          USER_STATUS =  @USER_STATUS,
          USER_PASSWORD = @USER_PASSWORD
  
     where 
          [USER_CODE] =  @MAIN_INFO_ID and
          --[USER_HD_ID] = @STDNT_HD_ID and
          --[USER_BR_ID] = @STDNT_BR_ID and
          USER_TYPE = 'SA'
        	
 
end