
CREATE PROC [dbo].[sp_SUPPLEMENTARY_GENERATE]


	@SUPL_HD_ID  numeric,
	@SUPL_BR_ID  numeric,
	@SUPL_NAME  nvarchar(1000) ,
	@SUPL_MONTH_NAME nvarchar(50),
	@SUPL_NOTES1  nvarchar(1000) ,
	@SUPL_NOTES2  nvarchar(1000) ,
	@SUPL_DUE_DATE date,
	@CLASS_ID numeric,
	@STD_ID numeric


AS


--declare
--	@SUPL_HD_ID  numeric = 1,
--	@SUPL_BR_ID  numeric = 1,
--	@SUPL_NAME  nvarchar(1000) ='Scholarship Withdrawl',
--	@SUPL_MONTH_NAME nvarchar(50) = 'Mar.-May. 2016',
--	@SUPL_NOTES1  nvarchar(1000)  = 'notes',
--	@SUPL_NOTES2  nvarchar(1000) ='',
--	@SUPL_DUE_DATE date = '2016-04-27',
--@CLASS_ID numeric  = 1,
	--@STD_ID numeric = 1



--declare @acc_hd_id nvarchar(100) = ''
--declare @acc_br_id nvarchar(100) = ''
	

--set @acc_hd_id = CAST((@SUPL_HD_ID) as nvarchar(50))
--set @acc_br_id = CAST(@SUPL_BR_ID as nvarchar(50))


--declare @PID_Del numeric = 0
--set @PID_Del = (select SUPL_ID from SUPLEMENTARY_PARENT where SUPL_HD_ID = @SUPL_HD_ID and SUPL_BR_ID = @SUPL_BR_ID)

--delete from TBL_VCH_DEF where VCH_MAIN_ID in (select vm.VCH_MID from TBL_VCH_MAIN vm where vm.VCH_referenceNo = @PID_Del and vm.VCH_prefix = 'SW')

--delete from TBL_VCH_MAIN where VCH_referenceNo = @PID_Del and VCH_prefix = 'SW'

--delete from SUPLEMENTARY_DEF where SUPL_DEF_PID = @PID_Del
--delete from SUPLEMENTARY_PARENT where SUPL_MONTH_ID = @SUPL_MONTH_ID


declare @PID_Del numeric = 0
set @PID_Del = (select top(1) SUPL_ID from SUPLEMENTARY_PARENT where SUPL_HD_ID = @SUPL_HD_ID and SUPL_BR_ID = @SUPL_BR_ID)

delete from SUPLEMENTARY_DEF where SUPL_DEF_PID = @PID_Del
delete from SUPLEMENTARY_PARENT where SUPL_ID = @PID_Del


--declare @paid_to nvarchar(50)
--declare @prev_suplementary_parent_id int = 0

--select top(1) @prev_suplementary_parent_id = SUPL_ID from SUPLEMENTARY_PARENT p join SUPPLEMENTARY_MONTHS_INFO m on m.SUPL_MONTH_ID = p.SUPL_MONTH_ID  order by SUPL_FROM_DATE DESC

--set @prev_suplementary_parent_id = ISNULL(@prev_suplementary_parent_id,0)	

--update SUPLEMENTARY_DEF set SUPL_DEF_STATUS = 'Partially Transafered' where SUPL_DEF_STATUS = 'Partially Received' and SUPL_DEF_PID = @prev_suplementary_parent_id
--update SUPLEMENTARY_DEF set SUPL_DEF_STATUS = 'Fully Transafered' where SUPL_DEF_STATUS = 'Receivable' and SUPL_DEF_PID = @prev_suplementary_parent_id

declare @PID int = 0

--declare @prev_suplementary_parent_id_nvarchar nvarchar(50) = '%'

--if @prev_suplementary_parent_id != 0
--	set @prev_suplementary_parent_id_nvarchar = CAST(@prev_suplementary_parent_id as nvarchar(50))

insert into SUPLEMENTARY_PARENT values (@SUPL_HD_ID, @SUPL_BR_ID, @SUPL_NAME,@SUPL_MONTH_NAME,@SUPL_NOTES1,@SUPL_NOTES2,@SUPL_DUE_DATE)

