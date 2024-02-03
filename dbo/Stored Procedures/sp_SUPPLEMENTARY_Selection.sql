CREATE PROC [dbo].[sp_SUPPLEMENTARY_Selection]


	@HD_ID  numeric,
	@BR_ID  numeric,
	@CLASS_ID numeric,
	@MONTH_ID numeric


AS

if @CLASS_ID = 0
	set  @CLASS_ID = (select top(1) CLASS_ID from SCHOOL_PLANE where CLASS_IS_SUPPLEMENTARY_BILLS = 1 and CLASS_HD_ID =@HD_ID and CLASS_BR_ID = @BR_ID and CLASS_STATUS = 'T' )

--if @MONTH_ID = 0
--	set @MONTH_ID = (select top(1) ID from VSUPPLEMENTARY_MONTHS_INFO where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and Status = 'T' and ID in ( select SUPL_MONTH_ID from SUPLEMENTARY_PARENT) order by [From Date] DESC)


--select CLASS_ID,CLASS_Name from SCHOOL_PLANE where CLASS_IS_SUPPLEMENTARY_BILLS = 1 and CLASS_HD_ID =@HD_ID and CLASS_BR_ID = @BR_ID and CLASS_STATUS = 'T' 
--select ID,Name, (select top(1) SUPL_DUE_DATE from SUPLEMENTARY_PARENT where SUPL_MONTH_ID = ID) as [Due Date] from VSUPPLEMENTARY_MONTHS_INFO where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and Status = 'T'
--and ID in ( select SUPL_MONTH_ID from SUPLEMENTARY_PARENT) order by [From Date] DESC

--select sd.SUPL_DEF_ID ID, sd.SUPL_DEF_STUDENT_ID [Std ID], s.STDNT_SCHOOL_ID [School ID], CAST(s.STDNT_SCHOOL_ID as int) [School ID Int],s.STDNT_FIRST_NAME [Student Name],
--sp.CLASS_Name Class, sd.SUPL_DEF_GPA GPA, sd.SUPL_DEF_FEE Fee, sd.SUPL_DEF_ARREARS Arrears,sd.SUPL_DEF_ARREARS_RECEIVED [Arrears Received],sd.SUPL_DEF_PERCENTAGE Percentage, sd.SUPL_DEF_LATE_FEE_FINE [Late Fee Fine],sd.SUPL_DEF_FEE_RECEIVED [Fee Received],sd.SUPL_DEF_DISCOUNT Discount,
--CASE WHEN sd.SUPL_DEF_STATUS = 'Fully Received' THEN CAST(1 as bit) ELSE CAST(0 as bit) END [Is Fully Received] , SUPL_DEF_DATE_RECEIVED [Date Received], SUPL_DEF_PAID_TO_ACCOUNT [Paid To]
--from SUPLEMENTARY_DEF sd
--join STUDENT_INFO s on s.STDNT_ID = sd.SUPL_DEF_STUDENT_ID
--join SCHOOL_PLANE sp on sp.CLASS_ID = sd.SUPL_DEF_CLASS_ID

--where SUPL_DEF_PID in (select SUPL_ID from SUPLEMENTARY_PARENT where SUPL_MONTH_ID = @MONTH_ID) and s.STDNT_CLASS_PLANE_ID = @CLASS_ID


--				declare @cash_in_hand_account nvarchar(100) =''
--				declare @cash_at_bank_account nvarchar(100) =''
--				select @cash_in_hand_account = COA_UID from TBL_COA where COA_Name = 'Cash in Hand' and CMP_ID = CAST(@HD_ID as nvarchar(50)) and BRC_ID = CAST(@BR_ID as nvarchar(50))
--				select @cash_at_bank_account = COA_UID from TBL_COA where COA_Name = 'Cash at Bank' and CMP_ID = CAST(@HD_ID as nvarchar(50)) and BRC_ID = CAST(@BR_ID as nvarchar(50))

--			select COA_UID as ID, COA_Name + '- (Cash In Hand)' as Name from TBL_COA where COA_PARENTID = @cash_in_hand_account and COA_isDeleted = 0 and CMP_ID = CAST(@HD_ID as nvarchar(50)) and BRC_ID = CAST(@BR_ID as nvarchar(50))
--			union		
--			select COA_UID as ID, COA_Name + '- (Cash at Bank)' as Name	 from TBL_COA where COA_PARENTID = @cash_at_bank_account and COA_isDeleted = 0 and CMP_ID = CAST(@HD_ID as nvarchar(50)) and BRC_ID = CAST(@BR_ID as nvarchar(50))