



CREATE procedure  [dbo].[sp_BR_ADMIN_insertion]                                               	   

          @BR_ADM_ID  numeric,
          @BR_ADM_HD_ID  numeric,
          @BR_ADM_NAME  nvarchar(50) ,
          @BR_ADM_ADDRESS  nvarchar(100) ,
          @BR_ADM_PHONE  nvarchar(50) ,
          @BR_ADM_EMAIL  nvarchar(50) ,
          @BR_ADM_MOBILE  nvarchar(50) ,
          @BR_ADM_FAX  nvarchar(50) ,
          @BR_ADM_STATUS  char(2) ,
		  @BR_ADM_CITY numeric,
		  @BR_ADM_COUNTRY numeric,
		  @BR_ADM_BANK_NAME nvarchar(50),
		  @BR_ADM_ACCT_TITLE nvarchar(50),
		  @BR_ADM_ACCT_NO nvarchar(50),
		  @BR_ADM_STAFF_CENT_BR_ID int,
		  @BR_ADM_PARENT_CENT_BR_ID int,
		  @BR_ADM_ASSEMENT_TYPE nvarchar(50),
		  
		  @BR_ADM_ACCT_START_DATE DATE,
		  @BR_ADM_ACCT_END_DATE DATE,
		  @WORKING_HOURS_TIME_IN nvarchar(20),
		  @WORKING_HOURS_TIME_OUT nvarchar(20),
		  @BR_ADM_WEBSITE NVARCHAR(50),

		  
          @FEE_SETTING_FINE  int,
          @FEE_SETTING_REPRINT_CHARGES  float,
          @FEE_SETTING_FEE_CRITERIA  int ,
          @BR_ADM_FEE_HISTORY  bit,
          @FEE_SETTING_REPRINT_HISTORY  bit,
          @FEE_SETTING_ARREARS_WITH_DUE_DATE  bit,
		  @FEE_SETTING_INVOICE_MOBILE_NO NVARCHAR(100),
		  
		  @REPORT_SETTING_REPORT_NAME nvarchar(50),
		  @REPORT_SETTING_REPORT_VALUE nvarchar(50),
		  
		  @USER_NAME nvarchar(50),
		  @USER_PASSWORD nvarchar(50),
		  @USER_STATUS char(2),
		  @BR_ADM_SMS_API_ID numeric,
		  @BR_ADM_PAYROLL_MINUTES_IN_HOUR int,
		  @BR_ADM_PAYROLL_HOURS_IN_DAY int,
		  @BR_ADM_PAYROLL_IS_OVERTIME_MONTHLY_SLIP_GENERATE char(1),
		  @BR_ADM_PAYROLL_LATE_MINUTES int,
		  @BR_ADM_PAYROLL_COMMSSION_FORMULA nvarchar(200),
		  @BR_ADM_OVERTIME_AFTER_TIMEOUT char(1),
		  @BR_ADM_OVERTIME_CALCULATION_TYPE nvarchar(50),
		  @BR_ADM_IS_ADVANCE_ACCOUNTING	bit,
		  @BR_ADM_IS_ADVANCE_CLASS_PLAN	bit,
          @BR_ADM_IS_FEES_WITH_ACCOUNTS	bit,
		  @BR_ADM_FEES_PER_MONTHS float,
		  @BR_ADM_STUDENT_LATE_MINUTES int,
		  @BR_ADM_SESSION numeric,
		  @BR_ADM_EARLY_MINUTES_ALLOWED int,
		  @BR_ADM_HALF_DAY_MINUTES int,
		  @BANK_DETAIL1 nvarchar(MAX),
		  @BANK_DETAIL2 nvarchar(MAX),
		  @CO_TITLE nvarchar(500)
		  		
   as  begin   
   declare @count int
   declare @brachces int
   declare @id NVARCHAR(10) 
   
   set @brachces = (select MAIN_INFO_BRANCHES from MAIN_HD_INFO where MAIN_INFO_ID = @BR_ADM_HD_ID)
   set @brachces = (select ISNULL( @brachces,0))
   set @count = (select COUNT(BR_ADM_ID) from dbo.BR_ADMIN where BR_ADM_HD_ID = @BR_ADM_HD_ID)
   --set @BR_ADM_SMS_API_ID = (select MAX(SMS_API_ID) from SMS_API)
   
   if @count < @brachces
   
   begin				 
			    
				   
				  
				   
					 insert into BR_ADMIN
					 values
					 (
						@BR_ADM_HD_ID,
						@BR_ADM_NAME,
						@BR_ADM_ADDRESS,
						@BR_ADM_PHONE,
						@BR_ADM_EMAIL,
						@BR_ADM_MOBILE,
						@BR_ADM_FAX,
						@BR_ADM_STATUS,
					    @BR_ADM_CITY ,
					    @BR_ADM_COUNTRY,					    
						@BR_ADM_ACCT_START_DATE,
						@BR_ADM_ACCT_END_DATE,
						@BR_ADM_WEBSITE,
						@BR_ADM_BANK_NAME,
						@BR_ADM_ACCT_TITLE,
						@BR_ADM_ACCT_NO,
						'',
						@BR_ADM_STAFF_CENT_BR_ID,
						@BR_ADM_PARENT_CENT_BR_ID,
						@BR_ADM_ASSEMENT_TYPE,
						@BR_ADM_SMS_API_ID,
						@BR_ADM_PAYROLL_MINUTES_IN_HOUR ,
						@BR_ADM_PAYROLL_HOURS_IN_DAY,
						@BR_ADM_PAYROLL_IS_OVERTIME_MONTHLY_SLIP_GENERATE,
						@BR_ADM_PAYROLL_LATE_MINUTES,
						@BR_ADM_PAYROLL_COMMSSION_FORMULA,
						@BR_ADM_OVERTIME_AFTER_TIMEOUT,
						@BR_ADM_OVERTIME_CALCULATION_TYPE,
						@BR_ADM_IS_ADVANCE_ACCOUNTING,
						@BR_ADM_IS_ADVANCE_CLASS_PLAN,
						@BR_ADM_IS_FEES_WITH_ACCOUNTS,
						@BR_ADM_FEES_PER_MONTHS,
						CAST(0 as bit),
						CAST(0 as bit),
						CAST(0 as bit),
						@BR_ADM_STUDENT_LATE_MINUTES,
						@BR_ADM_SESSION ,
						@BR_ADM_EARLY_MINUTES_ALLOWED ,		  
						@BR_ADM_HALF_DAY_MINUTES,
						0,0,0,'','',CAST(0 as bit),'GoudySans Blk BT'
					 )


					 --set @id = ( select  isnull( (max( BR_ADM_ID )),0) + 1 from  BR_ADMIN )  
					 set @id = SCOPE_IDENTITY()
					 
					 insert into FeeChallanBankDetail 
					select @BR_ADM_HD_ID, @id, @BANK_DETAIL1,@BANK_DETAIL2,@CO_TITLE, '','','',CAST(0 as bit),GETDATE(),NULL,NULL,NULL

					 insert into COMBINE_BRANCHES values (@id,@id)
				DECLARE @TEMP INT
				SET @TEMP =  (SELECT(LEN(@id)))
				IF @TEMP=1
				BEGIN
					SET @id = '00'+@id
				END
				ELSE IF @TEMP=2
				BEGIN
					SET @id = '0'+@id
				END
					
					insert into USER_INFO
					 values
					 (
					  @BR_ADM_HD_ID,
					  @id,
					  @id,
					  @USER_NAME + '-' + @id +  '-0000',
					  @BR_ADM_NAME,
					  'A',
					  @USER_PASSWORD,
					  @USER_STATUS,
					  NULL
					 )

					exec [sp_WORKING_HOURS_insertion] @BR_ADM_HD_ID, @id, @WORKING_HOURS_TIME_IN, @WORKING_HOURS_TIME_OUT,@BR_ADM_STATUS
					exec [sp_FEE_SETTING_insertion] @BR_ADM_HD_ID, @id, @FEE_SETTING_FINE,@FEE_SETTING_REPRINT_CHARGES,@FEE_SETTING_FEE_CRITERIA,@BR_ADM_FEE_HISTORY,@FEE_SETTING_REPRINT_HISTORY,@FEE_SETTING_ARREARS_WITH_DUE_DATE, @FEE_SETTING_INVOICE_MOBILE_NO

					insert into REPORT_SETTING
					values
					(
						@BR_ADM_HD_ID,
						@id,
						@REPORT_SETTING_REPORT_NAME,
						@REPORT_SETTING_REPORT_VALUE,
						'T'
					)

					update USER_INFO set USER_BR_ID = @id where USER_TYPE = 'SA' and USER_HD_ID = @BR_ADM_HD_ID and USER_BR_ID = 0
					
					if @count = 1
					begin
						update RIGHTS_PACKAGES_PARENT set PACKAGES_BR_ID = @id where PACKAGES_HD_ID = @BR_ADM_HD_ID and PACKAGES_BR_ID =1 and PACKAGES_TYPE = 1
					end
					
					
					declare @HD_ID numeric = @BR_ADM_HD_ID
					declare @BR_ID numeric = @id





