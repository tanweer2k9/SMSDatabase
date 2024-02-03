CREATE FUNCTION [dbo].[sc_CalcualteRoyalty](@FEE_COLLECT_FEE_FROM_DATE date,@FromDate date, @ToDate date,@IsRoyalty bit, @LeavingDate date, @RoyaltyAmount float)
returns float


BEGIN
declare @roylaity float = 0

if (@FEE_COLLECT_FEE_FROM_DATE between @FromDate and @ToDate) 
BEGIN
	if ISNULL(@IsRoyalty,1) != 0
		BEGIN
			--This line is commented due to if student is left before FromDate the royalty calculation is zero but it has to be charged
			if ISNULL(@LeavingDate,'9999-01-01') > @FromDate OR @RoyaltyAmount > 0
			--if @RoyaltyAmount > 0
			BEGIN
				set @roylaity = ROUND(@RoyaltyAmount,0)
			END  
		END
	
END





return @roylaity
END