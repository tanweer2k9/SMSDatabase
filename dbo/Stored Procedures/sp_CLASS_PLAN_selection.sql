CREATE PROC dbo.sp_CLASS_PLAN_selection




@HD_ID numeric,
@BR_ID numeric,
@SESSION_ID numeric,
@CLASS_ID numeric out




AS

if @SESSION_ID = -1	
	set @SESSION_ID = (select BR_ADM_SESSION from BR_ADMIN where BR_ADM_ID = @BR_ID)

select ID, Name from VCLASS_PLAN where [HD ID] = @HD_ID and [BR ID] = @BR_ID and [SESSION ID] = @SESSION_ID and [Status] = 'T'


declare @one int = 1

set @CLASS_ID = (select top(@one)ID from VCLASS_PLAN where [HD ID] = @HD_ID and [BR ID] = @BR_ID and [SESSION ID] = @SESSION_ID and [Status] = 'T')