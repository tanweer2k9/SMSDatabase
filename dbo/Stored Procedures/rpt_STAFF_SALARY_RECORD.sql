CREATE PROC [dbo].[rpt_STAFF_SALARY_RECORD] 

@HD_ID numeric,
@BR_ID numeric,
@STAFF_ID numeric,
@FROM_DATE date,
@TO_DATE date,
@is_hold bit



AS
--declare @HD_ID numeric = 1
--declare @BR_ID numeric = 1
--declare @STAFF_ID numeric = 0
--declare @FROM_DATE date = '2017-05-01'
--declare @TO_DATE date = '2017-05-30'
--declare @is_hold bit = 1







declare @income_tax_id int = 0
declare @Regularlity_allowance_id int = 0

declare @staff_id_like nvarchar(50)= '%'

if @STAFF_ID != 0
BEGIN
	set @staff_id_like = CAST(@STAFF_ID as nvarchar(50))
END


set @income_tax_id = (select DEDUCTION_ID from DEDUCTION where DEDUCTION_NAME = 'Income Tax' and DEDUCTION_HD_ID = @HD_ID and DEDUCTION_BR_ID = @BR_ID)
set @Regularlity_allowance_id = (select ALLOWANCE_ID from ALLOWANCE where ALLOWANCE_NAME = 'Regularlity Allowance' and ALLOWANCE_HD_ID = @HD_ID and ALLOWANCE_BR_ID = @BR_ID)


set @Regularlity_allowance_id = ISNULL(@Regularlity_allowance_id,0)
set @income_tax_id = ISNULL(@income_tax_id,0)


select ROW_NUMBER() over(order by [Department Rank],[Staff Rank],CAST([Emp Code] as int),[Month Date]) as [S.No],[Emp Code],--A.[Staff ID],
[Salary Month],([Staff First Name] + ' ' + [Staff Last Name]) as Name, Designation, Department,CAST([Month Salary] as float) Salary, [Department ID],
[Joining Date],[Confirmation Date],



CASE WHEN @is_hold = 0
THEN CASE WHEN h.DAYS is NULL THEN (30 - [Deduct Days]) ELSE 0 END ELSE h.DAYS END [Days Worked], 

CASE WHEN @is_hold = 0
THEN CASE WHEN h.DAYS is NULL THEN (30 - [Deduct Days]) ELSE 0 END ELSE h.DAYS END * [Per Day Salary] as [Worked Days Pay],

CASE WHEN h.DAYS is NULL THEN ISNULL((select SUM(ISNULL(Amount,0)) from VSTAFF_SALLERY_DEFF where PID = A.ID and [Amount Type] ='E' and [Deff ID] = @Regularlity_allowance_id),0) ELSE 0 END as [Regularity Allowance], 

CASE WHEN h.DAYS is NULL THEN ISNULL((select SUM(ISNULL(Amount,0)) from VSTAFF_SALLERY_DEFF where PID = A.ID and [Amount Type] ='E' and [Deff ID] != @Regularlity_allowance_id),0) ELSE 0 END [Other Pay], 

(CASE WHEN @is_hold = 0
THEN CASE WHEN h.DAYS is NULL THEN (30 - [Deduct Days]) ELSE 0 END ELSE h.DAYS END * [Per Day Salary] ) +

 --(CASE WHEN @is_hold = 0 THENOR @is_hold = 1

 (CASE WHEN h.DAYS is NULL  OR @is_hold = 1  THEN (ISNULL((select SUM(Amount) from VSTAFF_SALLERY_DEFF where PID = A.ID and [Amount Type] ='E'),0)) ELSE 0 END ) 

--ELSE 0 END )
[Gross Pay],


CASE WHEN h.DAYS is NULL  OR @is_hold = 1  THEN ((ISNULL((select SUM(Amount) from VSTAFF_SALLERY_DEFF where PID = A.ID and [Amount Type] in ('D') and [Deff ID] != @income_tax_id ),0)) + (ISNULL((select SUM(Amount) from VSTAFF_SALLERY_DEFF where PID = A.ID and [Amount Type] in ('L') ),0))) ELSE 0 END  as [Other Deduction],

CASE WHEN h.DAYS is NULL  OR @is_hold = 1 THEN ISNULL((select SUM(Amount) from VSTAFF_SALLERY_DEFF where PID = A.ID and [Amount Type] in ('D') and [Deff ID] = @income_tax_id),0) ELSE 0 END as [Income Tax], 

CASE WHEN @is_hold = 0
THEN CASE WHEN h.DAYS is NULL THEN [Net Total] ELSE 0 END ELSE [Net Total] - ((30 - h.DAYS) * [Per Day Salary]) END as [Net Pay],

' ' as Remarks,
 ('Salary for the month of ' + [Salary Month]) as [Salary Month Year]
 
 from VSTAFF_SALLERY A 
 left join (select val, CAST(1 as bit) Hold from dbo.split((select s.EMPLOYEE_IDS from SALARY_HOLD s where  s.EMPLOYEE_IDS != '' and  s.HD_ID = @HD_ID
and s.BR_ID in ( select * from [dbo].[get_centralized_br_id]('S', @BR_ID)) and DATEPART(MM,[DATE]) = DATEPART(MM,@FROM_DATE) and DATEPART(YYYY,[DATE]) = DATEPART(YYYY,@FROM_DATE) ) ,',') where val != '' ) sp on CAST(sp.val as numeric) = A.[Staff ID]  
left join SALARY_HOLD_DAYS h on h.STAFF_ID = A.[Staff ID] and  DATEPART(MM,h.[DATE]) = DATEPART(MM,@FROM_DATE) and DATEPART(YYYY,h.[DATE]) = DATEPART(YYYY,@FROM_DATE)

 
 where [Month Date] between @FROM_DATE and @TO_DATE and [Institute ID] = @HD_ID
 and [Branch ID] = @BR_ID and [Staff ID] like @staff_id_like 
 and CASE WHEN @is_hold = 1 THEN  h.IS_PAID ELSE  0 END = 0

 order by  [Department Rank]