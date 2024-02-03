
CREATE PROC [dbo].[usp_PlanFeeInsertion]

@BrId numeric,
@StudentName nvarchar(100),
@TotalFee float,
@YearlyPlanFeeId numeric


AS

declare @Formula float = 0, @InstallementId numeric = 0

select top(1) @Formula = FeeFormula, @InstallementId = InstallmentId from FeeYearlyPlanDef where PId = @YearlyPlanFeeId



insert into PLAN_FEE
select (select top(1) BR_ADM_HD_ID from BR_ADMIN where BR_ADM_ID = @BrId), @BrId, @StudentName, @TotalFee, 'T', @Formula, 1,1,'',@InstallementId, @YearlyPlanFeeId

select SCOPE_IDENTITY()