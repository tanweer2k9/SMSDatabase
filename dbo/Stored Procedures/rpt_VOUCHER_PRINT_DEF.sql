CREATE PROC [dbo].[rpt_VOUCHER_PRINT_DEF]


@HD_ID nvarchar(50),
@BR_ID nvarchar(50) ,
@VOUCHER_ID nvarchar(MAX),
@From_Date date,
@To_Date date,
@Status nvarchar(50),
@COA_ACCOUNT_HEAD nvarchar(50)


AS

if @Status = 'Voucher'
BEGIN
	select VCH_MAIN_ID [Voucher No], c.COA_Name [COA Account], d.VCH_DEF_narration Narration,d.VCH_DEF_debit [Debit],d.VCH_DEF_credit [Credit], '' [Deposite Type]
	from TBL_VCH_DEF d
	join TBL_COA c on c.COA_UID = d.VCH_DEF_COA

	 where d.CMP_ID = @HD_ID and d.BRC_ID = @BR_ID and d.VCH_MAIN_ID in (select val from dbo.split(@VOUCHER_ID,','))  and c.CMP_ID = @HD_ID and c.BRC_ID = @BR_ID and c.COA_isDeleted = 0



 END
 ELSE if @Status = 'Fee Voucher'
 BEGIN
	
	declare @t table ([Voucher No] nvarchar(50), [COA Account] nvarchar(50),Debit float ,Credit float,[Std #]nvarchar(2000),[Std Name]nvarchar(2000),[Class]nvarchar(1000),[Installement]nvarchar(50), [Cheque No] nvarchar(50),[Date]  date, [Deposite Type] nvarchar(50),Narration nvarchar(2000) )



	declare @count int = 0
declare @i int = 1

set @count= (select COUNT(*) from COMBINE_BRANCHES c where c.FROM_BRANCH_ID = @BR_ID)

WHILE @i <= @count
BEGIN
		select @BR_ID = COMBINE_BRANCHES_ID from  (select ROW_NUMBER() over (order by (select 0)) as sr,c.COMBINE_BRANCHES_ID from COMBINE_BRANCHES c where c.FROM_BRANCH_ID		= @BR_ID)A where sr = @i
	
	select @HD_ID = BR_ADM_HD_ID  from BR_ADMIN where BR_ADM_ID = @BR_ID


	insert into @t
	select *, '' as Narration from dbo.[GET_FEE_VOUCHERS] (@BR_ID, @HD_ID, @FROM_DATE ,@TO_DATE )
	union all
	select VCH_MID [Voucher No], c.COA_Name CoaAccount, d.VCH_DEF_debit Debit, 0 Credit, '' [Std #], '','','','', VCH_DEF_date, 'Bank Receipt', d.VCH_DEF_narration as Narration
from TBL_VCH_MAIN  m 
	
join TBL_VCH_DEF d on d.VCH_MAIN_ID = m.VCH_MID and m.BRC_ID = d.BRC_ID
join TBL_COA c on c.COA_UID = d.VCH_DEF_COA and c.CMP_ID = @HD_ID and c.BRC_ID = @BR_ID and c.COA_isDeleted = 0

where (VCH_DEF_COA = @COA_ACCOUNT_HEAD ) and d.CMP_ID  =@HD_ID and d.BRC_ID = @BR_ID and d.VCH_MAIN_ID like 'BR-%' and m.CMP_ID = @HD_ID and m.BRC_ID = @BR_ID and CAST(m.VCH_date as date) between @From_Date and @To_Date 

union all
select VCH_MID [Voucher No], c.COA_Name CoaAccount, 0 Debit, d1.VCH_DEF_credit Credit, '', '','','','', d1.VCH_DEF_date, 'Bank Receipt', d1.VCH_DEF_narration as Narration


from TBL_VCH_MAIN  m 
	
join TBL_VCH_DEF d on d.VCH_MAIN_ID = m.VCH_MID and m.BRC_ID = d.BRC_ID and VCH_DEF_COA = @COA_ACCOUNT_HEAD
join TBL_VCH_DEF d1 on d1.VCH_MAIN_ID = d.VCH_MAIN_ID and d.BRC_ID = d1.BRC_ID  and d1.VCH_DEF_COA != @COA_ACCOUNT_HEAD and CAST(d1.VCH_DEF_date as date) between @From_Date and @To_Date 
join TBL_COA c on c.COA_UID = d1.VCH_DEF_COA and c.CMP_ID = @HD_ID and c.BRC_ID = @BR_ID and c.COA_isDeleted = 0

where  d.CMP_ID =@HD_ID and d.BRC_ID = @BR_ID and d.VCH_MAIN_ID like 'BR-%' and m.CMP_ID = @HD_ID and m.BRC_ID = @BR_ID and CAST(m.VCH_date as date) between @From_Date and @To_Date 

	set @i = @i + 1
END



	select * from @t

--COnvert this into tabular value function [GET_FEE_VOUCHERS]
--declare @tbl_bank_deposite table ([Voucher No] nvarchar(50), [COA Account] nvarchar(50),Debit float ,Credit float,[Std #]nvarchar(50),[Std Name]nvarchar(50),[Class]nvarchar(50),[Installement]nvarchar(50), [Cheque No] nvarchar(50) )


--declare @tbl_multiple_cheques_received table ([Voucher No] nvarchar(50), [COA Account] nvarchar(50),Debit float ,Credit float,[Std #]nvarchar(1000),[Std Name]nvarchar(1000),[Class]nvarchar(1000),[Installement]nvarchar(1000), [Cheque No] nvarchar(50))


--declare @tbl_transfered_From_cash_to_bank table ([Voucher No] nvarchar(500), [COA Account] nvarchar(500),Debit float ,Credit float,[Std #]nvarchar(1000),[Std Name]nvarchar(1000),[Class]nvarchar(1000),[Installement]nvarchar(1000), [Cheque No] nvarchar(50))


----THis case is of Multiple CHeques Received
--;with CTE as
--(
--  select T2.VCH_MAIN_ID col1,s.STDNT_SCHOOL_ID [Std No.]
--    , s.STDNT_FIRST_NAME  [Std Name], sp.CLASS_Name [Class Name], T1.FEE_COLLECT_INSTALLMENT_NAME
-- from TBL_VCH_DEF T2 
--    inner join FEE_COLLECT T1 on charindex(',' + CAST(T1.FEE_COLLECT_ID as nvarchar(50)) + ',', ',' + T2.VCH_DEF_referenceNo + ',') > 0
--	join STUDENT_INFO s on s.STDNT_ID = T1.FEE_COLLECT_STD_ID
--	join SCHOOL_PLANE sp on sp.CLASS_ID = T1.FEE_COLLECT_PLAN_ID	
--	where VCH_DEF_ItemCOA ='Multiple Cheques Received' and CMP_ID = @HD_ID and BRC_ID = @BR_ID and VCH_DEF_credit = 0 and CAST(VCH_DEF_date as date) between @From_Date and @To_Date
--)
--,
--tbl as
--(select T2.VCH_MAIN_ID,T2.VCH_DEF_referenceNo [Fee Ids],
--[Std #] = stuff(  (   select ',' + CTE.[Std No.]    from CTE    where T2.VCH_MAIN_ID = CTE.col1   for xml path('')   )   , 1    , 1    , ''    ),
--[Std Name] = stuff( (   select ',' + CTE.[Std Name]   from CTE    where T2.VCH_MAIN_ID = CTE.col1   for xml path('')   )   , 1    , 1    , ''    ),
--[Class] = stuff( ( select ',' + CTE.[Class Name] from CTE    where T2.VCH_MAIN_ID = CTE.col1   for xml path('')   )   , 1    , 1    , ''    ),
--[Installement] = stuff(  ( select distinct ',' + FEE_COLLECT_INSTALLMENT_NAME   from CTE   where T2.VCH_MAIN_ID = CTE.col1      for xml path('')     )    , 1     , 1 , '')
 
--from TBL_VCH_DEF T2 
--where VCH_DEF_ItemCOA ='Multiple Cheques Received' and CMP_ID = @HD_ID and BRC_ID = @BR_ID and VCH_DEF_credit = 0 and CAST(VCH_DEF_date as date) between @From_Date and @To_Date)

----Insert into  Transfered From Cash To Bank Table Variable
--insert into @tbl_multiple_cheques_received
--select tbl.VCH_MAIN_ID [Voucher No],CASE WHEN d.VCH_DEF_credit=0 THEN c.COA_Name ELSE 'Debtor' END [COA Name],d.VCH_DEF_debit Debit,d.VCH_DEF_credit Credit, tbl.[Std #],  [Std Name], [Class],[Installement], (select top(1) CHEQ_CHEQUE_NO from CHEQUE_INFO where CAST(CHEQ_ID as nvarchar(50)) =   (select m.VCH_referenceNo from TBL_VCH_MAIN m where m.VCH_MID = d.VCH_MAIN_ID and m.CMP_ID = @HD_ID and m.BRC_ID = @BR_ID ))  from tbl 
--join TBL_VCH_DEF d on tbl.VCH_MAIN_ID = d.VCH_MAIN_ID
--join TBL_COA c on c.COA_UID = d.VCH_DEF_COA 

--where VCH_DEF_ItemCOA ='Multiple Cheques Received' and d.CMP_ID = @HD_ID and d.BRC_ID = @BR_ID  and c.CMP_ID = @HD_ID and c.BRC_ID = @BR_ID and c.COA_isDeleted = 0
--and CAST(d.VCH_DEF_date as date) between @From_Date and @To_Date
----THis case is of  Transfered From Cash To Bank End



----THis case is of Transfered From Cash To Bank
--;with CTE as
--(
--  select T2.VCH_DEF_countID col1,s.STDNT_SCHOOL_ID [Std No.]
--    , s.STDNT_FIRST_NAME  [Std Name], sp.CLASS_Name [Class Name], T1.FEE_COLLECT_INSTALLMENT_NAME
-- from TBL_VCH_DEF T2 
--    inner join FEE_COLLECT T1 on charindex(',' + CAST(T1.FEE_COLLECT_ID as nvarchar(50)) + ',', ',' + T2.VCH_DEF_referenceNo + ',') > 0
--	join STUDENT_INFO s on s.STDNT_ID = T1.FEE_COLLECT_STD_ID
--	join SCHOOL_PLANE sp on sp.CLASS_ID = T1.FEE_COLLECT_PLAN_ID	
--	where VCH_DEF_ItemCOA ='Transfered To' and T2.CMP_ID = @HD_ID and T2.BRC_ID = @BR_ID  and  CAST(VCH_DEF_date as date) between @From_Date and @To_Date
--)
--,tbl as
--(select T2.VCH_DEF_countID,T2.VCH_MAIN_ID,T2.VCH_DEF_referenceNo [Fee Ids],T2.VCH_DEF_credit,T2.VCH_DEF_debit,T2.VCH_DEF_COA,
--[Std #] = stuff(  (   select ',' + CTE.[Std No.]    from CTE    where T2.VCH_DEF_countID = CTE.col1   for xml path('')   )   , 1    , 1    , ''    ),
--[Std Name] = stuff( (   select ',' + CTE.[Std Name]   from CTE    where T2.VCH_DEF_countID = CTE.col1   for xml path('')   )   , 1    , 1    , ''    ),
--[Class] = stuff( ( select ',' + CTE.[Class Name] from CTE    where T2.VCH_DEF_countID = CTE.col1   for xml path('')   )   , 1    , 1    , ''    ),
--[Installement] = stuff(  ( select distinct ',' + FEE_COLLECT_INSTALLMENT_NAME   from CTE   where T2.VCH_DEF_countID = CTE.col1      for xml path('')     )    , 1     , 1 , '')
 
--from TBL_VCH_DEF T2 
--where VCH_DEF_ItemCOA ='Transfered To' and CMP_ID = @HD_ID and BRC_ID = @BR_ID and   CAST(T2.VCH_DEF_date as date) between @From_Date and @To_Date) 
----Insert into Multiple CHeques Received table variable
--insert into @tbl_transfered_From_cash_to_bank

--select tbl.VCH_MAIN_ID [Voucher No],CASE WHEN tbl.VCH_DEF_credit=0 THEN c.COA_Name ELSE 'Debtor' END [COA Name],tbl.VCH_DEF_debit Debit,tbl.VCH_DEF_credit Credit, tbl.[Std #],  [Std Name], [Class],[Installement], '' [Cheque No]  from tbl 

--join TBL_COA c on c.COA_UID = tbl.VCH_DEF_COA 
--where c.CMP_ID = @HD_ID and c.BRC_ID = @BR_ID and c.COA_isDeleted = 0 









----Case of Fees Deposite in bank
--insert into @tbl_bank_deposite
----This is getting of credit records means Students Account
--select d1.VCH_MAIN_ID [Voucher No], MAX('Debtor') [COA Name]  , MAX(0) Debit, SUM(d1.VCH_DEF_credit) [Credit], MAX(s.STDNT_SCHOOL_ID) [Std #], MAX(s.STDNT_FIRST_NAME) [Std Name],MAX( p.CLASS_Name) [Class],MAX(f.FEE_COLLECT_INSTALLMENT_NAME) [Installement], '' [Cheque No] from
--(select d.VCH_MAIN_ID,m.VCH_referenceNo from TBL_VCH_DEF d
--join TBL_COA c on c.COA_UID = d.VCH_DEF_COA and c.CMP_ID = @HD_ID and c.BRC_ID = @BR_ID and c.COA_isDeleted = 0
--join TBL_VCH_MAIN m on m.VCH_MID = d.VCH_MAIN_ID and m.CMP_ID  =@HD_ID and m.BRC_ID = @BR_ID 

--where CAST(m.VCH_date as date) between @From_Date and @To_Date and d.VCH_DEF_COA in (select c1.COA_UID from TBL_COA c1 where c1.CMP_ID = @HD_ID and c1.BRC_ID = @BR_ID and c1.COA_isDeleted = 0 and c1.COA_PARENTID in (select c2.COA_UID from TBL_COA c2 where c2.CMP_ID = @HD_ID and c2.BRC_ID = @BR_ID and c2.COA_isDeleted = 0 and c2.COA_Name ='Cash at Bank')) and d.CMP_ID 
-- =@HD_ID and d.BRC_ID = @BR_ID and d.VCH_MAIN_ID like 'FE%' and (d.VCH_DEF_ItemCOA is null OR d.VCH_DEF_ItemCOA = '' )  )A

--join FEE_COLLECT f on CAST(f.FEE_COLLECT_ID as nvarchar(50))  = A.VCH_referenceNo 
--join STUDENT_INFO s on s.STDNT_ID = f.FEE_COLLECT_STD_ID
--join SCHOOL_PLANE p on p.CLASS_ID = f.FEE_COLLECT_PLAN_ID
--join TBL_COA c2 on c2.COA_ID = s.STDNT_COA_ID
--join TBL_VCH_DEF d1 on d1.VCH_DEF_COA = c2.COA_UID  
--where d1.VCH_MAIN_ID = A.VCH_MAIN_ID and d1.CMP_ID =@HD_ID and d1.BRC_ID = @BR_ID and d1.VCH_DEF_remarks = 'U'
--group by d1.VCH_MAIN_ID




----This is getting of debit records means Bank Account
--select A.*,[Std #],[Std Name],[Class],[Installement], '' [Cheque No],'Bank Deposite' [Deposite Type] from
--(select m.VCH_MID [Voucher No], MAX(c.COA_Name) [COA Account],SUM(VCH_DEF_debit) Debit,0 Credit
--from TBL_VCH_DEF d
--join TBL_COA c on c.COA_UID = d.VCH_DEF_COA and c.CMP_ID = @HD_ID and c.BRC_ID = @BR_ID and c.COA_isDeleted = 0
--join TBL_VCH_MAIN m on m.VCH_MID = d.VCH_MAIN_ID and m.CMP_ID  =@HD_ID and m.BRC_ID = @BR_ID

--where CAST(m.VCH_date as date) between @From_Date and @To_Date and d.VCH_DEF_COA in (select c1.COA_UID from TBL_COA c1 where c1.CMP_ID = @HD_ID and c1.BRC_ID = @BR_ID and c1.COA_isDeleted = 0 and c1.COA_PARENTID in (select c2.COA_UID from TBL_COA c2 where c2.CMP_ID = @HD_ID and c2.BRC_ID = @BR_ID and c2.COA_isDeleted = 0 and c2.COA_Name ='Cash at Bank')) and d.CMP_ID 
-- =@HD_ID and d.BRC_ID = @BR_ID and d.VCH_MAIN_ID like 'FE%' and (d.VCH_DEF_ItemCOA is null OR d.VCH_DEF_ItemCOA = '' )  
--group by m.VCH_MID)A
--join @tbl_bank_deposite bd on bd.[Voucher No] = A.[Voucher No]

--union

--select *,'Bank Deposite' [Deposite Type] from @tbl_bank_deposite

----Case of Fees Deposite in bank End

--union 

--select *, 'Multiple Cheques Received' from @tbl_multiple_cheques_received

--union 

--select *, 'Cash Transfer To Bank' from @tbl_transfered_From_cash_to_bank

 END