set @PID = SCOPE_IDENTITY()

--set @paid_to = (select COA_UID from TBL_COA where  CMP_ID = @acc_hd_id and BRC_ID = @acc_br_id and COA_isDeleted = 0 and COA_PARENTID = (select COA_UID from TBL_COA where COA_Name = 'Cash In Hand' and CMP_ID =@acc_hd_id and BRC_ID = @acc_br_id and COA_isDeleted = 0))









declare @i int = 1
declare @count int = 0
declare @FEE_COLLECT_ID numeric = 0
declare @fee_id numeric
declare @HD_ID_nvarchar nvarchar(50)
declare @BR_ID_nvarchar nvarchar(50)
declare @datetime datetime = ''
declare @VCH_reference_no nvarchar(50) = ''
declare @VCH_MAIN_ID nvarchar(50) = ''
declare @VCH_DEF_COA nvarchar(50) = ''
declare @credit float= 0
declare @fee float
declare @fee_collect_def_id numeric
declare @count_PID int = 0
declare @student_id numeric = 0
declare @percentage float = 0
declare @GPA float = 0
declare @ID numeric = 0
declare @Fee_Collect_Status nvarchar(50) = ''
declare @account_Fee_month nvarchar(50)
declare @account_class_plan nvarchar(50)
declare @account_student nvarchar(50)
declare @account_final_fee_bill nvarchar(50)
declare @tbl table (ID numeric)


declare @class_nvarchar nvarchar(50) = '%'
declare @std_nvarchar nvarchar(50) = '%'


if @CLASS_ID != 0
	set @class_nvarchar = CAST(@CLASS_ID as nvarchar(50))

if @STD_ID != 0
	set @std_nvarchar  = CAST(@STD_ID as nvarchar(50))


set @count = (select COUNT(*) from SCHOLARSHIP_GENERATION where SCH_GEN_HD_ID =@SUPL_HD_ID and SCH_GEN_BR_ID = @SUPL_BR_ID and SCH_GEN_IS_CLEARED = 0 and SCH_GEN_CLASS_ID like @class_nvarchar and SCH_GEN_STD_ID like @std_nvarchar)

