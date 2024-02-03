CREATE procedure  [dbo].[sp_TEACHER_INFO_insertion]
                                               
                                               
          @TECH_HD_ID  numeric,
          @TECH_BR_ID  numeric,
          @TECH_REG_BY_ID  numeric,
          @TECH_PARANT_ID  numeric,
          @TECH_REG_BY_TYPE  nvarchar(50) ,
          @TECH_FIRST_NAME  nvarchar(50) ,
          @TECH_LAST_NAME  nvarchar(50) ,
          @TECH_GENDER  bit,
          @TECH_NATIONALITY  nvarchar(50) ,
          @TECH_RELIGION  nvarchar(50) ,
          @TECH_DOB  datetime,
          @TECH_CNIC  nvarchar(50) ,
          @TECH_CELL_NO  nvarchar(20) ,
          @TECH_RESIDENCE_NO  nvarchar(20) ,
          @TECH_TEMP_ADDER  nvarchar(max) ,
          @TECH_PERM_ADDER  nvarchar(max) ,
          @TECH_MOTHR_LANG  nvarchar(50) ,
          @TECH_QUALIFICATION  nvarchar(50) ,
          @TECH_DESIGNATION nvarchar(50),
          @TECH_EXPERIENCE  nvarchar(50) ,
          @TECH_SALLERY  float,
          @TECH_EMAIL  nvarchar(50) ,
          @TECH_IMG  nvarchar(max) ,
          @TECH_REG_DATE  datetime,
          @TECH_STATUS  char(2) ,
          @TECH_JOINING_DATE date,
          @TECH_USER nvarchar(50),
          @TECH_ROLE_TYPE nvarchar(50),
          @TECH_LEFT_DATE date,
          
          @USER_NAME nvarchar(50),
          @USER_PASSWORD nvarchar(50),
          @USER_STATUS char(2),
		  @TECH_IS_COMMISION char(2),
		  @TECH_IS_OVERTIME char(2),
		  @TECH_DEPARTMENT numeric,
		  @TECH_EMPLOYEE_CODE nvarchar(100),
		  @TECH_CONFIRMATION_DURATION_MONTHS int,
		  @TECH_CONFIRMATION_DATE date,
		  @TECH_CITY numeric,
		  @TECH_STAFF_TYPE numeric,
		  @TECH_DEDUCTION_TYPE nvarchar(50),
		  @TECH_COA_ID numeric,
		  @TECH_BANK_ACCOUNT_NO nvarchar(100),
		  @TECH_BANK_ACCOUNT_TITLE nvarchar(100),
		  @TECH_BANK_ID numeric,
		  @TECH_LEAVES_TYPE nvarchar(50),
		  @TECH_IS_VACATION_ALLOWED bit,
		  @TECH_WORKING_HOURS_PACKAGE_ID numeric,
		  @TECH_ID_DESIGNATION nvarchar(100),
		  @TECH_ID_CARD_NAME nvarchar(100)
   
   
     as  begin
	   declare @user_id numeric = 0
   
     insert into TEACHER_INFO
     values
     (
    
        @TECH_HD_ID,
        @TECH_BR_ID,
        @TECH_REG_BY_ID,
        @TECH_PARANT_ID,
        @TECH_REG_BY_TYPE,
        @TECH_FIRST_NAME,
        @TECH_LAST_NAME,
        @TECH_GENDER,
        @TECH_NATIONALITY,
        @TECH_RELIGION,
        @TECH_DOB,
        @TECH_CNIC,
        @TECH_CELL_NO,
        @TECH_RESIDENCE_NO,
        @TECH_TEMP_ADDER,
        @TECH_PERM_ADDER,
        @TECH_MOTHR_LANG,
        @TECH_QUALIFICATION,
        @TECH_DESIGNATION,
        @TECH_EXPERIENCE,
        @TECH_SALLERY,
        @TECH_EMAIL,
        @TECH_IMG,
        @TECH_REG_DATE,
        @TECH_STATUS,
        @TECH_JOINING_DATE,
        @TECH_USER,
        NULL,
        '1900-01-01',
		1000,
		@TECH_IS_COMMISION,
		@TECH_IS_OVERTIME,
		@TECH_DEPARTMENT,
		@TECH_EMPLOYEE_CODE,
		@TECH_CONFIRMATION_DURATION_MONTHS,
		@TECH_CONFIRMATION_DATE,
		@TECH_CITY,
		@TECH_STAFF_TYPE,
		@TECH_DEDUCTION_TYPE,
		@TECH_COA_ID,
		@TECH_BANK_ACCOUNT_NO,
		@TECH_BANK_ACCOUNT_TITLE,
		@TECH_BANK_ID ,
		@TECH_LEAVES_TYPE,
		@TECH_IS_VACATION_ALLOWED,
		@TECH_ID_DESIGNATION,
		@TECH_ID_CARD_NAME 
     )
     

	  
    declare @id nvarchar(50)    
     set @id = SCOPE_IDENTITY()
				
	set @TECH_IMG = ( ( SELECT PATH_TEC_IMG FROM PATH_INFO WHERE PATH_STATUS = 'T' ) + @id + '.png' )
	
   
    insert into USER_INFO
     values
     (
      @TECH_HD_ID,
      @TECH_BR_ID,
      @id,
      @USER_NAME,
      @TECH_FIRST_NAME,
      @TECH_ROLE_TYPE,
      @USER_PASSWORD,
      @USER_STATUS,
      NULL      
     )
   
   set @user_id =SCOPE_IDENTITY()

   update USER_INFO set USER_NAME = @USER_NAME + CONVERT(nvarchar(15), @user_id) where USER_ID = @user_id
   update TEACHER_INFO set TECH_USER_INFO_ID = @user_id where TECH_ID = @id

     
      select @TECH_IMG  [Path],'ok' msg, @id [MAX ID]
    
     insert into TEACHER_HISTORY values (@id, @TECH_DEPARTMENT, @TECH_DESIGNATION, @TECH_QUALIFICATION, @TECH_SALLERY, GETDATE(), @TECH_LEFT_DATE, 'T')
     

	 declare @user_name_reg_by nvarchar(50)= (select USER_NAME from USER_INFO where USER_ID = @TECH_REG_BY_ID) 

	 EXEC sp_UPDATE_ATTENDANCE_SET_TIME_POLICY  @id, @TECH_WORKING_HOURS_PACKAGE_ID, @user_name_reg_by
end