﻿CREATE VIEW [dbo].[V_MAIN_HD_INFO]
AS
SELECT     dbo.MAIN_HD_INFO.MAIN_INFO_ID, dbo.MAIN_HD_INFO.MAIN_INFO_DATE_FORMAT, dbo.DATE_INFO.DATE_NAME, 
                      dbo.MAIN_HD_INFO.MAIN_INFO_INSTITUTION_LEVEL, dbo.INSTITUTION_LEVEL_INFO.INST_LEVEL_NAME, 
                      dbo.MAIN_HD_INFO.MAIN_INFO_INSTITUTION_FULL_NAME, dbo.MAIN_HD_INFO.MAIN_INFO_INSTITUTION_SHORT_NAME, 
                      dbo.MAIN_HD_INFO.MAIN_INFO_INSTITUTION_LOGO, dbo.MAIN_HD_INFO.MAIN_INFO_BRANCHES, dbo.MAIN_HD_INFO.MAIN_INFO_HEAD_OFFICE, 
                      dbo.MAIN_HD_INFO.MAIN_INFO_SUB_OFFICE, dbo.MAIN_HD_INFO.MAIN_INFO_EMAIL, dbo.MAIN_HD_INFO.MAIN_INFO_MOBILE, 
                      dbo.MAIN_HD_INFO.MAIN_INFO_LAND_LINE, dbo.MAIN_HD_INFO.MAIN_INFO_FAX, dbo.MAIN_HD_INFO.MAIN_INFO_STATUS
FROM         dbo.MAIN_HD_INFO INNER JOIN
                      dbo.DATE_INFO ON dbo.MAIN_HD_INFO.MAIN_INFO_DATE_FORMAT = dbo.DATE_INFO.DATE_ID INNER JOIN
                      dbo.INSTITUTION_LEVEL_INFO ON dbo.MAIN_HD_INFO.MAIN_INFO_INSTITUTION_LEVEL = dbo.INSTITUTION_LEVEL_INFO.INST_LEVEL_ID