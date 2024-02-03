
CREATE PROC [dbo].[sp_SCHOOL_REGISTRATION_insertion]

@MAIN_INFO_BRANCHES int,
@MAIN_INFO_CITY nvarchar(200),
@MAIN_INFO_COUNTRY int,
@MAIN_INFO_EMAIL nvarchar(200),
@MAIN_INFO_INSTITUTION_FULL_NAME nvarchar(200),
@MAIN_INFO_INSTITUTION_LEVEL int,
@MAIN_INFO_INSTITUTION_LOGO nvarchar(200),
@MAIN_INFO_LAND_LINE nvarchar(200),
@MAIN_INFO_MOBILE nvarchar(200),
@BR_ADM_CITY nvarchar(200),
@BR_ADM_COUNTRY int,
@BR_ADM_EMAIL nvarchar(200),
@BR_ADM_MOBILE nvarchar(200),
@BR_ADM_NAME nvarchar(200),
@BR_ADM_PHONE nvarchar(200),
@BR_ADM_WEBSITE nvarchar(200),
@BR_ADM_ADDRESS nvarchar(500),
@SMS_BRAND_NAME nvarchar(100)

AS


declare @HD_ID int = 0
declare @BR_ID int = 0
declare @date_format int = 0
declare @intitute_level int = 0
declare @country_id int = 0
declare @sms_api int = 0

insert into MAIN_HD_INFO values
(
-1,
-1,
@MAIN_INFO_INSTITUTION_FULL_NAME,
'',
@MAIN_INFO_INSTITUTION_LOGO,
@MAIN_INFO_BRANCHES,
'',
'',
@MAIN_INFO_EMAIL,
@MAIN_INFO_MOBILE,
@MAIN_INFO_LAND_LINE,
'',
GETDATE(),
DATEADD(YYYY,1,getdate()),
'',
'T',
@MAIN_INFO_CITY,
-1,
NULL,
'',
'',
'',
''
)

set @HD_ID = (select SCOPE_IDENTITY())
set @MAIN_INFO_INSTITUTION_LOGO = ((SELECT PATH_HD_IMG FROM PATH_INFO WHERE PATH_STATUS = 'T' ) + CAST((@HD_ID) as nvarchar(50)) + '.png' )	


insert into br_Admin values
(
@HD_ID,
@BR_ADM_NAME,
@BR_ADM_ADDRESS,
@BR_ADM_PHONE,
@BR_ADM_EMAIL,
@BR_ADM_MOBILE,
'',
'T',
@BR_ADM_CITY,
-1,
GETDATE(),
DATEADD(YYYY,1,getdate()),
@BR_ADM_WEBSITE,
'',
'',
'',
'Main Admin',
-1,
-1,
'Marks',
-1,
50,
6,
'F',
15,
'',
'T',
'Minutes',
0,
0,
0,
1,0,0,0, 15,0,0,0,0,0,0,'','',CAST(0 as bit),''
)

set @BR_ID = (select SCOPE_IDENTITY())

--Rights
declare @super_admin_rights_id int = 0
declare @admin_rights_id int = 0

insert into RIGHTS_PACKAGES_PARENT values (@HD_ID, @BR_ID, 'Super Admin', 1)
set @super_admin_rights_id = (select SCOPE_IDENTITY())


insert into RIGHTS_PACKAGES_PARENT values (@HD_ID, @BR_ID, 'Admin', 2)
set @admin_rights_id = (select SCOPE_IDENTITY())

insert into RIGHTS_PACKAGES_CHILD 
select @super_admin_rights_id, PACKAGES_DEF_RIGHTS_PAGES_ID, PACKAGES_DEF_STATUS, PACKAGES_DEF_LOAD_STATUS,0 from RIGHTS_PACKAGES_CHILD where PACKAGES_DEF_PID in (select PACKAGES_ID from RIGHTS_PACKAGES_PARENT where PACKAGES_HD_ID = 1 and PACKAGES_BR_ID = 1 and PACKAGES_TYPE = 1)

insert into RIGHTS_PACKAGES_CHILD 
select @admin_rights_id, PACKAGES_DEF_RIGHTS_PAGES_ID, PACKAGES_DEF_STATUS, PACKAGES_DEF_LOAD_STATUS,0 from RIGHTS_PACKAGES_CHILD where PACKAGES_DEF_PID in (select PACKAGES_ID from RIGHTS_PACKAGES_PARENT where PACKAGES_HD_ID = 1 and PACKAGES_BR_ID = 1 and PACKAGES_TYPE = 2)




--declare @sa_id int = 0
--set @sa_id = (select MAX(USER_CODE) from USER_INFO where USER_TYPE = 'SA') + 1
declare @TEMP nvarchar(5) = ''
declare @TEMP_br nvarchar(5) = ''
	 SET @TEMP =  (SELECT(LEN(@HD_ID))) 
	
	IF @TEMP = 1
	BEGIN
		SET @TEMP = '0' + CAST((@HD_ID) as nvarchar(50))
	END
	else
	BEGIN
		SET @TEMP = CAST((@HD_ID) as nvarchar(50))
	END

declare @school_password nvarchar(10) = (SELECT SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 9))
declare @school_user_name nvarchar(50) = @TEMP + '-001-1'


	 SET @TEMP_br =  (SELECT(LEN(@BR_ID)))
	 IF @TEMP_br = 1
	BEGIN
		SET @TEMP_br = '00' + CAST((@BR_ID) as nvarchar(50))
	END
	else if @TEMP_br = 2
	BEGIN
		SET @TEMP_br = '0' + CAST((@BR_ID) as nvarchar(50))
	END
	else
	BEGIN
		SET @TEMP_br = CAST((@BR_ID) as nvarchar(50))
	END


