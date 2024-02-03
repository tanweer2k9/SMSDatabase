CREATE PROC [dbo].[sp_charts_staff_info]

@HD_ID numeric,
@BR_ID numeric


AS



select ID, Name from VDEPARTMENT_INFO where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and [Status] = 'T'
select ID, Name from VDESIGNATION_INFO where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and [Status] = 'T'



select ID, Name from VSCHOOL_PLANE where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and [Status] = 'T'