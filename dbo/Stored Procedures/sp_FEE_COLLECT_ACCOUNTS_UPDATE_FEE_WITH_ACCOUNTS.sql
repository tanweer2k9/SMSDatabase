
CREATE PROC [dbo].[sp_FEE_COLLECT_ACCOUNTS_UPDATE_FEE_WITH_ACCOUNTS] 


@FEE_COLLECT_ID numeric,
@Late_Fee_Fine float,
@BR_ID numeric,
@STD_ID numeric,
@Fee_Name nvarchar(50)


AS

declare @CLASS_coa numeric= 0
declare @std_coa  numeric = 0

	select @CLASS_coa = p.CLASS_COA_ID,@std_coa = ISNULL(STDNT_COA_ID,0) from STUDENT_INFO s 
	join SCHOOL_PLANE p on s.STDNT_CLASS_PLANE_ID = p.CLASS_ID 
	where STDNT_ID = @STD_ID



update fd set fd.FEE_COLLECT_DEF_FEE =  @Late_Fee_Fine, fd.FEE_COLLECT_DEF_TOTAL = fd.FEE_COLLECT_DEF_TOTAL + @Late_Fee_Fine
from FEE_COLLECT_DEF fd
join FEE_INFO f on f.FEE_ID = fd.FEE_COLLECT_DEF_FEE_NAME and f.FEE_BR_ID = @BR_ID
where f.FEE_NAME = @Fee_Name and fd.FEE_COLLECT_DEF_PID = @FEE_COLLECT_ID

update FEE_COLLECT set FEE_COLLECT_FEE = FEE_COLLECT_FEE + @Late_Fee_Fine, FEE_COLLECT_NET_TOATAL = FEE_COLLECT_NET_TOATAL + @Late_Fee_Fine where FEE_COLLECT_ID = @FEE_COLLECT_ID

update vd set vd.VCH_DEF_credit = CASE WHEN c.COA_Name = @Fee_Name OR  vd.VCH_DEF_credit > 0 THEN vd.VCH_DEF_credit + @Late_Fee_Fine ELSE 0 END, vd.VCH_DEF_debit = CASE WHEN vd.VCH_DEF_debit > 0 AND c.COA_Name != @Fee_Name THEN vd.VCH_DEF_debit + @Late_Fee_Fine ELSE 0 END
from TBL_VCH_DEF vd
join TBL_VCH_MAIN m on m.VCH_MID = vd.VCH_MAIN_ID
join TBL_COA c on c.COA_UID = vd.VCH_DEF_COA
where m.VCH_referenceNo = CAST(@FEE_COLLECT_ID as nvarchar(25)) and vd.BRC_ID = @BR_ID and c.BRC_ID = @BR_ID and c.COA_isDeleted = 0 and (c.COA_ID = @std_coa OR c.COA_ID = @CLASS_coa OR c.COA_Name = 'Final Fee Bills' OR c.COA_Name = @Fee_Name)