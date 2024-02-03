

CREATE PROC [dbo].[usp_StudentRegistrationFeeInsertion]

@StdRegId numeric,
@FeesDate date, 
@BrId numeric

AS



--declare @StdRegId numeric, @FeesDate date, @BrId numeric


declare @StdRegFeeDeleteId numeric = 0

select @StdRegFeeDeleteId =Id from StdRegFeeGenerationMaster m where m.StudentRegistrationId = @StdRegId

delete from StdRegFeeGenerationDetail where PId = @StdRegFeeDeleteId
delete from StdRegFeeGenerationMaster where Id = @StdRegFeeDeleteId



declare @StartDate date, @EndDate date, @NetTotal float, @StdRegGenerationId numeric,@fee_formula_fee_plan float, @ToMonthNo int

declare @one int = 1


select top(@one) @fee_formula_fee_plan = FeeFormula,@ToMonthNo = ToMonth from StudentRegistrationFeePlanMaster pf
join FeeYearlyPlanDef yd on yd.PId = pf.YearlyFeePlanId and IsDeleted = 0 and FromMonth = DATEPART(MM, @FeesDate)
join INSTALLMENT_INFO i on i.INSTALLMENT_ID = yd.InstallmentId where StdRegId =@StdRegId


select @StartDate = @FeesDate, @EndDate = EOMONTH(datefromparts(DATEPART(YYYY,@FeesDate), @ToMonthNo, 1))

declare @tbl_BillNo table (BillNo nvarchar(15), BillNoCount bigint)
declare @BillNo nvarchar(15), @BillNoCount bigint

insert into @tbl_BillNo
exec dbo.usp_GetBillNo @BrId
select top(1) @BillNo = BillNo, @BillNoCount = BillNoCount from @tbl_BillNo

insert into StdRegFeeGenerationMaster
select BrId,Id,ClassId, 'Registration Slip', 'Receiveable', GETDATE(),@StartDate,@EndDate, @NetTotal,@BillNo,Next Value For SqFeeChallanNo, GETDATE(),NULL,NULL,NULL  from StudentRegistration 
where Id = @StdRegId

select @StdRegGenerationId = SCOPE_IDENTITY()


declare @tblFeeDef table (Sr int identity(1,1), FeeId numeric, Fee float,FeeType nvarchar(50), IsOncePaid nvarchar(50), DefId numeric ) 

insert into @tblFeeDef
select FeeId, Fee, f.FEE_TYPE, IsOncePaid,d.Id from StudentRegistrationFeePlanDetail d 
join StudentRegistrationFeePlanMaster m on m.Id = d.PId 
join FEE_INFO f on f.FEE_ID = d.FeeId
where m.StdRegId = @StdRegId and d.Status = 1

declare @count int = 0, @i int = 1 

select @count = COUNT(Sr) from @tblFeeDef

WHILE @i <= @count
BEGIN
	declare @FeeType nvarchar(50), @Fee float, @FeeId numeric, @IsOncePaid nvarchar(50),@total_fee float,@DefId numeric
	select @FeeType = FeeType, @Fee = Fee, @FeeId = FeeId, @IsOncePaid = IsOncePaid,@DefId= DefId from @tblFeeDef where Sr = @i

	--May be in future Monthly and custome used so commented for now
	--if @FeeType = 'Monthly'
	--						begin
	--			set @total_fee = @Fee * @mounth_diff2 *	@FEE_COLLECT_MONTHS		-- @FEE_COLLECT_MONTHS variable is month fees count e.g NGS is 1.2
	--		end
			
	--			else 
				if @FeeType = 'Once' and @IsOncePaid = 'F'
				BEGIN
					set @total_fee = @Fee 	
					update StudentRegistrationFeePlanDetail set IsOncePaid = 'T' where   Id = @DefId
				END

				insert into StdRegFeeGenerationDetail
				select @StdRegGenerationId, @FeeId, @total_fee

set @i = @i + 1
END


select @NetTotal = SUM(Fee) from StdRegFeeGenerationDetail where PId = @StdRegGenerationId

update StdRegFeeGenerationMaster set NetTotal = @NetTotal  where Id = @StdRegGenerationId 

select @StdRegGenerationId