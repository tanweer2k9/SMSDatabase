

CREATE PROC [dbo].[usp_GetDashboardCounter]

 @HD_ID numeric,
 @BR_ID numeric, 
 @CLASS_ID nvarchar(100), 
 @SESSION_ID numeric, 
 @FEE_START_DATE date ,
 @SESSION_START_DATE date,
 @SESSION_END_DATE date,
 @Only_Current_Strength bit 

AS



 --declare @HD_ID numeric = 1,
 --@BR_ID numeric = 1, 
 --@CLASS_ID nvarchar(100) = '10056,10057,10058,10059,10061,10062,10063,10060', 
 --@SESSION_ID numeric = 47, 
 --@FEE_START_DATE date ='2018-05-01 00:00:00',
 --@SESSION_START_DATE date='2018-08-01 00:00:00',
 --@SESSION_END_DATE date='2019-07-31 00:00:00',
 --@Only_Current_Strength bit=0


declare @total_strength_students int = 0
declare @current_session_students int = 0
declare @previous_session_students int = 0
declare @inactive_current_sessin_student int = 0
declare @receivable_student int = 0
declare @received_student int = 0
declare @fees_total numeric = 0
declare @fees_received numeric = 0
declare @not_cleared_check numeric = 0
declare @current_month_active numeric = 0
declare @current_month_inactive numeric = 0




--declare @student_table table ([STDNT_ID] numeric,[STDNT_CLASS_PLANE_ID] [numeric],[STDNT_FIRST_NAME] [nvarchar](50),[STDNT_CLASSES_START_DATE] [date],[STDNT_DATE_OF_LEAVING] [date],[STDNT_CATEGORY] [nvarchar](50))
declare @one int = 1

declare @CurrentSessionId numeric = 0

if @BR_ID != 0
BEGIN
	set @CurrentSessionId = (select top(@one) BR_ADM_SESSION  from BR_ADMIN with (nolock) where (BR_ADM_ID = @BR_ID))
END	
ELSE if @BR_ID = 0 AND @HD_ID = 0
BEGIN
	set @CurrentSessionId =(select top(@one) BR_ADM_SESSION from BR_ADMIN  with (nolock) )
END
ELSE if @BR_ID = 0 AND @HD_ID != 0
BEGIN
	set @CurrentSessionId =(select top(@one) BR_ADM_SESSION from BR_ADMIN  with (nolock) where BR_ADM_HD_ID = @HD_ID )
END

declare @tbl table (STDNT_CLASS_PLANE_ID numeric, STDNT_HD_ID numeric, STDNT_BR_ID numeric, STDNT_DATE_OF_LEAVING date, STDNT_CLASSES_START_DATE date, STDNT_CATEGORY nvarchar(50),STDNT_SESSION_ID numeric, STDNT_STATUS char(1))

declare  @tbl_std_fee table (StdId numeric, StdSchoolId nvarchar(50),StdName nvarchar(100), FEE_COLLECT_FEE_STATUS nvarchar(50),FEE_COLLECT_FEE float,FEE_COLLECT_ARREARS float, FEE_COLLECT_FEE_PAID float, FEE_COLLECT_ARREARS_RECEIVED float, FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT float)
--If Current session means in Br_Adm Table
if @CurrentSessionId = @SESSION_ID
BEGIN
	insert into @tbl
	select STDNT_CLASS_PLANE_ID,STDNT_HD_ID,STDNT_BR_ID,STDNT_DATE_OF_LEAVING,STDNT_CLASSES_START_DATE,STDNT_CATEGORY,STDNT_SESSION_ID,STDNT_STATUS from STUDENT_INFO  with (nolock) where (@HD_ID = 0 OR STDNT_HD_ID = @HD_ID) and (@BR_ID = 0 OR STDNT_BR_ID= @BR_ID)
END
ELSE
BEGIN
	insert into @tbl
	select STDNT_CLASS_PLANE_ID,STDNT_HD_ID,STDNT_BR_ID,STDNT_DATE_OF_LEAVING,STDNT_CLASSES_START_DATE,STDNT_CATEGORY,STDNT_SESSION_ID,STDNT_STATUS from STUDENT_INFO_YEARWISE_HISTORY  with (nolock)  where (@HD_ID = 0 OR STDNT_HD_ID = @HD_ID) and (@BR_ID = 0 OR STDNT_BR_ID= @BR_ID)
END


if @CurrentSessionId = @SESSION_ID
BEGIN
	set @total_strength_students = (select COUNT(*) from @tbl where (@CLASS_ID = '-1' OR STDNT_CLASS_PLANE_ID in (select CAST(val as numeric) from dbo.split(@CLASS_ID, ',')))  
		and (@HD_ID = 0 OR STDNT_HD_ID = @HD_ID) and (@BR_ID = 0 OR STDNT_BR_ID= @BR_ID) and STDNT_STATUS = 'T')

