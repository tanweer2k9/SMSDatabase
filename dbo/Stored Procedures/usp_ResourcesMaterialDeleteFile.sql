CREATE PROC usp_ResourcesMaterialDeleteFile

@FileId bigint

AS

delete from ResourcesMaterialFiles where Id = @FileId

delete from ResourcesMaterialUserAccess where FileId = @FileId