while @i< = @count
BEGIN
	select @FEE_COLLECT_ID = SCH_GEN_FEE_COLLECT_ID, @ID = SCH_GEN_ID,@student_id = SCH_GEN_STD_ID,@percentage = SCH_GEN_PERCENT, @GPA = SCH_GEN_GPA,@VCH_MAIN_ID = SCH_GEN_VCH_MAIN_ID, @VCH_DEF_COA = SCH_GEN_VCH_DEF_COA, @fee = ((SCH_GEN_FEE * SCH_GEN_PERCENT) / 100), @fee_id = SCH_GEN_FEE_ID, @account_Fee_month = SCH_GEN_FEE_INVOICE_MONTH_ACCOUNT, @account_student = SCH_GEN_FEE_STUDENT_ACCOUNT, @account_class_plan = SCH_GEN_FEE_CLASS_PLAN_ACCOUNT, @account_final_fee_bill = SCH_GEN_FEE_FINAL_FEE_BILL_ACCOUNT  from(select ROW_NUMBER() over (order by (select 0)) as sr, * from SCHOLARSHIP_GENERATION where SCH_GEN_HD_ID =@SUPL_HD_ID and SCH_GEN_BR_ID = @SUPL_BR_ID and SCH_GEN_IS_CLEARED = 0 and SCH_GEN_CLASS_ID like @class_nvarchar and SCH_GEN_STD_ID like @std_nvarchar)A where sr = @i 

	set @count_PID = (select COUNT(*) from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @FEE_COLLECT_ID and FEE_COLLECT_DEF_FEE_NAME = @fee_id)
	
	if @fee > 0
	BEGIN
		if @count_PID = 0
		BEGIN
			insert into FEE_COLLECT_DEF
			select @FEE_COLLECT_ID, @fee_id,@fee,0,0,0,'T','+',0,0,@fee,0,0
			set @fee_collect_def_id = SCOPE_IDENTITY()
		END
		ELSE
		BEGIN
			set @fee_collect_def_id = (select FEE_COLLECT_DEF_ID from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @FEE_COLLECT_ID and FEE_COLLECT_DEF_FEE_NAME = @fee_id)
			update FEE_COLLECT_DEF set FEE_COLLECT_DEF_FEE = @fee, FEE_COLLECT_DEF_TOTAL = FEE_COLLECT_DEF_TOTAL + @fee where FEE_COLLECT_DEF_ID = @fee_collect_def_id
		END

		set @Fee_Collect_Status = (select FEE_COLLECT_FEE_STATUS from FEE_COLLECT where FEE_COLLECT_ID = @FEE_COLLECT_ID)

		if @Fee_Collect_Status = 'Fully Received'
		BEGIN
			set @Fee_Collect_Status = 'Partially Received'
		END

		update FEE_COLLECT set FEE_COLLECT_FEE_STATUS = @Fee_Collect_Status, FEE_COLLECT_FEE = FEE_COLLECT_FEE + @fee, FEE_COLLECT_NET_TOATAL = FEE_COLLECT_NET_TOATAL + @fee where FEE_COLLECT_ID = @FEE_COLLECT_ID

	

		insert into @tbl select @ID
		--update SCHOLARSHIP_GENERATION set SCH_GEN_IS_CLEARED = 1 where SCH_GEN_ID = @ID
	
		set @datetime = GETDATE()
						
		set @HD_ID_nvarchar = CAST((@SUPL_HD_ID) as nvarchar(50))
		set @BR_ID_nvarchar = CAST((@SUPL_BR_ID) as nvarchar(50))
		set @VCH_reference_no = CAST((@fee_collect_def_id) as nvarchar(50))
		exec sp_TBL_VCH_DEF_insertion @VCH_MAIN_ID, @VCH_DEF_COA,0,@fee,0,0,@VCH_reference_no,'I','',@datetime,'','','',@HD_ID_nvarchar,		@BR_ID_nvarchar,0,1,''


		update TBL_VCH_DEF set VCH_DEF_credit = VCH_DEF_credit + @fee where VCH_MAIN_ID = @VCH_MAIN_ID and VCH_DEF_COA = @account_class_plan
		update TBL_VCH_DEF set VCH_DEF_credit = VCH_DEF_credit + @fee where VCH_MAIN_ID = @VCH_MAIN_ID and VCH_DEF_COA = @account_Fee_month
		update TBL_VCH_DEF set VCH_DEF_credit = VCH_DEF_credit + @fee where VCH_MAIN_ID = @VCH_MAIN_ID and VCH_DEF_COA = @account_final_fee_bill
		update TBL_VCH_DEF set VCH_DEF_debit = VCH_DEF_debit + @fee where VCH_MAIN_ID = @VCH_MAIN_ID and VCH_DEF_COA = @account_student

		insert into SUPLEMENTARY_DEF
		select @PID, @student_id, @GPA,@percentage,@fee,@FEE_COLLECT_ID
	END
	ELSE
	BEGIN
	insert into @tbl select @ID
		--update SCHOLARSHIP_GENERATION set SCH_GEN_IS_CLEARED = 1 where SCH_GEN_ID = @ID
	END

set @i = @i + 1
END


update SCHOLARSHIP_GENERATION set SCH_GEN_IS_CLEARED = 1 where SCH_GEN_ID in (select ID from @tbl)
































--insert into SUPLEMENTARY_DEF