declare @branch_password nvarchar(10) = (SELECT SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 9))
declare @branch_user_name nvarchar(50) = @TEMP + '-' +@TEMP_br + '-1'


--insert into user_info Super Admin
     insert into USER_INFO
     values
     (
      @HD_ID,
      @BR_ID,
      1,
      @school_user_name,
      @MAIN_INFO_INSTITUTION_FULL_NAME,
      'SA',
      @school_password,
      'T',
      @super_admin_rights_id    
     )

	 insert into USER_INFO
     values
     (
      @HD_ID,
      @BR_ID,
      1,
      @branch_user_name,
      @BR_ADM_NAME,
      'A',
      @branch_password,
      'T',
      @admin_rights_id    
     )


--date info
insert into DATE_INFO values (@HD_ID, @BR_ID, 'D/M/YY','d/M/yy','T')
insert into DATE_INFO values (@HD_ID, @BR_ID, 'DD/MM/YYYY','DD/MM/YYYY','T')
insert into DATE_INFO values (@HD_ID, @BR_ID, 'DD Month, yyyy','dd MMMM, yyyy','T')
insert into DATE_INFO values (@HD_ID, @BR_ID, 'Day,Month,D,YY (Short)','ddd, MMM d, yy','T')
insert into DATE_INFO values (@HD_ID, @BR_ID, 'Day,Month,D,YYYY (Long)','dddd, MMMM d, yyyy','T')
insert into DATE_INFO values (@HD_ID, @BR_ID, 'M/D/YY','M/d/yy','T')
insert into DATE_INFO values (@HD_ID, @BR_ID, 'MM/DD/YYYY','MM/dd/yyyy','T')
insert into DATE_INFO values (@HD_ID, @BR_ID, 'MM-DD-YYYY','MM-dd-yyyy','T')
insert into DATE_INFO values (@HD_ID, @BR_ID, 'Month dd, yyyy','MMMM dd, yyyy','T')
insert into DATE_INFO values (@HD_ID, @BR_ID, 'YY/MM/DD','yy/MM/dd','T')
insert into DATE_INFO values (@HD_ID, @BR_ID, 'YYYY/MM/DD','yyyy/MM/dd','T')
insert into DATE_INFO values (@HD_ID, @BR_ID, 'YYYY-MM-DD','yyyy-MM-dd','T')

set @date_format = (select top(1) date_id from date_info where date_hd_id = @HD_ID and date_br_id = @BR_ID)

--institution level
insert into INSTITUTION_LEVEL_INFO values (@HD_ID, @BR_ID, 'School','','T')
insert into INSTITUTION_LEVEL_INFO values (@HD_ID, @BR_ID, 'College','','T')
insert into INSTITUTION_LEVEL_INFO values (@HD_ID, @BR_ID, 'Academy','','T')
insert into INSTITUTION_LEVEL_INFO values (@HD_ID, @BR_ID, 'Training Center','','T')
insert into INSTITUTION_LEVEL_INFO values (@HD_ID, @BR_ID, 'Other Institute','','T')

set @intitute_level = (select inst_level_id from INSTITUTION_LEVEL_INFO where inst_level_hd_id = @HD_ID and inst_level_br_id = @BR_ID 
and inst_level_name in (select inst_level_name from INSTITUTION_LEVEL_INFO where inst_level_id = @MAIN_INFO_INSTITUTION_LEVEL))

--nationality info --update in branch also
insert into NATIONALITY_INFO values (@HD_ID, @BR_ID, 'Pakistan','NA','T')

set @country_id = (select NATIONALITY_ID from NATIONALITY_INFO where NATIONALITY_HD_ID = @HD_ID and NATIONALITY_BR_ID = @BR_ID and NATIONALITY_NAME in 
(select NATIONALITY_NAME from NATIONALITY_INFO where NATIONALITY_ID = @MAIN_INFO_COUNTRY))

update MAIN_HD_INFO set MAIN_INFO_COUNTRY = @country_id, MAIN_INFO_INSTITUTION_LEVEL = @intitute_level, main_info_date_format = @date_format, MAIN_INFO_INSTITUTION_LOGO = @MAIN_INFO_INSTITUTION_LOGO
where main_info_id = @HD_ID

set @country_id = (select NATIONALITY_ID from NATIONALITY_INFO where NATIONALITY_HD_ID = @HD_ID and NATIONALITY_BR_ID = @BR_ID and NATIONALITY_NAME in 
(select NATIONALITY_NAME from NATIONALITY_INFO where NATIONALITY_ID = @BR_ADM_COUNTRY))


--SMS API
if @SMS_BRAND_NAME = 'local'
begin
	insert into SMS_API values ('local', '','','','')
end
else
begin
	insert into SMS_API values ('', @SMS_BRAND_NAME,'','','')
end

set @sms_api = (select SCOPE_IDENTITY())

update BR_ADMIN set BR_ADM_COUNTRY = @country_id, BR_ADM_SMS_API_ID = @sms_api where BR_ADM_HD_ID = @HD_ID and BR_ADM_ID = @BR_ID


-- no relation with hd and br
-- Report Setting
insert into REPORT_SETTING values (@HD_ID, @BR_ID, 'Fee Challan', 'landscape_simple_3', 'T')

--Fee Setting
insert into FEE_SETTING values (@HD_ID, @BR_ID, 0,0,0,@BR_ID,@BR_ID,@BR_ID,'Parent') 

--Session Info
insert into SESSION_INFO 
select @HD_ID,@BR_ID,'2018-2019', 'T','2018-08-01','2019-07-31',1

