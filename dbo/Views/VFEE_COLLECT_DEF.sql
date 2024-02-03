﻿

CREATE VIEW [dbo].[VFEE_COLLECT_DEF]
AS
SELECT        dbo.FEE_COLLECT_DEF.FEE_COLLECT_DEF_ID AS ID, dbo.FEE_INFO.FEE_NAME AS [Fee Name], dbo.FEE_COLLECT_DEF.FEE_COLLECT_DEF_FEE AS [Current Fee], 
                         dbo.FEE_COLLECT_DEF.FEE_COLLECT_DEF_FEE_PAID AS [Fee Received], dbo.FEE_COLLECT_DEF.FEE_COLLECT_DEF_MIN AS [Min Fee Variation %], 
                         dbo.FEE_COLLECT_DEF.FEE_COLLECT_DEF_MAX AS [Max Fee Variation %], dbo.FEE_COLLECT_DEF.FEE_COLLECT_DEF_OPERATION AS Operation, 
                         dbo.FEE_COLLECT_DEF.FEE_COLLECT_DEF_ARREARS AS Arrears, dbo.FEE_COLLECT_DEF.FEE_COLLECT_DEF_ARREARS_RECEIVED AS [Arrears Received], 
                         dbo.FEE_COLLECT_DEF.FEE_COLLECT_DEF_TOTAL AS [Total Fee], 
                         dbo.FEE_COLLECT_DEF.FEE_COLLECT_DEF_TOTAL - dbo.FEE_COLLECT_DEF.FEE_COLLECT_DEF_ARREARS_RECEIVED - dbo.FEE_COLLECT_DEF.FEE_COLLECT_DEF_FEE_PAID AS Recievable, 
                         dbo.FEE_COLLECT_DEF.FEE_COLLECT_DEF_FEE_PAID + dbo.FEE_COLLECT_DEF.FEE_COLLECT_DEF_ARREARS_RECEIVED AS Recieved, dbo.FEE_COLLECT_DEF.FEE_COLLECT_DEF_PID AS [Invoice ID], 
                         dbo.FEE_COLLECT_DEF.FEE_COLLECT_DEF_FEE_NAME AS [Fee ID]
FROM            dbo.FEE_COLLECT_DEF INNER JOIN
                         dbo.FEE_INFO ON dbo.FEE_COLLECT_DEF.FEE_COLLECT_DEF_FEE_NAME = dbo.FEE_INFO.FEE_ID