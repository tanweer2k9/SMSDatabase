

CREATE PROC [dbo].[sp_FEE_ACCOUNT_TRANSFER_selection]

 @HD_ID nvarchar(50),
 @BR_ID nvarchar(50) ,
 @From_Date date = '',
 @To_Date date = ''

 AS
--declare @HD_ID nvarchar(50) = 1
--declare @BR_ID nvarchar(50) = 1
--declare @Date date = ''

declare @tbl table (ID int, [VCH ID] nvarchar(50),VCH_referenceNo nvarchar(50), Amount float, [Coa Account] nvarchar(50),[Coa Account Name] nvarchar(50), [Received Date] date)


insert into @tbl
select d.VCH_DEF_countID, m.VCH_ID,m.VCH_referenceNo,d.VCH_DEF_debit,d.VCH_DEF_COA,c.COA_Name, m.VCH_date
--CASE WHEN r.MULTI_RECEIVE_DATE_RECEIVE is null THEN CAST() ELSE CAST(r.MULTI_RECEIVE_DATE_RECEIVE as date) END 
from TBL_VCH_DEF d 
join TBL_VCH_MAIN m on m.VCH_MID = d.VCH_MAIN_ID and m.CMP_ID = @HD_ID and m.BRC_ID = @BR_ID
join TBL_COA c on c.COA_UID = d.VCH_DEF_COA and c.CMP_ID = @HD_ID and c.BRC_ID = @BR_ID and c.COA_isDeleted = 0
--left join FEE_MULTIPLE_RECEIVED_AMOUNT r on r.MULTI_RECEIVE_VCH_MAIN_ID = d.VCH_MAIN_ID 
where VCH_DEF_COA in (select c1.COA_UID from TBL_COA c1 where c1.CMP_ID = @HD_ID and c1.BRC_ID = @BR_ID and c1.COA_isDeleted = 0 and c1.COA_PARENTID in (select c2.COA_UID from TBL_COA c2 where c2.CMP_ID = @HD_ID and c2.BRC_ID = @BR_ID and c2.COA_isDeleted = 0 and COA_Name ='Cash in Hand')) and d.CMP_ID 
 =@HD_ID and d.BRC_ID = @BR_ID and d.VCH_DEF_ItemCOA in ('','Multiple Cash Received') and d.VCH_MAIN_ID like 'FE%' and d.VCH_DEF_prefix != 'Transfered From'
and m.VCH_date between @From_Date and @To_Date and m.VCH_chequeBankName = 'Multiple Cash Received'





 ;with CTE as
(
  select T2.[VCH ID] col1,s.STDNT_SCHOOL_ID [Std No.]
    , s.STDNT_FIRST_NAME  [Std Name], sp.CLASS_Name [Class Name], T1.FEE_COLLECT_INSTALLMENT_NAME,  Convert(varchar,T2.[Received Date],103)FEE_COLLECT_DATE_FEE_RECEIVED
  from @tbl T2 
    inner join FEE_COLLECT T1 on charindex(',' + CAST(T1.FEE_COLLECT_ID as nvarchar(50)) + ',', ',' + T2.VCH_referenceNo + ',') > 0
	join STUDENT_INFO s on s.STDNT_ID = T1.FEE_COLLECT_STD_ID
	join SCHOOL_PLANE sp on sp.CLASS_ID = T1.FEE_COLLECT_PLAN_ID	
)

select T2.ID,T2.[VCH ID],T2.VCH_referenceNo [Fee Ids],
[Std No.] = stuff(  (   select ',' + CTE.[Std No.]    from CTE    where T2.[VCH ID] = CTE.col1   for xml path('')   )   , 1    , 1    , ''    ),
[Name] = stuff( (   select ',' + CTE.[Std Name]   from CTE    where T2.[VCH ID] = CTE.col1   for xml path('')   )   , 1    , 1    , ''    ),
[Class Plan] = stuff( ( select ',' + CTE.[Class Name] from CTE    where T2.[VCH ID] = CTE.col1   for xml path('')   )   , 1    , 1    , ''    ),
[Fee Period] = stuff(  ( select distinct ',' + FEE_COLLECT_INSTALLMENT_NAME   from CTE   where T2.[VCH ID] = CTE.col1      for xml path('')     )    , 1     , 1 , ''),
[Fee Received Date] = stuff(  ( select distinct ',' + FEE_COLLECT_DATE_FEE_RECEIVED   from CTE   where T2.[VCH ID] = CTE.col1      for xml path('')     )    , 1     , 1 , ''),
T2.Amount,T2.[COA Account],T2.[COA Account Name] , CAST(0 as bit) as [Transfer] 
from @tbl T2 order by T2.[Received Date]





select c1.COA_UID,c1.COA_Name from TBL_COA c1 where c1.CMP_ID = @HD_ID and c1.BRC_ID = @BR_ID and c1.COA_isDeleted = 0 and c1.COA_PARENTID in (select c2.COA_UID from TBL_COA c2 where c2.CMP_ID = @HD_ID and c2.BRC_ID = @BR_ID and c2.COA_isDeleted = 0 and COA_Name ='Cash at Bank')