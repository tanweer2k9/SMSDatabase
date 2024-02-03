CREATE Procedure [dbo].[sp_bdaynotify]


@STATUS char,
@HD_ID numeric,
@BR_ID numeric,
@START_DATE date,
@END_DATE date,
@SCREEN_NAME nvarchar(50)

as 

declare @day int=0,
@today date=getdate(),
@br_id_txt nvarchar(50) = '%'
declare @count_template int = 0
if @Status= 'A'

begin


if @BR_ID!=0
set @br_id_txt=cast((@BR_ID)as nvarchar(50))

		set @day= (select SMS_NOTIFICATION_EVENT_DAYS from SMS_NOTIFICATION_SETTINGS where SMS_NOTIFICATION_HD_ID=@HD_ID 
			and SMS_NOTIFICATION_NAME=@SCREEN_NAME AND SMS_NOTIFICATION_BR_ID=@BR_ID)

			select STDNT_ID  as ID,STDNT_SCHOOL_ID as [School ID] ,STDNT_FIRST_NAME + ' ' + STDNT_LAST_NAME as Name,
			STUDENT_ROLL_NUM_ROLL_NO as [Roll No],PARENT_INFO.PARNT_FIRST_NAME as [Guardian Name] ,CLASS_Name as [Class Name] ,
			'Student' as [Type],STDNT_DOB as DOB,STDNT_CELL_NO as Cell,PARENT_INFO.PARNT_CELL_NO as [Guardian Cell] 
			from (select *,Case when DATEPART(YYYY,dateadd(dd,-@day,STDNT_DOB)) = DATEPART(YYYY,STDNT_DOB)
			then (DATEADD(YYYY, DATEDIFF(yyyy,STDNT_DOB, @today),STDNT_DOB)) 
			else ((DATEADD(YYYY, DATEDIFF(yyyy,STDNT_DOB, @today) + 1,STDNT_DOB)))END as new_dob  
			from STUDENT_INFO)new 
			join PARENT_INFO on STDNT_PARANT_ID=PARENT_INFO.PARNT_ID
			join STUDENT_ROLL_NUM on STDNT_ID = STUDENT_ROLL_NUM.STUDENT_ROLL_NUM_STD_ID
			join SCHOOL_PLANE on STDNT_CLASS_PLANE_ID=SCHOOL_PLANE.CLASS_ID
			where new_dob between @today and dateadd(DD,@day,@today)
			AND STDNT_STATUS='T'
			and STDNT_HD_ID=@HD_ID
			and STDNT_BR_ID like @br_id_txt
			order by new_dob

end


else if @Status= 'B'

begin


if @BR_ID!=0
set @br_id_txt=cast((@BR_ID)as nvarchar(50))

set @day= (select SMS_NOTIFICATION_EVENT_DAYS from SMS_NOTIFICATION_SETTINGS where SMS_NOTIFICATION_HD_ID = @HD_ID and SMS_NOTIFICATION_BR_ID = @BR_ID)

select STDNT_ID  as ID,STDNT_SCHOOL_ID as [School ID] ,STDNT_FIRST_NAME + ' ' + STDNT_LAST_NAME as Name,
STUDENT_ROLL_NUM_ROLL_NO as [Roll No],PARENT_INFO.PARNT_FIRST_NAME as [Guardian Name] ,CLASS_Name as [Class Name] ,
'Student' as [Type],STDNT_DOB as DOB,STDNT_CELL_NO as Cell,PARENT_INFO.PARNT_CELL_NO as [Guardian Cell] 
from (select *,Case when DATEPART(YYYY,dateadd(dd,-@day,STDNT_DOB)) = DATEPART(YYYY,STDNT_DOB)
then (DATEADD(YYYY, DATEDIFF(yyyy,STDNT_DOB, @today),STDNT_DOB)) 
else ((DATEADD(YYYY, DATEDIFF(yyyy,STDNT_DOB, @today) + 1,STDNT_DOB)))END as new_dob  
from STUDENT_INFO)new 
join PARENT_INFO on STDNT_PARANT_ID=PARENT_INFO.PARNT_ID
join STUDENT_ROLL_NUM on STDNT_ID = STUDENT_ROLL_NUM.STUDENT_ROLL_NUM_STD_ID
join SCHOOL_PLANE on STDNT_CLASS_PLANE_ID=SCHOOL_PLANE.CLASS_ID
where new_dob between @START_DATE and @END_DATE
AND STDNT_STATUS='T'
and STDNT_HD_ID=@HD_ID
and STDNT_BR_ID = @BR_ID
order by new_dob


end
select @day
EXEC sp_NOTIFICATION_SMS_TEMPLATE @SCREEN_NAME , @HD_ID,@BR_ID