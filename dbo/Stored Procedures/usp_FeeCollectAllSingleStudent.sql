CREATE PROC usp_FeeCollectAllSingleStudent
@StdId numeric 

AS
 

 select * from FEE_COLLECT where FEE_COLLECT_STD_ID = @StdId order by FEE_COLLECT_FEE_FROM_DATE