﻿



CREATE FUNCTION [dbo].[tf_Get_Early_Departure](@STAFF_ID numeric, @early_minutes int, @FROM_DATE datetime ,@TO_DATE datetime)
returns @tbl table (Dates Date, EarlyType nvarchar(50))

AS
BEGIN

--declare @STAFF_ID numeric = 38, @early_minutes int = 10, @FROM_DATE datetime = '2018-04-01',@TO_DATE datetime= '2018-04-20'

declare @count int = 0
declare @HD_ID numeric = 0
declare @BR_ID numeric = 0

declare @is_vacation_allowed bit = 0


select @HD_ID = TECH_HD_ID, @BR_ID = TECH_BR_ID,@is_vacation_allowed =  TECH_IS_VACATION_ALLOWED from TEACHER_INFO where TECH_ID  = @STAFF_ID


insert into @tbl
select ATTENDANCE_STAFF_DATE, case when ATTENDANCE_STAFF_TIME_OUT = CAST('00:00' as time) THEN 'Missing' ELSE 'Early' END EarlyType from (select ATTENDANCE_STAFF_DATE,ATTENDANCE_STAFF_TYPE_ID,ATTENDANCE_STAFF_TIME_IN,CAST( case when CountATTENDANCE_STAFF_TIME_OUT > 1 AND MinATTENDANCE_STAFF_TIME_OUT = '12:00:00 AM' THEN MaxATTENDANCE_STAFF_TIME_IN ELSE MaxATTENDANCE_STAFF_TIME_OUT END as time) ATTENDANCE_STAFF_TIME_OUT,ATTENDANCE_STAFF_REMARKS, ATTENDANCE_STAFF_CURRENT_TIME_OUT from
(select ATTENDANCE_STAFF_DATE, MIN(CAST(ATTENDANCE_STAFF_TIME_IN as time)) ATTENDANCE_STAFF_TIME_IN, COUNT(ATTENDANCE_STAFF_TIME_OUT) CountATTENDANCE_STAFF_TIME_OUT,  MAX(CAST(ATTENDANCE_STAFF_TIME_OUT as time)) MaxATTENDANCE_STAFF_TIME_OUT,MAX(CAST(ATTENDANCE_STAFF_TIME_IN as time)) MaxATTENDANCE_STAFF_TIME_IN,MAX(ATTENDANCE_STAFF_TYPE_ID)ATTENDANCE_STAFF_TYPE_ID,
--(CAST( case when ATTENDANCE_STAFF_TIME_OUT = '12:00:00 AM' THEN ATTENDANCE_STAFF_TIME_IN ELSE ATTENDANCE_STAFF_TIME_OUT END as time)) ATTENDANCE_STAFF_TIME_OUT, 
Min(CAST(ATTENDANCE_STAFF_TIME_OUT as time)) MinATTENDANCE_STAFF_TIME_OUT,MIN(ATTENDANCE_STAFF_REMARKS) ATTENDANCE_STAFF_REMARKS,MAX(CAST(ATTENDANCE_STAFF_CURRENT_TIME_OUT as time)) ATTENDANCE_STAFF_CURRENT_TIME_OUT from (

select ATTENDANCE_STAFF_DATE, ATTENDANCE_STAFF_TIME_IN,ATTENDANCE_STAFF_TIME_OUT,ATTENDANCE_STAFF_REMARKS,ATTENDANCE_STAFF_CURRENT_TIME_IN,ATTENDANCE_STAFF_CURRENT_TIME_OUT,ATTENDANCE_STAFF_TYPE_ID from ATTENDANCE_STAFF a
join (select * from dbo.tf_Get_All_Working_Days(@STAFF_ID,@early_minutes,@FROM_DATE,@TO_DATE,@HD_ID,@BR_ID,@is_vacation_allowed))w on w.Dates = a.ATTENDANCE_STAFF_DATE and a.ATTENDANCE_STAFF_TYPE_ID = @STAFF_ID and a.ATTENDANCE_STAFF_DATE between @FROM_DATE and @TO_DATE
 
 where ATTENDANCE_STAFF_REMARKS not in ('LE', 'A') and
not exists
(
select SHORT_LEAVE_DATE from SHORT_LEAVE s where 
ATTENDANCE_STAFF_TIME_OUT >= DATEADD(MINUTE,-5,CAST(s.SHORT_LEAVE_FROM_TIME as time))
and s.SHORT_LEAVE_STAFF_ID = ATTENDANCE_STAFF_TYPE_ID and ATTENDANCE_STAFF_DATE = s.SHORT_LEAVE_DATE

)

--union

----THis is necessary because all days are excluded that are not working days so that's why this union is necessary
--select 1,at.ATTENDANCE_STAFF_REMARKS,at.ATTENDANCE_STAFF_DATE,at.ATTENDANCE_STAFF_TIME_IN,at.ATTENDANCE_STAFF_TYPE_ID,at.ATTENDANCE_STAFF_TIME_OUT from ATTENDANCE_STAFF at 
--join EXTRA_HOLIDAYS eh on eh.DATE = at.ATTENDANCE_STAFF_DATE and eh.STAFF_ID = at.ATTENDANCE_STAFF_TYPE_ID  where eh.DATE between @FROM_DATE and @TO_Date and eh.STAFF_ID = @STAFF_ID 

)A 
group by ATTENDANCE_STAFF_DATE 

)B)C where  DATEADD(Mi, @early_minutes,CONVERT(datetime, ATTENDANCE_STAFF_TIME_OUT)) <  CONVERT(datetime, ATTENDANCE_STAFF_CURRENT_TIME_OUT) 


return
END