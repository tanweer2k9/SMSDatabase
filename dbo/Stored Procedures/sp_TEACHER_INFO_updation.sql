CREATE procedure  [dbo].[sp_TEACHER_INFO_updation]
                             
          @TECH_ID  numeric,
          @TECH_HD_ID  numeric,
          @TECH_BR_ID  numeric,
          @TECH_REG_BY_ID  numeric, 
          @TECH_PARANT_ID numeric,       
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
          @TECH_DESIGNATION nvarchar(50) ,
          @TECH_EXPERIENCE  nvarchar(50) ,
          @TECH_SALLERY float,
          @TECH_EMAIL  nvarchar(50) ,
          @TECH_IMG  nvarchar(max) ,
          @TECH_REG_DATE  datetime,
          @TECH_STATUS  char(2),           
          @TECH_JOINING_DATE date,
          @TECH_USER nvarchar(50),
          @TECH_ROLE_TYPE nvarchar(50),
          @TECH_LEFT_DATE date,
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
   
   
     as begin 
   
  -- if(@TECH_IMG = ( SELECT PATH_TEC_IMG FROM PATH_INFO WHERE PATH_STATUS = 'T' ))
  --  begin    
		--set @TECH_IMG = ( SELECT TECH_IMG FROM TEACHER_INFO WHERE TECH_ID = @TECH_ID)
  --  end 
  --  else
    
    begin
		set @TECH_IMG = ( ( SELECT PATH_TEC_IMG FROM PATH_INFO WHERE PATH_STATUS = 'T' ) + ( CONVERT(nvarchar, @TECH_ID) ) + '.png' )
    end
   
   declare @designation nvarchar(50) = (select TECH_DESIGNATION from TEACHER_INFO where TECH_ID = @TECH_ID)
   
   if @designation != @TECH_DESIGNATION
   BEGIN
		update ATTENDANCE_STAFF set ATTENDANCE_STAFF_TYPE = @TECH_DESIGNATION where ATTENDANCE_STAFF_TYPE_ID = @TECH_ID
   END
     update TEACHER_INFO
 
     set
          TECH_REG_BY_ID =  @TECH_REG_BY_ID,
          --TECH_PARANT_ID = @TECH_PARANT_ID,
          TECH_REG_BY_TYPE =  @TECH_REG_BY_TYPE,
          TECH_FIRST_NAME =  @TECH_FIRST_NAME,
          TECH_LAST_NAME =  @TECH_LAST_NAME,
          TECH_GENDER =  @TECH_GENDER,
          TECH_NATIONALITY =  @TECH_NATIONALITY,
          TECH_RELIGION =  @TECH_RELIGION,
          TECH_DOB =  @TECH_DOB,
          TECH_CNIC =  @TECH_CNIC,
          TECH_CELL_NO =  @TECH_CELL_NO,
          TECH_RESIDENCE_NO =  @TECH_RESIDENCE_NO,
          TECH_TEMP_ADDER =  @TECH_TEMP_ADDER,
          TECH_PERM_ADDER =  @TECH_PERM_ADDER,
          TECH_MOTHR_LANG =  @TECH_MOTHR_LANG,
          TECH_QUALIFICATION =  @TECH_QUALIFICATION,
		  TECH_DESIGNATION = @TECH_DESIGNATION,
		  TECH_SALLERY = @TECH_SALLERY,
          TECH_EXPERIENCE =  @TECH_EXPERIENCE,
          TECH_EMAIL =  @TECH_EMAIL,
          TECH_IMG =  @TECH_IMG,
          TECH_REG_DATE =  @TECH_REG_DATE,
          TECH_STATUS =  @TECH_STATUS,
          TECH_JOINING_DATE = @TECH_JOINING_DATE,
          TECH_USER = @TECH_USER,
          TECH_LEFT_DATE = @TECH_LEFT_DATE,
		  TECH_IS_COMMISION = @TECH_IS_COMMISION,
		  TECH_IS_OVERTIME  = @TECH_IS_OVERTIME,
		  TECH_DEPARTMENT = @TECH_DEPARTMENT,
		  TECH_EMPLOYEE_CODE =@TECH_EMPLOYEE_CODE,
		  TECH_CONFIRMATION_DURATION_MONTHS = @TECH_CONFIRMATION_DURATION_MONTHS,
		  TECH_CONFIRMATION_DATE = @TECH_CONFIRMATION_DATE,
		  TECH_CITY  = @TECH_CITY,
		  TECH_STAFF_TYPE = @TECH_STAFF_TYPE,
		  TECH_DEDUCTION_TYPE = @TECH_DEDUCTION_TYPE,
		  TECH_COA_ID = @TECH_COA_ID,		  
		  TECH_BANK_ACCOUNT_NO = @TECH_BANK_ACCOUNT_NO ,
		  TECH_BANK_ACCOUNT_TITLE = @TECH_BANK_ACCOUNT_TITLE,
		  TECH_BANK_ID = @TECH_BANK_ID ,
		  TECH_LEAVES_TYPE =@TECH_LEAVES_TYPE,
		  TECH_IS_VACATION_ALLOWED = @TECH_IS_VACATION_ALLOWED,
		  TECH_ID_DESIGNATION = @TECH_ID_DESIGNATION ,
		  TECH_ID_CARD_NAME = @TECH_ID_CARD_NAME
 
     where 
          TECH_ID =  @TECH_ID 
          
     update USER_INFO 
     set
         
          USER_DISPLAY_NAME =  @TECH_FIRST_NAME,         
          USER_STATUS =  @USER_STATUS,
          USER_TYPE = @TECH_ROLE_TYPE
 
     where 
     [USER_ID] = (select TECH_USER_INFO_ID from TEACHER_INFO where TECH_ID = @TECH_ID)
          --[USER_CODE] =  @TECH_ID and
          ----[USER_HD_ID] = @TECH_HD_ID and
          ----[USER_BR_ID] = @TECH_BR_ID and
          --USER_TYPE = 'Teacher'

		insert into TEACHER_HISTORY values (@TECH_ID, @TECH_DEPARTMENT, @TECH_DESIGNATION, @TECH_QUALIFICATION, @TECH_SALLERY, GETDATE(), @TECH_LEFT_DATE, 'T')
		
	
	declare @user_name nvarchar(50)= (select USER_NAME from USER_INFO where USER_ID = @TECH_REG_BY_ID) 

	EXEC sp_UPDATE_ATTENDANCE_SET_TIME_POLICY  @TECH_ID, @TECH_WORKING_HOURS_PACKAGE_ID, @user_name

end