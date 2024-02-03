
CREATE PROC [dbo].[usp_DiaryFeeChallanInfo]

@StdId numeric

AS
--declare @StdId numeric = 30225 


declare @one int = 1
declare @InvoiceId numeric=0 

--FeeChallanStudentsUploadPaymentMaster Joining is not Done with InvoiceId becuase may be FeeChlallan is delete and Invoice is no longer available so here it is joining with FEE_COLLECT_FEE_FROM_DATE and StdId. I am expecting FEE_COLLECT_FEE_FROM_DATE must be 1st of every month

select top(@one) @InvoiceId = FEE_COLLECT_ID from FEE_COLLECT f with (nolock)  where f.FEE_COLLECT_STD_ID= @StdId order by FEE_COLLECT_FEE_FROM_DATE desc

select  top(@one) m.Id,'PKR. ' + FORMAT(f.FEE_COLLECT_NET_TOATAL, '#,###')  TotalAmount, FORMAT(f.FEE_COLLECT_DUE_DAY, 'dddd dd,MMM yyyy') DueDate, p.Path, (ISNULL(f.FEE_COLLECT_FEE_PAID,0) + ISNULL(f.FEE_COLLECT_ARREARS_RECEIVED,0)) TotalFeeReceived, f.FEE_COLLECT_ID InvoiceId,IIF(f.FEE_COLLECT_FEE_STATUS = 'Receivable', ISNULL(m.PaymentStatus,'Pending'),IIF(f.FEE_COLLECT_FEE_STATUS like '%fully%','Paid',IIF(f.FEE_COLLECT_FEE_STATUS like '%fully%','Partially Paid',f.FEE_COLLECT_FEE_STATUS))) FeePaymentStatus,IIF(f.FEE_COLLECT_FEE_STATUS = 'Receivable',(IIF((m.PaymentStatus is null OR m.PaymentStatus = 'Rejected'  OR m.PaymentStatus = 'Pending'),CAST(1 as bit), cast(0 as bit))),cast(0 as bit)) IsPayFee ,f.FEE_COLLECT_INSTALLMENT_NAME Installment, (select top(@one) ISNULL(AdminCommentsRejected,'') from FeeChallanStudentsUploadPaymentDetail where PId = m.Id order by id desc) AdminCommentsRejected, 'Thank you for submitting the fee payment receipt. We will revert back to you after the payment review.' FeePaymentReceiptMessage  from FEE_COLLECT f with (nolock)
left join FeeChallanFilesPath p on f.FEE_COLLECT_ID = p.InvoiceId
left join FeeChallanStudentsUploadPaymentMaster m on m.InvoiceId = f.FEE_COLLECT_ID--m.FeeMonth = f.FEE_COLLECT_FEE_FROM_DATE and f.FEE_COLLECT_STD_ID = m.StdId
where FEE_COLLECT_ID = @InvoiceId and ISNULL(m.IsDeleted,0) = 0



declare @BrId numeric = 0
select @BrId = STDNT_BR_ID from STUDENT_INFO where STDNT_ID = @StdId

select BranchName,BankName,AccountTitle,AccountNo from FeeBankInfo f 
where BrId =@BrId order By Id desc