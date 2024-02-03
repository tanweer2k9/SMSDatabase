CREATE PROC [dbo].[usp_FeeInvoiceStudentInfo]

@InvoiceId numeric 
AS
--declare @InvoiceId numeric = 400862



select [InvoiceId], [Installment], [StudentName],  IIF([Relation] = 'Father' OR [Relation] = 'Brother' OR [Relation] = 'Uncle' OR [Relation] = 'None', 'Mr. ', 'Ms. ') + [ParentName] as [ParentName], [ParentEmail], [ClassName], [StdNo], [EmailModule], [Email], [StdId],MobileNo,BrId from VFeeStudentInfo f where InvoiceId = @InvoiceId and EmailModule = 'FeePaymentReceipt'