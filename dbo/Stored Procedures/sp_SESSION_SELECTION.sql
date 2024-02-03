
CREATE PROCEDURE [dbo].[sp_SESSION_SELECTION]
@HD_ID numeric,
@BR_ID numeric
AS BEGIN


select ID, [Start Date],[End Date] from VSESSION_INFO where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and Status = 'T' order by [Start Date] 

END