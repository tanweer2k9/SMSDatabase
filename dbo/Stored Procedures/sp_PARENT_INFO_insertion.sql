CREATE procedure  [dbo].[sp_PARENT_INFO_insertion]
                                               
                                               
          @PARNT_HD_ID  numeric,
          @PARNT_BR_ID  numeric,
          @PARNT_REG_BY_ID  numeric,
          @PARNT_REG_BY_TYPE  nvarchar(50) ,
          @PARNT_FULL_NAME  nvarchar(50) ,
          @PARNT_FIRST_NAME  nvarchar(50) ,
          @PARNT_LAST_NAME  nvarchar(50) ,
          @PARNT_NATIONALITY  nvarchar(50) ,
          @PARNT_RELIGION  nvarchar(50) ,
          @PARNT_DOB  datetime,
          @PARNT_CNIC  nvarchar(20) ,
          @PARNT_OCCUPATION  nvarchar(50) ,
          @PARNT_MOTHR_LANG  nvarchar(50) ,
          @PARNT_EMAIL  nvarchar(50) ,
          @PARNT_IMG  nvarchar(max) ,
          @PARNT_CELL_NO  nvarchar(20) ,
          @PARNT_RESIDENCE_NO  nvarchar(20) ,
          @PARNT_OFFICE_NO  nvarchar(20) ,
          @PARNT_TEMP_ADDR  nvarchar(max) ,
          @PARNT_PERM_ADDR  nvarchar(max) ,
          @PARNT_FIRST_NAME2  nvarchar(50) ,
          @PARNT_LAST_NAME2  nvarchar(50) ,
          @PARNT_NATIONALITY2  nvarchar(50) ,
          @PARNT_RELIGION2  nvarchar(50) ,
          @PARNT_DOB2  datetime,
          @PARNT_CNIC2  nvarchar(50) ,
          @PARNT_OCCUPATION2  nvarchar(50) ,
          @PARNT_MOTHR_LANG2  nvarchar(50) ,
          @PARNT_EMAIL2  nvarchar(50) ,
          @PARNT_IMG2  nvarchar(max) ,
          @PARNT_CELL_NO2  nvarchar(20) ,
          @PARNT_RESIDENCE_NO2  nvarchar(20) ,
          @PARNT_OFFICE_NO2  nvarchar(20) ,
          @PARNT_TEMP_ADDR2  nvarchar(max) ,
          @PARNT_PERM_ADDR2  nvarchar(max) ,
          @PARNT_REG_DATE  datetime,
          @PARNT_STATUS  char(2) , 
		  @PARNT_REG nvarchar(50) , 
		  @PARNT_REG2 nvarchar(50) , 
   
		  @USER_NAME nvarchar(50),
          @USER_PASSWORD nvarchar(50),
          @USER_STATUS char(2),
		  @PARNT_FAMILY_CODE nvarchar(50),
		  @PARNT_AREA numeric,
		  @PARNT_CITY numeric
   
     as  begin
     
     declare @user_id numeric
    declare @id nvarchar(50)    

   
   if @PARNT_FAMILY_CODE = -1
   BEGIN
		declare @tb table(code int)
		insert into @tb 
		SELECT CAST(LEFT(Val,PATINDEX('%[^0-9]%', Val+'a')-1) as bigint)as family_code from(
		SELECT SUBSTRING([Family Code], PATINDEX('%[0-9]%', [Family Code]), LEN([Family Code])) Val from VPARENT_INFO 
		
		)A
		
		set @PARNT_FAMILY_CODE = (select MAX(code) + 1 from @tb)
   END



     insert into PARENT_INFO
     values
     (        
        @PARNT_HD_ID,
        @PARNT_BR_ID,
        @PARNT_REG_BY_ID,
        @PARNT_REG_BY_TYPE,
        @PARNT_FULL_NAME,
        @PARNT_FIRST_NAME,
        @PARNT_LAST_NAME,
        @PARNT_NATIONALITY,
        @PARNT_RELIGION,
        @PARNT_DOB,
        @PARNT_CNIC,
        @PARNT_OCCUPATION,
        @PARNT_MOTHR_LANG,
        @PARNT_EMAIL,
        @PARNT_IMG,
        @PARNT_CELL_NO,
        @PARNT_RESIDENCE_NO,
        @PARNT_OFFICE_NO,
        @PARNT_TEMP_ADDR,
        @PARNT_PERM_ADDR,
        @PARNT_FIRST_NAME2,
        @PARNT_LAST_NAME2,
        @PARNT_NATIONALITY2,
        @PARNT_RELIGION2,
        @PARNT_DOB2,
        @PARNT_CNIC2,
        @PARNT_OCCUPATION2,
        @PARNT_MOTHR_LANG2,
        @PARNT_EMAIL2,
        @PARNT_IMG2,
        @PARNT_CELL_NO2,
        @PARNT_RESIDENCE_NO2,
        @PARNT_OFFICE_NO2,
        @PARNT_TEMP_ADDR2,
        @PARNT_PERM_ADDR2,
        @PARNT_REG_DATE,
        @PARNT_STATUS,
        @PARNT_REG,
        @PARNT_REG2,
		@PARNT_FAMILY_CODE,
		@PARNT_AREA,
		@PARNT_CITY
     )
     


	      set @id = SCOPE_IDENTITY()
				
	set @PARNT_IMG = ( ( SELECT PATH_PAR_IMG FROM PATH_INFO WHERE PATH_STATUS = 'T' ) + @id + 'F.png' )
	set @PARNT_IMG2 = ( ( SELECT PATH_PAR_IMG FROM PATH_INFO WHERE PATH_STATUS = 'T' ) + @id + 'M.png' )
      
    insert into USER_INFO
     values
     (
      @PARNT_HD_ID,
      @PARNT_BR_ID,
      @id,
      @USER_NAME,
      @PARNT_FULL_NAME,
      'Parent',
      @USER_PASSWORD,
      @USER_STATUS,
      NULL      
     )

	 set @user_id = SCOPE_IDENTITY()
	 update USER_INFO set USER_NAME = @USER_NAME + CONVERT(nvarchar(15), @user_id) where USER_ID = @user_id
	 

       select @PARNT_IMG [Path],@PARNT_IMG2 [Path2],'ok' [Insert],@id 'ID', @PARNT_FAMILY_CODE as [Family Code]
    
     
end