


CREATE PROC [dbo].[sp_FEE_COLLECT_ARREARS_CALCULATION_EXCEPT_FEE_PLAN]


 @FeePlanId numeric ,
 @FeeCollectIdOld numeric ,
 @FeeCollectId numeric,
 @BrId numeric 

AS

--declare @FeePlanId numeric = 161015
--declare @FeeCollectIdOld numeric = 362434
--declare @FeeCollectId numeric = 0

declare @tbl table (Sr int identity(1,1), FeeId numeric, Arrears float, Operation char(1))



--THis store procedure is for if fee head is not in fee plan and in previous invoice fee head was present and only for + operations
insert into @tbl
select f1.FEE_ID, FEE_COLLECT_DEF_FEE + FEE_COLLECT_DEF_ARREARS - FEE_COLLECT_DEF_FEE_PAID - FEE_COLLECT_DEF_ARREARS_RECEIVED,f.FEE_OPERATION from FEE_COLLECT_DEF fd
join FEE_INFO f on f.FEE_ID = fd.FEE_COLLECT_DEF_FEE_NAME
join (select f.FEE_NAME from FEE_COLLECT_DEF fd
join FEE_COLLECT fc on fc.FEE_COLLECT_ID = FEE_COLLECT_DEF_PID
join FEE_INFO f on f.FEE_ID = fd.FEE_COLLECT_DEF_FEE_NAME
where fc.FEE_COLLECT_ID = @FeeCollectIdOld 
and f.FEE_NAME not in (
select f.FEE_NAME from PLAN_FEE_DEF d
join FEE_INFO f on f.FEE_ID = d.PLAN_FEE_DEF_FEE_NAME
where d.PLAN_FEE_DEF_PLAN_ID = @FeePlanId and PLAN_FEE_DEF_STATUS = 'T'))A
on f.FEE_NAME = A.FEE_NAME and fd.FEE_COLLECT_DEF_PID = @FeeCollectIdOld
join FEE_INFO f1 on f1.FEE_NAME = f.FEE_NAME and f1.FEE_BR_ID = @BrId
where FEE_COLLECT_DEF_FEE + FEE_COLLECT_DEF_ARREARS - FEE_COLLECT_DEF_FEE_PAID - FEE_COLLECT_DEF_ARREARS_RECEIVED > 0



--select FEE_COLLECT_DEF_FEE_NAME,  FEE_COLLECT_DEF_FEE + FEE_COLLECT_DEF_ARREARS - FEE_COLLECT_DEF_FEE_PAID - FEE_COLLECT_DEF_ARREARS_RECEIVED from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @FeeCollectIdOld and FEE_COLLECT_DEF_OPERATION = '+' and FEE_COLLECT_DEF_FEE_NAME NOT in (select PLAN_FEE_DEF_FEE_NAME
--from  PLAN_FEE_DEF	
--join FEE_INFO on FEE_ID = PLAN_FEE_DEF_FEE_NAME	
--where PLAN_FEE_DEF_PLAN_ID = @FeePlanId and PLAN_FEE_DEF_STATUS = 'T' and FEE_STATUS = 'T')


declare @count int = 0
declare @i int = 1
declare @FeeId numeric=0 
declare  @Arrears float = 0, @operation char(1) = '+'
select @count =  COUNT(*) from @tbl
WHILE @i <= @count
BEGIN
	select @FeeId = FeeId,@Arrears = Arrears,@operation = Operation from @tbl where Sr = @i
	insert into FEE_COLLECT_DEF(FEE_COLLECT_DEF_PID,FEE_COLLECT_DEF_FEE_NAME,FEE_COLLECT_DEF_FEE,FEE_COLLECT_DEF_FEE_PAID,FEE_COLLECT_DEF_MIN,FEE_COLLECT_DEF_MAX,FEE_COLLECT_DEF_STATUS,FEE_COLLECT_DEF_OPERATION,FEE_COLLECT_DEF_ARREARS,FEE_COLLECT_DEF_ARREARS_RECEIVED,FEE_COLLECT_DEF_TOTAL, FEE_COLLECT_DEF_ROYALTY,FEE_COLLECT_DEF_ROYALTY_PAID,FEE_COLLECT_DEF_MONTHLY_FEE)																		

select @FeeCollectId,@FeeId, 0 ,0,0,0,'T',@operation, @Arrears,0,@Arrears,0,0,0 


	set @i  = @i + 1
END