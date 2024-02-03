CREATE FUNCTION [dbo].[GET_FEE_VOUCHERS] (@BR_ID nvarchar(50), @HD_ID nvarchar(50), @FROM_DATE date,@TO_DATE date)
returns @t table ([Voucher No] nvarchar(50), [COA Account] nvarchar(50),Debit float ,Credit float,[Std #]nvarchar(2000),[Std Name]nvarchar(2000),[Class]nvarchar(1000),[Installement]nvarchar(50), [Cheque No] nvarchar(50),[Date]  date, [Deposite Type] nvarchar(50) )


--declare @BR_ID nvarchar(50) = '1'
--declare @HD_ID nvarchar(50) = '1'
--declare @Bank_Account_Head nvarchar(50) = '01-06-01-00000'
--declare @FROM_DATE date = '2016-08-01'
--declare @TO_DATE date = '2017-08-31'

AS BEGIN

declare @tbl_bank_deposite table ([Voucher No] nvarchar(50), [COA Account] nvarchar(50),Debit float ,Credit float,[Std #]nvarchar(50),[Std Name]nvarchar(50),[Class]nvarchar(50),[Installement]nvarchar(50), [Cheque No] nvarchar(50),[Date]  date )


declare @tbl_multiple_cheques_received table ([Voucher No] nvarchar(50), [COA Account] nvarchar(50),Debit float ,Credit float,[Std #]nvarchar(1000),[Std Name]nvarchar(1000),[Class]nvarchar(1000),[Installement]nvarchar(1000), [Cheque No] nvarchar(50),[Date]  date)


declare @tbl_transfered_From_cash_to_bank table ([Voucher No] nvarchar(500), [COA Account] nvarchar(500),Debit float ,Credit float,[Std #]nvarchar(1000),[Std Name]nvarchar(1000),[Class]nvarchar(1000),[Installement]nvarchar(1000), [Cheque No] nvarchar(50),[Date]  date)


--THis case is of Multiple CHeques Received
;with CTE as
(
  select T2.VCH_MAIN_ID col1,s.STDNT_SCHOOL_ID [Std No.]
    , s.STDNT_FIRST_NAME  [Std Name], sp.CLASS_Name [Class Name], T1.FEE_COLLECT_INSTALLMENT_NAME
 from TBL_VCH_DEF T2 
    inner join FEE_COLLECT T1 on charindex(',' + CAST(T1.FEE_COLLECT_ID as nvarchar(50)) + ',', ',' + T2.VCH_DEF_referenceNo + ',') > 0
	join STUDENT_INFO s on s.STDNT_ID = T1.FEE_COLLECT_STD_ID
	join SCHOOL_PLANE sp on sp.CLASS_ID = T1.FEE_COLLECT_PLAN_ID	
		join TBL_VCH_MAIN m on m.VCH_MID = t2.VCH_MAIN_ID and m.BRC_ID = t2.BRC_ID 
	where VCH_DEF_ItemCOA ='Multiple Cheques Received' and t2.BRC_ID = @BR_ID and VCH_DEF_credit = 0 and CAST(m.VCH_date as date) between @From_Date and @To_Date
)
,
tbl as
(select T2.VCH_MAIN_ID,T2.VCH_DEF_referenceNo [Fee Ids],
[Std #] = stuff(  (   select ',' + CTE.[Std No.]    from CTE    where T2.VCH_MAIN_ID = CTE.col1   for xml path('')   )   , 1    , 1    , ''    ),
[Std Name] = stuff( (   select ',' + CTE.[Std Name]   from CTE    where T2.VCH_MAIN_ID = CTE.col1   for xml path('')   )   , 1    , 1    , ''    ),
[Class] = stuff( ( select ',' + CTE.[Class Name] from CTE    where T2.VCH_MAIN_ID = CTE.col1   for xml path('')   )   , 1    , 1    , ''    ),
[Installement] = stuff(  ( select distinct ',' + FEE_COLLECT_INSTALLMENT_NAME   from CTE   where T2.VCH_MAIN_ID = CTE.col1      for xml path('')     )    , 1     , 1 , ''),
T2.VCH_DEF_date [Date]
 
from TBL_VCH_DEF T2 
join TBL_VCH_MAIN m on m.VCH_MID = t2.VCH_MAIN_ID and m.BRC_ID = t2.BRC_ID 
	where VCH_DEF_ItemCOA ='Multiple Cheques Received' and t2.BRC_ID = @BR_ID and VCH_DEF_credit = 0 and CAST(m.VCH_date as date) between @From_Date and @To_Date
	)

--Insert into  Transfered From Cash To Bank Table Variable
insert into @tbl_multiple_cheques_received
select tbl.VCH_MAIN_ID [Voucher No],CASE WHEN d.VCH_DEF_credit=0 THEN c.COA_Name ELSE 'Debtor' END [COA Name],d.VCH_DEF_debit Debit,d.VCH_DEF_credit Credit, tbl.[Std #],  [Std Name], [Class],[Installement], (select top(1) CHEQ_CHEQUE_NO from CHEQUE_INFO where CHEQ_IS_DISHONORED != 1 and CAST(CHEQ_ID as nvarchar(50)) =   (select m.VCH_referenceNo from TBL_VCH_MAIN m where m.VCH_MID = d.VCH_MAIN_ID and m.CMP_ID = @HD_ID and m.BRC_ID = @BR_ID )),tbl.[Date]  from tbl 
join TBL_VCH_DEF d on tbl.VCH_MAIN_ID = d.VCH_MAIN_ID
join TBL_COA c on c.COA_UID = d.VCH_DEF_COA 
join TBL_VCH_MAIN m on m.VCH_MID = d.VCH_MAIN_ID and m.BRC_ID = d.BRC_ID 
where VCH_DEF_ItemCOA ='Multiple Cheques Received' and d.CMP_ID = @HD_ID and d.BRC_ID = @BR_ID  and c.CMP_ID = @HD_ID and c.BRC_ID = @BR_ID and c.COA_isDeleted = 0
and CAST(m.VCH_date as date) between @From_Date and @To_Date
--THis case is of  Transfered From Cash To Bank End



--THis case is of Transfered From Cash To Bank
;with CTE as
(
  select T2.VCH_DEF_countID col1,s.STDNT_SCHOOL_ID [Std No.]
    , s.STDNT_FIRST_NAME  [Std Name], sp.CLASS_Name [Class Name], T1.FEE_COLLECT_INSTALLMENT_NAME
 from TBL_VCH_DEF T2 
    inner join FEE_COLLECT T1 on charindex(',' + CAST(T1.FEE_COLLECT_ID as nvarchar(50)) + ',', ',' + T2.VCH_DEF_referenceNo + ',') > 0
	join STUDENT_INFO s on s.STDNT_ID = T1.FEE_COLLECT_STD_ID
	join SCHOOL_PLANE sp on sp.CLASS_ID = T1.FEE_COLLECT_PLAN_ID
	join TBL_VCH_MAIN m on m.VCH_MID = T2.VCH_MAIN_ID and m.BRC_ID = T2.BRC_ID 	
	where VCH_DEF_ItemCOA ='Transfered To' and T2.CMP_ID = @HD_ID and T2.BRC_ID = @BR_ID  and  CAST(m.VCH_date as date) between @From_Date and @To_Date
)
,tbl as
(select T2.VCH_DEF_countID,T2.VCH_MAIN_ID,T2.VCH_DEF_referenceNo [Fee Ids],T2.VCH_DEF_credit,T2.VCH_DEF_debit,T2.VCH_DEF_COA,
[Std #] = stuff(  (   select ',' + CTE.[Std No.]    from CTE    where T2.VCH_DEF_countID = CTE.col1   for xml path('')   )   , 1    , 1    , ''    ),
[Std Name] = stuff( (   select ',' + CTE.[Std Name]   from CTE    where T2.VCH_DEF_countID = CTE.col1   for xml path('')   )   , 1    , 1    , ''    ),
[Class] = stuff( ( select ',' + CTE.[Class Name] from CTE    where T2.VCH_DEF_countID = CTE.col1   for xml path('')   )   , 1    , 1    , ''    ),
[Installement] = stuff(  ( select distinct ',' + FEE_COLLECT_INSTALLMENT_NAME   from CTE   where T2.VCH_DEF_countID = CTE.col1      for xml path('')     )    , 1     , 1 , ''), T2.VCH_DEF_date [Date]
 
from TBL_VCH_DEF T2 
join TBL_VCH_MAIN m on m.VCH_MID = T2.VCH_MAIN_ID and m.BRC_ID = T2.BRC_ID 
where VCH_DEF_ItemCOA ='Transfered To' and T2.BRC_ID = @BR_ID and   CAST(m.VCH_date as date) between @From_Date and @To_Date) 
--Insert into Multiple CHeques Received table variable
insert into @tbl_transfered_From_cash_to_bank

select tbl.VCH_MAIN_ID [Voucher No],CASE WHEN tbl.VCH_DEF_credit=0 THEN c.COA_Name ELSE 'Debtor' END [COA Name],tbl.VCH_DEF_debit Debit,tbl.VCH_DEF_credit Credit, tbl.[Std #],  [Std Name], [Class],[Installement], '' [Cheque No],[Date]  from tbl 

join TBL_COA c on c.COA_UID = tbl.VCH_DEF_COA 
where c.CMP_ID = @HD_ID and c.BRC_ID = @BR_ID and c.COA_isDeleted = 0 









--Case of Fees Deposite in bank
insert into @tbl_bank_deposite
--This is getting of credit records means Students Account
select A.VCH_MAIN_ID [Voucher No], MAX('Debtor') [COA Name]  , MAX(0) Debit, SUM(d1.VCH_DEF_credit) [Credit], MAX(s.STDNT_SCHOOL_ID) [Std #], MAX(s.STDNT_FIRST_NAME) [Std Name],MAX( p.CLASS_Name) [Class],MAX(f.FEE_COLLECT_INSTALLMENT_NAME) [Installement], '' [Cheque No],MAX(VCH_DEF_date) [Date] from
(select d.VCH_MAIN_ID,m.VCH_referenceNo from TBL_VCH_DEF d
join TBL_COA c on c.COA_UID = d.VCH_DEF_COA and c.CMP_ID = @HD_ID and c.BRC_ID = @BR_ID and c.COA_isDeleted = 0
join TBL_VCH_MAIN m on m.VCH_MID = d.VCH_MAIN_ID and m.CMP_ID  =@HD_ID and m.BRC_ID = @BR_ID 

where CAST(m.VCH_date as date) between @From_Date and @To_Date and d.VCH_DEF_COA in (select c1.COA_UID from TBL_COA c1 where c1.CMP_ID = @HD_ID and c1.BRC_ID = @BR_ID and c1.COA_isDeleted = 0 and c1.COA_PARENTID in (select c2.COA_UID from TBL_COA c2 where c2.CMP_ID = @HD_ID and c2.BRC_ID = @BR_ID and c2.COA_isDeleted = 0 and c2.COA_Name ='Cash at Bank')) and d.CMP_ID 
 =@HD_ID and d.BRC_ID = @BR_ID and d.VCH_MAIN_ID like 'FE%' and (d.VCH_DEF_ItemCOA is null OR d.VCH_DEF_ItemCOA = '' )  )A

join FEE_COLLECT f on CAST(f.FEE_COLLECT_ID as nvarchar(50))  = A.VCH_referenceNo 
join STUDENT_INFO s on s.STDNT_ID = f.FEE_COLLECT_STD_ID
join SCHOOL_PLANE p on p.CLASS_ID = f.FEE_COLLECT_PLAN_ID
join TBL_COA c2 on c2.COA_ID = s.STDNT_COA_ID
join TBL_VCH_DEF d1 on d1.VCH_DEF_COA = c2.COA_UID  and d1.VCH_MAIN_ID = A.VCH_MAIN_ID
where d1.CMP_ID =@HD_ID and d1.BRC_ID = @BR_ID and d1.VCH_DEF_remarks = 'U' 
group by A.VCH_MAIN_ID



insert into @t
--This is getting of debit records means Bank Account

select A.* from
(select A.*,[Std #],[Std Name],[Class],[Installement], '' [Cheque No],[Date],'Bank Deposite' [Deposite Type] from
(select m.VCH_MID [Voucher No], MAX(c.COA_Name) [COA Account],SUM(VCH_DEF_debit) Debit,0 Credit
from TBL_VCH_DEF d
join TBL_COA c on c.COA_UID = d.VCH_DEF_COA and c.CMP_ID = @HD_ID and c.BRC_ID = @BR_ID and c.COA_isDeleted = 0
join TBL_VCH_MAIN m on m.VCH_MID = d.VCH_MAIN_ID and m.CMP_ID  =@HD_ID and m.BRC_ID = @BR_ID

where CAST(m.VCH_date as date) between @From_Date and @To_Date and d.VCH_DEF_COA in (select c1.COA_UID from TBL_COA c1 where c1.CMP_ID = @HD_ID and c1.BRC_ID = @BR_ID and c1.COA_isDeleted = 0 and c1.COA_PARENTID in (select c2.COA_UID from TBL_COA c2 where c2.CMP_ID = @HD_ID and c2.BRC_ID = @BR_ID and c2.COA_isDeleted = 0 and c2.COA_Name ='Cash at Bank')) and d.CMP_ID 
 =@HD_ID and d.BRC_ID = @BR_ID and d.VCH_MAIN_ID like 'FE%' and (d.VCH_DEF_ItemCOA is null OR d.VCH_DEF_ItemCOA = '' )  
group by m.VCH_MID)A
join @tbl_bank_deposite bd on bd.[Voucher No] = A.[Voucher No]

union

select *,'Bank Deposite' [Deposite Type] from @tbl_bank_deposite

--Case of Fees Deposite in bank End

union 

select *, 'Multiple Cheques Received' from @tbl_multiple_cheques_received

union 

select *, 'Cash Transfer To Bank' from @tbl_transfered_From_cash_to_bank
)A
left join TBL_VCH_SERIES s on A.[Voucher No] = s.VCH_SERIES_VCH_MAIN_ID and s.VCH_SERIES_BR_ID = @BR_ID

order by s.VCH_SERIES_VCH_PREFIX, s.VCH_SERIES_BANK_CODE,s.VCH_SERIES_NUMBER
return
END