declare @date_format int = 0
declare @intitute_level int = 0
declare @country_id int = 0
declare @city_id int = 0
declare @sms_api int = 0
declare @SMS_BRAND_NAME nvarchar(100)

					
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
and inst_level_name in (select inst_level_name from INSTITUTION_LEVEL_INFO where inst_level_id = 1))

--nationality info --update in branch also
insert into NATIONALITY_INFO values (@HD_ID, @BR_ID, 'Pakistan','NA','T')

set @country_id = (select NATIONALITY_ID from NATIONALITY_INFO where NATIONALITY_HD_ID = @HD_ID and NATIONALITY_BR_ID = @BR_ID and NATIONALITY_NAME in 
(select NATIONALITY_NAME from NATIONALITY_INFO where NATIONALITY_ID = 1))

update MAIN_HD_INFO set MAIN_INFO_COUNTRY = @country_id, MAIN_INFO_INSTITUTION_LEVEL = @intitute_level, main_info_date_format = @date_format
where main_info_id = @HD_ID

set @country_id = (select NATIONALITY_ID from NATIONALITY_INFO where NATIONALITY_HD_ID = @HD_ID and NATIONALITY_BR_ID = @BR_ID and NATIONALITY_NAME in 
(select NATIONALITY_NAME from NATIONALITY_INFO where NATIONALITY_ID = @BR_ADM_COUNTRY))