declare @session_Id numeric = 0
set @session_Id = SCOPE_IDENTITY()
--Term Info
declare @session_start_date date = ''
declare @session_end_date date = ''
set @session_start_date = (select top(@BR_ID) BR_ADM_ACCT_START_DATE from BR_ADMIN where BR_ADM_HD_ID = @HD_ID and BR_ADM_ID = @BR_ID)
set @session_end_date = (select top(@BR_ID) BR_ADM_ACCT_END_DATE from BR_ADMIN where BR_ADM_HD_ID = @HD_ID and BR_ADM_ID = @BR_ID)

insert into TERM_INFO values (@HD_ID, @BR_ID, 'First Mid-term', 'NA', 'T', DATEADD(MM,0, @session_start_date), DATEADD(MM,3, @session_end_date), @session_start_date, @session_end_date, 1,@session_Id)
insert into TERM_INFO values (@HD_ID, @BR_ID, 'First Term', 'NA', 'T', DATEADD(MM,3, @session_start_date), DATEADD(MM,6, @session_end_date), @session_start_date, @session_end_date,2,@session_Id)
insert into TERM_INFO values (@HD_ID, @BR_ID, '2nd Midd Term', 'NA', 'T', DATEADD(MM,6, @session_start_date), DATEADD(MM,9, @session_end_date), @session_start_date, @session_end_date,3,@session_Id)
insert into TERM_INFO values (@HD_ID, @BR_ID, '2nd Term', 'NA', 'T', DATEADD(MM,9, @session_start_date), DATEADD(MM,12, @session_end_date), @session_start_date, @session_end_date,4,@session_Id)


--Department Info
insert into DEPARTMENT_INFO values (@HD_ID, @BR_ID, 'Computer Science','NA','T',1)
insert into DEPARTMENT_INFO values (@HD_ID, @BR_ID, 'Study', 'NA','T',2)

--Section Info
insert into SECTION_INFO values (@HD_ID, @BR_ID,'A', 'NA', 'T')
insert into SECTION_INFO values (@HD_ID, @BR_ID,'B', 'NA', 'T')
insert into SECTION_INFO values (@HD_ID, @BR_ID,'C', 'NA', 'T')

-- Class Info
insert into CLASS_INFO  values (@HD_ID, @BR_ID, 'Play Group ','NA','T')
insert into CLASS_INFO  values (@HD_ID, @BR_ID, 'Nursery','NA','T')
insert into CLASS_INFO  values (@HD_ID, @BR_ID, 'Prep','NA','T')
insert into CLASS_INFO  values (@HD_ID, @BR_ID, 'One','NA','T')
insert into CLASS_INFO  values (@HD_ID, @BR_ID, 'Two','NA','T')
insert into CLASS_INFO  values (@HD_ID, @BR_ID, 'Three','NA','T')
insert into CLASS_INFO  values (@HD_ID, @BR_ID, 'Four','NA','T')
insert into CLASS_INFO  values (@HD_ID, @BR_ID, 'Five','NA','T')
insert into CLASS_INFO  values (@HD_ID, @BR_ID, 'Six','NA','T')
insert into CLASS_INFO  values (@HD_ID, @BR_ID, 'Seven','NA','T')
insert into CLASS_INFO  values (@HD_ID, @BR_ID, 'Eight','NA','T')
insert into CLASS_INFO  values (@HD_ID, @BR_ID, 'Nine','NA','T')
insert into CLASS_INFO  values (@HD_ID, @BR_ID, 'Ten','NA','T')
insert into CLASS_INFO  values (@HD_ID, @BR_ID, 'Pass Out','NA','T')


--Subject Info
insert into SUBJECT_INFO  values (@HD_ID, @BR_ID, 'English','NA','T','S',4)
insert into SUBJECT_INFO  values (@HD_ID, @BR_ID, 'Urdu','NA','T','S',4)
insert into SUBJECT_INFO  values (@HD_ID, @BR_ID, 'Math','NA','T','S',4)
insert into SUBJECT_INFO  values (@HD_ID, @BR_ID, 'Science','NA','T','S',4)
insert into SUBJECT_INFO  values (@HD_ID, @BR_ID, 'Social Study','NA','T','S',4)
insert into SUBJECT_INFO  values (@HD_ID, @BR_ID, 'Computer','NA','T','S',4)
insert into SUBJECT_INFO  values (@HD_ID, @BR_ID, 'Islamiyat','NA','T','S',4)
insert into SUBJECT_INFO  values (@HD_ID, @BR_ID, 'Poems','NA','T','S',4)
insert into SUBJECT_INFO  values (@HD_ID, @BR_ID, 'Genral Khnowlage','NA','T','S',4)
insert into SUBJECT_INFO  values (@HD_ID, @BR_ID, 'Biology','NA','T','S',4)
insert into SUBJECT_INFO  values (@HD_ID, @BR_ID, 'Chemistry','NA','T','S',4)
insert into SUBJECT_INFO  values (@HD_ID, @BR_ID, 'ART','NA','T','S',4)
insert into SUBJECT_INFO  values (@HD_ID, @BR_ID, 'Genral Science','NA','T','S',4)
insert into SUBJECT_INFO  values (@HD_ID, @BR_ID, 'Quran Pak','NA','T','S',4)
insert into SUBJECT_INFO  values (@HD_ID, @BR_ID, 'Poems Urdu','NA','T','S',4)

--Shift Info
insert into SHIFT_INFO  values (@HD_ID, @BR_ID, 'Morning','NA','T')

