﻿CREATE VIEW [dbo].[VDOC_NAME_INFO]
AS
SELECT     DOC_NAME_ID AS ID, DOC_NAME_HD_ID AS [Institute ID], DOC_NAME_BR_ID AS [Branch ID], DOC_NAME_NAME AS Name, DOC_NAME_DESC AS Description, DOC_NAME_STATUS AS Status
FROM         dbo.DOC_NAME_INFO