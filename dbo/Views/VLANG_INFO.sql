﻿CREATE VIEW [dbo].[VLANG_INFO]
AS
SELECT     LANG_ID AS ID, LANG_HD_ID AS [Institute ID], LANG_BR_ID AS [Branch ID], LANG_NAME AS Name, LANG_DESC AS Description, LANG_STATUS AS Status
FROM         dbo.LANG_INFO