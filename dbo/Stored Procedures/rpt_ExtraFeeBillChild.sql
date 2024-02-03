

CREATE PROC [dbo].[rpt_ExtraFeeBillChild]

@BR_ID numeric

AS

select CAST(ISNULL(StdId,0) as numeric) StdId,ISNULL([Std #],'')[Std #], IIF(FeeHead ='Actual Fee P#M', 'Monthly fee in September 2018', IIF(FeeHead ='After 20% Less Fee P#M', 'Monthly fee after 20% discount', IIF(FeeHead ='Difference', 'Monthly difference payable from Date of judgment (12-06-2019)', IIF(FeeHead ='2#5 Months Fees', 'Payable from (June 12 to Aug. 31, 2019)', IIF(FeeHead ='Remaining Tax', 'Adv. tax (236 i)', ''))))) FeeHead, ROUND(Fee,0) Fee, IIF(FeeHead ='Actual Fee P#M', 1, IIF(FeeHead ='After 20% Less Fee P#M', 2, IIF(FeeHead ='Difference', 3, IIF(FeeHead ='2#5 Months Fees', 4, IIF(FeeHead ='Remaining Tax', 5, 0))))) as FeeHeadOrder from (select StdId, [Std #], [Actual Fee P#M], [After 20% Less Fee P#M],[Difference], r.[2#5 Months Fees], r.[Remaining Tax] from  RecoveryFees r) p

unpivot (Fee FOr FeeHead in ([2#5 Months Fees], [Remaining Tax])) as unpvt

order by StdId, FeeHeadOrder