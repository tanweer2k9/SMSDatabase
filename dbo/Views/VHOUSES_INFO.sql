CREATE VIEW [dbo].[VHOUSES_INFO]
AS
SELECT        HOUSES_ID AS ID, HOUSES_HD_ID AS [Institute ID], HOUSES_BR_ID AS [Branch ID], HOUSES_NAME AS Name, HOUSES_DESC AS Description, 
                         HOUSES_STATUS AS Status
FROM            dbo.HOUSES_INFO