--select @PID,SUPL_STD_STUDENT_ID,STDNT_CLASS_PLANE_ID,SUPL_STD_GPA,SUPL_STD_Percentage,SUPL_STD_FEE,0,B.Arrears,0,0,0,GETDATE(),GETDATE(),@paid_to,'Receivable' 
--from SUPLEMENTARY_STUDENTS_SETTINGS su
--join STUDENT_INFO s on s.STDNT_ID = su.SUPL_STD_STUDENT_ID
--join (select ISNULL((SUPL_DEF_FEE + SUPL_DEF_LATE_FEE_FINE + SUPL_DEF_ARREARS - SUPL_DEF_FEE_RECEIVED - SUPL_DEF_DISCOUNT - SUPL_DEF_ARREARS_RECEIVED),0) as Arrears, A.SUPL_DEF_STUDENT_ID as [Std ID] from 
--(select ROW_NUMBER() over(partition by d.SUPL_DEF_STUDENT_ID order by m.SUPL_FROM_DATE DESC) as sr,d.*
--from SUPLEMENTARY_DEF d
--join SUPLEMENTARY_PARENT p on p.SUPL_ID = d.SUPL_DEF_PID
--join SUPPLEMENTARY_MONTHS_INFO m on m.SUPL_MONTH_ID = p.SUPL_MONTH_ID
--join STUDENT_INFO s on s.STDNT_ID = d.SUPL_DEF_STUDENT_ID
--where s.STDNT_STATUS = 'T' and s.STDNT_BR_ID = @SUPL_BR_ID and s.STDNT_HD_ID = @SUPL_HD_ID)A where sr = 1)B on B.[Std ID] = su.SUPL_STD_STUDENT_ID
--where s.STDNT_STATUS = 'T'

--declare @count int = (select COUNT(*) from SUPLEMENTARY_DEF where SUPL_DEF_PID = @PID)
--declare @i int =1
--declare @acc_prefix nvarchar(50) = 'SW'--Scholarship Withdrawl
--declare @acc_datetime datetime = getdate()
 
--declare @tbl_vch table (sr int identity(1,1),[status] nvarchar(50), ID nvarchar(50))


--while @i <= @count
--BEGIN
--	declare @std_id numeric = 0
--	declare @acc_invoice_id numeric = 0
--	declare @total_fee float = 0 
--	declare @VCH_MAIN_ID nvarchar(50) = ''
--	declare @VCH_DEF_COA nvarchar(50) = ''
--	declare @debit float= 0
--	declare @credit float = 0
--	declare @VCH_reference_no nvarchar(50) = ''
--	declare @supp_def_id numeric = 0
--	delete from @tbl_vch


--	select @std_id = SUPL_DEF_STUDENT_ID, @total_fee = SUPL_DEF_FEE, @supp_def_id = SUPL_DEF_ID  from (select ROW_NUMBER() over(order by (select 0)) as sr,* from SUPLEMENTARY_DEF where SUPL_DEF_PID = @PID)A where sr = @i

--	set @acc_datetime = getdate()
--	 insert into @tbl_vch exec sp_TBL_VCH_MAIN_insertion @acc_prefix, @acc_datetime, '','',@PID,'','',0,0,'',@acc_hd_id,@acc_br_id,0
--	 set @VCH_MAIN_ID = (select top(1) ID from @tbl_vch order by sr DESC )

--	 set @VCH_reference_no = CAST(@supp_def_id as nvarchar(50))
--	 set @VCH_DEF_COA = (select a.DEFAULT_ACCT_CODE  from TBL_DEFAULT_ACCT a where a.DEFAULT_ACCT_KEY = 'Scholarship Withdrawl' and a.CMP_ID = @acc_hd_id and a.BRC_ID = @acc_br_id )
--	 set @credit = @total_fee
--	 exec sp_TBL_VCH_DEF_insertion @VCH_MAIN_ID, @VCH_DEF_COA,@debit,@credit,0,0,@VCH_reference_no,'I','',@acc_datetime,'','','',@acc_hd_id, @acc_br_id,0,1,''

--	 set @VCH_DEF_COA = (select COA_UID from TBL_COA where COA_isDeleted = 0 and COA_ID =  (select STDNT_COA_ID from STUDENT_INFO where STDNT_ID = @std_id) )

--	 set @debit = @total_fee 
--	 set @credit = 0
--	 set @VCH_reference_no = ''
--	 exec sp_TBL_VCH_DEF_insertion @VCH_MAIN_ID, @VCH_DEF_COA,@debit,@credit,0,0,@VCH_reference_no,'I','',@acc_datetime,'','','',@acc_hd_id, @acc_br_id,0,1,''
--	set @i = @i + 1
--END