--Designation Info
insert into DESIGNATION_INFO  values (@HD_ID, @BR_ID, 'Vice Principle','NA','T')
insert into DESIGNATION_INFO  values (@HD_ID, @BR_ID, 'Princpal','NA','T')
insert into DESIGNATION_INFO  values (@HD_ID, @BR_ID, 'Professor','NA','T')
insert into DESIGNATION_INFO  values (@HD_ID, @BR_ID, 'Teacher','NA','T')
insert into DESIGNATION_INFO  values (@HD_ID, @BR_ID, 'Computer Teacher','NA','T')
insert into DESIGNATION_INFO  values (@HD_ID, @BR_ID, 'Scince Teacher','NA','T')
insert into DESIGNATION_INFO  values (@HD_ID, @BR_ID, 'Clerk','NA','T')
insert into DESIGNATION_INFO  values (@HD_ID, @BR_ID, 'Aaya','NA','T')
insert into DESIGNATION_INFO  values (@HD_ID, @BR_ID, 'Mali','NA','T')
insert into DESIGNATION_INFO  values (@HD_ID, @BR_ID, 'Sweeper','NA','T')
insert into DESIGNATION_INFO  values (@HD_ID, @BR_ID, 'Peon','NA','T')
insert into DESIGNATION_INFO  values (@HD_ID, @BR_ID, 'Gateman','NA','T')

--Degree Info
insert into DEGREE_INFO  values (@HD_ID, @BR_ID, 'BA','NA','T')
insert into DEGREE_INFO  values (@HD_ID, @BR_ID, 'MA','NA','T')
insert into DEGREE_INFO  values (@HD_ID, @BR_ID, 'B.Sc','NA','T')
insert into DEGREE_INFO  values (@HD_ID, @BR_ID, 'B.Ed','NA','T')
insert into DEGREE_INFO  values (@HD_ID, @BR_ID, 'M. Ed','NA','T')
insert into DEGREE_INFO  values (@HD_ID, @BR_ID, 'F.A','NA','T')
insert into DEGREE_INFO  values (@HD_ID, @BR_ID, 'M.Sc','NA','T')
insert into DEGREE_INFO  values (@HD_ID, @BR_ID, 'Matric','NA','T')
insert into DEGREE_INFO  values (@HD_ID, @BR_ID, 'MBA','NA','T')
insert into DEGREE_INFO  values (@HD_ID, @BR_ID, 'BBA','NA','T')
insert into DEGREE_INFO  values (@HD_ID, @BR_ID, 'B.Com','NA','T')
insert into DEGREE_INFO  values (@HD_ID, @BR_ID, 'M.Com','NA','T')

--Language Info
insert into LANG_INFO  values (@HD_ID, @BR_ID, 'Urdu','NA','T')
insert into LANG_INFO  values (@HD_ID, @BR_ID, 'English','NA','T')
insert into LANG_INFO  values (@HD_ID, @BR_ID, 'Punjabi','NA','T')

--Religion Info
insert into RELIGION_INFO  values (@HD_ID, @BR_ID, 'Muslim','NA','T')
insert into RELIGION_INFO values (@HD_ID, @BR_ID, 'Non Muslim','NA','T')

--Transport Info
insert into TRANSPORT_INFO values (@HD_ID, @BR_ID, 'Own','NA','T')
insert into TRANSPORT_INFO values (@HD_ID, @BR_ID, 'School Van','NA','T')

--Relation ship Info
insert into PEOPLE_RELATIONS_INFO values (@HD_ID, @BR_ID, 'Father','NA','T')
insert into PEOPLE_RELATIONS_INFO values (@HD_ID, @BR_ID, 'Mother','NA','T')
insert into PEOPLE_RELATIONS_INFO values (@HD_ID, @BR_ID, 'Sister','NA','T')
insert into PEOPLE_RELATIONS_INFO values (@HD_ID, @BR_ID, 'Brother','NA','T')
insert into PEOPLE_RELATIONS_INFO values (@HD_ID, @BR_ID, 'Uncle','NA','T')
insert into PEOPLE_RELATIONS_INFO values (@HD_ID, @BR_ID, 'Aunti','NA','T')

--Fee Info
insert into FEE_INFO values (@HD_ID, @BR_ID, 'Tuition Fee','NA','T', 'Monthly', '01', 1,'+',1,'F')
insert into FEE_INFO values (@HD_ID, @BR_ID, 'Registration Fee','NA','T', 'Yearly', '01', 2,'+',2,'F')
insert into FEE_INFO values (@HD_ID, @BR_ID, 'Security Fee','NA','T', 'Yearly', '05', 3,'+',3,'F')
insert into FEE_INFO values (@HD_ID, @BR_ID, 'Admission Fee','NA','T', 'Once', '01', 4,'+',4,'F')
insert into FEE_INFO values (@HD_ID, @BR_ID, 'Computer Lab Fee','NA','T', 'Yearly', '01', 5,'+',5,'F')
insert into FEE_INFO values (@HD_ID, @BR_ID, 'Late Fee Fine','NA','T', 'Monthly', '01', 6,'+',6,'F')
insert into FEE_INFO values (@HD_ID, @BR_ID, 'Exam Charges','NA','T', 'Custom', '05', 7,'+',7,'F')
insert into FEE_INFO values (@HD_ID, @BR_ID, 'Misc Fee','NA','T', 'Once', '01', 8,'+',8,'F')
insert into FEE_INFO values (@HD_ID, @BR_ID, 'Reprinting Charges','NA','T', 'Once', '01', 9,'+',9,'F')
insert into FEE_INFO values (@HD_ID, @BR_ID, 'Discount','NA','T', 'Monthly', '01', 10,'-',10,'F')

