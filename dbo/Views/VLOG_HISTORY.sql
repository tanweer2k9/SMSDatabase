CREATE VIEW [dbo].[VLOG_HISTORY]
AS
SELECT     dbo.LOG_HISTORY.LOG_ID AS ID, dbo.LOG_HISTORY.LOG_HD_ID AS [Institute ID], dbo.LOG_HISTORY.LOG_BR_ID AS [Branch ID], 
                      dbo.LOG_HISTORY.LOG_EVENT_NAME AS [Event Name], dbo.LOG_HISTORY.LOG_TIME AS [Date Time], dbo.USER_INFO.USER_DISPLAY_NAME AS [User Name], 
                      dbo.LOG_HISTORY.LOG_PAGE AS [Screen Name], dbo.LOG_HISTORY.LOG_DESC AS [IP Address]
FROM         dbo.LOG_HISTORY INNER JOIN
                      dbo.USER_INFO ON dbo.LOG_HISTORY.LOG_USER_ID = dbo.USER_INFO.USER_ID