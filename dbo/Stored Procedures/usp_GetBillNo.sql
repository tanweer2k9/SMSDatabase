CREATE PROC [dbo].[usp_GetBillNo] 

@BrId numeric



AS


declare @BillNo nvarchar(10) = ''
declare @BillNoCount bigint = 0
select @BillNoCount = BillNo from BillNoSetting where BrId = @BrId

if @BillNoCount = 0
BEGIN
	set @BillNoCount = 1
	insert into BillNoSetting values (@BrId, @BillNoCount)
END
ELSE
BEGIN
	set @BillNoCount = @BillNoCount + 1
	update BillNoSetting set BillNo = @BillNoCount where BrId = @BrId
END


set @BillNo = IIF(LEN(@brId) >3, CAST(@brId as nvarchar(5)), RIGHT('00' + CAST(@brId as nvarchar(5)),3)) + IIF(LEN(@BillNoCount) >4, CAST(@BillNoCount as nvarchar(8)), RIGHT('000' + CAST(@BillNoCount as nvarchar(8)),4))



select @BillNo, @BillNoCount