--SMS Screen
insert into SMS_SCREEN values (@HD_ID,@BR_ID,'Staff Registration','T','T','F','F','F','F','F','T','T',GETDATE(),'T','Teacher.aspx')
insert into SMS_SCREEN values (@HD_ID,@BR_ID,'Staff Attendance','T', 'T', 'F', 'F', 'F', 'F', 'F', 'F', 'T', GETDATE(),'T' ,'ATTENDANCE_Teachers_others.aspx')
insert into SMS_SCREEN values (@HD_ID,@BR_ID,'Manual SMS','T', 'F', 'F', 'F', 'T' ,'T', 'T' ,'T' ,'T', GETDATE(), 'T' ,'SMS_MANUALLY.aspx')
insert into SMS_SCREEN values (@HD_ID,@BR_ID,'Student Registration','T', 'T' ,'F' ,'F' ,'T' ,'F' ,'F' ,'F' ,'F' ,GETDATE(),'T' ,'Student.aspx')
insert into SMS_SCREEN values (@HD_ID,@BR_ID,'Guardian Registration','T' ,'T' ,'F' ,'F' ,'F' ,'T' ,'F' ,'F' ,'F' ,GETDATE(),'T' ,'Parent.aspx')
insert into SMS_SCREEN values (@HD_ID,@BR_ID,'Student Attendance','T', 'T', 'F', 'F', 'T', 'F', 'F', 'F', 'F', GETDATE(),'T','ATTENDANCE_Student.aspx')
insert into SMS_SCREEN values (@HD_ID,@BR_ID,'Student Attendance','T', 'T', 'F', 'F', 'F', 'T', 'F', 'F', 'F', GETDATE(),'T','ATTENDANCE_Student.aspx')
insert into SMS_SCREEN values (@HD_ID,@BR_ID,'Student Registration','T', 'T', 'F', 'F', 'F', 'T', 'F', 'F', 'F', GETDATE(),'T' ,'Student.aspx')
insert into SMS_SCREEN values (@HD_ID,@BR_ID,'Simple Fee Collection','F', 'T', 'F', 'F', 'T', 'F', 'F', 'F', 'F', GETDATE(),'T','Fee_collection_simple.aspx')
insert into SMS_SCREEN values (@HD_ID,@BR_ID,'Simple Fee Collection','F', 'T', 'F', 'F', 'F', 'T', 'F', 'F', 'F', GETDATE(),'T','Fee_collection_simple.aspx')
insert into SMS_SCREEN values (@HD_ID,@BR_ID,'Advance Fee Collection','F', 'T', 'F', 'F', 'T', 'F', 'F', 'F', 'F', GETDATE(),'T','Fee_collection.aspx')
insert into SMS_SCREEN values (@HD_ID,@BR_ID,'Advance Fee Collection','F', 'T', 'F', 'F', 'F', 'T', 'F', 'F', 'F', GETDATE(),'T','Fee_collection.aspx')
insert into SMS_SCREEN values (@HD_ID,@BR_ID,'Pay Collection','F', 'T', 'F', 'F', 'F', 'F', 'F', 'F', 'T', GETDATE(),'T','PAY_COLLECTION.aspx')
insert into SMS_SCREEN values (@HD_ID,@BR_ID,'Fee Generation','T', 'F', 'F', 'F', 'T', 'F', 'F', 'T', 'F', GETDATE(),'T','Fee_generate.aspx')
insert into SMS_SCREEN values (@HD_ID,@BR_ID,'Fee Generation','T', 'F', 'F', 'F', 'F', 'T', 'F', 'F', 'F', GETDATE(),'T','Fee_generate.aspx')
insert into SMS_SCREEN values (@HD_ID,@BR_ID,'Pay Slip Generation','T', 'F', 'F', 'F', 'F', 'F', 'F', 'F', 'T', GETDATE(),'T','Payslip_Generate.aspx')
insert into SMS_SCREEN values (@HD_ID,@BR_ID,'Owner Notification','T', 'F', 'F', 'F', 'F', 'F', 'F', 'T', 'F', GETDATE(),'T','Notification_Owner.aspx')
insert into SMS_SCREEN values (@HD_ID,@BR_ID,'Student Birthday Notification','T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', GETDATE(),'T','Notification.aspx')
insert into SMS_SCREEN values (@HD_ID,@BR_ID,'Fee Dues Notification','T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', GETDATE(),'T','Notification_Fee_Dues.aspx')
insert into SMS_SCREEN values (@HD_ID,@BR_ID,'Exam Notification','T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', GETDATE(),'T','Notification_Exam.aspx')
insert into SMS_SCREEN values (@HD_ID,@BR_ID,'Attendance Staff Notification','T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', GETDATE(),'T','Notification_Attendance_Staff.aspx')
insert into SMS_SCREEN values (@HD_ID,@BR_ID,'Attendance Student Notification','T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', GETDATE(),'T','Notification_Attendance_Student.aspx')