set @city_id = (select CITY_ID from CITY_INFO where CITY_HD_ID = @HD_ID and CITY_BR_ID = @BR_ID and CITY_NAME in 
(select CITY_NAME from CITY_INFO where CITY_ID = @BR_ADM_COUNTRY))

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

update BR_ADMIN set BR_ADM_COUNTRY = @country_id, BR_ADM_CITY = @city_id ,BR_ADM_SMS_API_ID = @sms_api where BR_ADM_HD_ID = @HD_ID and BR_ADM_ID = @BR_ID


-- no relation with hd and br
-- Report Setting
--insert into REPORT_SETTING values (@HD_ID, @BR_ID, 'Fee Challan', 'landscape_simple_3', 'T')

----Fee Setting
--insert into FEE_SETTING values (@HD_ID, @BR_ID, 0,0,0,@BR_ID,@BR_ID,@BR_ID,'Parent') 

--
select * from SESSION_INFO
declare @session_rank int = (select MAX(SESSION_RANK) from SESSION_INFO where SESSION_HD_ID = @HD_ID and SESSION_BR_ID = @BR_ID)
insert into SESSION_INFO values (@HD_ID, @BR_ID, '','T',@BR_ADM_ACCT_START_DATE, @BR_ADM_ACCT_END_DATE, (@session_rank + 1))
declare @session_Id numeric =  (select SCOPE_IDENTITY()) --select top(1)  SESSION_ID from SESSION_INFO order by id desc 

--Term Info
declare @session_start_date date = ''
declare @session_end_date date = ''
set @session_start_date = (select top(1) BR_ADM_ACCT_START_DATE from BR_ADMIN where BR_ADM_HD_ID = @HD_ID and BR_ADM_ID = @BR_ID)
set @session_end_date = (select top(1) BR_ADM_ACCT_END_DATE from BR_ADMIN where BR_ADM_HD_ID = @HD_ID and BR_ADM_ID = @BR_ID)

