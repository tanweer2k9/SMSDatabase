﻿CREATE VIEW [dbo].[VSESSION_INFO]
AS
SELECT        SESSION_ID AS ID, SESSION_HD_ID AS [Institute ID], SESSION_BR_ID AS [Branch ID], SESSION_DESC AS Description, SESSION_START_DATE AS [Start Date], 
                         SESSION_END_DATE AS [End Date], SESSION_RANK AS Rank, SESSION_STATUS AS Status
FROM            dbo.SESSION_INFO