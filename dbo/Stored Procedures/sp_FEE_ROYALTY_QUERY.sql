CREATE PROC [dbo].[sp_FEE_ROYALTY_QUERY]


 @STATUS char(1),
 @USER_BR_ID numeric,
 @BR_ID numeric,
 @CLASS_ID numeric,
 @FROM_DATE date,
 @TO_DATE date


AS


--declare @USER_BR_ID numeric
--declare @BR_ID numeric
--declare @CLASS_ID numeric
--declare @FROM_DATE date
--declare @TO_DATE date

declare @count int = 0
Declare @calculate_royalty_br int = 0
declare @class nvarchar(50) = '%'


select BR_ADM_ID ID, BR_ADM_NAME Name  from BR_ADMIN where BR_ADM_ROYALTY_TO_BRANCH = @USER_BR_ID



set @count = (select COUNT(*) from BR_ADMIN where BR_ADM_ROYALTY_TO_BRANCH = @USER_BR_ID)

if @count != 0 and @BR_ID = 0
BEGIN
	set @BR_ID = (select top(1) BR_ADM_ID from BR_ADMIN where BR_ADM_ROYALTY_TO_BRANCH = @USER_BR_ID)
END

if @CLASS_ID != 0
BEGIN
	set @class = CAST(@CLASS_ID as nvarchar(50))
END


IF @BR_ID = 0
BEGIN
	set @calculate_royalty_br = CAST(@USER_BR_ID as int)
END
ELSE
BEGIN
	set @calculate_royalty_br = CAST(@BR_ID as int) 
END


select CLASS_ID ID, CLASS_Name Name from SCHOOL_PLANE where CLASS_BR_ID = @calculate_royalty_br


select ROW_NUMBER() OVER(order by OrderSchoolID) as Sr, [Invoice ID],[Std ID],[School ID],[Std Name],[F. Code],Class,[Month Name],[Total Fee],[Total Fee Paid],[Royalty Fee Due],[Royalty Fee Paid],([Royalty Fee Due] -[Royalty Fee Paid]) as Remaining  from 
(
select s.STDNT_ID [Std ID], f.FEE_COLLECT_ID [Invoice ID],s.STDNT_SCHOOL_ID [School ID],CAST(s.STDNT_SCHOOL_ID as int) OrderSchoolID, s.STDNT_FIRST_NAME [Std Name],p.PARNT_FAMILY_CODE [F. Code],  
sp.CLASS_Name Class, [dbo].[get_month_name] (f.FEE_COLLECT_FEE_FROM_DATE,f.FEE_COLLECT_FEE_TO_DATE) as [Month Name], CASE WHEN f.FEE_COLLECT_FEE_STATUS = 'Partially Transfered' THEN FEE_COLLECT_FEE_PAID + FEE_COLLECT_ARREARS_RECEIVED ELSE FEE_COLLECT_FEE + FEE_COLLECT_ARREARS END as [Total Fee], f.FEE_COLLECT_FEE_PAID + FEE_COLLECT_ARREARS_RECEIVED [Total Fee Paid],
f.FEE_COLLECT_ROYALTY_FEE [Royalty Fee Due], f.FEE_COLLECT_ROYALTY_PAID [Royalty Fee Paid]
from FEE_COLLECT f
join STUDENT_INFO s on s.STDNT_ID = f.FEE_COLLECT_STD_ID
join PARENT_INFO p on p.PARNT_ID = s.STDNT_PARANT_ID
join SCHOOL_PLANE sp on sp.CLASS_ID = f.FEE_COLLECT_PLAN_ID 

where FEE_COLLECT_ROYALTY_FEE > 0 and FEE_COLLECT_BR_ID = @calculate_royalty_br and FEE_COLLECT_FEE_FROM_DATE between @FROM_DATE and @TO_DATE 
and f.FEE_COLLECT_PLAN_ID like @class --and f.FEE_COLLECT_FEE_STATUS != 'Fully Transfered'
)A



select ROW_NUMBER() OVER(order by FEE_COLLECT_DEF_FEE_NAME) as Sr, fd.FEE_COLLECT_DEF_PID PID, fi.FEE_NAME [Fee Name],
CASE WHEN f.FEE_COLLECT_FEE_STATUS = 'Partially Transfered' THEN fd.FEE_COLLECT_DEF_FEE_PAID + fd.FEE_COLLECT_DEF_ARREARS_RECEIVED ELSE FEE_COLLECT_DEF_FEE	+ fd.FEE_COLLECT_DEF_ARREARS END as [Fee],
fd.FEE_COLLECT_DEF_FEE_PAID + fd.FEE_COLLECT_DEF_ARREARS_RECEIVED [Paid], 

CASE WHEN f.FEE_COLLECT_FEE_STATUS = 'Partially Transfered' THEN (fd.FEE_COLLECT_DEF_ROYALTY * 100 / (fd.FEE_COLLECT_DEF_FEE)) ELSE (fd.FEE_COLLECT_DEF_ROYALTY * 100 / (fd.FEE_COLLECT_DEF_FEE + fd.FEE_COLLECT_DEF_ARREARS))	 END as [Percent],

fd.FEE_COLLECT_DEF_ROYALTY [Royality Due],fd.FEE_COLLECT_DEF_ROYALTY_PAID [Royality Paid]
  from FEE_COLLECT_DEF fd
join FEE_INFO fi on fi.FEE_ID = fd.FEE_COLLECT_DEF_FEE_NAME
join FEE_COLLECT f on fd.FEE_COLLECT_DEF_PID = f.FEE_COLLECT_ID

where f.FEE_COLLECT_ROYALTY_FEE > 0 and fd.FEE_COLLECT_DEF_ROYALTY > 0 and f.FEE_COLLECT_BR_ID = @calculate_royalty_br and f.FEE_COLLECT_FEE_FROM_DATE between @FROM_DATE and @TO_DATE 
and f.FEE_COLLECT_PLAN_ID like @class and f.FEE_COLLECT_FEE_STATUS != 'Fully Transfered'