insert into TERM_INFO values (@HD_ID, @BR_ID, 'Mid Semester 1', 'NA', 'T', DATEADD(MM,0, @session_start_date), DATEADD(MM,3, @session_end_date), @session_start_date, @session_end_date, 1,@session_Id)
insert into TERM_INFO values (@HD_ID, @BR_ID, 'End Semester 1', 'NA', 'T', DATEADD(MM,3, @session_start_date), DATEADD(MM,6, @session_end_date), @session_start_date, @session_end_date,2,@session_Id)
insert into TERM_INFO values (@HD_ID, @BR_ID, 'Mid Semester 2', 'NA', 'T', DATEADD(MM,6, @session_start_date), DATEADD(MM,9, @session_end_date), @session_start_date, @session_end_date,3,@session_Id)
insert into TERM_INFO values (@HD_ID, @BR_ID, 'End Semester 2', 'NA', 'T', DATEADD(MM,9, @session_start_date), DATEADD(MM,12, @session_end_date), @session_start_date, @session_end_date,4,@session_Id)


--Department Info
insert into DEPARTMENT_INFO values (@HD_ID, @BR_ID, 'Computer Science','NA','T',1)
insert into DEPARTMENT_INFO values (@HD_ID, @BR_ID, 'Study', 'NA','T',2)

--Section Info
insert into SECTION_INFO values (@HD_ID, @BR_ID,'A', 'NA', 'T')
insert into SECTION_INFO values (@HD_ID, @BR_ID,'B', 'NA', 'T')
insert into SECTION_INFO values (@HD_ID, @BR_ID,'C', 'NA', 'T')

-- Class Info
insert into CLASS_INFO  values (@HD_ID, @BR_ID, 'Play Group ','NA','T')
insert into CLASS_INFO  values (@HD_ID, @BR_ID, 'Receptio','NA','T')
insert into CLASS_INFO  values (@HD_ID, @BR_ID, 'Preparatory','NA','T')
insert into CLASS_INFO  values (@HD_ID, @BR_ID, 'Grade 1','NA','T')
insert into CLASS_INFO  values (@HD_ID, @BR_ID, 'Grade 2','NA','T')
insert into CLASS_INFO  values (@HD_ID, @BR_ID, 'Grade 3','NA','T')
insert into CLASS_INFO  values (@HD_ID, @BR_ID, 'Grade 4','NA','T')
insert into CLASS_INFO  values (@HD_ID, @BR_ID, 'Grade 5','NA','T')


--Subject Info
insert into SUBJECT_INFO  values (@HD_ID, @BR_ID, 'English','Eng.','T','S',4)
insert into SUBJECT_INFO  values (@HD_ID, @BR_ID, 'Urdu','Urdu','T','S',4)
insert into SUBJECT_INFO  values (@HD_ID, @BR_ID, 'Maths','Math','T','S',4)
insert into SUBJECT_INFO  values (@HD_ID, @BR_ID, 'Art & Design','Art','T','S',4)
insert into SUBJECT_INFO  values (@HD_ID, @BR_ID, 'Social Studies','SSt.','T','S',4)
insert into SUBJECT_INFO  values (@HD_ID, @BR_ID, 'Computer Studies','Comp.','T','S',4)
insert into SUBJECT_INFO  values (@HD_ID, @BR_ID, 'Islamiyat','Isl.','T','S',4)
insert into SUBJECT_INFO  values (@HD_ID, @BR_ID, 'Co. Curr.','Co.Curr.','T','S',4)
insert into SUBJECT_INFO  values (@HD_ID, @BR_ID, 'General Science','G.Sci.','T','S',4)
insert into SUBJECT_INFO  values (@HD_ID, @BR_ID, 'Social Studies','S. Std','T','S',4)
insert into SUBJECT_INFO  values (@HD_ID, @BR_ID, 'General Knowledge','GK.','T','S',4)

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
insert into FEE_INFO values (@HD_ID, @BR_ID, 'Tuition Fee','NA','T', 'Monthly', '01', 1,'+',2,'F')
insert into FEE_INFO values (@HD_ID, @BR_ID, 'Registration Fee','NA','T', 'Yearly', '01', 1,'+',2,'F')
insert into FEE_INFO values (@HD_ID, @BR_ID, 'Security Fee','NA','T', 'Yearly', '05', 3,'+',3,'F')
insert into FEE_INFO values (@HD_ID, @BR_ID, 'Admission Fee','NA','T', 'Once', '01', 4,'+',4,'F')
insert into FEE_INFO values (@HD_ID, @BR_ID, 'Late Fee Fine','NA','T', 'Monthly', '01', 6,'+',6,'F')
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



