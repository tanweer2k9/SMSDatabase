

CREATE PROC [dbo].[rpt_BANK_SALARY_TRANSFER]

@HD_ID numeric ,
@BR_ID numeric ,
@DATE date,
@BANK_ID numeric,
@ACCOUNT_NO_STATUS int

AS


--declare @HD_ID numeric = 1
--declare @BR_ID numeric = 1
--declare @DATE date = '2015-08-01'
--declare @BANK_ID numeric = 2,


if @ACCOUNT_NO_STATUS = 0 --if @ACCOUNT_NO_STATUS is zero means With account No
BEGIN
	select ROW_NUMBER() over(order by  MAX([Department Rank]),CAST(MAX([Emp Code]) as int) ) as [S.No],  MAX(Name) Name,[Account#], SUM(Amount) Amount, MAX([Salary Days])[Salary Days],MAX(Salary) Salary  from
(
select  [Department Rank],[Emp Code],([Staff First Name] + ' ' + [Staff Last Name]) as Name,Account#,A.Salary,A.[Salary Month],
	
	CASE WHEN h.DAYS is NULL  THEN[Net Total] ELSE 0 END Amount, 
	CASE WHEN h.DAYS is NULL  THEN([Working Days] - [Deduct Days]) ELSE 0 END
	 as [Salary Days]
	 from VSTAFF_SALLERY A
	 
	  left join (select val, CAST(1 as bit) Hold from dbo.split((select s.EMPLOYEE_IDS from SALARY_HOLD s where  s.EMPLOYEE_IDS != '' and  s.HD_ID = @HD_ID
and s.BR_ID in (select COMBINE_BRANCHES_ID from COMBINE_BRANCHES where FROM_BRANCH_ID = @BR_ID)  and DATEPART(MM,[DATE]) = DATEPART(MM,@DATE) and DATEPART(YYYY,[DATE]) = DATEPART(YYYY,@DATE) ) ,',') where val != '' ) sp on CAST(sp.val as numeric) = A.[Staff ID]  
left join SALARY_HOLD_DAYS h on h.STAFF_ID = A.[Staff ID] and  DATEPART(MM,h.[DATE]) = DATEPART(MM,@DATE) and DATEPART(YYYY,h.[DATE]) = DATEPART(YYYY,@DATE)

	 
	 where DATEPART(MM,[Month Date]) =DATEPART(MM,@DATE) and DATEPART(YYYY,[Month Date]) =DATEPART(YYYY,@DATE) and [Institute ID] = @HD_ID
	 and [Branch ID] in (select COMBINE_BRANCHES_ID from COMBINE_BRANCHES where FROM_BRANCH_ID = @BR_ID) and [Bank Name] = (select BANK_NAME from BANK_INFO where BANK_ID = @BANK_ID) and Account# != '' and [Account Title] != '' and  A.ID not in (select STAFF_SALLERY_DEFF_PID from STAFF_SALLERY_DEFF where STAFF_SALLERY_DEFF_AMOUNT_TYPE = 'D' and STAFF_SALLERY_DEFF_AMOUNT > 0 and STAFF_SALLERY_DEFF_NAME in (select DEDUCTION_ID  from DEDUCTION where DEDUCTION_NAME = 'July Salary' and DEDUCTION_BR_ID in (select COMBINE_BRANCHES_ID from COMBINE_BRANCHES where FROM_BRANCH_ID = @BR_ID)  and DEDUCTION_STATUS = 'T'))
)B where Amount >0 group by [Account#]
END
ELSE if @ACCOUNT_NO_STATUS = 1--if @ACCOUNT_NO_STATUS is 1 means Without account No
BEGIN
	select ROW_NUMBER() over(order by [Branch ID], [Department Rank],CAST([Emp Code] as int)) as [S.No], ([Staff First Name] + ' ' + [Staff Last Name]) as Name,Account#,[Net Total] As Amount, ([Working Days] - [Deduct Days]) as [Salary Days],Salary
	 from VSTAFF_SALLERY where DATEPART(MM,[Month Date]) =DATEPART(MM,@DATE) and DATEPART(YYYY,[Month Date]) =DATEPART(YYYY,@DATE) and [Institute ID] = @HD_ID
	 and [Branch ID] in (select COMBINE_BRANCHES_ID from COMBINE_BRANCHES where FROM_BRANCH_ID = @BR_ID)  and (Account# = '' OR [Account Title] = '') and  ID not in (select STAFF_SALLERY_DEFF_PID from STAFF_SALLERY_DEFF where STAFF_SALLERY_DEFF_AMOUNT_TYPE = 'D' and STAFF_SALLERY_DEFF_AMOUNT > 0 and STAFF_SALLERY_DEFF_NAME in (select DEDUCTION_ID  from DEDUCTION where DEDUCTION_NAME = 'July Salary' and DEDUCTION_BR_ID in (select COMBINE_BRANCHES_ID from COMBINE_BRANCHES where FROM_BRANCH_ID = @BR_ID)  and DEDUCTION_STATUS = 'T'))
END
ELSE--if @ACCOUNT_NO_STATUS is 2 means Refundable
BEGIN
	select ROW_NUMBER() over(order by [Department Rank],CAST([Emp Code] as int)) as [S.No], CASE WHEN [Account Title] = '' THEN ([Staff First Name] + ' ' + [Staff Last Name]) ELSE [Account Title] END as Name,Account#,[Net Total] As Amount, ([Working Days] - [Deduct Days]) as [Salary Days]
	 from VSTAFF_SALLERY where ID in (select STAFF_SALLERY_DEFF_PID from STAFF_SALLERY_DEFF where STAFF_SALLERY_DEFF_REFUND = 'T' and STAFF_SALLERY_DEFF_AMOUNT_TYPE = 'D' and STAFF_SALLERY_DEFF_AMOUNT > 0 and STAFF_SALLERY_DEFF_NAME in (select DEDUCTION_ID  from DEDUCTION where DEDUCTION_NAME = 'July Salary' and DEDUCTION_BR_ID in (select COMBINE_BRANCHES_ID from COMBINE_BRANCHES where FROM_BRANCH_ID = @BR_ID)  and DEDUCTION_STATUS = 'T')) and DATEPART(MM,[Month Date]) =DATEPART(MM,@DATE) and DATEPART(YYYY,[Month Date]) =DATEPART(YYYY,@DATE) and [Institute ID] = @HD_ID
	 and [Branch ID] in (select COMBINE_BRANCHES_ID from COMBINE_BRANCHES where FROM_BRANCH_ID = @BR_ID) 
END