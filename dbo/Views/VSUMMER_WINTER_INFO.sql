CREATE VIEW [dbo].[VSUMMER_WINTER_INFO]
AS
SELECT        SUM_WIN_ID AS ID, SUM_WIN_SESSION_ID AS [Session ID], SUM_WIN_HD_ID AS [Institute ID], SUM_WIN_BR_ID AS [Branch ID], SUM_WIN_SUMMER_START_DATE AS [Summer Start Date], 
                         SUM_WIN_SUMMER_END_DATE AS [Summer End Date], SUM_WIN_WINTER_START_DATE AS [Winter Start Date], SUM_WIN_WINTER_END_DATE AS [Winter End Date], 
                         SUM_WIN_SEMESTER1_START_DATE AS [Semester1 Start Date], SUM_WIN_SEMESTER1_END_DATE AS [Semester1 End Date], SUM_WIN_SEMESTER2_START_DATE AS [Semester2 Start Date], 
                         SUM_WIN_SEMESTER2_END_DATE AS [Semester2 End Date]
FROM            dbo.SUMMER_WINTER_INFO