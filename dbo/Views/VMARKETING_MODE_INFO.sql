﻿CREATE VIEW [dbo].[VMARKETING_MODE_INFO]
AS
SELECT        MODE_ID AS ID, MODE_HD_ID AS [Institute ID], MODE_BR_ID AS [Branch ID], MODE_NAME AS Name, MODE_DESCRIPTION AS Description, 
                         MODE_STATUS AS Status
FROM            dbo.MARKETING_MODE_INFO