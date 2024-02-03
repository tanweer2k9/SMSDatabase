
CREATE PROC [dbo].[rpt_ExtraFeeBillParent]

@BR_ID numeric

AS

--declare @BR_ID numeric

select 

(ID),[Institute ID],[Branch ID],[Branch Name],[First Name],[Last Name],r.Class,Section,[Std ID],[Date],[Installment Name][Month],0 Arrears,Notes,STD_FEE_NOTES_STATUS,[Status],[Father Name],[Class ID],[Bank Name],[Bank Acct Title],[Bank Acct no] ,'July  10, 2019' [Due Date], [School ID], [Parent Cell] [Cell] , 0 as [Advance Fee], 'Std #' as [Mobile No Inovice],[Start Date],[Attendance From Date],[Attendance To Date],[Parent Address],[Family Code],'1. Late Fee Rs. ' + CAST([Late Fee Fine] as nvarchar(50)) + ' Per Day' as instruction,[Late Fee Fine],0 as [Amount Not Cleared], '3. Reprinting charges of Challan Form is Rs.' + CAST([Reprinting Charges] as nvarchar(50)) as [Reprinting Instruction],CASE WHEN [School ID] = '' THEN 50000 ELSE  CONVERT(numeric(18,0),[School ID]) END as [Sch ID],[Logo Reports], ROUND([Remaining Tax],0) + ROUND(r.[2#5 Months Fees],0) [Net Total],ClassOrder,ISNULL(BankDetail1,'') BankDetail1,ISNULL(BankDetail2,'') BankDetail2 ,ISNULL(CareOfTitle,'') CareOfTitle, dbo.fn_Get_Bill_No( [Start Date],[End Date],[School ID]) BillNo,REPLACE(REPLACE(SchoolCopyInstruction,'##reprinting##', CAST([Reprinting Charges] as nvarchar(50))),'##latefeefine##',CAST([Late Fee Fine] as nvarchar(50))) SchoolCopyInstruction,REPLACE(REPLACE(ParentCopyInstruction,'##reprinting##', CAST([Reprinting Charges] as nvarchar(50))),'##latefeefine##',CAST([Late Fee Fine] as nvarchar(50))) ParentCopyInstruction 

from  RecoveryFees r
left join rpt_V_FEE_SLIP f on r.StdId = f.[Std ID] and [Start Date] between '2019-05-01' and '2019-05-31'
--left join STUDENT_INFO s on s.STDNT_ID = r.stdid and STDNT_STATUS = 'T'
 --and s.STDNT_BR_ID  =2
 
 where r.[Class] in (select CLASS_Name from SCHOOL_PLANE where CLASS_BR_ID = 2 and CLASS_SESSION_START_DATE = '2018-08-01' )
 and [Std #] in (217147)

 --and CLASS_LEVEL_ID = 1
 
 --and [Std #] = '219028'