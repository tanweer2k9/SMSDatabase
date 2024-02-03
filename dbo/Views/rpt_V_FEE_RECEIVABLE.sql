﻿CREATE VIEW [dbo].[rpt_V_FEE_RECEIVABLE]
AS
SELECT     dbo.FEE_COLLECT.FEE_COLLECT_HD_ID AS [Institute ID], dbo.FEE_COLLECT.FEE_COLLECT_BR_ID AS Branch, 
                      dbo.FEE_COLLECT.FEE_COLLECT_PLAN_ID AS [Plan ID], dbo.FEE_COLLECT.FEE_COLLECT_STD_ID AS ID, 
                      dbo.STUDENT_INFO.STDNT_FIRST_NAME AS [First Name], dbo.STUDENT_INFO.STDNT_LAST_NAME AS [Last Name], dbo.CLASS_INFO.CLASS_NAME AS Class, 
                      dbo.SECTION_INFO.SECT_NAME AS Section, dbo.FEE_COLLECT.FEE_COLLECT_FEE AS [Current Fee], 
                      dbo.FEE_COLLECT.FEE_COLLECT_FEE_PAID AS [Fee Received], dbo.FEE_COLLECT.FEE_COLLECT_DATE_FEE_GENERATED AS Date, 
                      dbo.FEE_COLLECT.FEE_COLLECT_FEE_STATUS AS Status, CASE WHEN DATEPART(MM, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(MM, 
                      FEE_COLLECT_FEE_TO_DATE) THEN DATENAME(MONTH, FEE_COLLECT_FEE_FROM_DATE) ELSE DATENAME(MONTH, FEE_COLLECT_FEE_FROM_DATE) 
                      + ' - ' + DATENAME(MONTH, FEE_COLLECT_FEE_TO_DATE) END AS Month, DATENAME(YY, dbo.FEE_COLLECT.FEE_COLLECT_FEE_TO_DATE) AS Year, 
                      dbo.FEE_COLLECT.FEE_COLLECT_ARREARS AS Arrears, dbo.FEE_COLLECT.FEE_COLLECT_ARREARS_RECEIVED AS [Arrears Recieved], 
                      dbo.FEE_COLLECT.FEE_COLLECT_DATE_FEE_RECEIVED AS [Date Received], dbo.FEE_COLLECT.FEE_COLLECT_ID AS [Invoice ID], 
                      dbo.STUDENT_INFO.STDNT_PARANT_ID AS [Parent ID], DATEPART(MM, dbo.FEE_COLLECT.FEE_COLLECT_FEE_TO_DATE) AS [Month int], 
                      dbo.SECTION_INFO.SECT_NAME
FROM         dbo.FEE_COLLECT INNER JOIN
                      dbo.SCHOOL_PLANE ON dbo.FEE_COLLECT.FEE_COLLECT_PLAN_ID = dbo.SCHOOL_PLANE.CLASS_ID INNER JOIN
                      dbo.STUDENT_INFO ON dbo.FEE_COLLECT.FEE_COLLECT_STD_ID = dbo.STUDENT_INFO.STDNT_ID INNER JOIN
                      dbo.CLASS_INFO ON dbo.SCHOOL_PLANE.CLASS_CLASS = dbo.CLASS_INFO.CLASS_ID INNER JOIN
                      dbo.SECTION_INFO ON dbo.SCHOOL_PLANE.CLASS_SECTION = dbo.SECTION_INFO.SECT_ID