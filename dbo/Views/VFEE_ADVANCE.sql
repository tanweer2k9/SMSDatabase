﻿CREATE VIEW [dbo].[VFEE_ADVANCE]
AS
SELECT     ADV_FEE_ID AS ID, ADV_FEE_STD_ID AS [Std ID], ADV_FEE_FROM_DATE AS [From Date], ADV_FEE_TO_DATE AS [To Date], ADV_FEE_DATE AS [Fee Date], 
                      ADV_FEE_AMOUNT AS Amount, ADV_FEE_STATUS AS Status
FROM         dbo.FEE_ADVANCE