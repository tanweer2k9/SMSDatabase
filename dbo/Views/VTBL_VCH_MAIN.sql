CREATE VIEW [dbo].[VTBL_VCH_MAIN]
AS
SELECT        CMP_ID AS [Institute ID], BRC_ID AS [Branch ID], VCH_MID AS ID, VCH_ID AS [Max ID], VCH_prefix AS Prefix, VCH_date AS Date, VCH_chequeNo AS [Cheque No], 
                         VCH_paidTo AS [Paid To], VCH_referenceNo AS [Reference No], VCH_PO AS [Purchase Order], VCH_GRN AS [GRN No], VCH_isPosted AS [Is Posted], 
                         VCH_narration AS Narration, VCH_isFinancial AS Financial, VCH_isDeleted AS [Is Deleted]
FROM            dbo.TBL_VCH_MAIN