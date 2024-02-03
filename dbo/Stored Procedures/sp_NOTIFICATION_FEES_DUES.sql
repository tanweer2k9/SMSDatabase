CREATE Proc [dbo].[sp_NOTIFICATION_FEES_DUES]

@hd_id numeric,
@br_id numeric,
@CLASS_ID numeric,
@SCREEN_NAME nvarchar(100)
As


--declare @br_id numeric = 0
--declare @hd_id numeric = 0
declare @count_template int = 0
declare @class_id_nvarchar nvarchar(50) = '%'
if @CLASS_ID != 0
	set @class_id_nvarchar = CAST((@CLASS_ID) as nvarchar(50))
--select ID,[Institute ID] as [HD ID], [Branch ID] as [BR ID], Name from VSCHOOL_PLANE where Status = 'T'
select ID, Name from VSCHOOL_PLANE where Status = 'T' and [Institute ID] = @hd_id and [Branch ID] = @br_id

;with last_fee_record_parent as
(select *,ROW_NUMBER() over (partition by FEE_COLLECT_STD_ID order by CAST(FEE_COLLECT_DATE_FEE_GENERATED as DATE) DESC) grp 
from FEE_COLLECT where FEE_COLLECT_HD_ID in (select * from dbo.get_all_hd_id(@hd_id) )
and FEE_COLLECT_BR_ID in (select * from dbo.get_all_br_id(@br_id)))
, final_tabl as 
(select *, FEE_COLLECT_FEE + FEE_COLLECT_ARREARS - FEE_COLLECT_FEE_PAID - FEE_COLLECT_ARREARS_RECEIVED as Fee 
from last_fee_record_parent where grp = 1
)

select FEE_COLLECT_STD_ID as ID ,s.STDNT_FIRST_NAME as Name, s.STDNT_CELL_NO as [Student Cell], 
--case when p.PARNT_CELL_NO = '' then p.PARNT_CELL_NO2 else p.PARNT_CELL_NO END as [Parent Cell],
p.PARNT_CELL_NO as [Parent Cell],
c.CLASS_Name as [Class Name],l.Fee, l.FEE_COLLECT_DUE_DAY as [Due Date], 
--case when p.PARNT_CELL_NO = '' then p.PARNT_FIRST_NAME else p.PARNT_FIRST_NAME2 END as [Guardian Name]
p.PARNT_FIRST_NAME as [Guardian Name]
from final_tabl l
join SCHOOL_PLANE c on c.CLASS_ID = l.FEE_COLLECT_PLAN_ID
join STUDENT_INFO s on s.STDNT_ID = l.FEE_COLLECT_STD_ID
join PARENT_INFO p on p.PARNT_ID = s.STDNT_PARANT_ID
where grp = 1 and s.STDNT_STATUS = 'T' and Fee > 0 and l.FEE_COLLECT_PLAN_ID like @class_id_nvarchar

EXEC sp_NOTIFICATION_SMS_TEMPLATE @SCREEN_NAME,@hd_id,@br_id


--set @count_template = (Select count(*)from SMS_TEMPLATE 
--join SMS_SCREEN on SMS_SCREEN.SMS_SCREEN_NAME = @SCREEN_NAME
--and SMS_SCREEN.SMS_SCREEN_ID=SMS_TEMPLATE.SMS_TEMPLATE_SCREEN_ID where SMS_SCREEN_STATUS = 'T')

--if @count_template = 1
--begin
--	Select SMS_TEMPLATE_INSERT_MSG as Msg,SMS_TEMPLATE_ID as ID,SMS_TEMPLATE_SCREEN_ID as [S ID]
--	from SMS_TEMPLATE 
--	join SMS_SCREEN on SMS_SCREEN.SMS_SCREEN_NAME = @SCREEN_NAME
--	and SMS_SCREEN.SMS_SCREEN_ID=SMS_TEMPLATE.SMS_TEMPLATE_SCREEN_ID
--	where SMS_SCREEN_STATUS = 'T'	
--end
--else
--begin
--	set @count_template =  (select COUNT(*) from SMS_SCREEN where SMS_SCREEN_NAME = @SCREEN_NAME and SMS_SCREEN_STATUS = 'T')
--	if @count_template = 1
--	begin
--		select SMS_SCREEN_ID as [S ID] from SMS_SCREEN where SMS_SCREEN_NAME = @SCREEN_NAME and SMS_SCREEN_STATUS = 'T'
--	end	
--	else
--	begin
--		select -1
--	end
--end

--select SUM(FEE_COLLECT_FEE) + SUM(FEE_COLLECT_ARREARS) - SUM(FEE_COLLECT_ARREARS_RECEIVED) - SUM(FEE_COLLECT_FEE_PAID) from last_fee_record_parent where grp = 1