-- Select SMS_SCREEN_ID,SMS_SCREEN_NAME,RIGHTS_PAGE_NAME from SMS_SCREEN WHERE SMS_SCREEN_HD_ID=2 AND SMS_SCREEN_BR_ID=1
--SMS variable
insert into SMS_VARIABLES values (@HD_ID,@BR_ID,'Staff',	GETDATE(),	'T' )
insert into SMS_VARIABLES values (@HD_ID,@BR_ID,'Student',	GETDATE(),'T' )
insert into SMS_VARIABLES values (@HD_ID,@BR_ID,'Parent',	GETDATE(),	'T' )
insert into SMS_VARIABLES values (@HD_ID,@BR_ID,'Att. Remarks',	GETDATE(),	'T' )
insert into SMS_VARIABLES values (@HD_ID,@BR_ID,'Time In',	GETDATE(),	'T' )
insert into SMS_VARIABLES values (@HD_ID,@BR_ID,'Time Out',	GETDATE(),	'T' )
insert into SMS_VARIABLES values (@HD_ID,@BR_ID,'Date',	GETDATE(),	'T' )
insert into SMS_VARIABLES values (@HD_ID,@BR_ID,'Invoice No',	GETDATE(),	'T' )
insert into SMS_VARIABLES values (@HD_ID,@BR_ID,'Total Fee',	GETDATE(),	'T' )
insert into SMS_VARIABLES values (@HD_ID,@BR_ID,'Fee Received',	GETDATE(),	'T' )
insert into SMS_VARIABLES values (@HD_ID,@BR_ID,'Fee Status',	GETDATE(),	'T' )
insert into SMS_VARIABLES values (@HD_ID,@BR_ID,'Total Salary',	GETDATE(),	'T' )
insert into SMS_VARIABLES values (@HD_ID,@BR_ID,'Salary Received',	GETDATE(),	'T' )
insert into SMS_VARIABLES values (@HD_ID,@BR_ID,'Month',	GETDATE(),	'T' )
insert into SMS_VARIABLES values (@HD_ID,@BR_ID,'Salary',	GETDATE(),	'T') 




declare @screen_id int = 0
set @screen_id = (select SMS_SCREEN_ID from SMS_SCREEN where SMS_SCREEN_NAME = 'Staff Registration' and SMS_SCREEN_HD_ID = @HD_ID and SMS_SCREEN_BR_ID = @BR_ID)
insert into SMS_TEMPLATE values (@HD_ID, @BR_ID, @screen_id, 'Dear ^Staff^, You has been registered in our branch. Kindly contact admin office for your detailed information.','^Staff^','Dear ^Staff^, Your information has been updated in our branch. Kindly contact admin office for your detailed information.','^Staff^', '','','','','a', GETDATE(),'T')

set @screen_id = (select SMS_SCREEN_ID from SMS_SCREEN where SMS_SCREEN_NAME = 'Student Registration' and SMS_SCREEN_HD_ID = @HD_ID and SMS_SCREEN_BR_ID = @BR_ID and SMS_SCREEN_STUDENT = 'T')
insert into SMS_TEMPLATE values (@HD_ID, @BR_ID, @screen_id, 'Dear ^Student^,You has been registered in our branch. Kindly contact admin office for your detailed information.','^Student^','Dear ^Student^,Your information has been updated in our branch. Kindly contact admin office for your detailed information.','^Student^', '','','','','a', GETDATE(),'F')

set @screen_id = (select SMS_SCREEN_ID from SMS_SCREEN where SMS_SCREEN_NAME = 'Gardian Registration' and SMS_SCREEN_HD_ID = @HD_ID and SMS_SCREEN_BR_ID = @BR_ID)
insert into SMS_TEMPLATE values (@HD_ID, @BR_ID, @screen_id, 'Dear ^Parent^ added','^Parent^', 'Dear ^Parent^ updated','^Parent^','','','','','a', GETDATE(),'T')

set @screen_id = (select SMS_SCREEN_ID from SMS_SCREEN where SMS_SCREEN_NAME = 'Student Attendance' and SMS_SCREEN_HD_ID = @HD_ID and SMS_SCREEN_BR_ID = @BR_ID and SMS_SCREEN_STUDENT = 'T')
insert into SMS_TEMPLATE values (@HD_ID, @BR_ID, @screen_id, 'Dear ^Student^, Your today attendance status is ^Att. Remarks^.','^Student^,^Att. Remarks^', 'Dear ^Student^, Your today attendance status is ^Att. Remarks^.','^Student^,^Att. Remarks^','','','','','a', GETDATE(),'F')

set @screen_id = (select SMS_SCREEN_ID from SMS_SCREEN where SMS_SCREEN_NAME = 'Student Attendance' and SMS_SCREEN_HD_ID = @HD_ID and SMS_SCREEN_BR_ID = @BR_ID and SMS_SCREEN_PARENTS = 'T')
insert into SMS_TEMPLATE values (@HD_ID, @BR_ID, @screen_id, 'Dear ^Parent^, Your child ^Student^ is ^Att. Remarks^ in the class.','^Parent^,^Student^,^Att. Remarks^', 'Dear ^Parent^, Your child ^Student^ is ^Att. Remarks^ in the class.','^Parent^,^Student^,^Att. Remarks^','','','','','a', GETDATE(),'T')

set @screen_id = (select SMS_SCREEN_ID from SMS_SCREEN where SMS_SCREEN_NAME = 'Student Registration' and SMS_SCREEN_HD_ID = @HD_ID and SMS_SCREEN_BR_ID = @BR_ID and SMS_SCREEN_PARENTS = 'T')
insert into SMS_TEMPLATE values (@HD_ID, @BR_ID, @screen_id, 'Dear ^Parent^, Your child  ^Student^ has been registered in our branch.','^Parent^,^Student^','Dear ^Parent^, Your child ^Student^ information has been update in our branch.','^Parent^,^Student^', '','','','','a', GETDATE(),'T')

