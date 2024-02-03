

CREATE PROC [dbo].[usp_StudentRegistrationFeeSelection]

@BrId numeric,
@StdId numeric,
@Type nvarchar(100)
AS
--declare @BrId numeric = 13

if @Type = 'Reg'
BEGIN
	select FEE_ID Id, FEE_NAME Name, CAST(ISNULL(d.Fee,0) as float) Fee, FEE_TYPE FeeType, FEE_OPERATION FeeOperation from FEE_INFO f
	left join StudentRegistrationFeePlanMaster m on m.StdRegId =@StdId
	left join StudentRegistrationFeePlanDetail d on d.FeeId = f.FEE_ID and m.Id = d.PId 
	
	
	where FEE_BR_ID = @BrId and FEE_STATUS = 'T'
END
ELSE IF @Type = 'Adm'
BEGIN
	select FEE_ID Id, FEE_NAME Name, CAST(ISNULL(d.PLAN_FEE_DEF_FEE,0) as float) Fee, FEE_TYPE FeeType, FEE_OPERATION FeeOperation from FEE_INFO f with (nolock)
	left join STUDENT_INFO s with (nolock) on   s.STDNT_ID = @StdId
	left join PLAN_FEE_DEF d with (nolock) on d.PLAN_FEE_DEF_FEE_NAME = f.FEE_ID and s.STDNT_CLASS_FEE_ID  = d.PLAN_FEE_DEF_PLAN_ID
	
	
	where FEE_BR_ID = @BrId and FEE_STATUS = 'T'
END

select Id, Name from FeeYearlyPlan  with (nolock) where BrId = @BrId and PlanStatus = 1



declare @FeeYearlyPlanId numeric = 0, @FeeDate date

if @Type = 'Reg'
BEGIN
	select @FeeYearlyPlanId = YearlyFeePlanId from StudentRegistrationFeePlanMaster where StdRegId = @StdId 
	select @FeeDate = m.StartDate from StdRegFeeGenerationMaster m where m.StudentRegistrationId= @StdId 
END
else if @Type = 'Adm'
BEGIN
	select @FeeYearlyPlanId = PLAN_FEE_YEARLY_PLAN_ID from PLAN_FEE f  with (nolock)
	join STUDENT_INFO s with (nolock)on s.STDNT_CLASS_FEE_ID = f.PLAN_FEE_ID
	where s.STDNT_ID = @StdId 

	select top(1) @FeeDate = f.FEE_COLLECT_FEE_FROM_DATE from FEE_COLLECT f  with (nolock) where f.FEE_COLLECT_STD_ID = @StdId order by FEE_COLLECT_FEE_FROM_DATE desc
END


select @FeeYearlyPlanId FeeYearlyPlanId, @FeeDate FeeDate