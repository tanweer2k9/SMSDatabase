CREATE PROC [dbo].[sp_AUTO_DATABASE_BACKUP]

@db_name NVARCHAR(50),
@path NVARCHAR(500)

AS


--DECLARE @name VARCHAR(50) -- database name  
--DECLARE @path VARCHAR(256) -- path for backup files  


BACKUP DATABASE @db_name TO DISK = @path