set @screen_id = (select SMS_SCREEN_ID from SMS_SCREEN where SMS_SCREEN_NAME = 'Staff Attendance' and SMS_SCREEN_HD_ID = @HD_ID and SMS_SCREEN_BR_ID = @BR_ID)
insert into SMS_TEMPLATE values (@HD_ID, @BR_ID, @screen_id, 'Dear ^Staff^, Your today (^Date^) attendance status is ^Att. Remarks^. Below is your timings: Time in: ^Time In^ Time Out: ^Time Out^','^Staff^,^Date^,^Att. Remarks^,^Time In^,^Time Out^', 'Dear ^Staff^, Your today (^Date^) attendance status is ^Att. Remarks^. Below is your timings: Time in: ^Time In^ Time Out: ^Time Out^','^Staff^,^Date^,^Att. Remarks^,^Time In^,^Time Out^','','','','','a', GETDATE(),'T')

set @screen_id = (select SMS_SCREEN_ID from SMS_SCREEN where SMS_SCREEN_NAME = 'Simple Fee Collection' and SMS_SCREEN_HD_ID = @HD_ID and SMS_SCREEN_BR_ID = @BR_ID and SMS_SCREEN_STUDENT = 'T')
insert into SMS_TEMPLATE values (@HD_ID, @BR_ID, @screen_id, '','','Dear ^Student^, Your Fee ^Total Fee^ against Invoice# ^Invoice No^ has been successfully received.','^Student^,^Total Fee^,^Invoice No^','','','','','a', GETDATE(),'F')

set @screen_id = (select SMS_SCREEN_ID from SMS_SCREEN where SMS_SCREEN_NAME = 'Simple Fee Collection' and SMS_SCREEN_HD_ID = @HD_ID and SMS_SCREEN_BR_ID = @BR_ID and SMS_SCREEN_PARENTS = 'T')
insert into SMS_TEMPLATE values (@HD_ID, @BR_ID, @screen_id, '','','Dear ^Parent^, Your child ^Student^ Fee ^Total Fee^ against Invoice# ^Invoice No^ has been successfully received.','^Parent^,^Student^,^Total Fee^,^Invoice No^','','','','','a', GETDATE(),'T')

set @screen_id = (select SMS_SCREEN_ID from SMS_SCREEN where SMS_SCREEN_NAME = 'Advance Fee Collection' and SMS_SCREEN_HD_ID = @HD_ID and SMS_SCREEN_BR_ID = @BR_ID and SMS_SCREEN_STUDENT = 'T')
insert into SMS_TEMPLATE values (@HD_ID, @BR_ID, @screen_id, '','','Dear ^Student^, Below is your fee status: Total Fee:^Total Fee^ Fee Received: ^Fee Received^ Invoice#: ^Invoice No^ Fee Current Status: ^Fee Status^','^Student^,^Fee Received^,^Total Fee^,^Invoice No^,^Fee Status^','','','','','a', GETDATE(),'F')

set @screen_id = (select SMS_SCREEN_ID from SMS_SCREEN where SMS_SCREEN_NAME = 'Advance Fee Collection' and SMS_SCREEN_HD_ID = @HD_ID and SMS_SCREEN_BR_ID = @BR_ID and SMS_SCREEN_PARENTS = 'T')
insert into SMS_TEMPLATE values (@HD_ID, @BR_ID, @screen_id, '','','Dear ^Parent^, Your child ^Student^ Fee ^Total Fee^ against Invoice# ^Invoice No^ has been successfully received.','^Parent^,^Student^,^Fee Received^,^Total Fee^,^Invoice No^,^Fee Status^','','','','','a', GETDATE(),'T')

set @screen_id = (select SMS_SCREEN_ID from SMS_SCREEN where SMS_SCREEN_NAME = 'Pay Collection' and SMS_SCREEN_HD_ID = @HD_ID and SMS_SCREEN_BR_ID = @BR_ID)
insert into SMS_TEMPLATE values (@HD_ID, @BR_ID, @screen_id, '','','Dear ^Staff^, You Received your salary amount ^Salary Received^ from Total Salary amount ^Total Salary^ against ^Invoice No^.','^Staff^,^Salary Received^,^Total Salary^,^Invoice No^','','','','','a', GETDATE(),'T')

set @screen_id = (select SMS_SCREEN_ID from SMS_SCREEN where SMS_SCREEN_NAME = 'Fee Generation' and SMS_SCREEN_HD_ID = @HD_ID and SMS_SCREEN_BR_ID = @BR_ID and SMS_SCREEN_STUDENT = 'T')
insert into SMS_TEMPLATE values (@HD_ID, @BR_ID, @screen_id,'Dear ^Student^, Your Total Fee ^Total Fee^ against Invoice No ^Invoice No^ of the month ^Month^ has been generated','^Student^,^Total Fee^,^Invoice No^,^Month^','','','','','','','a', GETDATE(),'F')

set @screen_id = (select SMS_SCREEN_ID from SMS_SCREEN where SMS_SCREEN_NAME = 'Fee Generation' and SMS_SCREEN_HD_ID = @HD_ID and SMS_SCREEN_BR_ID = @BR_ID and SMS_SCREEN_PARENTS = 'T')
insert into SMS_TEMPLATE values (@HD_ID, @BR_ID, @screen_id,'Dear ^Parent^, Your child ^Student^ Total Fee amount ^Total Fee^ against Invoice No ^Invoice No^ for the month of  ^Month^ has been  generated','^Parent^,^Student^,^Total Fee^,^Invoice No^,^Month^','','','','','','','a', GETDATE(),'T')

