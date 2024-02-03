CREATE PROC [dbo].[sp_FEE_COLLLECT_DEFINATION_UPDATION_IN_ACCOUNT_INSERTION]

@FEE_COLLECT_ID numeric,
@VCH_DEF_ItemCOA nvarchar(100) = ''

AS



Declare @i int = 1
Declare @count int = 0
declare @VCH_MAIN_ID nvarchar(50) = ''
Declare @def_name int
declare @arears float = 0
declare @fee_receieved float = 0
declare @fee float = 0
declare @arrears_received float = 0
declare @VCH_reference_no nvarchar(50) = ''
declare @debit float = 0
declare @credit float = 0
declare @HD_ID nvarchar(50) = ''
declare @BR_ID nvarchar(50) = ''
declare @accRefNo nvarchar(100) = ''
declare @VCH_DEF_COA nvarchar(50) = ''
declare @VCH_TYPE nvarchar(50) = ''
declare @FEE_COLLECT_STD_ID numeric = 0
declare @datetime datetime = ''
declare @oparation char(1) = ''
declare @total_current_fee float = 0

select @HD_ID = CAST((FEE_COLLECT_HD_ID) as nvarchar(50)), @BR_ID = CAST((FEE_COLLECT_BR_ID) as nvarchar(50)), @FEE_COLLECT_STD_ID = FEE_COLLECT_STD_ID from FEE_COLLECT where FEE_COLLECT_ID = @FEE_COLLECT_ID


set @count = (select COUNT(*) from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @FEE_COLLECT_ID)
set @VCH_MAIN_ID = (select top(1) VCH_MID from TBL_VCH_MAIN where VCH_referenceNo = CAST((@FEE_COLLECT_ID) as nvarchar(50)))

	-- student coaUID
set @VCH_DEF_COA = (select top(1) COA_UID from TBL_COA where COA_ID = (select STDNT_COA_ID from STUDENT_INFO where STDNT_ID = @FEE_COLLECT_STD_ID ) )


set @total_current_fee = (select ISNULL(SUM(FEE_COLLECT_DEF_FEE),0) from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @FEE_COLLECT_ID   and FEE_COLLECT_DEF_OPERATION = '+')
-
(select ISNULL(SUM(FEE_COLLECT_DEF_FEE),0) from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @FEE_COLLECT_ID   and FEE_COLLECT_DEF_OPERATION = '-')


--Set The Student debit Account in case if any fee is changed through advancee Fee Collection 
update TBL_VCH_DEF set VCH_DEF_debit = @total_current_fee where VCH_DEF_COA = @VCH_DEF_COA and VCH_MAIN_ID = @VCH_MAIN_ID and CMP_ID = @HD_ID and BRC_ID = @BR_ID





--Delete if studnet already paid some fees
delete from TBL_VCH_DEF where VCH_DEF_remarks = 'U' and VCH_MAIN_ID = @VCH_MAIN_ID and VCH_DEF_COA = @VCH_DEF_COA and CMP_ID = @HD_ID and BRC_ID = @BR_ID



 while @i <= @count
						BEGIN

								select @def_name = FEE_COLLECT_DEF_FEE_NAME, @oparation = FEE_COLLECT_DEF_OPERATION, @fee = FEE_COLLECT_DEF_FEE,@fee_receieved = FEE_COLLECT_DEF_FEE_PAID, @arears = FEE_COLLECT_DEF_ARREARS, @arrears_received = FEE_COLLECT_DEF_ARREARS_RECEIVED,@VCH_reference_no = CAST((FEE_COLLECT_DEF_ID) as nvarchar(50))   from (select ROW_NUMBER() over(order by (select 0)) as sr, FEE_COLLECT_DEF_FEE_NAME, FEE_COLLECT_DEF_FEE, FEE_COLLECT_DEF_ARREARS,FEE_COLLECT_DEF_FEE_PAID,FEE_COLLECT_DEF_ARREARS_RECEIVED, FEE_COLLECT_DEF_ID,FEE_COLLECT_DEF_OPERATION from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @FEE_COLLECT_ID)A where sr = @i
				
				
				
								set @credit= @fee_receieved + @arrears_received
								set @debit = 0
								--if @VCH_TYPE = 'Debit' 
								--	begin
								--		set @credit = @fee_receieved + @arears						
								--	end
								--ELSE 
								--	begin
								--		set @debit = @fee_receieved + @arears
								--	end
				
				
							select @accRefNo = COA_UID, @VCH_TYPE = COA_type from TBL_COA where CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_Name in 
							(select Name from VFEE_INFO where ID = @def_name) and COA_isDeleted = 0
							--reference number as tbl voucher def countID that is auto identity
							set @VCH_reference_no = (select top(1) CAST(VCH_DEF_countID as nvarchar(50)) from TBL_VCH_DEF where VCH_MAIN_ID = @VCH_MAIN_ID  and VCH_DEF_COA = @accRefNo and CMP_ID = @HD_ID and BRC_ID = @BR_ID)

							--set
				
							if @oparation = '+'
							BEGIN	
								update TBL_VCH_DEF set VCH_DEF_credit = @fee where VCH_DEF_countID =  CAST(@VCH_reference_no as numeric)
							END
							ELSE
							BEGIN
								update TBL_VCH_DEF set VCH_DEF_debit = @fee where VCH_DEF_countID =  CAST(@VCH_reference_no as numeric)
							END

							set @datetime = GETDATE()
							declare @is_profit_loss bit = (select CAST(1 as bit))

							if @VCH_DEF_ItemCOA = 'Multiple Cheques'
								set @is_profit_loss = (select CAST(0 as bit))
								if @debit > 0 or @credit > 0
								BEGIN
									exec sp_TBL_VCH_DEF_insertion @VCH_MAIN_ID, @VCH_DEF_COA,@debit,@credit,0,0,@VCH_reference_no,'U','',@datetime,@VCH_DEF_ItemCOA,'','',@HD_ID, @BR_ID,0,@is_profit_loss,@accRefNo
								END
							set @i = @i + 1
						END