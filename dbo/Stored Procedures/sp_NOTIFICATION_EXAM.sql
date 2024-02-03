CREATE PROC [dbo].[sp_NOTIFICATION_EXAM]

	@CLASS_ID int = 0,
	@SCREEN_NAME nvarchar(100),
	@HD_ID numeric,
	@BR_ID numeric

as

--declare @CLASS_ID int = 0
--declare @SCREEN_NAME nvarchar(100)

declare @class nvarchar(50) = '%'
declare @count_template int = 0
	if @CLASS_ID != 0
	begin
		set @class = CAST((@CLASS_ID) as nvarchar(50))
	end

select s.STDNT_ID as ID, s.STDNT_FIRST_NAME as Name, s.STDNT_CELL_NO as [Student Cell],
case when p.PARNT_CELL_NO = '' then p.PARNT_CELL_NO2 else p.PARNT_CELL_NO END as [Parent Cell],
case when p.PARNT_CELL_NO = '' then p.PARNT_FIRST_NAME else p.PARNT_FIRST_NAME2 END as [Guardian Name]
from STUDENT_INFO s
join PARENT_INFO p on p.PARNT_ID = s.STDNT_PARANT_ID
where s.STDNT_CLASS_PLANE_ID like @class

EXEC sp_NOTIFICATION_SMS_TEMPLATE @SCREEN_NAME,@HD_ID,@BR_ID