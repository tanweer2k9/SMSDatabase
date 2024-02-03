
CREATE PROC [dbo].[rpt_Supplemenetary_Bills]


@HD_ID numeric,
@BR_ID numeric

AS

select [Std ID],[First Name],[Last Name],Class,[Father Name],[Bank Name],[Bank Acct Title],[Bank Acct no],[School ID],[Parent Cell],[Student Cell],[Parent Address],[Family Code],[Parent ID], 
--dbo.get_month_name((select FEE_COLLECT_FEE_FROM_DATE from FEE_COLLECT where FEE_COLLECT_ID = Min([Fee Collect ID])),(select FEE_COLLECT_FEE_TO_DATE from FEE_COLLECT where FEE_COLLECT_ID = Max([Fee Collect ID])))
 'Dec.-Feb. 2017'
 As [Month Name] ,MIN([Challan No]) as [Challan No],Notes,[Due Date],[HD ID],[BR ID],[Class ID] from rpt_VSupplementary_Bills s
where s.[HD ID] = @HD_ID and s.[BR ID] = @BR_ID 
group by [Std ID],[First Name],[Last Name],Class,[Father Name],[Bank Name],[Bank Acct Title],[Bank Acct no],[School ID],[Parent Cell],[Student Cell],[Parent Address],[Family Code],[Parent ID],[Month Name],Notes,[Due Date],[HD ID],[BR ID],[Class ID]
order by s.[Class ID], CAST(s.[School ID] as int)