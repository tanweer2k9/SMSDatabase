



CREATE FUNCTION [dbo].[FEE_COLLECT_QUERY_SELECTION_GET_ACCOUNTS] (@BrId numeric)
 returns  @tbl3  table ([Fee Collect ID] numeric, [COA Account] nvarchar(500))


As BEGIN



declare @BR_ID numeric = 0

set @BR_ID = @BrId

declare @tbl table ([Fee Collect ID] numeric, [COA Account] nvarchar(500))

insert into @tbl


select CAST(m.VCH_referenceNo as numeric), c1.COA_Name
from TBL_VCH_MAIN m 
join

(select * from TBL_VCH_DEF d where d.BRC_ID = CAST(@BR_ID as nvarchar(5)) and VCH_DEF_COA in
(select COA_UID from TBL_COA where  COA_isDeleted= 0 and BRC_ID = CAST(@BR_ID as nvarchar(5)) and COA_PARENTID in
(select COA_UID from TBL_COA where COA_Name in ('Cash in Hand','Cash at Bank')) and COA_isDeleted=0 and BRC_ID = CAST(@BR_ID as nvarchar(5)))
)C on m.VCH_MID = C.VCH_MAIN_ID
join TBL_COA c1 on c1.COA_UID = C.VCH_DEF_COA
where m.BRC_ID = CAST(@BR_ID as nvarchar(5)) and m.VCH_prefix = 'FE' 
--and m.VCH_chequeBankName not in ('Transfered From','Transfered To','Multiple Cheques Received','Multiple Cash Received') 
and c1.BRC_ID = CAST(@BR_ID as nvarchar(5)) and c1.COA_isDeleted = 0  and m.VCH_referenceNo not like '%,%'  and VCH_referenceNo != ''
 
--delete from @tbl where [Fee Collect ID] in (select CHEQ_FEE_COLLECT_ID from CHEQ_FEE_INFO) and [Fee Collect ID] not in (select FEE_COLLECT_ID from FEE_COLLECT where FEE_COLLECT_CASH_DEPOSITE > 0)





declare @tbl1 table ([Fee Collect ID] numeric, [COA Account] nvarchar(250))

insert into @tbl1

select f.CHEQ_FEE_COLLECT_ID, co.COA_Name from CHEQUE_INFO c
join CHEQ_FEE_INFO f on f.CHEQ_FEE_CHEQUE_ID = c.CHEQ_ID
join TBL_COA co on co.COA_UID = c.CHEQ_COA_ACCOUNT
where  c.CHEQ_IS_DISHONORED != 1 and co.BRC_ID = CAST(@BR_ID as nvarchar(5)) and co.COA_isDeleted = 0 and   f.CHEQ_FEE_COLLECT_ID in (select FEE_COLLECT_ID from FEE_COLLECT where FEE_COLLECT_BR_ID = @BR_ID)



insert into @tbl
select [Fee Collect ID],STUFF(  
        (  
        SELECT ',' + CAST(t2.[COA Account] as nvarchar(50))  
        FROM @tbl1 t2  
        WHERE t1.[Fee Collect ID] = t2.[Fee Collect ID] 
        FOR XML PATH ('')  
        ),1,1,'')   from @tbl1 t1 group by [Fee Collect ID]




declare @tbl2 table ([Fee Collect ID] nvarchar(500), [COA Account] nvarchar(500))

insert into @tbl2
select 
--CAST(
m.VCH_referenceNo 
--as numeric)
, c1.COA_Name
from TBL_VCH_MAIN m 
join

(select * from TBL_VCH_DEF d where d.BRC_ID = CAST(@BR_ID as nvarchar(5)) and VCH_DEF_COA in
(select COA_UID from TBL_COA where  COA_isDeleted= 0 and BRC_ID = CAST(@BR_ID as nvarchar(5)) and COA_PARENTID in
(select COA_UID from TBL_COA where COA_Name in ('Cash in Hand','Cash at Bank')) and COA_isDeleted=0 and BRC_ID = CAST(@BR_ID as nvarchar(5)))
)C on m.VCH_MID = C.VCH_MAIN_ID
join TBL_COA c1 on c1.COA_UID = C.VCH_DEF_COA
where m.BRC_ID = CAST(@BR_ID as nvarchar(5)) and m.VCH_prefix = 'FE' 
--and m.VCH_chequeBankName in ('Transfered From','Transfered To','Multiple Cheques Received','Multiple Cash Received') 
and c1.BRC_ID = CAST(@BR_ID as nvarchar(5)) and c1.COA_isDeleted = 0  and m.VCH_referenceNo like '%,%'


insert into @tbl
SELECT 
LTRIM(RTRIM(m.n.value('.[1]','varchar(8000)'))) AS Certs,[COA Account]
FROM
(
SELECT [COA Account],CAST('<XMLRoot><RowData>' + REPLACE([Fee Collect ID],',','</RowData><RowData>') + '</RowData></XMLRoot>' AS XML) AS x
FROM   @tbl2
)t
CROSS APPLY x.nodes('/XMLRoot/RowData')m(n)


insert into @tbl3
select [Fee Collect ID],STUFF(  
        (  
        SELECT ',' + CAST(t2.[COA Account] as nvarchar(50))  
        FROM (select distinct [Fee Collect ID], [COA Account] from @tbl) t2  
        WHERE t1.[Fee Collect ID] = t2.[Fee Collect ID] 
        FOR XML PATH ('')  
        ),1,1,'')   from (select distinct [Fee Collect ID], [COA Account] from @tbl) t1 
		
		group by [Fee Collect ID] 


return
END