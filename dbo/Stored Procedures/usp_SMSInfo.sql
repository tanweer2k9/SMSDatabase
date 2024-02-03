CREATE PROC [dbo].[usp_SMSInfo]

@StdId numeric,
@InvoiceId numeric

AS


if @StdId != 0
BEGIN
	select [InvoiceId], [Installment], [StudentName], [ParentName], [ParentEmail], [StdNo], [StdId], [Relation], [IsSmsEnabled],IsEMailEnabled, [MobileNo],  [UserId],BrId,HdId from VsmsInfo where StdId = @StdId
END
else if @InvoiceId != 0
BEGIN
	select [InvoiceId], [Installment], [StudentName], [ParentName], [ParentEmail], [StdNo], [StdId], [Relation], [IsSmsEnabled],IsEMailEnabled, [MobileNo],  [UserId],BrId,HdId from VsmsInfo where InvoiceId = @InvoiceId
END