insert into TBL_TYPE_PLAN_MAIN values (CAST((@HD_ID) as nvarchar(50)), CAST((@BR_ID) as nvarchar(50)),@BR_ADM_NAME,1,1,1,0 )
declare @acount_type_plan_id int = (select SCOPE_IDENTITY())
insert into TBL_TYPE_PLAN_DEF values (CAST((@HD_ID) as nvarchar(50)), CAST((@BR_ID) as nvarchar(50)), @acount_type_plan_id, 'Balance Sheet',1,'',0)
insert into TBL_TYPE_PLAN_DEF values (CAST((@HD_ID) as nvarchar(50)), CAST((@BR_ID) as nvarchar(50)), @acount_type_plan_id, 'Profit & Loss',1,'',0)

insert into  TBL_ACC_PLAN values (CAST((@HD_ID) as nvarchar(50)), CAST((@BR_ID) as nvarchar(50)), @BR_ADM_NAME, 4,	'00-00-00-00000', 4,1,0,1,'-','',1,0)
declare @account_plan_id int =( select  SCOPE_IDENTITY())

insert into  TBL_ACC_PLAN_DEF values (CAST((@HD_ID) as nvarchar(50)), CAST((@BR_ID) as nvarchar(50)), @account_plan_id,1,'00',0,'1',1,1,1,1,0,1,0)
insert into  TBL_ACC_PLAN_DEF values (CAST((@HD_ID) as nvarchar(50)), CAST((@BR_ID) as nvarchar(50)), @account_plan_id,2,'00',0,'1',1,1,1,1,0,1,0)
insert into  TBL_ACC_PLAN_DEF values (CAST((@HD_ID) as nvarchar(50)), CAST((@BR_ID) as nvarchar(50)), @account_plan_id,3,'00',0,'1',1,1,1,1,0,1,0)
insert into  TBL_ACC_PLAN_DEF values (CAST((@HD_ID) as nvarchar(50)), CAST((@BR_ID) as nvarchar(50)), @account_plan_id,4,'00000',0,'1',1,1,1,1,1,1,0)

insert into STAFF_TYPE_INFO values (@HD_ID,@BR_ID, 'Permanent', 'NA', 'T')
insert into STAFF_TYPE_INFO values (@HD_ID,@BR_ID, 'Contractual', 'NA', 'T')

insert into BANK_INFO  values (@HD_ID,@BR_ID, 'None', '','', 'T')

insert into CITY_INFO  values (@HD_ID,@BR_ID, @BR_ADM_NAME, '','T')

insert into AREA_INFO  values (@HD_ID,@BR_ID, @BR_ADM_NAME, '','T')

insert into HOUSES_INFO  values (@HD_ID,@BR_ID, 'House 1', 'NA','T')


insert into CONDUCT_INFO  values (@HD_ID,@BR_ID, 'Good', '','T')
insert into CONDUCT_INFO  values (@HD_ID,@BR_ID, 'Very Good', '','T')
insert into CONDUCT_INFO  values (@HD_ID,@BR_ID, 'Excellent', '','T')
insert into CONDUCT_INFO  values (@HD_ID,@BR_ID, 'Poor', '','T')


select 'ok','I',@BR_ADM_HD_ID,@id, @USER_NAME + '-' + @id +  '-0000' as [Login Name], @USER_PASSWORD as [Password]
		
			 
	end
	
	
	else		
	
		begin		
			
			--select 1/0					
			RAISERROR ('Maximum Branches Has Been Created Already !!! ',16,1);
			--THROW ;
			--select 'Maximum Branches Has Been Created Already !!! ' 		 						
		end	
		
		
		
		     
end