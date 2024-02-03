
CREATE PROC [dbo].[sp_EXAM_FITLERS]

@CLASS_ID numeric,
@HD_ID numeric, 
@BR_ID numeric,
@STATUS char(1),
@SessionId numeric


AS

declare @one int = 1

if @CLASS_ID = 0
BEGIN
	set @CLASS_ID = ( select top(@one)ID from VSCHOOL_PLANE where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and Status = 'T' and [Session Id] = @SessionId and Level != 1)
END
else
BEGIN
	set @SessionId = ( select top(@one)[Session Id] from VSCHOOL_PLANE where ID = @CLASS_ID)
END

select * from dbo.tf_GetExamTerms(@CLASS_ID, @HD_ID,@BR_ID,@SessionId) order by [Rank]
select * from VSTUDENT_INFO where [Class ID] = @CLASS_ID and [Status] = 'T' and SessionId = @SessionId
select ID, Name from VSCHOOL_PLANE where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and Status = 'T' and [Session Id] = @SessionId 
and Level != 1
order BY [Order]