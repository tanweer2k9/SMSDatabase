﻿CREATE VIEW [dbo].[V_STUDY_CRITERIA_INFO]
AS
SELECT     STUDY_CRITERIA_ID AS ID, STUDY_CRITERIA_HD_ID AS [Institution ID], STUDY_CRITERIA_BR_ID AS [Branch ID], STUDY_CRITERIA_NAME AS Name, 
                      STUDY_CRITERIA_LENGTH AS Length, STUDY_CRITERIA_FORMAT AS Format, STUDY_CRITERIA_STATUS AS Status
FROM         dbo.STUDY_CRITERIA_INFO