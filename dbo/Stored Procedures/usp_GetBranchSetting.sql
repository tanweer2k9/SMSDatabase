CREATE PROC [dbo].[usp_GetBranchSetting]

@BrId numeric



AS

select * from BranchSetting bs
join BR_ADMIN br on br.BR_ADM_ID = bs.BrId


where BrId = @BrId and br.BR_ADM_STATUS = 'T'