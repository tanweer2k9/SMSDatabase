﻿CREATE VIEW [dbo].[VEXPENCE_INFO]
AS
SELECT     EXPENCE_ID AS ID, EXPENCE_HD_ID AS [Institute ID], EXPENCE_BR_ID AS [Branch ID], EXPENCE_NAME AS Name, EXPENCE_DESC AS Description, 
                      EXPENCE_STATUS AS Status
FROM         dbo.EXPENCE_INFO