﻿CREATE VIEW [dbo].[VCHART_SETTING]
AS
SELECT     CHART_ID AS ID, CHART_NAME AS Name, CHART_WIDTH AS Width, CHART_HEIGHT AS Height, CHART_LOGIN_ID AS [Login ID], CHART_STATUS AS Status
FROM         dbo.CHART_SETTING