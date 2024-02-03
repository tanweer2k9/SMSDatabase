CREATE PROC rpt_ChequePrint


@HD_ID nvarchar(50),
@BR_ID nvarchar(50) ,
@VOUCHER_ID nvarchar(MAX)

AS



select [Voucher No], [Payment To], Amount, Date,SUBSTRING(Date,1,1) D1,SUBSTRING(Date,2,1) D2,SUBSTRING(Date,3,1) M1,SUBSTRING(Date,4,1) M2,SUBSTRING(Date,5,1) Y1,SUBSTRING(Date,6,1) Y2,SUBSTRING(Date,7,1) Y3,SUBSTRING(Date,8,1) Y4
from
(select VCH_MID [Voucher No], Format(VCH_date, N'ddMMyyyy') [Date], m.VCH_paidTo [Payment To], d.VCH_DEF_credit Amount
	from TBL_VCH_MAIN  m
	join TBL_VCH_DEF d on d.VCH_MAIN_ID = m.VCH_MID
	join TBL_COA c on c.COA_UID = d.VCH_DEF_COA and c.COA_isDeleted = 0 and c.BRC_ID = @BR_ID  and c.CMP_ID = @HD_ID
	join TBL_COA c1 on c1.COA_UID = c.COA_PARENTID and c1.COA_isDeleted = 0 and c1.BRC_ID = @BR_ID  and c1.CMP_ID = @HD_ID and c1.COA_Name = 'Cash at Bank'
	where m.CMP_ID = @HD_ID and m.BRC_ID = @BR_ID and VCH_MID  in (select val from dbo.split(@VOUCHER_ID,','))
	)A
	order by  [Voucher No]