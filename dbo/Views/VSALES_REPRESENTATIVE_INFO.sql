﻿CREATE VIEW [dbo].[VSALES_REPRESENTATIVE_INFO]
AS
SELECT        SALES_ID AS ID, SALES_HD_ID AS [Institute ID], SALES_BR_ID AS [Branch ID], SALES_NAME AS Name, SALES_DESCRIPTION AS Description, 
                         SALES_STATUS AS Status
FROM            dbo.SALES_REPRESENTATIVE_INFO