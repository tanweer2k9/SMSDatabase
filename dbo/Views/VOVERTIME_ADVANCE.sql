﻿CREATE VIEW [dbo].[VOVERTIME_ADVANCE]
AS
SELECT        OVRTM_ADV_ID AS ID, OVRTM_ADV_HD_ID AS [Institute ID], OVRTM_ADV_BR_ID AS [Branch ID], OVRTM_ADV_STAFF_ID AS [Staff ID], 
                         OVRTM_ADV_AMOUNT AS Amount, OVRTM_ADV_DATE AS Date, OVRTM_ADV_ADJUST_AMOUNT AS [Adjust Amount], OVRTM_ADV_ADJUST_DATE AS [Adjust Date], 
                         OVRTM_ADV_STATUS AS Status
FROM            dbo.OVETIME_ADVANCE