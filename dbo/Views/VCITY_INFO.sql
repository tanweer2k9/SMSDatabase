﻿CREATE VIEW [dbo].[VCITY_INFO]
AS
SELECT        CITY_ID AS ID, CITY_HD_ID AS [Institute ID], CITY_BR_ID AS [Branch ID], CITY_NAME AS Name, CITY_DESC AS Description, CITY_STATUS AS Status
FROM            dbo.CITY_INFO