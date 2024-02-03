
CREATE PROC [dbo].[usp_FeeChallanFilesPathDeletion]

@InvoiceIds nvarchar(MAX)

AS


delete from FeeChallanFilesPath where InvoiceId in
(select CAST(val as numeric) from dbo.split(@InvoiceIds, ','))