set @screen_id = (select SMS_SCREEN_ID from SMS_SCREEN where SMS_SCREEN_NAME = 'Pay Slip Generation' and SMS_SCREEN_HD_ID = @HD_ID and SMS_SCREEN_BR_ID = @BR_ID )
insert into SMS_TEMPLATE values (@HD_ID, @BR_ID, @screen_id,'Dear ^Staff^, Your Salary amount ^Salary^ against Invoice ^Invoice No^ for the month of ^Month^ has been generated','^Staff^,^Salary^,^Invoice No^,^Month^','','','','','','','a', GETDATE(),'T')

set @screen_id = (select SMS_SCREEN_ID from SMS_SCREEN where SMS_SCREEN_NAME = 'Owner Notification' and SMS_SCREEN_HD_ID = @HD_ID and SMS_SCREEN_BR_ID = @BR_ID )
insert into SMS_TEMPLATE values (@HD_ID, @BR_ID, @screen_id,'Dear ^Name^ Summary of today ^Start Date^ Total Staff ^Total Staff^ New Staff ^New Staff^  Left Staff ^Left Staff^ Staff Present ^Staff Present^ Staff Absent ^Staff Absent^ Staff Leave ^Staff Leave^ Staff Late ^Staff Late^ Average Time In ^Average Time In^ Average Time Out ^Average Time Out^ Average Working Hours ^Average Working Hours^','','','','','','','','a', GETDATE(),'T')

set @screen_id = (select SMS_SCREEN_ID from SMS_SCREEN where SMS_SCREEN_NAME = 'Student Birthday Notification' and SMS_SCREEN_HD_ID = @HD_ID and SMS_SCREEN_BR_ID = @BR_ID )
insert into SMS_TEMPLATE values (@HD_ID, @BR_ID, @screen_id,'Dear ^Name^ today is your birthday','','','','','','','','a', GETDATE(),'T')

set @screen_id = (select SMS_SCREEN_ID from SMS_SCREEN where SMS_SCREEN_NAME = 'Fee Dues Notification' and SMS_SCREEN_HD_ID = @HD_ID and SMS_SCREEN_BR_ID = @BR_ID )
insert into SMS_TEMPLATE values (@HD_ID, @BR_ID, @screen_id,'dear  ^Guardian Name^ your child ^Name^ remaining fee is  ^Fee^ and due date is  ^Due Date^. Please clear your dues on time','','','','','','','','a', GETDATE(),'T')

set @screen_id = (select SMS_SCREEN_ID from SMS_SCREEN where SMS_SCREEN_NAME = 'Exam Notification' and SMS_SCREEN_HD_ID = @HD_ID and SMS_SCREEN_BR_ID = @BR_ID )
insert into SMS_TEMPLATE values (@HD_ID, @BR_ID, @screen_id,'Dear ^Guardian Name^ your child ^Student Name^ roll no ^Roll No^ Class: ^Class Name^ Term: ^Term^ Max Marks: ^Max Marks^ Obtained Marks: ^Obtained Marks^ Percent: ^Percent^ Grade: ^Grade^ Position: ^Position^ Remarks: ^Remarks^','','','','','','','','a', GETDATE(),'T')

set @screen_id = (select SMS_SCREEN_ID from SMS_SCREEN where SMS_SCREEN_NAME = 'Attendance Staff Notification' and SMS_SCREEN_HD_ID = @HD_ID and SMS_SCREEN_BR_ID = @BR_ID )
insert into SMS_TEMPLATE values (@HD_ID, @BR_ID, @screen_id,'Dear ^Name^ Your Designation is ^Designation^ Total Days: ^Total Days^ Working Days: ^Working Days^ Present: ^Present^ Absent: ^Absent^ Leave: ^Leave^ Late: ^Late^ Average Time In: ^Average Time In^ Average Time Out: ^Average Time Out^ Average Woking Hours: ^Average Woking Hours^ Start Date: ^Start Date^ End Date: ^End Date^','','','','','','','','a', GETDATE(),'T')

set @screen_id = (select SMS_SCREEN_ID from SMS_SCREEN where SMS_SCREEN_NAME = 'Attendance Student Notification' and SMS_SCREEN_HD_ID = @HD_ID and SMS_SCREEN_BR_ID = @BR_ID )
insert into SMS_TEMPLATE values (@HD_ID, @BR_ID, @screen_id,'Dear ^Guardian Name^ your child ^Name^ Class: ^Class Name^ Total Days: ^Total Days^ Study Days: ^Study Days^ Present: ^Present^ Absent: ^Absent^ Leave: ^Leave^ Late: ^Late^ Start Date: ^Start Date^ End Date: ^End Date^','','','','','','','','a', GETDATE(),'T')



--working days
insert into WORKING_DAYS values( @HD_ID, @BR_ID, 'Monday', @BR_ID,'T','T')
insert into WORKING_DAYS values( @HD_ID, @BR_ID, 'Tuesday', @BR_ID,'T','T')
insert into WORKING_DAYS values( @HD_ID, @BR_ID, 'Wednesday', @BR_ID,'T','T')
insert into WORKING_DAYS values( @HD_ID, @BR_ID, 'Thursday', @BR_ID,'T','T')
insert into WORKING_DAYS values( @HD_ID, @BR_ID, 'Friday', @BR_ID,'T','T')
insert into WORKING_DAYS values( @HD_ID, @BR_ID, 'Saturday', @BR_ID,'T','T')
insert into WORKING_DAYS values( @HD_ID, @BR_ID, 'Sunday', 0,'T','T')

--working hours
insert into WORKING_HOURS values(@HD_ID, @BR_ID,'8:00 AM', '2:00 PM', 'T' )


select 'ok' as [Status], @MAIN_INFO_INSTITUTION_LOGO as [Path], @school_user_name as [School Username], @school_password as [School Password],
@branch_user_name as [Branch Username], @branch_password as [Branch Password]