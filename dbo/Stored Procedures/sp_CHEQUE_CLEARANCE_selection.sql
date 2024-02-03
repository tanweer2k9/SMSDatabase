
CREATE PROC [dbo].[sp_CHEQUE_CLEARANCE_selection]


@HD_ID int,
@BR_ID int,
@IS_CLEARED_CHEQUES bit,
@FROM_DATE date,
@TO_DATE date

AS

declare @clearance bit = 0

--declare @HD_ID int = 2
--declare @BR_ID int = 1





--select * from CHEQUE_INFO
--select * from CHEQ_FEE_INFO


select distinct A.[Cheque ID], A.[Std ID], A.[School ID],A.Name,A.[Class Plan],A.[Fee Month],c.CHEQ_CHEQUE_NO [Cheque No],c.CHEQ_DATE [Cheque Date],c.CHEQ_CLEARANCE_DATE [Clearance Date],c.CHEQ_BANK_NAME [Bank], CHEQ_COA_ACCOUNT as [Coa Account],c.CHEQ_AMOUNT [Amount],c.CHEQ_REMARKS [Remarks],c.CHEQ_IS_CLEARED Cheque,c.CHEQ_IS_DISHONORED [Is DisHonored] from
(select distinct t2.CHEQ_FEE_CHEQUE_ID [Cheque ID], 
  STUFF(
         (SELECT  ', ' + CAST(s.STDNT_ID as nvarchar(20))
          FROM FEE_COLLECT t1
		  join STUDENT_INFO s on s.STDNT_ID = t1.FEE_COLLECT_STD_ID
          inner join CHEQ_FEE_INFO t
            on t1.FEE_COLLECT_ID = t.CHEQ_FEE_COLLECT_ID
          where t2.CHEQ_FEE_CHEQUE_ID = t.CHEQ_FEE_CHEQUE_ID
          FOR XML PATH ('')), 1, 1, '') [Std ID],

  
  STUFF(
         (SELECT  ', ' + s.STDNT_SCHOOL_ID
          FROM FEE_COLLECT t1
		  join STUDENT_INFO s on s.STDNT_ID = t1.FEE_COLLECT_STD_ID
          inner join CHEQ_FEE_INFO t
            on t1.FEE_COLLECT_ID = t.CHEQ_FEE_COLLECT_ID
          where t2.CHEQ_FEE_CHEQUE_ID = t.CHEQ_FEE_CHEQUE_ID
          FOR XML PATH ('')), 1, 1, '') [School ID],

		  STUFF(
         (SELECT distinct ', ' + dbo.get_month_name(t1.FEE_COLLECT_FEE_FROM_DATE,t1.FEE_COLLECT_FEE_TO_DATE)
          FROM FEE_COLLECT t1
		  --join STUDENT_INFO s on s.STDNT_ID = t1.FEE_COLLECT_STD_ID
          inner join CHEQ_FEE_INFO t
            on t1.FEE_COLLECT_ID = t.CHEQ_FEE_COLLECT_ID
          where t2.CHEQ_FEE_CHEQUE_ID = t.CHEQ_FEE_CHEQUE_ID
          FOR XML PATH ('')), 1, 1, '') [Fee Month],

		  STUFF(
         (SELECT  ', ' + s.STDNT_FIRST_NAME
          FROM FEE_COLLECT t1
		  join STUDENT_INFO s on s.STDNT_ID = t1.FEE_COLLECT_STD_ID
          inner join CHEQ_FEE_INFO t
            on t1.FEE_COLLECT_ID = t.CHEQ_FEE_COLLECT_ID
          where t2.CHEQ_FEE_CHEQUE_ID = t.CHEQ_FEE_CHEQUE_ID
          FOR XML PATH ('')), 1, 1, '') [Name],

		  STUFF(
         (SELECT distinct ', ' + sp.CLASS_Name 
          FROM FEE_COLLECT t1
		  join SCHOOL_PLANE sp on sp.CLASS_ID = t1.FEE_COLLECT_PLAN_ID
          inner join CHEQ_FEE_INFO t
            on t1.FEE_COLLECT_ID = t.CHEQ_FEE_COLLECT_ID
          where t2.CHEQ_FEE_CHEQUE_ID = t.CHEQ_FEE_CHEQUE_ID
          FOR XML PATH ('')), 1, 1, '') [Class Plan]
		  

from CHEQ_FEE_INFO t2 )A
join CHEQUE_INFO c on c.CHEQ_ID =A.[Cheque ID]
join CHEQ_FEE_INFO cf on cf.CHEQ_FEE_CHEQUE_ID = c.CHEQ_ID
join FEE_COLLECT f on f.FEE_COLLECT_ID = cf.CHEQ_FEE_COLLECT_ID
--join TBL_COA coa on coa.COA_UID = c.CHEQ_COA_ACCOUNT and CAST(c.CHEQ_BR_ID as nvarchar(50)) = coa.BRC_ID and CAST(c.CHEQ_HD_ID as nvarchar(50)) = coa.CMP_ID and coa.COA_isDeleted = 0
where c.CHEQ_HD_ID = @HD_ID and c.CHEQ_BR_ID =@BR_ID and c.CHEQ_IS_CLEARED = @IS_CLEARED_CHEQUES and c.CHEQ_AMOUNT > 0 and c.CHEQ_DATE between @FROM_DATE and @TO_DATE  order by c.CHEQ_DATE


declare @cash_at_bank_account nvarchar(100) =''
			select @cash_at_bank_account = COA_UID from TBL_COA where COA_Name = 'Cash at Bank' and CMP_ID = CAST(@HD_ID as nvarchar(50)) and BRC_ID = CAST(@BR_ID as nvarchar(50))

	select COA_UID, COA_Name from TBL_COA where COA_PARENTID = @cash_at_bank_account and COA_isDeleted = 0 and CMP_ID = CAST(@HD_ID as nvarchar(50)) and BRC_ID = CAST(@BR_ID as nvarchar(50))

--select s.STDNT_ID as [Std ID], s.STDNT_SCHOOL_ID as [School ID],f.FEE_COLLECT_ID as [Invoice ID],dbo.get_month_name (f.FEE_COLLECT_FEE_FROM_DATE, f.FEE_COLLECT_FEE_TO_DATE) as [Fee Month],s.STDNT_FIRST_NAME as Name, p.CLASS_Name as [Class Plan],v.VCH_chequeNo as [Cheque No],
--v.VCH_date as [Cheque Date], v.VCH_chequeClearanceDate as [Clearance Date],v.VCH_chequeBankName as Bank, f.FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT as Amount,@clearance as Cheque

--from FEE_COLLECT f
--join STUDENT_INFO s on f.FEE_COLLECT_STD_ID = s.STDNT_ID
--join TBL_VCH_MAIN v on v.VCH_referenceNo = CAST(f.FEE_COLLECT_ID as nvarchar(50))
--join SCHOOL_PLANE p on p.CLASS_ID = s.STDNT_CLASS_PLANE_ID

--where f.FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT > 0
--and s.STDNT_HD_ID = @HD_ID and s.STDNT_BR_ID = @BR_ID