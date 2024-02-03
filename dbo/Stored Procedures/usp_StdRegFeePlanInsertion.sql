
CREATE PROC [dbo].[usp_StdRegFeePlanInsertion]

@BrId numeric,
@StdRegId numeric,
@YearlyPlanFeeId numeric

AS

declare @Id int = 0

select top(1) @Id = Id from StudentRegistrationFeePlanMaster where StdRegId = @StdRegId

if @Id = 0
BEGIN
	insert into StudentRegistrationFeePlanMaster
	select @BrId, @StdRegId, @YearlyPlanFeeId, 1
	select SCOPE_IDENTITY()
END
else
BEGIN
	delete from StudentRegistrationFeePlanDetail where PId = @Id
	update StudentRegistrationFeePlanMaster set YearlyFeePlanId = @YearlyPlanFeeId where Id = @Id
	select @Id
END