END	
ELSE
BEGIN
	set @total_strength_students = (select COUNT(*) from @tbl where (@CLASS_ID = '-1' OR STDNT_CLASS_PLANE_ID in (select CAST(val as numeric) from dbo.split(@CLASS_ID, ',')))  
		and (@HD_ID = 0 OR STDNT_HD_ID = @HD_ID) and (@BR_ID = 0 OR STDNT_BR_ID= @BR_ID) and STDNT_CLASSES_START_DATE <= @SESSION_END_DATE AND (STDNT_DATE_OF_LEAVING is NULL OR (STDNT_DATE_OF_LEAVING >= @SESSION_END_DATE )))
END
		/*Date of leaving must be greater than Session End Date in which we are searching*/ /*After That OR is included those student admission nd leaving in the same session must include in total strength*/ 
		--OR (STDNT_CLASSES_START_DATE between @SESSION_START_DATE and @SESSION_END_DATE AND STDNT_DATE_OF_LEAVING between @SESSION_START_DATE and @SESSION_END_DATE )
		
		if @Only_Current_Strength = 0
		BEGIN

			set @current_session_students = (select COUNT(*) from @tbl where (@CLASS_ID = '-1' OR STDNT_CLASS_PLANE_ID in (select CAST(val as numeric) from dbo.split(@CLASS_ID, ',')))  
					and STDNT_HD_ID = @HD_ID and STDNT_BR_ID= @BR_ID and STDNT_CLASSES_START_DATE  between @SESSION_START_DATE and @SESSION_END_DATE
					 --AND  (STDNT_DATE_OF_LEAVING is NULL OR (STDNT_DATE_OF_LEAVING >= @SESSION_END_DATE )) 
					 and STDNT_SESSION_ID = @SESSION_ID)


			set @previous_session_students = (select COUNT(*) from @tbl where (@CLASS_ID = '-1' OR STDNT_CLASS_PLANE_ID in (select CAST(val as numeric) from dbo.split(@CLASS_ID, ','))) 
					and STDNT_HD_ID = @HD_ID and STDNT_BR_ID= @BR_ID and STDNT_CLASSES_START_DATE <= @SESSION_END_DATE AND (STDNT_DATE_OF_LEAVING is NULL OR (STDNT_DATE_OF_LEAVING >= @SESSION_END_DATE ))						and STDNT_CLASSES_START_DATE < @SESSION_START_DATE)


			set @inactive_current_sessin_student = (select COUNT(*) from @tbl where (@CLASS_ID = '-1' OR STDNT_CLASS_PLANE_ID in (select CAST(val as numeric) from dbo.split(@CLASS_ID, ',')))  and					STDNT_HD_ID = @HD_ID and STDNT_BR_ID= @BR_ID and STDNT_DATE_OF_LEAVING between @SESSION_START_DATE and @SESSION_END_DATE and STDNT_CATEGORY = 'Left')

			set @current_month_active = (select COUNT(*) from STUDENT_INFO where (@CLASS_ID = '-1' OR STDNT_CLASS_PLANE_ID in (select CAST(val as numeric) from dbo.split(@CLASS_ID, ','))) and STDNT_HD_ID =				@HD_ID and STDNT_BR_ID= @BR_ID and DATEPART(MM,STDNT_CLASSES_START_DATE) = DATEPART(MM,GETDATE()) and  DATEPART(YYYY,STDNT_CLASSES_START_DATE) = DATEPART(YYYY,GETDATE()) )

					set @current_month_inactive = (select COUNT(*) from @tbl where (@CLASS_ID = '-1' OR STDNT_CLASS_PLANE_ID in (select CAST(val as numeric) from dbo.split(@CLASS_ID, ',')))  and								STDNT_STATUS = 'F' and STDNT_HD_ID = @HD_ID and STDNT_BR_ID= @BR_ID and DATEPART(MM,STDNT_DATE_OF_LEAVING) = DATEPART(MM,GETDATE()) and  DATEPART(YYYY,STDNT_DATE_OF_LEAVING)							= DATEPART(YYYY,GETDATE())  and STDNT_CATEGORY = 'Left')


					insert into @tbl_std_fee
					select STDNT_ID, STDNT_SCHOOL_ID, STDNT_FIRST_NAME, FEE_COLLECT_FEE_STATUS, FEE_COLLECT_FEE, FEE_COLLECT_ARREARS, FEE_COLLECT_FEE_PAID, FEE_COLLECT_ARREARS_RECEIVED,FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT from (select ROW_NUMBER() over( partition by f.FEE_COLLECT_STD_ID order  by f.FEE_COLLECT_FEE_FROM_DATE desc)as sr,s.*,FEE_COLLECT_FEE_STATUS, FEE_COLLECT_FEE, FEE_COLLECT_ARREARS, FEE_COLLECT_FEE_PAID, FEE_COLLECT_ARREARS_RECEIVED,FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT  from FEE_COLLECT f  with (nolock)  join STUDENT_INFO s  with (nolock) on s.STDNT_ID = f.FEE_COLLECT_STD_ID
					where f.FEE_COLLECT_FEE_FROM_DATE  between  DATEADD(YEAR,-1,GETDATE()) and GETDATE() and
					(@CLASS_ID = '-1' OR s.STDNT_CLASS_PLANE_ID in (select CAST(val as numeric) from dbo.split(@CLASS_ID, ',')))
					and (@HD_ID = 0 OR STDNT_HD_ID = @HD_ID) and (@BR_ID = 0 OR STDNT_BR_ID= @BR_ID) and STDNT_STATUS = 'T')A where sr = 1 

					

					--Fee Counters
					set @receivable_student = (select COUNT(*) from @tbl_std_fee where FEE_COLLECT_FEE_STATUS not in ('Fully Received','Fully Received') )

					set @received_student = (select COUNT(*) from @tbl_std_fee where FEE_COLLECT_FEE_STATUS in ('Fully Received','Fully Received') )

					select @fees_total = SUM( ISNULL(FEE_COLLECT_FEE,0) + ISNULL(FEE_COLLECT_ARREARS,0)), @fees_received = SUM(ISNULL(FEE_COLLECT_FEE_PAID,0) + ISNULL(FEE_COLLECT_ARREARS_RECEIVED,0)),@not_cleared_check = SUM( ISNULL(FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT,0))  from @tbl_std_fee
		
					--select @fees_received = SUM( FEE_COLLECT_FEE_PAID + FEE_COLLECT_ARREARS_RECEIVED)  from FEE_COLLECT f join STUDENT_INFO s on s.STDNT_ID = f.FEE_COLLECT_STD_ID 
					--where (@HD_ID = 0 OR STDNT_HD_ID = @HD_ID) and (@BR_ID = 0 OR STDNT_BR_ID= @BR_ID) and		
					--DATEPART(MM, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(MM, @FEE_START_DATE) and DATEPART(YYYY, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(YYYY, @FEE_START_DATE)
					--and (@CLASS_ID = '-1' OR s.STDNT_CLASS_PLANE_ID in (select CAST(val as numeric) from dbo.split(@CLASS_ID, ',')))
		
					--select @not_cleared_check = SUM( ISNULL(FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT,0))  from FEE_COLLECT f join STUDENT_INFO s on s.STDNT_ID = f.FEE_COLLECT_STD_ID 
					--where (@HD_ID = 0 OR STDNT_HD_ID = @HD_ID) and (@BR_ID = 0 OR STDNT_BR_ID= @BR_ID) and		
					--DATEPART(MM, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(MM, @FEE_START_DATE) and DATEPART(YYYY, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(YYYY, @FEE_START_DATE)
					--and (@CLASS_ID = '-1' OR s.STDNT_CLASS_PLANE_ID in (select CAST(val as numeric) from dbo.split(@CLASS_ID, ',')))

		END

		--THis is in money foramt must use this in future. FOr this I have to update this store procedure NGSAPI projct and datamodels project

			--select @total_strength_students TotalStrength,@current_session_students CurrentSessionStudent,@previous_session_students PreviousSessionStudent,@inactive_current_sessin_student CurrentSessionStudentInactive,@receivable_student ReceivableStudent,@received_student ReceivedStudent, REPLACE(CONVERT(varchar, CAST(@fees_total AS money), 1),'.00','') FeeTotal,  REPLACE(CONVERT(varchar, CAST(@fees_received AS money), 1),'.00','') FeeReceived, REPLACE(CONVERT(varchar, CAST((@fees_total - @fees_received) AS money), 1),'.00','')  FeesReceivable , @not_cleared_check NotClearedCheckAmount, @current_month_active CurrentMonthActive, @current_month_inactive CurrentMonthInActive


		select @total_strength_students TotalStrength,@current_session_students CurrentSessionStudent,@previous_session_students PreviousSessionStudent,@inactive_current_sessin_student CurrentSessionStudentInactive,@receivable_student ReceivableStudent,@received_student ReceivedStudent, @fees_total FeeTotal, @fees_received FeeReceived, @fees_total - @fees_received FeesReceivable , @not_cleared_check NotClearedCheckAmount, @current_month_active CurrentMonthActive, @current_month_inactive CurrentMonthInActive